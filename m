From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [ebtables-compat-experimental6 PATCH v2] iptables: xtables-eb: fix
 renaming of chains
Date: Mon, 24 Nov 2014 19:43:05 +0100
Message-ID: <20141124184305.1910.4067.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: giuseppelng@gmail.com, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46407 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754362AbaKXSnR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Nov 2014 13:43:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Renaming of chains is not working. and ebtables-compat gets:
 libnftnl: attribute 0 assertion failed in chain.c:159

This patch brings back the parser code of the original ebtables tool:
 http://git.netfilter.org/ebtables.old-history/tree/userspace/ebtables2/ebtables.c#n652

I adaped the original parser code to fit in the new environment. Also tried to
keep original error messages as much as possible.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-eb.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 47af78f..51811cf 100644
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
@@ -643,7 +644,21 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 			}
 
 			if (c == 'E') {
-				ret = nft_chain_user_rename(h, chain, *table, newname);
+				if (optind >= argc)
+					xtables_error(PARAMETER_PROBLEM, "No new chain name  specified");
+				else if (optind < argc - 1)
+					xtables_error(PARAMETER_PROBLEM, "No extra options allowed with -E");
+				else if (strlen(argv[optind]) >= NFT_CHAIN_MAXNAMELEN)
+					xtables_error(PARAMETER_PROBLEM, "Chain name length can't exceed %d"" characters", NFT_CHAIN_MAXNAMELEN - 1);
+				else if (strchr(argv[optind], ' ') != NULL)
+					xtables_error(PARAMETER_PROBLEM, "Use of ' ' not allowed in chain names");
+
+				ret = nft_chain_user_rename(h, chain, *table,
+							    argv[optind]);
+				if (ret != 0 && errno == ENOENT)
+					xtables_error(PARAMETER_PROBLEM, "Chain '%s' doesn't exists", chain);
+
+				optind++;
 				break;
 			} else if (c == 'D' && optind < argc && (argv[optind][0] != '-' || (argv[optind][1] >= '0' && argv[optind][1] <= '9'))) {
 				if (optind != argc - 1)

