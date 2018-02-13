From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_nat: range size must be at least 1
Date: Tue, 13 Feb 2018 01:45:53 +0100
Message-ID: <20180213004553.20083-1-fw@strlen.de>
References: <001a114528768857060565072942@google.com>
Cc: syzkaller-bugs@googlegroups.com, Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35302 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932736AbeBMAux (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Feb 2018 19:50:53 -0500
In-Reply-To: <001a114528768857060565072942@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 divide error: 0000 [#1] SMP KASAN
 RIP: 0010:nf_nat_l4proto_unique_tuple+0x291/0x530
 net/netfilter/nf_nat_proto_common.c:88

looks like a day 0 bug.
Avoid this by forcing a min_range of 1.

Reported-by: <syzbot+8012e198bd037f4871e5@syzkaller.appspotmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_nat_proto_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_nat_proto_common.c b/net/netfilter/nf_nat_proto_common.c
index fbce552a796e..2d1fc3722ed2 100644
--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -72,6 +72,8 @@ void nf_nat_l4proto_unique_tuple(const struct nf_nat_l3proto *l3proto,
 	} else {
 		min = ntohs(range->min_proto.all);
 		range_size = ntohs(range->max_proto.all) - min + 1;
+		if (range_size == 0)
+			range_size = 1;
 	}
 
 	if (range->flags & NF_NAT_RANGE_PROTO_RANDOM) {
-- 
2.13.6

