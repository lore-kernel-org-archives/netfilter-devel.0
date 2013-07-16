From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH 3/4] nft: nft_xtables_config_load() called
 only in nft_init()
Date: Wed, 17 Jul 2013 00:30:53 +0200
Message-ID: <20130716223053.13253.90159.stgit@nftables>
References: <20130716222925.13253.93123.stgit@nftables>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:38674 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301Ab3GVOcK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:32:10 -0400
Received: by mail-ea0-f174.google.com with SMTP id o10so3853645eaj.5
        for <netfilter-devel@vger.kernel.org>; Mon, 22 Jul 2013 07:32:09 -0700 (PDT)
Received: from [127.0.1.1] ([37.77.121.31])
        by mx.google.com with ESMTPSA id r54sm51203146eev.8.2013.07.22.07.32.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 22 Jul 2013 07:32:08 -0700 (PDT)
In-Reply-To: <20130716222925.13253.93123.stgit@nftables>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c |   28 ++++++++--------------------
 1 file changed, 8 insertions(+), 20 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 9a8986a..198c41e 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -388,6 +388,14 @@ int nft_init(struct nft_handle *h)
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = tables;
 
+	/* If built-in chains don't exist for this table, create them */
+	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0) {
+		int i;
+
+		for (i=0; i<TABLES_MAX; i++)
+			if (h->tables[i].name != NULL)
+				nft_chain_builtin_init(h, h->tables[i].name, NULL, NF_ACCEPT);
+	}
 	return 0;
 }
 
@@ -742,10 +750,6 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	uint16_t flags = NLM_F_ACK|NLM_F_CREATE;
 	int ret = 1;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
-
 	nft_fn = nft_rule_append;
 
 	r = nft_rule_new(h, chain, table, cs);
@@ -1316,10 +1320,6 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	struct nft_chain *c;
 	int ret;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
-
 	c = nft_chain_alloc();
 	if (c == NULL)
 		return 0;
@@ -1472,10 +1472,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	uint64_t handle;
 	int ret;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
-
 	/* Find the old chain to be renamed */
 	c = nft_chain_find(h, table, chain);
 	if (c == NULL) {
@@ -2170,10 +2166,6 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	struct nft_rule *r;
 	uint64_t handle;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
-
 	nft_fn = nft_rule_insert;
 
 	list = nft_rule_list_create(h);
@@ -2521,10 +2513,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	struct nft_chain *c;
 	bool found = false;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
-
 	list = nft_chain_dump(h);
 
 	iter = nft_chain_list_iter_create(list);

