Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDDB8C10F0E
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ABB722075B
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 17:01:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbfDORAp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 13:00:45 -0400
Received: from mail.us.es ([193.147.175.20]:50466 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727861AbfDORAp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 13:00:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0E321C443A
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A7C34DA712
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A6A54DA701; Mon, 15 Apr 2019 19:00:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90819DA701;
        Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 63DFD4265A31;
        Mon, 15 Apr 2019 19:00:41 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 14/22] netfilter: make two functions static
Date:   Mon, 15 Apr 2019 19:00:20 +0200
Message-Id: <20190415170028.3470-15-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415170028.3470-1-pablo@netfilter.org>
References: <20190415170028.3470-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

They have no external callers anymore.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
index 55dff3ab44c7..2d5a0a1a87b8 100644
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
index a2bd439937e6..e058273c5dde 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3782,8 +3782,8 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 }
 EXPORT_SYMBOL_GPL(nf_tables_bind_set);
 
-void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
-			  struct nft_set_binding *binding, bool event)
+static void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
+				 struct nft_set_binding *binding, bool event)
 {
 	list_del_rcu(&binding->list);
 
@@ -3794,7 +3794,6 @@ void nf_tables_unbind_set(const struct nft_ctx *ctx, struct nft_set *set,
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
2.11.0

