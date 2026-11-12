Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521676;
	b=wMFT8XELjEY2fvlEvl0yCtsR8wLlQHDSrM/LqUytBEgQYzOOlUCj/+Nn8qktn4EYHAw6
	 ELuVf22WCN9RMDAhkGDcHX8mXXD+PE18CxNW92LCcXYKwI2JnJ20M6dS6SlVCHHQDByDX
	 7oljKBo+pPTLZ2gqt8dQ6IqHNKAm1uz3FLBSPqekoiSHB6kEYoWAzrVS3o+qSPhyA88ar
	 csuVUe2PCZCdVe++tbS/3ezuEuYgn2OwvpFoWG5DkHvaeuUlM4TbBlFXi7wIZ81vTX8D6
	 45TQbMd0jrRF60VVKqqfUZOYs9GARzZaNJ+3yl8zZKOWX2nvP3zIyinhhS/GAnLf1vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521676;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=4WkdgRj1t+xsH2714orLkAV/TTYlxHFa0A4dPqFYo38=;
	b=sQznds9Kj+j7bpOiZgdOpwLQDH/RjI8RqXwGEAVu/Wgi6VJ6WtmkZg3Evk7Jv5+Eog5E
	 FAZWJLv/fLUoO09YGyaX+ADs0HIEcDec3gNovDQoy+CCgJqejmLMY6+79jhkU8ukxQaEy
	 f5t2rpQGgNfyLUelHZqVlI6pdNY8LsSuhjCIcni0oxvjVUq+iiXxbcskc6u/QiEn4N7mU
	 i5MC5w9Hqvdo5xm9VH7PyEuuhThEU6hu/pD9mnZMZWAEhH21+BMX9hCL9UgjgTpkwtJbg
	 hFD39LOTbgCQBzjjAMUSKJBQUNhBQ5DJ0jSTWsI3F7jQQKorbNKnwu/jIxN7S6Nz60Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=HIJ9UBEH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AA1606A32D
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:14:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45AA1606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=HIJ9UBEH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521674;
	bh=4WkdgRj1t+xsH2714orLkAV/TTYlxHFa0A4dPqFYo38=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HIJ9UBEHaSfzpBQbzdxKrtkc1QOqmUP1cPJwdiL6iKDow+uMdGk4cGcc0OQ3mtqtP
	 6Mk78Z4OuBdvNOEIdVlQByntHNmjhHwu8cFBzcJmhcnUMLwZ9QCDNFzyRrDfrrNBf1
	 TDr9cXU8oK6oxzV3hG9WBMrI62nh+FdwvOxRuetoh2Bx8wiL7SN/gIYYlx91Fvcz0K
	 2D3d2poDNfF1qL3WSIvEtx+86JEPyZ33pKAFdWzqg7HCdkZfBKcvmFavMoi8YDVW+H
	 dqDITzesYQ+7W/lppuOB19K7EaiY64AqBnIwxsyWDfsw1fa1cyzHRRDn+lu+Ceppuu
	 +IARTbG5EZPsg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 53B506005C
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:14:34 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 RESEND 2/7] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Thu, 12 Nov 2026 23:14:24 +0100
Message-ID: <20261112221429.2279193-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112221429.2279193-1-pablo@netfilter.org>
References: <20261112221429.2279193-1-pablo@netfilter.org>
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

