Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A63DC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:32:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E350623107
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Jan 2021 22:32:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730749AbhANWcw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Jan 2021 17:32:52 -0500
Received: from correo.us.es ([193.147.175.20]:44110 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730161AbhANWcv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Jan 2021 17:32:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 151D7303D06
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:31:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 088DEDA789
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Jan 2021 23:31:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F21B3DA73D; Thu, 14 Jan 2021 23:31:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D232DA789;
        Thu, 14 Jan 2021 23:31:19 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Jan 2021 23:31:19 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7414442DC700;
        Thu, 14 Jan 2021 23:31:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     mikhail.sennikovskii@cloud.ionos.com
Subject: [PATCH conntrack-tools 1/3] conntrack: add struct ct_cmd
Date:   Thu, 14 Jan 2021 23:32:00 +0100
Message-Id: <20210114223202.4758-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210114223202.4758-1-pablo@netfilter.org>
References: <20210114223202.4758-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new object stores the result of the command parser, this prepares
for batch support.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 125 +++++++++++++++++++++++++++++-------------------
 1 file changed, 76 insertions(+), 49 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index cc58d3f3df7f..12c9608c1003 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -2762,30 +2762,25 @@ nfct_set_nat_details(const int opt, struct nf_conntrack *ct,
 
 }
 
-int main(int argc, char *argv[])
+struct ct_cmd {
+	unsigned int	command;
+	unsigned int	cmd;
+	unsigned int	type;
+	unsigned int	event_mask;
+	int		family;
+	int		protonum;
+	size_t		socketbuffersize;
+};
+
+static void do_parse(struct ct_cmd *ct_cmd, int argc, char *argv[])
 {
-	int c, cmd;
 	unsigned int type = 0, event_mask = 0, l4flags = 0, status = 0;
-	int res = 0, partial;
+	int protonum = 0, family = AF_UNSPEC;
 	size_t socketbuffersize = 0;
-	int family = AF_UNSPEC;
-	int protonum = 0;
-	union ct_address ad;
 	unsigned int command = 0;
-
-	/* we release these objects in the exit_error() path. */
-	if (!alloc_tmpl_objects())
-		exit_error(OTHER_PROBLEM, "out of memory");
-
-	register_tcp();
-	register_udp();
-	register_udplite();
-	register_sctp();
-	register_dccp();
-	register_icmp();
-	register_icmpv6();
-	register_gre();
-	register_unknown();
+	int res = 0, partial;
+	union ct_address ad;
+	int c, cmd;
 
 	/* disable explicit missing arguments error output from getopt_long */
 	opterr = 0;
@@ -3065,27 +3060,57 @@ int main(int argc, char *argv[])
 	if (!(command & CT_HELP) && h && h->final_check)
 		h->final_check(l4flags, cmd, tmpl.ct);
 
-	switch(command) {
+	ct_cmd->command = command;
+	ct_cmd->cmd = cmd;
+	ct_cmd->family = family;
+	ct_cmd->type = type;
+	ct_cmd->protonum = protonum;
+	ct_cmd->event_mask = event_mask;
+	ct_cmd->socketbuffersize = socketbuffersize;
+}
+
+int main(int argc, char *argv[])
+{
+	struct ct_cmd _cmd = {}, *cmd = &_cmd;
+	int res = 0;
+
+	/* we release these objects in the exit_error() path. */
+	if (!alloc_tmpl_objects())
+		exit_error(OTHER_PROBLEM, "out of memory");
+
+	register_tcp();
+	register_udp();
+	register_udplite();
+	register_sctp();
+	register_dccp();
+	register_icmp();
+	register_icmpv6();
+	register_gre();
+	register_unknown();
+
+	do_parse(cmd, argc, argv);
+
+	switch(cmd->command) {
 	struct nfct_filter_dump *filter_dump;
 
 	case CT_LIST:
-		if (type == CT_TABLE_DYING) {
+		if (cmd->type == CT_TABLE_DYING) {
 			if (nfct_mnl_socket_open(0) < 0)
 				exit_error(OTHER_PROBLEM, "Can't open handler");
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_DYING,
-					    mnl_nfct_dump_cb, family);
+					    mnl_nfct_dump_cb, cmd->family);
 
 			nfct_mnl_socket_close();
 			break;
-		} else if (type == CT_TABLE_UNCONFIRMED) {
+		} else if (cmd->type == CT_TABLE_UNCONFIRMED) {
 			if (nfct_mnl_socket_open(0) < 0)
 				exit_error(OTHER_PROBLEM, "Can't open handler");
 
 			res = nfct_mnl_dump(NFNL_SUBSYS_CTNETLINK,
 					    IPCTNL_MSG_CT_GET_UNCONFIRMED,
-					    mnl_nfct_dump_cb, family);
+					    mnl_nfct_dump_cb, cmd->family);
 
 			nfct_mnl_socket_close();
 			break;
@@ -3100,7 +3125,7 @@ int main(int argc, char *argv[])
 			exit_error(PARAMETER_PROBLEM, "Can't use -z with "
 						      "filtering parameters");
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd->family);
 
 		nfct_callback_register(cth, NFCT_T_ALL, dump_cb, tmpl.ct);
 
@@ -3115,7 +3140,7 @@ int main(int argc, char *argv[])
 		}
 		nfct_filter_dump_set_attr_u8(filter_dump,
 					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+					     cmd->family);
 
 		if (options & CT_OPT_ZERO)
 			res = nfct_query(cth, NFCT_Q_DUMP_FILTER_RESET,
@@ -3139,7 +3164,7 @@ int main(int argc, char *argv[])
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfexp_callback_register(cth, NFCT_T_ALL, dump_exp_cb, NULL);
-		res = nfexp_query(cth, NFCT_Q_DUMP, &family);
+		res = nfexp_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(cth);
 
 		if (dump_xml_header_done == 0) {
@@ -3191,22 +3216,22 @@ int main(int argc, char *argv[])
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd->family);
 
 		nfct_callback_register(cth, NFCT_T_ALL, update_cb, tmpl.ct);
 
-		res = nfct_query(cth, NFCT_Q_DUMP, &family);
+		res = nfct_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(ith);
 		nfct_close(cth);
 		break;
-		
+
 	case CT_DELETE:
 		cth = nfct_open(CONNTRACK, 0);
 		ith = nfct_open(CONNTRACK, 0);
 		if (!cth || !ith)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd->family);
 
 		nfct_callback_register(cth, NFCT_T_ALL, delete_cb, tmpl.ct);
 
@@ -3221,7 +3246,7 @@ int main(int argc, char *argv[])
 		}
 		nfct_filter_dump_set_attr_u8(filter_dump,
 					     NFCT_FILTER_DUMP_L3NUM,
-					     family);
+					     cmd->family);
 
 		res = nfct_query(cth, NFCT_Q_DUMP_FILTER, filter_dump);
 
@@ -3268,7 +3293,7 @@ int main(int argc, char *argv[])
 		cth = nfct_open(CONNTRACK, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
-		res = nfct_query(cth, NFCT_Q_FLUSH_FILTER, &family);
+		res = nfct_query(cth, NFCT_Q_FLUSH_FILTER, &cmd->family);
 		nfct_close(cth);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"connection tracking table has been emptied.\n");
@@ -3278,7 +3303,7 @@ int main(int argc, char *argv[])
 		cth = nfct_open(EXPECT, 0);
 		if (!cth)
 			exit_error(OTHER_PROBLEM, "Can't open handler");
-		res = nfexp_query(cth, NFCT_Q_FLUSH, &family);
+		res = nfexp_query(cth, NFCT_Q_FLUSH, &cmd->family);
 		nfct_close(cth);
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
 		fprintf(stderr,"expectation table has been emptied.\n");
@@ -3288,11 +3313,11 @@ int main(int argc, char *argv[])
 		if (options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
-			if (event_mask & CT_EVENT_F_NEW)
+			if (cmd->event_mask & CT_EVENT_F_NEW)
 				nl_events |= NF_NETLINK_CONNTRACK_NEW;
-			if (event_mask & CT_EVENT_F_UPD)
+			if (cmd->event_mask & CT_EVENT_F_UPD)
 				nl_events |= NF_NETLINK_CONNTRACK_UPDATE;
-			if (event_mask & CT_EVENT_F_DEL)
+			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
 
 			res = nfct_mnl_socket_open(nl_events);
@@ -3306,6 +3331,8 @@ int main(int argc, char *argv[])
 			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
 		if (options & CT_OPT_BUFFERSIZE) {
+			size_t socketbuffersize = cmd->socketbuffersize;
+
 			socklen_t socklen = sizeof(socketbuffersize);
 
 			res = setsockopt(mnl_socket_get_fd(sock.mnl),
@@ -3316,7 +3343,7 @@ int main(int argc, char *argv[])
 				setsockopt(mnl_socket_get_fd(sock.mnl),
 					   SOL_SOCKET, SO_RCVBUF,
 					   &socketbuffersize,
-					   socketbuffersize);
+					   sizeof(socketbuffersize));
 			}
 			getsockopt(mnl_socket_get_fd(sock.mnl), SOL_SOCKET,
 				   SO_RCVBUF, &socketbuffersize, &socklen);
@@ -3325,7 +3352,7 @@ int main(int argc, char *argv[])
 					socketbuffersize);
 		}
 
-		nfct_filter_init(family);
+		nfct_filter_init(cmd->family, &cmd->tmpl);
 
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
@@ -3359,11 +3386,11 @@ int main(int argc, char *argv[])
 		if (options & CT_OPT_EVENT_MASK) {
 			unsigned int nl_events = 0;
 
-			if (event_mask & CT_EVENT_F_NEW)
+			if (cmd->event_mask & CT_EVENT_F_NEW)
 				nl_events |= NF_NETLINK_CONNTRACK_EXP_NEW;
-			if (event_mask & CT_EVENT_F_UPD)
+			if (cmd->event_mask & CT_EVENT_F_UPD)
 				nl_events |= NF_NETLINK_CONNTRACK_EXP_UPDATE;
-			if (event_mask & CT_EVENT_F_DEL)
+			if (cmd->event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_EXP_DESTROY;
 
 			cth = nfct_open(CONNTRACK, nl_events);
@@ -3423,7 +3450,7 @@ try_proc_count:
 			exit_error(OTHER_PROBLEM, "Can't open handler");
 
 		nfexp_callback_register(cth, NFCT_T_ALL, count_exp_cb, NULL);
-		res = nfexp_query(cth, NFCT_Q_DUMP, &family);
+		res = nfexp_query(cth, NFCT_Q_DUMP, &cmd->family);
 		nfct_close(cth);
 		printf("%d\n", counter);
 		break;
@@ -3472,7 +3499,7 @@ try_proc:
 	case CT_HELP:
 		usage(argv[0]);
 		if (options & CT_OPT_PROTO)
-			extension_help(h, protonum);
+			extension_help(h, cmd->protonum);
 		break;
 	default:
 		usage(argv[0]);
@@ -3481,17 +3508,17 @@ try_proc:
 
 	if (res < 0)
 		exit_error(OTHER_PROBLEM, "Operation failed: %s",
-			   err2str(errno, command));
+			   err2str(errno, cmd->command));
 
 	free_tmpl_objects();
 	free_options();
 	if (labelmap)
 		nfct_labelmap_destroy(labelmap);
 
-	if (command && exit_msg[cmd][0]) {
+	if (cmd->command && exit_msg[cmd->cmd][0]) {
 		fprintf(stderr, "%s v%s (conntrack-tools): ",PROGNAME,VERSION);
-		fprintf(stderr, exit_msg[cmd], counter);
-		if (counter == 0 && !(command & (CT_LIST | EXP_LIST)))
+		fprintf(stderr, exit_msg[cmd->cmd], counter);
+		if (counter == 0 && !(cmd->command & (CT_LIST | EXP_LIST)))
 			return EXIT_FAILURE;
 	}
 
-- 
2.20.1

