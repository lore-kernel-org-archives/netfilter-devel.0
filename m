Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30014400967
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 11:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785410810; cv=none; b=EymQCVdxg/zzdW+FoRp3J42nk/usa+HD3v8kCtvuyZCmsU1lMRf//KKLy2hItKeGqdNWPOxPCdmqyUUotfXoxTPXUbcd4txzXCwT1BZOJESAVK8+WckhoyMdHWoEdOh0WL1bx8kcFqDiEFc3XfIoVQ2gqSiKQ4PHhg4D1F11pKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785410810; c=relaxed/simple;
	bh=z5/IU32Wl72bB+EupB+jTYfeOOLwqpd7gc/zRUbmLE0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=I4l0QTnQiTmufUn94+1y0pgo01oqoeanvZiJH1iPcR4YTFQohqehqekCkRJCAvq0owSrquhaks2KyuyknY18JL1AEN8hdXOIUXm4GAocvklGFe3XmsiBsuZ9EIE5mwb/BeRmlOHbwhvT6QUHgYyzlqWNNbgbhPk723nlb0RISw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XzbwaSd6; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XzbwaSd6"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6FC8A602B4
	for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2026 13:26:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785410806;
	bh=5oZtI05VcivCrFZbjVgy7SrNuZ0BIKngQk57UJwstPE=;
	h=From:To:Subject:Date:From;
	b=XzbwaSd6SXpUrv5EKrvN6VegJey8k33PkA+VB0ljeVEqeYX2+9ANmgtpAEyvOIhry
	 p2eCnuSZbEBpBc/iS8xeaWy3dkbM05NWN/lXx3gi68Y68mItcPmkTdmrnF1dFz48b/
	 QqslIDFr/7txeuqUryf+jWXub1vGmS5nJPQzJuQCpBrvpqEBfX3uayhvcPIYM9VfK6
	 bdSKWmzmkShtcJNR9q6eO6Vyfiguzx8oC/YXlGIJa3TvIWmyIHp6WB5jj9zga2Tfeu
	 Lunz5AH5hOq92nsJIUpeLH/CGmpAclwRGwyCLePksOl0WSQuaAAZnyGqKrMz17Yx41
	 XKOcjYml0AkAA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2] netfilter: nft_ct: postpone expectation creation to confirmed conntrack
Date: Thu, 30 Jul 2026 13:26:40 +0200
Message-ID: <20260730112640.498919-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Originally, the ct expectation support called nf_ct_helper_ext_add() for
confirmed conntracks, which is invalid, triggering a splat. This was
fixed by commit 1710eb913bdc ("netfilter: nft_ct: skip expectations for
confirmed conntrack").

This is still not sufficient though. Early insertion of expectations
into the expectations list, which resides in the ct helper extension
area might lead to stale entries pointing to the wrong hlist_head
through .pprev due to ct extension reallocation.

Commit 7c9664351980 ("netfilter: move nat hlist_head to nf_conn") moved
the nat hlist_head to nf_conn for this reason:

     1. ...
     2. When reallocation of extension area occurs we need to fixup the
        bysource hash head via hlist_replace_rcu.

However, I'd rather not to increase the size of the struct nf_conn for
this feature, which only supports for creating expectations in the reply
direction, which restricts its usecase. Note that ct expectation is also
broken with NAT, where the ct needs to be confirmed to access dnat
mappings.

Remove the code to check for the expectation size per master, this
intentionally restricts it to one single expectation per master
conntrack after the conntrack has been confirmed.

To address this issue, add the ct helper extension on the first packet
matching this rule. Then, follow up packets will find the conntrack
already in confirmed state with stable expectations list in the a ct
helper extension area that can be used for creating the custom
expectation.

This patch adds a new flag to annotate that the expectation for this
rule has been already created once for this connection.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Reported-by: Jaeyeong Lee <iostreampy@proton.me>
Link: https://patch.msgid.link/20260715144755.00ea7dfcd9f@proton.me
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - clear_bit in case expectation allocation fails.
    - continue rule evaluation when creating ct helper extension.
    - expand commit description.

 net/netfilter/nft_ct.c | 41 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 34 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 03a88c77e0f0..1f6691a36c05 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1226,6 +1226,10 @@ static int nft_ct_expect_timeout_get(const struct nlattr *attr, u32 *val)
 	return 0;
 }
 
+struct nft_ct_expect_data {
+	unsigned long	flags;
+};
+
 static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 				  const struct nlattr * const tb[],
 				  struct nft_object *obj)
@@ -1233,6 +1237,8 @@ static int nft_ct_expect_obj_init(const struct nft_ctx *ctx,
 	struct nft_ct_expect_obj *priv = nft_obj_data(obj);
 	int err;
 
+	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nft_ct_expect_data));
+
 	if (!tb[NFTA_CT_EXPECT_L4PROTO] ||
 	    !tb[NFTA_CT_EXPECT_DPORT] ||
 	    !tb[NFTA_CT_EXPECT_TIMEOUT] ||
@@ -1297,11 +1303,14 @@ static int nft_ct_expect_obj_dump(struct sk_buff *skb,
 	return 0;
 }
 
+#define NFT_CT_EXPECT_DONE_BIT	0
+
 static void nft_ct_expect_obj_eval(struct nft_object *obj,
 				   struct nft_regs *regs,
 				   const struct nft_pktinfo *pkt)
 {
 	const struct nft_ct_expect_obj *priv = nft_obj_data(obj);
+	struct nft_ct_expect_data *expect_data;
 	struct nf_conntrack_expect *exp;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn_help *help;
@@ -1310,40 +1319,58 @@ static void nft_ct_expect_obj_eval(struct nft_object *obj,
 	struct nf_conn *ct;
 
 	ct = nf_ct_get(pkt->skb, &ctinfo);
-	if (!ct || nf_ct_is_confirmed(ct) || nf_ct_is_template(ct)) {
+	if (!ct || nf_ct_is_template(ct)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
-	dir = CTINFO2DIR(ctinfo);
 
 	help = nfct_help(ct);
-	if (!help)
-		help = nf_ct_helper_ext_add(ct, GFP_ATOMIC);
 	if (!help) {
-		regs->verdict.code = NF_DROP;
+		if (!nf_ct_is_confirmed(ct)) {
+			nf_ct_helper_ext_add(ct, GFP_ATOMIC);
+			return;
+		}
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	/* Disallow adding expectations if there is a helper. */
+	if (rcu_access_pointer(help->helper)) {
+		regs->verdict.code = NFT_BREAK;
+		return;
+	}
+
+	expect_data = nfct_help_data(ct);
+	if (!expect_data) {
+		regs->verdict.code = NFT_BREAK;
 		return;
 	}
 
-	if (help->expecting[NF_CT_EXPECT_CLASS_DEFAULT] >= priv->size) {
+	if (test_and_set_bit(NFT_CT_EXPECT_DONE_BIT, &expect_data->flags)) {
 		regs->verdict.code = NFT_BREAK;
 		return;
 	}
+
 	if (l3num == NFPROTO_INET)
 		l3num = nf_ct_l3num(ct);
 
 	exp = nf_ct_expect_alloc(ct);
 	if (exp == NULL) {
 		regs->verdict.code = NF_DROP;
+		clear_bit(NFT_CT_EXPECT_DONE_BIT, &expect_data->flags);
 		return;
 	}
+	dir = CTINFO2DIR(ctinfo);
 	nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, l3num,
 		          &ct->tuplehash[!dir].tuple.src.u3,
 		          &ct->tuplehash[!dir].tuple.dst.u3,
 		          priv->l4proto, NULL, &priv->dport);
 	exp->timeout += priv->timeout;
 
-	if (nf_ct_expect_related(exp, 0) != 0)
+	if (nf_ct_expect_related(exp, 0) != 0) {
 		regs->verdict.code = NF_DROP;
+		clear_bit(NFT_CT_EXPECT_DONE_BIT, &expect_data->flags);
+	}
 
 	nf_ct_expect_put(exp);
 }
-- 
2.47.3

