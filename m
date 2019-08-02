Return-Path: <SRS0=xWIb=V6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F840C32755
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:29:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 519B42182B
	for <netfilter-devel@archiver.kernel.org>; Fri,  2 Aug 2019 13:29:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389396AbfHBN3l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 2 Aug 2019 09:29:41 -0400
Received: from correo.us.es ([193.147.175.20]:41564 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391787AbfHBN3l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Aug 2019 09:29:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 020D0FB44F
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 15:29:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E67F41150CC
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Aug 2019 15:29:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CE8551150CB; Fri,  2 Aug 2019 15:29:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B11B2DA730;
        Fri,  2 Aug 2019 15:29:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 02 Aug 2019 15:29:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.181.192])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0D4124265A31;
        Fri,  2 Aug 2019 15:29:34 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        jakub.kicinski@netronome.com, jiri@resnulli.us,
        marcelo.leitner@gmail.com, saeedm@mellanox.com, wenxu@ucloud.cn,
        gerlitz.or@gmail.com, paulb@mellanox.com
Subject: [PATCH net-next 3/3] filter: nf_tables_offload: set priority field for rules
Date:   Fri,  2 Aug 2019 15:28:46 +0200
Message-Id: <20190802132846.3067-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190802132846.3067-1-pablo@netfilter.org>
References: <20190802132846.3067-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allocates the priority per rule starting from priority 1
since some drivers assume priority 0 never happens.

This patch is restricting the rule priority range to 8-bit integer since
the nft_rule object has 7-bit spare bits plus one that is scratched from
the handle. It should be possible to extend this later on by placing the
priority after the userdata area to turn this into 32-bits priority
field, to put this data away from the packet path cachelines.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: formerly "netfilter: nf_tables: map basechain priority to hardware priority"
    address mapping to hardware based on comments from Jakub.

 include/net/netfilter/nf_tables.h         |  8 ++++++--
 include/net/netfilter/nf_tables_offload.h |  1 +
 net/netfilter/nf_tables_offload.c         | 27 ++++++++++++++++++++++-----
 3 files changed, 29 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 87dbe62c0f27..a6308fcf5bf0 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -9,6 +9,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <linux/u64_stats_sync.h>
 #include <linux/rhashtable.h>
+#include <linux/idr.h>
 #include <net/netfilter/nf_flow_table.h>
 #include <net/netlink.h>
 #include <net/flow_offload.h>
@@ -824,14 +825,16 @@ int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
  *	@genmask: generation mask
  *	@dlen: length of expression data
  *	@udata: user data is appended to the rule
+ *	@prio: priority (for hardware offload)
  *	@data: expression data
  */
 struct nft_rule {
 	struct list_head		list;
-	u64				handle:42,
+	u64				handle:41,
 					genmask:2,
 					dlen:12,
-					udata:1;
+					udata:1,
+					prio:8;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(struct nft_expr))));
 };
@@ -964,6 +967,7 @@ struct nft_base_chain {
 	char 				dev_name[IFNAMSIZ];
 	struct {
 		struct flow_block	flow_block;
+		struct idr		prio_idr;
 	} offload;
 };
 
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index fb3db391ade8..70f226568fe7 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -76,6 +76,7 @@ int nft_flow_rule_offload_commit(struct net *net);
 static inline void nft_basechain_offload_init(struct nft_base_chain *basechain)
 {
 	flow_block_init(&basechain->offload.flow_block);
+	idr_init(&basechain->offload.prio_idr);
 }
 
 #endif
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 84615381b06f..21144938482a 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -103,10 +103,11 @@ void nft_offload_update_dependency(struct nft_offload_ctx *ctx,
 }
 
 static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
-					 __be16 proto,
-					struct netlink_ext_ack *extack)
+					 __be16 proto, u32 priority,
+					 struct netlink_ext_ack *extack)
 {
 	common->protocol = proto;
+	common->prio = priority;
 	common->extack = extack;
 }
 
@@ -125,6 +126,8 @@ static int nft_setup_cb_call(struct nft_base_chain *basechain,
 	return 0;
 }
 
+#define NFT_OFFLOAD_PRIO_MAX	U8_MAX
+
 static int nft_flow_offload_rule(struct nft_trans *trans,
 				 enum flow_cls_command command)
 {
@@ -134,22 +137,36 @@ static int nft_flow_offload_rule(struct nft_trans *trans,
 	struct nft_base_chain *basechain;
 	struct netlink_ext_ack extack;
 	__be16 proto = ETH_P_ALL;
+	u32 prio = 1;
+	int err;
 
 	if (!nft_is_base_chain(trans->ctx.chain))
 		return -EOPNOTSUPP;
 
 	basechain = nft_base_chain(trans->ctx.chain);
 
-	if (flow)
+	if (flow) {
+		if (idr_alloc_u32(&basechain->offload.prio_idr, NULL, &prio,
+				  NFT_OFFLOAD_PRIO_MAX, GFP_KERNEL) < 0)
+			return -E2BIG;
+
+		rule->prio = prio;
 		proto = flow->proto;
+	}
 
-	nft_flow_offload_common_init(&cls_flow.common, proto, &extack);
+	nft_flow_offload_common_init(&cls_flow.common, proto, rule->prio,
+				     &extack);
 	cls_flow.command = command;
 	cls_flow.cookie = (unsigned long) rule;
 	if (flow)
 		cls_flow.rule = flow->rule;
 
-	return nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flow);
+	err = nft_setup_cb_call(basechain, TC_SETUP_CLSFLOWER, &cls_flow);
+	if ((err < 0 && command == FLOW_CLS_REPLACE) ||
+	    (err == 0 && command == FLOW_CLS_DESTROY))
+		idr_remove(&basechain->offload.prio_idr, rule->prio);
+
+	return err;
 }
 
 static int nft_flow_offload_bind(struct flow_block_offload *bo,
-- 
2.11.0

