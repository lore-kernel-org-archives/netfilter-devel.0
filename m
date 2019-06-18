Return-Path: <SRS0=xYYy=UR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF0B5C31E5D
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 08:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B84320B1F
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jun 2019 08:47:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BtCOpJRI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729246AbfFRIrJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jun 2019 04:47:09 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35095 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728991AbfFRIrI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jun 2019 04:47:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id c6so2274529wml.0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 01:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=uRvPRon+/9GwuuOrISxuVh9HqQkxMvCxxSKchNQiRHg=;
        b=BtCOpJRIb0wFNG/algB+/5p99qVqfJHhj7/abpSazsVLtg8nDUH8Lob+rVnhpIvcQl
         uNtqisyjzeiZyS6J+KVLC6XQk63OGll3wEaSMSCOc65VHnKHwgXESvG9piqhHpIfJ9HX
         4H1SZO6RI1DqRWd8WOVWnJEUa0B3DThpKkWer5wEx3UN+0gkijN2sVzUtGk0LXmjIutQ
         wohCtxldZ2HMgsD30+xvJUMOPDw+d9GKj6rbjjEDC4Sq0q68lgVNX1/3k7DraDILlsWD
         bFChmTHTlB8mxrfSfSyBAinv6+bPWcwqZFlj9bVzXTzgEo3YI8HIw9BR3xRQCt6hiXks
         7ZPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=uRvPRon+/9GwuuOrISxuVh9HqQkxMvCxxSKchNQiRHg=;
        b=B2SzR0UJJT1lCy9VK7mJ5eigAdAIXEZevRmJfeC63ukoknXgjMoWJ1P6UvYP5oYE7u
         cO4NYFVG0HQS9gdFB7As8uQ3V5R0KwzUQcYU+m/R8iVix5MM53oGFSb7FiPyCKgtdoAo
         diGtltjptMYvt+xi8jmrw5FT7RgVitsDz6P5VKk/KD0SKNhX8XtLAns/D1FlKrthe8uH
         +BiuljSTZDSNN3zByB6Rx7syrkpIDEqnooKJKPVf6HNjw4tm/H1Q6QhUsNGbuui3pLLJ
         bsIYdAvZrNmqDplGneMfSG7CJMlgmoJ4lvF/BLtEzYMyQb6CjyXLdtPKO8dMENi19vi5
         BvNw==
X-Gm-Message-State: APjAAAVJvMYWHT3f4w62tCDsNfNf+tidvsaQbAMyC9yRDBP5cGsTxWAx
        1vXDvSxqqHS9elHBg09PGs+ICMfQ
X-Google-Smtp-Source: APXvYqy7P4JwBrdFmrSOAPhzDOhJQAaxK87pDEt1fdRiHEsUG/MR6Xjk0XztCD+2d02h6rQKj9aj9A==
X-Received: by 2002:a1c:3942:: with SMTP id g63mr2189472wma.61.1560847626390;
        Tue, 18 Jun 2019 01:47:06 -0700 (PDT)
Received: from nevthink ([46.6.171.188])
        by smtp.gmail.com with ESMTPSA id c4sm16938556wrb.68.2019.06.18.01.47.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Jun 2019 01:47:05 -0700 (PDT)
Date:   Tue, 18 Jun 2019 10:47:03 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH v2 nf-next] netfilter: enable set expiration date for set
 elements
Message-ID: <20190618084703.wdsnmcsa3l74osob@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, the expiration of every element in a set or map
is a read-only parameter generated at kernel side.

This change will permit to set a certain expiration date
per element that will be required, for example, during
stateful replication among several nodes.

This patch handles the NFTA_SET_ELEM_EXPIRATION in order
to configure the expiration parameter per element, or
will use the timeout in the case that the expiration
is not set.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
v2:
 - set always expiration 0 in nft_dynset_new()

 include/net/netfilter/nf_tables.h |  2 +-
 net/netfilter/nf_tables_api.c     | 26 ++++++++++++++++++++------
 net/netfilter/nft_dynset.c        |  3 ++-
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5b8624ae4a27..9e8493aad49d 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -636,7 +636,7 @@ static inline struct nft_object **nft_set_ext_obj(const struct nft_set_ext *ext)
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *data,
-			u64 timeout, gfp_t gfp);
+			u64 timeout, u64 expiration, gfp_t gfp);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d444405211c5..412bb85e9d29 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3873,6 +3873,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_DATA]		= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_FLAGS]		= { .type = NLA_U32 },
 	[NFTA_SET_ELEM_TIMEOUT]		= { .type = NLA_U64 },
+	[NFTA_SET_ELEM_EXPIRATION]	= { .type = NLA_U64 },
 	[NFTA_SET_ELEM_USERDATA]	= { .type = NLA_BINARY,
 					    .len = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_ELEM_EXPR]		= { .type = NLA_NESTED },
@@ -4326,7 +4327,7 @@ static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *data,
-			u64 timeout, gfp_t gfp)
+			u64 timeout, u64 expiration, gfp_t gfp)
 {
 	struct nft_set_ext *ext;
 	void *elem;
@@ -4341,9 +4342,11 @@ void *nft_set_elem_init(const struct nft_set *set,
 	memcpy(nft_set_ext_key(ext), key, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		memcpy(nft_set_ext_data(ext), data, set->dlen);
-	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION))
-		*nft_set_ext_expiration(ext) =
-			get_jiffies_64() + timeout;
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
+		*nft_set_ext_expiration(ext) = get_jiffies_64() + expiration;
+		if (expiration == 0)
+			*nft_set_ext_expiration(ext) += timeout;
+	}
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_TIMEOUT))
 		*nft_set_ext_timeout(ext) = timeout;
 
@@ -4408,6 +4411,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_trans *trans;
 	u32 flags = 0;
 	u64 timeout;
+	u64 expiration;
 	u8 ulen;
 	int err;
 
@@ -4451,6 +4455,16 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		timeout = set->timeout;
 	}
 
+	expiration = 0;
+	if (nla[NFTA_SET_ELEM_EXPIRATION] != NULL) {
+		if (!(set->flags & NFT_SET_TIMEOUT))
+			return -EINVAL;
+		err = nf_msecs_to_jiffies64(nla[NFTA_SET_ELEM_EXPIRATION],
+					    &expiration);
+		if (err)
+			return err;
+	}
+
 	err = nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &d1,
 			    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
@@ -4533,7 +4547,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	err = -ENOMEM;
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
-				      timeout, GFP_KERNEL);
+				      timeout, expiration, GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err3;
 
@@ -4735,7 +4749,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 	err = -ENOMEM;
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
-				      GFP_KERNEL);
+				      0, GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err2;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 8394560aa695..5082df8d45d7 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -24,6 +24,7 @@ struct nft_dynset {
 	enum nft_registers		sreg_data:8;
 	bool				invert;
 	u64				timeout;
+	u64				expiration;
 	struct nft_expr			*expr;
 	struct nft_set_binding		binding;
 };
@@ -60,7 +61,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 	elem = nft_set_elem_init(set, &priv->tmpl,
 				 &regs->data[priv->sreg_key],
 				 &regs->data[priv->sreg_data],
-				 timeout, GFP_ATOMIC);
+				 timeout, 0, GFP_ATOMIC);
 	if (elem == NULL)
 		goto err1;
 
-- 
2.11.0

