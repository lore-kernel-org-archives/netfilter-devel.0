Return-Path: <SRS0=SqQQ=RB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4672C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1995620851
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Feb 2019 21:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfBZVNv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Feb 2019 16:13:51 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:48006 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728766AbfBZVNv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Feb 2019 16:13:51 -0500
Received: from localhost ([::1]:32864 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1gyk2w-0006nM-Jf; Tue, 26 Feb 2019 22:13:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 4/5] json: Fix memleaks in echo support
Date:   Tue, 26 Feb 2019 22:13:41 +0100
Message-Id: <20190226211342.15125-5-phil@nwl.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190226211342.15125-1-phil@nwl.cc>
References: <20190226211342.15125-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When extracting netlink message data for populating JSON objects with
handles, allocated nftnl objects were not freed. Though since freeing
these objects also frees retrieved string attributes, copy them using
strdupa() which takes care of memory deallocation upon function return.
This is ideal since these strings are used only to find the right JSON
object to insert the handle into.

Fixes: bb32d8db9a125 ("JSON: Add support for echo option")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/parser_json.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/src/parser_json.c b/src/parser_json.c
index 6755d39c34f0a..c92113ba516c2 100644
--- a/src/parser_json.c
+++ b/src/parser_json.c
@@ -1,3 +1,4 @@
+#define _GNU_SOURCE
 #include <errno.h>
 #include <stdint.h> /* needed by gmputil.h */
 #include <string.h>
@@ -3485,8 +3486,9 @@ static int json_update_table(struct netlink_mon_handler *monh,
 
 	nlt = netlink_table_alloc(nlh);
 	family = family2str(nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY));
-	name = nftnl_table_get_str(nlt, NFTNL_TABLE_NAME);
+	name = strdupa(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
 	handle = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
+	nftnl_table_free(nlt);
 
 	json_array_foreach(array, index, value) {
 		if (json_unpack(value, "{s:{s:o}}", "add", "table", &value) ||
@@ -3512,9 +3514,10 @@ static int json_update_chain(struct netlink_mon_handler *monh,
 
 	nlc = netlink_chain_alloc(nlh);
 	family = family2str(nftnl_chain_get_u32(nlc, NFTNL_CHAIN_FAMILY));
-	table = nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE);
-	name = nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME);
+	table = strdupa(nftnl_chain_get_str(nlc, NFTNL_CHAIN_TABLE));
+	name = strdupa(nftnl_chain_get_str(nlc, NFTNL_CHAIN_NAME));
 	handle = nftnl_chain_get_u64(nlc, NFTNL_CHAIN_HANDLE);
+	nftnl_chain_free(nlc);
 
 	json_array_foreach(array, index, value) {
 		if (json_unpack(value, "{s:{s:o}}", "add", "chain", &value) ||
@@ -3540,9 +3543,10 @@ static int json_update_rule(struct netlink_mon_handler *monh,
 
 	nlr = netlink_rule_alloc(nlh);
 	family = family2str(nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY));
-	table = nftnl_rule_get_str(nlr, NFTNL_RULE_TABLE);
-	chain = nftnl_rule_get_str(nlr, NFTNL_RULE_CHAIN);
+	table = strdupa(nftnl_rule_get_str(nlr, NFTNL_RULE_TABLE));
+	chain = strdupa(nftnl_rule_get_str(nlr, NFTNL_RULE_CHAIN));
 	handle = nftnl_rule_get_u64(nlr, NFTNL_RULE_HANDLE);
+	nftnl_rule_free(nlr);
 
 	json_array_foreach(array, index, value) {
 		if (json_unpack(value, "{s:{s:o}}", "add", "rule", &value) ||
@@ -3574,13 +3578,16 @@ static int json_update_set(struct netlink_mon_handler *monh,
 
 	nls = netlink_set_alloc(nlh);
 	flags = nftnl_set_get_u32(nls, NFTNL_SET_FLAGS);
-	if (flags & NFT_SET_ANONYMOUS)
+	if (flags & NFT_SET_ANONYMOUS) {
+		nftnl_set_free(nls);
 		return MNL_CB_OK;
+	}
 
 	family = family2str(nftnl_set_get_u32(nls, NFTNL_SET_FAMILY));
-	table = nftnl_set_get_str(nls, NFTNL_SET_TABLE);
-	name = nftnl_set_get_str(nls, NFTNL_SET_NAME);
+	table = strdupa(nftnl_set_get_str(nls, NFTNL_SET_TABLE));
+	name = strdupa(nftnl_set_get_str(nls, NFTNL_SET_NAME));
 	handle = nftnl_set_get_u64(nls, NFTNL_SET_HANDLE);
+	nftnl_set_free(nls);
 
 	json_array_foreach(array, index, value) {
 		if (json_unpack(value, "{s:{s:o}}", "add", "set", &value) ||
@@ -3605,10 +3612,11 @@ static int json_update_obj(struct netlink_mon_handler *monh,
 
 	nlo = netlink_obj_alloc(nlh);
 	family = family2str(nftnl_obj_get_u32(nlo, NFTNL_OBJ_FAMILY));
-	table = nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE);
-	name = nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME);
+	table = strdupa(nftnl_obj_get_str(nlo, NFTNL_OBJ_TABLE));
+	name = strdupa(nftnl_obj_get_str(nlo, NFTNL_OBJ_NAME));
 	type = obj_type_name(nftnl_obj_get_u32(nlo, NFTNL_OBJ_TYPE));
 	handle = nftnl_obj_get_u64(nlo, NFTNL_OBJ_HANDLE);
+	nftnl_obj_free(nlo);
 
 	json_array_foreach(array, index, value) {
 		if (json_unpack(value, "{s:{s:o}}", "add", type, &value) ||
-- 
2.20.1

