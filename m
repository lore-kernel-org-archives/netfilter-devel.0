From: "Vink, Ronald" <ronald.vink@boskalis.com>
Subject: UNSUBSCIBE
Date: Mon, 9 Jan 2017 06:51:54 +0000
Message-ID: <AM3PR04MB1218B8C62DE756BA240CB13799640@AM3PR04MB1218.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "netfilter@vger.kernel.org" <netfilter@vger.kernel.org>,
        "netfilter-announce@lists.netfilter.org"
        <netfilter-announce@lists.netfilter.org>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-eopbgr40076.outbound.protection.outlook.com ([40.107.4.76]:63883
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758057AbdAIGv7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Jan 2017 01:51:59 -0500
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



-----Original Message-----
From: netfilter-announce [mailto:netfilter-announce-bounces@lists.netfilter=
.org] On Behalf Of Pablo Neira Ayuso
Sent: maandag 19 december 2016 23:58
To: netfilter-devel@vger.kernel.org
Cc: lwn@lwn.net; netfilter@vger.kernel.org; netfilter-announce@lists.netfil=
ter.org
Subject: [ANNOUNCE] libnftnl 1.0.7 release

Hi!

The Netfilter project proudly presents:

        libnftnl 1.0.7

libnftnl is a userspace library providing a low-level netlink programming i=
nterface (API) to the in-kernel nf_tables subsystem. The library libnftnl h=
as been previously known as libnftables. This library is currently used by =
the nft command line tool.

This release includes the following list of updates:

* New nftnl_rule_cmp() interface to compare rules.

* Support for new kernel expressions:
 - Number Generator (a.k.a. numgen).
 - Routing (a.k.a. rt).
 - Range.
 - Inverted set lookups.
 - Inverted dynamic set updates (ie. rule mismatch on full sets).
 - Packet quota.
 - Hash.
 - Forward Information Base lookups (a.k.a. fib).
 - Reference to stateful objects (requires kernel 4.10-rc).
 - Notrack.

* Allow to add userdata to sets.

* Support for stateful objects, including quota and counter (requires
  kernel 4.10-rc).

* Support for layer 4 pseudoheader fields checksum updates (requires
  kernel 4.10-rc).

  ... and fixes.

You can download this library from:

http://www.netfilter.org/projects/libnftnl/downloads.html
ftp://ftp.netfilter.org/pub/libnftnl/

Thanks!
