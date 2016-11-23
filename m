From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_fib_ipv4: initialize *dest to zero
Date: Wed, 23 Nov 2016 22:12:21 +0800
Message-ID: <1479910341-40744-2-git-send-email-zlpnobody@163.com>
References: <1479910341-40744-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:35820 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935052AbcKWONP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2016 09:13:15 -0500
In-Reply-To: <1479910341-40744-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Otherwise, if fib lookup fail, *dest will be filled with garbage value,
so reverse path filtering will not work properly:
 # nft add rule x prerouting fib saddr oif eq 0 drop

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/ipv4/netfilter/nft_fib_ipv4.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/netfilter/nft_fib_ipv4.c b/net/ipv4/netfilter/nft_fib_ipv4.c
index bfffa74..2581363 100644
--- a/net/ipv4/netfilter/nft_fib_ipv4.c
+++ b/net/ipv4/netfilter/nft_fib_ipv4.c
@@ -122,6 +122,8 @@ void nft_fib4_eval(const struct nft_expr *expr, struct nft_regs *regs,
 		fl4.saddr = get_saddr(iph->daddr);
 	}
 
+	*dest = 0;
+
 	if (fib_lookup(nft_net(pkt), &fl4, &res, FIB_LOOKUP_IGNORE_LINKSTATE))
 		return;
 
-- 
2.5.5


