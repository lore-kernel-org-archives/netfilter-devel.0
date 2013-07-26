From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH 3/5] nft: nft_xtables_config_load() called only in nft_init()
Date: Fri, 26 Jul 2013 13:05:17 +0200
Message-ID: <1374836719-27596-3-git-send-email-giuseppelng@gmail.com>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:42116 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758067Ab3GZLGB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:06:01 -0400
Received: by mail-wi0-f179.google.com with SMTP id hj3so699559wib.12
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 04:06:00 -0700 (PDT)
In-Reply-To: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes nft_xtables_config_load called at only one unique place
instead of multiple ones but for xtables-config since it tries to load
a different file than default one.

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c                |   29 +++++++++--------------------
 iptables/xtables-config.c     |   15 +++++++++++----
 iptables/xtables-restore.c    |   16 ++++++++--------
 iptables/xtables-standalone.c |   14 +++-----------
 iptables/xtables.c            |    4 ++++
 5 files changed, 35 insertions(+), 43 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 0b45c93..bb1a1da 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -388,6 +388,15 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
 
+	/* If built-in chains don't exist for this table, create them */
+	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0) {
+		int i;
+
+		for (i = 0; i < TABLES_MAX; i++)
+			nft_chain_builtin_init(h, h->tables[i].name,
+					       NULL, NF_ACCEPT);
+	}
+
 	return 0;
 }
 
@@ -742,10 +751,6 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	uint16_t flags = NLM_F_ACK|NLM_F_CREATE;
 	int ret = 1;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
-
 	nft_fn = nft_rule_append;
 
 	r = nft_rule_new(h, chain, table, cs);
@@ -1322,10 +1327,6 @@ int nft_chain_user_add(struct nft_handle *h, const char *chain, const char *tabl
 	struct nft_chain *c;
 	int ret;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
-
 	c = nft_chain_alloc();
 	if (c == NULL)
 		return 0;
@@ -1478,10 +1479,6 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	uint64_t handle;
 	int ret;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
-
 	/* Find the old chain to be renamed */
 	c = nft_chain_find(h, table, chain);
 	if (c == NULL) {
@@ -2177,10 +2174,6 @@ int nft_rule_insert(struct nft_handle *h, const char *chain,
 	struct nft_rule *r;
 	uint64_t handle = 0;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, chain, NF_ACCEPT);
-
 	nft_fn = nft_rule_insert;
 
 	if (rulenum > 0) {
@@ -2525,10 +2518,6 @@ int nft_rule_list(struct nft_handle *h, const char *chain, const char *table,
 	struct nft_chain *c;
 	bool found = false;
 
-	/* If built-in chains don't exist for this table, create them */
-	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
-		nft_chain_builtin_init(h, table, NULL, NF_ACCEPT);
-
 	list = nft_chain_dump(h);
 
 	iter = nft_chain_list_iter_create(list);
diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
index b7cf609..d61b762 100644
--- a/iptables/xtables-config.c
+++ b/iptables/xtables-config.c
@@ -15,6 +15,7 @@
 #include <stdbool.h>
 #include <string.h>
 #include <errno.h>
+#include <libmnl/libmnl.h>
 
 #include "xtables-multi.h"
 #include "nft.h"
@@ -35,11 +36,17 @@ int xtables_config_main(int argc, char *argv[])
 	else
 		filename = argv[1];
 
-	if (nft_init(&h, xtables_ipv4) < 0) {
-                fprintf(stderr, "Failed to initialize nft: %s\n",
-			strerror(errno));
-		return EXIT_FAILURE;
+	h.nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (h.nl == NULL) {
+		perror("mnl_socket_open");
+		return -1;
 	}
+	if (mnl_socket_bind(h.nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		perror("mnl_socket_bind");
+		return -1;
+	}
+	h.portid = mnl_socket_get_portid(h.nl);
+	h.tables = xtables_ipv4;
 
 	return nft_xtables_config_load(&h, filename, NFT_LOAD_VERBOSE) == 0 ?
 						    EXIT_SUCCESS : EXIT_FAILURE;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 608e189..dda314d 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -193,14 +193,6 @@ xtables_restore_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h, xtables_ipv4) < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version,
-				strerror(errno));
-		exit(EXIT_FAILURE);
-	}
-
 	while ((c = getopt_long(argc, argv, "bcvthnM:T:46", options, NULL)) != -1) {
 		switch (c) {
 			case 'b':
@@ -252,6 +244,14 @@ xtables_restore_main(int argc, char *argv[])
 	}
 	else in = stdin;
 
+	if (nft_init(&h, xtables_ipv4) < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version,
+				strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
 	chain_list = nft_chain_dump(&h);
 	if (chain_list == NULL)
 		xtables_error(OTHER_PROBLEM, "cannot retrieve chain list\n");
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 9d5a667..ccce5ba 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -44,9 +44,9 @@ xtables_main(int argc, char *argv[])
 {
 	int ret;
 	char *table = "filter";
-	struct nft_handle h;
-
-	memset(&h, 0, sizeof(h));
+	struct nft_handle h = {
+		.family = AF_INET
+	};
 
 	xtables_globals.program_name = "xtables";
 	ret = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
@@ -61,14 +61,6 @@ xtables_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h, xtables_ipv4) < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version,
-				strerror(errno));
-		exit(EXIT_FAILURE);
-	}
-
 	ret = do_commandx(&h, argc, argv, &table);
 	if (!ret) {
 		if (errno == EINVAL) {
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 7a6509a..59f38a9 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1114,6 +1114,10 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table)
 	if (h->ops == NULL)
 		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
+	if (nft_init(h, xtables_ipv4) < 0)
+		xtables_error(OTHER_PROBLEM,
+			      "Could not initialize nftables layer.");
+
 	h->ops->post_parse(command, &cs, &args);
 
 	if (command == CMD_REPLACE &&
-- 
1.7.8.6

