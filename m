From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental5 PATCH] iptables: xtables-eb: fix
 renaming of chains
Date: Thu, 20 Nov 2014 13:09:32 +0100
Message-ID: <20141120120931.24603.59259.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:52879 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751517AbaKTMJn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2014 07:09:43 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Renaming of chains is not working. and ebtables-compat gets:
 libnftnl: attribute 0 assertion failed in chain.c:159

This patch brings back the parser code of the original ebtables tool:
 http://git.netfilter.org/ebtables.old-history/tree/userspace/ebtables2/ebtables.c#n652

I adaped the original parser code to fit in the new environment, plus fixing
style issues.
In the nft backend, some minor changes are needed to support this operation,
for example to avoid calling the nf_tables API with NLM_F_EXCL.

I also tried to keep original error messages as much as possible.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/nft.c                   |   12 +++++++++++-
 iptables/xtables-eb-standalone.c |    2 +-
 iptables/xtables-eb.c            |   33 +++++++++++++++++++++++++++++++--
 3 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index 4ee22c5..7cd56ef 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -253,6 +253,7 @@ enum obj_update_type {
 	NFT_COMPAT_CHAIN_USER_ADD,
 	NFT_COMPAT_CHAIN_USER_DEL,
 	NFT_COMPAT_CHAIN_UPDATE,
+	NFT_COMPAT_CHAIN_RENAME,
 	NFT_COMPAT_RULE_APPEND,
 	NFT_COMPAT_RULE_INSERT,
 	NFT_COMPAT_RULE_REPLACE,
@@ -1508,10 +1509,15 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	uint64_t handle;
 	int ret;
 
+	nft_fn = nft_chain_user_add;
+
 	/* If built-in chains don't exist for this table, create them */
 	if (nft_xtables_config_load(h, XTABLES_CONFIG_DEFAULT, 0) < 0)
 		nft_xt_builtin_init(h, table);
 
+	/* Config load changed errno. Ensure genuine info for our callers. */
+	errno = 0;
+
 	/* Find the old chain to be renamed */
 	c = nft_chain_find(h, table, chain);
 	if (c == NULL) {
@@ -1530,7 +1536,7 @@ int nft_chain_user_rename(struct nft_handle *h,const char *chain,
 	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_HANDLE, handle);
 
 	if (h->batch_support) {
-		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_USER_ADD, c);
+		ret = batch_chain_add(h, NFT_COMPAT_CHAIN_RENAME, c);
 	} else {
 		char buf[MNL_SOCKET_BUFFER_SIZE];
 		struct nlmsghdr *nlh;
@@ -2279,6 +2285,10 @@ static int nft_action(struct nft_handle *h, int action)
 						     NLM_F_CREATE : 0,
 						   seq++, n->chain);
 			break;
+		case NFT_COMPAT_CHAIN_RENAME:
+			nft_compat_chain_batch_add(h, NFT_MSG_NEWCHAIN, 0,
+						   seq++, n->chain);
+			break;
 		case NFT_COMPAT_RULE_APPEND:
 			nft_compat_rule_batch_add(h, NFT_MSG_NEWRULE,
 						  NLM_F_CREATE | NLM_F_APPEND,
diff --git a/iptables/xtables-eb-standalone.c b/iptables/xtables-eb-standalone.c
index 1c3cbf0..740a420 100644
--- a/iptables/xtables-eb-standalone.c
+++ b/iptables/xtables-eb-standalone.c
@@ -84,7 +84,7 @@ int xtables_eb_main(int argc, char *argv[])
 		ret = nft_commit(&h);
 
 	if (!ret)
-		fprintf(stderr, "%s\n", nft_strerror(errno));
+		xtables_error(OTHER_PROBLEM, "%s\n", nft_strerror(errno));
 
 	exit(!ret);
 }
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 0775ee7..e5220c3 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -21,6 +21,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#include <errno.h>
 #include <getopt.h>
 #include <string.h>
 #include <stdio.h>
@@ -32,6 +33,7 @@
 #include <xtables.h>
 
 #include <linux/netfilter_bridge.h>
+#include <linux/netfilter/nf_tables.h>
 #include <ebtables/ethernetdb.h>
 #include "xshared.h"
 #include "nft.h"
@@ -582,7 +584,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 	struct ebtables_command_state cs;
 	char command = 'h';
 	const char *chain = NULL;
-	const char *newname = NULL;
 	const char *policy = NULL;
 	int exec_style = EXEC_STYLE_PRG;
 	int selected_chain = -1;
@@ -643,7 +644,35 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 			}
 
 			if (c == 'E') {
-				ret = nft_chain_user_rename(h, chain, *table, newname);
+				if (optind >= argc) {
+					xtables_error(PARAMETER_PROBLEM,
+						      "No new chain name"
+						      " specified");
+				} else if (optind < argc - 1) {
+					xtables_error(PARAMETER_PROBLEM,
+						      "No extra options "
+						      "allowed with -E");
+				} else if (strlen(argv[optind]) >=
+					   NFT_CHAIN_MAXNAMELEN) {
+					xtables_error(PARAMETER_PROBLEM,
+						      "Chain name length can't"
+						      " exceed %d"" characters",
+						      NFT_CHAIN_MAXNAMELEN - 1);
+				} else if (strchr(argv[optind], ' ') != NULL) {
+					xtables_error(PARAMETER_PROBLEM,
+						      "Use of ' ' not allowed "
+						      "in chain names");
+				}
+
+				ret = nft_chain_user_rename(h, chain, *table,
+							    argv[optind]);
+				if (ret != 0 && errno == ENOENT) {
+					xtables_error(PARAMETER_PROBLEM,
+						      "Chain '%s' doesn't"
+						      " exists",
+						      chain);
+				}
+				optind++;
 				break;
 			} else if (c == 'D' && optind < argc && (argv[optind][0] != '-' || (argv[optind][1] >= '0' && argv[optind][1] <= '9'))) {
 				if (optind != argc - 1)

