Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9F1C04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7D98216B7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 11:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbfEULbV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 07:31:21 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35500 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726296AbfEULbV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 07:31:21 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hT2zH-0008Tx-9k; Tue, 21 May 2019 13:31:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     marcmicalizzi@gmail.com, Florian Westphal <fw@strlen.de>
Subject: [PATCH nf 3/5] netfilter: nft_flow_offload: don't offload when sequence numbers need adjustment
Date:   Tue, 21 May 2019 13:24:32 +0200
Message-Id: <20190521112434.11767-4-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190521112434.11767-1-fw@strlen.de>
References: <20190521112434.11767-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We can't deal with tcp sequence number rewrite in flow_offload.
While at it, simplify helper check, we only need to know if the extension
is present, we don't need the helper data.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_flow_offload.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index bde63d9c3c4e..c97c03c3939a 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -12,7 +12,6 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <net/netfilter/nf_flow_table.h>
-#include <net/netfilter/nf_conntrack_helper.h>
 
 struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
@@ -67,7 +66,6 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
-	const struct nf_conn_help *help;
 	enum ip_conntrack_info ctinfo;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
@@ -93,8 +91,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
-	help = nfct_help(ct);
-	if (help)
+	if (nf_ct_ext_exist(ct, NF_CT_EXT_HELPER) ||
+	    ct->status & IPS_SEQ_ADJUST)
 		goto out;
 
 	if (!nf_ct_is_confirmed(ct))
-- 
2.21.0

