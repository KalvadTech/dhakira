# Dhakira

Dhakira is an opiniated in-memory web server in Crystal, with a special emphasis towards SPA hosting!

## Explanation

For long time, we have been working with SPAs, and what were the solutions to deploy SPAs? NGiNX or Apache.

Even if both are great tools, for hosting only some basic websites, they were slow and not very easy to configure, especially if you want to embed them into some containers.

What we did is to rework what we wanted as a webserver:

- should be able to host "standard" websites and SPAs
- should be easy to configure
- should be very performant and load everything in-memory

Once we had our requirements, we started to discuss about it with some of Kalvad's Team member, and we came with a first implementation, in Crystal.

Crystal is like a compiled Ruby, backed by LLVM.

## How does it work?

``` mermaidjs
graph TD
    A[Launch Dhakira] --> B(Check if ./dhakira_html folder exists)
    B -->|No| Z[Error]
    B -->|Yes| C(Check if we have some websites or spas configured)
    C --> D[Does the folder ./dhakira_html/spas or ./dhakira_html/websites exists?]
    D -->|Yes| G[Check every folder, load every file in memory, with the associated mime-type]
    D -->|No| Z
    G -->H[Launch Webserver]
```


## Installation

Download the latest release on github, or compile it with ```shards build --static --no-debug --release --production -v```

## Usage

``` 
./dhakira -h
    -b HOST, --bind HOST             Host to bind (defaults to 0.0.0.0)
    -p PORT, --port PORT             Port to listen for connections (defaults to 3000)
    -s, --ssl                        Enables SSL
    --ssl-key-file FILE              SSL key file
    --ssl-cert-file FILE             SSL certificate file
    -h, --help                       Shows this help

```


## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/your-github-user/dhakira/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Loïc Tosser](https://github.com/wowi42) - creator and maintainer
