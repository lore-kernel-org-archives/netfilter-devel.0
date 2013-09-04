From: valentina.giusti@bmw-carit.de
Subject: [PATCH 3/4] nfacct: Add 'notify' commands for notifications
Date: Wed,  4 Sep 2013 14:05:32 +0200
Message-ID: <1378296333-19208-4-git-send-email-valentina.giusti@bmw-carit.de>
References: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.bmw-carit.de ([62.245.222.98]:49603 "EHLO
	linuxmail.bmw-carit.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762575Ab3IDMFg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:05:36 -0400
In-Reply-To: <1378296333-19208-1-git-send-email-valentina.giusti@bmw-carit.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Valentina Giusti <valentina.giusti@bmw-carit.de>

The notify command allows to receive notifications based on intervals
expressed as bytes and packets or as time periods.

Examples of usage:
nfacct notify http-traffic bytes 1024	# notification every 1024 bytes
nfacct notify http-traffic packets 100	# notification every 100 packets
nfacct notify http-traffic period 120	# notification every 2 minutes

When the notification request specifies both a traffic target (bytes or
packets) and a time target (period), additional parameters are available,
which allow to specify a limit for the amount of notifications based on
accounted packets or bytes to be sent during a single period:

nfacct notify http-traffic bytes 1024 bytes-ratelimit 10 period 5 # sends a
notification at least every 5s and at most 10 more if 1024 bytes are
accounted

Signed-off-by: Valentina Giusti <valentina.giusti@bmw-carit.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: "David S. Miller" <davem@davemloft.net>
---
 include/linux/netfilter/nfnetlink_acct.h |    1 +
 src/nfacct.c                             |  139 ++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+)

diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 7c4279b..28c01db 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -10,6 +10,7 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_NOTIFY,
 	NFNL_MSG_ACCT_MAX
 };
 
diff --git a/src/nfacct.c b/src/nfacct.c
index 2ef93c3..eab06ea 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -29,6 +29,7 @@ enum {
 	NFACCT_CMD_ADD,
 	NFACCT_CMD_DELETE,
 	NFACCT_CMD_GET,
+	NFACCT_CMD_NOTIFY,
 	NFACCT_CMD_FLUSH,
 	NFACCT_CMD_VERSION,
 	NFACCT_CMD_HELP,
@@ -39,6 +40,7 @@ static int nfacct_cmd_list(int argc, char *argv[]);
 static int nfacct_cmd_add(int argc, char *argv[]);
 static int nfacct_cmd_delete(int argc, char *argv[]);
 static int nfacct_cmd_get(int argc, char *argv[]);
+static int nfacct_cmd_notify(int argc, char *argv[]);
 static int nfacct_cmd_flush(int argc, char *argv[]);
 static int nfacct_cmd_version(int argc, char *argv[]);
 static int nfacct_cmd_help(int argc, char *argv[]);
@@ -76,6 +78,8 @@ int main(int argc, char *argv[])
 		cmd = NFACCT_CMD_DELETE;
 	else if (strncmp(argv[1], "get", strlen(argv[1])) == 0)
 		cmd = NFACCT_CMD_GET;
+	else if (strncmp(argv[1], "notify", strlen(argv[1])) == 0)
+		cmd = NFACCT_CMD_NOTIFY;
 	else if (strncmp(argv[1], "flush", strlen(argv[1])) == 0)
 		cmd = NFACCT_CMD_FLUSH;
 	else if (strncmp(argv[1], "version", strlen(argv[1])) == 0)
@@ -104,6 +108,9 @@ int main(int argc, char *argv[])
 	case NFACCT_CMD_GET:
 		ret = nfacct_cmd_get(argc, argv);
 		break;
+	case NFACCT_CMD_NOTIFY:
+		ret = nfacct_cmd_notify(argc, argv);
+		break;
 	case NFACCT_CMD_FLUSH:
 		ret = nfacct_cmd_flush(argc, argv);
 		break;
@@ -438,6 +445,138 @@ static int nfacct_cmd_get(int argc, char *argv[])
 	return 0;
 }
 
+static int nfacct_cmd_notify(int argc, char *argv[])
+{
+	bool xml = false;
+	struct mnl_socket *nl;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct nlmsghdr *nlh;
+	uint32_t portid, seq;
+	struct nfacct *nfacct;
+	int ret, i;
+	uint32_t *bytes = NULL, *bytes_rl = NULL;
+	uint32_t *pkts = NULL, *pkts_rl = NULL;
+	uint32_t *period = NULL;
+
+	if (argc < 5) {
+		nfacct_perror("missing object name, bytes, packets or period");
+		return -1;
+	}
+
+	nfacct = nfacct_alloc();
+	if (nfacct == NULL) {
+		nfacct_perror("OOM");
+		return -1;
+	}
+	nfacct_attr_set(nfacct, NFACCT_ATTR_NAME, argv[2]);
+
+	for (i = 3; i < argc; i += 2) {
+		if (strncmp(argv[i], "xml", strlen(argv[i])) == 0) {
+			xml = true;
+		} else if (strncmp(argv[i], "bytes", strlen(argv[i])) == 0) {
+			bytes = malloc(sizeof(uint32_t));
+			if (!bytes)
+				return -ENOMEM;
+			ret = sscanf(argv[i + 1], "%u", bytes);
+			if (ret < 1)
+				goto input_error;
+			nfacct_attr_set(nfacct, NFACCT_ATTR_NOTIFY_BYTES,
+					bytes);
+		} else if (strncmp(argv[i], "bytes-ratelimit",
+			   strlen(argv[i])) == 0) {
+			if (!bytes || !*bytes)
+				goto input_error;
+			bytes_rl = malloc(sizeof(uint32_t));
+			if (!bytes_rl)
+				return -ENOMEM;
+			ret = sscanf(argv[i + 1], "%u", bytes_rl);
+			if (ret < 1 || !*bytes_rl)
+				goto input_error;
+			nfacct_attr_set(nfacct, NFACCT_ATTR_NOTIFY_B_RL,
+					bytes_rl);
+		} else if (strncmp(argv[i], "packets", strlen(argv[i])) == 0) {
+			pkts = malloc(sizeof(uint32_t));
+			if (!pkts)
+				return -ENOMEM;
+			ret = sscanf(argv[i + 1], "%u", pkts);
+			if (ret < 1)
+				goto input_error;
+			nfacct_attr_set(nfacct, NFACCT_ATTR_NOTIFY_PKTS, pkts);
+		} else if (strncmp(argv[i], "packets-ratelimit",
+			   strlen(argv[i])) == 0) {
+			if (!pkts || !*pkts)
+				goto input_error;
+			pkts_rl = malloc(sizeof(uint32_t));
+			if (!pkts_rl)
+				return -ENOMEM;
+			ret = sscanf(argv[i + 1], "%u", pkts_rl);
+			if (ret < 1 || !*pkts_rl)
+				goto input_error;
+			nfacct_attr_set(nfacct, NFACCT_ATTR_NOTIFY_P_RL,
+					pkts_rl);
+		} else if (strncmp(argv[i], "period", strlen(argv[i])) == 0) {
+			period = malloc(sizeof(uint32_t));
+			if (!period)
+				return -ENOMEM;
+			ret = sscanf(argv[i + 1], "%u", period);
+			if (ret < 1)
+				goto input_error;
+			nfacct_attr_set(nfacct, NFACCT_ATTR_NOTIFY_PERIOD,
+					period);
+		} else {
+			nfacct_perror("unknown argument");
+			return -1;
+		}
+	}
+
+	seq = time(NULL);
+	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_NOTIFY,
+				     NLM_F_ACK, seq);
+
+	nfacct_nlmsg_build_payload(nlh, nfacct);
+	nfacct_free(nfacct);
+
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		nfacct_perror("mnl_socket_open");
+		return -1;
+	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		nfacct_perror("mnl_socket_bind");
+		return -1;
+	}
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0) {
+		nfacct_perror("mnl_socket_send");
+		return -1;
+	}
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, nfacct_cb, &xml);
+		if (ret <= 0 && (errno == EINVAL || errno == ENOENT))
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1) {
+		nfacct_perror("error");
+		return -1;
+	}
+
+	mnl_socket_close(nl);
+
+	if (xml_header)
+		printf("</nfacct>\n");
+
+	return 0;
+
+input_error:
+	nfacct_perror("input error");
+	return -1;
+}
+
 static int nfacct_cmd_flush(int argc, char *argv[])
 {
 	struct mnl_socket *nl;
-- 
1.7.10.4

