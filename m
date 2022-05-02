Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF32C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 May 2022 16:03:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386144AbiEBQGx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 May 2022 12:06:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386283AbiEBQGn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 May 2022 12:06:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D712F1408A
        for <netfilter-devel@vger.kernel.org>; Mon,  2 May 2022 09:02:31 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@ionos.com
Subject: [PATCH conntrack] conntrack: consolidate socket open call
Date:   Mon,  2 May 2022 18:02:27 +0200
Message-Id: <20220502160227.187287-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Create netlink socket once and reuse it, rather than open + close it
over and over again.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 65 +++++++++++++------------------------------------
 1 file changed, 17 insertions(+), 48 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 679a1d27e250..e3659cafd2b6 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -75,6 +75,7 @@ struct nfct_mnl_socket {
 
 static struct nfct_mnl_socket _sock;
 static struct nfct_mnl_socket _modifier_sock;
+static struct nfct_mnl_socket _event_sock;
 
 struct u32_mask {
 	uint32_t value;
@@ -2429,7 +2430,7 @@ out_err:
 }
 
 static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
-		      unsigned int events)
+				unsigned int events)
 {
 	socket->mnl = mnl_socket_open(NETLINK_NETFILTER);
 	if (socket->mnl == NULL) {
@@ -3267,29 +3268,25 @@ static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 	ct_cmd->socketbuffersize = socketbuffersize;
 }
 
-static int do_command_ct(const char *progname, struct ct_cmd *cmd)
+static int do_command_ct(const char *progname, struct ct_cmd *cmd,
+			 struct nfct_mnl_socket *sock)
 {
 	struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
-	struct nfct_mnl_socket *sock = &_sock;
+	struct nfct_mnl_socket *event_sock = &_event_sock;
 	struct nfct_filter_dump *filter_dump;
 	int res = 0;
 
 	switch(cmd->command) {
 	case CT_LIST:
-		if (nfct_mnl_socket_open(sock, 0) < 0)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
-
 		if (cmd->type == CT_TABLE_DYING) {
 			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close(sock);
 			break;
 		} else if (cmd->type == CT_TABLE_UNCONFIRMED) {
 			res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
 					    mnl_nfct_dump_cb, cmd, NULL);
-			nfct_mnl_socket_close(sock);
 			break;
 		}
 
@@ -3333,10 +3330,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			printf("</conntrack>\n");
 			fflush(stdout);
 		}
-
-		nfct_mnl_socket_close(sock);
 		break;
-
 	case EXP_LIST:
 		cth = nfct_open(EXPECT, 0);
 		if (!cth)
@@ -3365,10 +3359,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			nfct_set_attr(cmd->tmpl.ct, ATTR_CONNLABELS,
 					xnfct_bitmask_clone(cmd->tmpl.label_modify));
 
-		res = nfct_mnl_socket_open(sock, 0);
-		if (res < 0)
-			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
-
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
 				       IPCTNL_MSG_CT_NEW,
 				       NLM_F_CREATE | NLM_F_ACK | NLM_F_EXCL,
@@ -3376,7 +3366,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		if (res >= 0)
 			counter++;
 
-		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_CREATE:
@@ -3393,8 +3382,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_UPDATE:
-		if (nfct_mnl_socket_open(sock, 0) < 0 ||
-		    nfct_mnl_socket_open(modifier_sock, 0) < 0)
+		if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
@@ -3403,12 +3391,10 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 				    cmd, NULL);
 
 		nfct_mnl_socket_close(modifier_sock);
-		nfct_mnl_socket_close(sock);
 		break;
 
 	case CT_DELETE:
-		if (nfct_mnl_socket_open(sock, 0) < 0 ||
-		    nfct_mnl_socket_open(modifier_sock, 0) < 0)
+		if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfct_filter_init(cmd);
@@ -3433,7 +3419,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		nfct_filter_dump_destroy(filter_dump);
 
 		nfct_mnl_socket_close(modifier_sock);
-		nfct_mnl_socket_close(sock);
 		break;
 
 	case EXP_DELETE:
@@ -3470,14 +3455,9 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		break;
 
 	case CT_FLUSH:
-		res = nfct_mnl_socket_open(sock, 0);
-		if (res < 0)
-			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
-
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, cmd->family,
 				       IPCTNL_MSG_CT_DELETE, NLM_F_ACK, NULL, NULL);
 
-		nfct_mnl_socket_close(sock);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
 		break;
@@ -3503,9 +3483,9 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
 
-			res = nfct_mnl_socket_open(sock, nl_events);
+			res = nfct_mnl_socket_open(event_sock, nl_events);
 		} else {
-			res = nfct_mnl_socket_open(sock,
+			res = nfct_mnl_socket_open(event_sock,
 						   NF_NETLINK_CONNTRACK_NEW |
 						   NF_NETLINK_CONNTRACK_UPDATE |
 						   NF_NETLINK_CONNTRACK_DESTROY);
@@ -3563,7 +3543,7 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 			}
 			res = mnl_cb_run(buf, res, 0, 0, event_cb, cmd);
 		}
-		mnl_socket_close(sock->mnl);
+		mnl_socket_close(event_sock->mnl);
 		break;
 
 	case EXP_EVENT:
@@ -3597,20 +3577,14 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd)
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(sock, 0) < 0)
-			goto try_proc_count;
-
 		res = nfct_mnl_request(sock, NFNL_SUBSYS_CTNETLINK, AF_UNSPEC,
 				       IPCTNL_MSG_CT_GET_STATS, 0,
 				       nfct_global_stats_cb, NULL);
 
-		nfct_mnl_socket_close(sock);
-
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
 			break;
 
-try_proc_count:
 		{
 #define NF_CONNTRACK_COUNT_PROC "/proc/sys/net/netfilter/nf_conntrack_count"
 		FILE *fd;
@@ -3642,15 +3616,10 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(sock, 0) < 0)
-			goto try_proc;
-
 		res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
 				    IPCTNL_MSG_CT_GET_STATS_CPU,
 				    nfct_stats_cb, NULL, NULL);
 
-		nfct_mnl_socket_close(sock);
-
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
 			break;
@@ -3661,15 +3630,10 @@ try_proc_count:
 		/* If we fail with netlink, fall back to /proc to ensure
 		 * backward compatibility.
 		 */
-		if (nfct_mnl_socket_open(sock, 0) < 0)
-			goto try_proc;
-
 		res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK_EXP,
 				    IPCTNL_MSG_EXP_GET_STATS_CPU,
 				    nfexp_stats_cb, NULL, NULL);
 
-		nfct_mnl_socket_close(sock);
-
 		/* don't look at /proc, we got the information via ctnetlink */
 		if (res >= 0)
 			break;
@@ -3891,6 +3855,7 @@ static const char *ct_unsupp_cmd_file(const struct ct_cmd *cmd)
 
 int main(int argc, char *argv[])
 {
+	struct nfct_mnl_socket *sock = &_sock;
 	struct ct_cmd *cmd, *next;
 	LIST_HEAD(cmd_list);
 	int res = 0;
@@ -3905,6 +3870,9 @@ int main(int argc, char *argv[])
 	register_gre();
 	register_unknown();
 
+	if (nfct_mnl_socket_open(sock, 0) < 0)
+		exit_error(OTHER_PROBLEM, "Can't open handler");
+
 	if (argc > 2 &&
 	    (!strcmp(argv[1], "-R") || !strcmp(argv[1], "--load-file"))) {
 		ct_parse_file(&cmd_list, argv[0], argv[2]);
@@ -3916,7 +3884,7 @@ int main(int argc, char *argv[])
 					   ct_unsupp_cmd_file(cmd));
 		}
 		list_for_each_entry_safe(cmd, next, &cmd_list, list) {
-			res |= do_command_ct(argv[0], cmd);
+			res |= do_command_ct(argv[0], cmd, sock);
 			list_del(&cmd->list);
 			free(cmd);
 		}
@@ -3926,10 +3894,11 @@ int main(int argc, char *argv[])
 			exit_error(OTHER_PROBLEM, "OOM");
 
 		do_parse(cmd, argc, argv);
-		do_command_ct(argv[0], cmd);
+		do_command_ct(argv[0], cmd, sock);
 		res = print_stats(cmd);
 		free(cmd);
 	}
+	nfct_mnl_socket_close(sock);
 
 	return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
-- 
2.30.2

