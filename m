From: pablo@netfilter.org
Subject: [PATCH] conntrack: add support to dump the dying and unconfirmed list via ctnetlink
Date: Thu, 29 Nov 2012 14:52:20 +0100
Message-ID: <1354197140-8498-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab2K2Nwd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:52:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds support for:

conntrack -L dying
conntrack -L unconfirmed

To display the list of dying and unconfirmed conntracks. This provides
some instrumentation in case that `conntrack -C` really deviates from
what `conntrack -L | wc -l` says.

Users like to check this to make sure things are going OK. Still, some
conntrack objects may be still in the dying and the unconfirmed list.
With this patch, we can also dump their content, before it was not
possible.

In normal cases both lists would be simply empty, or in the case of
the dying list, you can observe that entries go slightly down in
number.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c |  108 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 95 insertions(+), 13 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 7451a80..227c355 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -822,27 +822,45 @@ add_command(unsigned int *cmd, const int newcmd)
 	*cmd |= newcmd;
 }
 
-static unsigned int
-check_type(int argc, char *argv[])
+static char *get_table(int argc, char *argv[])
 {
 	char *table = NULL;
 
-	/* Nasty bug or feature in getopt_long ? 
+	/* Nasty bug or feature in getopt_long ?
 	 * It seems that it behaves badly with optional arguments.
 	 * Fortunately, I just stole the fix from iptables ;) */
 	if (optarg)
 		return 0;
-	else if (optind < argc && argv[optind][0] != '-' 
-			&& argv[optind][0] != '!')
+	else if (optind < argc && argv[optind][0] != '-' &&
+		 argv[optind][0] != '!')
 		table = argv[optind++];
-	
-	if (!table)
-		return 0;
-		
+
+	return table;
+}
+
+enum {
+	CT_TABLE_CONNTRACK,
+	CT_TABLE_EXPECT,
+	CT_TABLE_DYING,
+	CT_TABLE_UNCONFIRMED,
+};
+
+static unsigned int check_type(int argc, char *argv[])
+{
+	const char *table = get_table(argc, argv);
+
+	/* default to conntrack subsystem if nothing has been specified. */
+	if (table == NULL)
+		return CT_TABLE_CONNTRACK;
+
 	if (strncmp("expect", table, strlen(table)) == 0)
-		return 1;
+		return CT_TABLE_EXPECT;
 	else if (strncmp("conntrack", table, strlen(table)) == 0)
-		return 0;
+		return CT_TABLE_CONNTRACK;
+	else if (strncmp("dying", table, strlen(table)) == 0)
+		return CT_TABLE_DYING;
+	else if (strncmp("unconfirmed", table, strlen(table)) == 0)
+		return CT_TABLE_UNCONFIRMED;
 	else
 		exit_error(PARAMETER_PROBLEM, "unknown type `%s'", table);
 
@@ -1686,6 +1704,27 @@ static int nfct_global_stats_cb(const struct nlmsghdr *nlh, void *data)
 	return MNL_CB_OK;
 }
 
+static int mnl_nfct_dump_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nf_conntrack *ct;
+	char buf[4096];
+
+	ct = nfct_new();
+	if (ct == NULL)
+		return MNL_CB_OK;
+
+	nfct_nlmsg_parse(nlh, ct);
+
+	nfct_snprintf(buf, sizeof(buf), ct, NFCT_T_UNKNOWN, NFCT_O_DEFAULT, 0);
+	printf("%s\n", buf);
+
+	nfct_destroy(ct);
+
+	counter++;
+
+	return MNL_CB_OK;
+}
+
 static struct ctproto_handler *h;
 
 int main(int argc, char *argv[])
@@ -1720,6 +1759,16 @@ int main(int argc, char *argv[])
 	switch(c) {
 		/* commands */
 		case 'L':
+			type = check_type(argc, argv);
+			/* Special case: dumping dying and unconfirmed list
+			 * are handled like normal conntrack dumps.
+			 */
+			if (type == CT_TABLE_DYING ||
+			    type == CT_TABLE_UNCONFIRMED)
+				add_command(&command, cmd2type[c][0]);
+			else
+				add_command(&command, cmd2type[c][type]);
+			break;
 		case 'I':
 		case 'D':
 		case 'G':
@@ -1730,14 +1779,25 @@ int main(int argc, char *argv[])
 		case 'C':
 		case 'S':
 			type = check_type(argc, argv);
+			if (type == CT_TABLE_DYING ||
+			    type == CT_TABLE_UNCONFIRMED) {
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't do that command with "
+					   "tables `dying' and `unconfirmed'");
+			}
 			add_command(&command, cmd2type[c][type]);
 			break;
 		case 'U':
 			type = check_type(argc, argv);
-			if (type == 0)
+			if (type == CT_TABLE_DYING ||
+			    type == CT_TABLE_UNCONFIRMED) {
+				exit_error(PARAMETER_PROBLEM,
+					   "Can't do that command with "
+					   "tables `dying' and `unconfirmed'");
+			} else if (type == CT_TABLE_CONNTRACK)
 				add_command(&command, CT_UPDATE);
 			else
-				exit_error(PARAMETER_PROBLEM, 
+				exit_error(PARAMETER_PROBLEM,
 					   "Can't update expectations");
 			break;
 		/* options */
@@ -1937,6 +1997,28 @@ int main(int argc, char *argv[])
 	struct nfct_filter_dump *filter_dump;
 
 	case CT_LIST:
+		if (type == CT_TABLE_DYING) {
+			if (nfct_mnl_socket_open() < 0)
+				exit_error(OTHER_PROBLEM, "Can't open handler");
+
+			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+					    IPCTNL_MSG_CT_GET_DYING,
+					    mnl_nfct_dump_cb);
+
+			nfct_mnl_socket_close();
+			break;
+		} else if (type == CT_TABLE_UNCONFIRMED) {
+			if (nfct_mnl_socket_open() < 0)
+				exit_error(OTHER_PROBLEM, "Can't open handler");
+
+			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
+					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
+					    mnl_nfct_dump_cb);
+
+			nfct_mnl_socket_close();
+			break;
+		}
+
 		cth = nfct_open(CONNTRACK, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
-- 
1.7.10.4

