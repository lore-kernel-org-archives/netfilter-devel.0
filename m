From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 5/6] ipset: Support comments in the userspace library.
Date: Mon,  2 Sep 2013 08:35:56 +0200
Message-ID: <1378103757-14426-6-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:56618 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab3IBGi3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 02:38:29 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 99CA8A2D0F
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 07:38:28 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 3vypfw7RN4Yo for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 07:38:07 +0100 (BST)
In-Reply-To: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This adds support to the userspace portion of ipset for handling ipsets
with the comment extension enabled. The library revision has been raised
accordingly.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 Make_global.am                  |  2 +-
 include/libipset/data.h         |  6 +++++-
 include/libipset/linux_ip_set.h |  9 +++++++++
 include/libipset/parse.h        |  2 ++
 include/libipset/print.h        |  3 +++
 lib/data.c                      | 34 ++++++++++++++++++++++++++++++++++
 lib/debug.c                     |  1 +
 lib/errcode.c                   |  2 ++
 lib/libipset.map                |  6 ++++++
 lib/parse.c                     | 27 +++++++++++++++++++++++++++
 lib/print.c                     | 31 +++++++++++++++++++++++++++++++
 lib/session.c                   |  8 +++++++-
 lib/types.c                     |  4 ++--
 13 files changed, 130 insertions(+), 5 deletions(-)

diff --git a/Make_global.am b/Make_global.am
index 29b5678..9c228cc 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -69,7 +69,7 @@
 # interface. 
 
 #            curr:rev:age
-LIBVERSION = 4:0:1
+LIBVERSION = 4:1:2
 
 AM_CPPFLAGS = $(kinclude_CFLAGS) $(all_includes) -I$(top_srcdir)/include \
 	-I/usr/local/include
diff --git a/include/libipset/data.h b/include/libipset/data.h
index 2b6b8cd..ae0d099 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -57,6 +57,8 @@ enum ipset_opt {
 	IPSET_OPT_COUNTERS,
 	IPSET_OPT_PACKETS,
 	IPSET_OPT_BYTES,
+	IPSET_OPT_COMMENTS,
+	IPSET_OPT_COMMENT,
 	/* Internal options */
 	IPSET_OPT_FLAGS = 48,	/* IPSET_FLAG_EXIST| */
 	IPSET_OPT_CADT_FLAGS,	/* IPSET_FLAG_BEFORE| */
@@ -106,11 +108,13 @@ enum ipset_opt {
 	| IPSET_FLAG(IPSET_OPT_CADT_FLAGS)\
 	| IPSET_FLAG(IPSET_OPT_BEFORE) \
 	| IPSET_FLAG(IPSET_OPT_PHYSDEV) \
-	| IPSET_FLAG(IPSET_OPT_NOMATCH))
+	| IPSET_FLAG(IPSET_OPT_NOMATCH) \
+	| IPSET_FLAG(IPSET_OPT_COMMENT))
 
 struct ipset_data;
 
 extern void ipset_strlcpy(char *dst, const char *src, size_t len);
+extern void ipset_strlcat(char *dst, const char *src, size_t len);
 extern bool ipset_data_flags_test(const struct ipset_data *data,
 				  uint64_t flags);
 extern void ipset_data_flags_set(struct ipset_data *data, uint64_t flags);
diff --git a/include/libipset/linux_ip_set.h b/include/libipset/linux_ip_set.h
index 8024cdf..8163d6d 100644
--- a/include/libipset/linux_ip_set.h
+++ b/include/libipset/linux_ip_set.h
@@ -19,6 +19,9 @@
 /* The max length of strings including NUL: set and type identifiers */
 #define IPSET_MAXNAMELEN	32
 
+/* The maximum permissible length we will accept over netlink (inc. comments) */
+#define IPSET_MAXSTRLEN		255
+
 /* Message types and commands */
 enum ipset_cmd {
 	IPSET_CMD_NONE,
@@ -110,6 +113,7 @@ enum {
 	IPSET_ATTR_IFACE,
 	IPSET_ATTR_BYTES,
 	IPSET_ATTR_PACKETS,
+	IPSET_ATTR_COMMENT,
 	__IPSET_ATTR_ADT_MAX,
 };
 #define IPSET_ATTR_ADT_MAX	(__IPSET_ATTR_ADT_MAX - 1)
@@ -140,6 +144,7 @@ enum ipset_errno {
 	IPSET_ERR_IPADDR_IPV4,
 	IPSET_ERR_IPADDR_IPV6,
 	IPSET_ERR_COUNTER,
+	IPSET_ERR_COMMENT,
 
 	/* Type specific error codes */
 	IPSET_ERR_TYPE_SPECIFIC = 4352,
@@ -174,8 +179,12 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_PHYSDEV	= (1 << IPSET_FLAG_BIT_PHYSDEV),
 	IPSET_FLAG_BIT_NOMATCH	= 2,
 	IPSET_FLAG_NOMATCH	= (1 << IPSET_FLAG_BIT_NOMATCH),
+	IPSET_FLAG_EXT_BEGIN	= 2,
+	IPSET_FLAG_WITH_TIMEOUTS = (1 << IPSET_FLAG_EXT_BEGIN),
 	IPSET_FLAG_BIT_WITH_COUNTERS = 3,
 	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
+	IPSET_FLAG_BIT_WITH_COMMENTS = 4,
+	IPSET_FLAG_WITH_COMMENTS = (1 << IPSET_FLAG_BIT_WITH_COMMENTS),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
diff --git a/include/libipset/parse.h b/include/libipset/parse.h
index 014c62f..5c46a88 100644
--- a/include/libipset/parse.h
+++ b/include/libipset/parse.h
@@ -90,6 +90,8 @@ extern int ipset_parse_typename(struct ipset_session *session,
 				enum ipset_opt opt, const char *str);
 extern int ipset_parse_iface(struct ipset_session *session,
 			     enum ipset_opt opt, const char *str);
+extern int ipset_parse_comment(struct ipset_session *session,
+			     enum ipset_opt opt, const char *str);
 extern int ipset_parse_output(struct ipset_session *session,
 			      int opt, const char *str);
 extern int ipset_parse_ignored(struct ipset_session *session,
diff --git a/include/libipset/print.h b/include/libipset/print.h
index 1d537bd..f2a6095 100644
--- a/include/libipset/print.h
+++ b/include/libipset/print.h
@@ -40,6 +40,9 @@ extern int ipset_print_port(char *buf, unsigned int len,
 extern int ipset_print_iface(char *buf, unsigned int len,
 			     const struct ipset_data *data,
 			     enum ipset_opt opt, uint8_t env);
+extern int ipset_print_comment(char *buf, unsigned int len,
+			     const struct ipset_data *data,
+			     enum ipset_opt opt, uint8_t env);
 extern int ipset_print_proto(char *buf, unsigned int len,
 			     const struct ipset_data *data,
 			     enum ipset_opt opt, uint8_t env);
diff --git a/lib/data.c b/lib/data.c
index 04a5997..9aaa550 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -75,6 +75,7 @@ struct ipset_data {
 			char iface[IFNAMSIZ];
 			uint64_t packets;
 			uint64_t bytes;
+			char comment[IPSET_MAXSTRLEN];
 		} adt;
 	};
 };
@@ -108,6 +109,25 @@ ipset_strlcpy(char *dst, const char *src, size_t len)
 }
 
 /**
+ * ipset_strlcat - concatenate the string from src to the end of dst
+ * @dst: the target string buffer
+ * @src: the source string buffer
+ * @len: the length of bytes to concat, including the terminating null byte.
+ *
+ * Cooncatenate the string in src to destination, but at most len bytes are
+ * copied. The target is unconditionally terminated by the null byte.
+ */
+void
+ipset_strlcat(char *dst, const char *src, size_t len)
+{
+	assert(dst);
+	assert(src);
+
+	strncat(dst, src, len);
+	dst[len - 1] = '\0';
+}
+
+/**
  * ipset_data_flags_test - test option bits in the data blob
  * @data: data blob
  * @flags: the option flags to test
@@ -278,6 +298,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_COUNTERS:
 		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_COUNTERS);
 		break;
+	case IPSET_OPT_COMMENTS:
+		cadt_flag_type_attr(data, opt, IPSET_FLAG_WITH_COMMENTS);
+		break;
 	/* Create-specific options, filled out by the kernel */
 	case IPSET_OPT_ELEMENTS:
 		data->create.elements = *(const uint32_t *) value;
@@ -336,6 +359,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	case IPSET_OPT_BYTES:
 		data->adt.bytes = *(const uint64_t *) value;
 		break;
+	case IPSET_OPT_COMMENT:
+		ipset_strlcpy(data->adt.comment, value, IPSET_MAXSTRLEN);
+		break;
 	/* Swap/rename */
 	case IPSET_OPT_SETNAME2:
 		ipset_strlcpy(data->setname2, value, IPSET_MAXNAMELEN);
@@ -370,6 +396,9 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		if (data->cadt_flags & IPSET_FLAG_WITH_COUNTERS)
 			ipset_data_flags_set(data,
 					     IPSET_FLAG(IPSET_OPT_COUNTERS));
+		if (data->cadt_flags & IPSET_FLAG_WITH_COMMENTS)
+			ipset_data_flags_set(data,
+					     IPSET_FLAG(IPSET_OPT_COMMENTS));
 		break;
 	default:
 		return -1;
@@ -472,6 +501,8 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 		return &data->adt.packets;
 	case IPSET_OPT_BYTES:
 		return &data->adt.bytes;
+	case IPSET_OPT_COMMENT:
+		return &data->adt.comment;
 	/* Swap/rename */
 	case IPSET_OPT_SETNAME2:
 		return data->setname2;
@@ -484,6 +515,7 @@ ipset_data_get(const struct ipset_data *data, enum ipset_opt opt)
 	case IPSET_OPT_PHYSDEV:
 	case IPSET_OPT_NOMATCH:
 	case IPSET_OPT_COUNTERS:
+	case IPSET_OPT_COMMENTS:
 		return &data->cadt_flags;
 	default:
 		return NULL;
@@ -543,6 +575,8 @@ ipset_data_sizeof(enum ipset_opt opt, uint8_t family)
 	case IPSET_OPT_NOMATCH:
 	case IPSET_OPT_COUNTERS:
 		return sizeof(uint32_t);
+	case IPSET_OPT_COMMENT:
+		return IPSET_MAXSTRLEN;
 	default:
 		return 0;
 	};
diff --git a/lib/debug.c b/lib/debug.c
index 3aa5a99..a204940 100644
--- a/lib/debug.c
+++ b/lib/debug.c
@@ -64,6 +64,7 @@ static const struct ipset_attrname adtattr2name[] = {
 	[IPSET_ATTR_CIDR2]	= { .name = "CIDR2" },
 	[IPSET_ATTR_IP2_TO]	= { .name = "IP2_TO" },
 	[IPSET_ATTR_IFACE]	= { .name = "IFACE" },
+	[IPSET_ATTR_COMMENT]	= { .name = "COMMENT" },
 };
 
 static void
diff --git a/lib/errcode.c b/lib/errcode.c
index c939949..c824cc3 100644
--- a/lib/errcode.c
+++ b/lib/errcode.c
@@ -72,6 +72,8 @@ static const struct ipset_errcode_table core_errcode_table[] = {
 	  "An IPv6 address is expected, but not received" },
 	{ IPSET_ERR_COUNTER, 0,
 	  "Packet/byte counters cannot be used: set was created without counter support" },
+	{ IPSET_ERR_COMMENT, 0,
+	  "Comment too long!" },
 
 	/* ADD specific error codes */
 	{ IPSET_ERR_EXIST, IPSET_CMD_ADD,
diff --git a/lib/libipset.map b/lib/libipset.map
index 271fe59..06216e7 100644
--- a/lib/libipset.map
+++ b/lib/libipset.map
@@ -127,3 +127,9 @@ LIBIPSET_4.0 {
 global:
   ipset_parse_uint64;
 } LIBIPSET_3.0;
+
+LIBIPSET_4.1 {
+global:
+  ipset_parse_comment;
+  ipset_strlcat;
+} LIBIPSET_4.0;
diff --git a/lib/parse.c b/lib/parse.c
index 112b273..bde56b3 100644
--- a/lib/parse.c
+++ b/lib/parse.c
@@ -1739,6 +1739,33 @@ ipset_parse_iface(struct ipset_session *session,
 }
 
 /**
+ * ipset_parse_comment - parse string as a comment
+ * @session: session structure
+ * @opt: option kind of the data
+ * @str: string to parse
+ *
+ * Parse string for use as a comment on an ipset entry.
+ * Gets stored in the data blob as usual.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+int ipset_parse_comment(struct ipset_session *session,
+		       enum ipset_opt opt, const char *str)
+{
+	struct ipset_data *data;
+
+	assert(session);
+	assert(opt == IPSET_OPT_COMMENT);
+	assert(str);
+
+	data = ipset_session_data(session);
+	if (strlen(str) > IPSET_MAXSTRLEN)
+		return syntax_err("comment is longer than the maximum permitted");
+
+	return ipset_data_set(data, opt, str);
+}
+
+/**
  * ipset_parse_output - parse output format name
  * @session: session structure
  * @opt: option kind of the data
diff --git a/lib/print.c b/lib/print.c
index 86a7674..9ccc3c8 100644
--- a/lib/print.c
+++ b/lib/print.c
@@ -530,6 +530,37 @@ ipset_print_iface(char *buf, unsigned int len,
 }
 
 /**
+ * ipset_print_comment - print arbitrary parameter string
+ * @buf: printing buffer
+ * @len: length of available buffer space
+ * @data: data blob
+ * @opt: the option kind
+ * @env: environment flags
+ *
+ * Print arbitrary string to output buffer.
+ *
+ * Return length of printed string or error size.
+ */
+int ipset_print_comment(char *buf, unsigned int len,
+		       const struct ipset_data *data, enum ipset_opt opt,
+		       uint8_t env UNUSED)
+{
+	const char *comment;
+	int size, offset = 0;
+
+	assert(buf);
+	assert(len > 0);
+	assert(data);
+	assert(opt == IPSET_OPT_COMMENT);
+
+	comment = ipset_data_get(data, opt);
+	assert(comment);
+	size = snprintf(buf + offset, len, "\"%s\"", comment);
+	SNPRINTF_FAILURE(size, len, offset);
+	return offset;
+}
+
+/**
  * ipset_print_proto - print protocol name
  * @buf: printing buffer
  * @len: length of available buffer space
diff --git a/lib/session.c b/lib/session.c
index f1df515..94aa9a7 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -488,6 +488,11 @@ static const struct ipset_attr_policy adt_attrs[] = {
 		.type = MNL_TYPE_U64,
 		.opt = IPSET_OPT_BYTES,
 	},
+	[IPSET_ATTR_COMMENT] = {
+		.type = MNL_TYPE_NUL_STRING,
+		.opt = IPSET_OPT_COMMENT,
+		.len  = IPSET_MAXSTRLEN,
+	},
 };
 
 static const struct ipset_attr_policy ipaddr_attrs[] = {
@@ -522,8 +527,9 @@ generic_data_attr_cb(const struct nlattr *attr, void *data,
 		return MNL_CB_ERROR;
 	}
 	if (policy[type].type == MNL_TYPE_NUL_STRING &&
-	    mnl_attr_get_payload_len(attr) > IPSET_MAXNAMELEN)
+	    mnl_attr_get_payload_len(attr) > IPSET_MAXSTRLEN) {
 		return MNL_CB_ERROR;
+	}
 	tb[type] = attr;
 	return MNL_CB_OK;
 }
diff --git a/lib/types.c b/lib/types.c
index adaba83..b95114f 100644
--- a/lib/types.c
+++ b/lib/types.c
@@ -607,7 +607,7 @@ ipset_load_types(void)
 		len = snprintf(path, sizeof(path), "%.*s",
 			       (unsigned int)(next - dir), dir);
 
-		if (len >= sizeof(path) || len < 0)
+		if (len >= (int)sizeof(path) || len < (int)0)
 			continue;
 
 		n = scandir(path, &list, NULL, alphasort);
@@ -620,7 +620,7 @@ ipset_load_types(void)
 
 			len = snprintf(file, sizeof(file), "%s/%s",
 				       path, list[n]->d_name);
-			if (len >= sizeof(file) || len < 0)
+			if (len >= (int)sizeof(file) || len < (int)0)
 				goto nextf;
 
 			if (dlopen(file, RTLD_NOW) == NULL)
-- 
1.8.3.2

