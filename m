Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794271157;
	b=M0A/oSzJz2/oyBPB6E9XTaO5C1ZqH8qqiDhu04N1Zlf+2r6oQGY21WkbIk0zBVK5qwnK
	 gplQ0PLFSUuYojYIF0iQGnRuiZHBZkNsmJR4ziz3CvsuoIg1zhN5agbwDiyIk7HUbgq3T
	 h0hPbO8xlaLpSMtSpP9DNQkWB6bl9cbYzYIwGuEi3qWzMex9XdQJXPoQUtTfw9IeqRNXa
	 uSIXgy6oGvyQ5qtJkxuB8ZzhBggr6ESLf8dsPgRBqFi6xTm0/Oy4a7dEsp7nRXXySDL/b
	 5tyP9m/aL4TN/zw7TEU8oKlyxY1jTA9AxmZe7Y+ifbrHOzt6bQ7qiUWO2fhQHKa5eFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794271157;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=IpmdCqf7HU+gzN7E3X0HWtqHdIjWMMBKEHqkX0Ks2Fk=;
	b=ZwfTNDOSjLUXs2MbZf6OfoV2+Ed2EputvKjDefWs9mqKmX5GnDEqs2Ete+hZspvmlmCL
	 meLwEhcDGbDvgNuQSU7clpvZ6bDJvELgAdbmDhxNya7O5dHCJ53qqH1x4bxIXLnxaw+Rr
	 0sGEobX8WO1scPI4fPknjDOHotogVnB8Rix7An4Etaf42ncggf4cvwdRKfnaSTgS7eRUI
	 AWRGHZsiptV20jvXL0EGMc8P6bekTrKHE0yFCHkqNHDX72UO8Mqp7Ui7/DdycM57a1/+U
	 sUMkobbh5+25SNAXIpnV7F+Vi9hpMOgoGWlr7w9sJCeV+KR1ku8YVTPmzr9YSNWlcZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UH3BQSPW;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A431606A31C
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 00:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A431606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=UH3BQSPW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794271154;
	bh=IpmdCqf7HU+gzN7E3X0HWtqHdIjWMMBKEHqkX0Ks2Fk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=UH3BQSPWnZTbKqxtG9PcMDiooSzC1nz/bBbLjt9VJMFVOc9LUO5nRlrn6lxNPtvUG
	 Zh4kQcsnxH9MV9CT7Hoc/4DJG+b4tV2pCJalvf8EXNrSwn+h+CBcN1r5TLf9P6QV74
	 ZMesqEsoSZ/oWzBNyLnlR/NWK6CE7alyyicambF43MhnsUXjAzvsOu4zMwli9DU4NR
	 wFgnhXw/6ZUW7hMNFAuPw/6C8HhHu4cw9gqFuroqLMjGrQXU3j1hapZIKZC0UR1304
	 WCErA7PW6OLbO/mLy3L3tumQiCkKydD1Qk6V1jYCH3dk19656jkg+v8ys+btOqb2Nt
	 NAzkKVbSBColg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A23A16005B
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 01:39:14 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v4 2/4] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Tue, 10 Nov 2026 01:39:07 +0100
Message-ID: <20261110003909.1740094-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110003909.1740094-1-pablo@netfilter.org>
References: <20261110003909.1740094-1-pablo@netfilter.org>
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
v4: rebase on top of nf.git.

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

