From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-nftables PATCH 1/5] nft: let nft_handle struct own the builtin table pointer
Date: Fri, 26 Jul 2013 13:05:15 +0200
Message-ID: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:40509 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756790Ab3GZLFz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 07:05:55 -0400
Received: by mail-wg0-f48.google.com with SMTP id f12so2041073wgh.3
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2013 04:05:54 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch adds own builtin_table pointer used by future tool (like arptables)
to have own tables and not tables declared in nft.c

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c                |   22 +++-------------------
 iptables/nft.h                |   24 +++++++++++++++++++++++-
 iptables/xtables-config.c     |    2 +-
 iptables/xtables-restore.c    |    2 +-
 iptables/xtables-save.c       |    2 +-
 iptables/xtables-standalone.c |    2 +-
 6 files changed, 30 insertions(+), 24 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 9a857b9..5665148 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -80,24 +80,7 @@ static int mnl_talk(struct nft_handle *h, struct nlmsghdr *nlh,
 	return 0;
 }
 
-#define FILTER		0
-#define MANGLE		1
-#define RAW		2
-#define SECURITY	3
-#define NAT		4
-#define TABLES_MAX	5
-
-struct builtin_chain {
-	const char *name;
-	const char *type;
-	uint32_t prio;
-	uint32_t hook;
-};
-
-static struct builtin_table {
-	const char *name;
-	struct builtin_chain chains[NF_INET_NUMHOOKS];
-} tables[TABLES_MAX] = {
+struct builtin_table xtables_ipv4[TABLES_MAX] = {
 	[RAW] = {
 		.name	= "raw",
 		.chains = {
@@ -389,7 +372,7 @@ static bool nft_chain_builtin(struct nft_chain *c)
 	return nft_chain_attr_get(c, NFT_CHAIN_ATTR_HOOKNUM) != NULL;
 }
 
-int nft_init(struct nft_handle *h)
+int nft_init(struct nft_handle *h, struct builtin_table *t)
 {
 	h->nl = mnl_socket_open(NETLINK_NETFILTER);
 	if (h->nl == NULL) {
@@ -402,6 +385,7 @@ int nft_init(struct nft_handle *h)
 		return -1;
 	}
 	h->portid = mnl_socket_get_portid(h->nl);
+	h->tables = t;
 
 	return 0;
 }
diff --git a/iptables/nft.h b/iptables/nft.h
index 7a6351b..f3317c9 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -4,6 +4,25 @@
 #include "xshared.h"
 #include "nft-shared.h"
 
+#define FILTER         0
+#define MANGLE         1
+#define RAW            2
+#define SECURITY       3
+#define NAT            4
+#define TABLES_MAX     5
+
+struct builtin_chain {
+	const char *name;
+	const char *type;
+	uint32_t prio;
+	uint32_t hook;
+};
+
+struct builtin_table {
+	const char *name;
+	struct builtin_chain chains[NF_INET_NUMHOOKS];
+};
+
 struct nft_handle {
 	int			family;
 	struct mnl_socket	*nl;
@@ -11,9 +30,12 @@ struct nft_handle {
 	uint32_t		seq;
 	bool			commit;
 	struct nft_family_ops	*ops;
+	struct builtin_table	*tables;
 };
 
-int nft_init(struct nft_handle *h);
+extern struct builtin_table xtables_ipv4[TABLES_MAX];
+
+int nft_init(struct nft_handle *h, struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 
 /*
diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
index 515b18b..b7cf609 100644
--- a/iptables/xtables-config.c
+++ b/iptables/xtables-config.c
@@ -35,7 +35,7 @@ int xtables_config_main(int argc, char *argv[])
 	else
 		filename = argv[1];
 
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, xtables_ipv4) < 0) {
                 fprintf(stderr, "Failed to initialize nft: %s\n",
 			strerror(errno));
 		return EXIT_FAILURE;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 8469ba1..608e189 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -193,7 +193,7 @@ xtables_restore_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, xtables_ipv4) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 41ceaf5..db03090 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -96,7 +96,7 @@ xtables_save_main(int argc, char *argv[])
 	init_extensions();
 	init_extensions4();
 #endif
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, xtables_ipv4) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 3f8b981..9d5a667 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -61,7 +61,7 @@ xtables_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, xtables_ipv4) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
-- 
1.7.8.6

