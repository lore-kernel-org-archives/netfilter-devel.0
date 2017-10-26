From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 0/8] rework dependency removal
Date: Fri, 27 Oct 2017 01:06:03 +0200
Message-ID: <20171026230611.14269-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59752 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751305AbdJZXF4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Oct 2017 19:05:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series resolves a few shortcomings with the current dependency
removal.

Problem is that the current approach sometimes can remove dependencies
that are required, i.e. where the removal does change the rule.

Examples:
inet t .. meta nfproto ipv6 tcp dport 22 or
inet t .. ip protocol tcp tcp dport 22
are reduced to 'tcp dport 22'.
ip6 nexthdr icmpv6 icmpv6 type echo-request
becomes 'ipv6 type echo-request' (which is not exactly the same,
the implicit dependency nft adds is 'meta l4proto', which skips
most extension headers).

I already pushed a couple of test cases to increase coverage.

These patches aim to fix those by making dependency removal more
strict.

The additional checks are only done in families other than ip and ipv6,
as those are already restricted to a particular l3 protocol.


 include/payload.h         |   14 +-
 include/utils.h           |    1 
 src/netlink.c             |   11 --
 src/netlink_delinearize.c |   27 +----
 src/payload.c             |  224 +++++++++++++++++++++++++++++++++++++++++-----
 tests/py/bridge/icmpX.t   |    4 
 tests/py/inet/icmpX.t     |    4 
 tests/py/inet/ip_tcp.t    |    4 
 8 files changed, 224 insertions(+), 65 deletions(-)

