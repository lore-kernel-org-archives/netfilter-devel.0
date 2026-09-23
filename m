Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0848549BD7D
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 12:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790166479; cv=none; b=sGtK8WK7n9ZD+w8X9QYM5bXzU4Vxmb+u7rQpOMsmqjCrFgaGjKacNuEdbtT/d3JjGaPsyoBaYLz0SqB7BDH4yar6zifHIi4JaZ9lWjSqIBlr2JGgIEtKN5segwu7THeWibUg12B7ZqjZBZBXWkpQYK+crXSpIIeKy/uR5EB+BJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790166479; c=relaxed/simple;
	bh=os1ZrQS8kNoYTpCi8/R2cjgGZbw8tIpGZQo+gb9Uzz8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=sz/AKCBNZebmg6xZlHJzQ+stfae1tULw/muavRsF+gwNP+OUUHBh4CWN2x3qWxkAdgZGtPg38sjeFSrBGsC4cXoF+aq/xTxWKZ7AZEuOPbrff9EhdXqgbCLcT0HSd5KSswqM5Jg62fTOTgYqFB/otbxXdNUzWFJDAKiayDKl38E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 774466038C; Wed, 23 Sep 2026 14:27:52 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 nf-next] netfilter: conntrack: add and use nf_ct_get_real()
Date: Wed, 23 Sep 2026 14:27:41 +0200
Message-ID: <20260923122741.30468-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Like nf_ct_get() but returns NULL in case skb is still associated
with a template conntrack object.

This patch doesn't fix crashes, hence no fixes tag, but the missing
template checks in these functions allow for undesireable resp.
non-deterministic behaviour.  Example:

1. netns A: "ct zone set N" attaches shared per-CPU template.
   Then, CONNMARK --set-mark .. (or any unguarded nf_ct_get() caller
   reachable before nf_conntrack_in consumes the template) writes
   ct->mark = 0x1 into that shared object.
2. nf_conntrack_in() later runs, consumes the template for netns
   A's real connection — but the shared per-CPU object's mark field still
   holds 0x1.
3. netns B, same CPU, next packet hitting ct zone set reuses that same
   object (oldcnt == 1 again) and gets zone reset, but mark is still 0x1
   from netns A until something explicitly overwrites it — visible to any
   subsequent ct mark read in netns B before it's set again.

Many places continue to use nf_ct_get(), because they fall into
one of the following categories:

1. They actually do want a template, (e.g defrag hook for zone info)
2. Already do check the template bit
3. Cannot see a template in the existing pipeline,
   e.g. NAT functions (template is removed in nf_conntrack_in),
   synproxy (its in INPUT hook, so after nf_conntrack_in).

net/sched is also left alone, I can't find a way to provide those places
with a conntrack template. act_ct sets one, but then calls
nf_conntrack_in() which consumes that template to make a real ct entry.

Same for OVS; I can't find a callpath that would result in arrival of
skb with a template conntrack.

Assisted-by: LLM
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: also convert nfnetlink_log and make nft_ct.c
 consistent with the xt_conntrack.c change, i.e.
 "templates don't even exist".

 include/net/netfilter/nf_conntrack.h | 12 ++++++++++++
 net/ipv4/netfilter/nf_socket_ipv4.c  |  2 +-
 net/ipv6/netfilter/nf_socket_ipv6.c  |  2 +-
 net/netfilter/nfnetlink_log.c        |  2 +-
 net/netfilter/nfnetlink_queue.c      |  4 ++--
 net/netfilter/nft_ct.c               |  4 ++--
 net/netfilter/nft_ct_fast.c          |  4 ++--
 net/netfilter/nft_flow_offload.c     |  2 +-
 net/netfilter/xt_CONNSECMARK.c       |  4 ++--
 net/netfilter/xt_HMARK.c             |  2 +-
 net/netfilter/xt_connbytes.c         |  2 +-
 net/netfilter/xt_connlabel.c         |  2 +-
 net/netfilter/xt_connmark.c          |  4 ++--
 net/netfilter/xt_conntrack.c         |  2 +-
 net/netfilter/xt_helper.c            |  2 +-
 net/netfilter/xt_ipvs.c              |  2 +-
 16 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index bc42dd0e10e6..eb55a4dc0d60 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -260,6 +260,18 @@ static inline int nf_ct_is_template(const struct nf_conn *ct)
 	return test_bit(IPS_TEMPLATE_BIT, &ct->status);
 }
 
+/* Like nf_ct_get(), but returns NULL for template conntracks. */
+static inline struct nf_conn *
+nf_ct_get_real(const struct sk_buff *skb, enum ip_conntrack_info *ctinfo)
+{
+	struct nf_conn *ct = nf_ct_get(skb, ctinfo);
+
+	if (ct && nf_ct_is_template(ct))
+		return NULL;
+
+	return ct;
+}
+
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int nf_ct_is_confirmed(const struct nf_conn *ct)
 {
diff --git a/net/ipv4/netfilter/nf_socket_ipv4.c b/net/ipv4/netfilter/nf_socket_ipv4.c
index f9c6755f5ec5..e3d0ae943bd4 100644
--- a/net/ipv4/netfilter/nf_socket_ipv4.c
+++ b/net/ipv4/netfilter/nf_socket_ipv4.c
@@ -130,7 +130,7 @@ struct sock *nf_sk_lookup_slow_v4(struct net *net, const struct sk_buff *skb,
 	 * case this is a reply packet of an established
 	 * SNAT-ted connection.
 	 */
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 	if (ct &&
 	    ((iph->protocol != IPPROTO_ICMP &&
 	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
diff --git a/net/ipv6/netfilter/nf_socket_ipv6.c b/net/ipv6/netfilter/nf_socket_ipv6.c
index 893f2aeb4711..71a61e3eed4b 100644
--- a/net/ipv6/netfilter/nf_socket_ipv6.c
+++ b/net/ipv6/netfilter/nf_socket_ipv6.c
@@ -145,7 +145,7 @@ struct sock *nf_sk_lookup_slow_v6(struct net *net, const struct sk_buff *skb,
 	 * case this is a reply packet of an established
 	 * SNAT-ted connection.
 	 */
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 	if (ct &&
 	    ((tproto != IPPROTO_ICMPV6 &&
 	      ctinfo == IP_CT_ESTABLISHED_REPLY) ||
diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index d923f2cb1398..dddbaf6860cc 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -787,7 +787,7 @@ nfulnl_log_packet(struct net *net,
 	if (inst->flags & NFULNL_CFG_F_CONNTRACK) {
 		nfnl_ct = rcu_dereference(nfnl_ct_hook);
 		if (nfnl_ct != NULL) {
-			ct = nf_ct_get(skb, &ctinfo);
+			ct = nf_ct_get_real(skb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index c727668b0c5b..607fe0549d5c 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -786,7 +786,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	if (queue->flags & NFQA_CFG_F_CONNTRACK) {
 		if (nfnl_ct != NULL) {
-			ct = nf_ct_get(entskb, &ctinfo);
+			ct = nf_ct_get_real(entskb, &ctinfo);
 			if (ct != NULL)
 				size += nfnl_ct->build_size(ct);
 		}
@@ -1730,7 +1730,7 @@ static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	struct nf_conn *ct;
 
-	ct = nf_ct_get(entry->skb, ctinfo);
+	ct = nf_ct_get_real(entry->skb, ctinfo);
 	if (ct == NULL)
 		return NULL;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 3c4c2faa7398..211a4624761a 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -62,7 +62,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 	const struct nf_conntrack_helper *helper;
 	unsigned int state;
 
-	ct = nf_ct_get(pkt->skb, &ctinfo);
+	ct = nf_ct_get_real(pkt->skb, &ctinfo);
 
 	switch (priv->key) {
 	case NFT_CT_STATE:
@@ -78,7 +78,7 @@ static void nft_ct_get_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (!ct || nf_ct_is_template(ct))
+	if (!ct)
 		goto err;
 
 	switch (priv->key) {
diff --git a/net/netfilter/nft_ct_fast.c b/net/netfilter/nft_ct_fast.c
index a44524c4fe63..3f0390fe08e6 100644
--- a/net/netfilter/nft_ct_fast.c
+++ b/net/netfilter/nft_ct_fast.c
@@ -14,7 +14,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 	const struct nf_conn *ct;
 	unsigned int state;
 
-	ct = nf_ct_get(pkt->skb, &ctinfo);
+	ct = nf_ct_get_real(pkt->skb, &ctinfo);
 
 	switch (priv->key) {
 	case NFT_CT_STATE:
@@ -30,7 +30,7 @@ void nft_ct_get_fast_eval(const struct nft_expr *expr,
 		break;
 	}
 
-	if (!ct || nf_ct_is_template(ct)) {
+	if (!ct) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..1ab1ad2b3c3b 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -64,7 +64,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (nft_flow_offload_skip(pkt->skb, nft_pf(pkt)))
 		goto out;
 
-	ct = nf_ct_get(pkt->skb, &ctinfo);
+	ct = nf_ct_get_real(pkt->skb, &ctinfo);
 	if (!ct)
 		goto out;
 
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 1494b3ee30e1..264982fa1977 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -35,7 +35,7 @@ static void secmark_save(const struct sk_buff *skb)
 		struct nf_conn *ct;
 		enum ip_conntrack_info ctinfo;
 
-		ct = nf_ct_get(skb, &ctinfo);
+		ct = nf_ct_get_real(skb, &ctinfo);
 		if (ct && !ct->secmark) {
 			ct->secmark = skb->secmark;
 			nf_conntrack_event_cache(IPCT_SECMARK, ct);
@@ -53,7 +53,7 @@ static void secmark_restore(struct sk_buff *skb)
 		const struct nf_conn *ct;
 		enum ip_conntrack_info ctinfo;
 
-		ct = nf_ct_get(skb, &ctinfo);
+		ct = nf_ct_get_real(skb, &ctinfo);
 		if (ct && ct->secmark)
 			skb->secmark = ct->secmark;
 	}
diff --git a/net/netfilter/xt_HMARK.c b/net/netfilter/xt_HMARK.c
index 8928ec56c388..f4c8915d921d 100644
--- a/net/netfilter/xt_HMARK.c
+++ b/net/netfilter/xt_HMARK.c
@@ -79,7 +79,7 @@ hmark_ct_set_htuple(const struct sk_buff *skb, struct hmark_tuple *t,
 {
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	enum ip_conntrack_info ctinfo;
-	struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+	struct nf_conn *ct = nf_ct_get_real(skb, &ctinfo);
 	struct nf_conntrack_tuple *otuple;
 	struct nf_conntrack_tuple *rtuple;
 
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 1c6ffc7f1622..fedbcc4c81a0 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -30,7 +30,7 @@ connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct nf_conn_acct *acct;
 	const struct nf_conn_counter *counters;
 
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 	if (!ct)
 		return false;
 
diff --git a/net/netfilter/xt_connlabel.c b/net/netfilter/xt_connlabel.c
index 87505cdad5f1..a309caae9f84 100644
--- a/net/netfilter/xt_connlabel.c
+++ b/net/netfilter/xt_connlabel.c
@@ -25,7 +25,7 @@ connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	struct nf_conn *ct;
 	bool invert = info->options & XT_CONNLABEL_OP_INVERT;
 
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 	if (ct == NULL)
 		return invert;
 
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 2cf27f7d59b9..38f0e6af94af 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -32,7 +32,7 @@ connmark_tg_shift(struct sk_buff *skb, const struct xt_connmark_tginfo2 *info)
 	u_int32_t newmark;
 	u_int32_t oldmark;
 
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 	if (ct == NULL)
 		return XT_CONTINUE;
 
@@ -134,7 +134,7 @@ connmark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 	if (ct == NULL)
 		return false;
 
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index ea299da24734..0122a0b31fac 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -167,7 +167,7 @@ conntrack_mt(const struct sk_buff *skb, struct xt_action_param *par,
 	const struct nf_conn *ct;
 	unsigned int statebit;
 
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 
 	if (ct)
 		statebit = XT_CONNTRACK_STATE_BIT(ctinfo);
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index a5a167f941e0..f0a6eed39f8a 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -30,7 +30,7 @@ helper_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	enum ip_conntrack_info ctinfo;
 	bool ret = info->invert;
 
-	ct = nf_ct_get(skb, &ctinfo);
+	ct = nf_ct_get_real(skb, &ctinfo);
 	if (!ct || !ct->master)
 		return ret;
 
diff --git a/net/netfilter/xt_ipvs.c b/net/netfilter/xt_ipvs.c
index e13c0ffb73a9..2c92e40ffc5f 100644
--- a/net/netfilter/xt_ipvs.c
+++ b/net/netfilter/xt_ipvs.c
@@ -115,7 +115,7 @@ ipvs_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (data->bitmask & XT_IPVS_DIR) {
 		enum ip_conntrack_info ctinfo;
-		struct nf_conn *ct = nf_ct_get(skb, &ctinfo);
+		struct nf_conn *ct = nf_ct_get_real(skb, &ctinfo);
 
 		if (ct == NULL) {
 			match = false;
-- 
2.55.0

