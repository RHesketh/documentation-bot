## Synopsis

At the top of the file there should be a short introduction and/ or overview that explains **what** the project is. This description should match descriptions added for package managers (Gemspec, package.json, etc.)

## Installation

DocumentationBot requires Ruby version 2.2.2. The easiest way to install Ruby is using a Ruby environment manager such as [RVM](http://rvm.io) or [rbenv](https://github.com/rbenv/rbenv), but the bot should work with any properly installed Ruby of the correct version.

Once Ruby has been installed, the project can be setup into an initial working state by using the following command:

`script/setup`

## Usage
To start the bot, type:

`script/start`

**Note:** To start the bot you must provide a Slack API token. This can be done through the SLACK_API_TOKEN environment variable, e.g.

`SLACK_API_TOKEN=abcd-1234567890-aBCDeFG script/start`

Alternatively you can put the API token into a file named `slack_api_token` in the `config` directory. There is a file named `config/slack_api_token.example` which shows how this file should be formatted.

## Tests

Describe and show how to run the tests with code examples.

## Contributors

Let people know how they can dive into the project, include important links to things like issue trackers, irc, twitter accounts if applicable.

## License

A short snippet describing the license (MIT, Apache, etc.)
