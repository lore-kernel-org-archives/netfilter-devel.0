Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789467;
	b=GRYYVntQeCW1bYptJe57Wd3xHHdIwG+qULEF/HR4HerYSJ1ZnM/rOvX/auwQjvDVp11L
	 ir+J0m6eoQln0lGZpisCDHqssH2Tf1VbzR5uyFCpKrFoEcuPjyxhtrA9Fl2GlQJoZHrHW
	 i7Uq8yS6NyWDgZAttYtYhSBRm6ZK4HgXPULUWWA1quADeLw845hZ8OOT8WoAvfL7bYzYB
	 mMPLyySdO1Jrc75NOmtkcIGpUmJJDRKNqRlLIZtBRm+j/GzkkTyZgHlyvCS4J+JsjrI/u
	 1dzcdkM94X7eJ5FeTYjTrLidfaYAmSyh/PDv4KsMNzfLgSV2ugHnWvBRi1IbkOiB+AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789467;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=YXjMNPBIs81jsvfjPCmsnFds016p5XXPf1faKWCguKE=;
	b=K3ffFz3u4zfuptE62eLpTKhP0yO8gHFYmc4QA68WDhFz6IEHqxlX+W+iz9JV9AzE/2II
	 atK/xQhTX577s997S7pWHs8ZiA0/dntMvxLHVoIVPq/7eJWFR1WX72le30WoCBerrRCfb
	 xvaz9Oy1VW7scG1eb5DcQNxm10isRN4bwLSJKwzELNguMsJYuSsh1siZpl32oR1wiFoOz
	 c3r/9hIPN4hlc284wEEiVj4OAC9ChUuFH828hcGvVC0tZcMNahXf/2LGj7Bz6WiLXDTg+
	 tBsoWa343Smvxgex7X0yz8crI6jJWX1B497dP3feUIMyKYxj9oUPLnuXDHucNE2GQnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=U74qGIIK;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC863606A332
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:37:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC863606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=U74qGIIK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789465;
	bh=YXjMNPBIs81jsvfjPCmsnFds016p5XXPf1faKWCguKE=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=U74qGIIKJas7QglpLNL9MksPKoOGt245UiMonbr6JDt/iDEGwAd4lA9c+eiJhmYHQ
	 bhx1PSoXSDIto18bdvz/kP43OvQusnseitq/qyR3v/Gy5DsAHPIAPUf8QJrLvnzTdq
	 b/HiE9DzliZn2lpm2XQP1yV82Kg1R5j1ybp8XKF/pk+9TippONohrClPxkf97s8VGN
	 wDnaMHOEVOGFB1Vgv2vT57DgEzl46RABo4DZjaBLWE2UXQC/kSmdin153eye7VFWwm
	 RMLtDy+00W+vngVEYGbLFejnkm93CjMUfgxp31iWcCO4e5S/H7IIy7KpQ+rnL2+fi5
	 uIcH9UQYrHjfA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 028EF60077
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:37:44 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v8 7/7] netfilter: nfnetlink_queue: do not skip ct confirmation with userspace ct helpers
Date: Mon, 16 Nov 2026 01:37:33 +0100
Message-ID: <20261116003733.2820132-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116003733.2820132-1-pablo@netfilter.org>
References: <20261116003733.2820132-1-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There are a two more issues with the existing userspace ct helpers:

- Disallow re-queueing packets in userspace ct helpers, none of the
  existing helper in userspace use this feature.

- nf_conntrack_update() should only be called if this is the confirmation
  hook, there is a new helper function to check this, use it.

While at this, nfqnl_reinject() is already called from a rcu read lock
section, remove the redundant rcu_read_{un,lock}().

Remove #ifdef around nfqnl_hook_exp_support() so this function can be
used regardless conntrack supported to address a compilation warning.

Fixes: ee04805ff54a ("netfilter: conntrack: make conntrack userspace helpers work again")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v8: no changes

 net/netfilter/nfnetlink_queue.c | 37 ++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c52ac4a3dd80..1f6d7d25881d 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -381,7 +381,6 @@ nf_queue_hook_entry(const struct nf_hook_entries *hooks,
 	return &hooks->hooks[i];
 }
 
-#if IS_ENABLED(CONFIG_NF_CONNTRACK)
 static bool nfqnl_hook_exp_support(const struct nf_hook_ops *ops)
 {
 	return (ops->hook_ops_type == NF_HOOK_OP_CONNTRACK &&
@@ -392,7 +391,6 @@ static bool nfqnl_hook_exp_support(const struct nf_hook_ops *ops)
 		 (ops->pf == NFPROTO_BRIDGE &&
 		  ops->hooknum == NF_BR_POST_ROUTING)));
 }
-#endif
 
 /* caller must hold rcu read-side lock */
 static void nf_reinject(struct nf_queue_entry *entry,
@@ -528,31 +526,38 @@ static void __nfqnl_reinject(struct nf_queue_entry *entry,
 			     const struct nf_hook_ops *hook,
 			     unsigned int verdict)
 {
-	const struct nf_ct_hook *ct_hook;
+	unsigned int verdict_mask = verdict & NF_VERDICT_MASK;
 
 	if (!nf_bridge_ports_valid(entry))
-		verdict = NF_DROP;
+		goto drop;
 
-	if (verdict == NF_ACCEPT ||
-	    verdict == NF_REPEAT ||
-	    verdict == NF_STOP) {
-		unsigned int ct_verdict = verdict;
+	if (verdict_mask == NF_ACCEPT ||
+	    verdict_mask == NF_REPEAT ||
+	    verdict_mask == NF_STOP ||
+	    verdict_mask == NF_QUEUE) {
+		const struct nf_ct_hook *ct_hook;
 
-		rcu_read_lock();
 		ct_hook = rcu_dereference(nf_ct_hook);
-		if (ct_hook)
-			ct_verdict = ct_hook->update(entry->state.net, entry->skb);
-		rcu_read_unlock();
+		if (ct_hook && nfqnl_hook_exp_support(hook)) {
+			if (verdict_mask == NF_QUEUE ||
+			    verdict_mask == NF_REPEAT)
+				goto drop;
+
+			verdict_mask = ct_hook->update(entry->state.net, entry->skb);
+		}
 
-		switch (ct_verdict & NF_VERDICT_MASK) {
+		switch (verdict_mask) {
 		case NF_ACCEPT:
 			/* follow userspace verdict, could be REPEAT */
 			break;
 		case NF_STOLEN:
 			nf_queue_entry_free(entry);
 			return;
+		case NF_QUEUE:
+			/* follow userspace verdict too */
+			break;
 		default:
-			verdict = ct_verdict & NF_VERDICT_MASK;
+			verdict = verdict_mask;
 			break;
 		}
 	}
@@ -574,6 +579,10 @@ static void __nfqnl_reinject(struct nf_queue_entry *entry,
 			verdict = NF_DROP;
 	}
 	nf_reinject(entry, hook_entries, hook, verdict);
+	return;
+drop:
+	kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+	nf_queue_entry_free(entry);
 }
 
 static void nfqnl_reinject(struct nf_queue_entry *entry,
-- 
2.47.3

