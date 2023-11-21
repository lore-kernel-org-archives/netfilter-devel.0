Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8348DC61D92
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:28:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233856AbjKUM2v (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:28:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234750AbjKUM2u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:28:50 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A00FEE7;
        Tue, 21 Nov 2023 04:28:46 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r5Prx-0005Cr-AX; Tue, 21 Nov 2023 13:28:45 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     lorenzo@kernel.org, <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 6/8] netfilter: nf_tables: add xdp offload flag
Date:   Tue, 21 Nov 2023 13:27:49 +0100
Message-ID: <20231121122800.13521-7-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231121122800.13521-1-fw@strlen.de>
References: <20231121122800.13521-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Also make sure this flag cannot be set or cleared, just like
with the regular hw offload flag.

Otherwise we'd have to add more complexity and explicitly
withdraw or add the device to the netdev -> flowtable mapping.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_flow_table.h    |  1 +
 include/uapi/linux/netfilter/nf_tables.h |  5 ++++-
 net/netfilter/nf_tables_api.c            | 14 ++++++++++++--
 3 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 6598ac455d17..11985d9b8370 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -70,6 +70,7 @@ struct nf_flowtable_type {
 enum nf_flowtable_flags {
 	NF_FLOWTABLE_HW_OFFLOAD		= 0x1,	/* NFT_FLOWTABLE_HW_OFFLOAD */
 	NF_FLOWTABLE_COUNTER		= 0x2,	/* NFT_FLOWTABLE_COUNTER */
+	NF_FLOWTABLE_XDP_OFFLOAD	= 0x4,	/* NFT_FLOWTABLE_XDP_OFFLOAD */
 };
 
 struct nf_flowtable {
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index ca30232b7bc8..ed297dc77288 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1675,12 +1675,15 @@ enum nft_object_attributes {
  *
  * @NFT_FLOWTABLE_HW_OFFLOAD: flowtable hardware offload is enabled
  * @NFT_FLOWTABLE_COUNTER: enable flow counters
+ * @NFT_FLOWTABLE_XDP_OFFLOAD: flowtable xdp offload is enabled
  */
 enum nft_flowtable_flags {
 	NFT_FLOWTABLE_HW_OFFLOAD	= 0x1,
 	NFT_FLOWTABLE_COUNTER		= 0x2,
+	NFT_FLOWTABLE_XDP_OFFLOAD	= 0x4,
 	NFT_FLOWTABLE_MASK		= (NFT_FLOWTABLE_HW_OFFLOAD |
-					   NFT_FLOWTABLE_COUNTER)
+					   NFT_FLOWTABLE_COUNTER |
+					   NFT_FLOWTABLE_XDP_OFFLOAD),
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 7437b997ca7e..4e21311ec768 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8288,6 +8288,15 @@ static void nft_hooks_destroy(struct list_head *hook_list)
 	}
 }
 
+static bool nft_flowtable_flag_changes(const struct nf_flowtable *ft,
+				       unsigned int new_flags, enum nft_flowtable_flags flag)
+{
+	if ((ft->flags & flag) ^ (new_flags & flag))
+		return true;
+
+	return false;
+}
+
 static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 				struct nft_flowtable *flowtable,
 				struct netlink_ext_ack *extack)
@@ -8318,8 +8327,9 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 			err = -EOPNOTSUPP;
 			goto err_flowtable_update_hook;
 		}
-		if ((flowtable->ft->flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
-		    (flags & NFT_FLOWTABLE_HW_OFFLOAD)) {
+
+		if (nft_flowtable_flag_changes(flowtable->ft, flags, NFT_FLOWTABLE_HW_OFFLOAD) ||
+		    nft_flowtable_flag_changes(flowtable->ft, flags, NFT_FLOWTABLE_XDP_OFFLOAD)) {
 			err = -EOPNOTSUPP;
 			goto err_flowtable_update_hook;
 		}
-- 
2.41.0

