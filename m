From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH] libnfnetlink_conntrack updates
Date: Tue, 13 Sep 2005 00:59:36 +0200
Message-ID: <43260858.9010000@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050303040605020703080800"
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------050303040605020703080800
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

Attached a patch that I forgot to send some time ago. The list of 
changes is the following:

- Add missing files: include/libnfnetlink_conntrack/Makefile.am and 
include/Makefile.am.
- Rename list_conntrack_handler to callback_handler, IMHO a proper name 
for such function.
- Use new nfnl_open prototype: Now it's got four parameters.
- Kill recurrent definition of the structure nfnlhdr: Actually this 
should go somewhere in libnfnetlink, later.
- Ignore utils subdirectory. It contains a testsuite that is currently 
broken. Yes I know you're aware of it ;) it's on the TODO list. But 
would it be worth to fix it? I use the conntrack tool to test 
libnfnetlink_conntrack.
- ctnl_error now has a nicer definition.

BTW, I'll move libct to libconntrack as soon (as soon I get some spare 
time) as you suggested in the TODO list.

--
Pablo

--------------050303040605020703080800
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/libnfnetlink_conntrack/Makefile.am
===================================================================
--- include/libnfnetlink_conntrack/Makefile.am	(revision 0)
+++ include/libnfnetlink_conntrack/Makefile.am	(revision 0)
@@ -0,0 +1,3 @@
+
+pkginclude_HEADERS = libnfnetlink_conntrack.h
+
Index: include/Makefile.am
===================================================================
--- include/Makefile.am	(revision 0)
+++ include/Makefile.am	(revision 0)
@@ -0,0 +1,3 @@
+
+SUBDIRS = libnfnetlink_conntrack
+
Index: src/libnfnetlink_conntrack.c
===================================================================
--- src/libnfnetlink_conntrack.c	(revision 4257)
+++ src/libnfnetlink_conntrack.c	(working copy)
@@ -28,8 +28,13 @@
 #include <libnfnetlink/libnfnetlink.h>
 #include <libnfnetlink_conntrack/libnfnetlink_conntrack.h>
 
-#define ctnl_error printf
+#define ctnl_error(format, args...) fprintf(stderr, format, ## args)
 
+struct nfnlhdr {
+	struct nlmsghdr nlh;
+	struct nfgenmsg nfmsg;
+};
+
 /***********************************************************************
  * low level stuff 
  ***********************************************************************/
@@ -40,10 +45,7 @@
 
 int ctnl_wilddump_request(struct ctnl_handle *cth, int family, int type)
 {
-        struct {
-                struct nlmsghdr nlh;
-                struct nfgenmsg g;
-        } req;
+	struct nfnlhdr req;
 
 	nfnl_fill_hdr(&cth->nfnlh, &req.nlh, 0, AF_INET, 0,
 		      type, NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST);
@@ -52,8 +54,8 @@
 }
 
 /* handler used for nfnl_listen */
-static int list_conntrack_handler(struct sockaddr_nl *nladdr, 
-				  struct nlmsghdr *n, void *arg)
+static int callback_handler(struct sockaddr_nl *nladdr, 
+			    struct nlmsghdr *n, void *arg)
 {
 	struct ctnl_handle *cth = (struct ctnl_handle *) arg;
 	int type = NFNL_MSG_TYPE(n->nlmsg_type);
@@ -63,7 +65,7 @@
 	if (NFNL_SUBSYS_ID(n->nlmsg_type) != NFNL_SUBSYS_CTNETLINK &&
 	    NFNL_SUBSYS_ID(n->nlmsg_type) != NFNL_SUBSYS_CTNETLINK_EXP) {
 		ctnl_error("received message for wrong subsys, skipping\n");
-		nfnl_dump_packet(n, n->nlmsg_len, "list_conntrack_handler");
+		nfnl_dump_packet(n, n->nlmsg_len, "callback_handler");
 		return 0;
 	}
 
@@ -96,10 +98,22 @@
 	      unsigned subscriptions)
 {
 	int err;
+	u_int8_t cb_count;
 
+	switch(subsys_id) {
+		case NFNL_SUBSYS_CTNETLINK:
+			cb_count = IPCTNL_MSG_MAX;
+			break;
+		case NFNL_SUBSYS_CTNETLINK_EXP:
+			cb_count = IPCTNL_MSG_EXP_MAX;
+			break;
+		default:
+			return -ENOENT;
+			break;
+	}
 	memset(cth, 0, sizeof(*cth));
 
-	err = nfnl_open(&cth->nfnlh, subsys_id, subscriptions);
+	err = nfnl_open(&cth->nfnlh, subsys_id, cb_count, subscriptions);
 	if (err < 0) {
 		return err;
 	}
@@ -154,14 +168,10 @@
 
 int ctnl_flush_conntrack(struct ctnl_handle *cth)
 {
-	struct {
-		struct nlmsghdr nlh;
-		struct nfgenmsg g;
-	} *req;
+	struct nfnlhdr *req;
+	char buf[sizeof(*req)];
 
-	char buf[sizeof(*req)];
 	memset(&buf, 0, sizeof(buf));
-
 	req = (void *) &buf;
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
@@ -171,7 +181,7 @@
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 )
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 /**
@@ -184,7 +194,7 @@
 	if (ctnl_wilddump_request(cth, family, IPCTNL_MSG_CT_GET) < 0)
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 int ctnl_list_conntrack_zero_counters(struct ctnl_handle *cth, int family)
@@ -192,19 +202,14 @@
 	if (ctnl_wilddump_request(cth, family, IPCTNL_MSG_CT_GET_CTRZERO) < 0)
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 int ctnl_event_conntrack(struct ctnl_handle *cth, int family)
 {
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
-struct nfnlhdr {
-	struct nlmsghdr nlh;
-	struct nfgenmsg nfmsg;
-}; 
-
 static void ctnl_build_tuple_ip(struct nfnlhdr *req, int size,
 			        struct ctnl_tuple *t)
 {
@@ -271,10 +276,16 @@
 	nest = nfnl_nest(&req->nlh, size, CTA_PROTOINFO);
 
 	switch (ct->tuple[CTNL_DIR_ORIGINAL].protonum) {
-	case IPPROTO_TCP:
+	case IPPROTO_TCP: {
+		struct nfattr *nest_proto;
+		nest_proto = nfnl_nest(&req->nlh, size, CTA_PROTOINFO_TCP);
 		nfnl_addattr_l(&req->nlh, size, CTA_PROTOINFO_TCP_STATE,
 			       &ct->protoinfo.tcp.state, sizeof(u_int8_t));
+		nfnl_nest_end(&req->nlh, nest_proto);
 		break;
+		}
+	default:
+		break;
 	}
 
 	nfnl_nest_end(&req->nlh, nest);
@@ -369,7 +380,7 @@
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0)
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 /**
@@ -397,7 +408,7 @@
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0)
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 static int new_update_conntrack(struct ctnl_handle *cth,
 				struct ctnl_conntrack *ct,
@@ -418,7 +429,7 @@
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 )
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 /**
@@ -446,13 +457,13 @@
 	if (ctnl_wilddump_request(cth, family, IPCTNL_MSG_EXP_GET) < 0)
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 
 }
 
 int ctnl_event_expect(struct ctnl_handle *cth, int family)
 {
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 int ctnl_flush_expect(struct ctnl_handle *cth)
@@ -470,7 +481,7 @@
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 )
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 /**
@@ -507,12 +518,10 @@
 			   sizeof(timeout)) < 0)
 		return -1;
 
-	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
-		ctnl_error("error while nfnl_send\n");
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 )
 		return -1;
-	}
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 /**
@@ -539,7 +548,7 @@
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0)
 		return -1;
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
 int ctnl_get_expect(struct ctnl_handle *cth, 
@@ -557,11 +566,9 @@
 
 	ctnl_build_tuple(req, sizeof(buf), tuple, CTA_EXPECT_MASTER);
 
-	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
-		ctnl_error("error while nfnl_send\n");
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 )
 		return -1;
-	}
 
-	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+	return nfnl_listen(&cth->nfnlh, &callback_handler, cth);
 }
 
Index: Makefile.am
===================================================================
--- Makefile.am	(revision 4257)
+++ Makefile.am	(working copy)
@@ -1,7 +1,7 @@
 AUTOMAKE_OPTIONS = foreign
 
 INCLUDES =$(all_includes) -I$(top_srcdir)/include -I${KERNELDIR}
-SUBDIRS	= include src utils
+SUBDIRS	= include src
 LINKOPTS = -lnfnetlink
 
 man_MANS = #nfnetlink_conntrack.3 nfnetlink_conntrack.7

--------------050303040605020703080800--
