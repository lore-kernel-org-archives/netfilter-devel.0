From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/11] libipset: ipset_strncpy is really a strlcpy-type operation
Date: Sun, 19 Dec 2010 06:18:09 +0100
Message-ID: <1292735894-17534-8-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42667 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab0LSFSW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:22 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/libipset/data.h |    2 +-
 lib/data.c              |   14 +++++++-------
 lib/types.c             |    8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/libipset/data.h b/include/libipset/data.h
index cb35393..4710963 100644
--- a/include/libipset/data.h
+++ b/include/libipset/data.h
@@ -100,7 +100,7 @@ enum ipset_opt {
 
 struct ipset_data;
 
-extern void ipset_strncpy(char *dst, const char *src, size_t len);
+extern void ipset_strlcpy(char *dst, const char *src, size_t len);
 extern bool ipset_data_flags_test(const struct ipset_data *data,
 				  uint64_t flags);
 extern void ipset_data_flags_set(struct ipset_data *data, uint64_t flags);
diff --git a/lib/data.c b/lib/data.c
index 2872c0d..6bc423b 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -85,7 +85,7 @@ copy_addr(uint8_t family, union nf_inet_addr *ip, const void *value)
 }
 
 /**
- * ipset_strncpy - copy the string from src to dst
+ * ipset_strlcpy - copy the string from src to dst
  * @dst: the target string buffer
  * @src: the source string buffer
  * @len: the length of bytes to copy, including the terminating null byte.
@@ -94,7 +94,7 @@ copy_addr(uint8_t family, union nf_inet_addr *ip, const void *value)
  * copied. The target is unconditionally terminated by the null byte.
  */
 void
-ipset_strncpy(char *dst, const char *src, size_t len)
+ipset_strlcpy(char *dst, const char *src, size_t len)
 {
 	assert(dst);
 	assert(src);
@@ -199,7 +199,7 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 	switch (opt) {
 	/* Common ones */
 	case IPSET_SETNAME:
-		ipset_strncpy(data->setname, value, IPSET_MAXNAMELEN);
+		ipset_strlcpy(data->setname, value, IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_TYPE:
 		data->type = value;
@@ -265,7 +265,7 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		break;
 	/* Create-specific options, type */
 	case IPSET_OPT_TYPENAME:
-		ipset_strncpy(data->u.create.typename, value,
+		ipset_strlcpy(data->u.create.typename, value,
 			      IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_REVISION:
@@ -279,10 +279,10 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		memcpy(data->u.adt.ether, value, ETH_ALEN);
 		break;
 	case IPSET_OPT_NAME:
-		ipset_strncpy(data->u.adt.name, value, IPSET_MAXNAMELEN);
+		ipset_strlcpy(data->u.adt.name, value, IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_NAMEREF:
-		ipset_strncpy(data->u.adt.nameref, value, IPSET_MAXNAMELEN);
+		ipset_strlcpy(data->u.adt.nameref, value, IPSET_MAXNAMELEN);
 		break;
 	case IPSET_OPT_IP2:
 		if (!(data->family == AF_INET || data->family == AF_INET6))
@@ -297,7 +297,7 @@ ipset_data_set(struct ipset_data *data, enum ipset_opt opt, const void *value)
 		break;
 	/* Swap/rename */
 	case IPSET_OPT_SETNAME2:
-		ipset_strncpy(data->u.setname2, value, IPSET_MAXNAMELEN);
+		ipset_strlcpy(data->u.setname2, value, IPSET_MAXNAMELEN);
 		break;
 	/* flags */
 	case IPSET_OPT_EXIST:
diff --git a/lib/types.c b/lib/types.c
index 3034477..d979c24 100644
--- a/lib/types.c
+++ b/lib/types.c
@@ -54,7 +54,7 @@ ipset_cache_add(const char *name, const struct ipset_type *type,
 	if (n == NULL)
 		return -ENOMEM;
 
-	ipset_strncpy(n->name, name, IPSET_MAXNAMELEN);
+	ipset_strlcpy(n->name, name, IPSET_MAXNAMELEN);
 	n->type = type;
 	n->family = family;
 	n->next = NULL;	
@@ -133,7 +133,7 @@ ipset_cache_rename(const char *from, const char *to)
 
 	for (s = setlist; s != NULL; s = s->next) {
 		if (STREQ(s->name, from)) {
-			ipset_strncpy(s->name, to, IPSET_MAXNAMELEN);
+			ipset_strlcpy(s->name, to, IPSET_MAXNAMELEN);
 			return 0;
 		}
 	}
@@ -164,8 +164,8 @@ ipset_cache_swap(const char *from, const char *to)
 			b = s;
 	}
 	if (a != NULL && b != NULL) {
-		ipset_strncpy(a->name, to, IPSET_MAXNAMELEN);
-		ipset_strncpy(b->name, from, IPSET_MAXNAMELEN);
+		ipset_strlcpy(a->name, to, IPSET_MAXNAMELEN);
+		ipset_strlcpy(b->name, from, IPSET_MAXNAMELEN);
 		return 0;
 	}
 		
-- 
1.7.1

