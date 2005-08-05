From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] updates for libnfnetlink_conntrack
Date: Fri, 05 Aug 2005 02:39:45 +0200
Message-ID: <42F2B551.4070204@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090406000706000600000308"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
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
--------------090406000706000600000308
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

@Harald: BTW, I can reach SVN to commit changes to conntrack (timeout 
error).

This patch includes the following updates for the userspace 
libnfnetlink_conntrack library:

a) change ctnl_open prototype: Now the subsystem is passed as parameter 
to select if we work working with given subsystem, say 
NFNL_CTNETLINK_CONNTRACK[_EXP].

b) added functions ctnl_[new|get|del]_expect

c) minor change in ctnl_build_tuple that let us create tuples based on 
CTA_* and CTA_EXPECT_* attributes.

--------------090406000706000600000308
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/libnfnetlink_conntrack/libnfnetlink_conntrack.h
===================================================================
--- include/libnfnetlink_conntrack/libnfnetlink_conntrack.h	(revision 4208)
+++ include/libnfnetlink_conntrack/libnfnetlink_conntrack.h	(working copy)
@@ -99,7 +99,7 @@
 	struct ctnl_msg_handler *handler[IPCTNL_MSG_MAX];
 };
 
-extern int ctnl_open(struct ctnl_handle *, unsigned);
+extern int ctnl_open(struct ctnl_handle *, u_int8_t, unsigned);
 extern int ctnl_close(struct ctnl_handle *);
 extern int ctnl_unregister_handler(struct ctnl_handle *, int);
 extern int ctnl_register_handler(struct ctnl_handle *, 
@@ -113,6 +113,11 @@
 extern int ctnl_event_conntrack(struct ctnl_handle *, int);
 extern int ctnl_flush_conntrack(struct ctnl_handle *);
 
+extern int ctnl_new_expect(struct ctnl_handle *, struct ctnl_tuple *, 
+			   struct ctnl_tuple *, struct ctnl_tuple *, 
+			   unsigned long);
+extern int ctnl_del_expect(struct ctnl_handle *,struct ctnl_tuple *);
+extern int ctnl_get_expect(struct ctnl_handle *, struct ctnl_tuple *);
 extern int ctnl_list_expect(struct ctnl_handle *, int);
 extern int ctnl_event_expect(struct ctnl_handle *, int);
 extern int ctnl_flush_expect(struct ctnl_handle *);
Index: src/libnfnetlink_conntrack.c
===================================================================
--- src/libnfnetlink_conntrack.c	(revision 4208)
+++ src/libnfnetlink_conntrack.c	(working copy)
@@ -60,7 +60,8 @@
 	struct ctnl_msg_handler *hdlr = cth->handler[type];
 	int ret;
 
-	if (NFNL_SUBSYS_ID(n->nlmsg_type) != NFNL_SUBSYS_CTNETLINK) {
+	if (NFNL_SUBSYS_ID(n->nlmsg_type) != NFNL_SUBSYS_CTNETLINK &&
+	    NFNL_SUBSYS_ID(n->nlmsg_type) != NFNL_SUBSYS_CTNETLINK_EXP) {
 		ctnl_error("received message for wrong subsys, skipping\n");
 		nfnl_dump_packet(n, n->nlmsg_len, "list_conntrack_handler");
 		return 0;
@@ -91,13 +92,14 @@
  * cth: pointer to already allocated library handle
  * subscriptions: netlink groups we are interested in
  */
-int ctnl_open(struct ctnl_handle *cth, unsigned subscriptions)
+int ctnl_open(struct ctnl_handle *cth, u_int8_t subsys_id, 
+	      unsigned subscriptions)
 {
 	int err;
 
 	memset(cth, 0, sizeof(*cth));
 
-	err = nfnl_open(&cth->nfnlh, NFNL_SUBSYS_CTNETLINK, subscriptions);
+	err = nfnl_open(&cth->nfnlh, subsys_id, subscriptions);
 	if (err < 0) {
 		return err;
 	}
@@ -249,9 +251,8 @@
 }
 
 static void ctnl_build_tuple(struct nfnlhdr *req, int size, 
-			     struct ctnl_tuple *t, int dir)
+			     struct ctnl_tuple *t, int type)
 {
-	enum ctattr_type type = dir ? CTA_TUPLE_REPLY : CTA_TUPLE_ORIG;
 	struct nfattr *nest;
 
 	nest = nfnl_nest(&req->nlh, size, type);
@@ -329,9 +330,9 @@
 				 struct ctnl_conntrack *ct)
 {
 	ctnl_build_tuple(req, size, &ct->tuple[CTNL_DIR_ORIGINAL], 
-			 CTNL_DIR_ORIGINAL);
+			 CTA_TUPLE_ORIG);
 	ctnl_build_tuple(req, size, &ct->tuple[CTNL_DIR_REPLY],
-			 CTNL_DIR_REPLY);
+			 CTA_TUPLE_REPLY);
 	
 	nfnl_addattr_l(&req->nlh, size, CTA_STATUS, &ct->status, 
 		       sizeof(unsigned int));
@@ -382,6 +383,7 @@
 {
 	struct nfnlhdr *req;
 	char buf[CTNL_BUFFSIZE];
+	int type = dir ? CTA_TUPLE_REPLY : CTA_TUPLE_ORIG;
 
 	memset(&buf, 0, sizeof(buf));
 	req = (void *) &buf;
@@ -390,7 +392,7 @@
 		      0, AF_INET, 0, IPCTNL_MSG_CT_DELETE,
 		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST|NLM_F_ACK);
 
-	ctnl_build_tuple(req, sizeof(buf), tuple, dir); 
+	ctnl_build_tuple(req, sizeof(buf), tuple, type); 
 
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0)
 		return -1;
@@ -470,3 +472,96 @@
 
 	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
+
+/**
+ * ctnl_new_expect - create a new expectation
+ *
+ * cth: libctnetlink handle
+ * master_tuple: tuple of the master original direction
+ * t: direction, original or reply.
+ * exp_tuple: tuple of to-be-created expectation
+ * mask: mask of to-be-created expectation
+ * timeout: timeout of new expectation
+ */
+int ctnl_new_expect(struct ctnl_handle *cth,
+		    struct ctnl_tuple *master,
+		    struct ctnl_tuple *tuple,
+		    struct ctnl_tuple *mask,
+		    unsigned long timeout)
+{
+	struct nfnlhdr *req;
+	char buf[CTNL_BUFFSIZE];
+
+	memset(&buf, 0, sizeof(buf));
+	req = (void *) &buf;
+
+	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
+		      0, AF_INET, 0, IPCTNL_MSG_EXP_NEW,
+		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK);
+
+	ctnl_build_tuple(req, sizeof(buf), master, CTA_EXPECT_MASTER);
+	ctnl_build_tuple(req, sizeof(buf), tuple, CTA_EXPECT_TUPLE);
+	ctnl_build_tuple(req, sizeof(buf), mask, CTA_EXPECT_MASK);
+	
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXPECT_TIMEOUT, &timeout,
+			   sizeof(timeout)) < 0)
+		return -1;
+
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
+		ctnl_error("error while nfnl_send\n");
+		return -1;
+	}
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+}
+
+/**
+ * ctnl_del_expect - delete an expectation from conntrack subsystem
+ *
+ * cth: libctnetlink handle
+ * t: tuple of to-be-deleted expectation
+ */
+int ctnl_del_expect(struct ctnl_handle *cth, 
+		    struct ctnl_tuple *tuple)
+{
+	struct nfnlhdr *req;
+	char buf[CTNL_BUFFSIZE];
+
+	memset(&buf, 0, sizeof(buf));
+	req = (void *) &buf;
+
+	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
+		      0, AF_INET, 0, IPCTNL_MSG_EXP_DELETE,
+		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST|NLM_F_ACK);
+
+	ctnl_build_tuple(req, sizeof(buf), tuple, CTA_EXPECT_MASTER);
+
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0)
+		return -1;
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+}
+
+int ctnl_get_expect(struct ctnl_handle *cth, 
+		    struct ctnl_tuple *tuple)
+{
+	struct nfnlhdr *req;
+	char buf[CTNL_BUFFSIZE];
+
+	memset(&buf, 0, sizeof(buf));
+	req = (void *) &buf;
+
+	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
+			0, AF_INET, 0, IPCTNL_MSG_EXP_GET,
+			NLM_F_REQUEST|NLM_F_ACK);
+
+	ctnl_build_tuple(req, sizeof(buf), tuple, CTA_EXPECT_MASTER);
+
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
+		ctnl_error("error while nfnl_send\n");
+		return -1;
+	}
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+}
+

--------------090406000706000600000308--
