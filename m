Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826777;
	b=zkOz59KDlLobqnYwniM3xNtGOcqtag01HFeCDhO6hGCnqMXz2G90g01XipQJnCOp0T3z
	 7d4vpi3Q8oO8+3AWp5Xsn8cZ79120Xtn/Vthpbvqhbx+DRSUNi72RBNUE76t4LIeZzR0Q
	 HcImtMyzXxt1z4B40A+iBckLGSjncxgxiCgces2IWmGrNDO4vvIJq6BZyq3yTD/eh61I0
	 X6xWQoAjQrpsD9RP+mGZ8HRbAr5x6WQYT6i5mBK2C1fzrAUqpwdMF9jZ9xRx3lZPag5uF
	 FdmJftHsXxGc+2CP/RChxVc5cb7Gy7y3j2hxfq7RvEGKC6s6UrAjYsH1cyI/NuvJh6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826777;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=82I7kFUFpkbRNmyNzFJ5JQteM+PM3fTS8C9PqcZHi4g=;
	b=oyzmmNYIn11Zy2ab+YcvTkv3MR5RhFKfawm5IHbVZXcpN0FljeLBnHi9zE/h0ZFUwWrf
	 3ae5Nc74DizQ9dcT5HdmTPPVlq8e0cEutg1Ax/t4Z/47Rzx148nZucSsvabbrQmbouv4w
	 1nzAdGhNnEwuJyCFTh51TiVkAWRGZFIX8DG6aloKQ2Bw9aO8gIwiU0T8j5quYiVsa96UN
	 FT8JJUwTJGdNqnFmPP7d8kxDDbPMEm0oW76RAajNlLSOv674d+vN3BguU3xisCNSCleaq
	 S3yweIWwOlliOQO2a/YY0r0eeNFkgMxrvvfeEBzwRiJdVFsD+ah9lcc2bkw2MYZiUoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=LV6lDmIT;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01251606A334
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:59:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01251606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=LV6lDmIT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794826775;
	bh=82I7kFUFpkbRNmyNzFJ5JQteM+PM3fTS8C9PqcZHi4g=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LV6lDmIT+/oAp4PgNATC9/2pI0pXnWJBgdPSS70kZ7GczIC1vQPT5l9yCbaJOwx52
	 6pU4TllczyrPK7AWoROodsilHFahSHa92qiDxtCXdrr6pPZmVT/i679AbJCK9SbSF0
	 ylLh1AeYFSKhdwZXjsZUZ/DEokDn7DmMaLv4LjOtw8z6u9wt9BBv95IESbXgHDTRBL
	 u5+srgBf8iH5wcbZC4+cEZ5kXqegXfNKLv2SPf0E9ezPFszzFyurIiH011bqYOgqOf
	 emxAX6QK5ZDb9BDeqBmw8OD3fTTBMdCXOSsTbJeHg2cut4+Mrm1Bb9j9zuKCItTkKv
	 yhWS2tpwUtNDg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 61DAD60091
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:59:35 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v9 2/7] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Mon, 16 Nov 2026 11:59:26 +0100
Message-ID: <20261116105931.2866911-2-pablo@netfilter.org>
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

Add nf_queue_hook_entry() and nf_queue_hook_entries() helper functions
to retrieve hook entries and use them.

This comes in preparation for a fix to restrict expectation creation to
nfnetlink_cthelper.

No functional changes are intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v9: no changes

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

