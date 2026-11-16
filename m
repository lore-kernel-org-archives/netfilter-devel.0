Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789404;
	b=Xg4jKgrz4b5a9F5UEs68N55S8p2HI0K8Y6jPIt6EzqUvWdTQkvALxPJ9eRQf/CDGVTes
	 TMn0cIbCnI+UjVx9X8s+nVGaRQfUHwVjsMZQZzwLIum3bPECEUwtojiOFBgtBfjdUdxXJ
	 52o6TIRWnrvBhB3jf3i+uJXqMcKLTPWb/9MPZDyJH0gPfcPQnScxvLV6vxrUW9BRZdf79
	 QBnrBgTXAdN+qEyS5hxJTsgCFTzVjfWqrisqwOp29Fn119GkZwKvjUZIJySKcoQ2EsCIc
	 8uJU5qxWvyDtZDWeQBG52eBooYZPCXXhADtH3xyruK50NAkZCDi/gGM6FtvFw3hS79g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789404;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=m/mH7pIFb+fzfU4oaMcwzL3Cqz5q+fnBitYQl7P3CXU=;
	b=0ganj5JtNBvks//zdRSoieTqYy4syOWbYsTnvHMzN0HMBrYhuc4SgNBJaj7pb0hLDr9r
	 AVYY9oTnfB4NPNmxa/JeQqevPvAxRx/4uywzFJWgSh4HJO6JQ/xbTfYlx3QVxincTW6BB
	 1YRzHpCy2csirjgUK8A0/9SsTrrWJKIycmeWMWSesmAAE/uSpceihDm+xILlJJSwX+/tg
	 AnbqUY735KcAOug4y6mdy88Go37lVPb2fZxMsgZ8U8zr+KVGDlT3YnJhs70pk7z6m4KGx
	 YDN0U7/ny9BWKqDYifpvaN/z8kDG2JFTG6qcSlfBSsmL+ZXIHeYrwWnflqPuXRhJw+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ODxrcjDW;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21D5606A882
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:36:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A21D5606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=ODxrcjDW
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789402;
	bh=m/mH7pIFb+fzfU4oaMcwzL3Cqz5q+fnBitYQl7P3CXU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ODxrcjDWxrv20tSM1iywvyHTHsfX6HJz1Aa7h6V6OnDzH/3QFu5KdkHT1fyTnhovV
	 tNOuk7mkDjJCmGVEWWidVeuWKazbAGaNHvyUZlMhHXn69wWqaj4lgN76sS46c8QRpF
	 329i0uc0go87Fcf6nvhwVM0OqQFSYtkYoD/PH3+RwyhHGfolmEQzIVrHAHgBNi3rLj
	 XC5fOkUbsHsnBW8GZbkyvtc89It1GK8kDUzAKl52S5fqKusdh/oXWcGeX0I9scVFeE
	 5DBXf0hmCrghkRW+Its7qZm5MkUDbvRH+rOthaqSWHJR8QoTXpM2VSfl4R14fdkgIz
	 pu7Q4UzcyuqkA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E0FE560078
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:36:41 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH,v8 3/7] netfilter: nfnetlink_queue: consolidate access to hook entries on reinjection
Date: Mon, 16 Nov 2026 01:36:30 +0100
Message-ID: <20261116003634.2819957-3-pablo@netfilter.org>
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

Fetch struct nf_hook_entries and nf_hook_ops only once then pass it on
to reinject path. Otherwise re-fetching the pointer breaks atomicity
when checking for the conntrack hook type since hook (un)registration
might occur while following nfqueue reinjection path.

This is a preparation patch, not behaviour change is intended.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v8: fetch nf_hook_ops only once not to break atomicity.

 net/netfilter/nfnetlink_queue.c | 69 ++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 9929240e819e..943dd35ff371 100644
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
+	hook = READ_ONCE(hooks[i]);
+
+	if (i >= hook_entries->num_hook_entries)
+		goto drop;
 
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
@@ -1890,6 +1914,24 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
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
+	hook = READ_ONCE(hooks[i]);
+
+	if (i >= hook_entries->num_hook_entries) {
+		kfree_skb_reason(entry->skb, SKB_DROP_REASON_NETFILTER_DROP);
+		nf_queue_entry_free(entry);
+		return -ENOENT;
+	}
+
 	/* rcu lock already held from nfnl->call_rcu. */
 	nfnl_ct = rcu_dereference(nfnl_ct_hook);
 
@@ -1924,7 +1966,8 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 	if (nfqa[NFQA_PRIORITY])
 		entry->skb->priority = ntohl(nla_get_be32(nfqa[NFQA_PRIORITY]));
 
-	nfqnl_reinject(entry, verdict);
+	__nfqnl_reinject(entry, hook_entries, hook, verdict);
+
 	return 0;
 }
 
-- 
2.47.3

