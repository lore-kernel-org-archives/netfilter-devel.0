Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A5AC41513
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Aug 2023 11:17:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232029AbjHILRB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Aug 2023 07:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbjHILQ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2023 07:16:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD6210F3;
        Wed,  9 Aug 2023 04:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 54DC76315F;
        Wed,  9 Aug 2023 11:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F7AC433C7;
        Wed,  9 Aug 2023 11:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1691579816;
        bh=93FdhOffN2IdJjElA1A0bYyEJDti2U92q9FniqWMZ5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xnwAdWhWQ9522O2FvLMeeQif1NE9Ycpya1eG6Nph5At0+Uxf6ap83M2ruV+tEpvtj
         zj4rapT1eRkTYfOe5Y+wx0xP/4hTkXD/AdRAChmP3jkBhga5xhOZasZCs9DpmTCFEf
         qqo/TCG29pwfmKkKzPU26Yu0J35Mm53Cy9V7ZqaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 126/323] netfilter: nftables: add helper function to set the base sequence number
Date:   Wed,  9 Aug 2023 12:39:24 +0200
Message-ID: <20230809103703.896804025@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ 802b805162a1b7d8391c40ac8a878e9e63287aff ]

This patch adds a helper function to calculate the base sequence number
field that is stored in the nfnetlink header. Use the helper function
whenever possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -561,6 +561,11 @@ nf_tables_chain_type_lookup(struct net *
 	return ERR_PTR(-ENOENT);
 }
 
+static __be16 nft_base_seq(const struct net *net)
+{
+	return htons(net->nft.base_seq & 0xffff);
+}
+
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
@@ -583,7 +588,7 @@ static int nf_tables_fill_table_info(str
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
 	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
@@ -1218,7 +1223,7 @@ static int nf_tables_fill_chain_info(str
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name))
 		goto nla_put_failure;
@@ -2265,7 +2270,7 @@ static int nf_tables_fill_rule_info(stru
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_RULE_TABLE, table->name))
 		goto nla_put_failure;
@@ -3176,7 +3181,7 @@ static int nf_tables_fill_set(struct sk_
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -4032,7 +4037,7 @@ static int nf_tables_dump_set(struct sk_
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = table->family;
 	nfmsg->version      = NFNETLINK_V0;
-	nfmsg->res_id	    = htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id	    = nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_TABLE, table->name))
 		goto nla_put_failure;
@@ -4104,7 +4109,7 @@ static int nf_tables_fill_setelem_info(s
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -5152,7 +5157,7 @@ static int nf_tables_fill_obj_info(struc
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->name) ||
@@ -5813,7 +5818,7 @@ static int nf_tables_fill_flowtable_info
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_FLOWTABLE_TABLE, flowtable->table->name) ||
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
@@ -6051,7 +6056,7 @@ static int nf_tables_fill_gen_info(struc
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= AF_UNSPEC;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||


