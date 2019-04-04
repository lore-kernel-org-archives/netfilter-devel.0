Return-Path: <SRS0=UjrQ=SG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 988A0C10F0C
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 09:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70F7B21900
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Apr 2019 09:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731609AbfDDJCW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Apr 2019 05:02:22 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:36194 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731600AbfDDJCV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Apr 2019 05:02:21 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@breakpoint.cc>)
        id 1hByGJ-0006B8-A6; Thu, 04 Apr 2019 11:02:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: make two functions static
Date:   Thu,  4 Apr 2019 10:58:20 +0200
Message-Id: <20190404085820.8923-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

They have no external callers anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter/x_tables.h | 1 -
 include/net/netfilter/nf_tables.h  | 2 --
 net/netfilter/nf_tables_api.c      | 5 ++---
 net/netfilter/x_tables.c           | 3 +--
 4 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index bf384b3eedb8..1f852ef7b098 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -317,7 +317,6 @@ struct xt_table_info *xt_replace_table(struct xt_table *table,
 				       int *error);
 
 struct xt_match *xt_find_match(u8 af, const char *name, u8 revision);
-struct xt_target *xt_find_target(u8 af, const char *name, u8 revision);
 struct xt_match *xt_request_find_match(u8 af, const char *name, u8 revision);
 struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision);
 int xt_find_revision(u8 af, const char *name, u8 revision, int target,
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 3e9ab643eedf..54139eb985d5 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -475,8 +475,6 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      enum nft_trans_phase phase);
 int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 		       struct nft_set_binding *binding);
-void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding, bool commit);
 void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 513f93118604..b6926afbb1d5 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3783,8 +3783,8 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
-void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding, bool event)
+static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+				 struct nft_set_binding *binding, bool event)
 {
 	list_del_rcu(&binding->list);
 
@@ -3795,7 +3795,6 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
 					     GFP_KERNEL);
 	}
 }
-EXPORT_SYMBOL_GPL(nf_tables_unbind_set);
 
 void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index e5e5c64df8d1..0a6656ed1534 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -227,7 +227,7 @@ xt_request_find_match(uint8_t nfproto, const char *name, uint8_t revision)
 EXPORT_SYMBOL_GPL(xt_request_find_match);
 
 /* Find target, grabs ref.  Returns ERR_PTR() on error. */
-struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
+static struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
 {
 	struct xt_target *t;
 	int err = -ENOENT;
@@ -255,7 +255,6 @@ struct xt_target *xt_find_target(u8 af, const char *name, u8 revision)
 
 	return ERR_PTR(err);
 }
-EXPORT_SYMBOL(xt_find_target);
 
 struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision)
 {
-- 
2.21.0

