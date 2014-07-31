From: Ana Rey <anarey@gmail.com>
Subject: [PATCH 0/6] tests: Automated regression testing
Date: Thu, 31 Jul 2014 11:08:05 +0200
Message-ID: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:60549 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932239AbaGaJI1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:08:27 -0400
Received: by mail-wg0-f43.google.com with SMTP id l18so2403383wgh.2
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 02:08:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is the automated regression testing of nftables.

In all development is important to have a good system to let us
check all features in our tools automatically. In nftables, there is
not an automated tests to check it so far.

There is not system to let us check all options/features in nft. So,
If anyone sends a patch, we can not check all nft-tool automatically.
It's impossible check if anything is broken, or if a change adds a fail
in the system, or fix a problem in all cases.

I send in this patchset the nftables automated regression tests. It
contains a python script (nft-add.py) and a set of test files.

This let us check the input of rules of nft-tool from the command-line
and the output from nft-tool of this rule. Then, It compares if the
rule input matches the rule output automatically. And, the most
important things: It do it automatically.

We also have plans to add automated regression testing in the packet
path in the future, which should come in a follow up step.

Comments welcome, thanks

Ana Rey (6):
  [nft] tests: Add Automated regression testing
  [nft] tests: Add ip6 folder with test files.
  [nft] tests: Add inet folder with test files.
  [nft] tests: Add any folder with test files.
  [nft] tests: Add arp folder with test files.
  [nft] tests: Add bridge folder with test files.

 tests/any/ct.t        | 113 +++++++
 tests/any/frag.t      |  69 +++++
 tests/any/limit.t     |  13 +
 tests/any/log.t       |  14 +
 tests/any/meta.t      | 157 ++++++++++
 tests/any/queue.t     |  15 +
 tests/arp/arp.t       |  58 ++++
 tests/arp/chains.t    |   5 +
 tests/bridge/chains.t |   8 +
 tests/inet/ah.t       |  63 ++++
 tests/inet/comp.t     |  31 ++
 tests/inet/dccp.t     |  31 ++
 tests/inet/esp.t      |  23 ++
 tests/inet/sctp.t     |  42 +++
 tests/inet/tcp.t      | 104 +++++++
 tests/inet/udp.t      |  49 +++
 tests/inet/udplite.t  |  42 +++
 tests/ip/chains.t     |  22 ++
 tests/ip/icmp.t       |  98 ++++++
 tests/ip/ip.t         | 108 +++++++
 tests/ip/nat.t        |  18 ++
 tests/ip/reject.t     |   5 +
 tests/ip/sets.t       |  31 ++
 tests/ip6/chains.t    |  16 +
 tests/ip6/dst.t       |  25 ++
 tests/ip6/hbh.t       |  17 +
 tests/ip6/icmpv6.t    | 115 +++++++
 tests/ip6/ip6.t       | 141 +++++++++
 tests/ip6/mh.t        |  50 +++
 tests/ip6/nat.t       |   8 +
 tests/ip6/reject.t    |   5 +
 tests/ip6/rt.t        |  50 +++
 tests/ip6/sets.t      |  27 ++
 tests/ip6/vmap.t      |  54 ++++
 tests/nft-test.py     | 842 ++++++++++++++++++++++++++++++++++++++++++++++++++
 35 files changed, 2469 insertions(+)
 create mode 100644 tests/any/ct.t
 create mode 100644 tests/any/frag.t
 create mode 100644 tests/any/limit.t
 create mode 100644 tests/any/log.t
 create mode 100644 tests/any/meta.t
 create mode 100644 tests/any/queue.t
 create mode 100644 tests/arp/arp.t
 create mode 100644 tests/arp/chains.t
 create mode 100644 tests/bridge/chains.t
 create mode 100644 tests/inet/ah.t
 create mode 100644 tests/inet/comp.t
 create mode 100644 tests/inet/dccp.t
 create mode 100644 tests/inet/esp.t
 create mode 100644 tests/inet/sctp.t
 create mode 100644 tests/inet/tcp.t
 create mode 100644 tests/inet/udp.t
 create mode 100644 tests/inet/udplite.t
 create mode 100644 tests/ip/chains.t
 create mode 100644 tests/ip/icmp.t
 create mode 100644 tests/ip/ip.t
 create mode 100644 tests/ip/nat.t
 create mode 100644 tests/ip/reject.t
 create mode 100644 tests/ip/sets.t
 create mode 100644 tests/ip6/chains.t
 create mode 100644 tests/ip6/dst.t
 create mode 100644 tests/ip6/hbh.t
 create mode 100644 tests/ip6/icmpv6.t
 create mode 100644 tests/ip6/ip6.t
 create mode 100644 tests/ip6/mh.t
 create mode 100644 tests/ip6/nat.t
 create mode 100644 tests/ip6/reject.t
 create mode 100644 tests/ip6/rt.t
 create mode 100644 tests/ip6/sets.t
 create mode 100644 tests/ip6/vmap.t
 create mode 100755 tests/nft-test.py

-- 
2.0.0

