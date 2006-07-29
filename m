From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnfnetlink_conntrack encapsulation issues
Date: Sat, 29 Jul 2006 12:51:03 +0200
Message-ID: <44CB3D97.6090908@netfilter.org>
References: <44C89B2E.1080401@ufomechanic.net> <44CA2F93.9000409@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070804040605000309090905"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44CA2F93.9000409@netfilter.org>
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
--------------070804040605000309090905
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Pablo Neira Ayuso wrote:
> I just send the patch attached to Patrick, since I can't commit to SVN 
> anymore since my certificate expired. It provides low-level functions 
> for those that want to work with libnfnetlink (or someday libnl) that is 
> what I'm currently doing with conntrackd.

Uh, I forgot to attach the patch that I sent to Patrick. It implements a 
set of functions to build/parse netlink messages for ctnetlink, so you 
can implement your own functions that do specific things with 
libnfnetlink and them, I think this is way more flexible.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------070804040605000309090905
Content-Type: text/plain;
 name="libnetfilter_conntrack.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="libnetfilter_conntrack.patch"

Index: include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(revisión: 6652)
+++ include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h	(copia de trabajo)
@@ -27,13 +27,15 @@
 	CTA_STATUS,
 	CTA_PROTOINFO,
 	CTA_HELP,
-	CTA_NAT,
+	CTA_NAT_SRC,
+#define CTA_NAT	CTA_NAT_SRC	/* backwards compatibility */
 	CTA_TIMEOUT,
 	CTA_MARK,
 	CTA_COUNTERS_ORIG,
 	CTA_COUNTERS_REPLY,
 	CTA_USE,
 	CTA_ID,
+	CTA_NAT_DST,
 	__CTA_MAX
 };
 #define CTA_MAX (__CTA_MAX - 1)
Index: include/libnetfilter_conntrack/libnetfilter_conntrack.h
===================================================================
--- include/libnetfilter_conntrack/libnetfilter_conntrack.h	(revisión: 6652)
+++ include/libnetfilter_conntrack/libnetfilter_conntrack.h	(copia de trabajo)
@@ -96,7 +96,8 @@
 
 	union nfct_protoinfo protoinfo;
 	struct nfct_counters counters[NFCT_DIR_MAX];
-	struct nfct_nat nat;
+	struct nfct_nat snat;
+	struct nfct_nat dnat;
 };
 
 struct nfct_expect {
@@ -211,6 +212,8 @@
 /*
  * [Allocate|free] a conntrack
  */
+extern struct nfct_conntrack *nfct_conntrack_new(void);
+
 extern struct nfct_conntrack *
 nfct_conntrack_alloc(struct nfct_tuple *orig, struct nfct_tuple *reply,
 		     u_int32_t timeout, union nfct_protoinfo *proto,
@@ -281,6 +284,30 @@
 extern int nfct_event_conntrack(struct nfct_handle *cth); 
 
 /*
+ * NAT facilities 
+ */
+
+enum {
+	NFCT_NAT_SRC,
+	NFCT_NAT_DST,
+	NFCT_NAT_PORT_SRC,
+	NFCT_NAT_PORT_DST
+};
+
+extern int nfct_nat_setup(unsigned int type,
+			  struct nfct_conntrack *ct,
+			  const char *data);
+
+/*
+ * strip NAT handlings
+ */ 
+extern void nfct_conntrack_strip_nat(const struct nfct_conntrack *ct,
+				     struct nfct_conntrack *strip_ct);
+extern int nfct_conntrack_is_snatted(const struct nfct_conntrack *ct);
+extern int nfct_conntrack_is_dnatted(const struct nfct_conntrack *ct);
+extern int nfct_conntrack_is_redirected(const struct nfct_conntrack *ct);
+
+/*
  * Conntrack printing functions
  */
 extern int nfct_sprintf_conntrack(char *buf, struct nfct_conntrack *ct, 
@@ -305,6 +332,17 @@
 extern int nfct_conntrack_compare(struct nfct_conntrack *ct1, 
 				  struct nfct_conntrack *ct2,
 				  struct nfct_conntrack_compare *cmp);
+/*
+ * Tuple comparison
+ */
+extern int nfct_tuple_src_equal(const struct nfct_tuple *t1,
+				const struct nfct_tuple *t2);
+extern int nfct_tuple_dst_equal(const struct nfct_tuple *t1,
+				const struct nfct_tuple *t2);
+extern int nfct_tuple_proto_equal(const struct nfct_tuple *t1,
+				  const struct nfct_tuple *t2);
+extern int nfct_tuple_equal(const struct nfct_tuple *t1,
+			    const struct nfct_tuple *t2);
 
 /* 
  * Expectations
@@ -327,11 +365,38 @@
 extern int nfct_sprintf_expect_id(char *buf, struct nfct_expect *exp);
 
 /*
- * low-level functions for libnetfilter_cthelper
+ * low-level netlink functions 
  */
 extern void nfct_build_tuple(struct nfnlhdr *req, int size, 
 			     struct nfct_tuple *t, int type);
 
+extern void nfct_build_snat(struct nfnlhdr *req, int size,
+			    struct nfct_conntrack *ct);
 
+extern void nfct_build_dnat(struct nfnlhdr *req, int size,
+			    struct nfct_conntrack *ct); 
 
+extern void nfct_build_protoinfo(struct nfnlhdr *req, int size,
+				 struct nfct_conntrack *ct);
+
+extern void nfct_build_status(struct nfnlhdr *req, int size,
+			      struct nfct_conntrack *ct);
+
+extern void nfct_build_timeout(struct nfnlhdr *req, int size,
+			       struct nfct_conntrack *ct);
+
+extern void nfct_build_mark(struct nfnlhdr *req, int size,
+			    struct nfct_conntrack *ct);
+
+extern int nfct_build_netlink_message(const int msg_type,
+				      struct nfnl_subsys_handle *ssh, 
+				      struct nfct_conntrack *ct,
+				      void *buffer,
+				      unsigned int size);
+
+extern int nfct_parse_netlink_message(struct nfct_conntrack *ct,
+				      struct nlmsghdr *nlh,
+				      unsigned int *type,
+				      unsigned int *flags);
+
 #endif	/* _LIBNETFILTER_CONNTRACK_H_ */
Index: configure.in
===================================================================
--- configure.in	(revisión: 6652)
+++ configure.in	(copia de trabajo)
@@ -4,7 +4,7 @@
 
 AC_CANONICAL_SYSTEM
 
-AM_INIT_AUTOMAKE(libnetfilter_conntrack, 0.0.31)
+AM_INIT_AUTOMAKE(libnetfilter_conntrack, 0.0.40)
 
 AC_PROG_CC
 AM_PROG_LIBTOOL
Index: src/libnetfilter_conntrack.c
===================================================================
--- src/libnetfilter_conntrack.c	(revisión: 6652)
+++ src/libnetfilter_conntrack.c	(copia de trabajo)
@@ -222,8 +222,8 @@
 	nfnl_nest_end(&req->nlh, nest);
 }
 
-static void nfct_build_protoinfo(struct nfnlhdr *req, int size,
-				 struct nfct_conntrack *ct)
+void nfct_build_protoinfo(struct nfnlhdr *req, int size,
+			  struct nfct_conntrack *ct)
 {
 	struct nfattr *nest;
 	struct nfct_proto *h;
@@ -237,7 +237,8 @@
 }
 
 static void nfct_build_protonat(struct nfnlhdr *req, int size,
-				struct nfct_conntrack *ct)
+				struct nfct_conntrack *ct,
+				struct nfct_nat *nat)
 {
 	struct nfattr *nest;
 
@@ -262,26 +263,95 @@
 	nfnl_nest_end(&req->nlh, nest);
 }
 
-static void nfct_build_nat(struct nfnlhdr *req, int size,
-			   struct nfct_conntrack *ct)
+static void __nfct_build_nat(struct nfnlhdr *req,
+			     int size,
+			     struct nfct_nat *nat)
 {
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, CTA_NAT);
-
 	nfnl_addattr_l(&req->nlh, size, CTA_NAT_MINIP,
-		       &ct->nat.min_ip, sizeof(u_int32_t));
+		       &nat->min_ip, sizeof(u_int32_t));
 	
-	if (ct->nat.min_ip != ct->nat.max_ip)
+	if (nat->min_ip != nat->max_ip)
 		nfnl_addattr_l(&req->nlh, size, CTA_NAT_MAXIP,
-			       &ct->nat.max_ip, sizeof(u_int32_t));
+			       &nat->max_ip, sizeof(u_int32_t));
+}
 
-	if (ct->nat.l4min.all != ct->nat.l4max.all)
-		nfct_build_protonat(req, size, ct);
+void nfct_build_snat(struct nfnlhdr *req, int size, struct nfct_conntrack *ct)
+{
+	struct nfattr *nest;
 
+	/* no NAT handling, skip */
+	if (ct->snat.min_ip == 0 || ct->snat.l4min.all == 0)
+		return;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+
+	__nfct_build_nat(req, size, &ct->snat);
+
+	if (ct->snat.l4min.all != ct->snat.l4max.all)
+		nfct_build_protonat(req, size, ct, &ct->snat);
+
 	nfnl_nest_end(&req->nlh, nest);
 }
 
+void nfct_build_dnat(struct nfnlhdr *req, int size, struct nfct_conntrack *ct)
+{
+	struct nfattr *nest;
+
+	/* no NAT handling, skip */
+	if (ct->dnat.min_ip == 0 || ct->dnat.l4min.all == 0)
+		return;
+
+	nest = nfnl_nest(&req->nlh, size, CTA_NAT_SRC);
+
+	__nfct_build_nat(req, size, &ct->dnat);
+
+	if (ct->dnat.l4min.all != ct->dnat.l4max.all)
+		nfct_build_protonat(req, size, ct, &ct->dnat);
+
+	nfnl_nest_end(&req->nlh, nest);
+}
+
+void nfct_build_status(struct nfnlhdr *req,
+		       int size,
+		       struct nfct_conntrack *ct)
+{
+	if (ct->status == 0)
+		return;
+
+	nfnl_addattr32(&req->nlh, size, CTA_STATUS,
+		       htonl(ct->status | IPS_CONFIRMED));
+}
+
+void nfct_build_timeout(struct nfnlhdr *req,
+			int size,
+			struct nfct_conntrack *ct)
+{
+	if (ct->timeout == 0)
+		return;
+
+	nfnl_addattr32(&req->nlh, size, CTA_TIMEOUT, htonl(ct->timeout));
+}
+
+void nfct_build_mark(struct nfnlhdr *req,
+		     int size,
+		     struct nfct_conntrack *ct)
+{
+	if (ct->mark == 0)
+		return;
+	
+	nfnl_addattr32(&req->nlh, size, CTA_MARK, htonl(ct->mark));
+}
+
+void nfct_build_id(struct nfnlhdr *req,
+		   int size,
+		   struct nfct_conntrack *ct)
+{
+	if (ct->id == 0)
+		return;
+
+	nfnl_addattr32(&req->nlh, size, CTA_ID, htonl(ct->id));
+}
+
 void nfct_dump_tuple(struct nfct_tuple *tp)
 {
 	struct in_addr src = { .s_addr = tp->src.v4 };
@@ -489,8 +559,10 @@
 
 static char *msgtype[] = {"[UNKNOWN]", "[NEW]", "[UPDATE]", "[DESTROY]"};
 
-static int typemsg2enum(u_int16_t type, u_int16_t flags)
+static int typemsg2enum(struct nlmsghdr *nlh)
 {
+	u_int16_t type = NFNL_MSG_TYPE(nlh->nlmsg_type);
+	u_int16_t flags = nlh->nlmsg_flags;
 	int ret = NFCT_MSG_UNKNOWN;
 
 	if (type == IPCTNL_MSG_CT_NEW) {
@@ -504,13 +576,64 @@
 	return ret;
 }
 
-static int nfct_conntrack_netlink_handler(struct nfct_handle *cth, 
-					  struct nlmsghdr *nlh, void *arg)
+int nfct_conntrack_is_snatted(const struct nfct_conntrack *ct)
 {
-	struct nfct_conntrack ct;
-	unsigned int flags = 0;
+	return (ct->status & IPS_SRC_NAT_DONE) &&
+	       (ct->tuple[NFCT_DIR_REPLY].dst.v4 !=
+		ct->tuple[NFCT_DIR_ORIGINAL].src.v4);
+}
+
+int nfct_conntrack_is_dnatted(const struct nfct_conntrack *ct)
+{
+	return (ct->status & IPS_DST_NAT_DONE) &&
+	       (ct->tuple[NFCT_DIR_REPLY].src.v4 !=
+		ct->tuple[NFCT_DIR_ORIGINAL].dst.v4);
+}
+
+int nfct_conntrack_is_redirected(const struct nfct_conntrack *ct)
+{
+	return (ct->status & IPS_DST_NAT_DONE) &&
+	       (ct->tuple[NFCT_DIR_ORIGINAL].l4dst.tcp.port !=
+	        ct->tuple[NFCT_DIR_REPLY].l4src.tcp.port);
+}
+
+void nfct_conntrack_strip_nat(const struct nfct_conntrack *ct,
+			      struct nfct_conntrack *strip_ct)
+{
+	memcpy(strip_ct, ct, sizeof(struct nfct_conntrack));
+	memset(&strip_ct->snat, 0, sizeof(struct nfct_nat));
+	memset(&strip_ct->dnat, 0, sizeof(struct nfct_nat));
+
+	if (nfct_conntrack_is_snatted(ct)) {
+		strip_ct->snat.min_ip = strip_ct->tuple[NFCT_DIR_REPLY].dst.v4;
+		strip_ct->snat.max_ip = strip_ct->snat.min_ip;
+		strip_ct->tuple[NFCT_DIR_REPLY].dst.v4 =
+			strip_ct->tuple[NFCT_DIR_ORIGINAL].src.v4;
+	} else if (nfct_conntrack_is_dnatted(ct)) {
+		/* This connection has been DNAT'ed */
+		strip_ct->dnat.min_ip = ct->tuple[NFCT_DIR_REPLY].src.v4;
+		strip_ct->dnat.max_ip = strip_ct->dnat.min_ip;
+		strip_ct->tuple[NFCT_DIR_REPLY].src.v4 =
+			ct->tuple[NFCT_DIR_ORIGINAL].dst.v4;
+		strip_ct->tuple[NFCT_DIR_REPLY].dst.v4 =
+			ct->tuple[NFCT_DIR_REPLY].src.v4;
+	} else if (nfct_conntrack_is_redirected(ct)) {
+		/* This connection has been DNAT'ed: Port redirection */
+		strip_ct->dnat.l4min.tcp.port =
+			ct->tuple[NFCT_DIR_REPLY].l4src.tcp.port;
+		strip_ct->dnat.l4max.tcp.port =
+			strip_ct->dnat.l4min.tcp.port;
+		strip_ct->tuple[NFCT_DIR_REPLY].l4src.tcp.port =
+			ct->tuple[NFCT_DIR_ORIGINAL].l4dst.tcp.port;
+	}
+}
+
+int nfct_parse_netlink_message(struct nfct_conntrack *ct,
+			       struct nlmsghdr *nlh,
+			       unsigned int *type,
+			       unsigned int *flags)
+{
 	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
-	int type = NFNL_MSG_TYPE(nlh->nlmsg_type), ret = 0;
 	int len = nlh->nlmsg_len;
 	struct nfattr *cda[CTA_MAX];
 
@@ -518,66 +641,83 @@
 	if (len < 0)
 		return -EINVAL;
 
-	memset(&ct, 0, sizeof(struct nfct_conntrack));
+	*type = typemsg2enum(nlh);
+	*flags = 0;
 
-	ct.tuple[NFCT_DIR_ORIGINAL].l3protonum = nfhdr->nfgen_family;
-	ct.tuple[NFCT_DIR_REPLY].l3protonum = nfhdr->nfgen_family;
+	memset(ct, 0, sizeof(struct nfct_conntrack));
 
+	ct->tuple[NFCT_DIR_ORIGINAL].l3protonum = nfhdr->nfgen_family;
+	ct->tuple[NFCT_DIR_REPLY].l3protonum = nfhdr->nfgen_family;
+
 	nfnl_parse_attr(cda, CTA_MAX, NFA_DATA(nfhdr), len);
 
 	if (cda[CTA_TUPLE_ORIG-1])
 		parse_tuple(cda[CTA_TUPLE_ORIG-1], 
-			    &ct.tuple[NFCT_DIR_ORIGINAL]);
+			    &ct->tuple[NFCT_DIR_ORIGINAL]);
 	
 	if (cda[CTA_TUPLE_REPLY-1])
 		parse_tuple(cda[CTA_TUPLE_REPLY-1], 
-			    &ct.tuple[NFCT_DIR_REPLY]);
+			    &ct->tuple[NFCT_DIR_REPLY]);
 	
 	if (cda[CTA_STATUS-1]) {
-		ct.status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
-		flags |= NFCT_STATUS;
+		ct->status = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_STATUS-1]));
+		*flags |= NFCT_STATUS;
 	}
 
 	if (cda[CTA_PROTOINFO-1]) {
-		parse_protoinfo(cda[CTA_PROTOINFO-1], &ct);
-		flags |= NFCT_PROTOINFO;
+		parse_protoinfo(cda[CTA_PROTOINFO-1], ct);
+		*flags |= NFCT_PROTOINFO;
 	}
 
 	if (cda[CTA_TIMEOUT-1]) {
-		ct.timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
-		flags |= NFCT_TIMEOUT;
+		ct->timeout = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_TIMEOUT-1]));
+		*flags |= NFCT_TIMEOUT;
 	}
 	
 	if (cda[CTA_MARK-1]) {
-		ct.mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
-		flags |= NFCT_MARK;
+		ct->mark = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_MARK-1]));
+		*flags |= NFCT_MARK;
 	}
 	
 	if (cda[CTA_COUNTERS_ORIG-1]) {
-		nfct_parse_counters(cda[CTA_COUNTERS_ORIG-1], &ct, 
+		nfct_parse_counters(cda[CTA_COUNTERS_ORIG-1], ct, 
 				    NFA_TYPE(cda[CTA_COUNTERS_ORIG-1])-1);
-		flags |= NFCT_COUNTERS_ORIG;
+		*flags |= NFCT_COUNTERS_ORIG;
 	}
 
 	if (cda[CTA_COUNTERS_REPLY-1]) {
-		nfct_parse_counters(cda[CTA_COUNTERS_REPLY-1], &ct, 
+		nfct_parse_counters(cda[CTA_COUNTERS_REPLY-1], ct, 
 				    NFA_TYPE(cda[CTA_COUNTERS_REPLY-1])-1);
-		flags |= NFCT_COUNTERS_RPLY;
+		*flags |= NFCT_COUNTERS_RPLY;
 	}
 
 	if (cda[CTA_USE-1]) {
-		ct.use = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_USE-1]));
-		flags |= NFCT_USE;
+		ct->use = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_USE-1]));
+		*flags |= NFCT_USE;
 	}
 
 	if (cda[CTA_ID-1]) {
-		ct.id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
-		flags |= NFCT_ID;
+		ct->id = ntohl(*(u_int32_t *)NFA_DATA(cda[CTA_ID-1]));
+		*flags |= NFCT_ID;
 	}
 
+	return 0;
+}
+
+static int nfct_conntrack_netlink_handler(struct nfct_handle *cth, 
+					  struct nlmsghdr *nlh, void *arg)
+{
+	struct nfct_conntrack ct;
+	unsigned int flags, type;
+	int ret = 0;
+
+	if (nfct_parse_netlink_message(&ct, nlh, &type, &flags) < 0)
+		return -EINVAL;
+
 	if (cth->callback)
-		ret = cth->callback((void *) &ct, flags,
-				    typemsg2enum(type, nlh->nlmsg_flags),
+		ret = cth->callback((void *) &ct,
+				    flags,
+				    type,
 				    cth->callback_data);
 
 	return ret;
@@ -829,7 +969,7 @@
 {
 	struct nfgenmsg *nfhdr = NLMSG_DATA(nlh);
 	struct nfct_expect exp;
-	int type = NFNL_MSG_TYPE(nlh->nlmsg_type), ret = 0;
+	int ret = 0;
 	int len = nlh->nlmsg_len;
 	struct nfattr *cda[CTA_EXPECT_MAX];
 
@@ -859,12 +999,50 @@
 
 	if (cth->callback)
 		ret = cth->callback((void *)&exp, 0, 
-				    typemsg2enum(type, nlh->nlmsg_flags),
+				    typemsg2enum(nlh),
 				    cth->callback_data);
 
 	return 0;
 }
 
+struct nfct_conntrack *nfct_conntrack_new()
+{
+	struct nfct_conntrack *ct;
+
+	ct = malloc(sizeof(struct nfct_conntrack));
+	if (!ct)
+		return NULL;
+	memset(ct, 0, sizeof(struct nfct_conntrack));
+
+	return ct;
+}
+
+int nfct_nat_setup(unsigned int type,
+		   struct nfct_conntrack *ct,
+		   const char *data)
+{
+	int ret = 0;
+
+	switch(type) {
+	case NFCT_NAT_SRC:
+		ret = inet_aton(data, (struct in_addr *) &ct->snat.min_ip);
+		break;
+	case NFCT_NAT_DST:
+		ret = inet_aton(data, (struct in_addr *) &ct->dnat.min_ip);
+		break;
+	case NFCT_NAT_PORT_SRC:
+		ct->snat.l4min.all = htons(atoi(data));
+		break;
+	case NFCT_NAT_PORT_DST:
+		ct->dnat.l4min.all = htons(atoi(data));
+		break;
+	default:
+		/* do nothing */
+		break;
+	}
+	return ret;
+}
+
 struct nfct_conntrack *
 nfct_conntrack_alloc(struct nfct_tuple *orig, struct nfct_tuple *reply,
 		     u_int32_t timeout, union nfct_protoinfo *proto,
@@ -873,10 +1051,9 @@
 {
 	struct nfct_conntrack *ct;
 
-	ct = malloc(sizeof(struct nfct_conntrack));
+	ct = nfct_conntrack_new();
 	if (!ct)
 		return NULL;
-	memset(ct, 0, sizeof(struct nfct_conntrack));
 
 	ct->tuple[NFCT_DIR_ORIGINAL] = *orig;
 	ct->tuple[NFCT_DIR_REPLY] = *reply;
@@ -886,8 +1063,15 @@
 	ct->mark = mark;
 	if (id != NFCT_ANY_ID)
 		ct->id = id;
-	if (range)
-		ct->nat = *range;
+	if (range) {
+		/*
+		 * This is hack <SIGH>, just to keep backward compatibility
+		 */
+		if (status & IPS_SRC_NAT || status & IPS_SRC_NAT_DONE)
+			ct->snat = *range;
+		else if (status & IPS_DST_NAT_DONE || status & IPS_DST_NAT_DONE)
+			ct->dnat = *range;
+	}
 
 	return ct;
 }
@@ -897,6 +1081,40 @@
 	free(ct);
 }
 
+int nfct_tuple_src_equal(const struct nfct_tuple *t1,
+			 const struct nfct_tuple *t2)
+{
+	return (t1->src.v6[0] == t2->src.v6[0] &&
+		t1->src.v6[1] == t2->src.v6[1] &&
+		t1->src.v6[2] == t2->src.v6[2] &&
+		t1->src.v6[3] == t2->src.v6[3]);
+}
+
+int nfct_tuple_dst_equal(const struct nfct_tuple *t1,
+			 const struct nfct_tuple *t2)
+{
+	return (t1->dst.v6[0] == t2->dst.v6[0] &&
+		t1->src.v6[1] == t2->dst.v6[1] &&
+		t1->dst.v6[2] == t2->dst.v6[2] &&
+		t1->dst.v6[3] == t2->dst.v6[3]);
+}
+
+int nfct_tuple_proto_equal(const struct nfct_tuple *t1,
+			   const struct nfct_tuple *t2)
+{
+	return (t1->l3protonum == t2->l3protonum &&
+		t1->protonum == t2->protonum &&
+		t1->l4src.all == t2->l4src.all &&
+		t1->l4dst.all == t2->l4dst.all);
+}
+
+int nfct_tuple_equal(const struct nfct_tuple *t1,
+		     const struct nfct_tuple *t2)
+{
+	return (nfct_tuple_src_equal(t1, t2) && nfct_tuple_dst_equal(t1, t2)
+		&& nfct_tuple_proto_equal(t1, t2));
+}
+
 #define L3PROTONUM(ct) ct->tuple[NFCT_DIR_ORIGINAL].l3protonum
 #define L4PROTONUM(ct) ct->tuple[NFCT_DIR_ORIGINAL].protonum
 
@@ -948,110 +1166,120 @@
 	return 1;
 }
 
-int nfct_create_conntrack(struct nfct_handle *cth, struct nfct_conntrack *ct)
+static void __build_create_conntrack(struct nfnl_subsys_handle *ssh,
+				     struct nfnlhdr *req,
+				     int size,
+				     struct nfct_conntrack *ct)
 {
-	struct nfnlhdr *req;
-	char buf[NFCT_BUFSIZE];
-	u_int32_t status = htonl(ct->status | IPS_CONFIRMED);
-	u_int32_t timeout = htonl(ct->timeout);
-	u_int32_t mark = htonl(ct->mark);
 	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
 
-	req = (void *) buf;
+	memset(req, 0, size);
 
-	memset(buf, 0, sizeof(buf));
-	
-	nfnl_fill_hdr(cth->nfnlssh_ct, &req->nlh, 0, l3num, 0, 
+	nfnl_fill_hdr(ssh, &req->nlh, 0, l3num, 0, 
 		      IPCTNL_MSG_CT_NEW,
 		      NLM_F_REQUEST|NLM_F_CREATE|NLM_F_ACK|NLM_F_EXCL);
 
-	nfct_build_tuple(req, sizeof(buf), &ct->tuple[NFCT_DIR_ORIGINAL], 
+	nfct_build_tuple(req, size, &ct->tuple[NFCT_DIR_ORIGINAL], 
 				 CTA_TUPLE_ORIG);
-	nfct_build_tuple(req, sizeof(buf), &ct->tuple[NFCT_DIR_REPLY],
+	nfct_build_tuple(req, size, &ct->tuple[NFCT_DIR_REPLY],
 				 CTA_TUPLE_REPLY);
 
-	nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_STATUS, &status, 
-		       sizeof(u_int32_t));
+	nfct_build_status(req, size, ct);
+	nfct_build_timeout(req, size, ct);
+	nfct_build_mark(req, size, ct);
+	nfct_build_protoinfo(req, size, ct);
+	nfct_build_snat(req, size, ct);
+	nfct_build_dnat(req, size, ct);
+}
 
-	nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
-		       sizeof(u_int32_t));
-	
-	if (ct->mark != 0)
-		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
-			       sizeof(u_int32_t));
+int nfct_create_conntrack(struct nfct_handle *cth, struct nfct_conntrack *ct)
+{
+	char buf[NFCT_BUFSIZE];
+	struct nfnlhdr *req = (void *) buf;
 
-	nfct_build_protoinfo(req, sizeof(buf), ct);
-	if (ct->nat.min_ip != 0)
-		nfct_build_nat(req, sizeof(buf), ct);
+	__build_create_conntrack(cth->nfnlssh_ct, req, sizeof(buf), ct);
 
 	return nfnl_talk(cth->nfnlh, &req->nlh, 0, 0, NULL, NULL, NULL);
 }
 
-int nfct_update_conntrack(struct nfct_handle *cth, struct nfct_conntrack *ct)
+static void __build_update_conntrack(struct nfnl_subsys_handle *ssh,
+				     struct nfnlhdr *req,
+				     int size,
+				     struct nfct_conntrack *ct)
 {
-	struct nfnlhdr *req;
-	char buf[NFCT_BUFSIZE];
-	u_int32_t status = htonl(ct->status | IPS_CONFIRMED);
-	u_int32_t timeout = htonl(ct->timeout);
-	u_int32_t id = htonl(ct->id);
-	u_int32_t mark = htonl(ct->mark);
 	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
 
-	req = (void *) &buf;
-	memset(&buf, 0, sizeof(buf));
+	memset(req, 0, size);
 
-	nfnl_fill_hdr(cth->nfnlssh_ct, &req->nlh, 0, l3num, 0, 
+	nfnl_fill_hdr(ssh, &req->nlh, 0, l3num, 0, 
 		      IPCTNL_MSG_CT_NEW, NLM_F_REQUEST|NLM_F_ACK);	
 
-	nfct_build_tuple(req, sizeof(buf), &ct->tuple[NFCT_DIR_ORIGINAL], 
-				 CTA_TUPLE_ORIG);
-	nfct_build_tuple(req, sizeof(buf), &ct->tuple[NFCT_DIR_REPLY],
-				 CTA_TUPLE_REPLY);
+	nfct_build_tuple(req, size, &ct->tuple[NFCT_DIR_ORIGINAL], 
+			 CTA_TUPLE_ORIG);
+	nfct_build_tuple(req, size, &ct->tuple[NFCT_DIR_REPLY],
+			 CTA_TUPLE_REPLY);
 
-	if (ct->status != 0)
-		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_STATUS, &status, 
-			       sizeof(u_int32_t));
+	nfct_build_status(req, size, ct);
+	nfct_build_timeout(req, size, ct);
+	nfct_build_mark(req, size, ct);
+	nfct_build_id(req, size, ct);
+	nfct_build_protoinfo(req, size, ct);
+}
 
-	if (ct->timeout != 0)
-		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_TIMEOUT, &timeout, 
-			       sizeof(u_int32_t));
-	
-	if (ct->mark != 0)
-		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_MARK, &mark,
-			       sizeof(u_int32_t));
+int nfct_update_conntrack(struct nfct_handle *cth, struct nfct_conntrack *ct)
+{
+	char buf[NFCT_BUFSIZE];
+	struct nfnlhdr *req = (void *) buf;
 
-	if (ct->id != NFCT_ANY_ID)
-		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ID, &id, 
-			       sizeof(u_int32_t));
+	__build_update_conntrack(cth->nfnlssh_ct, req, sizeof(buf), ct);
 
-	nfct_build_protoinfo(req, sizeof(buf), ct);
-
 	return nfnl_talk(cth->nfnlh, &req->nlh, 0, 0, NULL, NULL, NULL);
 }
 
-int nfct_delete_conntrack(struct nfct_handle *cth, struct nfct_tuple *tuple, 
-			  int dir, u_int32_t id)
+static void __build_delete_conntrack(struct nfnl_subsys_handle *ssh,
+				     struct nfnlhdr *req,
+				     int size,
+				     struct nfct_conntrack *ct)
 {
-	struct nfnlhdr *req;
-	char buf[NFCT_BUFSIZE];
-	int type = dir ? CTA_TUPLE_REPLY : CTA_TUPLE_ORIG;
-	 u_int8_t l3num = tuple->l3protonum;
+	u_int8_t l3num = ct->tuple[NFCT_DIR_ORIGINAL].l3protonum;
+	struct nfct_tuple zero;
 
-	req = (void *) &buf;
-	memset(&buf, 0, sizeof(buf));
+	memset(req, 0, size);
+	memset(&zero, 0, sizeof(struct nfct_tuple));
 
-	nfnl_fill_hdr(cth->nfnlssh_ct, &req->nlh, 0, 
+	nfnl_fill_hdr(ssh, &req->nlh, 0, 
 		      l3num, 0, IPCTNL_MSG_CT_DELETE, 
 		      NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST|NLM_F_ACK);
 
-	nfct_build_tuple(req, sizeof(buf), tuple, type);
-
-	if (id != NFCT_ANY_ID) {
-		id = htonl(id); /* to network byte order */
-		nfnl_addattr_l(&req->nlh, sizeof(buf), CTA_ID, &id, 
-			       sizeof(u_int32_t));
+	if (!nfct_tuple_equal(&zero, &ct->tuple[NFCT_DIR_ORIGINAL])) {
+		nfct_build_tuple(req,
+				 size,
+				 &ct->tuple[NFCT_DIR_ORIGINAL],
+				 CTA_TUPLE_ORIG);
+	} else if (!nfct_tuple_equal(&zero, &ct->tuple[NFCT_DIR_REPLY])) {
+		nfct_build_tuple(req,
+				 size,
+				 &ct->tuple[NFCT_DIR_REPLY],
+				 CTA_TUPLE_REPLY);
 	}
 
+	if (ct->id != NFCT_ANY_ID)
+		nfnl_addattr32(&req->nlh, size, CTA_ID, htonl(ct->id));
+}
+
+int nfct_delete_conntrack(struct nfct_handle *cth, struct nfct_tuple *tuple, 
+			  int dir, u_int32_t id)
+{
+	char buf[NFCT_BUFSIZE];
+	struct nfnlhdr *req = (void *) buf;
+	struct nfct_conntrack ct;
+
+	memset(&ct, 0, sizeof(struct nfct_conntrack));
+	ct.tuple[dir] = *tuple;
+	ct.id = id;
+
+	__build_delete_conntrack(cth->nfnlssh_ct, req, sizeof(buf), &ct);
+
 	return nfnl_talk(cth->nfnlh, &req->nlh, 0, 0, NULL, NULL, NULL);
 }
 
@@ -1123,6 +1351,33 @@
 	return(__nfct_dump_conntrack_table(cth, 1, family));
 }
 
+int nfct_build_netlink_message(const int msg_type,
+			       struct nfnl_subsys_handle *ssh,
+			       struct nfct_conntrack *ct,
+			       void *buffer,
+			       unsigned int size)
+{
+	struct nfnlhdr *req = buffer;
+
+	memset(req, 0, size);
+
+	switch(msg_type) {
+	case NFCT_MSG_NEW:
+		__build_create_conntrack(ssh, req, size, ct);
+		break;
+	case NFCT_MSG_UPDATE:
+		__build_update_conntrack(ssh, req, size, ct);
+		break;
+	case NFCT_MSG_DESTROY:
+		__build_delete_conntrack(ssh, req, size, ct);
+		break;
+	default:
+		return -1;
+	}
+
+	return req->nlh.nlmsg_len;
+}
+
 int nfct_event_conntrack(struct nfct_handle *cth)
 {
 	/*

--------------070804040605000309090905--
