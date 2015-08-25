From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH libnetfilter_conntrack] conntrack: add zone attribute to tuple
Date: Tue, 25 Aug 2015 14:22:41 +0200
Message-ID: <95bea4d38688c67a110fcd5ef7acd4032009765b.1440504195.git.daniel@iogearbox.net>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:56899 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbHYMWp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2015 08:22:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the front-end to the recent ctnetlink interface
changes that add the zone attribute into the tuple.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 include/internal/object.h                          |  2 +
 .../libnetfilter_conntrack.h                       |  2 +
 .../linux_nfnetlink_conntrack.h                    |  1 +
 qa/test_api.c                                      |  2 +
 src/conntrack/build.c                              | 46 ++++++++++++++-----
 src/conntrack/build_mnl.c                          | 51 +++++++++++++++++++---
 src/conntrack/compare.c                            | 22 ++++++++++
 src/conntrack/copy.c                               | 14 ++++++
 src/conntrack/getter.c                             | 12 +++++
 src/conntrack/parse.c                              | 12 +++++
 src/conntrack/parse_mnl.c                          | 17 ++++++++
 src/conntrack/setter.c                             | 14 ++++++
 src/conntrack/snprintf_default.c                   | 17 ++++++++
 src/conntrack/snprintf_xml.c                       | 13 ++++--
 14 files changed, 205 insertions(+), 20 deletions(-)

diff --git a/include/internal/object.h b/include/internal/object.h
index 6f5d2e5..ffbcb1f 100644
--- a/include/internal/object.h
+++ b/include/internal/object.h
@@ -107,6 +107,8 @@ struct __nfct_tuple {
 
 	uint8_t			l3protonum;
 	uint8_t			protonum;
+	uint16_t		zone;
+
 	union __nfct_l4_src	l4src;
 	union __nfct_l4_dst	l4dst;
 };
diff --git a/include/libnetfilter_conntrack/libnetfilter_conntrack.h b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
index 3a0a131..22af622 100644
--- a/include/libnetfilter_conntrack/libnetfilter_conntrack.h
+++ b/include/libnetfilter_conntrack/libnetfilter_conntrack.h
@@ -136,6 +136,8 @@ enum nf_conntrack_attr {
 	ATTR_HELPER_INFO,			/* variable length */
 	ATTR_CONNLABELS,			/* variable length */
 	ATTR_CONNLABELS_MASK,			/* variable length */
+	ATTR_ORIG_ZONE,				/* u16 bits */
+	ATTR_REPL_ZONE,				/* u16 bits */
 	ATTR_MAX
 };
 
diff --git a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
index 6a15380..f1f50b7 100644
--- a/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
+++ b/include/libnetfilter_conntrack/linux_nfnetlink_conntrack.h
@@ -65,6 +65,7 @@ enum ctattr_tuple {
 	CTA_TUPLE_UNSPEC,
 	CTA_TUPLE_IP,
 	CTA_TUPLE_PROTO,
+	CTA_TUPLE_ZONE,
 	__CTA_TUPLE_MAX
 };
 #define CTA_TUPLE_MAX (__CTA_TUPLE_MAX - 1)
diff --git a/qa/test_api.c b/qa/test_api.c
index fe1cb78..3742357 100644
--- a/qa/test_api.c
+++ b/qa/test_api.c
@@ -385,6 +385,8 @@ static void test_nfct_cmp_api(struct nf_conntrack *ct1, struct nf_conntrack *ct2
 	printf("== test cmp API ==\n");
 
 	test_nfct_cmp_attr(ATTR_ZONE);
+	test_nfct_cmp_attr(ATTR_ORIG_ZONE);
+	test_nfct_cmp_attr(ATTR_REPL_ZONE);
 	test_nfct_cmp_attr(ATTR_MARK);
 
 	assert(nfct_cmp(ct1, ct2, NFCT_CMP_ALL) == 1);
diff --git a/src/conntrack/build.c b/src/conntrack/build.c
index 0549084..01bdefb 100644
--- a/src/conntrack/build.c
+++ b/src/conntrack/build.c
@@ -86,18 +86,20 @@ static void __build_tuple_proto(struct nfnlhdr *req,
 	nfnl_nest_end(&req->nlh, nest);
 }
 
-void __build_tuple(struct nfnlhdr *req, 
-		   size_t size, 
-		   const struct __nfct_tuple *t, 
-		   const int type)
+static void __build_tuple_raw(struct nfnlhdr *req, size_t size,
+			      const struct __nfct_tuple *t)
 {
-	struct nfattr *nest;
-
-	nest = nfnl_nest(&req->nlh, size, type);
-
 	__build_tuple_ip(req, size, t);
 	__build_tuple_proto(req, size, t);
+}
 
+void __build_tuple(struct nfnlhdr *req, size_t size,
+		   const struct __nfct_tuple *t, const int type)
+{
+	struct nfattr *nest;
+
+	nest = nfnl_nest(&req->nlh, size, type);
+	__build_tuple_raw(req, size, t);
 	nfnl_nest_end(&req->nlh, nest);
 }
 
@@ -448,10 +450,20 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 	    test_bit(ATTR_ORIG_PORT_DST, ct->head.set) ||
 	    test_bit(ATTR_ORIG_L3PROTO, ct->head.set)  ||
 	    test_bit(ATTR_ORIG_L4PROTO, ct->head.set)  ||
+	    test_bit(ATTR_ORIG_ZONE, ct->head.set)     ||
 	    test_bit(ATTR_ICMP_TYPE, ct->head.set) 	  ||
 	    test_bit(ATTR_ICMP_CODE, ct->head.set)	  ||
-	    test_bit(ATTR_ICMP_ID, ct->head.set))
-		__build_tuple(req, size, &ct->head.orig, CTA_TUPLE_ORIG);
+	    test_bit(ATTR_ICMP_ID, ct->head.set)) {
+		const struct __nfct_tuple *t = &ct->head.orig;
+		struct nfattr *nest;
+
+		nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_ORIG);
+		__build_tuple_raw(req, size, t);
+		if (test_bit(ATTR_ORIG_ZONE, ct->head.set))
+			nfnl_addattr16(&req->nlh, size, CTA_TUPLE_ZONE,
+				       htons(t->zone));
+		nfnl_nest_end(&req->nlh, nest);
+	}
 
 	if (test_bit(ATTR_REPL_IPV4_SRC, ct->head.set) ||
 	    test_bit(ATTR_REPL_IPV4_DST, ct->head.set) ||
@@ -460,8 +472,18 @@ int __build_conntrack(struct nfnl_subsys_handle *ssh,
 	    test_bit(ATTR_REPL_PORT_SRC, ct->head.set) ||
 	    test_bit(ATTR_REPL_PORT_DST, ct->head.set) ||
 	    test_bit(ATTR_REPL_L3PROTO, ct->head.set)  ||
-	    test_bit(ATTR_REPL_L4PROTO, ct->head.set))
-		__build_tuple(req, size, &ct->repl, CTA_TUPLE_REPLY);
+	    test_bit(ATTR_REPL_L4PROTO, ct->head.set)  ||
+	    test_bit(ATTR_REPL_ZONE, ct->head.set)) {
+		const struct __nfct_tuple *t = &ct->repl;
+		struct nfattr *nest;
+
+		nest = nfnl_nest(&req->nlh, size, CTA_TUPLE_REPLY);
+		__build_tuple_raw(req, size, t);
+		if (test_bit(ATTR_REPL_ZONE, ct->head.set))
+			nfnl_addattr16(&req->nlh, size, CTA_TUPLE_ZONE,
+				       htons(t->zone));
+		nfnl_nest_end(&req->nlh, nest);
+	}
 
 	if (test_bit(ATTR_MASTER_IPV4_SRC, ct->head.set) ||
 	    test_bit(ATTR_MASTER_IPV4_DST, ct->head.set) ||
diff --git a/src/conntrack/build_mnl.c b/src/conntrack/build_mnl.c
index a37bd73..8ed0690 100644
--- a/src/conntrack/build_mnl.c
+++ b/src/conntrack/build_mnl.c
@@ -81,6 +81,17 @@ nfct_build_tuple_proto(struct nlmsghdr *nlh, const struct __nfct_tuple *t)
 }
 
 int
+nfct_build_tuple_raw(struct nlmsghdr *nlh, const struct __nfct_tuple *t)
+{
+	if (nfct_build_tuple_ip(nlh, t) < 0)
+		return -1;
+	if (nfct_build_tuple_proto(nlh, t) < 0)
+		return -1;
+
+	return 0;
+}
+
+int
 nfct_build_tuple(struct nlmsghdr *nlh, const struct __nfct_tuple *t, int type)
 {
 	struct nlattr *nest;
@@ -89,9 +100,7 @@ nfct_build_tuple(struct nlmsghdr *nlh, const struct __nfct_tuple *t, int type)
 	if (nest == NULL)
 		return -1;
 
-	if (nfct_build_tuple_ip(nlh, t) < 0)
-		goto err;
-	if (nfct_build_tuple_proto(nlh, t) < 0)
+	if (nfct_build_tuple_raw(nlh, t) < 0)
 		goto err;
 
 	mnl_attr_nest_end(nlh, nest);
@@ -410,10 +419,26 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	    test_bit(ATTR_ORIG_PORT_DST, ct->head.set) ||
 	    test_bit(ATTR_ORIG_L3PROTO, ct->head.set) ||
 	    test_bit(ATTR_ORIG_L4PROTO, ct->head.set) ||
+	    test_bit(ATTR_ORIG_ZONE, ct->head.set) ||
 	    test_bit(ATTR_ICMP_TYPE, ct->head.set) ||
 	    test_bit(ATTR_ICMP_CODE, ct->head.set) ||
 	    test_bit(ATTR_ICMP_ID, ct->head.set)) {
-		nfct_build_tuple(nlh, &ct->head.orig, CTA_TUPLE_ORIG);
+		const struct __nfct_tuple *t = &ct->head.orig;
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, CTA_TUPLE_ORIG);
+		if (nest == NULL)
+			return -1;
+
+		if (nfct_build_tuple_raw(nlh, t) < 0) {
+			mnl_attr_nest_cancel(nlh, nest);
+			return -1;
+		}
+
+		if (test_bit(ATTR_ORIG_ZONE, ct->head.set))
+			mnl_attr_put_u16(nlh, CTA_TUPLE_ZONE, htons(t->zone));
+
+		mnl_attr_nest_end(nlh, nest);
 	}
 
 	if (test_bit(ATTR_REPL_IPV4_SRC, ct->head.set) ||
@@ -424,10 +449,26 @@ nfct_nlmsg_build(struct nlmsghdr *nlh, const struct nf_conntrack *ct)
 	    test_bit(ATTR_REPL_PORT_DST, ct->head.set) ||
 	    test_bit(ATTR_REPL_L3PROTO, ct->head.set) ||
 	    test_bit(ATTR_REPL_L4PROTO, ct->head.set) ||
+	    test_bit(ATTR_REPL_ZONE, ct->head.set) ||
 	    test_bit(ATTR_ICMP_TYPE, ct->head.set) ||
 	    test_bit(ATTR_ICMP_CODE, ct->head.set) ||
 	    test_bit(ATTR_ICMP_ID, ct->head.set)) {
-		nfct_build_tuple(nlh, &ct->repl, CTA_TUPLE_REPLY);
+		const struct __nfct_tuple *t = &ct->repl;
+		struct nlattr *nest;
+
+		nest = mnl_attr_nest_start(nlh, CTA_TUPLE_REPLY);
+		if (nest == NULL)
+			return -1;
+
+		if (nfct_build_tuple_raw(nlh, t) < 0) {
+			mnl_attr_nest_cancel(nlh, nest);
+			return -1;
+		}
+
+		if (test_bit(ATTR_REPL_ZONE, ct->head.set))
+			mnl_attr_put_u16(nlh, CTA_TUPLE_ZONE, htons(t->zone));
+
+		mnl_attr_nest_end(nlh, nest);
 	}
 
 	if (test_bit(ATTR_MASTER_IPV4_SRC, ct->head.set) ||
diff --git a/src/conntrack/compare.c b/src/conntrack/compare.c
index e15ba93..8b2f3cb 100644
--- a/src/conntrack/compare.c
+++ b/src/conntrack/compare.c
@@ -149,6 +149,15 @@ cmp_orig_ipv6_dst(const struct nf_conntrack *ct1,
 		sizeof(struct in6_addr)) == 0);
 }
 
+static int
+cmp_orig_zone(const struct nf_conntrack *ct1,
+	      const struct nf_conntrack *ct2,
+	      unsigned int flags)
+{
+	return nfct_get_attr_u16(ct1, ATTR_ORIG_ZONE) ==
+	       nfct_get_attr_u16(ct2, ATTR_ORIG_ZONE);
+}
+
 int __cmp_orig(const struct nf_conntrack *ct1,
 	       const struct nf_conntrack *ct2,
 	       unsigned int flags)
@@ -165,6 +174,8 @@ int __cmp_orig(const struct nf_conntrack *ct1,
 		return 0;
 	if (!__cmp(ATTR_ORIG_IPV6_DST, ct1, ct2, flags, cmp_orig_ipv6_dst, true))
 		return 0;
+	if (!__cmp(ATTR_ORIG_ZONE, ct1, ct2, flags, cmp_orig_zone, false))
+		return 0;
 
 	return 1;
 }
@@ -259,6 +270,15 @@ cmp_repl_ipv6_dst(const struct nf_conntrack *ct1,
 		sizeof(struct in6_addr)) == 0);
 }
 
+static int
+cmp_repl_zone(const struct nf_conntrack *ct1,
+	      const struct nf_conntrack *ct2,
+	      unsigned int flags)
+{
+	return nfct_get_attr_u16(ct1, ATTR_REPL_ZONE) ==
+	       nfct_get_attr_u16(ct2, ATTR_REPL_ZONE);
+}
+
 static int cmp_repl(const struct nf_conntrack *ct1,
 		    const struct nf_conntrack *ct2,
 		    unsigned int flags)
@@ -275,6 +295,8 @@ static int cmp_repl(const struct nf_conntrack *ct1,
 		return 0;
 	if (!__cmp(ATTR_REPL_IPV6_DST, ct1, ct2, flags, cmp_repl_ipv6_dst, true))
 		return 0;
+	if (!__cmp(ATTR_REPL_ZONE, ct1, ct2, flags, cmp_repl_zone, false))
+		return 0;
 
 	return 1;
 }
diff --git a/src/conntrack/copy.c b/src/conntrack/copy.c
index 5915c16..249e7e0 100644
--- a/src/conntrack/copy.c
+++ b/src/conntrack/copy.c
@@ -89,6 +89,18 @@ static void copy_attr_repl_port_dst(struct nf_conntrack *dest,
 	dest->repl.l4dst.all = orig->repl.l4dst.all;
 }
 
+static void copy_attr_orig_zone(struct nf_conntrack *dest,
+				const struct nf_conntrack *orig)
+{
+	dest->head.orig.zone = orig->head.orig.zone;
+}
+
+static void copy_attr_repl_zone(struct nf_conntrack *dest,
+				const struct nf_conntrack *orig)
+{
+	dest->repl.zone = orig->repl.zone;
+}
+
 static void copy_attr_icmp_type(struct nf_conntrack *dest,
 				const struct nf_conntrack *orig)
 {
@@ -535,6 +547,8 @@ const copy_attr copy_attr_array[ATTR_MAX] = {
 	[ATTR_TCP_WSCALE_ORIG]		= copy_attr_tcp_wscale_orig,
 	[ATTR_TCP_WSCALE_REPL]		= copy_attr_tcp_wscale_repl,
 	[ATTR_ZONE]			= copy_attr_zone,
+	[ATTR_ORIG_ZONE]		= copy_attr_orig_zone,
+	[ATTR_REPL_ZONE]		= copy_attr_repl_zone,
 	[ATTR_SECCTX]			= copy_attr_secctx,
 	[ATTR_TIMESTAMP_START]		= copy_attr_timestamp_start,
 	[ATTR_TIMESTAMP_STOP]		= copy_attr_timestamp_stop,
diff --git a/src/conntrack/getter.c b/src/conntrack/getter.c
index ae546ee..ef4ec1d 100644
--- a/src/conntrack/getter.c
+++ b/src/conntrack/getter.c
@@ -69,6 +69,16 @@ static const void *get_attr_repl_port_dst(const struct nf_conntrack *ct)
 	return &ct->repl.l4dst.all;
 }
 
+static const void *get_attr_orig_zone(const struct nf_conntrack *ct)
+{
+	return &ct->head.orig.zone;
+}
+
+static const void *get_attr_repl_zone(const struct nf_conntrack *ct)
+{
+	return &ct->repl.zone;
+}
+
 static const void *get_attr_icmp_type(const struct nf_conntrack *ct)
 {
 	return &ct->head.orig.l4dst.icmp.type;
@@ -412,6 +422,8 @@ const get_attr get_attr_array[ATTR_MAX] = {
 	[ATTR_TCP_WSCALE_ORIG]		= get_attr_tcp_wscale_orig,
 	[ATTR_TCP_WSCALE_REPL]		= get_attr_tcp_wscale_repl,
 	[ATTR_ZONE]			= get_attr_zone,
+	[ATTR_ORIG_ZONE]		= get_attr_orig_zone,
+	[ATTR_REPL_ZONE]		= get_attr_repl_zone,
 	[ATTR_SECCTX]			= get_attr_secctx,
 	[ATTR_TIMESTAMP_START]		= get_attr_timestamp_start,
 	[ATTR_TIMESTAMP_STOP]		= get_attr_timestamp_stop,
diff --git a/src/conntrack/parse.c b/src/conntrack/parse.c
index 3eb8b81..b52454b 100644
--- a/src/conntrack/parse.c
+++ b/src/conntrack/parse.c
@@ -189,6 +189,18 @@ void __parse_tuple(const struct nfattr *attr,
 		__parse_ip(tb[CTA_TUPLE_IP-1], tuple, dir, set);
 	if (tb[CTA_TUPLE_PROTO-1])
 		__parse_proto(tb[CTA_TUPLE_PROTO-1], tuple, dir, set);
+
+	if (tb[CTA_TUPLE_ZONE-1]) {
+		tuple->zone = ntohs(*(uint16_t *)NFA_DATA(tb[CTA_TUPLE_ZONE-1]));
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_ZONE, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_ZONE, set);
+			break;
+		}
+	}
 }
 
 static void __parse_protoinfo_tcp(const struct nfattr *attr, 
diff --git a/src/conntrack/parse_mnl.c b/src/conntrack/parse_mnl.c
index 2582cd7..56a575e 100644
--- a/src/conntrack/parse_mnl.c
+++ b/src/conntrack/parse_mnl.c
@@ -254,7 +254,12 @@ static int nfct_parse_tuple_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			return MNL_CB_ERROR;
 		break;
+	case CTA_TUPLE_ZONE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U16) < 0)
+			return MNL_CB_ERROR;
+		break;
 	}
+
 	tb[type] = attr;
 	return MNL_CB_OK;
 }
@@ -278,6 +283,18 @@ nfct_parse_tuple(const struct nlattr *attr, struct __nfct_tuple *tuple,
 			return -1;
 	}
 
+	if (tb[CTA_TUPLE_ZONE]) {
+		tuple->zone = ntohs(mnl_attr_get_u16(tb[CTA_TUPLE_ZONE]));
+		switch(dir) {
+		case __DIR_ORIG:
+			set_bit(ATTR_ORIG_ZONE, set);
+			break;
+		case __DIR_REPL:
+			set_bit(ATTR_REPL_ZONE, set);
+			break;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/src/conntrack/setter.c b/src/conntrack/setter.c
index c648a10..eba2fb6 100644
--- a/src/conntrack/setter.c
+++ b/src/conntrack/setter.c
@@ -110,6 +110,18 @@ set_attr_repl_port_dst(struct nf_conntrack *ct, const void *value, size_t len)
 }
 
 static void
+set_attr_orig_zone(struct nf_conntrack *ct, const void *value, size_t len)
+{
+	ct->head.orig.zone = *((uint16_t *) value);
+}
+
+static void
+set_attr_repl_zone(struct nf_conntrack *ct, const void *value, size_t len)
+{
+	ct->repl.zone = *((uint16_t *) value);
+}
+
+static void
 set_attr_icmp_type(struct nf_conntrack *ct, const void *value, size_t len)
 {
 	uint8_t rtype;
@@ -507,6 +519,8 @@ const set_attr set_attr_array[ATTR_MAX] = {
 	[ATTR_TCP_WSCALE_ORIG]	= set_attr_tcp_wscale_orig,
 	[ATTR_TCP_WSCALE_REPL]	= set_attr_tcp_wscale_repl,
 	[ATTR_ZONE]		= set_attr_zone,
+	[ATTR_ORIG_ZONE]	= set_attr_orig_zone,
+	[ATTR_REPL_ZONE]	= set_attr_repl_zone,
 	[ATTR_SECCTX]		= set_attr_do_nothing,
 	[ATTR_TIMESTAMP_START]	= set_attr_do_nothing,
 	[ATTR_TIMESTAMP_STOP]	= set_attr_do_nothing,
diff --git a/src/conntrack/snprintf_default.c b/src/conntrack/snprintf_default.c
index 24e2f28..06466b1 100644
--- a/src/conntrack/snprintf_default.c
+++ b/src/conntrack/snprintf_default.c
@@ -171,6 +171,13 @@ int __snprintf_proto(char *buf,
 	return size;
 }
 
+static int
+__snprintf_tuple_zone(char *buf, unsigned int len, const char *pfx,
+		      const struct __nfct_tuple *tuple)
+{
+	return (snprintf(buf, len, "zone-%s=%u ", pfx, tuple->zone));
+}
+
 static int __snprintf_status_assured(char *buf,
 				     unsigned int len,
 				     const struct nf_conntrack *ct)
@@ -396,6 +403,11 @@ int __snprintf_conntrack_default(char *buf,
 	ret = __snprintf_proto(buf+offset, len, &ct->head.orig);
 	BUFFER_SIZE(ret, size, len, offset);
 
+	if (test_bit(ATTR_ORIG_ZONE, ct->head.set)) {
+		ret = __snprintf_tuple_zone(buf+offset, len, "orig", &ct->head.orig);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_ORIG_COUNTER_PACKETS, ct->head.set) &&
 	    test_bit(ATTR_ORIG_COUNTER_BYTES, ct->head.set)) {
 		ret = __snprintf_counters(buf+offset, len, ct, __DIR_ORIG);
@@ -414,6 +426,11 @@ int __snprintf_conntrack_default(char *buf,
 	ret = __snprintf_proto(buf+offset, len, &ct->repl);
 	BUFFER_SIZE(ret, size, len, offset);
 
+	if (test_bit(ATTR_REPL_ZONE, ct->head.set)) {
+		ret = __snprintf_tuple_zone(buf+offset, len, "reply", &ct->repl);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_REPL_COUNTER_PACKETS, ct->head.set) &&
 	    test_bit(ATTR_REPL_COUNTER_BYTES, ct->head.set)) {
 		ret = __snprintf_counters(buf+offset, len, ct, __DIR_REPL);
diff --git a/src/conntrack/snprintf_xml.c b/src/conntrack/snprintf_xml.c
index bf52362..c3a836a 100644
--- a/src/conntrack/snprintf_xml.c
+++ b/src/conntrack/snprintf_xml.c
@@ -284,7 +284,7 @@ __snprintf_localtime_xml(char *buf, unsigned int len, const struct tm *tm)
 static int __snprintf_tuple_xml(char *buf,
 				unsigned int len,
 				const struct nf_conntrack *ct,
-				unsigned int dir)
+				unsigned int dir, bool zone_incl)
 {
 	int ret;
 	unsigned int size = 0, offset = 0;
@@ -330,6 +330,11 @@ static int __snprintf_tuple_xml(char *buf,
 	ret = snprintf(buf+offset, len, "</layer4>");
 	BUFFER_SIZE(ret, size, len, offset);
 
+	if (zone_incl) {
+		ret = snprintf(buf+offset, len, "<zone>%u</zone>", tuple->zone);
+		BUFFER_SIZE(ret, size, len, offset);
+	}
+
 	if (test_bit(ATTR_ORIG_COUNTER_PACKETS, ct->head.set) &&
 	    test_bit(ATTR_ORIG_COUNTER_BYTES, ct->head.set)) {
 		ret = snprintf(buf+offset, len, "<counters>");
@@ -398,10 +403,12 @@ int __snprintf_conntrack_xml(char *buf,
 
 	BUFFER_SIZE(ret, size, len, offset);
 
-	ret = __snprintf_tuple_xml(buf+offset, len, ct, __DIR_ORIG);
+	ret = __snprintf_tuple_xml(buf+offset, len, ct, __DIR_ORIG,
+				   test_bit(ATTR_ORIG_ZONE, ct->head.set));
 	BUFFER_SIZE(ret, size, len, offset);
 
-	ret = __snprintf_tuple_xml(buf+offset, len, ct, __DIR_REPL);
+	ret = __snprintf_tuple_xml(buf+offset, len, ct, __DIR_REPL,
+				   test_bit(ATTR_REPL_ZONE, ct->head.set));
 	BUFFER_SIZE(ret, size, len, offset);
 
 	if (test_bit(ATTR_TCP_STATE, ct->head.set) ||
-- 
1.9.3

