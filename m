Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789461;
	b=bpE1fIIteDgPT7QZCfnXNh8zSpcRxSy3G4dktJUOIFv2xT8qU9VB19qlKDBxK5M8L1Ge
	 RF3qlAFsYHa/UQvxMWx+9iLOo5jPUnNH1XOEL0ehqJG6ZTgOdKKYUEC02ILDFHX//wKaA
	 tbFVkZJ1pYeGpc3TII0+daDo13iBuQd9rWsl7IqdEnKM6ulGpR9PfwZL1gko111sK8jwM
	 8OHzl2mKRDjuKrG45VtBSvKZ+sB2JiK85pqLkFEiCfA3krMx7qfM0dwTrZj8vF2G9XSEg
	 /6dIo+6ETCo4rmPrgSunBj1DqiwK+NUfeDw1Hew1dG67LimzzKpW7gQ9Df6hZJSbRMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789461;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=2RiHQKc2RAdiIUU2O5PMoeCGrvtka2737xYXLuF5uho=;
	b=XAH99y+OwUa81D5Fo56jUCvXRGpBz0y3MBdBGG0kCiBGYcq354KcewD/ovK8EqMjqkfJ
	 uVZbT4GpPXwRtHACl2S2128YYZ0iKxQxIE/8q+6ZKfC46gYqqrIZgstT67Vq05Mp3a0xe
	 0iS2MaCnhsriYWX4eVqTTLG/9Me3wj9L1AH6maVvcM+G3XRaD82uvZUCJCzIKISmJ7TTO
	 8lI7P5VVjvVL/jn/qkSdHyZASyhFjTzB4OyY90mblUemQ7v8DTa0kqQZ+UuC0s0PzPZP2
	 NOXUrweklw47p7IvloNYkPrONYkM9LVgi5ewizIIWorQDHg85b9QBYFc0ZFALLXeqaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b="N+MQ/KPX";
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C717C606A334
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:37:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C717C606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=N+MQ/KPX
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789459;
	bh=2RiHQKc2RAdiIUU2O5PMoeCGrvtka2737xYXLuF5uho=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=N+MQ/KPXHzQunqr4Ohrgab+K1vBZ1GGqQ65x/6XKBKz+e6tO4guVMHsCXYZZZq9p2
	 yA40CISjx5YNy/yAfo8mLnVuscIZrovSt66CG3/B9glN4Nf470LptqjQ2RY7UBhbeW
	 bQbfan3iG1TXYZCzT0NuGShT7QSTeBvRlPHNMROFGmmzfkyHWAMfiQeJDkblxFFLp0
	 2lTIeoIODR51jaMFGcj7XeJyP4YGV6nFsSpiJJrsrOSRri0TCQGrCPine5TaKtK5MI
	 C8uFdY8HUNcbcKph4dskfUkfuuPIquXXeAl/EyTYkuo2pB+k3EXqJSqCtlzIrtP1fL
	 Ms6gj+41GPKWg==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DDE0560077
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:37:38 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v8 2/7] netfilter: nfnetlink_queue: add helper function to retrieve hook entries
Date: Mon, 16 Nov 2026 01:37:28 +0100
Message-ID: <20261116003733.2820132-2-pablo@netfilter.org>
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

