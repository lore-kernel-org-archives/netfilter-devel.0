Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51AF35AAC5
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Sep 2025 21:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756850122; cv=none; b=i52MYupZwdZlIro1lf7e4UmAk63XL7qexEZWgxPPPugQ3jDB9d8UvZmypLlzIdi34gKpaPoiAZxekOzOZ8UyL9YDJ2hYJCueYrwTatMqjslcuRqkpCRvKKy7jGzDQPQ8FtL7HKuGbnjxhTvoouO5GWV7Y0EnNzab0Jf6FeKkQ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756850122; c=relaxed/simple;
	bh=MPnlKuJEbxPSRlot/gHHoNf3E/ac1/MXYWGaE+zmVd4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kmKig30mErrtqsznHCPn1qLvps5mEwB+5qRupcdyWTqPIYiNyYI9RqT7TV0nc3P1VmFwEkCSGL9GrYUitg8l2ZOB2WjxtH2oTITe/03lTtOujB8eTEOfzDIQIsMg90ydT2ZQd5AVL0oyR1FfBa4jy/om8ecrK1gigB4QBJC3Jdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SjWgthGy; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjWgthGy"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-55f646b1db8so5701666e87.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Sep 2025 14:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756850118; x=1757454918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/jcBWv1fgxvj00kZYKbd/CKQ3ijtovJAbvJnjbTm+TQ=;
        b=SjWgthGytCOFY1fXzU0IMEH444pDruQTKGjjIVN89kCgmNnHW17cnh/Upe/2HdTaN+
         0JzapxX7jv9m5NuqjkUl/gus4X9d8giGlPyz07xgavRpCDfHRzBZao1TGOCzKIEXW0oE
         CQ4aqpBs679T0XDeR/fCc4tu5GPQ0M7rB1435VKK7GlGuZtRe1Yo+fXhNcKhgd/2f6Ek
         ADttxxMy735pqJy2Fy6Zwg1IrJxcMDLstQt6oLOriGmRmB3o2ZkXKz0NUezHqspq94/Q
         sZm2Y1Uz8Y9VCWysg6n0i1KpoQbKFt27QsH1EJQsu9sP87FD7aCBonfD35oUDqAgdLgS
         EpsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756850118; x=1757454918;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/jcBWv1fgxvj00kZYKbd/CKQ3ijtovJAbvJnjbTm+TQ=;
        b=pncx6jh68CWiuEK9YD6o9zaFfzVNbg0HF2vG27Lg7EM12bOV2hqyvWkKnBSZ3TWdIZ
         9mgNY7muQlGqDsWcCc1dbsvCnFHzlMIVa8ST+rYJSo+tLB75iQ81EPI/o/HUmEnE9s1c
         3CWGQKSy7QdKh7i5zPEVCJmd6QRrX+gDCHfGI1x6A42DhgbPUWR5pZRYfNTI0LQ6Sn0x
         fNMIV5sm1gAgygsLuiVETdGrvZQyNRdX47WDxTq2wrZ5Y2jI871R/0CPUPH28eoB5iuR
         2eZpiL4ucOHLnV1weYobvgU3gAM9MV2YXWAGPW6yF1rOEOl/kdgOAN1xSbXs5++Jv7QY
         z3QQ==
X-Gm-Message-State: AOJu0YznSO4pb2J6s1I+SKh+qVlcWvlv8jWvJP4rLD7saxho4V7q95ML
	RnZW2JzH3AOrST1DFo+6Sn53LB3tCFFX8bCuzI1rcLPBglAWyeMz98fjXJ4cObTdzsDviQ==
X-Gm-Gg: ASbGncv54C3MZNeVKhbokSfv83mJfiai2AVdpyCc3sARmNggIYbdkcuUSk1rhsxuV6l
	ZSxSqi8GzZ3dcxGnxVGD9qgXJuLKlruOjJwbQVG1uq6kFEBu9P0fEXrwT4RqkHrWVTTYhMiKuLz
	ITd0O5oBsM6Ml3gtFd0usQF1I9rNO2rA17zLWodkjBexoa8BjtJKDg/wP8oJGhyeek3Gc5hagmc
	LvpmcD8Ui+K1ENXZR+410vi+qgUAg4gGkEvQ9cDSIskkCMdeqc2zIA3RaD0M0pnXbU70Kb/7ruJ
	NVS8xGo0IgBXd6a8KxPlsz9a89FYxtnOZ4/bpHrqtEwd9y/aMdcBMyMhwF+yxrZJGE+yYptaMyK
	AUYX12FvmajNix0enS9UaY6sMe8SqqTLLvlAuxHinpCdBMbiplL2adUXRxfRRBzt2mAmo4vQIuE
	DnHhfLXWcHVMHe9oZI5FY=
X-Google-Smtp-Source: AGHT+IF9QXwrV1YSUzCmv8i/72KlouUq7spxub7bF86OGliMr9OTU21AExZRPXeeK6kQhROYlOrK7w==
X-Received: by 2002:a05:6512:2c09:b0:55b:92f9:c625 with SMTP id 2adb3069b0e04-55f708b70ccmr3474190e87.20.1756850117634;
        Tue, 02 Sep 2025 14:55:17 -0700 (PDT)
Received: from localhost.localdomain ([2001:464e:6820:0:bbbc:f1d0:63b4:a07])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5608ace7e22sm55739e87.76.2025.09.02.14.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 14:55:17 -0700 (PDT)
From: Nikolaos Gkarlis <nickgarlis@gmail.com>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	Nikolaos Gkarlis <nickgarlis@gmail.com>
Subject: [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack expressions in inet tables
Date: Tue,  2 Sep 2025 23:54:33 +0200
Message-Id: <20250902215433.75568-1-nickgarlis@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
References: <CA+jwDRkVb-qQq-PeYSF5HtLqTi9TTydrQh_OQF7tijiQ=Rh6iA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel allows netlink messages that use the legacy NFT_CT_SRC and
NFT_CT_DST keys in inet tables without an accompanying nft_meta
expression specifying NFT_META_NFPROTO. This results in ambiguous
conntrack expressions that cannot be reliably evaluated during packet
processing.

When that happens, the register size calculation defaults to IPv6 (16
bytes) regardless of the actual packet family.

This causes two issues:
1. For IPv4 packets, only 4 bytes contain valid address data while 12
   bytes contain uninitialized memory during comparison.
2. nft userspace cannot properly display these rules ([invalid type]).

The bug is not reproducible through standard nft commands, which use
NFT_CT_SRC_IP(6) and NFT_CT_DST_IP(6) keys when NFT_META_NFPROTO is
not defined.

Fix by adding a pointer to the parent nft_rule in nft_expr, allowing
iteration over preceding expressions to ensure that an nft_meta with
NFT_META_NFPROTO has been defined.

Signed-off-by: Nikolaos Gkarlis <nickgarlis@gmail.com>
---
Adding a pointer from nft_expr to nft_rule may be controversial, but
it was the only approach I could come up with that provides context
about preceding expressions when validating an expression.

I am not certain if this is the best way to handle it, but I am sending
the patch for review. Let me know if you would rather this handled
another way.

 include/net/netfilter/nf_tables.h |  2 ++
 include/net/netfilter/nft_meta.h  |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++---
 net/netfilter/nft_ct.c            | 21 +++++++++++++++++++++
 net/netfilter/nft_meta.c          |  3 ++-
 5 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 891e43a01bdc..4beb3aa46fe0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -403,10 +403,12 @@ struct nft_set_estimate {
  *	struct nft_expr - nf_tables expression
  *
  *	@ops: expression ops
+ *	@rule: rule this expression is contained in
  *	@data: expression private data
  */
 struct nft_expr {
 	const struct nft_expr_ops	*ops;
+	const struct nft_rule *rule;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(u64))));
 };
diff --git a/include/net/netfilter/nft_meta.h b/include/net/netfilter/nft_meta.h
index d602263590fe..93d987de78a6 100644
--- a/include/net/netfilter/nft_meta.h
+++ b/include/net/netfilter/nft_meta.h
@@ -51,4 +51,6 @@ void nft_meta_inner_eval(const struct nft_expr *expr,
 			 struct nft_regs *regs, const struct nft_pktinfo *pkt,
 			 struct nft_inner_tun_ctx *tun_ctx);
 
+extern const struct nft_expr_ops nft_meta_get_ops;
+
 #endif
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 58c5425d61c2..eab26b33d80e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3500,6 +3500,7 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 }
 
 static int nf_tables_newexpr(const struct nft_ctx *ctx,
+			     const struct nft_rule *rule,
 			     const struct nft_expr_info *expr_info,
 			     struct nft_expr *expr)
 {
@@ -3507,6 +3508,7 @@ static int nf_tables_newexpr(const struct nft_ctx *ctx,
 	int err;
 
 	expr->ops = ops;
+	expr->rule = rule;
 	if (ops->init) {
 		err = ops->init(ctx, expr, (const struct nlattr **)expr_info->tb);
 		if (err < 0)
@@ -3516,6 +3518,7 @@ static int nf_tables_newexpr(const struct nft_ctx *ctx,
 	return 0;
 err1:
 	expr->ops = NULL;
+	expr->rule = NULL;
 	return err;
 }
 
@@ -3530,6 +3533,7 @@ static void nf_tables_expr_destroy(const struct nft_ctx *ctx,
 }
 
 static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
+				      const struct nft_rule *rule,
 				      const struct nlattr *nla)
 {
 	struct nft_expr_info expr_info;
@@ -3550,7 +3554,7 @@ static struct nft_expr *nft_expr_init(const struct nft_ctx *ctx,
 	if (expr == NULL)
 		goto err_expr_stateful;
 
-	err = nf_tables_newexpr(ctx, &expr_info, expr);
+	err = nf_tables_newexpr(ctx, rule, &expr_info, expr);
 	if (err < 0)
 		goto err_expr_new;
 
@@ -4339,7 +4343,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	expr = nft_expr_first(rule);
 	for (i = 0; i < n; i++) {
-		err = nf_tables_newexpr(&ctx, &expr_info[i], expr);
+		err = nf_tables_newexpr(&ctx, rule, &expr_info[i], expr);
 		if (err < 0) {
 			NL_SET_BAD_ATTR(extack, expr_info[i].attr);
 			goto err_release_rule;
@@ -6681,7 +6685,7 @@ struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
 	struct nft_expr *expr;
 	int err;
 
-	expr = nft_expr_init(ctx, attr);
+	expr = nft_expr_init(ctx, NULL, attr);
 	if (IS_ERR(expr))
 		return expr;
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index d526e69a2a2b..b18bd5705872 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -22,6 +22,7 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nft_meta.h>
 
 struct nft_ct_helper_obj  {
 	struct nf_conntrack_helper *helper4;
@@ -440,6 +441,26 @@ static int nft_ct_get_init(const struct nft_ctx *ctx,
 			break;
 		case NFPROTO_IPV6:
 		case NFPROTO_INET:
+			const struct nft_expr *curr, *last;
+			bool meta_nfproto = false;
+			if (!expr->rule)
+				return -EINVAL;
+
+			nft_rule_for_each_expr(curr, last, expr->rule) {
+				if (curr == expr)
+					break;
+
+				if (curr->ops == &nft_meta_get_ops) {
+					const struct nft_meta *meta = nft_expr_priv(curr);
+					if (meta->key == NFT_META_NFPROTO) {
+						meta_nfproto = true;
+						break;
+					}
+				}
+			}
+			if (!meta_nfproto)
+				return -EINVAL;
+
 			len = sizeof_field(struct nf_conntrack_tuple,
 					   src.u3.ip6);
 			break;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 05cd1e6e6a2f..aa6bf05e3907 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -767,7 +767,7 @@ bool nft_meta_get_reduce(struct nft_regs_track *track,
 }
 EXPORT_SYMBOL_GPL(nft_meta_get_reduce);
 
-static const struct nft_expr_ops nft_meta_get_ops = {
+const struct nft_expr_ops nft_meta_get_ops = {
 	.type		= &nft_meta_type,
 	.size		= NFT_EXPR_SIZE(sizeof(struct nft_meta)),
 	.eval		= nft_meta_get_eval,
@@ -777,6 +777,7 @@ static const struct nft_expr_ops nft_meta_get_ops = {
 	.validate	= nft_meta_get_validate,
 	.offload	= nft_meta_get_offload,
 };
+EXPORT_SYMBOL_GPL(nft_meta_get_ops);
 
 static bool nft_meta_set_reduce(struct nft_regs_track *track,
 				const struct nft_expr *expr)
-- 
2.34.1

