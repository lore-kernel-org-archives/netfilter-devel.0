Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FBDC77B7E
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 19:15:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjE1TPK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 15:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjE1TPK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 15:15:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B180A0;
        Sun, 28 May 2023 12:15:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCD736158B;
        Sun, 28 May 2023 19:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5B7C433D2;
        Sun, 28 May 2023 19:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1685301308;
        bh=tkN2zENliMK06+4dajmPd0caINgJBS1oFBw8BKBvEnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KE0hmpIgAOp8o9ee5S/CXj5xompaCLG8E2kGb0kEs+vRNNpelYUwDUdjlaqIJDY8N
         lAwv/8klNJ6ow6UOankol/4qhyI01TFK6Un7qnnof4h42LTaEqqdHgJldnK+A6jJu5
         9E3+cTzH4X7sTwSGuGfgnGKf72jY0tsLuvwFq6oE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 65/86] netfilter: nf_tables: allow up to 64 bytes in the set element data area
Date:   Sun, 28 May 2023 20:10:39 +0100
Message-Id: <20230528190831.047564073@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.564682883@linuxfoundation.org>
References: <20230528190828.564682883@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ fdb9c405e35bdc6e305b9b4e20ebc141ed14fc81 ]

So far, the set elements could store up to 128-bits in the data area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_tables.h |    4 ++++
 net/netfilter/nf_tables_api.c     |   35 +++++++++++++++++++++++++----------
 2 files changed, 29 insertions(+), 10 deletions(-)

--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -229,6 +229,10 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data	val;
 	} key;
+	union {
+		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
+		struct nft_data val;
+	} data;
 	void			*priv;
 };
 
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3954,6 +3954,25 @@ static int nft_setelem_parse_flags(const
 	return 0;
 }
 
+static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
+				  struct nft_data_desc *desc,
+				  struct nft_data *data,
+				  struct nlattr *attr)
+{
+	int err;
+
+	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
+	if (err < 0)
+		return err;
+
+	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+		nft_data_release(data, desc->type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -3966,7 +3985,6 @@ static int nft_add_set_elem(struct nft_c
 	struct nft_object *obj = NULL;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
-	struct nft_data data;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
 	u32 flags = 0;
@@ -4045,15 +4063,11 @@ static int nft_add_set_elem(struct nft_c
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
-		err = nft_data_init(ctx, &data, sizeof(data), &desc,
-				    nla[NFTA_SET_ELEM_DATA]);
+		err = nft_setelem_parse_data(ctx, set, &desc, &elem.data.val,
+					     nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
 			goto err2;
 
-		err = -EINVAL;
-		if (set->dtype != NFT_DATA_VERDICT && desc.len != set->dlen)
-			goto err3;
-
 		dreg = nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
 			struct nft_ctx bind_ctx = {
@@ -4067,7 +4081,7 @@ static int nft_add_set_elem(struct nft_c
 				continue;
 
 			err = nft_validate_register_store(&bind_ctx, dreg,
-							  &data,
+							  &elem.data.val,
 							  desc.type, desc.len);
 			if (err < 0)
 				goto err3;
@@ -4089,7 +4103,8 @@ static int nft_add_set_elem(struct nft_c
 	}
 
 	err = -ENOMEM;
-	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
+	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
+				      elem.data.val.data,
 				      timeout, GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err3;
@@ -4156,7 +4171,7 @@ err4:
 	kfree(elem.priv);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
-		nft_data_release(&data, desc.type);
+		nft_data_release(&elem.data.val, desc.type);
 err2:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err1:


