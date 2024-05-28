const { Octokit } = require("@octokit/core");
const fs = require("fs");
const dateFormat = require('date-and-time')

//
// 1.) Retrieve all parameters from the environment.
// The corresponding environment variables are defined
// in the job.

// If the GITHUB_TOKEN is a basic auth credential, the
// user and password are exposed with a trailing
// '_user' and '_password'.
var githubToken = process.env.GITHUB_TOKEN_password;
var releaseNamePrefix = process.env.RELEASE_NAME_PREFIX;
var releaseTagPrefix = process.env.RELEASE_TAG_PREFIX;
var additionalAssetLabel = process.env.ADDITIONAL_ASSET_LABEL

// CLOUDCI_GIT_COMMIT is not defined as additional environment variable
// for the stage. CLOUDCI_GIT_COMMIT is always injected into the environment
// for run-first and run-last commands.
var targetCommitish = process.env.CLOUDCI_GIT_COMMIT;

// We expect the additional asset in the transfer folder one folder level above,
// since the script is launched from a subfolder.
var additionalAssetName = `../${process.env.ADDITIONAL_ASSET_PATH}`;

//
// 2.) Use a suitable stategy for release suffixes
// to ensure that the same release does not already exist. A simple and
// straight-forward approach is to use a time stamp.
var releaseSuffix = dateFormat.format(new Date(), 'YYYY-MM-DD-HH-mm-ss')

// 1: protocol
// 2: host
// 3: owner
// 4: repo
var gitRepoUrlParts = process.env.GIT_URL.match(/(.*):\/\/(.*)\/(.*)\/([^\.]*)(\.git)?$/)

console.log(process.env.GIT_URL);
console.log(gitRepoUrlParts);


var githubApiUrl=`${gitRepoUrlParts[1]}://${gitRepoUrlParts[2]}/api/v3/`
var owner=gitRepoUrlParts[3]
var repo=gitRepoUrlParts[4]

//
// 3.) Define the client for communicating with the GitHub-API.
const octokit = new Octokit({
  auth: githubToken,
  baseUrl: githubApiUrl,
});


//
// 4.) Create the GitHub release.
octokit
  .request("POST repos/{owner}/{repo}/releases", {
    owner: owner,
    repo: repo,
    target_commitish: targetCommitish,
    tag_name: `${releaseTagPrefix}${releaseSuffix}`,
    name: `${releaseNamePrefix}-${releaseSuffix}`,
    draft: false,
    prerelease: false,
    generate_release_notes: false,
  })
  .then((res) => {
    // response status code check not required. In case of an issue octokit throws an error
    console.log(`Release created: status: '${res.status}', url: '${res.data.html_url}'`)

    //
    // 5.) ... and we attach the additional asset
    octokit.request(`POST ${res.data.upload_url}`, {
      name: additionalAssetName,
      label: additionalAssetLabel,
      data: fs.readFileSync(additionalAssetName),
    });

    console.log(`additional asset "${additionalAssetName}" uploaded`)
  })