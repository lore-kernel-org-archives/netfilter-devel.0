Return-Path: <SRS0=AQmx=Q3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B56AC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Feb 2019 18:51:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C08320859
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Feb 2019 18:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfBTSvn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Feb 2019 13:51:43 -0500
Received: from mail.us.es ([193.147.175.20]:37604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbfBTSvn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Feb 2019 13:51:43 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 877E71031E9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75A64FC5E0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6B182FC5E1; Wed, 20 Feb 2019 19:51:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D4A1FC5E0
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Feb 2019 19:51:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 43C5B4265A4C
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Feb 2019 19:51:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH conntrack-tools 2/3] conntrack: use libmnl for conntrack events
Date:   Wed, 20 Feb 2019 19:51:33 +0100
Message-Id: <20190220185134.3608-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190220185134.3608-1-pablo@netfilter.org>
References: <20190220185134.3608-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use libmnl instead libnfnetlink infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/conntrack.c | 120 +++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 37 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index a5861cbb85ce..e3abe9ff698e 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -64,6 +64,11 @@
 #include <libmnl/libmnl.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
+static struct nfct_mnl_socket {
+	struct mnl_socket	*mnl;
+	uint32_t		portid;
+} sock;
+
 struct u32_mask {
 	uint32_t value;
 	uint32_t mask;
@@ -1397,7 +1402,7 @@ event_sighandler(int s)
 
 	fprintf(stderr, "%s v%s (conntrack-tools): ", PROGNAME, VERSION);
 	fprintf(stderr, "%d flow events have been shown.\n", counter);
-	nfct_close(cth);
+	mnl_socket_close(sock.mnl);
 	exit(0);
 }
 
@@ -1415,17 +1420,40 @@ exp_event_sighandler(int s)
 	exit(0);
 }
 
-static int event_cb(enum nf_conntrack_msg_type type,
-		    struct nf_conntrack *ct,
-		    void *data)
+static int event_cb(const struct nlmsghdr *nlh, void *data)
 {
-	char buf[1024];
-	struct nf_conntrack *obj = data;
 	unsigned int op_type = NFCT_O_DEFAULT;
+	struct nf_conntrack *obj = data;
+	enum nf_conntrack_msg_type type;
 	unsigned int op_flags = 0;
+	struct nf_conntrack *ct;
+	char buf[1024];
+
+	switch(nlh->nlmsg_type & 0xff) {
+	case IPCTNL_MSG_CT_NEW:
+		if (nlh->nlmsg_flags & NLM_F_CREATE)
+			type = NFCT_T_NEW;
+		else
+			type = NFCT_T_UPDATE;
+		break;
+	case IPCTNL_MSG_CT_DELETE:
+		type = NFCT_T_DESTROY;
+		break;
+	default:
+		/* Unknown event type. */
+		type = 0;
+		break;
+	}
+
+	ct = nfct_new();
+	if (!ct)
+		goto out;
+
+	if (nfct_nlmsg_parse(nlh, ct) < 0)
+		goto out;
 
 	if (nfct_filter(obj, ct))
-		return NFCT_CB_CONTINUE;
+		goto out;
 
 	if (output_mask & _O_XML) {
 		op_type = NFCT_O_XML;
@@ -1434,7 +1462,7 @@ static int event_cb(enum nf_conntrack_msg_type type,
 			printf("<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
 			       "<conntrack>\n");
 		}
-	} 
+	}
 	if (output_mask & _O_EXT)
 		op_flags = NFCT_OF_SHOW_LAYER3;
 	if (output_mask & _O_TMS) {
@@ -1456,8 +1484,9 @@ static int event_cb(enum nf_conntrack_msg_type type,
 	fflush(stdout);
 
 	counter++;
-
-	return NFCT_CB_CONTINUE;
+out:
+	nfct_destroy(ct);
+	return MNL_CB_OK;
 }
 
 static int dump_cb(enum nf_conntrack_msg_type type,
@@ -1843,11 +1872,6 @@ out_err:
 	return ret;
 }
 
-static struct nfct_mnl_socket {
-	struct mnl_socket	*mnl;
-	uint32_t		portid;
-} sock;
-
 static int nfct_mnl_socket_open(unsigned int events)
 {
 	sock.mnl = mnl_socket_open(NETLINK_NETFILTER);
@@ -2791,42 +2815,64 @@ int main(int argc, char *argv[])
 			if (event_mask & CT_EVENT_F_DEL)
 				nl_events |= NF_NETLINK_CONNTRACK_DESTROY;
 
-			cth = nfct_open(CONNTRACK, nl_events);
+			res = nfct_mnl_socket_open(nl_events);
 		} else {
-			cth = nfct_open(CONNTRACK,
-					NF_NETLINK_CONNTRACK_NEW |
-					NF_NETLINK_CONNTRACK_UPDATE |
-					NF_NETLINK_CONNTRACK_DESTROY);
+			res = nfct_mnl_socket_open(NF_NETLINK_CONNTRACK_NEW |
+						   NF_NETLINK_CONNTRACK_UPDATE |
+						   NF_NETLINK_CONNTRACK_DESTROY);
 		}
 
-		if (!cth)
-			exit_error(OTHER_PROBLEM, "Can't open handler");
+		if (res < 0)
+			exit_error(OTHER_PROBLEM, "Can't open netlink socket");
 
 		if (options & CT_OPT_BUFFERSIZE) {
-			size_t ret;
-			ret = nfnl_rcvbufsiz(nfct_nfnlh(cth), socketbuffersize);
+			socklen_t socklen = sizeof(socketbuffersize);
+
+			res = setsockopt(mnl_socket_get_fd(sock.mnl),
+					 SOL_SOCKET, SO_RCVBUFFORCE,
+					 &socketbuffersize,
+					 sizeof(socketbuffersize));
+			if (res < 0) {
+				setsockopt(mnl_socket_get_fd(sock.mnl),
+					   SOL_SOCKET, SO_RCVBUF,
+					   &socketbuffersize,
+					   socketbuffersize);
+			}
+			getsockopt(mnl_socket_get_fd(sock.mnl), SOL_SOCKET,
+				   SO_RCVBUF, &socketbuffersize, &socklen);
 			fprintf(stderr, "NOTICE: Netlink socket buffer size "
-					"has been set to %zu bytes.\n", ret);
+					"has been set to %zu bytes.\n",
+					socketbuffersize);
 		}
 
 		nfct_filter_init(family);
 
 		signal(SIGINT, event_sighandler);
 		signal(SIGTERM, event_sighandler);
-		nfct_callback_register(cth, NFCT_T_ALL, event_cb, tmpl.ct);
-		res = nfct_catch(cth);
-		if (res == -1) {
-			if (errno == ENOBUFS) {
-				fprintf(stderr, 
-					"WARNING: We have hit ENOBUFS! We "
-					"are losing events.\nThis message "
-					"means that the current netlink "
-					"socket buffer size is too small.\n"
-					"Please, check --buffer-size in "
-					"conntrack(8) manpage.\n");
+
+		while (1) {
+			char buf[MNL_SOCKET_BUFFER_SIZE];
+
+			res = mnl_socket_recvfrom(sock.mnl, buf, sizeof(buf));
+			if (res < 0) {
+				if (errno == ENOBUFS) {
+					fprintf(stderr,
+						"WARNING: We have hit ENOBUFS! We "
+						"are losing events.\nThis message "
+						"means that the current netlink "
+						"socket buffer size is too small.\n"
+						"Please, check --buffer-size in "
+						"conntrack(8) manpage.\n");
+					continue;
+				}
+				exit_error(OTHER_PROBLEM,
+					   "failed to received netlink event: %s",
+					   strerror(errno));
+				break;
 			}
+			res = mnl_cb_run(buf, res, 0, 0, event_cb, tmpl.ct);
 		}
-		nfct_close(cth);
+		mnl_socket_close(sock.mnl);
 		break;
 
 	case EXP_EVENT:
-- 
2.11.0

