From: Khem Raj <raj.khem@gmail.com>
Subject: [libnetfilter-acct][PATCH] Declare the define visibility attribute together
Date: Mon, 10 Apr 2017 15:27:48 -0700
Message-ID: <20170410222748.10825-1-raj.khem@gmail.com>
Cc: Khem Raj <raj.khem@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:36807 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751983AbdDJW17 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Apr 2017 18:27:59 -0400
Received: by mail-pg0-f68.google.com with SMTP id 81so27360914pgh.3
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Apr 2017 15:27:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

clang ignores the visibility attribute if its not
defined before the definition. As a result these
symbols become hidden and consumers of this library
fail to link due to these missing symbols

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 doxygen.cfg.in          |  2 +-
 src/internal.h          |  5 ++---
 src/libnetfilter_acct.c | 41 ++++++++++++++---------------------------
 3 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index 7f4bd04..fe64d48 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -72,7 +72,7 @@ RECURSIVE              = YES
 EXCLUDE                = 
 EXCLUDE_SYMLINKS       = NO
 EXCLUDE_PATTERNS       = */.git/* .*.d
-EXCLUDE_SYMBOLS        = EXPORT_SYMBOL nfacct
+EXCLUDE_SYMBOLS        = nfacct
 EXAMPLE_PATH           = 
 EXAMPLE_PATTERNS       = 
 EXAMPLE_RECURSIVE      = NO
diff --git a/src/internal.h b/src/internal.h
index f0cc2e1..e5c5ffd 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -3,10 +3,9 @@
 
 #include "config.h"
 #ifdef HAVE_VISIBILITY_HIDDEN
-#	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
+#	define __EXPORT	__attribute__((visibility("default")))
 #else
-#	define EXPORT_SYMBOL
+#	define __EXPORT
 #endif
 
 #include <endian.h>
diff --git a/src/libnetfilter_acct.c b/src/libnetfilter_acct.c
index b0bcf67..0220d14 100644
--- a/src/libnetfilter_acct.c
+++ b/src/libnetfilter_acct.c
@@ -76,21 +76,19 @@ struct nfacct {
  * In case of success, this function returns a valid pointer, otherwise NULL
  * s returned and errno is appropriately set.
  */
-struct nfacct *nfacct_alloc(void)
+struct nfacct __EXPORT *nfacct_alloc(void)
 {
 	return calloc(1, sizeof(struct nfacct));
 }
-EXPORT_SYMBOL(nfacct_alloc);
 
 /**
  * nfacct_free - release one accounting object
  * \param nfacct pointer to the accounting object
  */
-void nfacct_free(struct nfacct *nfacct)
+void __EXPORT nfacct_free(struct nfacct *nfacct)
 {
 	free(nfacct);
 }
-EXPORT_SYMBOL(nfacct_free);
 
 /**
  * nfacct_attr_set - set one attribute of the accounting object
@@ -98,7 +96,7 @@ EXPORT_SYMBOL(nfacct_free);
  * \param type attribute type you want to set
  * \param data pointer to data that will be used to set this attribute
  */
-void
+void __EXPORT
 nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		const void *data)
 {
@@ -126,7 +124,6 @@ nfacct_attr_set(struct nfacct *nfacct, enum nfacct_attr_type type,
 		break;
 	}
 }
-EXPORT_SYMBOL(nfacct_attr_set);
 
 /**
  * nfacct_attr_set_str - set one attribute the accounting object
@@ -134,13 +131,12 @@ EXPORT_SYMBOL(nfacct_attr_set);
  * \param type attribute type you want to set
  * \param name string that will be used to set this attribute
  */
-void
+void __EXPORT
 nfacct_attr_set_str(struct nfacct *nfacct, enum nfacct_attr_type type,
 		    const char *name)
 {
 	nfacct_attr_set(nfacct, type, name);
 }
-EXPORT_SYMBOL(nfacct_attr_set_str);
 
 /**
  * nfacct_attr_set_u64 - set one attribute the accounting object
@@ -148,20 +144,19 @@ EXPORT_SYMBOL(nfacct_attr_set_str);
  * \param type attribute type you want to set
  * \param value unsigned 64-bits integer
  */
-void
+void __EXPORT
 nfacct_attr_set_u64(struct nfacct *nfacct, enum nfacct_attr_type type,
 		    uint64_t value)
 {
 	nfacct_attr_set(nfacct, type, &value);
 }
-EXPORT_SYMBOL(nfacct_attr_set_u64);
 
 /**
  * nfacct_attr_unset - unset one attribute the accounting object
  * \param nfacct pointer to the accounting object
  * \param type attribute type you want to set
  */
-void
+void __EXPORT
 nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type)
 {
 	switch(type) {
@@ -182,7 +177,6 @@ nfacct_attr_unset(struct nfacct *nfacct, enum nfacct_attr_type type)
 		break;
 	}
 }
-EXPORT_SYMBOL(nfacct_attr_unset);
 
 /**
  * nfacct_attr_get - get one attribute the accounting object
@@ -192,7 +186,7 @@ EXPORT_SYMBOL(nfacct_attr_unset);
  * This function returns a valid pointer to the attribute data. If a
  * unsupported attribute is used, this returns NULL.
  */
-const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
+const void __EXPORT *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
 {
 	const void *ret = NULL;
 
@@ -220,7 +214,6 @@ const void *nfacct_attr_get(struct nfacct *nfacct, enum nfacct_attr_type type)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(nfacct_attr_get);
 
 /**
  * nfacct_attr_get_str - get one attribute the accounting object
@@ -230,12 +223,11 @@ EXPORT_SYMBOL(nfacct_attr_get);
  * This function returns a valid pointer to the beginning of the string.
  * If the attribute is unsupported, this returns NULL.
  */
-const char *
+const char __EXPORT *
 nfacct_attr_get_str(struct nfacct *nfacct, enum nfacct_attr_type type)
 {
 	return nfacct_attr_get(nfacct, type);
 }
-EXPORT_SYMBOL(nfacct_attr_get_str);
 
 /**
  * nfacct_attr_get_u64 - get one attribute the accounting object
@@ -245,12 +237,11 @@ EXPORT_SYMBOL(nfacct_attr_get_str);
  * This function returns a unsigned 64-bits integer. If the attribute is
  * unsupported, this returns NULL.
  */
-uint64_t nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
+uint64_t __EXPORT nfacct_attr_get_u64(struct nfacct *nfacct, enum nfacct_attr_type type)
 {
 	const void *ret = nfacct_attr_get(nfacct, type);
 	return ret ? *((uint64_t *)ret) : 0;
 }
-EXPORT_SYMBOL(nfacct_attr_get_u64);
 
 static int
 nfacct_snprintf_plain(char *buf, size_t rem, struct nfacct *nfacct,
@@ -424,8 +415,8 @@ err:
  * This function returns -1 in case that some mandatory attributes are
  * missing. On sucess, it returns 0.
  */
-int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
-		    uint16_t type, uint16_t flags)
+int __EXPORT nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
+		             uint16_t type, uint16_t flags)
 {
 	int ret = 0;
 
@@ -445,7 +436,6 @@ int nfacct_snprintf(char *buf, size_t size, struct nfacct *nfacct,
 	}
 	return ret;
 }
-EXPORT_SYMBOL(nfacct_snprintf);
 
 /**
  * @}
@@ -484,7 +474,7 @@ EXPORT_SYMBOL(nfacct_snprintf);
  * - Command NFNL_MSG_ACCT_DEL, to delete one specific nfacct object (if
  *   unused, otherwise you hit EBUSY).
  */
-struct nlmsghdr *
+struct nlmsghdr __EXPORT *
 nfacct_nlmsg_build_hdr(char *buf, uint8_t cmd, uint16_t flags, uint32_t seq)
 {
 	struct nlmsghdr *nlh;
@@ -502,14 +492,13 @@ nfacct_nlmsg_build_hdr(char *buf, uint8_t cmd, uint16_t flags, uint32_t seq)
 
 	return nlh;
 }
-EXPORT_SYMBOL(nfacct_nlmsg_build_hdr);
 
 /**
  * nfacct_nlmsg_build_payload - build payload from accounting object
  * \param nlh: netlink message that you want to use to add the payload.
  * \param nfacct: pointer to a accounting object
  */
-void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
+void __EXPORT nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 {
 	if (nfacct->bitset & (1 << NFACCT_ATTR_NAME))
 		mnl_attr_put_strz(nlh, NFACCT_NAME, nfacct->name);
@@ -526,7 +515,6 @@ void nfacct_nlmsg_build_payload(struct nlmsghdr *nlh, struct nfacct *nfacct)
 	if (nfacct->bitset & (1 << NFACCT_ATTR_QUOTA))
 		mnl_attr_put_u64(nlh, NFACCT_QUOTA, htobe64(nfacct->quota));
 }
-EXPORT_SYMBOL(nfacct_nlmsg_build_payload);
 
 static int nfacct_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
 {
@@ -563,7 +551,7 @@ static int nfacct_nlmsg_parse_attr_cb(const struct nlattr *attr, void *data)
  * This function returns -1 in case that some mandatory attributes are
  * missing. On sucess, it returns 0.
  */
-int
+int __EXPORT
 nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct)
 {
 	struct nlattr *tb[NFACCT_MAX+1] = {};
@@ -589,7 +577,6 @@ nfacct_nlmsg_parse_payload(const struct nlmsghdr *nlh, struct nfacct *nfacct)
 
 	return 0;
 }
-EXPORT_SYMBOL(nfacct_nlmsg_parse_payload);
 
 /**
  * @}
-- 
2.12.2

