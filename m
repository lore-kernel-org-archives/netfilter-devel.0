From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 2/2] updates for lib[ct|nf]netlink
Date: Tue, 28 Jun 2005 03:57:47 +0200
Message-ID: <42C0AE9B.9050309@eurodev.net>
References: <42C03F39.7000806@eurodev.net>
	<20050627195124.GX19928@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050107080605030503070304"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050627195124.GX19928@sunbeam.de.gnumonks.org>
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
--------------050107080605030503070304
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> On Mon, Jun 27, 2005 at 08:02:33PM +0200, Pablo Neira wrote:
> 
>>This patch attached includes the updates to keep in sync the user space 
>>libraries with the kernel part.
> 
> no problem with your patches per se, but
> please make sure your patches apply with the current code ins svn:
> 
> patching file libctnetlink/libctnetlink.c
> Hunk #2 succeeded at 172 (offset -1 lines).

Damn, sorry. It seems that I forgot to update my working copy at some 
point. I've fixed it. Attached a clean patch. I'll apply if you don't 
object.

> btw: I've granted you write permissions to 'libctnetlink'.  Feel free to
> submit (I'm reading the changelog mailinglist).  But please propose
> large modifications / restructuring to the mailinglist before
> implementing the changes.

Sure I will. cool, thanks :)

> Does anyone have experience with versioned symbols in the dynamic
> linker?  We'd better make sure that we do this correctly once the first
> official releases of libnfnetlink and libctnetlink were made public.

I'll investigate this stuff.

--
Pablo

--------------050107080605030503070304
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: libctnetlink.c
===================================================================
--- libctnetlink.c	(revision 4067)
+++ libctnetlink.c	(working copy)
@@ -2,6 +2,7 @@
  *
  * (C) 2001 by Jay Schulist <jschlst@samba.org>
  * (C) 2002 by Harald Welte <laforge@gnumonks.org>
+ * (C) 2005 by Pablo Neira Ayuso <pablo@eurodev.net>
  *
  * Development of this code funded by Astaro AG (http://www.astaro.com)
  *
@@ -171,7 +172,7 @@
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
 			0, AF_INET, IPCTNL_MSG_CONFIG,
-			NLM_F_REQUEST);
+			NLM_F_REQUEST|NLM_F_ACK);
 
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), type, &mask,
 				sizeof(unsigned int)) < 0) {
@@ -183,7 +184,8 @@
 		ctnl_error("error while nfnl_send\n");
 		return -1;
 	}
-	return 0;
+
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
 
 int ctnl_flush_conntrack(struct ctnl_handle *cth)
@@ -200,13 +202,14 @@
 
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
@@ -268,7 +271,7 @@
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
 			0, AF_INET, IPCTNL_MSG_CT_GET,
-			NLM_F_REQUEST);
+			NLM_F_REQUEST|NLM_F_ACK);
 
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, tuple,
 				sizeof(*tuple)) < 0) {
@@ -327,16 +330,14 @@
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
@@ -347,14 +348,15 @@
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
@@ -380,8 +382,20 @@
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
@@ -395,6 +409,31 @@
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
@@ -416,46 +455,89 @@
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
+		+ NFA_LENGTH(sizeof(unsigned long))];
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
+			sizeof(*tuple)) < 0) {
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
 /**
  * ctnl_new_expect - create a new expectation
  *
  * cth: libctnetlink handle
- * t: tuple of to-be-created expectation
+ * master_tuple: tuple of the master original direction
+ * t: direction, original or reply.
+ * exp_tuple: tuple of to-be-created expectation
  * mask: mask of to-be-created expectation
- * master_tuple_orig: tuple of master original direction
- * master_tuple_reply: tuple of master reply direction
  * timeout: timeout of new expectation
  */
 int ctnl_new_expect(struct ctnl_handle *cth,
-		    struct ip_conntrack_tuple *t,
+		    struct ip_conntrack_tuple *master_tuple,
+		    enum ctattr_type_t t,
+		    struct ip_conntrack_tuple *exptuple,
 		    struct ip_conntrack_tuple *mask,
-		    struct ip_conntrack_tuple *master_tuple_orig,
-		    struct ip_conntrack_tuple *master_tuple_reply,
 		    unsigned long timeout)
 {
 	struct {
@@ -463,10 +545,9 @@
 		struct nfgenmsg nfmsg;
 	} *req;
 
-	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*t))
+	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*master_tuple))
 		 + NFA_LENGTH(sizeof(*mask)) 
-		 + NFA_LENGTH(sizeof(*master_tuple_orig)) 
-		 + NFA_LENGTH(sizeof(*master_tuple_reply)) 
+		 + NFA_LENGTH(sizeof(*exptuple)) 
 		 + NFA_LENGTH(sizeof(unsigned long))];
 
 	memset(&buf, 0, sizeof(buf));
@@ -477,22 +558,18 @@
 		      0, AF_INET, IPCTNL_MSG_EXP_NEW,
 		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK);
 
-	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXP_TUPLE, t,
-			   sizeof(*t)) < 0)
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXP_TUPLE, exptuple,
+			   sizeof(*exptuple)) < 0)
 		return -1;
 
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXP_MASK, mask,
 			   sizeof(*mask)) < 0)
 		return -1;
 
-	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ORIG, master_tuple_orig,
-			   sizeof(*master_tuple_orig)) < 0)
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, master_tuple,
+			   sizeof(*master_tuple)) < 0)
 		return -1;
 
-	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_RPLY,
-			   master_tuple_reply, sizeof(*master_tuple_reply)) < 0)
-		return -1;
-
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_EXP_TIMEOUT, &timeout,
 			   sizeof(timeout)) < 0)
 		return -1;
@@ -504,7 +581,30 @@
 
 	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
+ 
+int ctnl_flush_expect(struct ctnl_handle *cth)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct nfgenmsg g;
+	} *req;
 
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
Index: libctnetlink.h
===================================================================
--- libctnetlink.h	(revision 4067)
+++ libctnetlink.h	(working copy)
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
@@ -43,17 +54,24 @@
 			      enum ctattr_type_t t);
 extern int ctnl_list_conntrack(struct ctnl_handle *cth, int family);
 extern int ctnl_list_conntrack_zero_counters(struct ctnl_handle *cth, int family);
+extern int ctnl_event_conntrack(struct ctnl_handle *cth, int family);
 extern int ctnl_flush_conntrack(struct ctnl_handle *cth);
 
 extern int ctnl_list_expect(struct ctnl_handle *cth, int family);
-extern int ctnl_del_expect(struct ctnl_handle *cth,
-			   struct ip_conntrack_tuple *t);
 extern int ctnl_new_expect(struct ctnl_handle *cth,
-			   struct ip_conntrack_tuple *t,
+			   struct ip_conntrack_tuple *master_tuple,
+			   enum ctattr_type_t t,
+			   struct ip_conntrack_tuple *exptuple,
 			   struct ip_conntrack_tuple *mask,
-			   struct ip_conntrack_tuple *master_tuple_orig,
-			   struct ip_conntrack_tuple *master_tuple_reply,
 			   unsigned long timeout);
+extern int ctnl_get_expect(struct ctnl_handle *cth, 
+			   struct ip_conntrack_tuple *tuple,
+			   enum ctattr_type_t t);
+extern int ctnl_del_expect(struct ctnl_handle *cth,
+			   struct ip_conntrack_tuple *tuple,
+			   enum ctattr_type_t t);
+extern int ctnl_event_expect(struct ctnl_handle *cth, int family);
+extern int ctnl_flush_expect(struct ctnl_handle *cth);
 
 #if 0
 extern int ctnl_listen(struct ctnl_handle *ctnl,

--------------050107080605030503070304--
