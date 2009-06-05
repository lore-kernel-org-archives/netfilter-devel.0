From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/3] netfilter: MASQUERADE: remove redundant rwlock
Date: Fri,  5 Jun 2009 03:15:42 +0200
Message-ID: <1244164542-10739-4-git-send-email-fw@strlen.de>
References: <1244164542-10739-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48520 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752817AbZFEBKx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 21:10:53 -0400
In-Reply-To: <1244164542-10739-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The lock "protects" an assignment and a comparision of an integer.
When the caller of device_cmp() evaluates the result, nat->masq_index
may already have been changed (regardless if the lock is there or not).

So, the lock either has to be held during nf_ct_iterate_cleanup(),
or can be removed.

This does the latter.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/ipt_MASQUERADE.c |   12 +-----------
 1 files changed, 1 insertions(+), 11 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index f389f60..855505d 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -27,9 +27,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
 
-/* Lock protects masq region inside conntrack */
-static DEFINE_RWLOCK(masq_lock);
-
 /* FIXME: Multiple targets. --RR */
 static bool masquerade_tg_check(const struct xt_tgchk_param *par)
 {
@@ -79,9 +76,7 @@ masquerade_tg(struct sk_buff *skb, const struct xt_target_param *par)
 		return NF_DROP;
 	}
 
-	write_lock_bh(&masq_lock);
 	nat->masq_index = par->out->ifindex;
-	write_unlock_bh(&masq_lock);
 
 	/* Transfer from original range. */
 	newrange = ((struct nf_nat_range)
@@ -97,16 +92,11 @@ static int
 device_cmp(struct nf_conn *i, void *ifindex)
 {
 	const struct nf_conn_nat *nat = nfct_nat(i);
-	int ret;
 
 	if (!nat)
 		return 0;
 
-	read_lock_bh(&masq_lock);
-	ret = (nat->masq_index == (int)(long)ifindex);
-	read_unlock_bh(&masq_lock);
-
-	return ret;
+	return nat->masq_index == (int)(long)ifindex;
 }
 
 static int masq_device_event(struct notifier_block *this,
-- 
1.6.0.6

