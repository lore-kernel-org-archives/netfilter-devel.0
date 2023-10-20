Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0AAC00A98
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 17:34:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377710AbjJTReo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229982AbjJTRem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007CEA3
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oHgG//UHae1OzfvnHM+bRpDZ+g43Mbk0Ww5fMCrcUmg=; b=mQ0LEloKLoDXwOowSKbupHfmCY
        Psh/hRxkp0y48YazIxj9jLioYfM6mEzFzoKAJh2FGJSo7ya189iRZ/n8u7S/1bbKJcHw1L0XyapCN
        7+Cz3M8/1xunbNmn1FfAYL0aj6TlG8ImY0bg51urbvXpCtyzuZqgUpTqjGDw9YWztPdLEgok7xlb1
        HC36sw9c2K7b62KIGDINiahjh/qd3h7nuJEH+z5WAZQ+1tusnp0+NFMOrTyfqEY8aKcjCv8xBh5xD
        /rHN84hS+KpRi8p7Zkr/3hK+aXoyzwGoJVzrk1NzDTp8wkhT+ZgQtV4azmMHtaDVbMGrv/smbt0q3
        pofbnE3w==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qttOP-0003kZ-0l; Fri, 20 Oct 2023 19:34:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 2/6] netfilter: nf_tables: Unconditionally allocate nft_obj_filter
Date:   Fri, 20 Oct 2023 19:34:29 +0200
Message-ID: <20231020173433.4611-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020173433.4611-1-phil@nwl.cc>
References: <20231020173433.4611-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prep work for moving the filter into struct netlink_callback's scratch
area.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 36 +++++++++++++++--------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0f7ee76ad64f..0dfac634d21f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7725,11 +7725,9 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 				goto cont;
 			if (idx < s_idx)
 				goto cont;
-			if (filter && filter->table &&
-			    strcmp(filter->table, table->name))
+			if (filter->table && strcmp(filter->table, table->name))
 				goto cont;
-			if (filter &&
-			    filter->type != NFT_OBJECT_UNSPEC &&
+			if (filter->type != NFT_OBJECT_UNSPEC &&
 			    obj->ops->type->type != filter->type)
 				goto cont;
 
@@ -7764,23 +7762,21 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	const struct nlattr * const *nla = cb->data;
 	struct nft_obj_filter *filter = NULL;
 
-	if (nla[NFTA_OBJ_TABLE] || nla[NFTA_OBJ_TYPE]) {
-		filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
-		if (!filter)
-			return -ENOMEM;
+	filter = kzalloc(sizeof(*filter), GFP_ATOMIC);
+	if (!filter)
+		return -ENOMEM;
 
-		if (nla[NFTA_OBJ_TABLE]) {
-			filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
-			if (!filter->table) {
-				kfree(filter);
-				return -ENOMEM;
-			}
+	if (nla[NFTA_OBJ_TABLE]) {
+		filter->table = nla_strdup(nla[NFTA_OBJ_TABLE], GFP_ATOMIC);
+		if (!filter->table) {
+			kfree(filter);
+			return -ENOMEM;
 		}
-
-		if (nla[NFTA_OBJ_TYPE])
-			filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 	}
 
+	if (nla[NFTA_OBJ_TYPE])
+		filter->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
+
 	cb->data = filter;
 	return 0;
 }
@@ -7789,10 +7785,8 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
 	struct nft_obj_filter *filter = cb->data;
 
-	if (filter) {
-		kfree(filter->table);
-		kfree(filter);
-	}
+	kfree(filter->table);
+	kfree(filter);
 
 	return 0;
 }
-- 
2.41.0

