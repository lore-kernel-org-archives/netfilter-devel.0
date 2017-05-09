From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 00/10] switch l4 dependency to meta l4proto
Date: Tue,  9 May 2017 17:51:12 +0200
Message-ID: <20170509155122.26356-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44544 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755579AbdEIPvF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 11:51:05 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently nft inserts different types of dependencies for l4 protocols,
depending on the family.

For inet, nft inserts 'meta l4proto' to e.g. check for tcp.
For ip, nft uses 'ip protocol' instead.
For ipv6, 'ip6 nexthdr' is used.

And the latter is a problem, because this means that
'tcp dport 22' will only match tcp packets that do not have a ipv6 extension
header.

This first switches implicit ipv6 dependency to 'meta l4proto', so
the last transport header protocol will be considered instead of the
first ipv6 nexthdr value.

For ip, this problem doesn't exist, however, since it makes things
a bit simpler when nft creates the same l4 dependency for ip/ip6/inet/bridge
and so on the later patches in this series will also switch ipv4 over to
meta expression.

 src/evaluate.c            |    8 ++++++++
 src/netlink_delinearize.c |    6 ++++++
 src/payload.c             |   24 +++++++++++++++++++++++-
 src/proto.c               |    6 ++++--
 4 files changed, 41 insertions(+), 3 deletions(-)

[ diffstat exludes test/ intentionally.
  Also, last patch uses -C mode to avoid a huge 7000 line diff.  ]
