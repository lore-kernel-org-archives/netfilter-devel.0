From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 1/5] ipset: netmask: expand to support cidr and full mask
Date: Tue, 21 Mar 2017 14:39:53 -0400
Message-ID: <1490121597-2140-2-git-send-email-johunt@akamai.com>
References: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([23.79.238.179]:20305 "EHLO
        prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932885AbdCUSkL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:40:11 -0400
In-Reply-To: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Convert netmask to store cidr and netmask.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 include/libipset/data.h         |  5 ++-
 include/libipset/linux_ip_set.h |  5 +++
 include/libipset/print.h        |  3 ++
 lib/data.c                      | 25 +++++++++++++--
 lib/debug.c                     |  1 +
 lib/parse.c                     | 68 ++++++++++++++++++++++++++++++++++++-----
 lib/print.c                     | 39 +++++++++++++++++++++--
 lib/session.c                   |  8 +++++
 8 files changed, 141 insertions(+), 13 deletions(-)

diff --git a/include/libipset/data.h b/include/libipset/data.h
index ca21890..0314cfb 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -37,6 +37,7 @@ enum ipset_opt {
 	IPSET_OPT_RESIZE,
 	IPSET_OPT_SIZE,
 	IPSET_OPT_FORCEADD,
+	IPSET_OPT_NETMASK_MASK,
 	/* Create-specific options, filled out by the kernel */
 	IPSET_OPT_ELEMENTS,
 	IPSET_OPT_REFERENCES,
@@ -66,6 +67,7 @@ enum ipset_opt {
 	IPSET_OPT_SKBMARK,
 	IPSET_OPT_SKBPRIO,
 	IPSET_OPT_SKBQUEUE,
+	IPSET_OPT_NETMASK_FLAG,
 	/* Internal options */
 	IPSET_OPT_FLAGS = 48,	/* IPSET_FLAG_EXIST| */
 	IPSET_OPT_CADT_FLAGS,	/* IPSET_FLAG_BEFORE| */
@@ -101,7 +103,8 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_COUNTERS)\
 	| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT)\
 	| IPSET_FLAG(IPSET_OPT_FORCEADD)\
-	| IPSET_FLAG(IPSET_OPT_SKBINFO))
+	| IPSET_FLAG(IPSET_OPT_SKBINFO)\
+	| IPSET_FLAG(IPSET_OPT_NETMASK_MASK))
 
 #define IPSET_ADT_FLAGS			\
 	(IPSET_FLAG(IPSET_OPT_IP)	\
diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index def91b9..4f93886 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -84,6 +84,7 @@ enum {
 	IPSET_ATTR_CADT_LINENO = IPSET_ATTR_LINENO,	/* 9 */
 	IPSET_ATTR_MARK,	/* 10 */
 	IPSET_ATTR_MARKMASK,	/* 11 */
+	IPSET_ATTR_NETMASK_MASK,/* 12 */
 	/* Reserve empty slots */
 	IPSET_ATTR_CADT_MAX = 16,
 	/* Create-only specific attributes */
@@ -199,6 +200,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_FORCEADD = (1 << IPSET_FLAG_BIT_WITH_FORCEADD),
 	IPSET_FLAG_BIT_WITH_SKBINFO = 6,
 	IPSET_FLAG_WITH_SKBINFO = (1 << IPSET_FLAG_BIT_WITH_SKBINFO),
+	IPSET_FLAG_BIT_WITH_NETMASK = 7,
+	IPSET_FLAG_WITH_NETMASK = (1 << IPSET_FLAG_BIT_WITH_NETMASK),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
@@ -206,6 +209,8 @@ enum ipset_cadt_flags {
 enum ipset_create_flags {
 	IPSET_CREATE_FLAG_BIT_FORCEADD = 0,
 	IPSET_CREATE_FLAG_FORCEADD = (1 << IPSET_CREATE_FLAG_BIT_FORCEADD),
+	IPSET_CREATE_FLAG_BIT_NETMASK = 1,
+	IPSET_CREATE_FLAG_NETMASK = (1 << IPSET_CREATE_FLAG_BIT_NETMASK),
 	IPSET_CREATE_FLAG_BIT_MAX = 7,
 };
 
diff --git a/include/libipset/print.h b/include/libipset/print.h
index 2103ce1..f9e77d3 100644
--- a/include/libipset/print.h
+++ b/include/libipset/print.h
@@ -74,6 +74,9 @@ extern int ipset_print_flag(char *buf, unsigned int len,
 extern int ipset_print_elem(char *buf, unsigned int len,
 			    const struct ipset_data *data,
 			    enum ipset_opt opt, uint8_t env);
+extern int ipset_print_netmask(char *buf, unsigned int len,
+			    const struct ipset_data *data,
+			    enum ipset_opt opt, uint8_t env);
 
 #define ipset_print_portnum	ipset_print_number
 
diff --git a/lib/data.c b/lib/data.c
index 8372a2f..951a124 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -24,6 +24,11 @@
  * We always store the data in host order, *except* IP addresses.
  */
 
+struct ipset_netmask {
+	uint8_t cidr;
+	union nf_inet_addr mask;
+};
+
 struct ipset_data {
 	/* Option bits: which fields are set */
 	uint64_t bits;
@@ -51,7 +56,7 @@ struct ipset_data {
 		struct {
 			uint8_t probes;
 			uint8_t resize;
-			uint8_t netmask;
+			struct ipset_netmask netmask;
 			uint32_t hashsize;
 			uint32_t maxelem;
 			uint32_t markmask;
@@ -295,7 +300,13 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		data->create.markmask = *(const uint32_t *) value;
 		break;
 	case IPSET_OPT_NETMASK:
-		data->create.netmask = *(const uint8_t *) value;
+		data->create.netmask.cidr = *(const uint8_t *) value;
+		break;
+	case IPSET_OPT_NETMASK_MASK:
+		if (!(data->family == NFPROTO_IPV4 ||
+		      data->family == NFPROTO_IPV6))
+			return -1;
+		copy_addr(data->family, &data->create.netmask.mask, value);
 		break;
 	case IPSET_OPT_PROBES:
 		data->create.probes = *(const uint8_t *) value;
@@ -318,6 +329,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_SKBINFO:
 		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_SKBINFO);
 		break;
+	case IPSET_OPT_NETMASK_FLAG:
+		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_NETMASK);
+		break;
 	/* Create-specific options, filled out by the kernel */
 	case IPSET_OPT_ELEMENTS:
 		data->create.elements = *(const uint32_t *) value;
@@ -495,7 +509,9 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 	case IPSET_OPT_MARKMASK:
 		return &data->create.markmask;
 	case IPSET_OPT_NETMASK:
-		return &data->create.netmask;
+		return &data->create.netmask.cidr;
+	case IPSET_OPT_NETMASK_MASK:
+		return &data->create.netmask.mask;
 	case IPSET_OPT_PROBES:
 		return &data->create.probes;
 	case IPSET_OPT_RESIZE:
@@ -558,6 +574,7 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 	case IPSET_OPT_CREATE_COMMENT:
 	case IPSET_OPT_FORCEADD:
 	case IPSET_OPT_SKBINFO:
+	case IPSET_OPT_NETMASK_FLAG:
 		return &data->cadt_flags;
 	default:
 		return NULL;
@@ -581,6 +598,7 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_IP_TO:
 	case IPSET_OPT_IP2:
 	case IPSET_OPT_IP2_TO:
+	case IPSET_OPT_NETMASK_MASK:
 		return family == NFPROTO_IPV4 ? sizeof(uint32_t)
 					 : sizeof(struct in6_addr);
 	case IPSET_OPT_MARK:
@@ -623,6 +641,7 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_NOMATCH:
 	case IPSET_OPT_COUNTERS:
 	case IPSET_OPT_FORCEADD:
+	case IPSET_OPT_NETMASK_FLAG:
 		return sizeof(uint32_t);
 	case IPSET_OPT_ADT_COMMENT:
 		return IPSET_MAX_COMMENT_SIZE + 1;
diff --git a/lib/debug.c b/lib/debug.c
index 6f831ec..a32f709 100644
--- a/lib/debug.c
+++ b/lib/debug.c
@@ -40,6 +40,7 @@ static const struct ipset_attrname createattr2name[] = {
 	[IPSET_ATTR_MAXELEM]	= { .name = "MAXELEM" },
 	[IPSET_ATTR_MARKMASK]	= { .name = "MARKMASK" },
 	[IPSET_ATTR_NETMASK]	= { .name = "NETMASK" },
+	[IPSET_ATTR_NETMASK_MASK] = { .name = "NETMASK_MASK" },
 	[IPSET_ATTR_PROBES]	= { .name = "PROBES" },
 	[IPSET_ATTR_RESIZE]	= { .name = "RESIZE" },
 	[IPSET_ATTR_SIZE]	= { .name = "SIZE" },
diff --git a/lib/parse.c b/lib/parse.c
index 88d2888..5c41c37 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -1654,7 +1654,35 @@ ipset_parse_uint8(struct ipset_session *session,
 }
 
 /**
+ * ipset_cidr_to_mask - convert cidr value to mask stored in nf_inet_addr
+ * @addr: store resulting mask here
+ * @cidr: value to convert to mask
+ * @family: INET family type
+ *
+ * Parse cidr value and convert it into a mask stored in an nf_inet_addr.
+ */
+static void
+ipset_cidr_to_mask(union nf_inet_addr *addr, uint8_t cidr, uint8_t family)
+{
+	uint8_t i;
+	uint8_t addrsize = (family == NFPROTO_IPV4) ? 1 : 4;
+
+        for (i=0; i < addrsize; i++) {
+		if (!cidr) {
+			addr->all[i] = 0;
+		} else if (cidr >= 32) {
+			addr->all[i] = 0xffffffff;
+			cidr -= 32;
+		} else {
+			addr->all[i] = htonl(~((1 << (32 - cidr)) - 1));
+			break;
+		}
+	}
+}
+
+/**
  * ipset_parse_netmask - parse string as a CIDR netmask value
+ *			 or netmask value
  * @session: session structure
  * @opt: option kind of the data
  * @str: string to parse
@@ -1669,12 +1697,13 @@ int
 ipset_parse_netmask(struct ipset_session *session,
 		    enum ipset_opt opt, const char *str)
 {
-	uint8_t family, cidr;
+	uint8_t family, cidr = 0;
 	struct ipset_data *data;
 	int err = 0;
+	union nf_inet_addr netmask = {};
 
 	assert(session);
-	assert(opt == IPSET_OPT_NETMASK);
+	assert(opt == IPSET_OPT_NETMASK_MASK || opt == IPSET_OPT_NETMASK);
 	assert(str);
 
 	data = ipset_session_data(session);
@@ -1684,16 +1713,41 @@ ipset_parse_netmask(struct ipset_session *session,
 		ipset_data_set(data, IPSET_OPT_FAMILY, &family);
 	}
 
+	/* Try to parse input as CIDR first */
 	err = string_to_cidr(session, str, 1,
 			     family == NFPROTO_IPV4 ? 32 : 128,
 			     &cidr);
 
-	if (err)
-		return syntax_err("netmask is out of the inclusive range "
-				  "of 1-%u",
-				  family == NFPROTO_IPV4 ? 32 : 128);
+	if (opt == IPSET_OPT_NETMASK) {
+		if (err)
+			return syntax_err("netmask is out of the inclusive range "
+					  "of 1-%u",
+					  family == NFPROTO_IPV4 ? 32 : 128);
+
+		return ipset_data_set(data, opt, &cidr);
+	} else {
+
+		/* If that fails, attempt to parse as an IP addr */
+		if (err) {
+			/* Store mask value as input by user */
+			err = parse_ipaddr(session, opt, str, family);
+			if (err)
+				return err;
 
-	return ipset_data_set(data, opt, &cidr);
+			/* Check if it's a CIDR and store if it is */
+			netmask = *(const union nf_inet_addr *) ipset_data_get(data, IPSET_OPT_NETMASK_MASK);
+		} else {
+			ipset_cidr_to_mask(&netmask, cidr, family);
+
+			err = ipset_data_set(data, opt, &netmask);
+			if (err)
+				return err;
+		}
+
+		ipset_data_set(data, IPSET_OPT_NETMASK_FLAG, &family);
+
+		return ipset_data_set(data, IPSET_OPT_NETMASK, &cidr);
+	}
 }
 
 /**
diff --git a/lib/print.c b/lib/print.c
index 7dd229e..cc450c6 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -241,6 +241,39 @@ SNPRINTF_IP(32, 4)
 SNPRINTF_IP(128, 6)
 
 /**
+ * ipset_print_netmask - print netmask in either CIDR or address to string
+ * @buf: printing buffer
+ * @len: length of available buffer space
+ * @data: data blob
+ * @opt: the option kind
+ * @env: environment flags
+ *
+ * If the netmask can be represented as a CIDR print that, otherwise print
+ * the mask value.
+ *
+ * Return length of printed string or error size.
+ */
+int
+ipset_print_netmask(char *buf, unsigned int len,
+		    const struct ipset_data *data, enum ipset_opt opt,
+		    uint8_t env)
+{
+	uint8_t cidr;
+
+	assert(buf);
+	assert(len > 0);
+	assert(data);
+	assert(opt == IPSET_OPT_NETMASK_MASK);
+
+	cidr = *(const uint8_t *) ipset_data_get(data, IPSET_OPT_NETMASK);
+
+	if (cidr)
+		return snprintf(buf, len, "%u", cidr);
+	else
+		return ipset_print_ip(buf, len, data, opt, env);
+}
+
+/**
  * ipset_print_ip - print IPv4|IPv6 address to string
  * @buf: printing buffer
  * @len: length of available buffer space
@@ -265,7 +298,7 @@ ipset_print_ip(char *buf, unsigned int len,
 	assert(buf);
 	assert(len > 0);
 	assert(data);
-	assert(opt == IPSET_OPT_IP || opt == IPSET_OPT_IP2);
+	assert(opt == IPSET_OPT_IP || opt == IPSET_OPT_IP2 || opt == IPSET_OPT_NETMASK_MASK);
 
 	D("len: %u", len);
 	family = ipset_data_family(data);
@@ -944,7 +977,6 @@ ipset_print_data(char *buf, unsigned int len,
 	case IPSET_OPT_HASHSIZE:
 	case IPSET_OPT_MAXELEM:
 	case IPSET_OPT_MARKMASK:
-	case IPSET_OPT_NETMASK:
 	case IPSET_OPT_PROBES:
 	case IPSET_OPT_RESIZE:
 	case IPSET_OPT_TIMEOUT:
@@ -953,6 +985,9 @@ ipset_print_data(char *buf, unsigned int len,
 	case IPSET_OPT_SIZE:
 		size = ipset_print_number(buf, len, data, opt, env);
 		break;
+	case IPSET_OPT_NETMASK_MASK:
+		size = ipset_print_netmask(buf, len, data, opt, env);
+		break;
 	default:
 		return -1;
 	}
diff --git a/lib/session.c b/lib/session.c
index 1bdaaa7..55eab83 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -414,6 +414,10 @@ static const struct ipset_attr_policy create_attrs[] = {
 		.type = MNL_TYPE_U32,
 		.opt = IPSET_OPT_MEMSIZE,
 	},
+	[IPSET_ATTR_NETMASK_MASK] = {
+		.type = MNL_TYPE_NESTED,
+		.opt = IPSET_OPT_NETMASK_MASK,
+	},
 };
 
 static const struct ipset_attr_policy adt_attrs[] = {
@@ -1494,6 +1498,10 @@ rawdata2attr(struct ipset_session *session, struct nlmsghdr *nlh,
 	if (attr->type == MNL_TYPE_NESTED) {
 		/* IP addresses */
 		struct nlattr *nested;
+
+		if (type == IPSET_ATTR_NETMASK_MASK)
+			family = ipset_data_family(session->data);
+
 		int atype = family == NFPROTO_IPV4 ? IPSET_ATTR_IPADDR_IPV4
 					      : IPSET_ATTR_IPADDR_IPV6;
 
-- 
1.9.1

