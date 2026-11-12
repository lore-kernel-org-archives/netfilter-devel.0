Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521482;
	b=tjm7sWD048EuZH8fdUCcLe2OD9Wal8M0lxis3YcXGueLyXY336scvnHUTF4QUgqi4GF8
	 wnJVEsj/HQAi30ueOHq/l1eFu9Vr2QADYUFxvDBy2zAmj+ekauUFzyB6OssLZ8CjmKMP4
	 8kQeRwStmEUYbyhp++1eQgqw6WXqHHztBS+P8lloyOQW5XJe4RuFwefhqiHUTpQsYkgJg
	 1ndgihmtoDm9PgcGmL4yqGFPwEQvOhD/+6hmukA95GNQ1KsONv3JyduhQpbxBsnD7x1XO
	 MOBEmmooilKSBtAFOK0r1EhtvYFRYLw0I2f30Myj10RyYn23w3GblOeOv/qrRl+zW5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521482;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=4WkdgRj1t+xsH2714orLkAV/TTYlxHFa0A4dPqFYo38=;
	b=VpxQ1PhY8EYJZQGXjoY6eoRd+Tvl6Up1yUMdWVbkqGSZ4t/pGYJqwg4VFtcW68n/aTkl
	 VxrSaE69HxlgjW8qSHaH+GRYKT7weUmYTvgOFXu0zT+SYghbMnvJyfZKHfnhuIL9tW7Mf
	 +Azk8+zYTeh6ZMpyUz9KS25NXVOM5mJeVkty++B81W9Nks1AMYiiaqAs54dVOGQ9a0QCF
	 oZyXf6gNwuiKmhDSfTj5IytVCxfeR9KZxfUmP5sTs5Oe9oSz2VafGBa4efHsgszg3Caud
	 S1G9mZc8wJUoMfc5CNmTQmhCWyHN8BXtN9cxRMj4aLT0Nf46v+n993yUWwsZbMtk3bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Ljgq5ytx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4BBF606A31C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:11:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B4BBF606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=Ljgq5ytx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521471;
	bh=4WkdgRj1t+xsH2714orLkAV/TTYlxHFa0A4dPqFYo38=;
	h=From:To:Subject:Date:From;
	b=Ljgq5ytxiMXLZvqrRIterCAxbakGDePv5KSUyGPsn5rfv9yOTG7cpPATa5EqkNxbW
	 q71SZrlDKiJ4eGsN1Htp9plrXL+G/p6sHaGFlhl0I4/dQZ/yliLlMVTCSrx5CvjQ1V
	 mSbW0ZPee1NIG/bibDAihIKjMcJAoaLtGUHRe8Wf05gOiHU0VB8PKBWJkRLvmJSuvq
	 KZLrToAHxKO+BM9Zp7M1p04qgsQSnjnml+2P0A4JiAHKUvsGFiKw5BxZ/VUvVZeEqa
	 lTtZIGlC6Ni/8N2whJEuzUSQJSESWJEELWle1RNdbnMliN08kTBJXqJ8/PYgjo/ouY
	 1EK1dZmaWgK5w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 249196005E
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:11:11 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 1/6] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Thu, 12 Nov 2026 23:11:01 +0100
Message-ID: <20261112221106.2278789-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
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
v7: no changes

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

