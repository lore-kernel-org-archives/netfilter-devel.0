Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794789463;
	b=W2fFn4ZOTPBnGaZW+lodEvZ7L1iQcMaHxG6CrFHs2QR/XmW2pd6JmS4XMhyMUvDlxjiF
	 WDqKM81IPSmuzIw6go+JcsHXUi2LrPONdC+Wv3B7b7wjAqm+LnNvrfVjUntaQqi465yqT
	 rE+JRF5Y5ptvIMowcu/4dfb8HcEGnldJaiOe35LQMeIn38jfAUnNpCsogV2SzCCLeL7m+
	 OJfze7gAV8yWquXPxyAMTghai4oQCwD3ByWo9zgNMOO260v5qqIsg7tgnu6LHebSiEkvn
	 4O0TCYQNK0s+V96IVFnwzvBkUiU66vsm3n0rpnD3+AM5R663HVQVTMz+Xgzs3WctnNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794789463;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=m/mH7pIFb+fzfU4oaMcwzL3Cqz5q+fnBitYQl7P3CXU=;
	b=gV8OW5yWDMn9nGad8MsnzpykoQd0+XNnGMID3p2V7Y7AEN4ffMCMNRnkrzqz+GZyTLx/
	 49MZ5Y88B2Iqe9E4XwSZjIzCGlnKcPfNY5CfgfC3vlDvreaP678zKHP2XWvG3m37uaVDN
	 s2PYq2hKJpjTHv2kAoYksEI+PkjakRM2A5HZh6Wjefwz/9a5G7L2MIE9XVBv1rwMHs6eo
	 aq5XimI3FF84Y4/fpy0VXre03mDLI85sakjaW7GRStydGvCouqu1OyUm5kcmQZpBrQ0aA
	 dcN4Zw9YtKrvmy2ZmCsXw3wgeJztBb6no2wSt6vwUa7YfZF0t9XsAJruDVxlRdPxnSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XVnXynPm;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1D1606A329
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 00:37:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BC1D1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=XVnXynPm
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794789460;
	bh=m/mH7pIFb+fzfU4oaMcwzL3Cqz5q+fnBitYQl7P3CXU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=XVnXynPmhTpxYSdUTWXIld6hYiVd9UoptkgVMX3OAVWqYKDptCCCL9mdTwCKmQjW6
	 OPYwbKEVtiF4as6m5hRVU1pKaTz5rimI/HzoOyDoQd7k8J/yLsukrMwt/Cakk5UgrQ
	 5HB96YHcE09OT3fWkkVdI7X73Ldh65uOxoKC6mniTjfluQzRGm4Mnw/SopXXlCdtl8
	 5KLij+8icIIh61T7nzAjzm4OILDjcfEbQEKSZQB9POQ9ZF5GFZGhmS9/jFhwl5GpFx
	 j7XGFsH1cgcfSNMTbKBQHej+R8QFWz6L0SP/wBWbt0sWaQmIBw3n63dv5rWHu3EVnE
	 GTzgcX26aGN/g==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id B00A660076
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Nov 2026 01:37:40 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v8 3/7] netfilter: nfnetlink_queue: consolidate access to hook entries on reinjection
Date: Mon, 16 Nov 2026 01:37:29 +0100
Message-ID: <20261116003733.2820132-3-pablo@netfilter.org>
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

