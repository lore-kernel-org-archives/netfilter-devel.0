From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH conntrack-tools] nfct: timeout: add support for default protocol timeout tuning
Date: Mon, 30 Sep 2013 19:25:33 +0200
Message-ID: <1380561933-25102-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40154 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab3I3RZu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:25:50 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This new interface supersedes the /proc interface:

/proc/sys/net/netfilter/nf_conntrack_PROTO_STATE_timeout

to tune default conntrack timeout helpers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netfilter/nfnetlink_cttimeout.h |    2 +
 include/nfct.h                                |    2 +
 src/nfct-extensions/timeout.c                 |  155 ++++++++++++++++++++++++-
 3 files changed, 157 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_cttimeout.h b/include/linux/netfilter/nfnetlink_cttimeout.h
index a2810a7..1ab0b97 100644
--- a/include/linux/netfilter/nfnetlink_cttimeout.h
+++ b/include/linux/netfilter/nfnetlink_cttimeout.h
@@ -6,6 +6,8 @@ enum ctnl_timeout_msg_types {
 	IPCTNL_MSG_TIMEOUT_NEW,
 	IPCTNL_MSG_TIMEOUT_GET,
 	IPCTNL_MSG_TIMEOUT_DELETE,
+	IPCTNL_MSG_TIMEOUT_DEFAULT_SET,
+	IPCTNL_MSG_TIMEOUT_DEFAULT_GET,
 
 	IPCTNL_MSG_TIMEOUT_MAX
 };
diff --git a/include/nfct.h b/include/nfct.h
index ddf9038..f40985c 100644
--- a/include/nfct.h
+++ b/include/nfct.h
@@ -19,6 +19,8 @@ enum {
 	NFCT_CMD_GET,
 	NFCT_CMD_FLUSH,
 	NFCT_CMD_DISABLE,
+	NFCT_CMD_DEFAULT_SET,
+	NFCT_CMD_DEFAULT_GET,
 };
 
 #define __init __attribute__((constructor))
diff --git a/src/nfct-extensions/timeout.c b/src/nfct-extensions/timeout.c
index 0cf92bb..7142bcd 100644
--- a/src/nfct-extensions/timeout.c
+++ b/src/nfct-extensions/timeout.c
@@ -32,8 +32,8 @@ static void
 nfct_cmd_timeout_usage(char *argv[])
 {
 	fprintf(stderr, "nfct v%s: Missing command\n"
-			"%s timeout list|add|delete|get|flush "
-			"[parameters...]\n", VERSION, argv[0]);
+			"%s timeout <list|add|delete|get|flush|set> "
+			"[<parameters>, ...]\n", VERSION, argv[0]);
 }
 
 static int nfct_cmd_timeout_list(int argc, char *argv[]);
@@ -41,6 +41,8 @@ static int nfct_cmd_timeout_add(int argc, char *argv[]);
 static int nfct_cmd_timeout_delete(int argc, char *argv[]);
 static int nfct_cmd_timeout_get(int argc, char *argv[]);
 static int nfct_cmd_timeout_flush(int argc, char *argv[]);
+static int nfct_cmd_timeout_default_set(int argc, char *argv[]);
+static int nfct_cmd_timeout_default_get(int argc, char *argv[]);
 
 static int nfct_cmd_timeout_parse_params(int argc, char *argv[])
 {
@@ -60,6 +62,10 @@ static int nfct_cmd_timeout_parse_params(int argc, char *argv[])
 		cmd = NFCT_CMD_GET;
 	else if (strncmp(argv[2], "flush", strlen(argv[2])) == 0)
 		cmd = NFCT_CMD_FLUSH;
+	else if (strncmp(argv[2], "default-set", strlen(argv[2])) == 0)
+		cmd = NFCT_CMD_DEFAULT_SET;
+	else if (strncmp(argv[2], "default-get", strlen(argv[2])) == 0)
+		cmd = NFCT_CMD_DEFAULT_GET;
 	else {
 		fprintf(stderr, "nfct v%s: Unknown command: %s\n",
 			VERSION, argv[2]);
@@ -82,6 +88,12 @@ static int nfct_cmd_timeout_parse_params(int argc, char *argv[])
 	case NFCT_CMD_FLUSH:
 		ret = nfct_cmd_timeout_flush(argc, argv);
 		break;
+	case NFCT_CMD_DEFAULT_SET:
+		ret = nfct_cmd_timeout_default_set(argc, argv);
+		break;
+	case NFCT_CMD_DEFAULT_GET:
+		ret = nfct_cmd_timeout_default_get(argc, argv);
+		break;
 	}
 
 	return ret;
@@ -524,6 +536,145 @@ int nfct_cmd_timeout_flush(int argc, char *argv[])
 	return 0;
 }
 
+static int nfct_cmd_timeout_default_set(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nfct_timeout *t;
+	int ret;
+
+	if (argc < 6) {
+		nfct_perror("missing parameters\n"
+			    "syntax: nfct timeout default-set "
+			    "family protocol state1 "
+			    "timeout1 state2 timeout2...");
+		return -1;
+	}
+
+	t = nfct_timeout_alloc();
+	if (t == NULL)
+		return -1;
+
+	if (nfct_cmd_timeout_parse(t, argc-3, &argv[3]) < 0)
+		return -1;
+
+	seq = time(NULL);
+	nlh = nfct_timeout_nlmsg_build_hdr(buf, IPCTNL_MSG_TIMEOUT_DEFAULT_SET,
+					   NLM_F_ACK, seq);
+	nfct_timeout_nlmsg_build_payload(nlh, t);
+	nfct_timeout_free(t);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		nfct_perror("mnl_socket_open");
+		return -1;
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		nfct_perror("mnl_socket_bind");
+		return -1;
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		nfct_perror("mnl_socket_send");
+		return -1;
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, NULL, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		nfct_perror("error");
+		return -1;
+	}
+
+	mnl_socket_close(nl);
+
+	return 0;
+}
+
+static int nfct_cmd_timeout_default_get(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nfct_timeout *t;
+	int ret, l3proto, l4proto;
+
+	if (argc < 3) {
+		nfct_perror("missing parameters\n"
+			    "syntax: nfct timeout default-get "
+			    "family protocol");
+		return -1;
+	}
+
+	t = nfct_timeout_alloc();
+	if (t == NULL)
+		return -1;
+
+	argc-=3;
+	argv+=3;
+
+	l3proto = nfct_cmd_get_l3proto(argv);
+	if (l3proto < 0)
+		return -1;
+
+	nfct_timeout_attr_set_u16(t, NFCT_TIMEOUT_ATTR_L3PROTO, l3proto);
+	argc--;
+	argv++;
+
+	l4proto = nfct_cmd_get_l4proto(argv);
+	if (l4proto < 0)
+		return -1;
+
+	nfct_timeout_attr_set_u8(t, NFCT_TIMEOUT_ATTR_L4PROTO, l4proto);
+
+	seq = time(NULL);
+	nlh = nfct_timeout_nlmsg_build_hdr(buf, IPCTNL_MSG_TIMEOUT_DEFAULT_GET,
+					   NLM_F_ACK, seq);
+	nfct_timeout_nlmsg_build_payload(nlh, t);
+	nfct_timeout_free(t);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		nfct_perror("mnl_socket_open");
+		return -1;
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		nfct_perror("mnl_socket_bind");
+		return -1;
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		nfct_perror("mnl_socket_send");
+		return -1;
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, nfct_timeout_cb, NULL);
+		if (ret <= 0)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		nfct_perror("error");
+		return -1;
+	}
+	mnl_socket_close(nl);
+
+	return 0;
+}
 static struct nfct_extension timeout = {
 	.type		= NFCT_SUBSYS_TIMEOUT,
 	.parse_params	= nfct_cmd_timeout_parse_params,
-- 
1.7.10.4

