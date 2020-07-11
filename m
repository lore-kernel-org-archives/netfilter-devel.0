Return-Path: <SRS0=5odi=AW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3057C433E0
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9B55206F4
	for <netfilter-devel@archiver.kernel.org>; Sat, 11 Jul 2020 10:19:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgGKKTJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 11 Jul 2020 06:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726208AbgGKKTJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 11 Jul 2020 06:19:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5E0C08C5DD
        for <netfilter-devel@vger.kernel.org>; Sat, 11 Jul 2020 03:19:09 -0700 (PDT)
Received: from localhost ([::1]:59436 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1juCb5-0007FW-L3; Sat, 11 Jul 2020 12:19:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 01/18] nft: Make table creation purely implicit
Date:   Sat, 11 Jul 2020 12:18:14 +0200
Message-Id: <20200711101831.29506-2-phil@nwl.cc>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200711101831.29506-1-phil@nwl.cc>
References: <20200711101831.29506-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While asserting a required builtin chain exists, its table is created
implicitly if missing. Exploit this from xtables-restore, too: The only
actions which need adjustment are chain_new and chain_restore, i.e. when
restoring (either builtin or custom) chains.

Note: The call to nft_table_builtin_add() wasn't sufficient as it
doesn't set the table as initialized and therefore a following call to
nft_xt_builtin_init() would override non-default base chain policies.

Note2: The 'table_new' callback in 'nft_xt_restore_cb' is left in place
as xtables-translate uses it to print an explicit 'add table' command.

Note3: nft_table_new() function was already unused since a7f1e208cdf9c
("nft: split parsing from netlink commands").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c         |  5 -----
 iptables/nft.c             | 17 +++--------------
 iptables/nft.h             |  2 --
 iptables/xtables-restore.c |  3 ---
 4 files changed, 3 insertions(+), 24 deletions(-)

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 51cdfed41519c..5d33f1f00f574 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -393,8 +393,3 @@ int ebt_cmd_user_chain_policy(struct nft_handle *h, const char *table,
 
 	return 1;
 }
-
-void nft_cmd_table_new(struct nft_handle *h, const char *table)
-{
-	nft_cmd_new(h, NFT_COMPAT_TABLE_NEW, table, NULL, NULL, -1, false);
-}
diff --git a/iptables/nft.c b/iptables/nft.c
index 0c5a74fc232c6..c5ab0dbe8d6e7 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -350,7 +350,6 @@ static int mnl_append_error(const struct nft_handle *h,
 	case NFT_COMPAT_RULE_SAVE:
 	case NFT_COMPAT_RULE_ZERO:
 	case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
-	case NFT_COMPAT_TABLE_NEW:
 		assert(0);
 		break;
 	}
@@ -892,7 +891,7 @@ static struct nftnl_chain *nft_chain_new(struct nft_handle *h,
 	}
 
 	/* if this built-in table does not exists, create it */
-	nft_table_builtin_add(h, _t);
+	nft_xt_builtin_init(h, table);
 
 	_c = nft_chain_builtin_find(_t, chain);
 	if (_c != NULL) {
@@ -1789,6 +1788,8 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 	bool created = false;
 	int ret;
 
+	nft_xt_builtin_init(h, table);
+
 	c = nft_chain_find(h, table, chain);
 	if (c) {
 		/* Apparently -n still flushes existing user defined
@@ -2099,11 +2100,6 @@ err_out:
 	return ret == 0 ? 1 : 0;
 }
 
-void nft_table_new(struct nft_handle *h, const char *table)
-{
-	nft_xt_builtin_init(h, table);
-}
-
 static int __nft_rule_del(struct nft_handle *h, struct nftnl_rule *r)
 {
 	struct obj_update *obj;
@@ -2735,7 +2731,6 @@ static void batch_obj_del(struct nft_handle *h, struct obj_update *o)
 	case NFT_COMPAT_RULE_SAVE:
 	case NFT_COMPAT_RULE_ZERO:
 	case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
-	case NFT_COMPAT_TABLE_NEW:
 		assert(0);
 		break;
 	}
@@ -2811,7 +2806,6 @@ static void nft_refresh_transaction(struct nft_handle *h)
 		case NFT_COMPAT_RULE_SAVE:
 		case NFT_COMPAT_RULE_ZERO:
 		case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
-		case NFT_COMPAT_TABLE_NEW:
 			break;
 		}
 	}
@@ -2915,7 +2909,6 @@ retry:
 		case NFT_COMPAT_RULE_SAVE:
 		case NFT_COMPAT_RULE_ZERO:
 		case NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE:
-		case NFT_COMPAT_TABLE_NEW:
 			assert(0);
 		}
 
@@ -3178,10 +3171,6 @@ static int nft_prepare(struct nft_handle *h)
 			ret = ebt_set_user_chain_policy(h, cmd->table,
 							cmd->chain, cmd->policy);
 			break;
-		case NFT_COMPAT_TABLE_NEW:
-			nft_xt_builtin_init(h, cmd->table);
-			ret = 1;
-			break;
 		case NFT_COMPAT_SET_ADD:
 			nft_xt_builtin_init(h, cmd->table);
 			batch_set_add(h, NFT_COMPAT_SET_ADD, cmd->obj.set);
diff --git a/iptables/nft.h b/iptables/nft.h
index bd783231156b7..bd944f441caf1 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -68,7 +68,6 @@ enum obj_update_type {
 	NFT_COMPAT_RULE_SAVE,
 	NFT_COMPAT_RULE_ZERO,
 	NFT_COMPAT_BRIDGE_USER_CHAIN_UPDATE,
-	NFT_COMPAT_TABLE_NEW,
 };
 
 struct cache_chain {
@@ -135,7 +134,6 @@ int nft_for_each_table(struct nft_handle *h, int (*func)(struct nft_handle *h, c
 bool nft_table_find(struct nft_handle *h, const char *tablename);
 int nft_table_purge_chains(struct nft_handle *h, const char *table, struct nftnl_chain_list *list);
 int nft_table_flush(struct nft_handle *h, const char *table);
-void nft_table_new(struct nft_handle *h, const char *table);
 const struct builtin_table *nft_table_builtin_find(struct nft_handle *h, const char *table);
 
 /*
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index eb25ec3dc8398..d27394972d90c 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -61,7 +61,6 @@ static void print_usage(const char *name, const char *version)
 static const struct nft_xt_restore_cb restore_cb = {
 	.commit		= nft_commit,
 	.abort		= nft_abort,
-	.table_new	= nft_cmd_table_new,
 	.table_flush	= nft_cmd_table_flush,
 	.do_command	= do_commandx,
 	.chain_set	= nft_cmd_chain_set,
@@ -410,7 +409,6 @@ int xtables_ip6_restore_main(int argc, char *argv[])
 
 static const struct nft_xt_restore_cb ebt_restore_cb = {
 	.commit		= nft_bridge_commit,
-	.table_new	= nft_cmd_table_new,
 	.table_flush	= nft_cmd_table_flush,
 	.do_command	= do_commandeb,
 	.chain_set	= nft_cmd_chain_set,
@@ -456,7 +454,6 @@ int xtables_eb_restore_main(int argc, char *argv[])
 
 static const struct nft_xt_restore_cb arp_restore_cb = {
 	.commit		= nft_commit,
-	.table_new	= nft_cmd_table_new,
 	.table_flush	= nft_cmd_table_flush,
 	.do_command	= do_commandarp,
 	.chain_set	= nft_cmd_chain_set,
-- 
2.27.0

