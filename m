Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794521482;
	b=CYg0J6/YKtJYsrYHUhj4W4l9dbFCmtkwaL/zCBQHitTZj2H2k6RROQc1MdYq8ZLPS/Jr
	 Zs1xnkp/Kuv7HEEc0QJu2Sa4ZoDRSEpxkZMJZD/CjSa154Cm1hfpDnuVtKxt6NiFV4NcP
	 gdpEI3wjHxHuQQ2EfYVqR3LEcV75tU35q3PhGOiJU9Xr1kBAE7b3ZgnzXnMU6rD7+ZJUl
	 Y8Lx3mYbLezvLCChHPrxMhCOz1l+5AQU7hXYS58KNo5bdX5qs763pglO8AeR+852glZch
	 DUt2VrFSiszyYFJaU+hI/o2UGu0hfjKdT0eORiHqXbSRh6aecQAFjRWvXHyyfpKvZww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794521482;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=InjCYOlcg3b+RLU4BkPO7cRHG0V6Z+cy+Rrvu7FiYks=;
	b=aaGJeOtCsFBFyYnXYrVR/GYNVfWLesM7xFYz42ib/Yo00Z0IhYf/V9iMAXq0dT0AMRef
	 wJ2pmZX3cUnrSRau9sNghpol0Q4/iw1gFjEuc21CM7v3iF27LZk1nQBd+rlTz569eemc5
	 ubOKasBs7Qyn5nuYjxnmE5NouHmJe5NUvLlNlNg73XQll3ntWqRqQc7T+iwGftflB7ce5
	 yRUas+jg8O31DqI1QYpKAuaXSDWkLh+zpD/GsyZ9zGaHrbKkNNTb/nUyN8sKEKRndgnCG
	 4+xzL5ixx8r+IZO6rWNd5g38hgYWe8fXeecJafZJZv7oA+JeI6B+CHEK0TYGZ2CnC4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=K8pJFBJb;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03788606A323
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 22:11:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03788606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=K8pJFBJb
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794521474;
	bh=InjCYOlcg3b+RLU4BkPO7cRHG0V6Z+cy+Rrvu7FiYks=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=K8pJFBJbaAbIsXMLj/rmJ5y4IX6qF0tAviUwfpYJA3tg6ynE63CrH+9EXhKbZewMK
	 GqrK8lkLzjr6a/KvlqlJ+eMV8u/wIwYh4X/eTA87y3pS3/45hBd2lsHnzO88hxtd19
	 ohY1k+JCGe9CeTjr4M8UXk37DUcZiq4soZbYH+ZEOMb1D8ORvr+HmCNGDCVYY+rZEb
	 pnF2WCENrEfKJGVAKFReu33viVQzM5Q4lcAQbil3xSCZC0E7hbCkZSPuUmMRN3rPZE
	 fFzlN59FvQya7ZvkhDwZIedg+BxIk9SXhVeVKLyIOKiThKi9WaC7GsxZ+533BHHRN0
	 YGC0P0rvswA0w==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6EF0C60079
	for <netfilter-devel@vger.kernel.org>; Thu, 12 Nov 2026 23:11:14 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v7 2/6] netfilter: nfnetlink_queue: consolidate access to hook entries on reinjection
Date: Thu, 12 Nov 2026 23:11:02 +0100
Message-ID: <20261112221106.2278789-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261112221106.2278789-1-pablo@netfilter.org>
References: <20261112221106.2278789-1-pablo@netfilter.org>
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

Fetch struct nf_hook_entries only once then pass it on to reinject path,
otherwise re-fetching the pointer breaks atomicity when checking for the
conntrack hook type, since hook registration/unregistration might occur
while following nfqueue reinjection path.

This is a preparation patch, not behaviour change is intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v7: no changes

 net/netfilter/nfnetlink_queue.c | 42 +++++++++++++++++++++++----------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 09af8faf8675..7fb6b6b82a24 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -382,10 +382,11 @@ nf_queue_hook_entry(const struct nf_hook_entries *hooks,
 }
 
 /* caller must hold rcu read-side lock */
-static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
+static void nf_reinject(struct nf_queue_entry *entry,
+			const struct nf_hook_entries *hooks,
+			unsigned int verdict)
 {
 	const struct nf_hook_entry *hook_entry;
-	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
 	bool old_in_nf_duplicate;
 	unsigned int i;
@@ -400,13 +401,6 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	current->in_nf_duplicate = entry->in_nf_duplicate;
 
-	hooks = nf_queue_hook_entries(entry);
-	if (!hooks) {
-		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
-		nf_queue_entry_free(entry);
-		goto out;
-	}
-
 	hook_entry = nf_queue_hook_entry(hooks, entry);
 	if (!hook_entry) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
@@ -515,7 +509,9 @@ static bool nf_bridge_ports_valid(const struct nf_queue_entry *entry)
 	return true;
 }
 
-static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
+static void __nfqnl_reinject(struct nf_queue_entry *entry,
+			     const struct nf_hook_entries *hooks,
+			     unsigned int verdict)
 {
 	const struct nf_ct_hook *ct_hook;
 
@@ -562,8 +558,21 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		if (nf_ct_drop_unconfirmed(entry, NULL))
 			verdict = NF_DROP;
 	}
+	nf_reinject(entry, hooks, verdict);
+}
+
+static void nfqnl_reinject(struct nf_queue_entry *entry,
+			   unsigned int verdict)
+{
+	const struct nf_hook_entries *hooks = nf_queue_hook_entries(entry);
+
+	if (!hooks) {
+		kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		return;
+	}
 
-	nf_reinject(entry, verdict);
+	__nfqnl_reinject(entry, hooks, verdict);
 }
 
 static void
@@ -1866,6 +1875,7 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
+	const struct nf_hook_entries *hooks;
 	const struct nfnl_ct_hook *nfnl_ct;
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	enum ip_conntrack_info ctinfo;
@@ -1890,6 +1900,13 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (entry == NULL)
 		return -ENOENT;
 
+	hooks = nf_queue_hook_entries(entry);
+	if (!hooks) {
+		kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		return -ENOENT;
+	}
+
 	/* rcu lock already held from nfnl->call_rcu. */
 	nfnl_ct = rcu_dereference(nfnl_ct_hook);
 
@@ -1924,7 +1941,8 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_PRIORITY])
 		entry->skb->priority = ntohl(nla_get_be32(nfqa[NFQA_PRIORITY]));
 
-	nfqnl_reinject(entry, verdict);
+	__nfqnl_reinject(entry, hooks, verdict);
+
 	return 0;
 }
 
-- 
2.47.3

