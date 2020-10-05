Return-Path: <SRS0=VfFo=DM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F3B1C4363A
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 14:28:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 03BD820776
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Oct 2020 14:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgJEO2b (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Oct 2020 10:28:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725960AbgJEO2b (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Oct 2020 10:28:31 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88B02C0613CE
        for <netfilter-devel@vger.kernel.org>; Mon,  5 Oct 2020 07:28:31 -0700 (PDT)
Received: from localhost ([::1]:58612 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1kPRTa-0005G6-34; Mon, 05 Oct 2020 16:28:30 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 3/3] nft: Fix for concurrent noflush restore calls
Date:   Mon,  5 Oct 2020 16:48:58 +0200
Message-Id: <20201005144858.11578-4-phil@nwl.cc>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005144858.11578-1-phil@nwl.cc>
References: <20201005144858.11578-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Transaction refresh was broken with regards to nft_chain_restore(): It
created a rule flush batch object only if the chain was found in cache
and a chain add object only if the chain was not found. Yet with
concurrent ruleset updates, one has to expect both situations:

* If a chain vanishes, the rule flush job must be skipped and instead
  the chain add job become active.

* If a chain appears, the chain add job must be skipped and instead
  rules flushed.

Change the code accordingly: Create both batch objects and set their
'skip' field depending on the situation in cache and adjust both in
nft_refresh_transaction().

As a side-effect, the implicit rule flush becomes explicit and all
handling of implicit batch jobs is dropped along with the related field
indicating such.

Reuse the 'implicit' parameter of __nft_rule_flush() to control the
initial 'skip' field value instead.

A subtle caveat is vanishing of existing chains: Creating the chain add
job based on the chain in cache causes a netlink message containing that
chain's handle which the kernel dislikes. Therefore unset the chain's
handle in that case.

Fixes: 58d7de0181f61 ("xtables: handle concurrent ruleset modifications")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c                                | 58 ++++++++++---------
 .../ipt-restore/0016-concurrent-restores_0    | 53 +++++++++++++++++
 2 files changed, 83 insertions(+), 28 deletions(-)
 create mode 100755 iptables/tests/shell/testcases/ipt-restore/0016-concurrent-restores_0

diff --git a/iptables/nft.c b/iptables/nft.c
index 70be9ba908edc..9424c181d17cc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -265,7 +265,6 @@ struct obj_update {
 	struct list_head	head;
 	enum obj_update_type	type:8;
 	uint8_t			skip:1;
-	uint8_t			implicit:1;
 	unsigned int		seq;
 	union {
 		struct nftnl_table	*table;
@@ -1634,7 +1633,7 @@ struct nftnl_set *nft_set_batch_lookup_byid(struct nft_handle *h,
 
 static void
 __nft_rule_flush(struct nft_handle *h, const char *table,
-		 const char *chain, bool verbose, bool implicit)
+		 const char *chain, bool verbose, bool skip)
 {
 	struct obj_update *obj;
 	struct nftnl_rule *r;
@@ -1656,7 +1655,7 @@ __nft_rule_flush(struct nft_handle *h, const char *table,
 		return;
 	}
 
-	obj->implicit = implicit;
+	obj->skip = skip;
 }
 
 struct nft_rule_flush_data {
@@ -1759,19 +1758,14 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table)
 {
 	struct nftnl_chain_list *list;
+	struct obj_update *obj;
 	struct nftnl_chain *c;
 	bool created = false;
 
 	nft_xt_builtin_init(h, table);
 
 	c = nft_chain_find(h, table, chain);
-	if (c) {
-		/* Apparently -n still flushes existing user defined
-		 * chains that are redefined.
-		 */
-		if (h->noflush)
-			__nft_rule_flush(h, table, chain, false, true);
-	} else {
+	if (!c) {
 		c = nftnl_chain_alloc();
 		if (!c)
 			return 0;
@@ -1779,20 +1773,26 @@ int nft_chain_restore(struct nft_handle *h, const char *chain, const char *table
 		nftnl_chain_set_str(c, NFTNL_CHAIN_TABLE, table);
 		nftnl_chain_set_str(c, NFTNL_CHAIN_NAME, chain);
 		created = true;
-	}
 
-	if (h->family == NFPROTO_BRIDGE)
-		nftnl_chain_set_u32(c, NFTNL_CHAIN_POLICY, NF_ACCEPT);
+		list = nft_chain_list_get(h, table, chain);
+		if (list)
+			nftnl_chain_list_add(c, list);
+	} else {
+		/* If the chain should vanish meanwhile, kernel genid changes
+		 * and the transaction is refreshed enabling the chain add
+		 * object. With the handle still set, kernel interprets it as a
+		 * chain replace job and errors since it is not found anymore.
+		 */
+		nftnl_chain_unset(c, NFTNL_CHAIN_HANDLE);
+	}
 
-	if (!created)
-		return 1;
+	__nft_rule_flush(h, table, chain, false, created);
 
-	if (!batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c))
+	obj = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+	if (!obj)
 		return 0;
 
-	list = nft_chain_list_get(h, table, chain);
-	if (list)
-		nftnl_chain_list_add(c, list);
+	obj->skip = !created;
 
 	/* the core expects 1 for success and 0 for error */
 	return 1;
@@ -2649,11 +2649,6 @@ static void nft_refresh_transaction(struct nft_handle *h)
 	h->error.lineno = 0;
 
 	list_for_each_entry_safe(n, tmp, &h->obj_list, head) {
-		if (n->implicit) {
-			batch_obj_del(h, n);
-			continue;
-		}
-
 		switch (n->type) {
 		case NFT_COMPAT_TABLE_FLUSH:
 			tablename = nftnl_table_get_str(n->table, NFTNL_TABLE_NAME);
@@ -2679,14 +2674,22 @@ static void nft_refresh_transaction(struct nft_handle *h)
 
 			c = nft_chain_find(h, tablename, chainname);
 			if (c) {
-				/* -restore -n flushes existing rules from redefined user-chain */
-				__nft_rule_flush(h, tablename,
-						 chainname, false, true);
 				n->skip = 1;
 			} else if (!c) {
 				n->skip = 0;
 			}
 			break;
+		case NFT_COMPAT_RULE_FLUSH:
+			tablename = nftnl_rule_get_str(n->rule, NFTNL_RULE_TABLE);
+			if (!tablename)
+				continue;
+
+			chainname = nftnl_rule_get_str(n->rule, NFTNL_RULE_CHAIN);
+			if (!chainname)
+				continue;
+
+			n->skip = !nft_chain_find(h, tablename, chainname);
+			break;
 		case NFT_COMPAT_TABLE_ADD:
 		case NFT_COMPAT_CHAIN_ADD:
 		case NFT_COMPAT_CHAIN_ZERO:
@@ -2698,7 +2701,6 @@ static void nft_refresh_transaction(struct nft_handle *h)
 		case NFT_COMPAT_RULE_INSERT:
 		case NFT_COMPAT_RULE_REPLACE:
 		case NFT_COMPAT_RULE_DELETE:
-		case NFT_COMPAT_RULE_FLUSH:
 		case NFT_COMPAT_SET_ADD:
 		case NFT_COMPAT_RULE_LIST:
 		case NFT_COMPAT_RULE_CHECK:
diff --git a/iptables/tests/shell/testcases/ipt-restore/0016-concurrent-restores_0 b/iptables/tests/shell/testcases/ipt-restore/0016-concurrent-restores_0
new file mode 100755
index 0000000000000..53ec12fa368af
--- /dev/null
+++ b/iptables/tests/shell/testcases/ipt-restore/0016-concurrent-restores_0
@@ -0,0 +1,53 @@
+#!/bin/bash
+
+set -e
+
+RS="*filter
+:INPUT ACCEPT [12024:3123388]
+:FORWARD ACCEPT [0:0]
+:OUTPUT ACCEPT [12840:2144421]
+:FOO - [0:0]
+:BAR0 - [0:0]
+:BAR1 - [0:0]
+:BAR2 - [0:0]
+:BAR3 - [0:0]
+:BAR4 - [0:0]
+:BAR5 - [0:0]
+:BAR6 - [0:0]
+:BAR7 - [0:0]
+:BAR8 - [0:0]
+:BAR9 - [0:0]
+"
+
+RS1="$RS
+-X BAR3
+-X BAR6
+-X BAR9
+-A FOO -s 9.9.0.1/32 -j BAR1
+-A FOO -s 9.9.0.2/32 -j BAR2
+-A FOO -s 9.9.0.4/32 -j BAR4
+-A FOO -s 9.9.0.5/32 -j BAR5
+-A FOO -s 9.9.0.7/32 -j BAR7
+-A FOO -s 9.9.0.8/32 -j BAR8
+COMMIT
+"
+
+RS2="$RS
+-X BAR2
+-X BAR5
+-X BAR7
+-A FOO -s 9.9.0.1/32 -j BAR1
+-A FOO -s 9.9.0.3/32 -j BAR3
+-A FOO -s 9.9.0.4/32 -j BAR4
+-A FOO -s 9.9.0.6/32 -j BAR6
+-A FOO -s 9.9.0.8/32 -j BAR8
+-A FOO -s 9.9.0.9/32 -j BAR9
+COMMIT
+"
+
+for n in $(seq 1 10); do
+	$XT_MULTI iptables-restore --noflush -w <<< "$RS1" &
+	$XT_MULTI iptables-restore --noflush -w <<< "$RS2" &
+	wait -n
+	wait -n
+done
-- 
2.28.0

