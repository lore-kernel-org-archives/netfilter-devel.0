Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C094C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15EBD22519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfKTNTE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:04 -0500
Received: from correo.us.es ([193.147.175.20]:49294 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfKTNTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6D854130E23
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5DDC9DA7B6
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 53873B8009; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3D7A4B7FF6
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2114842EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/7] netfilter: nf_tables: pass nft_object_ref to object evaluation function
Date:   Wed, 20 Nov 2019 14:18:51 +0100
Message-Id: <20191120131854.308740-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191120131854.308740-1-pablo@netfilter.org>
References: <20191120131854.308740-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This update comes in preparation to pass operation type on the object as
a follow patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nft_connlimit.c     |  4 ++--
 net/netfilter/nft_counter.c       |  4 ++--
 net/netfilter/nft_ct.c            | 12 ++++++------
 net/netfilter/nft_limit.c         |  8 ++++----
 net/netfilter/nft_meta.c          |  5 +++--
 net/netfilter/nft_objref.c        |  6 ++++--
 net/netfilter/nft_quota.c         |  3 ++-
 net/netfilter/nft_synproxy.c      |  4 ++--
 net/netfilter/nft_tunnel.c        |  4 ++--
 10 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 04c3b2e7eb99..413eb650bafd 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1137,7 +1137,7 @@ struct nft_object_ref {
  *	@update: update stateful object
  */
 struct nft_object_ops {
-	void				(*eval)(struct nft_object *obj,
+	void				(*eval)(struct nft_object_ref *ref,
 						struct nft_regs *regs,
 						const struct nft_pktinfo *pkt);
 	unsigned int			size;
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 69d6173f91e2..838b5e62e36c 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -105,11 +105,11 @@ static int nft_connlimit_do_dump(struct sk_buff *skb,
 	return -1;
 }
 
-static inline void nft_connlimit_obj_eval(struct nft_object *obj,
+static inline void nft_connlimit_obj_eval(struct nft_object_ref *ref,
 					struct nft_regs *regs,
 					const struct nft_pktinfo *pkt)
 {
-	struct nft_connlimit *priv = nft_obj_data(obj);
+	struct nft_connlimit *priv = nft_obj_data(ref->obj);
 
 	nft_connlimit_do_eval(priv, regs, pkt, NULL);
 }
diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index f6d4d0fa23a6..e9d5cab5f189 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -45,11 +45,11 @@ static inline void nft_counter_do_eval(struct nft_counter_percpu_priv *priv,
 	local_bh_enable();
 }
 
-static inline void nft_counter_obj_eval(struct nft_object *obj,
+static inline void nft_counter_obj_eval(struct nft_object_ref *ref,
 					struct nft_regs *regs,
 					const struct nft_pktinfo *pkt)
 {
-	struct nft_counter_percpu_priv *priv = nft_obj_data(obj);
+	struct nft_counter_percpu_priv *priv = nft_obj_data(ref->obj);
 
 	nft_counter_do_eval(priv, regs, pkt);
 }
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 46ca8bcca1bd..be486c8bf6a7 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -823,11 +823,11 @@ struct nft_ct_timeout_obj {
 	u8			l4proto;
 };
 
-static void nft_ct_timeout_obj_eval(struct nft_object *obj,
+static void nft_ct_timeout_obj_eval(struct nft_object_ref *ref,
 				    struct nft_regs *regs,
 				    const struct nft_pktinfo *pkt)
 {
-	const struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
+	const struct nft_ct_timeout_obj *priv = nft_obj_data(ref->obj);
 	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
 	struct nf_conn_timeout *timeout;
 	const unsigned int *values;
@@ -1059,11 +1059,11 @@ static void nft_ct_helper_obj_destroy(const struct nft_ctx *ctx,
 	nf_ct_netns_put(ctx->net, ctx->family);
 }
 
-static void nft_ct_helper_obj_eval(struct nft_object *obj,
+static void nft_ct_helper_obj_eval(struct nft_object_ref *ref,
 				   struct nft_regs *regs,
 				   const struct nft_pktinfo *pkt)
 {
-	const struct nft_ct_helper_obj *priv = nft_obj_data(obj);
+	const struct nft_ct_helper_obj *priv = nft_obj_data(ref->obj);
 	struct nf_conn *ct = (struct nf_conn *)skb_nfct(pkt->skb);
 	struct nf_conntrack_helper *to_assign = NULL;
 	struct nf_conn_help *help;
@@ -1207,11 +1207,11 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	return 0;
 }
 
-static void nft_ct_expect_obj_eval(struct nft_object *obj,
+static void nft_ct_expect_obj_eval(struct nft_object_ref *ref,
 				   struct nft_regs *regs,
 				   const struct nft_pktinfo *pkt)
 {
-	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	const struct nft_ct_expect_obj *priv = nft_obj_data(ref->obj);
 	struct nf_conntrack_expect *exp;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_help *help;
diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index 35b67d7e3694..6f5ffecb83fd 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -236,11 +236,11 @@ static struct nft_expr_type nft_limit_type __read_mostly = {
 	.owner		= THIS_MODULE,
 };
 
-static void nft_limit_obj_pkts_eval(struct nft_object *obj,
+static void nft_limit_obj_pkts_eval(struct nft_object_ref *ref,
 				    struct nft_regs *regs,
 				    const struct nft_pktinfo *pkt)
 {
-	struct nft_limit_pkts *priv = nft_obj_data(obj);
+	struct nft_limit_pkts *priv = nft_obj_data(ref->obj);
 
 	if (nft_limit_eval(&priv->limit, priv->cost))
 		regs->verdict.code = NFT_BREAK;
@@ -279,11 +279,11 @@ static const struct nft_object_ops nft_limit_obj_pkts_ops = {
 	.dump		= nft_limit_obj_pkts_dump,
 };
 
-static void nft_limit_obj_bytes_eval(struct nft_object *obj,
+static void nft_limit_obj_bytes_eval(struct nft_object_ref *ref,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	struct nft_limit *priv = nft_obj_data(obj);
+	struct nft_limit *priv = nft_obj_data(ref->obj);
 	u64 cost = div64_u64(priv->nsecs * pkt->skb->len, priv->rate);
 
 	if (nft_limit_eval(priv, cost))
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 8fbea031bd4a..419fb1e42885 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -639,10 +639,11 @@ static int nft_secmark_compute_secid(struct nft_secmark *priv)
 	return 0;
 }
 
-static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs,
+static void nft_secmark_obj_eval(struct nft_object_ref *ref,
+				 struct nft_regs *regs,
 				 const struct nft_pktinfo *pkt)
 {
-	const struct nft_secmark *priv = nft_obj_data(obj);
+	const struct nft_secmark *priv = nft_obj_data(ref->obj);
 	struct sk_buff *skb = pkt->skb;
 
 	skb->secmark = priv->secid;
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index c9d8543fc97c..21ef987d5ac4 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -17,7 +17,7 @@ static void nft_objref_eval(const struct nft_expr *expr,
 {
 	struct nft_object_ref *priv = nft_expr_priv(expr);
 
-	priv->obj->ops->eval(priv->obj, regs, pkt);
+	priv->obj->ops->eval(priv, regs, pkt);
 }
 
 static int nft_objref_init(const struct nft_ctx *ctx,
@@ -108,6 +108,7 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 	struct nft_objref_map *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext;
+	struct nft_object_ref ref;
 	struct nft_object *obj;
 	bool found;
 
@@ -118,7 +119,8 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 		return;
 	}
 	obj = *nft_set_ext_obj(ext);
-	obj->ops->eval(obj, regs, pkt);
+	ref.obj = obj;
+	obj->ops->eval(&ref, regs, pkt);
 }
 
 static int nft_objref_map_init(const struct nft_ctx *ctx,
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 4413690591f2..17e6cab3dfad 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -46,10 +46,11 @@ static const struct nla_policy nft_quota_policy[NFTA_QUOTA_MAX + 1] = {
 
 #define NFT_QUOTA_DEPLETED_BIT	1	/* From NFT_QUOTA_F_DEPLETED. */
 
-static void nft_quota_obj_eval(struct nft_object *obj,
+static void nft_quota_obj_eval(struct nft_object_ref *ref,
 			       struct nft_regs *regs,
 			       const struct nft_pktinfo *pkt)
 {
+	struct nft_object *obj = ref->obj;
 	struct nft_quota *priv = nft_obj_data(obj);
 	bool overquota;
 
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index e2c1fc608841..2d43db7788ae 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -319,11 +319,11 @@ static int nft_synproxy_obj_dump(struct sk_buff *skb,
 	return nft_synproxy_do_dump(skb, priv);
 }
 
-static void nft_synproxy_obj_eval(struct nft_object *obj,
+static void nft_synproxy_obj_eval(struct nft_object_ref *ref,
 				  struct nft_regs *regs,
 				  const struct nft_pktinfo *pkt)
 {
-	const struct nft_synproxy *priv = nft_obj_data(obj);
+	const struct nft_synproxy *priv = nft_obj_data(ref->obj);
 
 	nft_synproxy_do_eval(priv, regs, pkt);
 }
diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 3d4c2ae605a8..5fee55aa981e 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -421,11 +421,11 @@ static int nft_tunnel_obj_init(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static inline void nft_tunnel_obj_eval(struct nft_object *obj,
+static inline void nft_tunnel_obj_eval(struct nft_object_ref *ref,
 				       struct nft_regs *regs,
 				       const struct nft_pktinfo *pkt)
 {
-	struct nft_tunnel_obj *priv = nft_obj_data(obj);
+	struct nft_tunnel_obj *priv = nft_obj_data(ref->obj);
 	struct sk_buff *skb = pkt->skb;
 
 	skb_dst_drop(skb);
-- 
2.11.0

