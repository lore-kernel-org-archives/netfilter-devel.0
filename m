Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794826778;
	b=eoubcp+5syJD5agIZ5tVXFRNVVzHBvHtz6wHbZxkCbKScQatJSQV10PT7wDDPYg+OW1i
	 L6ANu/3/GeKPcnHnzw8Md7EqM6EZJ090xSO7EJmhzLac0pEULkasMMtyqCgILzfYR0rSe
	 7svlu6G+7W+6gcnS20odwgiX3J3DXR660YkQ7MAeixZashm5/7ioUl9d/PDZjtdWBOaus
	 7KCWCKYO+w1jW9Ps6Z843xF+Pajiekwh1cd7pE5/FyHT8+FwSRV1UcUJfPnFb3MHmoqMS
	 2aE1EeGJ5hA7z7pAis4bLBJP0lsnc/eOjb8rMX98hZL1dNb6X8h8qGLL8tA4+O4gVxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794826778;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=0d5QsG3ML31bWEDKUgwziYCJyLbXWH3qNaWcj07yK4s=;
	b=E2T5y1hzpbFLG1MwtTU14wkzPxHUolpsw3IXwgMqeW7Gq9Yj5eG4BlKubkVpxR3eeqw/
	 Dq5SeF0Q2ciQbbgLkis62X27FNpzVw1G70tDjzTALPb1XYDBZdd1sSboS1ab4X287HrSf
	 GKm1jcS25tUsSUqVQmccqds7WwFQ7MllNwQGeoPnYt1pxq77+JzxuW9gqBA+64VUreYsH
	 pGqscWbHGiKX5wRmkdklAT5Ye3s7pu56iNvJi9207M0QxSto7hHBMg+jZnTegu2jTcZ+N
	 qUu/AlnApzh3KSXEniWArkN5kYBE4RwtAg7xpAzjaOnpCHLIseovwEzthpvHAzbwWsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=d5OsPuoH;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D80E606A323
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 10:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4D80E606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=d5OsPuoH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794826776;
	bh=0d5QsG3ML31bWEDKUgwziYCJyLbXWH3qNaWcj07yK4s=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=d5OsPuoHbjldgNEc0nE8OJSYhoyKzDplL1WX6VBRX8iMRnZTLtMQsIraBAixJsUdb
	 cT9vaRocB9MYFyBx+AS3m0HUPP1uM8TE27sl8NTuiDyQdD4uSJeSEGzHttyTVrHXX4
	 woF5IRkarwVblOg3ne+m7THx17odVXqZsEXiWW1tjblRw31dAd875TUund5BRW2/tq
	 FBUXADSPczx4h89ruOEQnlUYVdC4CqI4Hyy1LG8MPnXmKj65pSPC1tcs3BTkc/PHjp
	 MVvVpT7+iBvvbuhuB3UofdgtQrVs7TN/MPdedQhDfD5PSomfteFBjwMYVoh02ta22I
	 N83yqsh+b2E4g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 65ED360092
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 11:59:36 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v9 3/7] netfilter: nfnetlink_queue: consolidate access to hook entries on reinjection
Date: Mon, 16 Nov 2026 11:59:27 +0100
Message-ID: <20261116105931.2866911-3-pablo@netfilter.org>
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

Fetch struct nf_hook_entries and nf_hook_ops only once then pass it on
to reinject path. Otherwise re-fetching the pointer breaks atomicity
when checking for the conntrack hook type since hook (un)registration
might occur while following nfqueue reinjection path.

This is a preparation patch, not behaviour change is intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v9: use READ_ONCE() after index validation

 net/netfilter/nfnetlink_queue.c | 68 ++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 9929240e819e..c9773c4fb816 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -382,9 +382,11 @@ nf_queue_hook_entry(const struct nf_hook_entries *hooks,
 }
 
 /* caller must hold rcu read-side lock */
-static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
+static void nf_reinject(struct nf_queue_entry *entry,
+			const struct nf_hook_entries *hook_entries,
+			const struct nf_hook_ops *hook,
+			unsigned int verdict)
 {
-	const struct nf_hook_entries *hook_entries;
 	const struct nf_hook_entry *hook_entry;
 	struct sk_buff *skb = entry->skb;
 	bool old_in_nf_duplicate;
@@ -400,13 +402,6 @@ static void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	current->in_nf_duplicate = entry->in_nf_duplicate;
 
-	hook_entries = nf_queue_hook_entries(entry);
-	if (!hook_entries) {
-		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
-		nf_queue_entry_free(entry);
-		goto out;
-	}
-
 	hook_entry = nf_queue_hook_entry(hook_entries, entry);
 	if (!hook_entry) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
@@ -515,7 +510,10 @@ static bool nf_bridge_ports_valid(const struct nf_queue_entry *entry)
 	return true;
 }
 
-static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
+static void __nfqnl_reinject(struct nf_queue_entry *entry,
+			     const struct nf_hook_entries *hook_entries,
+			     const struct nf_hook_ops *hook,
+			     unsigned int verdict)
 {
 	const struct nf_ct_hook *ct_hook;
 
@@ -562,8 +560,32 @@ static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		if (nf_ct_drop_unconfirmed(entry, NULL))
 			verdict = NF_DROP;
 	}
+	nf_reinject(entry, hook_entries, hook, verdict);
+}
+
+static void nfqnl_reinject(struct nf_queue_entry *entry,
+			   unsigned int verdict)
+{
+	const struct nf_hook_entries *hook_entries = nf_queue_hook_entries(entry);
+	struct nf_hook_ops **hooks, *hook;
+	unsigned int i;
+
+	if (!hook_entries)
+		goto drop;
+
+	hooks = nf_hook_entries_get_hook_ops(hook_entries);
+
+	i = entry->hook_index;
+	if (i >= hook_entries->num_hook_entries)
+		goto drop;
+
+	hook = READ_ONCE(hooks[i]);
 
-	nf_reinject(entry, verdict);
+	__nfqnl_reinject(entry, hook_entries, hook, verdict);
+	return;
+drop:
+	kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+	nf_queue_entry_free(entry);
 }
 
 static void
@@ -1866,14 +1888,16 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
+	const struct nf_hook_entries *hook_entries;
 	const struct nfnl_ct_hook *nfnl_ct;
 	struct nfqnl_msg_verdict_hdr *vhdr;
+	struct nf_hook_ops **hooks, *hook;
 	enum ip_conntrack_info ctinfo;
 	struct nfqnl_instance *queue;
 	struct nf_queue_entry *entry;
 	struct nf_conn *ct = NULL;
 	unsigned int verdict;
-	int err;
+	int err, i;
 
 	queue = verdict_instance_lookup(q, queue_num,
 					NETLINK_CB(skb).portid);
@@ -1890,6 +1914,23 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (entry == NULL)
 		return -ENOENT;
 
+	hook_entries = nf_queue_hook_entries(entry);
+	if (!hook_entries) {
+		kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		return -ENOENT;
+	}
+
+	hooks = nf_hook_entries_get_hook_ops(hook_entries);
+
+	i = entry->hook_index;
+	if (i >= hook_entries->num_hook_entries) {
+		kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		return -ENOENT;
+	}
+	hook = READ_ONCE(hooks[i]);
+
 	/* rcu lock already held from nfnl->call_rcu. */
 	nfnl_ct = rcu_dereference(nfnl_ct_hook);
 
@@ -1924,7 +1965,8 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_PRIORITY])
 		entry->skb->priority = ntohl(nla_get_be32(nfqa[NFQA_PRIORITY]));
 
-	nfqnl_reinject(entry, verdict);
+	__nfqnl_reinject(entry, hook_entries, hook, verdict);
+
 	return 0;
 }
 
-- 
2.47.3

