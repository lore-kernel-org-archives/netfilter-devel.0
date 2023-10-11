Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDA8ECD98FB
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Oct 2023 08:00:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjJKIAK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Oct 2023 04:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbjJKIAJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Oct 2023 04:00:09 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDBAB9D
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Oct 2023 01:00:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qqU8U-0006ue-KI; Wed, 11 Oct 2023 10:00:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/6] netfilter: conntrack: convert nf_conntrack_update to netfilter verdicts
Date:   Wed, 11 Oct 2023 09:59:36 +0200
Message-ID: <20231011075944.2301-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231011075944.2301-1-fw@strlen.de>
References: <20231011075944.2301-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This function calls helpers that can return nf-verdicts, but then
those get converted to -1/0 as thats what the caller expects.

Theoretically NF_DROP could have an errno number set in the upper 24
bits of the return value. Or any of those helpers could return
NF_STOLEN, which would result in use-after-free.

This is fine as-is, the called functions don't do this yet.

But its better to avoid possible future problems if the upcoming
patchset to add NF_DROP_REASON() support gains further users, so remove
the 0/-1 translation from the picture and pass the verdicts down to
the caller.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_conntrack_core.c | 58 ++++++++++++++++++-------------
 net/netfilter/nfnetlink_queue.c   | 15 ++++----
 2 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 124136b5a79a..2e5f3864d353 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2169,11 +2169,11 @@ static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
 
 	dataoff = get_l4proto(skb, skb_network_offset(skb), l3num, &l4num);
 	if (dataoff <= 0)
-		return -1;
+		return NF_DROP;
 
 	if (!nf_ct_get_tuple(skb, skb_network_offset(skb), dataoff, l3num,
 			     l4num, net, &tuple))
-		return -1;
+		return NF_DROP;
 
 	if (ct->status & IPS_SRC_NAT) {
 		memcpy(tuple.src.u3.all,
@@ -2193,7 +2193,7 @@ static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
 
 	h = nf_conntrack_find_get(net, nf_ct_zone(ct), &tuple);
 	if (!h)
-		return 0;
+		return NF_ACCEPT;
 
 	/* Store status bits of the conntrack that is clashing to re-do NAT
 	 * mangling according to what it has been done already to this packet.
@@ -2206,19 +2206,25 @@ static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
 
 	nat_hook = rcu_dereference(nf_nat_hook);
 	if (!nat_hook)
-		return 0;
+		return NF_ACCEPT;
 
-	if (status & IPS_SRC_NAT &&
-	    nat_hook->manip_pkt(skb, ct, NF_NAT_MANIP_SRC,
-				IP_CT_DIR_ORIGINAL) == NF_DROP)
-		return -1;
+	if (status & IPS_SRC_NAT) {
+		unsigned int verdict = nat_hook->manip_pkt(skb, ct,
+							   NF_NAT_MANIP_SRC,
+							   IP_CT_DIR_ORIGINAL);
+		if (verdict != NF_ACCEPT)
+			return verdict;
+	}
 
-	if (status & IPS_DST_NAT &&
-	    nat_hook->manip_pkt(skb, ct, NF_NAT_MANIP_DST,
-				IP_CT_DIR_ORIGINAL) == NF_DROP)
-		return -1;
+	if (status & IPS_DST_NAT) {
+		unsigned int verdict = nat_hook->manip_pkt(skb, ct,
+							   NF_NAT_MANIP_DST,
+							   IP_CT_DIR_ORIGINAL);
+		if (verdict != NF_ACCEPT)
+			return verdict;
+	}
 
-	return 0;
+	return NF_ACCEPT;
 }
 
 /* This packet is coming from userspace via nf_queue, complete the packet
@@ -2233,14 +2239,14 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 
 	help = nfct_help(ct);
 	if (!help)
-		return 0;
+		return NF_ACCEPT;
 
 	helper = rcu_dereference(help->helper);
 	if (!helper)
-		return 0;
+		return NF_ACCEPT;
 
 	if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
-		return 0;
+		return NF_ACCEPT;
 
 	switch (nf_ct_l3num(ct)) {
 	case NFPROTO_IPV4:
@@ -2255,42 +2261,44 @@ static int nf_confirm_cthelper(struct sk_buff *skb, struct nf_conn *ct,
 		protoff = ipv6_skip_exthdr(skb, sizeof(struct ipv6hdr), &pnum,
 					   &frag_off);
 		if (protoff < 0 || (frag_off & htons(~0x7)) != 0)
-			return 0;
+			return NF_ACCEPT;
 		break;
 	}
 #endif
 	default:
-		return 0;
+		return NF_ACCEPT;
 	}
 
 	if (test_bit(IPS_SEQ_ADJUST_BIT, &ct->status) &&
 	    !nf_is_loopback_packet(skb)) {
 		if (!nf_ct_seq_adjust(skb, ct, ctinfo, protoff)) {
 			NF_CT_STAT_INC_ATOMIC(nf_ct_net(ct), drop);
-			return -1;
+			return NF_DROP;
 		}
 	}
 
 	/* We've seen it coming out the other side: confirm it */
-	return nf_conntrack_confirm(skb) == NF_DROP ? - 1 : 0;
+	return nf_conntrack_confirm(skb);
 }
 
 static int nf_conntrack_update(struct net *net, struct sk_buff *skb)
 {
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
-	int err;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct)
-		return 0;
+		return NF_ACCEPT;
 
 	if (!nf_ct_is_confirmed(ct)) {
-		err = __nf_conntrack_update(net, skb, ct, ctinfo);
-		if (err < 0)
-			return err;
+		int ret = __nf_conntrack_update(net, skb, ct, ctinfo);
+
+		if (ret != NF_ACCEPT)
+			return ret;
 
 		ct = nf_ct_get(skb, &ctinfo);
+		if (!ct)
+			return NF_ACCEPT;
 	}
 
 	return nf_confirm_cthelper(skb, ct, ctinfo);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 556bc902af00..171d1f52d3dd 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -228,19 +228,22 @@ find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
 	const struct nf_ct_hook *ct_hook;
-	int err;
 
 	if (verdict == NF_ACCEPT ||
 	    verdict == NF_REPEAT ||
 	    verdict == NF_STOP) {
 		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
-		if (ct_hook) {
-			err = ct_hook->update(entry->state.net, entry->skb);
-			if (err < 0)
-				verdict = NF_DROP;
-		}
+		if (ct_hook)
+			verdict = ct_hook->update(entry->state.net, entry->skb);
 		rcu_read_unlock();
+
+		switch (verdict & NF_VERDICT_MASK) {
+		case NF_STOLEN:
+			nf_queue_entry_free(entry);
+			return;
+		}
+
 	}
 	nf_reinject(entry, verdict);
 }
-- 
2.41.0

