From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/5] attr: avoid multiple definition of hidden variable
Date: Thu, 11 Nov 2010 00:08:04 +0100
Message-ID: <1289430485-16467-6-git-send-email-jengelh@medozas.de>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56323 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270Ab0KJXIM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:08:12 -0500
In-Reply-To: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When nesting two mnl_attr_for_each loops, the __len__ variable will be
declared twice, eliciting a warning when -Wshadow is turned on. There
can also be warnings in pre-C99 because declarations and code are
mixed. Do without any temporaries that are not explicitly specified as
macro parameters.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |   24 +++++++++++-------------
 src/attr.c              |   17 +++++------------
 2 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 43388e5..9520a07 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -122,19 +122,17 @@ extern int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type
 
 /* TLV iterators */
 extern bool mnl_attr_ok(const struct nlattr *attr, int len);
-extern struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len);
-
-#define mnl_attr_for_each(attr, nlh, offset)			\
-	int __len__ = mnl_nlmsg_get_payload_len(nlh);		\
-	for (attr = mnl_nlmsg_get_payload_offset(nlh, offset);	\
-	     mnl_attr_ok(attr, __len__);			\
-	     attr = mnl_attr_next(attr, &(__len__)))
-
-#define mnl_attr_for_each_nested(attr, nest)			\
-	int __len__ = mnl_attr_get_len(nest);			\
-	for (attr = mnl_attr_get_payload(nest);			\
-	     mnl_attr_ok(attr, __len__);			\
-	     attr = mnl_attr_next(attr, &(__len__)))
+extern struct nlattr *mnl_attr_next(const struct nlattr *attr);
+
+#define mnl_attr_for_each(attr, nlh, offset) \
+	for ((attr) = mnl_nlmsg_get_payload_offset((nlh), (offset)); \
+	     mnl_attr_ok((attr), mnl_nlmsg_get_payload_tail(nlh) - (void *)(attr)); \
+	     (attr) = mnl_attr_next(attr))
+
+#define mnl_attr_for_each_nested(attr, nest) \
+	for ((attr) = mnl_attr_get_payload(nest); \
+	     mnl_attr_ok((attr), mnl_attr_get_payload(attr) + mnl_attr_get_payload_len(attr) - (void *)(attr)); \
+	     (attr) = mnl_attr_next(attr))
 
 /* TLV callback-based attribute parsers */
 typedef int (*mnl_attr_cb_t)(const struct nlattr *attr, void *data);
diff --git a/src/attr.c b/src/attr.c
index e22a8ac..5137395 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -106,9 +106,8 @@ bool mnl_attr_ok(const struct nlattr *attr, int len)
  * as parameter. You have to use mnl_attr_ok() to ensure that the next
  * attribute is valid.
  */
-struct nlattr *mnl_attr_next(const struct nlattr *attr, int *len)
+struct nlattr *mnl_attr_next(const struct nlattr *attr)
 {
-	*len -= MNL_ALIGN(attr->nla_len);
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
 }
 
@@ -256,14 +255,11 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 		   mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
-	const struct nlattr *attr = mnl_nlmsg_get_payload_offset(nlh, offset);
-	int len = nlh->nlmsg_len - MNL_NLMSG_HDRLEN - MNL_ALIGN(offset);
+	const struct nlattr *attr;
 
-	while (mnl_attr_ok(attr, len)) {
+	mnl_attr_for_each(attr, nlh, offset)
 		if ((ret = cb(attr, data)) <= MNL_CB_STOP)
 			return ret;
-		attr = mnl_attr_next(attr, &len);
-	}
 	return ret;
 }
 
@@ -285,14 +281,11 @@ int mnl_attr_parse_nested(const struct nlattr *nested,
 			  mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
-	const struct nlattr *attr = mnl_attr_get_payload(nested);
-	int len = mnl_attr_get_payload_len(nested);
+	const struct nlattr *attr;
 
-	while (mnl_attr_ok(attr, len)) {
+	mnl_attr_for_each_nested(attr, nested)
 		if ((ret = cb(attr, data)) <= MNL_CB_STOP)
 			return ret;
-		attr = mnl_attr_next(attr, &len);
-	}
 	return ret;
 }
 
-- 
1.7.1

