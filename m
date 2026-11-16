Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826787;
	b=VDK4+lKYjnEEF+qmRzl3gGWjBqJRi8LD0OXfjwO540C8K56mXz7W4wSjm+LCEtgc00Jq
	 LcN2L89nyZIaWL2x9p55qGFGvvGqJnldAItbNEyzUsr1OESuugrVlSBHELLLuPLS+eQ1p
	 jWJijPC5pRm4zvkRJ7QehiPTPPmz7QJ7VECGHps1zZ7FY6nxSifN3u3jRUITCc1Xbon67
	 Ipl+eNWrGNMPt6n7o722t9qhzlqCX5IqkTnyC1ykXuQ5WCCRfHiJ5Q+mXHP/252PBc/Rq
	 /58iyLgLQDKvMIjNIe8UKoKSMT5cC7eYvyYOpDMkhuBkDJ3J/M10qa8JGKGaNN16esQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826787;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=4Z9e64Lzzy4/YqtjZ97NcSgr4gJ9VGrz/7wKLpY3iOs=;
	b=u/y8mGHQ4PBhkZeimlrtJ3/i9a/0zrmJ7uRq0SI2+pxMr9V9WkviYboClTxAvT0diJJd
	 2LnLbSHydatdNOkOoZsLQC3eKCYs6tVkVuV7fjgo3HAbgTrTpF+Hv8NoguHb50oUPrpZP
	 WxOqreSgSRIQGvWc0HmPu6gBiJEx/baM5Q6TXDzmoi7n2WdXEITbQ9QgfmcEeewZsFdeo
	 w2PYKots6a1cQ5CGpiUXalFLXgHaQpVAsc6sE0ratCD2N0MIxPG0EcWdZaB+RX0a7oVTf
	 TaQk7yS3VeiqoqE0Xx7EElpvy0m+yOGtVFRQ5PSm/99RitB2qHLrXrQFtHcBBFagsTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mAaYqlaQ;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CC2606A330
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0CC2606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=mAaYqlaQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794826784;
	bh=4Z9e64Lzzy4/YqtjZ97NcSgr4gJ9VGrz/7wKLpY3iOs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=mAaYqlaQ5uBstQeWOJOCJR6xx13gwL3D9F+PdxXvG+6SHOKd3CjY2BzReKCJOM++O
	 3nuLdvrTGyVlB42pRT4d3o2PKTfHtLxjUBRFRb/OKhVDVgrSGhQpkXTDbQyoQCXFhW
	 8Me1fp5zIFUczsTs1vo2/4bIq57UANivwoUXvZ76paMjI2M9Zqann9MJ1r/AFwsJIa
	 A+7b56FNYipOG/reEGZ0z6vMa5RyG9Udu0YZIRW6YyBkK9h4LIH9DINlWbl2g+fGw3
	 ltqHvNRPn3B1MCQsXlWTekvPhlIz8eblaG5+tViGvO1OaZvDuDdzyISpboQ7MaLgtu
	 3trmga10duOtQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id CF9BC60093
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:59:43 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v9 7/7] netfilter: nfnetlink_queue: do not skip ct confirmation with userspace ct helpers
Date: Mon, 16 Nov 2026 11:59:31 +0100
Message-ID: <20261116105931.2866911-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116105931.2866911-1-pablo@netfilter.org>
References: <20261116105931.2866911-1-pablo@netfilter.org>
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
v9: no changes

 net/netfilter/nfnetlink_queue.c | 37 ++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 7e21a465d4c6..e3a24ed75e4b 100644
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

