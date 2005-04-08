From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Fri, 08 Apr 2005 12:19:32 +0200
Message-ID: <42565AB4.5000803@eurodev.net>
References: <424747D5.8060500@eurodev.net>	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>	<4254265F.6080607@eurodev.net>	<42554200.3020405@ufomechanic.net>
	<42555F99.8010201@ufomechanic.net>
	<42564BA6.3040702@ufomechanic.net> <42564FAA.2050302@eurodev.net>
	<425658A8.6050200@ufomechanic.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010308060006070005010509"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <425658A8.6050200@ufomechanic.net>
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
--------------010308060006070005010509
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Amin Azez wrote:
> Pablo Neira wrote:
> 
>> Amin Azez wrote:
>>
>>> Anyway, it looks like only the Makefile.ladd and the whole source 
>>> files from the pomg-ng/nfnetlink-ctnetlink-0.13 need importing in 
>>> conjunction with Pablo's new combined patch.
>>
>>
>> You don't have to combine anything. This is a complete misconception, 
>> just apply patches in:
>>
>> http://people.netfilter.org/~pablo/patches/nfnetlink-conntrack-0.50-2.6.11/ 
>>
> 
> 
> Hmm; I did that first but libctnetlink needs linux/nfnetlink_conntrack.h 
> which I can't find anywhere but p-o-m/nfnetlink-ctnetlink-0.13
> 
> I seem to have missed something obvious, is that libctnetlink dependancy 
> out of date?

yes, include files have changed its location.

--
Pablo

--------------010308060006070005010509
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: libctnetlink.c
===================================================================
--- libctnetlink.c	(revision 3742)
+++ libctnetlink.c	(working copy)
@@ -27,14 +27,12 @@
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
-#include <linux/netfilter_ipv4/ip_conntrack_icmp.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
-#include <linux/nfnetlink_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_netlink.h>
 
 #include "libctnetlink.h"
 
-#define ctnl_error(format, args...) \
-	fprintf(stderr, "%s: " format, __FUNCTION__, ## args)
+#define ctnl_error printf
 
 /***********************************************************************
  * low level stuff 
@@ -65,11 +63,17 @@
 	int type = NFNL_MSG_TYPE(n->nlmsg_type);
 	struct ctnl_msg_handler *hdlr = cth->handler[type];
 	int ret;
+	struct nlmsgerr *msgerr;
 
 	/* end of messages reached, let's return */
 	if (n->nlmsg_type == NLMSG_DONE)
 		return -100;
 
+	if (n->nlmsg_type == NLMSG_ERROR) {
+		msgerr = NLMSG_DATA(n);
+		return msgerr->error;
+	}
+
 	if (NFNL_SUBSYS_ID(n->nlmsg_type) != NFNL_SUBSYS_CTNETLINK) {
 		ctnl_error("received message for wrong subsys, skipping\n");
 		nfnl_dump_packet(n, n->nlmsg_len, "list_conntrack_handler");
@@ -81,28 +85,16 @@
 		return 0;
 	}
 
+	if (!hdlr->handler) {
+		ctnl_error("no handler function for type %d\n", type);
+		return 0;
+	}
+
 	ret = hdlr->handler(nladdr, n, arg);
 
 	return ret;
 }
 
-/* handler used for nfnl_listen */
-static int get_conntrack_handler(struct sockaddr_nl *nladdr,
-                                  struct nlmsghdr *n, void *arg)
-{
-	struct nfgenmsg *cm = NLMSG_DATA(n);
-	struct nfattr **cb = (struct nfattr **)arg;
-
-	/* this is what we get when there's no match */
-	if (NFNL_SUBSYS_ID(n->nlmsg_type) != NFNL_SUBSYS_CTNETLINK)
-		return -1;
-        
-	nfnl_parse_attr(cb, CTA_MAX, NFM_NFA(cm), n->nlmsg_len);
-	
-	return -100; /* to get nfnl_listen to break out of the loop */
-}
-
-
 /***********************************************************************
  * high level stuff 
  ***********************************************************************/
@@ -149,7 +141,7 @@
 int ctnl_register_handler(struct ctnl_handle *cth, 
 			  struct ctnl_msg_handler *hndlr)
 {
-	if (hndlr->type >= CTNL_MSG_COUNT)
+	if (hndlr->type >= IPCTNL_MSG_COUNT)
 		return -EINVAL;
 
 	cth->handler[hndlr->type] = hndlr;
@@ -165,7 +157,7 @@
  */
 int ctnl_unregister_handler(struct ctnl_handle *cth, int type)
 {
-	if (type >= CTNL_MSG_COUNT)
+	if (type >= IPCTNL_MSG_COUNT)
 		return -EINVAL;
 
 	cth->handler[type] = NULL;
@@ -180,7 +172,7 @@
  */
 int ctnl_list_conntrack(struct ctnl_handle *cth, int family)
 {
-	if (ctnl_wilddump_request(cth, family, CTNL_MSG_GETCONNTRACK) < 0) {
+	if (ctnl_wilddump_request(cth, family, IPCTNL_MSG_GETCONNTRACK) < 0) {
 		ctnl_error("error during ctnl_wilddump_request\n");
 		return -1;
 	}
@@ -189,42 +181,54 @@
 
 }
 
+/* TODO: Don't user list_conntrack_handler */
+int ctnl_event_conntrack(struct ctnl_handle *cth, int family)
+{
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
+}
+
 /**
  * ctnl_get_conntrack - get a connection from conntrack hashtable
  * cth: libctnetlink handle
  * t: tuple of connection to get
  * cb: a struct nfattr to put the connection in
  */
-int ctnl_get_conntrack(struct ctnl_handle *cth,
-		     struct ip_conntrack_tuple *t,
-		     struct nfattr **cb)
+int ctnl_get_conntrack(struct ctnl_handle *cth, 
+		       struct ip_conntrack_tuple *tuple,
+		       enum ctattr_type_t t)
 {
 	struct {
 		struct nlmsghdr nlh;
 		struct nfgenmsg g;
 	} *req;
 
-	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*t))];
+	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*tuple))
+		 + NFA_LENGTH(sizeof(unsigned long))];
 	memset(&buf, 0, sizeof(buf));
 
 	req = (void *) &buf;
-	
+
+	if (tuple == NULL) {
+		ctnl_error("tuple must be specified\n");
+		return -1;
+	}
+
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
-			0, AF_INET, CTNL_MSG_GETCONNTRACK,
+			0, AF_INET, IPCTNL_MSG_GETCONNTRACK,
 			NLM_F_REQUEST);
 
-	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ORIG, t,
-			sizeof(*t)) < 0) {
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, tuple,
+				sizeof(*tuple)) < 0) {
 		ctnl_error("error during nfnl_addattr_l\n");
 		return -1;
 	}
-	
+
 	if (nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf) < 0 ) {
 		ctnl_error("error while nfnl_send\n");
 		return -1;
 	}
 
-	return nfnl_listen(&cth->nfnlh, &get_conntrack_handler, cb);
+	return nfnl_listen(&cth->nfnlh, &list_conntrack_handler, cth);
 }
 
 /**
@@ -232,24 +236,32 @@
  * cth: libctnetlink handle
  * t: tuple of to-be-deleted connection
  */
-int ctnl_del_conntrack(struct ctnl_handle *cth, struct ip_conntrack_tuple *t)
+int ctnl_del_conntrack(struct ctnl_handle *cth, 
+		       struct ip_conntrack_tuple *tuple,
+		       enum ctattr_type_t t)
 {
 	struct {
 		struct nlmsghdr nlh;
 		struct nfgenmsg nfmsg;
 	} *req;
 
-	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*t))];
+	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*tuple))
+		 + NFA_LENGTH(sizeof(unsigned long))];
 	memset(&buf, 0, sizeof(buf));
 
 	req = (void *) &buf;
 
+	if (tuple == NULL) {
+		ctnl_error("tuple must be specified\n");
+		return -1;
+	}
+	
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
-		      0, AF_INET, CTNL_MSG_DELCONNTRACK,
+		      0, AF_INET, IPCTNL_MSG_DELCONNTRACK,
 		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST);
 
-	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ORIG, t, 
-			   sizeof(*t)) < 0) {
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), t, tuple, 
+			   sizeof(*tuple)) < 0) {
 		ctnl_error("error during nfnl_addattr_l\n");
 		return -1;
 	}
@@ -258,13 +270,75 @@
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
+		       unsigned int status)
+{
+	struct {
+		struct nlmsghdr nlh;
+		struct nfgenmsg nfmsg;
+	} *req;
+
+	char buf[sizeof(*req) + NFA_LENGTH(sizeof(*orig))
+		 + NFA_LENGTH(sizeof(*reply)) 
+		 + NFA_LENGTH(sizeof(unsigned long))
+		 + NFA_LENGTH(sizeof(*proto))
+		 + NFA_LENGTH(sizeof(unsigned int))];
+	memset(&buf, 0, sizeof(buf));
+
+	req = (void *) &buf;
+
+	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
+		      0, AF_INET, IPCTNL_MSG_NEWCONNTRACK,
+		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST|NLM_F_CREATE);
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ORIG, orig, 
+			   sizeof(*orig)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_RPLY, reply, 
+			   sizeof(*reply)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
+			   sizeof(unsigned long)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_PROTOINFO, proto, 
+			   sizeof(*proto)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_STATUS, &status,
+			   sizeof(unsigned int)) < 0) {
+		ctnl_error("error during nfnl_addattr_l\n");
+		return -1;
+	}
+
+	return nfnl_send(&cth->nfnlh, (struct nlmsghdr *)&buf);
+}
+
+/**
  * ctnl_list_expect - retrieve a list of expectations from conntrack subsys
  * cth: libctnetlink handle
  * family: AF_INET, ...
  */
 int ctnl_list_expect(struct ctnl_handle *cth, int family)
 {
-	if (ctnl_wilddump_request(cth, family, CTNL_MSG_GETEXPECT) < 0) {
+	if (ctnl_wilddump_request(cth, family, IPCTNL_MSG_GETEXPECT) < 0) {
 		ctnl_error("error during ctnl_wilddump_request\n");
 		return -1;
 	}
@@ -292,7 +366,7 @@
 	req = (void *) &buf;
 
 	nfnl_fill_hdr(&cth->nfnlh, (struct nlmsghdr *) &buf,
-		      0, AF_INET, CTNL_MSG_DELEXPECT,
+		      0, AF_INET, IPCTNL_MSG_DELEXPECT,
 		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST);
 
 	if (nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ORIG, t, 
Index: libctnetlink.h
===================================================================
--- libctnetlink.h	(revision 3742)
+++ libctnetlink.h	(working copy)
@@ -13,8 +13,8 @@
 #include <netinet/in.h>
 #include <asm/types.h>
 #include <linux/if.h>
-#include <linux/nfnetlink.h>
-#include <linux/nfnetlink_conntrack.h> 
+#include <linux/netfilter/nfnetlink.h>
+#include <linux/netfilter_ipv4/ip_conntrack_netlink.h> 
 #include <linux/netfilter_ipv4/ip_conntrack.h>
 #include "../libnfnetlink/libnfnetlink.h"
 
@@ -27,7 +27,7 @@
 
 struct ctnl_handle {
 	struct nfnl_handle nfnlh;
-	struct ctnl_msg_handler *handler[CTNL_MSG_COUNT];
+	struct ctnl_msg_handler *handler[IPCTNL_MSG_COUNT];
 };
 
 extern int ctnl_open(struct ctnl_handle *cth, unsigned subscriptions);
@@ -37,9 +37,10 @@
 				 struct ctnl_msg_handler *hndlr);
 extern int ctnl_get_conntrack(struct ctnl_handle *cth,
 			      struct ip_conntrack_tuple *tuple,
-			      struct nfattr **cb);
+			      enum ctattr_type_t t);
 extern int ctnl_del_conntrack(struct ctnl_handle *cth,
-			      struct ip_conntrack_tuple *t);
+			      struct ip_conntrack_tuple *tuple,
+			      enum ctattr_type_t t);
 extern int ctnl_list_conntrack(struct ctnl_handle *cth, int family);
 
 extern int ctnl_list_expect(struct ctnl_handle *cth, int family);

--------------010308060006070005010509
Content-Type: text/plain;
 name="y"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y"

Index: libnfnetlink.h
===================================================================
--- libnfnetlink.h	(revision 3742)
+++ libnfnetlink.h	(working copy)
@@ -8,7 +8,7 @@
 
 #include <linux/types.h>
 #include <linux/netlink.h>
-#include <linux/nfnetlink.h>
+#include <linux/netfilter/nfnetlink.h>
 
 #define NFNL_BUFFSIZE		8192
 

--------------010308060006070005010509--
