Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46222C001DF
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Oct 2023 17:34:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjJTRem (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbjJTRem (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Oct 2023 13:34:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A55126
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Oct 2023 10:34:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sfhMvW1GqHod5rgNxCurrcEn2LuzflQnjt6VN5LyRrM=; b=PcN/fJ3oFMDJDzFIWD1NZkZddS
        B6bZqeAQscHKT6ie1eJybGLZ4WvL628Wa0qJCzQ0d9kgrgQsbMoB9skvKyt07HRyc/PNskgaZrNI+
        7CiEOa9KNZjjCdgI8SXSLijwKYTxW3RPBL9ydrWQ8sat/Vo9jpTnpnqlYQMQA+Z7xcoCDbLoiGLP0
        fagf0bi94YiMTUecXxI+JVPonJtq5ZX8K6wYkAL8bebIlDC089J8tUwP2BDIFbAI91CwQARvX14sl
        wB69hwRyfs1YwKwuyQv4MAOq9nLbK7kpZ1yq1b2/LrSYLM/okFHcVZjIwIW7YOfX7TMcgSj8VUjhF
        uRaBWBpg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qttOP-0003kg-CF; Fri, 20 Oct 2023 19:34:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH 6/6] netfilter: nf_tables: Carry reset boolean in nft_obj_dump_ctx
Date:   Fri, 20 Oct 2023 19:34:33 +0200
Message-ID: <20231020173433.4611-7-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231020173433.4611-1-phil@nwl.cc>
References: <20231020173433.4611-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Relieve the dump callback from having to inspect nlmsg_type upon each
call, just do it once at start of the dump.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9523f1f3a598..29298ed0252d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7693,6 +7693,7 @@ struct nft_obj_dump_ctx {
 	unsigned int	s_idx;
 	char		*table;
 	u32		type;
+	bool		reset;
 };
 
 static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
@@ -7706,12 +7707,8 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned int entries = 0;
 	struct nft_object *obj;
 	unsigned int idx = 0;
-	bool reset = false;
 	int rc = 0;
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
-
 	rcu_read_lock();
 	nft_net = nft_pernet(net);
 	cb->seq = READ_ONCE(nft_net->base_seq);
@@ -7738,7 +7735,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 						     NFT_MSG_NEWOBJ,
 						     NLM_F_MULTI | NLM_F_APPEND,
 						     table->family, table,
-						     obj, reset);
+						     obj, ctx->reset);
 			if (rc < 0)
 				break;
 
@@ -7747,7 +7744,7 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 cont:
 			idx++;
 		}
-		if (reset && entries)
+		if (ctx->reset && entries)
 			audit_log_obj_reset(table, nft_net->base_seq, entries);
 		if (rc < 0)
 			break;
@@ -7774,6 +7771,9 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
+	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
+		ctx->reset = true;
+
 	return 0;
 }
 
-- 
2.41.0

