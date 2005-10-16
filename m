From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH] libnfnetlink updates
Date: Sun, 16 Oct 2005 23:17:34 +0200
Message-ID: <4352C36E.109@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070004090706010000060502"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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
--------------070004090706010000060502
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

This patch includes the following changes:

- define structure nfnlhdr in libnfnetlink.h
- nfnl_parse_attr now zeroes the array of nfattr. memset is always call 
before the parsing so it's better if we include it inside the macro.
- fix a problem with the attributes types. We have to use NFA_TYPE 
instead of reading from nfa->nfa_type now that your patch to see the 
highest bit of nfa_type has been pushed forward.
- Implement __be_to_cpu64. I haven't found any implementation available 
at the moment.

Please apply.

cheers,
Pablo

--------------070004090706010000060502
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/libnfnetlink/libnfnetlink.h
===================================================================
--- include/libnfnetlink/libnfnetlink.h	(revision 4297)
+++ include/libnfnetlink/libnfnetlink.h	(working copy)
@@ -23,6 +23,11 @@
 
 #define NFNL_BUFFSIZE		8192
 
+struct nfnlhdr {
+	struct nlmsghdr nlh;
+	struct nfgenmsg nfmsg;
+};
+
 struct nfnl_callback {
 	int (*call)(struct nlmsghdr *nlh, struct nfattr *nfa[], void *data);
 	void *data;
@@ -110,10 +115,11 @@
 extern int nfnl_nfa_addattr32(struct nfattr *, int, int, u_int32_t);
 extern int nfnl_parse_attr(struct nfattr **, int, struct nfattr *, int);
 #define nfnl_parse_nested(tb, max, nfa) \
-	nfnl_parse_attr((tb), (max), NFA_DATA((nfa)), NFA_PAYLOAD((nfa)))
+({	memset(tb, 0, max *sizeof(struct nfattr *));		\
+	nfnl_parse_attr((tb), (max), NFA_DATA((nfa)), NFA_PAYLOAD((nfa))); })
 #define nfnl_nest(nlh, bufsize, type) 				\
 ({	struct nfattr *__start = NLMSG_TAIL(nlh);		\
-	nfnl_addattr_l(nlh, bufsize, type, NULL, 0); 		\
+	nfnl_addattr_l(nlh, bufsize, (NFNL_NFA_NEST | type), NULL, 0); 	\
 	__start; })
 #define nfnl_nest_end(nlh, tail) 				\
 ({	(tail)->nfa_len = (void *) NLMSG_TAIL(nlh) - (void *) tail; })
@@ -125,4 +131,29 @@
 
 
 extern void nfnl_dump_packet(struct nlmsghdr *, int, char *);
+
+/* Pablo: What is the equivalence of be64_to_cpu in userspace?
+ * 
+ * Harald: Good question.  I don't think there's a standard way [yet?], 
+ * so I'd suggest manually implementing it by "#if little endian" bitshift
+ * operations in C (at least for now).
+ *
+ * All the payload of any nfattr will always be in network byte order.
+ * This would allow easy transport over a real network in the future 
+ * (e.g. jamal's netlink2).
+ *
+ * Pablo: I've called it __be64_to_cpu instead of be64_to_cpu, since maybe 
+ * there will one in the userspace headers someday. We don't want to
+ * pollute POSIX space naming,
+ */
+
+#include <byteswap.h>
+#if __BYTE_ORDER == __BIG_ENDIAN
+#  define __be64_to_cpu(x)	(x)
+# else
+# if __BYTE_ORDER == __LITTLE_ENDIAN
+#  define __be64_to_cpu(x)	__bswap_64(x)
+# endif
+#endif
+
 #endif /* __LIBNFNETLINK_H */
Index: src/libnfnetlink.c
===================================================================
--- src/libnfnetlink.c	(revision 4297)
+++ src/libnfnetlink.c	(working copy)
@@ -7,6 +7,12 @@
  *
  * this software may be used and distributed according to the terms
  * of the gnu general public license, incorporated herein by reference.
+ *
+ * 2005-09-14 Pablo Neira Ayuso <pablo@netfilter.org>: 
+ * 	Define structure nfnlhdr
+ * 	Added __be64_to_cpu function
+ *	Use NFA_TYPE macro to get the attribute type
+ *	Call memset from nfnl_parse_nested
  */
 
 #include <stdlib.h>
@@ -50,7 +56,7 @@
 
 	while (NFA_OK(nfa, len)) {
 		printf("    nfa@%p: nfa_type=%u, nfa_len=%u\n",
-			nfa, nfa->nfa_type, nfa->nfa_len);
+			nfa, NFA_TYPE(nfa), nfa->nfa_len);
 		nfa = NFA_NEXT(nfa,len);
 	}
 }
@@ -584,8 +590,8 @@
 	memset(tb, 0, sizeof(struct nfattr *) * max);
 
 	while (NFA_OK(nfa, len)) {
-		if (nfa->nfa_type <= max)
-			tb[nfa->nfa_type-1] = nfa;
+		if (NFA_TYPE(nfa) <= max)
+			tb[NFA_TYPE(nfa)-1] = nfa;
                 nfa = NFA_NEXT(nfa,len);
 	}
 	if (len)
@@ -732,7 +738,7 @@
 		int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
 
 		while (NFA_OK(attr, attrlen)) {
-			unsigned int flavor = attr->nfa_type;
+			unsigned int flavor = NFA_TYPE(attr);
 			if (flavor) {
 				if (flavor > cb->attr_count)
 					return -EINVAL;

--------------070004090706010000060502--
