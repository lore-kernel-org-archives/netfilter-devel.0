From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: [PATCH] src: parse new handle attribute for objects
Date: Fri, 19 Jan 2018 00:21:32 +0530
Message-ID: <20180118185132.8730-1-harshasharmaiitr@gmail.com>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org, harshasharmaiitr@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:39554 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752368AbeARSvt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jan 2018 13:51:49 -0500
Received: by mail-pf0-f196.google.com with SMTP id e11so15334866pff.6
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2018 10:51:49 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add code to allocate object handles and delete objects via
object handles.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
---
 include/libnftnl/object.h           |  1 +
 include/linux/netfilter/nf_tables.h |  2 ++
 include/obj.h                       |  1 +
 src/object.c                        | 20 +++++++++++++++++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 1c3bc7c..f4be8ce 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -19,6 +19,7 @@ enum {
 	NFTNL_OBJ_FAMILY,
 	NFTNL_OBJ_USE,
 	NFTNL_OBJ_BASE		= 16,
+	NFTNL_OBJ_HANDLE,
 	__NFTNL_OBJ_MAX
 };
 #define NFTNL_OBJ_MAX (__NFTNL_OBJ_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 120fa23..e9a8ba1 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1291,6 +1291,7 @@ enum nft_ct_helper_attributes {
  *
  * @NFTA_OBJ_TABLE: name of the table containing the expression (NLA_STRING)
  * @NFTA_OBJ_NAME: name of this expression type (NLA_STRING)
+ * @NFTA_OBJ_HANDLE: numeric object handle (NLA_U64)
  * @NFTA_OBJ_TYPE: stateful object type (NLA_U32)
  * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
  * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
@@ -1302,6 +1303,7 @@ enum nft_object_attributes {
 	NFTA_OBJ_TYPE,
 	NFTA_OBJ_DATA,
 	NFTA_OBJ_USE,
+	NFTA_OBJ_HANDLE,
 	__NFTA_OBJ_MAX
 };
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
diff --git a/include/obj.h b/include/obj.h
index d17d63a..4a728c8 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -19,6 +19,7 @@ struct nftnl_obj {
 	uint32_t		use;
 
 	uint32_t		flags;
+	uint64_t		handle;
 
 	union {
 		struct nftnl_obj_counter {
diff --git a/src/object.c b/src/object.c
index da3423b..e20e820 100644
--- a/src/object.c
+++ b/src/object.c
@@ -66,6 +66,7 @@ EXPORT_SYMBOL(nftnl_obj_is_set);
 static uint32_t nftnl_obj_validate[NFTNL_OBJ_MAX + 1] = {
 	[NFTNL_OBJ_FAMILY]	= sizeof(uint32_t),
 	[NFTNL_OBJ_USE]		= sizeof(uint32_t),
+	[NFTNL_OBJ_HANDLE]	= sizeof(uint64_t),
 };
 
 void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
@@ -94,6 +95,9 @@ void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 	case NFTNL_OBJ_USE:
 		obj->use = *((uint32_t *)data);
 		break;
+	case NFTNL_OBJ_HANDLE:
+		obj->handle = *((uint64_t *)data);
+		break;
 	default:
 		if (obj->ops)
 			obj->ops->set(obj, attr, data, data_len);
@@ -162,6 +166,9 @@ const void *nftnl_obj_get_data(struct nftnl_obj *obj, uint16_t attr,
 	case NFTNL_OBJ_USE:
 		*data_len = sizeof(uint32_t);
 		return &obj->use;
+	case NFTNL_OBJ_HANDLE:
+		*data_len = sizeof(uint64_t);
+		return &obj->handle;
 	default:
 		if (obj->ops)
 			return obj->ops->get(obj, attr, data_len);
@@ -221,7 +228,8 @@ void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_put_strz(nlh, NFTA_OBJ_NAME, obj->name);
 	if (obj->flags & (1 << NFTNL_OBJ_TYPE))
 		mnl_attr_put_u32(nlh, NFTA_OBJ_TYPE, htonl(obj->ops->type));
-
+	if (obj->flags & (1 << NFTNL_OBJ_HANDLE))
+		mnl_attr_put_u64(nlh, NFTA_OBJ_HANDLE, htobe64(obj->handle));
 	if (obj->ops) {
 		struct nlattr *nest = mnl_attr_nest_start(nlh, NFTA_OBJ_DATA);
 
@@ -245,6 +253,10 @@ static int nftnl_obj_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
 			abi_breakage();
 		break;
+	case NFTA_OBJ_HANDLE:
+		if (mnl_attr_validate(attr, MNL_TYPE_U64) < 0)
+			abi_breakage();
+		break;
 	case NFTA_OBJ_DATA:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 			abi_breakage();
@@ -294,6 +306,10 @@ int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
 		obj->use = ntohl(mnl_attr_get_u32(tb[NFTA_OBJ_USE]));
 		obj->flags |= (1 << NFTNL_OBJ_USE);
 	}
+	if (tb[NFTA_OBJ_HANDLE]) {
+		obj->handle = be64toh(mnl_attr_get_u64(tb[NFTA_OBJ_HANDLE]));
+		obj->flags |= (1 << NFTNL_OBJ_HANDLE);
+	}
 
 	obj->family = nfg->nfgen_family;
 	obj->flags |= (1 << NFTNL_OBJ_FAMILY);
@@ -409,6 +425,8 @@ static int nftnl_obj_export(char *buf, size_t size,
 		nftnl_buf_str(&b, type, nftnl_family2str(obj->family), FAMILY);
 	if (obj->flags & (1 << NFTNL_OBJ_USE))
 		nftnl_buf_u32(&b, type, obj->use, USE);
+	if (obj->flags & (1 << NFTNL_OBJ_HANDLE))
+		nftnl_buf_u64(&b, type, obj->handle, HANDLE);
 
 	if (obj->ops)
 		ret = obj->ops->snprintf(buf + b.len, size - b.len, type,
-- 
2.11.0

