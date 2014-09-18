From: Ana Rey <anarey@gmail.com>
Subject: [v3 nft 0/7] tests: Automated regression testing
Date: Thu, 18 Sep 2014 12:39:14 +0200
Message-ID: <1411036761-26825-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:44586 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755987AbaIRKhA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2014 06:37:00 -0400
Received: by mail-we0-f173.google.com with SMTP id t60so671733wes.32
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Sep 2014 03:36:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a new version of the automated regression testing of nftables.

There is no infrastructure to allow us to check all options/features in
nft. So, if anyone sends a patch, we cannot check if it breaks something.

I send in this patchset the nftables automated regression tests. It
contains a python script (nft-add.py) and a set of test files.

This allow us to check the input of rules of nft-tool from the
command-line and the output from nft-tool of this rule. Then, it
compares if the rule input matches the rule output automatically.

We also have plans to add automated regression testing in the packet
path in the future, which should come in a follow up step.

Comments welcome, thanks

[Changes in v3]
 * I fix signal handlers when press ctrl + c repeatedly.
 * I add the output_clean function. This function improves the parser of
   rules is shown by nft.


Ana Rey (7):
  tests: Add automated regression testing
  tests: Add ip folder with test files
  tests: Add ip6 folder with test files.
  tests: Add inet folder with test files.
  tests: Add arp folder with test files.
  tests: Add bridge folder with test files.
  tests: Add any folder with test files.

 tests/regression/any/ct.t        |  105 +++++
 tests/regression/any/frag.t      |   64 +++
 tests/regression/any/limit.t     |   12 +
 tests/regression/any/log.t       |   27 ++
 tests/regression/any/meta.t      |  160 +++++++
 tests/regression/any/queue.t     |   15 +
 tests/regression/arp/arp.t       |   53 +++
 tests/regression/arp/chains.t    |    5 +
 tests/regression/bridge/chains.t |    7 +
 tests/regression/inet/ah.t       |   58 +++
 tests/regression/inet/comp.t     |   31 ++
 tests/regression/inet/dccp.t     |   32 ++
 tests/regression/inet/esp.t      |   23 +
 tests/regression/inet/sctp.t     |   42 ++
 tests/regression/inet/tcp.t      |  103 +++++
 tests/regression/inet/udp.t      |   49 +++
 tests/regression/inet/udplite.t  |   42 ++
 tests/regression/ip/chains.t     |   22 +
 tests/regression/ip/icmp.t       |   93 +++++
 tests/regression/ip/ip.t         |  107 +++++
 tests/regression/ip/nat.t        |   18 +
 tests/regression/ip/reject.t     |    5 +
 tests/regression/ip/sets.t       |   31 ++
 tests/regression/ip6/chains.t    |   18 +
 tests/regression/ip6/dst.t       |   25 ++
 tests/regression/ip6/hbh.t       |   25 ++
 tests/regression/ip6/icmpv6.t    |   96 +++++
 tests/regression/ip6/ip6.t       |  142 +++++++
 tests/regression/ip6/mh.t        |   49 +++
 tests/regression/ip6/nat.t       |    6 +
 tests/regression/ip6/reject.t    |    5 +
 tests/regression/ip6/rt.t        |   45 ++
 tests/regression/ip6/sets.t      |   22 +
 tests/regression/ip6/vmap.t      |   54 +++
 tests/regression/nft-test.py     |  859 ++++++++++++++++++++++++++++++++++++++
 35 files changed, 2450 insertions(+)
 create mode 100644 tests/regression/any/ct.t
 create mode 100644 tests/regression/any/frag.t
 create mode 100644 tests/regression/any/limit.t
 create mode 100644 tests/regression/any/log.t
 create mode 100644 tests/regression/any/meta.t
 create mode 100644 tests/regression/any/queue.t
 create mode 100644 tests/regression/arp/arp.t
 create mode 100644 tests/regression/arp/chains.t
 create mode 100644 tests/regression/bridge/chains.t
 create mode 100644 tests/regression/inet/ah.t
 create mode 100644 tests/regression/inet/comp.t
 create mode 100644 tests/regression/inet/dccp.t
 create mode 100644 tests/regression/inet/esp.t
 create mode 100644 tests/regression/inet/sctp.t
 create mode 100644 tests/regression/inet/tcp.t
 create mode 100644 tests/regression/inet/udp.t
 create mode 100644 tests/regression/inet/udplite.t
 create mode 100644 tests/regression/ip/chains.t
 create mode 100644 tests/regression/ip/icmp.t
 create mode 100644 tests/regression/ip/ip.t
 create mode 100644 tests/regression/ip/nat.t
 create mode 100644 tests/regression/ip/reject.t
 create mode 100644 tests/regression/ip/sets.t
 create mode 100644 tests/regression/ip6/chains.t
 create mode 100644 tests/regression/ip6/dst.t
 create mode 100644 tests/regression/ip6/hbh.t
 create mode 100644 tests/regression/ip6/icmpv6.t
 create mode 100644 tests/regression/ip6/ip6.t
 create mode 100644 tests/regression/ip6/mh.t
 create mode 100644 tests/regression/ip6/nat.t
 create mode 100644 tests/regression/ip6/reject.t
 create mode 100644 tests/regression/ip6/rt.t
 create mode 100644 tests/regression/ip6/sets.t
 create mode 100644 tests/regression/ip6/vmap.t
 create mode 100755 tests/regression/nft-test.py

-- 
1.7.10.4

