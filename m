Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792518367;
	b=RWmHevlLDYZ6j5W/CRNwo2SLMZu+5Nom7cbLbVOKgCJeDn7jeev17PiceeUCHfOaCPtX
	 t9+hTvBpB+yaBUlslsKReXhfJPmn7aT/HmM9544miz9UwILKICL4jNkyoJSAw/Yg8BeFE
	 ptVGMdPrdFAawh9pdtH1wjVwhr1jBYI/M+vNWfVERTyyUbtCbzIHQIR/ik4G2gHsgTM9j
	 x5RhZ0YLluVR4aRKx3By0nVPDbEN8dzrYCaau2QOmvBf7cOkSl+2uO9y97PEz02Ja99vE
	 9A8DX2MIELsLGYkZZF727Qbvw37eoC51921QQoyiEB5PCoDCZrMmor9V1YBI4ACfbTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792518367;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:X-Spam-Status:
	 X-Spam-Checker-Version;
	bh=+5/tX9sv2N4Gpfz/4R1fEzBAcSLP22fqPL6nkGZsAOc=;
	b=NemzYDmFVCTcuaaZqsSdSMvDaCPIEM7CdsN3SYSGtatzCwP7ncb9R9BsQjQ4z68G9x6j
	 n67fYD3HB6zOkFz2DVsMH2nTEJhvUNZfjA7nvneuwfh88bKR92zDcea2B+ZCwRAuVvdar
	 /41+mZbJjdHfdn/J2SzIokboXLI95cMJ8rOP48SiikRHeumFkVG0Ku+CQeBTmWvUnZtpe
	 MDZOXcvidAq69QLr1wvN0xY3losAGsFWDf1k2aJJ16OI1E+zbLEjBxeYkFmtRP5aQByoM
	 +ft5P4mdjHfLfnyLy5rqQhlLF7LD5tt37aqrqZaPtUasPa16xkycdigOasXd/R1Zw4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AEtoF6DI;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A1A606A31B
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 17:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33A1A606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=AEtoF6DI
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1792518364;
	bh=+5/tX9sv2N4Gpfz/4R1fEzBAcSLP22fqPL6nkGZsAOc=;
	h=From:To:Subject:Date:From;
	b=AEtoF6DIpowTkxVHWbhFgUcuVf2VTJHG0xM4HcjMoU50FAXQ4eic/KwLw8phlvzYI
	 0nNUeDJH6mVme2L7I+ZcHluQkwPRJo6cPhuwbSia6mMUCHkJ5LmTpBoSfhrDdvZhpA
	 oJtYr0CKCoKlM1zoC6x6sjoeaqV9pDHknODOsDA14rkiQGkAdhIP6Lc4SILT59a7wh
	 o1NP9BsTxDgIUJ9vLVRZ+Ik7HWrlL4NWrA+Yw0eIXUA00ErRINZHZhw1AKffYAiGCj
	 LOd/RhlH3eC+XLg3WKh6yFQrfpmxFrHd9WAQ8S0H1GSpWB8p7tiZU46j9ybLgWyYzC
	 bVxXWBgl4pGmg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3635660051
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2026 19:46:04 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 1/2] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Tue, 20 Oct 2026 19:45:57 +0200
Message-ID: <20261020174558.1922531-1-pablo@netfilter.org>
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
v2: no changes

 net/netfilter/nfnetlink_queue.c | 43 ++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 00b76c25d55c..bd3567f29752 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -358,30 +358,45 @@ static int nf_reroute(struct sk_buff *skb, struct nf_queue_entry *entry)
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
 	const struct nf_hook_entry *hook_entry;
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
-	const struct net *net;
 	unsigned int i;
 	int err;
-	u8 pf;
 
-	net = entry->state.net;
-	pf = entry->state.pf;
+	hooks = nf_queue_hook_entries(entry);
+	if (!hooks)
+		goto drop;
 
-	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
+	hook_entry = nf_queue_hook_entry(hooks, entry);
+	if (!hook_entry)
+		goto drop;
 
 	i = entry->hook_index;
-	if (!hooks || i >= hooks->num_hook_entries) {
-		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
-		nf_queue_entry_free(entry);
-		return;
-	}
-
-	hook_entry = &hooks->hooks[i];
 
 	/* Continue traversal iff userspace said ok... */
 	if (verdict == NF_REPEAT)
@@ -417,6 +432,10 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 	}
 
 	nf_queue_entry_free(entry);
+	return;
+drop:
+	kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
+	nf_queue_entry_free(entry);
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us
-- 
2.47.3

