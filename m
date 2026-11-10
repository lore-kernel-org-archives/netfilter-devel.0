Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.70.190.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794347687;
	b=LTrRwX5BcpmTTetCq3UGBB4MvcUT+dM0x+bzpE3RguFhzZ5SpnBsGxsvNrvQvrwcHWXv
	 BUY2y5q0KTJAyYPKzbHzFn6YcEwPVONOU12sYk/c0zBhuAPNtGAC84C/kr/1SJYR/Othz
	 KqvHbY0cYxD5K/wUirxJ/51rNF/dzO53uPWg760opURdV4nVWo1nTe3EVRN3ODqgL7xyp
	 5Eayi8hIAcsUvlg1B3LTgYFZuNASWh0AKfxxJbLX2776tLlDK9gGgUhFnoX4M1UgUCl34
	 tS9m2FJT2kePnFPE5nVDREL1wJkcE3grvy+aeVZBuXNP1gdNLtBuOXe9q4sqgVZyt/A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794347687;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-Spam-Status:X-Spam-Checker-Version;
	bh=fdKTawZSx5bM8iM1ycgm0thaTNOwEFHHJsl9WSHeYyI=;
	b=BD+UVlLqcdfJJbQZjHLV+5Z6h02+yDyNeRa0KYkT3qnxnrvOENMwQ1KP01is+kEG9BI2
	 UT1LdXpehry1brpd0UNpvgx/X66yutAisMW4/k3H+BNdKKC0SbUg6MvO2KaeIMsyuf7Cx
	 kvyhmymWxFQIGQ+zSa/IqPoo5aB7yDxRDYVdD7bDP4TxU2spev0DJ5M+brKzpwpQ6ha29
	 a1VVolMjaqjApGfqm0XQ/PxdTdqzJxJRQPnAFWqbf8hgasW8iVydzaD3+rToBJbaA3Qqw
	 aLxjxYRWjNvs7eF9ue3+fm3rcnEvDrNqDza1odPR2UamoicxaEkHrOM5tvXyZJiM6bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=netfilter.org;
	spf=pass smtp.mailfrom=netfilter.org;
	dkim=pass header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IaZ5jqqx;
	arc=none smtp.remote-ip=217.70.190.124
Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC71C606A320
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 21:54:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC71C606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.a=rsa-sha256 header.s=2025 header.b=IaZ5jqqx
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1794347685;
	bh=fdKTawZSx5bM8iM1ycgm0thaTNOwEFHHJsl9WSHeYyI=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IaZ5jqqxs/e9EU0NqQdymuYbiJ9hJoSOu0/fE4/gpXCkQyBEV4Prfxo2rUKOUALwB
	 p5TZwa5ye7AAcOeA9f3cbsGLWgvN5WE54vBk0nxy4pnbFqUmx/dRcSsk4469PvMGHu
	 C6o/BpfmtVHcLXlQeIrOHmubFxD9EKgyLhYnck2dDF3uluc/tzgjwdXOBDpuB64JHS
	 RidVWIiYiC+WF6+JSv/6gxOVe8IY4TDh+upxk0Yi4458kHLqJCW8OBD+JdVcY1SMAz
	 USilDF/xYH8z5lm6q8Ed9tzld5GgS9induo3PywTJwA/uMYr+pHWwI0NTZHfpY/p7w
	 fDPGAFCZNYuwA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4310860305
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Nov 2026 22:54:45 +0100 (CET)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v6 3/7] netfilter: nfnetlink_queue: consolidate access to hook entries on reinjection
Date: Tue, 10 Nov 2026 22:54:35 +0100
Message-ID: <20261110215439.1958120-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110215439.1958120-1-pablo@netfilter.org>
References: <20261110215439.1958120-1-pablo@netfilter.org>
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
v6: new in this series

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

