From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH v2 1/5] networking: Introduce nla_strdup()
Date: Mon, 24 Jul 2017 20:56:47 +0200
Message-ID: <20170724185651.24063-2-phil@nwl.cc>
References: <20170724185651.24063-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35223 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753177AbdGXS5K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jul 2017 14:57:10 -0400
In-Reply-To: <20170724185651.24063-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is similar to strdup() for netlink string attributes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netlink.h |  1 +
 lib/nlattr.c          | 24 ++++++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 01709172b3d38..5c1fc1d4b0969 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -247,6 +247,7 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 int nla_policy_len(const struct nla_policy *, int);
 struct nlattr *nla_find(const struct nlattr *head, int len, int attrtype);
 size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize);
+char *nla_strdup(const struct nlattr *nla, gfp_t flags);
 int nla_memcpy(void *dest, const struct nlattr *src, int count);
 int nla_memcmp(const struct nlattr *nla, const void *data, size_t size);
 int nla_strcmp(const struct nlattr *nla, const char *str);
diff --git a/lib/nlattr.c b/lib/nlattr.c
index a7e0b16078dff..af8716fb8a3bf 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -272,6 +272,30 @@ size_t nla_strlcpy(char *dst, const struct nlattr *nla, size_t dstsize)
 EXPORT_SYMBOL(nla_strlcpy);
 
 /**
+ * nla_strdup - Copy string attribute payload into a newly allocated buffer
+ * @nla: attribute to copy the string from
+ * @flags: the type of memory to allocate (see kmalloc).
+ *
+ * Returns a pointer to the allocated buffer or NULL on error.
+ */
+char *nla_strdup(const struct nlattr *nla, gfp_t flags)
+{
+	size_t srclen = nla_len(nla);
+	char *src = nla_data(nla), *dst;
+
+	if (srclen > 0 && src[srclen - 1] == '\0')
+		srclen--;
+
+	dst = kmalloc(srclen + 1, flags);
+	if (dst != NULL) {
+		memcpy(dst, src, srclen);
+		dst[srclen] = '\0';
+	}
+	return dst;
+}
+EXPORT_SYMBOL(nla_strdup);
+
+/**
  * nla_memcpy - Copy a netlink attribute into another memory area
  * @dest: where to copy to memcpy
  * @src: netlink attribute to copy from
-- 
2.13.1

