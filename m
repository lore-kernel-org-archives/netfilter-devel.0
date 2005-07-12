From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH 4/*] libnfnetlink fixes
Date: Tue, 12 Jul 2005 22:37:13 +0200
Message-ID: <42D429F9.7000707@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030006040109050300000609"
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
--------------030006040109050300000609
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This fixes:

a) Check for bad file descriptor, otherwise this can result in a 
infinite loop during event display cancelation.

b) Return 0 on success. -100 is ugly and we this since we use explicit 
ACK confirmation (NLM_F_ACK) since it's cleaner.

c) nfnl_nest and nfnl_nest_end to build up nested attributes.

d) NLMSG_TAIL introduced in recent rtnetlinkv2 changes.

--------------030006040109050300000609
Content-Type: text/x-patch;
 name="04libnfnetlink.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04libnfnetlink.patch"

Index: libnfnetlink.c
===================================================================
--- libnfnetlink.c	(revision 4067)
+++ libnfnetlink.c	(working copy)
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
@@ -400,12 +404,11 @@
 		return -1;
 	}
 
-	nfa = (struct nfattr *)(((char *)n) + NLMSG_ALIGN(n->nlmsg_len));
+	nfa = NLMSG_TAIL(n);
 	nfa->nfa_type = type;
 	nfa->nfa_len = len;
 	memcpy(NFA_DATA(nfa), data, alen);
-	n->nlmsg_len = (NLMSG_ALIGN(n->nlmsg_len) + len);
-
+	n->nlmsg_len = (NLMSG_ALIGN(n->nlmsg_len) + NFA_ALIGN(len));
 	return 0;
 }
 
@@ -482,7 +485,7 @@
 {
 	while (NFA_OK(nfa, len)) {
 		if (nfa->nfa_type <= max)
-			tb[nfa->nfa_type] = nfa;
+			tb[nfa->nfa_type-1] = nfa;
                 nfa = NFA_NEXT(nfa,len);
 	}
 	if (len)
Index: libnfnetlink.h
===================================================================
--- libnfnetlink.h	(revision 4067)
+++ libnfnetlink.h	(working copy)
@@ -10,6 +10,9 @@
 #include <linux/netlink.h>
 #include <linux/netfilter/nfnetlink.h>
 
+#define NLMSG_TAIL(nlh) \
+	((void *) (nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len)
+
 #define NFNL_BUFFSIZE		8192
 
 struct nfnl_handle {
@@ -45,6 +48,12 @@
 extern int nfnl_nfa_addattr_l(struct nfattr *, int, int, void *, int);
 extern int nfnl_nfa_addattr32(struct nfattr *, int, int, u_int32_t);
 extern int nfnl_parse_attr(struct nfattr **, int, struct nfattr *, int);
+#define nfnl_nest(nlh, bufsize, type) 				\
+({	struct nfattr *__start = NLMSG_TAIL(nlh);		\
+	nfnl_addattr_l(nlh, bufsize, type, NULL, 0); 		\
+	__start; })
+#define nfnl_nest_end(nlh, tail) 				\
+({	(tail)->nfa_len = (void *) NLMSG_TAIL(nlh) - (void *) tail; })
 
 extern void nfnl_dump_packet(struct nlmsghdr *, int, char *);
 #endif /* __LIBNFNETLINK_H */

--------------030006040109050300000609--
