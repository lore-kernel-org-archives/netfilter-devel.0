From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 2/2] updates for lib[ct|nf]netlink
Date: Mon, 27 Jun 2005 20:02:33 +0200
Message-ID: <42C03F39.7000806@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010106090308090800070603"
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
--------------010106090308090800070603
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This patch attached includes the updates to keep in sync the user space 
libraries with the kernel part.

--------------010106090308090800070603
Content-Type: text/x-patch;
 name="libs-nf-ct-netlink-2.6.12.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libs-nf-ct-netlink-2.6.12.patch"

Index: libctnetlink/libctnetlink.c
===================================================================
--- libctnetlink/libctnetlink.c	(revision 3889)
+++ libctnetlink/libctnetlink.c	(working copy)
@@ -2,6 +2,7 @@
  *
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2005 by Pablo Neira Ayuso <pablo@eurodev.net>
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com)
  *
@@ -172,7 +173,7 @@
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
 			0, AF_INET, IPCTNL_MSG_CONFIG,
-			NLM_F_REQUEST);
+			NLM_F_REQUEST|NLM_F_ACK);
 
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), type, &mask,
 				sizeof(unsigned int)) < 0) {
@@ -184,7 +185,8 @@
 		ctnl_error("error while nfnl_send\n");
 		return -1;
 	}
-	return 0;
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
 
 int ctnl_flush_conntrack(struct ctnl_handle *cth)
@@ -201,13 +203,14 @@
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
 			0, AF_INET, IPCTNL_MSG_CT_FLUSH,
-			NLM_F_REQUEST);
+			NLM_F_REQUEST|NLM_F_ACK);
 
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
 		ctnl_error("error while nfnl_send\n");
 		return -1;
 	}
-	return 0;
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
 
 /**
@@ -269,7 +272,7 @@
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
 			0, AF_INET, IPCTNL_MSG_CT_GET,
-			NLM_F_REQUEST);
+			NLM_F_REQUEST|NLM_F_ACK);
 
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, tuple,
 				sizeof(*tuple)) < 0) {
@@ -328,16 +331,14 @@
 	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
 
-/**
- * ctnl_new_conntrack - create a connection in the conntrack hashtable
- * cth: libctnetlink handle
- * t: tuple of to-be-created connection
- */
-int ctnl_new_conntrack(struct ctnl_handle *cth,
-		       struct ip_conntrack_tuple *orig,
-		       struct ip_conntrack_tuple *reply, 
-		       unsigned long timeout, struct cta_proto *proto,
-		       unsigned int status)
+static int new_update_conntrack(struct ctnl_handle *cth,
+				struct ip_conntrack_tuple *orig,
+				struct ip_conntrack_tuple *reply,
+				unsigned long timeout, 
+				struct cta_proto *proto,
+				unsigned long status,
+				struct ip_nat_range *range,
+				u_int16_t msg_flags)
 {
 	struct {
 		struct nlmsghdr nlh;
@@ -348,14 +349,15 @@
 		 + NFA_LENGTH(sizeof(*reply)) 
 		 + NFA_LENGTH(sizeof(unsigned long))
 		 + NFA_LENGTH(sizeof(*proto))
-		 + NFA_LENGTH(sizeof(unsigned int))];
+		 + NFA_LENGTH(sizeof(unsigned long))
+		 + NFA_LENGTH(sizeof(struct ip_nat_range))];
 	memset(&buf, 0, sizeof(buf));
 
 	req = (void *) &buf;
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
 		      0, AF_INET, IPCTNL_MSG_CT_NEW,
-		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK);
+		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|msg_flags);
 
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ORIG, orig, 
 			   sizeof(*orig)) < 0) {
@@ -381,8 +383,20 @@
 		return -1;
 	}
 
+	/* No range specified but NAT bits set */
+	if (!range && (status & (IPS_NAT_MASK | IPS_NAT_DONE_MASK))) {
+		status |= ~(IPS_NAT_MASK | IPS_NAT_DONE_MASK);
+		return -1;
+	}
+
+	if (range && nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_NATINFO,
+				    range, sizeof(struct ip_nat_range)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_STATUS, &status,
-			   sizeof(unsigned int)) < 0) {
+			   sizeof(unsigned long)) < 0) {
 		ctnl_error("error during nfnl_addattr_l\n");
 		return -1;
 	}
@@ -396,6 +410,31 @@
 }
 
 /**
+ * ctnl_new_conntrack - create a connection in the conntrack hashtable
+ * cth: libctnetlink handle
+ * t: tuple of to-be-created connection
+ */
+int ctnl_new_conntrack(struct ctnl_handle *cth,
+		       struct ip_conntrack_tuple *orig,
+		       struct ip_conntrack_tuple *reply, 
+		       unsigned long timeout, struct cta_proto *proto,
+		       unsigned long status, struct ip_nat_range *range)
+{
+	return new_update_conntrack(cth, orig, reply, timeout, proto, 
+				    status, range, NLM_F_EXCL);
+}
+
+int ctnl_upd_conntrack(struct ctnl_handle *cth,
+		       struct ip_conntrack_tuple *orig,
+		       struct ip_conntrack_tuple *reply,
+		       unsigned long timeout, struct cta_proto *proto,
+		       unsigned long status)
+{
+	return new_update_conntrack(cth, orig, reply, timeout, proto,
+				    status, NULL, 0);
+}
+
+/**
  * ctnl_list_expect - retrieve a list of expectations from conntrack subsys
  * cth: libctnetlink handle
  * family: AF_INET, ...
@@ -411,37 +450,170 @@
 
 }
 
+/* TODO: Don't use list_conntrack_handler */
+int ctnl_event_expect(struct ctnl_handle *cth, int family)
+{
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+} 
+
 /**
  * ctnl_del_expect - delete an expectation from conntrack subsystem
  *
  * cth: libctnetlink handle
  * t: tuple of to-be-deleted expectation
  */
-int ctnl_del_expect(struct ctnl_handle *cth, struct ip_conntrack_tuple *t)
+int ctnl_del_expect(struct ctnl_handle *cth, 
+		    struct ip_conntrack_tuple *tuple,
+		    enum ctattr_type_t t)
 {
 	struct {
 		struct nlmsghdr nlh;
 		struct nfgenmsg nfmsg;
 	} *req;
 
-	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*t))];
+	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*tuple))];
 	memset(&buf, 0, sizeof(buf));
 
 	req = (void *) &buf;
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
 		      0, AF_INET, IPCTNL_MSG_EXP_DELETE,
-		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST);
+		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST|NLM_F_ACK);
 
-	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ORIG, t, 
-			   sizeof(*t)) < 0) {
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, tuple, 
+			   sizeof(*tuple)) < 0) {
 		ctnl_error("error during nfnl_addattr_l\n");
 		return -1;
 	}
 
-	return nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf);
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0)
+		return -1;
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
 
+/**
+ * ctnl_new_expectation - create an expectation
+ * cth: libctnetlink handle
+ * t: tuple of to-be-created connection
+ */
+int ctnl_new_expect(struct ctnl_handle *cth,
+		    struct ip_conntrack_tuple *tuple,
+		    enum ctattr_type_t t,
+		    struct ip_conntrack_tuple *exptuple,
+		    struct ip_conntrack_tuple *mask,
+		    unsigned long timeout)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct nfgenmsg nfmsg;
+	} *req;
+
+	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*tuple))
+		 + NFA_LENGTH(sizeof(*exptuple))
+		 + NFA_LENGTH(sizeof(*mask))
+		 + NFA_LENGTH(sizeof(unsigned long))];
+	memset(&buf, 0, sizeof(buf));
+
+	req = (void *) &buf;
+
+	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
+		      0, AF_INET, IPCTNL_MSG_EXP_NEW,
+		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK);
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, tuple, 
+			   sizeof(*tuple)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXP_TUPLE, exptuple,
+			   sizeof(*exptuple)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXP_MASK, mask, 
+			   sizeof(*mask)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXP_TIMEOUT, &timeout, 
+			   sizeof(unsigned long)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
+		ctnl_error("error while nfnl_send\n");
+		return -1;
+	}
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+}
+
+int ctnl_get_expect(struct ctnl_handle *cth, 
+		    struct ip_conntrack_tuple *tuple,
+		    enum ctattr_type_t t)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct nfgenmsg g;
+	} *req;
+
+	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*tuple))
+		 + NFA_LENGTH(sizeof(unsigned long))];
+	memset(&buf, 0, sizeof(buf));
+
+	req = (void *) &buf;
+
+	if (tuple == NULL) {
+		ctnl_error("tuple must be specified\n");
+		return -1;
+	}
+
+	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
+			0, AF_INET, IPCTNL_MSG_EXP_GET,
+			NLM_F_REQUEST|NLM_F_ACK);
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, tuple,
+				sizeof(*tuple)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
+		ctnl_error("error while nfnl_send\n");
+		return -1;
+	}
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+}
+
+int ctnl_flush_expect(struct ctnl_handle *cth)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct nfgenmsg g;
+	} *req;
+
+	char buf[sizeof(*req)];
+	memset(&buf, 0, sizeof(buf));
+
+	req = (void *) &buf;
+
+	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
+			0, AF_INET, IPCTNL_MSG_EXP_FLUSH,
+			NLM_F_REQUEST|NLM_F_ACK);
+
+	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
+		ctnl_error("error while nfnl_send\n");
+		return -1;
+	}
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+}
+
 #if 0
 int ctnl_listen(struct ctnl_handle *cth,
 	int (*handler)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
Index: libctnetlink/libctnetlink.h
===================================================================
--- libctnetlink/libctnetlink.h	(revision 3889)
+++ libctnetlink/libctnetlink.h	(working copy)
@@ -2,6 +2,7 @@
  *
  * Jay Schulist <jschlst@samba.org>, Copyright (c) 2001.
  * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2005 by Pablo Neira Ayuso <pablo@eurodev.net>
  *
  * This software may be used and distributed according to the terms
  * of the GNU General Public License, incorporated herein by reference.
@@ -35,6 +36,16 @@
 extern int ctnl_unregister_handler(struct ctnl_handle *cth, int type);
 extern int ctnl_register_handler(struct ctnl_handle *cth, 
 				 struct ctnl_msg_handler *hndlr);
+extern int ctnl_new_conntrack(struct ctnl_handle *cth,
+			      struct ip_conntrack_tuple *orig,
+			      struct ip_conntrack_tuple *reply,
+			      unsigned long timeout, struct cta_proto *proto,
+			      unsigned long status, struct ip_nat_range *range);
+extern int ctnl_upd_conntrack(struct ctnl_handle *cth,
+			      struct ip_conntrack_tuple *orig,
+			      struct ip_conntrack_tuple *reply,
+			      unsigned long timeout, struct cta_proto *proto,
+			      unsigned long status);
 extern int ctnl_get_conntrack(struct ctnl_handle *cth,
 			      struct ip_conntrack_tuple *tuple,
 			      enum ctattr_type_t t);
@@ -43,11 +54,24 @@
 			      enum ctattr_type_t t);
 extern int ctnl_list_conntrack(struct ctnl_handle *cth, int family);
 extern int ctnl_list_conntrack_zero_counters(struct ctnl_handle *cth, int family);
+extern int ctnl_event_conntrack(struct ctnl_handle *cth, int family);
 extern int ctnl_flush_conntrack(struct ctnl_handle *cth);
 
 extern int ctnl_list_expect(struct ctnl_handle *cth, int family);
+extern int ctnl_new_expect(struct ctnl_handle *cth,
+			   struct ip_conntrack_tuple *tuple,
+			   enum ctattr_type_t t,
+			   struct ip_conntrack_tuple *exptuple,
+			   struct ip_conntrack_tuple *mask,
+			   unsigned long timeout);
+extern int ctnl_get_expect(struct ctnl_handle *cth, 
+			   struct ip_conntrack_tuple *tuple,
+			   enum ctattr_type_t t);
 extern int ctnl_del_expect(struct ctnl_handle *cth,
-			   struct ip_conntrack_tuple *t);
+			   struct ip_conntrack_tuple *tuple,
+			   enum ctattr_type_t t);
+extern int ctnl_event_expect(struct ctnl_handle *cth, int family);
+extern int ctnl_flush_expect(struct ctnl_handle *cth);
 
 #if 0
 extern int ctnl_listen(struct ctnl_handle *ctnl,
Index: libnfnetlink/libnfnetlink.c
===================================================================
--- libnfnetlink/libnfnetlink.c	(revision 3889)
+++ libnfnetlink/libnfnetlink.c	(working copy)
@@ -108,10 +108,11 @@
  */
 int nfnl_close(struct nfnl_handle *nfnlh)
 {
-	if (nfnlh->fd)
-		close(nfnlh->fd);
+	int err;
+	
+	err = close(nfnlh->fd);
 
-	return 0;
+	return err;
 }
 
 /**
@@ -202,6 +203,9 @@
 		if (remain < 0) {
 			if (errno == EINTR)
 				continue;
+			/* Bad file descriptor */
+			if (errno == EBADF)
+				break;
 			nfnl_error("recvmsg overrun");
 			continue;
 		}
@@ -231,7 +235,7 @@
 
 			/* end of messages reached, let's return */
 			if (h->nlmsg_type == NLMSG_DONE)
-				return -100;
+				return 0;
 
 			/* Break the loop if success is explicitely
 			 * reported via NLM_F_ACK flag set */

--------------010106090308090800070603--
