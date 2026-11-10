Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794316012;
	b=LLfSJ2bwYMCzt1VSuK6YfuFXyBLL3cA8Lytm0opiTIcW0Z+wsAMWTzcoe+WyPsQlf3v0
	 rmBP2MdkST37xI1OFwd2Oxtl9fsWU8D7fIQ8e5xVowrDcbTq9hVnnFOu7Zf/3H5RdQZR0
	 h9J4fdwiwQZzoV3dVS/3qRxanXLMkV4ISEgEDsH1djqupjr8D6hl+9tH/CsbzEufSkZ1H
	 oqdRfwTz19ueq9EueppXDV3uMyl7/TkVaWUH1VrAN8ScUhCuZ8+eZj5cnrFLuUeM/FeBU
	 VIa2q4mkxCRnF0dxzIH5JS7xc/L4sTS68cFkuwYNdUdvjT5/cvyM/6eIKmGpC+gbiMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794316012;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=zYoIHkDFsgXhFUFw36LikFOjolVv0cwJpThXi/QBGT4=;
	b=QPcMSk/jOek++TN5F1f0SentgLolKAn3Td9xg3guSUc5u9quDBEkgm1iutMFacStAe1Y
	 Maf7vn0F6ss1oCSrqtCLglA+iRT9M9HKBS1R5+Js/eiVdJTSKaeBPIiFuc9P2ROrpntDI
	 UwdW4aJInNDOlZpfEDXvn+//QKNQ1HdihdK+85w5SVyrID8ZNzdjaouHiyIxKK0LMCM9V
	 hddvLiKoc5mVQgcuJk9vhXjRMAiVSApFIXu5je5CI+NmwDotEzTvY2RIs6B0ARZLwwvkb
	 c0G4AKUBzxKODQCtobdBsruONgm5VHJl/i1A07BAW/TSmd/Q8LwHxwnF29Cu1pA7VKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WBbUU4Cn;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F0C606A742
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 13:06:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 29F0C606A742
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=WBbUU4Cn
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794316002;
	bh=zYoIHkDFsgXhFUFw36LikFOjolVv0cwJpThXi/QBGT4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=WBbUU4Cn7lCg5Fa5KZhSy9vS4mTd2BLN3r2i+LUKVLzTkWrK17fW+Cx2Ggkmyf7Va
	 hbIDfMj3A63HGyeAb6fSrq6lsJMUHWnUG4mYE3wVnq9cmHUXB+/aczWEj6feRSWBbI
	 5vzimUP/pCZkjP0SXMgPAvFNp165CISTtiaHnNfzDmuLQ1MATqC4Lgj28GDadYiSee
	 5lpgt2NrWlL8amtj/zSswDa5IIbvLqMXXPMCpXmm4+LQrUOjmyhxz0F1ay1+Qp68eO
	 kqT8T894eFiskIqmTnSQDW/50hxq7jTwelw1+enJI5tVszA0C/YJ3j/IJLtyNJQPQB
	 wIUW3jH4FJHiA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C8CA5605D0
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 14:06:42 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v5 2/5] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Tue, 10 Nov 2026 14:06:34 +0100
Message-ID: <20261110130637.1832292-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110130637.1832292-1-pablo@netfilter.org>
References: <20261110130637.1832292-1-pablo@netfilter.org>
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
v5: no changes

 net/netfilter/nfnetlink_queue.c | 40 +++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index a8aa7ad832c3..09af8faf8675 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -360,6 +360,27 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
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
@@ -367,10 +388,8 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	const struct nf_hook_entries *hooks;
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
+	hooks = nf_queue_hook_entries(entry);
+	if (!hooks) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
 		goto out;
 	}
 
-	hook_entry = &hooks->hooks[i];
+	hook_entry = nf_queue_hook_entry(hooks, entry);
+	if (!hook_entry) {
+		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		goto out;
+	}
+
+	i = entry->hook_index;
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT)
-- 
2.47.3

