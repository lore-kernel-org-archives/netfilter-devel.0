From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 1/6 v2] netfilter: ipset: Support comments for ipset entries in the core.
Date: Mon,  2 Sep 2013 10:21:31 +0200
Message-ID: <1378110091-16400-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:56908 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3IBIVw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:21:52 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 1D09DA29BD
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Sep 2013 09:21:43 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id dCKyFzDQeyuk for <netfilter-devel@vger.kernel.org>;
	Mon,  2 Sep 2013 09:21:32 +0100 (BST)
In-Reply-To: <1378103757-14426-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This adds the core support for having comments on ipset entries.

The comments are stored as standard null-terminated strings in
dynamically allocated memory after being passed to the kernel. As a
result of this, any ipset using comments MUST perform cleanup of
individual entries when being flushed or destroyed in order to ensure
the allocated memory is released.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 kernel/include/linux/netfilter/ipset/ip_set.h      | 12 +++++
 .../include/linux/netfilter/ipset/ip_set_comment.h | 54 ++++++++++++++++++++++
 kernel/include/uapi/linux/netfilter/ipset/ip_set.h |  4 ++
 kernel/net/netfilter/ipset/ip_set_core.c           |  6 +++
 4 files changed, 76 insertions(+)
 create mode 100644 kernel/include/linux/netfilter/ipset/ip_set_comment.h

diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index f974f35..7543d5c 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -55,22 +55,29 @@ enum ip_set_extension {
 	IPSET_EXT_TIMEOUT = (1 << IPSET_EXT_BIT_TIMEOUT),
 	IPSET_EXT_BIT_COUNTER = 2,
 	IPSET_EXT_COUNTER = (1 << IPSET_EXT_BIT_COUNTER),
+	IPSET_EXT_BIT_COMMENT = 3,
+	IPSET_EXT_COMMENT = (1 << IPSET_EXT_BIT_COMMENT),
 };
 
 /* Extension offsets */
 enum ip_set_offset {
 	IPSET_OFFSET_TIMEOUT = 0,
 	IPSET_OFFSET_COUNTER,
+	IPSET_OFFSET_COMMENT,
 	IPSET_OFFSET_MAX,
 };
 
 #define SET_WITH_TIMEOUT(s)	((s)->extensions & IPSET_EXT_TIMEOUT)
 #define SET_WITH_COUNTER(s)	((s)->extensions & IPSET_EXT_COUNTER)
+#define SET_WITH_COMMENT(s)	((s)->extensions & IPSET_EXT_COMMENT)
+
+/* Comment struct */
 
 struct ip_set_ext {
 	u32 timeout;
 	u64 packets;
 	u64 bytes;
+	char *comment;
 };
 
 struct ip_set;
@@ -189,6 +196,10 @@ struct ip_set_counter {
 	atomic64_t packets;
 };
 
+struct ip_set_comment {
+	char *str;
+};
+
 static inline void
 ip_set_add_bytes(u64 bytes, struct ip_set_counter *counter)
 {
@@ -390,6 +401,7 @@ bitmap_bytes(u32 a, u32 b)
 }
 
 #include <linux/netfilter/ipset/ip_set_timeout.h>
+#include <linux/netfilter/ipset/ip_set_comment.h>
 
 #define IP_SET_INIT_KEXT(skb, opt, map)			\
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
index 17779ca..bc01f05 100644
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
@@ -182,6 +184,8 @@ enum ipset_cadt_flags {
 	IPSET_FLAG_WITH_TIMEOUTS = (1 << IPSET_FLAG_EXT_BEGIN),
 	IPSET_FLAG_BIT_WITH_COUNTERS = 3,
 	IPSET_FLAG_WITH_COUNTERS = (1 << IPSET_FLAG_BIT_WITH_COUNTERS),
+	IPSET_FLAG_BIT_WITH_COMMENTS = 4,
+	IPSET_FLAG_WITH_COMMENTS = (1 << IPSET_FLAG_BIT_WITH_COMMENTS),
 	IPSET_FLAG_CADT_MAX	= 15,
 };
 
diff --git a/kernel/net/netfilter/ipset/ip_set_core.c b/kernel/net/netfilter/ipset/ip_set_core.c
index 4c95bb8..292596f 100644
--- a/kernel/net/netfilter/ipset/ip_set_core.c
+++ b/kernel/net/netfilter/ipset/ip_set_core.c
@@ -340,6 +340,12 @@ ip_set_get_extensions(struct ip_set *set, struct nlattr *tb[],
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

