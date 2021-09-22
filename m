Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7787EC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B1B86109E
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Sep 2021 16:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhIVQI3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhIVQI2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Sep 2021 12:08:28 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6DCC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Sep 2021 09:06:58 -0700 (PDT)
Received: from localhost ([::1]:59564 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mT4lt-0006Ps-0J; Wed, 22 Sep 2021 18:06:57 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/4] nft: Check base-chain compatibility when adding to cache
Date:   Wed, 22 Sep 2021 18:06:30 +0200
Message-Id: <20210922160632.15635-3-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210922160632.15635-1-phil@nwl.cc>
References: <20210922160632.15635-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With introduction of dedicated base-chain slots, a selection process was
established as no longer all base-chains ended in the same chain list
for later searching/checking but only the first one found for each hook
matching criteria is kept and the rest discarded.

A side-effect of the above is that table compatibility checking started
to omit consecutive base-chains, making iptables-nft less restrictive as
long as the expected base-chains were returned first from kernel when
populating the cache.

Make behaviour consistent and warn users about the possibly disturbing
chains found by:

* Run all base-chain checks from nft_is_chain_compatible() before
  allowing a base-chain to occupy its slot.
* If an unfit base-chain was found (and discarded), flag the table's
  cache as tainted and warn about it if the remaining ruleset is
  otherwise compatible.

Since base-chains that remain in cache would pass
nft_is_chain_compatible() checking, remove that and reduce it to rule
inspection.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cache.c                          | 47 ++++++++++++++-----
 iptables/nft.c                                | 45 +++++-------------
 iptables/nft.h                                |  2 +
 .../shell/testcases/chain/0004extra-base_0    | 12 ++++-
 iptables/xtables-save.c                       |  3 ++
 5 files changed, 65 insertions(+), 44 deletions(-)

diff --git a/iptables/nft-cache.c b/iptables/nft-cache.c
index 9a03bbfbb32bb..b7f10ab923bc0 100644
--- a/iptables/nft-cache.c
+++ b/iptables/nft-cache.c
@@ -202,26 +202,51 @@ nft_chain_find(struct nft_handle *h, const char *table, const char *chain)
 	return NULL;
 }
 
+static int
+nft_cache_add_base_chain(struct nft_handle *h, const struct builtin_table *t,
+			 struct nft_chain *nc)
+{
+	uint32_t hooknum = nftnl_chain_get_u32(nc->nftnl, NFTNL_CHAIN_HOOKNUM);
+	const char *name = nftnl_chain_get_str(nc->nftnl, NFTNL_CHAIN_NAME);
+	const char *type = nftnl_chain_get_str(nc->nftnl, NFTNL_CHAIN_TYPE);
+	uint32_t prio = nftnl_chain_get_u32(nc->nftnl, NFTNL_CHAIN_PRIO);
+	const struct builtin_chain *bc = NULL;
+	int i;
+
+	for (i = 0; i < NF_IP_NUMHOOKS && t->chains[i].name != NULL; i++) {
+		if (hooknum == t->chains[i].hook) {
+			bc = &t->chains[i];
+			break;
+		}
+	}
+
+	if (!bc ||
+	    prio != bc->prio ||
+	    strcmp(name, bc->name) ||
+	    strcmp(type, bc->type))
+		return -EINVAL;
+
+	if (h->cache->table[t->type].base_chains[hooknum])
+		return -EEXIST;
+
+	h->cache->table[t->type].base_chains[hooknum] = nc;
+	return 0;
+}
+
 int nft_cache_add_chain(struct nft_handle *h, const struct builtin_table *t,
 			struct nftnl_chain *c)
 {
 	const char *cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
 	struct nft_chain *nc = nft_chain_alloc(c);
+	int ret;
 
 	if (nftnl_chain_is_set(c, NFTNL_CHAIN_HOOKNUM)) {
-		uint32_t hooknum = nftnl_chain_get_u32(c, NFTNL_CHAIN_HOOKNUM);
-
-		if (hooknum >= NF_INET_NUMHOOKS) {
+		ret = nft_cache_add_base_chain(h, t, nc);
+		if (ret) {
+			h->cache->table[t->type].tainted = true;
 			nft_chain_free(nc);
-			return -EINVAL;
+			return ret;
 		}
-
-		if (h->cache->table[t->type].base_chains[hooknum]) {
-			nft_chain_free(nc);
-			return -EEXIST;
-		}
-
-		h->cache->table[t->type].base_chains[hooknum] = nc;
 	} else {
 		list_add_tail(&nc->head,
 			      &h->cache->table[t->type].chains->list);
diff --git a/iptables/nft.c b/iptables/nft.c
index 89dde9ecca779..17e735aa694af 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3513,38 +3513,8 @@ static int nft_is_rule_compatible(struct nftnl_rule *rule, void *data)
 static int nft_is_chain_compatible(struct nft_chain *nc, void *data)
 {
 	struct nftnl_chain *c = nc->nftnl;
-	const struct builtin_table *table;
-	const struct builtin_chain *chain;
-	const char *tname, *cname, *type;
-	struct nft_handle *h = data;
-	enum nf_inet_hooks hook;
-	int prio;
-
-	if (nftnl_rule_foreach(c, nft_is_rule_compatible, NULL))
-		return -1;
-
-	if (!nft_chain_builtin(c))
-		return 0;
-
-	tname = nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE);
-	table = nft_table_builtin_find(h, tname);
-	if (!table)
-		return -1;
-
-	cname = nftnl_chain_get_str(c, NFTNL_CHAIN_NAME);
-	chain = nft_chain_builtin_find(table, cname);
-	if (!chain)
-		return -1;
 
-	type = nftnl_chain_get_str(c, NFTNL_CHAIN_TYPE);
-	prio = nftnl_chain_get_u32(c, NFTNL_CHAIN_PRIO);
-	hook = nftnl_chain_get_u32(c, NFTNL_CHAIN_HOOKNUM);
-	if (strcmp(type, chain->type) ||
-	    prio != chain->prio ||
-	    hook != chain->hook)
-		return -1;
-
-	return 0;
+	return nftnl_rule_foreach(c, nft_is_rule_compatible, NULL);
 }
 
 bool nft_is_table_compatible(struct nft_handle *h,
@@ -3559,13 +3529,24 @@ bool nft_is_table_compatible(struct nft_handle *h,
 	return !nft_chain_foreach(h, table, nft_is_chain_compatible, h);
 }
 
+bool nft_is_table_tainted(struct nft_handle *h, const char *table)
+{
+	const struct builtin_table *t = nft_table_builtin_find(h, table);
+
+	return t ? h->cache->table[t->type].tainted : false;
+}
+
 void nft_assert_table_compatible(struct nft_handle *h,
 				 const char *table, const char *chain)
 {
 	const char *pfx = "", *sfx = "";
 
-	if (nft_is_table_compatible(h, table, chain))
+	if (nft_is_table_compatible(h, table, chain)) {
+		if (nft_is_table_tainted(h, table))
+			printf("# Table `%s' contains incompatible base-chains, use 'nft' tool to list them.\n",
+			       table);
 		return;
+	}
 
 	if (chain) {
 		pfx = "chain `";
diff --git a/iptables/nft.h b/iptables/nft.h
index a7b652ff62a45..ef79b018f7836 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -45,6 +45,7 @@ struct nft_cache {
 		struct nftnl_set_list	*sets;
 		bool			exists;
 		bool			sorted;
+		bool			tainted;
 	} table[NFT_TABLE_MAX];
 };
 
@@ -262,6 +263,7 @@ void nft_rule_to_arpt_entry(struct nftnl_rule *r, struct arpt_entry *fw);
 
 bool nft_is_table_compatible(struct nft_handle *h,
 			     const char *table, const char *chain);
+bool nft_is_table_tainted(struct nft_handle *h, const char *table);
 void nft_assert_table_compatible(struct nft_handle *h,
 				 const char *table, const char *chain);
 
diff --git a/iptables/tests/shell/testcases/chain/0004extra-base_0 b/iptables/tests/shell/testcases/chain/0004extra-base_0
index 1b85b060c1487..cc07e4be31177 100755
--- a/iptables/tests/shell/testcases/chain/0004extra-base_0
+++ b/iptables/tests/shell/testcases/chain/0004extra-base_0
@@ -13,6 +13,10 @@ set -e
 
 nft -f - <<EOF
 table ip filter {
+	chain a {
+		type filter hook input priority filter
+	}
+
         chain INPUT {
                 type filter hook input priority filter
                 counter packets 218 bytes 91375 accept
@@ -24,4 +28,10 @@ table ip filter {
 }
 EOF
 
-$XT_MULTI iptables -L
+EXPECT="# Table \`filter' contains incompatible base-chains, use 'nft' tool to list them.
+-P INPUT ACCEPT
+-P FORWARD ACCEPT
+-P OUTPUT ACCEPT
+-A INPUT -j ACCEPT"
+
+diff -u -Z <(echo -e "$EXPECT") <($XT_MULTI iptables -S)
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 98cd0ed3f4716..f794e3ff1e318 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -78,6 +78,9 @@ __do_output(struct nft_handle *h, const char *tablename, void *data)
 		printf("# Table `%s' is incompatible, use 'nft' tool.\n",
 		       tablename);
 		return 0;
+	} else if (nft_is_table_tainted(h, tablename)) {
+		printf("# Table `%s' contains incompatible base-chains, use 'nft' tool to list them.\n",
+		       tablename);
 	}
 
 	now = time(NULL);
-- 
2.33.0

