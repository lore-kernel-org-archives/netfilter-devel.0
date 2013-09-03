From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/3] conntrack: minor cleanup
Date: Tue,  3 Sep 2013 17:28:40 +0200
Message-ID: <1378222122-29415-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54101 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab3ICP2x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:28:53 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Rename get_table to generic "optional argument handling" helper,
so it can be re-used in upcoming patch.

While at it, avoid copy&paste of "labelmap" handling.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/conntrack.c |   41 +++++++++++++++++++----------------------
 1 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 7d2a365..2567c08 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -890,20 +890,20 @@ add_command(unsigned int *cmd, const int newcmd)
 	*cmd |= newcmd;
 }
 
-static char *get_table(int argc, char *argv[])
+static char *get_optional_arg(int argc, char *argv[])
 {
-	char *table = NULL;
+	char *arg = NULL;
 
 	/* Nasty bug or feature in getopt_long ?
 	 * It seems that it behaves badly with optional arguments.
 	 * Fortunately, I just stole the fix from iptables ;) */
 	if (optarg)
-		return 0;
+		return arg;
 	else if (optind < argc && argv[optind][0] != '-' &&
 		 argv[optind][0] != '!')
-		table = argv[optind++];
+		arg = argv[optind++];
 
-	return table;
+	return arg;
 }
 
 enum {
@@ -915,7 +915,7 @@ enum {
 
 static unsigned int check_type(int argc, char *argv[])
 {
-	const char *table = get_table(argc, argv);
+	const char *table = get_optional_arg(argc, argv);
 
 	/* default to conntrack subsystem if nothing has been specified. */
 	if (table == NULL)
@@ -1818,6 +1818,15 @@ static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
 
 static struct ctproto_handler *h;
 
+static void labelmap_init(void)
+{
+	if (labelmap)
+		return;
+	labelmap = nfct_labelmap_new(NULL);
+	if (!labelmap)
+		perror("nfct_labelmap_new");
+}
+
 int main(int argc, char *argv[])
 {
 	int c, cmd;
@@ -1970,12 +1979,8 @@ int main(int argc, char *argv[])
 		case 'o':
 			options |= CT_OPT_OUTPUT;
 			parse_parameter(optarg, &output_mask, PARSE_OUTPUT);
-			if (output_mask & _O_CL) {
-				if (!labelmap)
-					labelmap = nfct_labelmap_new(NULL);
-				if (!labelmap)
-					perror("nfct_labelmap_new");
-			}
+			if (output_mask & _O_CL)
+				labelmap_init();
 			break;
 		case 'z':
 			options |= CT_OPT_ZERO;
@@ -1987,12 +1992,7 @@ int main(int argc, char *argv[])
 
 			options |= opt2type[c];
 
-			if (optarg)
-				continue;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
-				tmp = argv[optind++];
-
+			tmp = get_optional_arg(argc, argv);
 			if (tmp == NULL)
 				continue;
 
@@ -2023,10 +2023,7 @@ int main(int argc, char *argv[])
 			options |= opt2type[c];
 			char *optarg2 = strdup(optarg);
 
-			if (!labelmap)
-				labelmap = nfct_labelmap_new(NULL);
-			if (!labelmap)
-				exit_error(OTHER_PROBLEM, "unable to open labelmap file");
+			labelmap_init();
 
 			unsigned int max = parse_label_get_max(optarg);
 			struct nfct_bitmask * b = nfct_bitmask_new(max);
-- 
1.7.8.6

