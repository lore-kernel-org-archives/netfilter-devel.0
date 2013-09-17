From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 1/6] netfilter: ipset: Support comments for ipset entries in the core.
Date: Tue, 17 Sep 2013 15:13:20 +0200
Message-ID: <1379423605-22777-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:60526 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3IQNOU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Sep 2013 09:14:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id F0C21A32B1
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2013 14:14:19 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id cXPINwTVAiYp for <netfilter-devel@vger.kernel.org>;
	Tue, 17 Sep 2013 14:13:27 +0100 (BST)
In-Reply-To: <1379423605-22777-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This adds the core support for having comments on ipset entries.

The comments are stored as standard null-terminated strings in
dynamically allocated memory after being passed to the kernel. As a
result of this, code has been added to the generic destroy function to
iterate all extensions and call that extension's destroy task if the set
has that extension activated, and if such a task is defined.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/include/linux/netfilter/ipset/ip_set.h      | 40 ++++++++++++----
 .../include/linux/netfilter/ipset/ip_set_comment.h | 54 ++++++++++++++++++++++
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |  4 ++
 kernel/net/netfilter/ipset/ip_set_core.c           | 14 ++++++
 4 files changed, 104 insertions(+), 8 deletions(-)
 create mode 100644 kernel/include/linux/netfilter/ipset/ip_set_comment.h

diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index c687abb..ee831f3 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -54,6 +54,8 @@ enum ip_set_extension {
 	IPSET_EXT_TIMEOUT = (1 << IPSET_EXT_BIT_TIMEOUT),
 	IPSET_EXT_BIT_COUNTER = 1,
 	IPSET_EXT_COUNTER = (1 << IPSET_EXT_BIT_COUNTER),
+	IPSET_EXT_BIT_COMMENT = 2,
+	IPSET_EXT_COMMENT = (1 << IPSET_EXT_BIT_COMMENT),
 	/* Mark set with an extension which needs to call destroy */
 	IPSET_EXT_BIT_DESTROY = 7,
 	IPSET_EXT_DESTROY = (1 << IPSET_EXT_BIT_DESTROY),
@@ -61,11 +63,15 @@ enum ip_set_extension {
 
 #define SET_WITH_TIMEOUT(s)	((s)->extensions & IPSET_EXT_TIMEOUT)
 #define SET_WITH_COUNTER(s)	((s)->extensions & IPSET_EXT_COUNTER)
+#define SET_WITH_COMMENT(s)	((s)->extensions & IPSET_EXT_COMMENT)
+
+/* Comment struct */
 
 /* Extension id, in size order */
 enum ip_set_ext_id {
 	IPSET_EXT_ID_COUNTER = 0,
 	IPSET_EXT_ID_TIMEOUT,
+	IPSET_EXT_ID_COMMENT,
 	IPSET_EXT_ID_MAX,
 };
 
@@ -86,6 +92,7 @@ struct ip_set_ext {
 	u64 packets;
 	u64 bytes;
 	u32 timeout;
+	char *comment;
 };
 
 struct ip_set_counter {
@@ -93,20 +100,21 @@ struct ip_set_counter {
 	atomic64_t packets;
 };
 
-struct ip_set;
+struct ip_set_comment {
+	char *str;
+};
 
-static inline void
-ip_set_ext_destroy(struct ip_set *set, void *data)
-{
-	/* Check that the extension is enabled for the set and
-	 * call it's destroy function for its extension part in data.
-	 */
-}
+struct ip_set;
 
+#define ext_generic(e, s, i)	\
+(void *)(((void *)(e)) + (s)->offset[i])
 #define ext_timeout(e, s)	\
 (unsigned long *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_TIMEOUT])
 #define ext_counter(e, s)	\
 (struct ip_set_counter *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_COUNTER])
+#define ext_comment(e, s)	\
+(struct ip_set_comment *)(((void *)(e)) + (s)->offset[IPSET_EXT_ID_COMMENT])
+
 
 typedef int (*ipset_adtfn)(struct ip_set *set, void *value,
 			   const struct ip_set_ext *ext,
@@ -224,6 +232,21 @@ struct ip_set {
 };
 
 static inline void
+ip_set_ext_destroy(struct ip_set *set, void *data)
+{
+	u32 id = 0;
+	/* Check that the extension is enabled for the set and
+	 * call it's destroy function for its extension part in data.
+	 */
+	for (; id < IPSET_EXT_ID_MAX; id++) {
+		if (!(set->extensions & ip_set_extensions[id].type) ||
+		    !ip_set_extensions[id].destroy)
+			continue;
+		ip_set_extensions[id].destroy(ext_generic(data, set, id));
+	}
+}
+
+static inline void
 ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
 {
 	atomic64_add((long long)bytes, &(counter)->bytes);
@@ -426,6 +449,7 @@ bitmap_bytes(u32 a, u32 b)
 }
 
 #include <linux/netfilter/ipset/ip_set_timeout.h>
+#include <linux/netfilter/ipset/ip_set_comment.h>
 
 #define IP_SET_INIT_KEXT(skb, opt, set)			\
 	{ .bytes = (skb)->len, .packets = 1,		\
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_comment.h b/kernel/include/linux/netfilter/ipset/ip_set_comment.h
new file mode 100644
index 0000000..981a41e
--- /dev/null
+++ b/kernel/include/linux/netfilter/ipset/ip_set_comment.h
@@ -0,0 +1,54 @@
+#ifndef _IP_SET_COMMENT_H
+#define _IP_SET_COMMENT_H
+
+/* Copyright (C) 2013 Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#define IP_SET_MAX_COMMENT_SIZE 255
+
+#ifdef __KERNEL__
+
+static inline char*
+ip_set_comment_uget(struct nlattr *tb)
+{
+	return nla_data(tb);
+}
+
+static inline void
+ip_set_init_comment(struct ip_set_comment *comment,
+		    const struct ip_set_ext *ext)
+{
+	size_t len = ext->comment ? strlen(ext->comment) : 0;
+	if (!len)
+		return;
+	if (unlikely(len > IP_SET_MAX_COMMENT_SIZE))
+		len = IP_SET_MAX_COMMENT_SIZE;
+	if (unlikely(comment->str))
+		kfree(comment->str);
+	comment->str = kzalloc(len + 1, GFP_KERNEL);
+	strlcpy(comment->str, ext->comment, len + 1);
+}
+
+static inline bool
+ip_set_put_comment(struct sk_buff *skb, struct ip_set_comment *comment)
+{
+	if(!comment->str)
+		return NULL;
+	return nla_put_string(skb, IPSET_ATTR_COMMENT, comment->str);
+}
+
+static inline void
+ip_set_comment_free(struct ip_set_comment *comment)
+{
+	if(unlikely(!comment->str))
+		return;
+	kfree(comment->str);
+	comment->str = NULL;
+}
+
+#endif
+#endif
diff --git a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
index 2b61ac4..98dce6a 100644
--- a/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/uapi/linux/netfilter/ipset/ip_set.h
@@ -110,6 +110,7 @@ enum {
 	IPSET_ATTR_IFACE,
 	IPSET_ATTR_BYTES,
 	IPSET_ATTR_PACKETS,
+	IPSET_ATTR_COMMENT,
 	__IPSET_ATTR_ADT_MAX,
 };
 #define IPSET_ATTR_ADT_MAX	(__IPSET_ATTR_ADT_MAX - 1)
@@ -140,6 +141,7 @@ enum ipset_errno {
 	IPSET_ERR_IPADDR_IPV4,
 	IPSET_ERR_IPADDR_IPV6,
 	IPSET_ERR_COUNTER,
+	IPSET_ERR_COMMENT,
 
 	/* Type specific error codes */
 	IPSET_ERR_TYPE_SPECIFIC = 4352,
@@ -176,6 +178,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_NOMATCH	= (1 << IPSET_FLAG_BIT_NOMATCH),
 	IPSET_FLAG_BIT_WITH_COUNTERS = 3,
 	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
+	IPSET_FLAG_BIT_WITH_COMMENTS = 4,
+	IPSET_FLAG_WITH_COMMENTS = (1 << IPSET_FLAG_BIT_WITH_COMMENTS),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
index a2030ee..84b73cf 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -321,6 +321,7 @@ ip_set_get_ipaddr6(struct nlattr *nla, union nf_inet_addr *ipaddr)
 }
 EXPORT_SYMBOL_GPL(ip_set_get_ipaddr6);
 
+typedef void (*destroyer)(void *);
 /* ipset data extension types, in size order */
 
 const struct ip_set_ext_type ip_set_extensions[] = {
@@ -335,6 +336,13 @@ const struct ip_set_ext_type ip_set_extensions[] = {
 		.len	= sizeof(unsigned long),
 		.align	= __alignof__(unsigned long),
 	},
+	[IPSET_EXT_ID_COMMENT] = {
+		.type	 = IPSET_EXT_COMMENT | IPSET_EXT_DESTROY,
+		.flag	 = IPSET_FLAG_WITH_COMMENTS,
+		.len	 = sizeof(struct ip_set_comment),
+		.align	 = __alignof__(struct ip_set_comment),
+		.destroy = (destroyer) ip_set_comment_free,
+	},
 };
 EXPORT_SYMBOL_GPL(ip_set_extensions);
 
@@ -386,6 +394,12 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
 			ext->packets = be64_to_cpu(nla_get_be64(
 						   tb[IPSET_ATTR_PACKETS]));
 	}
+	if(tb[IPSET_ATTR_COMMENT]) {
+		if(!(set->extensions & IPSET_EXT_COMMENT))
+			return -IPSET_ERR_COMMENT;
+		ext->comment = ip_set_comment_uget(tb[IPSET_ATTR_COMMENT]);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ip_set_get_extensions);
-- 
1.8.3.2

