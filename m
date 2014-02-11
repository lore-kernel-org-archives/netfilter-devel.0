From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: [iptables (nft-compat) PATCH 8/8] nft: Initialize according to requested table, if any
Date: Tue, 11 Feb 2014 12:46:48 +0200
Message-ID: <1392115608-6733-9-git-send-email-tomasz.bursztyka@linux.intel.com>
References: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:16550 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751687AbaBKKrL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:47:11 -0500
In-Reply-To: <1392115608-6733-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will prevent too much overhead when initializing the table when
loading the configuration on builtin tables.

Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
---
 iptables/nft.c                | 41 +++++++++++++++++++++++++++++++++--------
 iptables/nft.h                |  4 +++-
 iptables/xtables-arp.c        |  2 +-
 iptables/xtables-config.c     |  2 +-
 iptables/xtables-restore.c    | 16 ++++++++--------
 iptables/xtables-save.c       | 16 ++++++++--------
 iptables/xtables-standalone.c |  2 +-
 iptables/xtables.c            |  1 +
 8 files changed, 56 insertions(+), 28 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 0283d92..4166046 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -436,6 +436,9 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 	struct nft_table *t;
 	int ret;
 
+	if (h->table && h->initialized)
+		return 0;
+
 	t = nft_table_alloc();
 	if (t == NULL)
 		return -1;
@@ -463,7 +466,11 @@ nft_table_builtin_add(struct nft_handle *h, struct builtin_table *_t,
 	if (ret < 0) {
 		if (errno != EEXIST)
 			perror("mnl-talk:nft_table_init_one");
-	}
+		else
+			h->initialized = true;
+	} else
+		h->initialized = true;
+
 	return ret;
 }
 
@@ -576,7 +583,10 @@ nft_chain_builtin_init(struct nft_handle *h, const char *table,
 		       const char *chain, int policy)
 {
 	int ret = 0;
-	struct builtin_table *t;
+	struct builtin_table *t = NULL;
+
+	if (strcmp(table, h->table) == 0 && h->initialized)
+		goto builtin_chain;
 
 	t = nft_table_builtin_find(h, table);
 	if (t == NULL) {
@@ -588,6 +598,8 @@ nft_chain_builtin_init(struct nft_handle *h, const char *table,
 		if (errno == EEXIST)
 			goto out;
 	}
+	h->initialized = true;
+builtin_chain:
 	__nft_chain_builtin_init(h, t, chain, policy);
 out:
 	return ret;
@@ -601,7 +613,7 @@ static bool nft_chain_builtin(struct nft_chain *c)
 	return nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM) != NULL;
 }
 
-int nft_init(struct nft_handle *h, struct builtin_table *t)
+int nft_init(struct nft_handle *h, struct builtin_table *t, const char *table)
 {
 	h->nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (h->nl == NULL) {
@@ -615,6 +627,8 @@ int nft_init(struct nft_handle *h, struct builtin_table *t)
 	}
 	h->portid = mnl_socket_get_portid(h->nl);
 	h->tables = t;
+	h->table = table;
+	h->initialized = false;
 
 	INIT_LIST_HEAD(&h->rule_list);
 
@@ -2439,8 +2453,12 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	struct nft_table *table;
 	struct nft_chain *chain;
 	uint32_t table_family, chain_family;
+	char *table_name;
 	bool found = false;
 
+	if (h->initialized)
+		return 0;
+
 	if (xtables_config_parse(filename, table_list, chain_list) < 0) {
 		if (errno == ENOENT) {
 			xtables_config_perror(flags,
@@ -2462,24 +2480,29 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 		if (h->family != table_family)
 			continue;
 
+		table_name = (char *)nft_table_attr_get(table,
+							NFT_TABLE_ATTR_NAME);
+		if (h->table && strcmp(h->table, table_name))
+				continue;
+
 		found = true;
 
 		if (nft_table_add(h, table) < 0) {
 			if (errno == EEXIST) {
 				xtables_config_perror(flags,
 					"table `%s' already exists, skipping\n",
-					(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME));
+					table_name);
 			} else {
 				xtables_config_perror(flags,
-					"table `%s' cannot be create, reason `%s'. Exitting\n",
-					(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME),
-					strerror(errno));
+					"table `%s' cannot be create, "
+					"reason `%s'. Exitting\n",
+					table_name, strerror(errno));
 				goto err;
 			}
 			continue;
 		}
 		xtables_config_perror(flags, "table `%s' has been created\n",
-			(char *)nft_table_attr_get(table, NFT_TABLE_ATTR_NAME));
+				      table_name);
 	}
 	nft_table_list_iter_destroy(titer);
 	nft_table_list_free(table_list);
@@ -2519,6 +2542,8 @@ int nft_xtables_config_load(struct nft_handle *h, const char *filename,
 	nft_chain_list_iter_destroy(citer);
 	nft_chain_list_free(chain_list);
 
+	h->initialized = true;
+
 	return 0;
 
 err:
diff --git a/iptables/nft.h b/iptables/nft.h
index 8b64f8b..c38516c 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -34,7 +34,9 @@ struct nft_handle {
 	struct mnl_nlmsg_batch	*batch;
 	struct nft_family_ops	*ops;
 	struct builtin_table	*tables;
+	const char		*table;
 	bool			restore;
+	bool			initialized;
 };
 
 extern struct builtin_table xtables_ipv4[TABLES_MAX];
@@ -43,7 +45,7 @@ extern struct builtin_table xtables_arp[TABLES_MAX];
 int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	     int (*cb)(const struct nlmsghdr *nlh, void *data),
 	     void *data);
-int nft_init(struct nft_handle *h, struct builtin_table *t);
+int nft_init(struct nft_handle *h, struct builtin_table *t, const char *table);
 void nft_fini(struct nft_handle *h);
 
 /*
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 0c79a38..4acf012 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -1377,7 +1377,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 				"chain name `%s' too long (must be under %i chars)",
 				chain, ARPT_FUNCTION_MAXNAMELEN);
 
-	if (nft_init(h, xtables_arp) < 0)
+	if (nft_init(h, xtables_arp, *table) < 0)
 		xtables_error(OTHER_PROBLEM,
 			      "Could not initialize nftables layer.");
 
diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
index b7cf609..807a9d7 100644
--- a/iptables/xtables-config.c
+++ b/iptables/xtables-config.c
@@ -35,7 +35,7 @@ int xtables_config_main(int argc, char *argv[])
 	else
 		filename = argv[1];
 
-	if (nft_init(&h, xtables_ipv4) < 0) {
+	if (nft_init(&h, xtables_ipv4, NULL) < 0) {
                 fprintf(stderr, "Failed to initialize nft: %s\n",
 			strerror(errno));
 		return EXIT_FAILURE;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 0498abc..56bcf78 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -197,14 +197,6 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
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
@@ -256,6 +248,14 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 	}
 	else in = stdin;
 
+	if (nft_init(&h, xtables_ipv4, tablename) < 0) {
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
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 93065cf..65d279e 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -97,14 +97,6 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 	init_extensions();
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
 	while ((c = getopt_long(argc, argv, "bcdt:46", options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
@@ -136,6 +128,14 @@ xtables_save_main(int family, const char *progname, int argc, char *argv[])
 		exit(1);
 	}
 
+	if (nft_init(&h, xtables_ipv4, tablename) < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version,
+				strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
 	if (dump) {
 		do_output(&h, tablename, show_counters);
 		exit(0);
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 355a446..f7d7d95 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -61,7 +61,7 @@ xtables_main(int family, const char *progname, int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h, xtables_ipv4) < 0) {
+	if (nft_init(&h, xtables_ipv4, table) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 7a8ace3..051f2fa 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -987,6 +987,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			*table = optarg;
+			h->table = *table;
 			break;
 
 		case 'x':
-- 
1.8.3.2

