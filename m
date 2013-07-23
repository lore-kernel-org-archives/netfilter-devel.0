From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [xtables-arptables PATCH v2 1/5] nft: add builtin_table pointer
Date: Tue, 23 Jul 2013 18:12:11 +0200
Message-ID: <20130723161200.10040.19762.stgit@localhost>
References: <20130723161017.10040.6256.stgit@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:58744 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933604Ab3GWQMb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:12:31 -0400
Received: by mail-we0-f179.google.com with SMTP id t57so2635478wes.10
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Jul 2013 09:12:30 -0700 (PDT)
Received: from [127.0.0.1] (adsl-ull-226-41.46-151.net24.it. [151.46.41.226])
        by mx.google.com with ESMTPSA id r8sm6980396wiz.5.2013.07.23.09.12.27
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Tue, 23 Jul 2013 09:12:29 -0700 (PDT)
In-Reply-To: <20130723161017.10040.6256.stgit@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft.c                |   22 +++-------------------
 iptables/nft.h                |   22 +++++++++++++++++++++-
 iptables/xtables-config.c     |    4 +++-
 iptables/xtables-restore.c    |    5 +++--
 iptables/xtables-save.c       |    5 +++--
 iptables/xtables-standalone.c |    4 +++-
 iptables/xtables.c            |    2 ++
 7 files changed, 38 insertions(+), 26 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4d6a7a3..f6dccff 100644
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
+struct builtin_table tables[TABLES_MAX] = {
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
index 7a6351b..e4d177e 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -4,6 +4,25 @@
 #include "xshared.h"
 #include "nft-shared.h"
 
+#define FILTER		0
+#define MANGLE		1
+#define RAW		2
+#define SECURITY	3
+#define NAT		4
+#define TABLES_MAX	5
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
@@ -11,9 +30,10 @@ struct nft_handle {
 	uint32_t		seq;
 	bool			commit;
 	struct nft_family_ops	*ops;
+	struct builtin_table	*tables;
 };
 
-int nft_init(struct nft_handle *h);
+int nft_init(struct nft_handle *h, struct builtin_table *t);
 void nft_fini(struct nft_handle *h);
 
 /*
diff --git a/iptables/xtables-config.c b/iptables/xtables-config.c
index 515b18b..bb87886 100644
--- a/iptables/xtables-config.c
+++ b/iptables/xtables-config.c
@@ -19,6 +19,8 @@
 #include "xtables-multi.h"
 #include "nft.h"
 
+extern struct builtin_table tables[TABLES_MAX];
+
 int xtables_config_main(int argc, char *argv[])
 {
 	struct nft_handle h = {
@@ -35,7 +37,7 @@ int xtables_config_main(int argc, char *argv[])
 	else
 		filename = argv[1];
 
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, tables) < 0) {
                 fprintf(stderr, "Failed to initialize nft: %s\n",
 			strerror(errno));
 		return EXIT_FAILURE;
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 8469ba1..b894173 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -24,6 +24,8 @@
 #define DEBUGP(x, args...)
 #endif
 
+extern struct builtin_table tables[TABLES_MAX];
+
 static int binary = 0, counters = 0, verbose = 0, noflush = 0;
 
 /* Keeping track of external matches and targets.  */
@@ -177,7 +179,6 @@ xtables_restore_main(int argc, char *argv[])
 	const struct xtc_ops *ops = &iptc_ops;
 	struct nft_chain_list *chain_list;
 	struct nft_chain *chain_obj;
-
 	line = 0;
 
 	xtables_globals.program_name = "xtables-restore";
@@ -193,7 +194,7 @@ xtables_restore_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, tables) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables-save.c b/iptables/xtables-save.c
index 41ceaf5..8a5c991 100644
--- a/iptables/xtables-save.c
+++ b/iptables/xtables-save.c
@@ -25,6 +25,8 @@
 #include <dlfcn.h>
 #endif
 
+extern struct builtin_table tables[TABLES_MAX];
+
 static bool show_counters = false;
 
 static const struct option options[] = {
@@ -82,7 +84,6 @@ xtables_save_main(int argc, char *argv[])
 		.family	= AF_INET,	/* default to AF_INET */
 	};
 	int c;
-
 	xtables_globals.program_name = "xtables-save";
 	/* XXX xtables_init_all does several things we don't want */
 	c = xtables_init_all(&xtables_globals, NFPROTO_IPV4);
@@ -96,7 +97,7 @@ xtables_save_main(int argc, char *argv[])
 	init_extensions();
 	init_extensions4();
 #endif
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, tables) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables-standalone.c b/iptables/xtables-standalone.c
index 3f8b981..bd95ff8 100644
--- a/iptables/xtables-standalone.c
+++ b/iptables/xtables-standalone.c
@@ -39,6 +39,8 @@
 #include "xtables-multi.h"
 #include "nft.h"
 
+extern struct builtin_table tables[TABLES_MAX];
+
 int
 xtables_main(int argc, char *argv[])
 {
@@ -61,7 +63,7 @@ xtables_main(int argc, char *argv[])
 	init_extensions4();
 #endif
 
-	if (nft_init(&h) < 0) {
+	if (nft_init(&h, tables) < 0) {
 		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
 				xtables_globals.program_name,
 				xtables_globals.program_version,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index c314b37..65e4882 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -50,6 +50,8 @@
 #define FALSE 0
 #endif
 
+extern struct builtin_table tables[TABLES_MAX];
+
 #define NUMBER_OF_CMD	16
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 				 'N', 'X', 'P', 'E', 'S', 'Z', 'C' };

