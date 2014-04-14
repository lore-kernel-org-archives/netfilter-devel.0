From: mathieu.poirier@linaro.org
Subject: [PATCH 2/2] nfacct: adding quota capabilities
Date: Sun, 13 Apr 2014 18:54:37 -0600
Message-ID: <1397436877-32458-2-git-send-email-mathieu.poirier@linaro.org>
References: <1397436877-32458-1-git-send-email-mathieu.poirier@linaro.org>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	mathieu.poirier@linaro.org, john.stultz@linaro.org
To: pablo@netfilter.org
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1397436877-32458-1-git-send-email-mathieu.poirier@linaro.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Mathieu Poirier <mathieu.poirier@linaro.org>

The accounting framework now supports quota at the packet and byte
level.  The tool is simply enhanced with two optional arguments to
specify the whether accounting for byte of packet and the limit
associated with each.  Also adding a monitor mode that listens for
quota attainment notification.

Examples:

/* create an accounting object that isn't associated to a quota */
$ nfacct add first_no_quota

/* create a quota object with byte count limited to 50 byte */
$ nfacct add second_quota byte 50

/* create a quota object with packet count limited to 5 */
$ nfacct add third_quota packet 5

>From there the accounting objects can be used in iptables the same
way as they did before:

/* limit the number of icmp packets allowed through the OUTPUT chain */
$ iptables -I OUTPUT -p icmp -m nfacct --nfacct-name third_quota --jump REJECT

/* listening for quota attainment notification */
$ nfacct listen

Everything else works the same way.

Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
---
 include/linux/netfilter/nfnetlink.h      |   4 +
 include/linux/netfilter/nfnetlink_acct.h |   9 ++
 src/nfacct.c                             | 140 +++++++++++++++++++++++++++----
 3 files changed, 137 insertions(+), 16 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index b64454c..ea27bb6 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -18,6 +18,10 @@ enum nfnetlink_groups {
 #define NFNLGRP_CONNTRACK_EXP_UPDATE	NFNLGRP_CONNTRACK_EXP_UPDATE
 	NFNLGRP_CONNTRACK_EXP_DESTROY,
 #define NFNLGRP_CONNTRACK_EXP_DESTROY	NFNLGRP_CONNTRACK_EXP_DESTROY
+	NFNLGRP_NFTABLES,
+#define NFNLGRP_NFTABLES		NFNLGRP_NFTABLES
+	NFNLGRP_ACCT_QUOTA,
+#define NFNLGRP_ACCT_QUOTA		NFNLGRP_ACCT_QUOTA
 	__NFNLGRP_MAX,
 };
 #define NFNLGRP_MAX	(__NFNLGRP_MAX - 1)
diff --git a/include/linux/netfilter/nfnetlink_acct.h b/include/linux/netfilter/nfnetlink_acct.h
index 7c4279b..44dcd17 100644
--- a/include/linux/netfilter/nfnetlink_acct.h
+++ b/include/linux/netfilter/nfnetlink_acct.h
@@ -10,15 +10,24 @@ enum nfnl_acct_msg_types {
 	NFNL_MSG_ACCT_GET,
 	NFNL_MSG_ACCT_GET_CTRZERO,
 	NFNL_MSG_ACCT_DEL,
+	NFNL_MSG_ACCT_OVERQUOTA,
 	NFNL_MSG_ACCT_MAX
 };
 
+enum nfnl_acct_flags {
+	NFACCT_F_QUOTA_PKTS     = (1 << 0),
+	NFACCT_F_QUOTA_BYTES    = (1 << 1),
+	NFACCT_F_OVERQUOTA      = (1 << 2), /* can't be set from userspace */
+};
+
 enum nfnl_acct_type {
 	NFACCT_UNSPEC,
 	NFACCT_NAME,
 	NFACCT_PKTS,
 	NFACCT_BYTES,
 	NFACCT_USE,
+	NFACCT_FLAGS,
+	NFACCT_QUOTA,
 	__NFACCT_MAX
 };
 #define NFACCT_MAX (__NFACCT_MAX - 1)
diff --git a/src/nfacct.c b/src/nfacct.c
index 2ef93c3..139aced 100644
--- a/src/nfacct.c
+++ b/src/nfacct.c
@@ -22,6 +22,8 @@
 
 #include <libmnl/libmnl.h>
 #include <libnetfilter_acct/libnetfilter_acct.h>
+#include <linux/netfilter/nfnetlink_acct.h>
+#include <linux/netfilter/nfnetlink.h>
 
 enum {
 	NFACCT_CMD_NONE = 0,
@@ -33,6 +35,7 @@ enum {
 	NFACCT_CMD_VERSION,
 	NFACCT_CMD_HELP,
 	NFACCT_CMD_RESTORE,
+	NFACCT_CMD_LISTEN,
 };
 
 static int nfacct_cmd_list(int argc, char *argv[]);
@@ -43,6 +46,7 @@ static int nfacct_cmd_flush(int argc, char *argv[]);
 static int nfacct_cmd_version(int argc, char *argv[]);
 static int nfacct_cmd_help(int argc, char *argv[]);
 static int nfacct_cmd_restore(int argc, char *argv[]);
+static int nfacct_cmd_listen(int argc, char *argv[]);
 
 static void usage(char *argv[])
 {
@@ -84,6 +88,8 @@ int main(int argc, char *argv[])
 		cmd = NFACCT_CMD_HELP;
 	else if (strncmp(argv[1], "restore", strlen(argv[1])) == 0)
 		cmd = NFACCT_CMD_RESTORE;
+	else if (strncmp(argv[1], "listen", strlen(argv[1])) == 0)
+		cmd = NFACCT_CMD_LISTEN;
 	else {
 		fprintf(stderr, "nfacct v%s: Unknown command: %s\n",
 			VERSION, argv[1]);
@@ -116,6 +122,9 @@ int main(int argc, char *argv[])
 	case NFACCT_CMD_RESTORE:
 		ret = nfacct_cmd_restore(argc, argv);
 		break;
+	case NFACCT_CMD_LISTEN:
+		ret = nfacct_cmd_listen(argc, argv);
+		break;
 	}
 	return ret < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
 }
@@ -219,7 +228,8 @@ static int nfacct_cmd_list(int argc, char *argv[])
 	return 0;
 }
 
-static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
+static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes,
+			  uint32_t flags, uint64_t quota)
 {
 	struct mnl_socket *nl;
 	char buf[MNL_SOCKET_BUFFER_SIZE];
@@ -238,6 +248,10 @@ static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
 
 	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_PKTS, pkts);
 	nfacct_attr_set_u64(nfacct, NFACCT_ATTR_BYTES, bytes);
+	if (flags) {
+		nfacct_attr_set(nfacct, NFACCT_ATTR_FLAGS, &flags);
+		nfacct_attr_set_u64(nfacct, NFACCT_ATTR_QUOTA, quota);
+	}
 
 	seq = time(NULL);
 	nlh = nfacct_nlmsg_build_hdr(buf, NFNL_MSG_ACCT_NEW,
@@ -279,19 +293,47 @@ static int _nfacct_cmd_add(char *name, uint64_t pkts, uint64_t bytes)
 	return 0;
 }
 
-
-
 static int nfacct_cmd_add(int argc, char *argv[])
 {
+	int mode, ret;
+	uint64_t quota;
+
 	if (argc < 3) {
 		nfacct_perror("missing object name");
 		return -1;
-	} else if (argc > 3) {
+	}
+
+	if (argc == 3)
+		return _nfacct_cmd_add(argv[2], 0, 0, 0, 0);
+
+	if (argc == 4) {
+		nfacct_perror("missing quota value");
+		return -1;
+	}
+
+	if (argc == 5) {
+		if (strcmp(argv[3], "byte") && strcmp(argv[3], "packet")) {
+			nfacct_perror("argument must "
+				      "\"byte\" or \"packet\"");
+			return -1;
+		}
+	}
+
+	if (argc > 5) {
 		nfacct_perror("too many arguments");
 		return -1;
 	}
 
-	return _nfacct_cmd_add(argv[2], 0, 0);
+	mode = (strcmp(argv[3], "byte") == 0 ?
+		NFACCT_F_QUOTA_BYTES : NFACCT_F_QUOTA_PKTS);
+
+	ret = sscanf(argv[4], "%"PRIu64"", &quota);
+	if (ret != 1) {
+		nfacct_perror("error reading quota");
+		return -1;
+	}
+
+	return _nfacct_cmd_add(argv[2], 0, 0, mode, quota);
 }
 
 static int nfacct_cmd_delete(int argc, char *argv[])
@@ -515,6 +557,7 @@ static const char help_msg[] =
 	"  get object-name\tGet existing accounting object\n"
 	"  flush\t\t\tFlush accounting object table\n"
 	"  restore\t\tRestore accounting object table reading 'list' output from stdin\n"
+	"  listen\t\tListens for quota attainment notifications\n"
 	"  version\t\tDisplay version and disclaimer\n"
 	"  help\t\t\tDisplay this help message\n";
 
@@ -526,28 +569,93 @@ static int nfacct_cmd_help(int argc, char *argv[])
 
 static int nfacct_cmd_restore(int argc, char *argv[])
 {
-	uint64_t pkts, bytes;
-	char name[512];
-	char buffer[512];
-	int ret;
+	uint64_t pkts, bytes, quota;
+	char name[512], mode[512], buffer[512];
+	int ret, flags;
 
 	while (fgets(buffer, sizeof(buffer), stdin)) {
 		char *semicolon = strchr(buffer, ';');
+
 		if (semicolon == NULL) {
 			nfacct_perror("invalid line");
 			return -1;
 		}
+
+		/* a single ';' terminates the input */
+		if (strncmp(buffer, ";", 1) == 0)
+			break;
+
 		*semicolon = 0;
-		ret = sscanf(buffer,
-			     "{ pkts = %"PRIu64", bytes = %"PRIu64" } = %s",
-		       &pkts, &bytes, name);
-		if (ret != 3) {
-			nfacct_perror("error reading input");
-			return -1;
+		ret = flags = 0;
+		quota = 0;
+
+		if (!strstr(buffer, "quota")) {
+			ret = sscanf(buffer,
+				     "{ pkts = %"PRIu64", "
+				     "bytes = %"PRIu64" } = %s",
+				     &pkts, &bytes, name);
+
+			if (ret != 3) {
+				nfacct_perror("error reading input");
+				return -1;
+			}
+		} else {
+			ret = sscanf(buffer, "{ pkts = %"PRIu64", "
+				     "bytes = %"PRIu64", quota = %"PRIu64", "
+				     "mode = %s } = %s",
+				     &pkts, &bytes, &quota, mode, name);
+
+			if (ret != 5) {
+				nfacct_perror("error reading input");
+				return -1;
+			}
+
+			flags = (strcmp(mode, "byte") == 0 ?
+				 NFACCT_F_QUOTA_BYTES : NFACCT_F_QUOTA_PKTS);
 		}
-		if ((ret = _nfacct_cmd_add(name, pkts, bytes)) != 0)
+
+		ret = _nfacct_cmd_add(name, pkts, bytes, flags, quota);
+		if (ret != 0)
 			return ret;
+	}
+	return 0;
+}
+
+static int nfacct_cmd_listen(int argc, char *argv[])
+{
+	struct mnl_socket *nl;
+	bool xml = false;
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	int ret, stop = 0, option = NFNLGRP_ACCT_QUOTA;
 
+	nl = mnl_socket_open(NETLINK_NETFILTER);
+	if (nl == NULL) {
+		nfacct_perror("mnl_socket_open");
+		return -1;
 	}
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0) {
+		nfacct_perror("mnl_socket_bind");
+		return -1;
+	}
+
+	mnl_socket_setsockopt(nl, NETLINK_ADD_MEMBERSHIP,
+			      &option, sizeof(int));
+
+	while (!stop) {
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+		if (ret == -1) {
+			fprintf(stderr, "Problems receiving nfaccounting "
+					"notification - bailing out\n");
+			stop = 1;
+		}
+
+		ret = mnl_cb_run(buf, ret, 0, 0, nfacct_cb, &xml);
+		if (ret <= 0)
+			stop = 1;
+	}
+
+	mnl_socket_close(nl);
+
 	return 0;
 }
-- 
1.8.3.2

