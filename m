From: "Vink, Ronald" <ronald.vink@boskalis.com>
Subject: RE: [ANNOUNCE] libnftnl 1.0.6 release
Date: Mon, 13 Jun 2016 09:23:50 +0000
Message-ID: <DB5PR04MB1224BDE0A3161F753134F57299530@DB5PR04MB1224.eurprd04.prod.outlook.com>
References: <20160530105545.GA16431@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "lwn@lwn.net" <lwn@lwn.net>,
	"netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
	"netfilter-announce@lists.netfilter.org"
	<netfilter-announce@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20160530105545.GA16431@salvia>
Content-Language: en-US
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Unsubscribe


-----Original Message-----
From: netfilter-announce [mailto:netfilter-announce-bounces@lists.netfilter.org] On Behalf Of Pablo Neira Ayuso
Sent: maandag 30 mei 2016 12:56
To: netfilter-devel@vger.kernel.org
Cc: lwn@lwn.net; netfilter@vger.kernel.org; netfilter-announce@lists.netfilter.org
Subject: [ANNOUNCE] libnftnl 1.0.6 release

Hi!

The Netfilter project proudly presents:

        libnftnl 1.0.6

libnftnl is a userspace library providing a low-level netlink programming interface (API) to the in-kernel nf_tables subsystem. The library libnftnl has been previously known as libnftables. This library is currently used by the nft command line tool.

This release includes the following list of updates:

* New TLV infrastructure for user data are in rule, set and elements.
* Support for the new tracing infrastructure.
* Matching of ct bytes and packets.
* meta prandom support.
* Enhancements for the limit expressions.
* Support for payload mangling.
* Masquerading port range selection.
  ... and fixes.

You can download this library from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Enjoy this new release and help us testing, thanks!

