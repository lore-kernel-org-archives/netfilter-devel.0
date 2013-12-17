From: Vytas Dauksa <vytas.dauksa@smoothwall.net>
Subject: [PATCH 1/1] add markmask for hash:ip,mark data type
Date: Tue, 17 Dec 2013 14:01:44 +0000
Message-ID: <1387288904-26456-2-git-send-email-vytas.dauksa@smoothwall.net>
References: <alpine.DEB.2.10.1312032006500.32285 () blackhole ! kfki ! hu>
 <1387288904-26456-1-git-send-email-vytas.dauksa@smoothwall.net>
Cc: kadlec@blackhole.kfki.hu,
	Vytas Dauksa <vytas.dauksa@smoothwall.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og109.obsmtp.com ([64.18.2.171]:33277 "HELO
	exprod7og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753251Ab3LQOCJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:02:09 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so6119637wgh.14
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2013 06:02:06 -0800 (PST)
In-Reply-To: <1387288904-26456-1-git-send-email-vytas.dauksa@smoothwall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce packet mark mask for hash:ip,mark data type. This allows to
set mark bit filter for the ip set.

Change-Id: Id8dd9ca7e64477c4f7b022a1d9c1a5b187f1c96e
---
 include/libipset/data.h                            |    2 ++
 include/libipset/linux_ip_set.h                    |    2 ++
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |    2 ++
 kernel/net/netfilter/ipset/ip_set_hash_gen.h       |   31 ++++++++++++++++++++
 kernel/net/netfilter/ipset/ip_set_hash_ipmark.c    |    9 ++++++
 lib/data.c                                         |    7 +++++
 lib/debug.c                                        |    1 +
 lib/errcode.c                                      |    2 ++
 lib/ipset_hash_ipmark.c                            |    9 ++++--
 lib/print.c                                        |    1 +
 lib/session.c                                      |    4 +++
 src/ipset.8                                        |    6 +++-
 tests/hash:ip,mark.t                               |   10 +++++++
 tests/hash:ip,mark.t.list0                         |    2 +-
 tests/hash:ip,mark.t.list1                         |    2 +-
 tests/hash:ip6,mark.t                              |   10 +++++++
 tests/hash:ip6,mark.t.list0                        |    2 +-
 tests/hash:ip6,mark.t.list1                        |    2 +-
 tests/ipmarkhash.t.list0                           |    2 +-
 tests/ipmarkhash.t.list1                           |    2 +-
 20 files changed, 99 insertions(+), 9 deletions(-)

diff --git a/include/libipset/data.h b/include/libipset/data.h
index 618e541..54d914d 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -31,6 +31,7 @@ enum ipset_opt {
 	IPSET_OPT_GC,
 	IPSET_OPT_HASHSIZE,
 	IPSET_OPT_MAXELEM,
+	IPSET_OPT_MARKMASK,
 	IPSET_OPT_NETMASK,
 	IPSET_OPT_PROBES,
 	IPSET_OPT_RESIZE,
@@ -87,6 +88,7 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_GC)	\
 	| IPSET_FLAG(IPSET_OPT_HASHSIZE)\
 	| IPSET_FLAG(IPSET_OPT_MAXELEM)	\
+	| IPSET_FLAG(IPSET_OPT_MARKMASK)\
 	| IPSET_FLAG(IPSET_OPT_NETMASK)	\
 	| IPSET_FLAG(IPSET_OPT_PROBES)	\
 	| IPSET_FLAG(IPSET_OPT_RESIZE)	\
diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index c57f81e..c2bae85 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -90,6 +90,7 @@ enum {
 	IPSET_ATTR_GC,
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
+	IPSET_ATTR_MARKMASK,
 	IPSET_ATTR_NETMASK,
 	IPSET_ATTR_PROBES,
 	IPSET_ATTR_RESIZE,
@@ -139,6 +140,7 @@ enum ipset_errno {
 	IPSET_ERR_EXIST,
 	IPSET_ERR_INVALID_CIDR,
 	IPSET_ERR_INVALID_NETMASK,
+	IPSET_ERR_INVALID_MARKMASK,
 	IPSET_ERR_INVALID_FAMILY,
 	IPSET_ERR_TIMEOUT,
 	IPSET_ERR_REFERENCED,
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index c57f81e..c2bae85 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -90,6 +90,7 @@ enum {
 	IPSET_ATTR_GC,
 	IPSET_ATTR_HASHSIZE,
 	IPSET_ATTR_MAXELEM,
+	IPSET_ATTR_MARKMASK,
 	IPSET_ATTR_NETMASK,
 	IPSET_ATTR_PROBES,
 	IPSET_ATTR_RESIZE,
@@ -139,6 +140,7 @@ enum ipset_errno {
 	IPSET_ERR_EXIST,
 	IPSET_ERR_INVALID_CIDR,
 	IPSET_ERR_INVALID_NETMASK,
+	IPSET_ERR_INVALID_MARKMASK,
 	IPSET_ERR_INVALID_FAMILY,
 	IPSET_ERR_TIMEOUT,
 	IPSET_ERR_REFERENCED,
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index 8f769f8..fa259db 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -263,6 +263,9 @@ struct htype {
 	u32 maxelem;		/* max elements in the hash */
 	u32 elements;		/* current element (vs timeout) */
 	u32 initval;		/* random jhash init value */
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	u32 markmask;		/* markmask value for mark mask to store */
+#endif
 	struct timer_list gc;	/* garbage collection when timeout enabled */
 	struct mtype_elem next; /* temporary storage for uadd */
 #ifdef IP_SET_HASH_WITH_MULTI
@@ -454,6 +457,9 @@ mtype_same_set(const struct ip_set *a, const struct ip_set *b)
 #ifdef IP_SET_HASH_WITH_NETMASK
 	       x->netmask == y->netmask &&
 #endif
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	       x->markmask == y->markmask &&
+#endif
 	       a->extensions == b->extensions;
 }
 
@@ -908,6 +914,10 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 	    nla_put_u8(skb, IPSET_ATTR_NETMASK, h->netmask))
 		goto nla_put_failure;
 #endif
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	if (nla_put_u32(skb, IPSET_ATTR_MARKMASK, h->markmask))
+		goto nla_put_failure;
+#endif
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
 	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
 		goto nla_put_failure;
@@ -1016,6 +1026,9 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 			    struct nlattr *tb[], u32 flags)
 {
 	u32 hashsize = IPSET_DEFAULT_HASHSIZE, maxelem = IPSET_DEFAULT_MAXELEM;
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	u32 markmask;
+#endif
 	u8 hbits;
 #ifdef IP_SET_HASH_WITH_NETMASK
 	u8 netmask;
@@ -1026,6 +1039,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
 	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
+
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	markmask = 0xffffffff;
+#endif
 #ifdef IP_SET_HASH_WITH_NETMASK
 	netmask = set->family == NFPROTO_IPV4 ? 32 : 128;
 	pr_debug("Create set %s with family %s\n",
@@ -1034,6 +1051,9 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 
 	if (unlikely(!ip_set_optattr_netorder(tb, IPSET_ATTR_HASHSIZE) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_MAXELEM) ||
+#ifdef IP_SET_HASH_WITH_MARKMASK
+		     !ip_set_optattr_netorder(tb, IPSET_ATTR_MARKMASK) ||
+#endif
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_TIMEOUT) ||
 		     !ip_set_optattr_netorder(tb, IPSET_ATTR_CADT_FLAGS)))
 		return -IPSET_ERR_PROTOCOL;
@@ -1057,6 +1077,14 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 			return -IPSET_ERR_INVALID_NETMASK;
 	}
 #endif
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	if (tb[IPSET_ATTR_MARKMASK]) {
+		markmask = ntohl(nla_get_u32(tb[IPSET_ATTR_MARKMASK]));
+
+		if ((markmask > 4294967295u) || markmask == 0)
+			return -IPSET_ERR_INVALID_MARKMASK;
+	}
+#endif
 
 	hsize = sizeof(*h);
 #ifdef IP_SET_HASH_WITH_NETS
@@ -1071,6 +1099,9 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 #ifdef IP_SET_HASH_WITH_NETMASK
 	h->netmask = netmask;
 #endif
+#ifdef IP_SET_HASH_WITH_MARKMASK
+	h->markmask = markmask;
+#endif
 	get_random_bytes(&h->initval, sizeof(h->initval));
 	set->timeout = IPSET_NO_TIMEOUT;
 
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c b/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
index e56c0d9..1bf8e85 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
+++ b/kernel/net/netfilter/ipset/ip_set_hash_ipmark.c
@@ -34,6 +34,7 @@ MODULE_ALIAS("ip_set_hash:ip,mark");
 
 /* Type specific function prefix */
 #define HTYPE		hash_ipmark
+#define IP_SET_HASH_WITH_MARKMASK
 
 /* IPv4 variant */
 
@@ -85,11 +86,13 @@ hash_ipmark4_kadt(struct ip_set *set, const struct sk_buff *skb,
 		  const struct xt_action_param *par,
 		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
+	const struct hash_ipmark *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipmark4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
 	e.mark = skb->mark;
+	e.mark &= h->markmask;
 
 	ip4addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip);
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -122,6 +125,7 @@ hash_ipmark4_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	e.mark = ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));
+	e.mark &= h->markmask;
 
 	if (adt == IPSET_TEST ||
 	    !(tb[IPSET_ATTR_IP_TO] || tb[IPSET_ATTR_CIDR])) {
@@ -213,11 +217,13 @@ hash_ipmark6_kadt(struct ip_set *set, const struct sk_buff *skb,
 		  const struct xt_action_param *par,
 		  enum ipset_adt adt, struct ip_set_adt_opt *opt)
 {
+	const struct hash_ipmark *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipmark6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_KEXT(skb, opt, set);
 
 	e.mark = skb->mark;
+	e.mark &= h->markmask;
 
 	ip6addrptr(skb, opt->flags & IPSET_DIM_ONE_SRC, &e.ip.in6);
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
@@ -227,6 +233,7 @@ static int
 hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 		  enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
+	const struct hash_ipmark *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipmark6_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
@@ -250,6 +257,7 @@ hash_ipmark6_uadt(struct ip_set *set, struct nlattr *tb[],
 		return ret;
 
 	e.mark = ntohl(nla_get_u32(tb[IPSET_ATTR_MARK]));
+	e.mark &= h->markmask;
 
 	if (adt == IPSET_TEST) {
 		ret = adtfn(set, &e, &ext, &ext, flags);
@@ -275,6 +283,7 @@ static struct ip_set_type hash_ipmark_type __read_mostly = {
 	.revision_max	= IPSET_TYPE_REV_MAX,
 	.create		= hash_ipmark_create,
 	.create_policy	= {
+		[IPSET_ATTR_MARKMASK]	= { .type = NLA_U32 },
 		[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 		[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
 		[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
diff --git a/lib/data.c b/lib/data.c
index 1f74cd5..48ec98a 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -54,6 +54,7 @@ struct ipset_data {
 			uint8_t netmask;
 			uint32_t hashsize;
 			uint32_t maxelem;
+			uint32_t markmask;
 			uint32_t gc;
 			uint32_t size;
 			/* Filled out by kernel */
@@ -287,6 +288,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_MAXELEM:
 		data->create.maxelem = *(const uint32_t *) value;
 		break;
+	case IPSET_OPT_MARKMASK:
+		data->create.markmask = *(const uint32_t *) value;
+		break;
 	case IPSET_OPT_NETMASK:
 		data->create.netmask = *(const uint8_t *) value;
 		break;
@@ -467,6 +471,8 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 		return &data->create.hashsize;
 	case IPSET_OPT_MAXELEM:
 		return &data->create.maxelem;
+	case IPSET_OPT_MARKMASK:
+		return &data->create.markmask;
 	case IPSET_OPT_NETMASK:
 		return &data->create.netmask;
 	case IPSET_OPT_PROBES:
@@ -561,6 +567,7 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_GC:
 	case IPSET_OPT_HASHSIZE:
 	case IPSET_OPT_MAXELEM:
+	case IPSET_OPT_MARKMASK:
 	case IPSET_OPT_SIZE:
 	case IPSET_OPT_ELEMENTS:
 	case IPSET_OPT_REFERENCES:
diff --git a/lib/debug.c b/lib/debug.c
index 9a3c6b8..1240e22 100644
--- a/lib/debug.c
+++ b/lib/debug.c
@@ -38,6 +38,7 @@ static const struct ipset_attrname createattr2name[] = {
 	[IPSET_ATTR_GC]		= { .name = "GC" },
 	[IPSET_ATTR_HASHSIZE]	= { .name = "HASHSIZE" },
 	[IPSET_ATTR_MAXELEM]	= { .name = "MAXELEM" },
+	[IPSET_ATTR_MARKMASK]	= { .name = "MARKMASK" },
 	[IPSET_ATTR_NETMASK]	= { .name = "NETMASK" },
 	[IPSET_ATTR_PROBES]	= { .name = "PROBES" },
 	[IPSET_ATTR_RESIZE]	= { .name = "RESIZE" },
diff --git a/lib/errcode.c b/lib/errcode.c
index 160d9ad..86eeabd 100644
--- a/lib/errcode.c
+++ b/lib/errcode.c
@@ -38,6 +38,8 @@ static const struct ipset_errcode_table core_errcode_table[] = {
 	  "cannot create more." },
 	{ IPSET_ERR_INVALID_NETMASK, 0,
 	  "The value of the netmask parameter is invalid" },
+	{ IPSET_ERR_INVALID_MARKMASK, 0,
+	  "The value of the markmask parameter is invalid" },
 	{ IPSET_ERR_INVALID_FAMILY, 0,
 	  "Protocol family not supported by the set type" },
 
diff --git a/lib/ipset_hash_ipmark.c b/lib/ipset_hash_ipmark.c
index 6976371..fdea32f 100644
--- a/lib/ipset_hash_ipmark.c
+++ b/lib/ipset_hash_ipmark.c
@@ -26,6 +26,10 @@ static const struct ipset_arg hash_ipmark_create_args0[] = {
 	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
 	  .parse = ipset_parse_family,
 	},
+	{ .name = { "markmask", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MARKMASK,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
 	{ .name = { "hashsize", NULL },
 	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
 	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
@@ -92,7 +96,7 @@ static const struct ipset_arg hash_ipmark_add_args0[] = {
 
 static const char hash_ipmark_usage0[] =
 "create SETNAME hash:ip,mark\n"
-"		[family inet|inet6]\n"
+"		[family inet|inet6] [markmask VALUE]\n"
 "               [hashsize VALUE] [maxelem VALUE]\n"
 "               [timeout VALUE] [counters] [comment]\n"
 "add    SETNAME IP,MARK [timeout VALUE]\n"
@@ -138,7 +142,8 @@ static struct ipset_type ipset_hash_ipmark0 = {
 			| IPSET_FLAG(IPSET_OPT_MARK),
 	},
 	.full = {
-		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_MARKMASK)
+			| IPSET_FLAG(IPSET_OPT_HASHSIZE)
 			| IPSET_FLAG(IPSET_OPT_MAXELEM)
 			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
 			| IPSET_FLAG(IPSET_OPT_COUNTERS)
diff --git a/lib/print.c b/lib/print.c
index 6634802..dfa850b 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -891,6 +891,7 @@ ipset_print_data(char *buf, unsigned int len,
 	case IPSET_OPT_GC:
 	case IPSET_OPT_HASHSIZE:
 	case IPSET_OPT_MAXELEM:
+	case IPSET_OPT_MARKMASK:
 	case IPSET_OPT_NETMASK:
 	case IPSET_OPT_PROBES:
 	case IPSET_OPT_RESIZE:
diff --git a/lib/session.c b/lib/session.c
index cf65960..d2957a5 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -381,6 +381,10 @@ static const struct ipset_attr_policy create_attrs[] = {
 		.type = MNL_TYPE_U32,
 		.opt = IPSET_OPT_MAXELEM,
 	},
+	[IPSET_ATTR_MARKMASK] = {
+		.type = MNL_TYPE_U32,
+		.opt = IPSET_OPT_MARKMASK,
+	},
 	[IPSET_ATTR_NETMASK] = {
 		.type = MNL_TYPE_U8,
 		.opt = IPSET_OPT_NETMASK,
diff --git a/src/ipset.8 b/src/ipset.8
index b401863..2012c78 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -881,7 +881,7 @@ ipset test foo 192.168.1,80.10.0.0/24
 .SS hash:ip,mark
 The \fBhash:ip,mark\fR set type uses a hash to store IP address and packet mark pairs.
 .PP
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBmarkmask\fR \fIvalue\fR ] [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
 .PP
 \fIADD\-ENTRY\fR := \fIipaddr\fR,\fImark\fR
 .PP
@@ -897,6 +897,10 @@ Optional \fBcreate\fR options:
 The protocol family of the IP addresses to be stored in the set. The default is
 \fBinet\fR, i.e IPv4.
 .TP
+\fBmarkmask\fR \fIvalue\fR
+Allows to set bits you are interested in the packet mark. This values is then used to perform bitwise AND operation for every mark added.
+markmask can be any value between 1 and 4294967295, by default all 32 bits are set.
+.TP
 \fBhashsize\fR \fIvalue\fR
 The initial hash size for the set, default is 1024. The hash size must be a power
 of two, the kernel automatically rounds up non power of two hash sizes to the first
diff --git a/tests/hash:ip,mark.t b/tests/hash:ip,mark.t
index bd5c237..ad76274 100644
--- a/tests/hash:ip,mark.t
+++ b/tests/hash:ip,mark.t
@@ -122,4 +122,14 @@
 0 ./check_extensions test 2.0.0.20 700 13 12479
 # Counters and timeout: destroy set
 0 ipset x test
+# Create a set with 65502 ( 0x0000FFDE ) markmask
+0 ipset create test hash:ip,mark markmask 0x0000FFDE
+# Add first value with 86111010 ( 0x0521F322 ) mark
+0 ipset add test 19.16.1.254,0x0521F322
+# Test last entry mark was modified to 62210 ( 0x0000F302 )
+0 ipset test test 19.16.1.254,0x0000F302
+# Test that mask is applied for tests as well
+0 ipset test test 19.16.1.254,0x0521F322
+# Destroy set
+0 ipset x test
 # eof
diff --git a/tests/hash:ip,mark.t.list0 b/tests/hash:ip,mark.t.list0
index 378dabe..d83b206 100644
--- a/tests/hash:ip,mark.t.list0
+++ b/tests/hash:ip,mark.t.list0
@@ -1,6 +1,6 @@
 Name: test
 Type: hash:ip,mark
-Header: family inet hashsize 1024 maxelem 65536 timeout x
+Header: family inet markmask 4294967295 hashsize 1024 maxelem 65536 timeout x
 Size in memory: 8836
 References: 0
 Members:
diff --git a/tests/hash:ip,mark.t.list1 b/tests/hash:ip,mark.t.list1
index af8a38b..400f999 100644
--- a/tests/hash:ip,mark.t.list1
+++ b/tests/hash:ip,mark.t.list1
@@ -1,6 +1,6 @@
 Name: test
 Type: hash:ip,mark
-Header: family inet hashsize 1024 maxelem 65536 timeout 5
+Header: family inet markmask 4294967295 hashsize 1024 maxelem 65536 timeout 5
 Size in memory: 8836
 References: 0
 Members:
diff --git a/tests/hash:ip6,mark.t b/tests/hash:ip6,mark.t
index bc7757b..5c243fa 100644
--- a/tests/hash:ip6,mark.t
+++ b/tests/hash:ip6,mark.t
@@ -224,4 +224,14 @@
 0 ./check_extensions test 2::20 700 13 12479
 # Counters and timeout: destroy set
 0 ipset x test
+# Create a set with 65502 ( 0x0000FFDE ) markmask
+0 ipset create test hash:ip,mark family inet6 markmask 0x0000FFDE
+# Add first value with 86111010 ( 0x0521F322 ) mark
+0 ipset add test 2:1::1,0x0521F322
+# Test last entry mark was modified to 62210 ( 0x0000F302 )
+0 ipset test test 2:1::1,0x0000F302
+# Test that mask is applied for tests as well
+0 ipset test test 2:1::1,0x0521F322
+# Destroy set
+0 ipset x test
 # eof
diff --git a/tests/hash:ip6,mark.t.list0 b/tests/hash:ip6,mark.t.list0
index 3ddc56a..0cd930b 100644
--- a/tests/hash:ip6,mark.t.list0
+++ b/tests/hash:ip6,mark.t.list0
@@ -1,6 +1,6 @@
 Name: test
 Type: hash:ip,mark
-Header: family inet6 hashsize 1024 maxelem 65536 timeout x
+Header: family inet6 markmask 4294967295 hashsize 1024 maxelem 65536 timeout x
 Size in memory: 9316
 References: 0
 Members:
diff --git a/tests/hash:ip6,mark.t.list1 b/tests/hash:ip6,mark.t.list1
index 3759448..44bc1da 100644
--- a/tests/hash:ip6,mark.t.list1
+++ b/tests/hash:ip6,mark.t.list1
@@ -1,6 +1,6 @@
 Name: test
 Type: hash:ip,mark
-Header: family inet6 hashsize 1024 maxelem 65536 timeout 5
+Header: family inet6 markmask 4294967295 hashsize 1024 maxelem 65536 timeout 5
 Size in memory: 9316
 References: 0
 Members:
diff --git a/tests/ipmarkhash.t.list0 b/tests/ipmarkhash.t.list0
index 201a687..4ada53a 100644
--- a/tests/ipmarkhash.t.list0
+++ b/tests/ipmarkhash.t.list0
@@ -1,6 +1,6 @@
 Name: test
 Type: hash:ip,mark
-Header: family inet hashsize 1024 maxelem 65536
+Header: family inet markmask 4294967295 hashsize 1024 maxelem 65536
 Size in memory: 8516
 References: 0
 Members:
diff --git a/tests/ipmarkhash.t.list1 b/tests/ipmarkhash.t.list1
index 2b0265b..74d2869 100644
--- a/tests/ipmarkhash.t.list1
+++ b/tests/ipmarkhash.t.list1
@@ -1,6 +1,6 @@
 Name: test
 Type: hash:ip,mark
-Header: family inet hashsize 1024 maxelem 65536
+Header: family inet markmask 4294967295 hashsize 1024 maxelem 65536
 Size in memory: 8468
 References: 0
 Members:
-- 
1.7.9.5

