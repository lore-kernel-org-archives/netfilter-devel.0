Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789403;
	b=U6bGV48TKCIcdDblPjHjw+aAxLN2/NCLrITE0xH+zLPPqdCUMcedAGPFS1v3cH2A8xPI
	 oty+Fh7Lpv1T7ZGHKMAqfyAj6WhjGzv4iqR87QR1KLFQ3wmX5L+nGrrCiqmnmj91DnJ1C
	 LZUxVninqXtnDMwK/Z0ovesZWHK3nnVtuQohCbxmffg4cKpGQ5K/+ze0sf4PJ0RVZoAdE
	 qm3OdCU5NhLS6sjFunX4q6fscV8wPBS4bodBnSs1GYWcAKEa64j5YwGEqQuyQYS+2vi1x
	 0GUbUizdpSqGTjFe7RNJ7orhB9nN1GbmUrh+QVLlrh5CQ/lIUUlcuurBGYi8rhxyeLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789403;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=2RiHQKc2RAdiIUU2O5PMoeCGrvtka2737xYXLuF5uho=;
	b=fcGV1jxAh+Mq7OLzLgsICzFislVnuxuAiL+SK7DFZha6s26hrpGXX0/UgHMzVndhsp1f
	 9FcsdFAsFHIBjAV68G59l9aH3W5G3LUIBI3dJQDB+B7Lso1zEJN6tqoY9ZbHwb5mCr61M
	 dRy5VgFgq7+39TH0DWCAC7lJV4DLc+cqqqhOZHKAsosPtsUC2kgJIxp19RP19SPlyJ2Cf
	 6BE7fVzonWlgty8725MDj1cOURHaieGUgHVAH5EUZpiQa+n3MnBP3AUqWg8ciRjJL+ULR
	 pEfsVKmgjp33xM5yMxuXl///zIqv1KcxidMRRNbatTHYzno/t8R3bjOTk9buZByMWFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VPzkinqY;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91358606A331
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:36:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 91358606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=VPzkinqY
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789401;
	bh=2RiHQKc2RAdiIUU2O5PMoeCGrvtka2737xYXLuF5uho=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=VPzkinqYF1iMM7sz6QbNlICTzTG9aPZ9efFIAiTJ/294pGgJoHfgmKPY9FvEJQhhu
	 WtlaLooc2zH/Ve0zHK81Db6WzbqS1zgZQFAPtHpYOkca+iS6SYPZedN1ULiKDvAwxA
	 uKIsb+Nsst5xj+m5TMqfihSHrCBI7d4hSOnpk9HJJaM3PXPhhgSKmFQ2yh7WfVyK3m
	 IzPvi1Tmioaor1ZeHyQGHWTKyp86te9vM9dx28/be+e7+qCLTAXxesYm7xf2ehh5b5
	 gkW4hs80eVgFw0dZwjgcVCxSmlmDtO/eKdAdq3QE73Y6W9SL+uTGqBZvhVC5nFjCU3
	 YqlZrdqzRrghA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E32EB60077
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:36:40 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH,v8 2/7] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Mon, 16 Nov 2026 01:36:29 +0100
Message-ID: <20261116003634.2819957-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261116003634.2819957-1-pablo@netfilter.org>
References: <20261116003634.2819957-1-pablo@netfilter.org>
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

Add nf_queue_hook_entry() and nf_queue_hook_entries() helper functions
to retrieve hook entries and use them.

This comes in preparation for a fix to restrict expectation creation to
nfnetlink_cthelper.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v8: no changes

 net/netfilter/nfnetlink_queue.c | 44 ++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a8aa7ad832c3..9929240e819e 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -360,17 +360,36 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
 	return ret;
 }
 
+static const struct nf_hook_entries *
+nf_queue_hook_entries(struct nf_queue_entry *entry)
+{
+	const struct net *net = entry->state.net;
+	u8 pf = entry->state.pf;
+
+	return nf_hook_entries_head(net, pf, entry->state.hook);
+}
+
+static const struct nf_hook_entry *
+nf_queue_hook_entry(const struct nf_hook_entries *hooks,
+		    struct nf_queue_entry *entry)
+{
+	unsigned int i = entry->hook_index;
+
+	if (i >= hooks->num_hook_entries)
+		return NULL;
+
+	return &hooks->hooks[i];
+}
+
 /* caller must hold rcu read-side lock */
 static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
+	const struct nf_hook_entries *hook_entries;
 	const struct nf_hook_entry *hook_entry;
-	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
 	bool old_in_nf_duplicate;
-	const struct net *net;
 	unsigned int i;
 	int err;
-	u8 pf;
 
 	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate &&
 			    !entry->in_nf_duplicate,
@@ -379,20 +398,23 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	local_bh_disable();
 	old_in_nf_duplicate = current->in_nf_duplicate;
 
-	net = entry->state.net;
-	pf = entry->state.pf;
-
 	current->in_nf_duplicate = entry->in_nf_duplicate;
-	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
-	i = entry->hook_index;
-	if (!hooks || i >= hooks->num_hook_entries) {
+	hook_entries = nf_queue_hook_entries(entry);
+	if (!hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
 		goto out;
 	}
 
-	hook_entry = &hooks->hooks[i];
+	hook_entry = nf_queue_hook_entry(hook_entries, entry);
+	if (!hook_entry) {
+		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		goto out;
+	}
+
+	i = entry->hook_index;
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT)
@@ -406,7 +428,7 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	if (verdict == NF_ACCEPT) {
 next_hook:
 		++i;
-		verdict = nf_iterate(skb, &entry->state, hooks, &i);
+		verdict = nf_iterate(skb, &entry->state, hook_entries, &i);
 	}
 
 	switch (verdict & NF_VERDICT_MASK) {
-- 
2.47.3

