Return-Path: <SRS0=PMCV=CL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFDD5C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9DB2071B
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:13:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="riQFKQEL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726791AbgIBJNP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:13:15 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48342 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726669AbgIBJNP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 05:13:15 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BhJBf6dTWzFf6X;
        Wed,  2 Sep 2020 02:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1599037994; bh=gPoGvC3oFseV8/c/NF09gMYjbiOsmciUu2qUQkPUqFA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=riQFKQEL+kUHYJ/rUTvNclXkChycZ5984qc5shnJi0D7qA+FwUD84QT3e8Qm2kknP
         5j6OOKNHi9KZDQQnKAJpm/Vfz5Uctigts2QTo5serdc4CReTWZgpxaaddXsSoN4M3t
         /ekHITewwoMN1dT9ta8GXDGnrW68hJfEavPWGLz8=
X-Riseup-User-ID: 18EF6825A4336643D316899DD4352D8F006DA38920AB1753E7BCF2FC1E487BC3
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BhJBf0fN8z8tRn;
        Wed,  2 Sep 2020 02:13:13 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnftnl 2/3] object: add userdata and comment support
Date:   Wed,  2 Sep 2020 11:12:40 +0200
Message-Id: <20200902091241.1379-3-guigom@riseup.net>
In-Reply-To: <20200902091241.1379-1-guigom@riseup.net>
References: <20200902091241.1379-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds NFTNL_OBJ_USERDATA to support userdata for objects.

Also adds NFTNL_UDATA_OBJ_COMMENT to support comments for objects,
stored in userdata space.

Bumps libnftnl.map to 15 as nftnl_obj_get_data needs to be exported to
enable getting object attributes/data.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/libnftnl/object.h           |  1 +
 include/libnftnl/udata.h            |  6 ++++++
 include/linux/netfilter/nf_tables.h |  2 ++
 include/obj.h                       |  5 +++++
 src/libnftnl.map                    |  4 ++++
 src/object.c                        | 26 ++++++++++++++++++++++++++
 6 files changed, 44 insertions(+)

diff --git a/include/libnftnl/object.h b/include/libnftnl/object.h
index 4c23774..9bd83a5 100644
--- a/include/libnftnl/object.h
+++ b/include/libnftnl/object.h
@@ -19,6 +19,7 @@ enum {
 	NFTNL_OBJ_FAMILY,
 	NFTNL_OBJ_USE,
 	NFTNL_OBJ_HANDLE,
+	NFTNL_OBJ_USERDATA,
 	NFTNL_OBJ_BASE		= 16,
 	__NFTNL_OBJ_MAX
 };
diff --git a/include/libnftnl/udata.h b/include/libnftnl/udata.h
index ba6b3ab..2e38fcc 100644
--- a/include/libnftnl/udata.h
+++ b/include/libnftnl/udata.h
@@ -22,6 +22,12 @@ enum nftnl_udata_rule_types {
 };
 #define NFTNL_UDATA_RULE_MAX (__NFTNL_UDATA_RULE_MAX - 1)
 
+enum nftnl_udata_obj_types {
+	NFTNL_UDATA_OBJ_COMMENT,
+	__NFTNL_UDATA_OBJ_MAX
+};
+#define NFTNL_UDATA_OBJ_MAX (__NFTNL_UDATA_OBJ_MAX - 1)
+
 #define NFTNL_UDATA_COMMENT_MAXLEN	128
 
 enum nftnl_udata_set_types {
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index d508154..1d65ff9 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -1542,6 +1542,7 @@ enum nft_ct_expectation_attributes {
  * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
  * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
  * @NFTA_OBJ_HANDLE: object handle (NLA_U64)
+ * @NFTA_OBJ_HANDLE: user data (NLA_BINARY)
  */
 enum nft_object_attributes {
 	NFTA_OBJ_UNSPEC,
@@ -1552,6 +1553,7 @@ enum nft_object_attributes {
 	NFTA_OBJ_USE,
 	NFTA_OBJ_HANDLE,
 	NFTA_OBJ_PAD,
+	NFTA_OBJ_USERDATA,
 	__NFTA_OBJ_MAX
 };
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
diff --git a/include/obj.h b/include/obj.h
index 10f806c..d9e856a 100644
--- a/include/obj.h
+++ b/include/obj.h
@@ -22,6 +22,11 @@ struct nftnl_obj {
 	uint32_t		flags;
 	uint64_t		handle;
 
+	struct {
+		void		*data;
+		uint32_t	len;
+	} user;
+
 	union {
 		struct nftnl_obj_counter {
 			uint64_t	pkts;
diff --git a/src/libnftnl.map b/src/libnftnl.map
index 6042479..ceafa3f 100644
--- a/src/libnftnl.map
+++ b/src/libnftnl.map
@@ -368,3 +368,7 @@ LIBNFTNL_14 {
   nftnl_flowtable_set_array;
   nftnl_flowtable_get_array;
 } LIBNFTNL_13;
+
+LIBNFTNL_15 {
+  nftnl_obj_get_data;
+} LIBNFTNL_14;
diff --git a/src/object.c b/src/object.c
index 4f58272..008bade 100644
--- a/src/object.c
+++ b/src/object.c
@@ -57,6 +57,8 @@ void nftnl_obj_free(const struct nftnl_obj *obj)
 		xfree(obj->table);
 	if (obj->flags & (1 << NFTNL_OBJ_NAME))
 		xfree(obj->name);
+	if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
+		xfree(obj->user.data);
 
 	xfree(obj);
 }
@@ -103,6 +105,16 @@ void nftnl_obj_set_data(struct nftnl_obj *obj, uint16_t attr,
 	case NFTNL_OBJ_HANDLE:
 		memcpy(&obj->handle, data, sizeof(obj->handle));
 		break;
+	case NFTNL_OBJ_USERDATA:
+		if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
+			xfree(obj->user.data);
+
+		obj->user.data = malloc(data_len);
+		if (!obj->user.data)
+			return;
+		memcpy(obj->user.data, data, data_len);
+		obj->user.len = data_len;
+		break;
 	default:
 		if (obj->ops)
 			obj->ops->set(obj, attr, data, data_len);
@@ -174,6 +186,9 @@ const void *nftnl_obj_get_data(struct nftnl_obj *obj, uint16_t attr,
 	case NFTNL_OBJ_HANDLE:
 		*data_len = sizeof(uint64_t);
 		return &obj->handle;
+	case NFTNL_OBJ_USERDATA:
+		*data_len = obj->user.len;
+		return obj->user.data;
 	default:
 		if (obj->ops)
 			return obj->ops->get(obj, attr, data_len);
@@ -235,6 +250,8 @@ void nftnl_obj_nlmsg_build_payload(struct nlmsghdr *nlh,
 		mnl_attr_put_u32(nlh, NFTA_OBJ_TYPE, htonl(obj->ops->type));
 	if (obj->flags & (1 << NFTNL_OBJ_HANDLE))
 		mnl_attr_put_u64(nlh, NFTA_OBJ_HANDLE, htobe64(obj->handle));
+	if (obj->flags & (1 << NFTNL_OBJ_USERDATA))
+		mnl_attr_put(nlh, NFTA_OBJ_USERDATA, obj->user.len, obj->user.data);
 	if (obj->ops) {
 		struct nlattr *nest = mnl_attr_nest_start(nlh, NFTA_OBJ_DATA);
 
@@ -269,6 +286,10 @@ static int nftnl_obj_parse_attr_cb(const struct nlattr *attr, void *data)
 		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
 			abi_breakage();
 		break;
+	case NFTA_OBJ_USERDATA:
+		if (mnl_attr_validate(attr, MNL_TYPE_BINARY) < 0)
+			abi_breakage();
+		break;
 	}
 
 	tb[type] = attr;
@@ -315,6 +336,11 @@ int nftnl_obj_nlmsg_parse(const struct nlmsghdr *nlh, struct nftnl_obj *obj)
 		obj->handle = be64toh(mnl_attr_get_u64(tb[NFTA_OBJ_HANDLE]));
 		obj->flags |= (1 << NFTNL_OBJ_HANDLE);
 	}
+	if (tb[NFTA_OBJ_USERDATA]) {
+		nftnl_obj_set_data(obj, NFTNL_OBJ_USERDATA,
+				   mnl_attr_get_payload(tb[NFTA_OBJ_USERDATA]),
+				   mnl_attr_get_payload_len(tb[NFTA_OBJ_USERDATA]));
+	}
 
 	obj->family = nfg->nfgen_family;
 	obj->flags |= (1 << NFTNL_OBJ_FAMILY);
-- 
2.27.0

