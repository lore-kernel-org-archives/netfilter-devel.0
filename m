Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD12CA9EB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30AA121D7D
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 22:49:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438306AbfJQWtD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 18:49:03 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:42618 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732705AbfJQWtC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 18:49:02 -0400
Received: from localhost ([::1]:55708 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1iLEZp-00044P-PI; Fri, 18 Oct 2019 00:49:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/8] xtables-restore: Constify struct nft_xt_restore_cb
Date:   Fri, 18 Oct 2019 00:48:32 +0200
Message-Id: <20191017224836.8261-5-phil@nwl.cc>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191017224836.8261-1-phil@nwl.cc>
References: <20191017224836.8261-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There is no need for dynamic callback mangling, so make all instances
static const.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h        | 2 +-
 iptables/xtables-restore.c   | 8 ++++----
 iptables/xtables-translate.c | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 5c6641505f3db..b062f3e5792e3 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -262,7 +262,7 @@ struct nft_xt_restore_cb {
 
 void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p,
-			   struct nft_xt_restore_cb *cb);
+			   const struct nft_xt_restore_cb *cb);
 
 void nft_check_xt_legacy(int family, bool is_ipt_save);
 #endif
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 4652d631d2219..df8844208c273 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -70,7 +70,7 @@ static struct nftnl_chain_list *get_chain_list(struct nft_handle *h,
 	return chain_list;
 }
 
-struct nft_xt_restore_cb restore_cb = {
+static const struct nft_xt_restore_cb restore_cb = {
 	.chain_list	= get_chain_list,
 	.commit		= nft_commit,
 	.abort		= nft_abort,
@@ -87,7 +87,7 @@ static const struct xtc_ops xtc_ops = {
 
 void xtables_restore_parse(struct nft_handle *h,
 			   const struct nft_xt_restore_parse *p,
-			   struct nft_xt_restore_cb *cb)
+			   const struct nft_xt_restore_cb *cb)
 {
 	const struct builtin_table *curtable = NULL;
 	char buffer[10240];
@@ -432,7 +432,7 @@ static int ebt_table_flush(struct nft_handle *h, const char *table)
 	return nft_table_flush(h, table);
 }
 
-struct nft_xt_restore_cb ebt_restore_cb = {
+static const struct nft_xt_restore_cb ebt_restore_cb = {
 	.chain_list	= get_chain_list,
 	.commit		= nft_bridge_commit,
 	.table_new	= nft_table_new,
@@ -478,7 +478,7 @@ int xtables_eb_restore_main(int argc, char *argv[])
 	return 0;
 }
 
-struct nft_xt_restore_cb arp_restore_cb = {
+static const struct nft_xt_restore_cb arp_restore_cb = {
 	.chain_list	= get_chain_list,
 	.commit		= nft_commit,
 	.table_new	= nft_table_new,
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 64e7667a253e7..43607901fc62b 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -413,7 +413,7 @@ static int dummy_compat_rev(const char *name, uint8_t rev, int opt)
 	return 1;
 }
 
-static struct nft_xt_restore_cb cb_xlate = {
+static const struct nft_xt_restore_cb cb_xlate = {
 	.table_new	= xlate_table_new,
 	.chain_set	= xlate_chain_set,
 	.chain_restore	= xlate_chain_user_restore,
-- 
2.23.0

