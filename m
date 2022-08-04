Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25253C25B06
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 22:06:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbiHDWGQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 18:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231321AbiHDWGQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 18:06:16 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E57626118
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 15:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659650774; x=1691186774;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=o/vxs79V2CiMB+3Hq98IMUcUWJ3HDEAbfKsg6Dsi8P4=;
  b=QwIBDhMTFkTKpz+ssyNSoIEjdywa/CoDHxcY34wzu8s9U53sSVokLyxC
   F6Exounc3P76xIFv1F7kjbQXFteNFX9RFkUDLuMftVPrMHzMvEwomPQwE
   JmYvBfjgUf/efsXP1gERKY7UZohbpB33YUKD0J433JywPOiso+pUmbbZt
   C4fbG+1aR4pVBiQ+0hEhruvgA5LQvJVAQQkMWIE4LiRLWyUSrDO1rIbAW
   KNjUYyT5eFIfe1t+gdavfzEZM1kQ+PRiWCJwjXCg0PMTIc28TrCzRIiRM
   8X9buW1DxhEvIE46y3QZ6NPMPdZmTgSFchJXtfZwH4BqGOJhCj/ieVUng
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10429"; a="291275950"
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="291275950"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 15:06:02 -0700
X-IronPort-AV: E=Sophos;i="5.93,216,1654585200"; 
   d="scan'208";a="706365363"
Received: from jekeller-desk.amr.corp.intel.com (HELO jekeller-desk.jekeller.internal) ([10.166.241.7])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2022 15:06:02 -0700
From:   Jacob Keller <jacob.e.keller@intel.com>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Duncan Roe <duncan_roe@optusnet.com.au>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH libmnl] libmnl: add support for signed types
Date:   Thu,  4 Aug 2022 15:05:55 -0700
Message-Id: <20220804220555.2681949-1-jacob.e.keller@intel.com>
X-Mailer: git-send-email 2.37.1.208.ge72d93e88cb2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

libmnl has get and put functions for unsigned integer types. It lacks
support for the signed variations. On some level this is technically
sufficient. A user could use the unsigned variations and then cast to a
signed value at use. However, this makes resulting code in the application
more difficult to follow. Introduce signed variations of the integer get
and put functions.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
---
 include/libmnl/libmnl.h |  16 ++++
 src/attr.c              | 194 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 210 insertions(+)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 4bd0b92e8742..6c37cd532a3d 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -92,6 +92,10 @@ extern uint8_t mnl_attr_get_u8(const struct nlattr *attr);
 extern uint16_t mnl_attr_get_u16(const struct nlattr *attr);
 extern uint32_t mnl_attr_get_u32(const struct nlattr *attr);
 extern uint64_t mnl_attr_get_u64(const struct nlattr *attr);
+extern int8_t mnl_attr_get_s8(const struct nlattr *attr);
+extern int16_t mnl_attr_get_s16(const struct nlattr *attr);
+extern int32_t mnl_attr_get_s32(const struct nlattr *attr);
+extern int64_t mnl_attr_get_s64(const struct nlattr *attr);
 extern const char *mnl_attr_get_str(const struct nlattr *attr);
 
 /* TLV attribute putters */
@@ -100,6 +104,10 @@ extern void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data);
 extern void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data);
 extern void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data);
 extern void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data);
+extern void mnl_attr_put_s8(struct nlmsghdr *nlh, uint16_t type, int8_t data);
+extern void mnl_attr_put_s16(struct nlmsghdr *nlh, uint16_t type, int16_t data);
+extern void mnl_attr_put_s32(struct nlmsghdr *nlh, uint16_t type, int32_t data);
+extern void mnl_attr_put_s64(struct nlmsghdr *nlh, uint16_t type, int64_t data);
 extern void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data);
 extern void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data);
 
@@ -109,6 +117,10 @@ extern bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen, uint16_t
 extern bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, uint16_t data);
 extern bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, uint32_t data);
 extern bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, uint64_t data);
+extern bool mnl_attr_put_s8_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, int8_t data);
+extern bool mnl_attr_put_s16_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, int16_t data);
+extern bool mnl_attr_put_s32_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, int32_t data);
+extern bool mnl_attr_put_s64_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, int64_t data);
 extern bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, const char *data);
 extern bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type, const char *data);
 
@@ -127,6 +139,10 @@ enum mnl_attr_data_type {
 	MNL_TYPE_U16,
 	MNL_TYPE_U32,
 	MNL_TYPE_U64,
+	MNL_TYPE_S8,
+	MNL_TYPE_S16,
+	MNL_TYPE_S32,
+	MNL_TYPE_S64,
 	MNL_TYPE_STRING,
 	MNL_TYPE_FLAG,
 	MNL_TYPE_MSECS,
diff --git a/src/attr.c b/src/attr.c
index 838eab063981..cf971d6ed3c1 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -192,6 +192,10 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
 	[MNL_TYPE_U16]		= sizeof(uint16_t),
 	[MNL_TYPE_U32]		= sizeof(uint32_t),
 	[MNL_TYPE_U64]		= sizeof(uint64_t),
+	[MNL_TYPE_S8]		= sizeof(int8_t),
+	[MNL_TYPE_S16]		= sizeof(int16_t),
+	[MNL_TYPE_S32]		= sizeof(int32_t),
+	[MNL_TYPE_S64]		= sizeof(int64_t),
 	[MNL_TYPE_MSECS]	= sizeof(uint64_t),
 };
 
@@ -371,6 +375,54 @@ EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 	return tmp;
 }
 
+/**
+ * mnl_attr_get_s8 - returns 8-bit signed integer attribute payload
+ * \param attr pointer to netlink attribute
+ *
+ * This function returns the 8-bit value of the attribute payload.
+ */
+EXPORT_SYMBOL int8_t mnl_attr_get_s8(const struct nlattr *attr)
+{
+	return *((int8_t *)mnl_attr_get_payload(attr));
+}
+
+/**
+ * mnl_attr_get_s16 - returns 16-bit signed integer attribute payload
+ * \param attr pointer to netlink attribute
+ *
+ * This function returns the 16-bit value of the attribute payload.
+ */
+EXPORT_SYMBOL int16_t mnl_attr_get_s16(const struct nlattr *attr)
+{
+	return *((int16_t *)mnl_attr_get_payload(attr));
+}
+
+/**
+ * mnl_attr_get_s32 - returns 32-bit signed integer attribute payload
+ * \param attr pointer to netlink attribute
+ *
+ * This function returns the 32-bit value of the attribute payload.
+ */
+EXPORT_SYMBOL int32_t mnl_attr_get_s32(const struct nlattr *attr)
+{
+	return *((int32_t *)mnl_attr_get_payload(attr));
+}
+
+/**
+ * mnl_attr_get_s64 - returns 64-bit signed integer attribute.
+ * \param attr pointer to netlink attribute
+ *
+ * This function returns the 64-bit value of the attribute payload. This
+ * function is align-safe, since accessing 64-bit Netlink attributes is a
+ * common source of alignment issues.
+ */
+EXPORT_SYMBOL int64_t mnl_attr_get_s64(const struct nlattr *attr)
+{
+	int64_t tmp;
+	memcpy(&tmp, mnl_attr_get_payload(attr), sizeof(tmp));
+	return tmp;
+}
+
 /**
  * mnl_attr_get_str - returns pointer to string attribute.
  * \param attr pointer to netlink attribute
@@ -469,6 +521,66 @@ EXPORT_SYMBOL void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type,
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
 }
 
+/**
+ * mnl_attr_put_s8 - add 8-bit signed integer attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param type netlink attribute type
+ * \param data 8-bit signed integer data that is stored by the new attribute
+ *
+ * This function updates the length field of the Netlink message (nlmsg_len)
+ * by adding the size (header + payload) of the new attribute.
+ */
+EXPORT_SYMBOL void mnl_attr_put_s8(struct nlmsghdr *nlh, uint16_t type,
+				   int8_t data)
+{
+	mnl_attr_put(nlh, type, sizeof(int8_t), &data);
+}
+
+/**
+ * mnl_attr_put_s16 - add 16-bit signed integer attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param type netlink attribute type
+ * \param data 16-bit signed integer data that is stored by the new attribute
+ *
+ * This function updates the length field of the Netlink message (nlmsg_len)
+ * by adding the size (header + payload) of the new attribute.
+ */
+EXPORT_SYMBOL void mnl_attr_put_s16(struct nlmsghdr *nlh, uint16_t type,
+				    int16_t data)
+{
+	mnl_attr_put(nlh, type, sizeof(int16_t), &data);
+}
+
+/**
+ * mnl_attr_put_s32 - add 32-bit signed integer attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param type netlink attribute type
+ * \param data 32-bit signed integer data that is stored by the new attribute
+ *
+ * This function updates the length field of the Netlink message (nlmsg_len)
+ * by adding the size (header + payload) of the new attribute.
+ */
+EXPORT_SYMBOL void mnl_attr_put_s32(struct nlmsghdr *nlh, uint16_t type,
+				    int32_t data)
+{
+	mnl_attr_put(nlh, type, sizeof(int32_t), &data);
+}
+
+/**
+ * mnl_attr_put_s64 - add 64-bit signed integer attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param type netlink attribute type
+ * \param data 64-bit signed integer data that is stored by the new attribute
+ *
+ * This function updates the length field of the Netlink message (nlmsg_len)
+ * by adding the size (header + payload) of the new attribute.
+ */
+EXPORT_SYMBOL void mnl_attr_put_s64(struct nlmsghdr *nlh, uint16_t type,
+				    int64_t data)
+{
+	mnl_attr_put(nlh, type, sizeof(int64_t), &data);
+}
+
 /**
  * mnl_attr_put_str - add string attribute to netlink message
  * \param nlh  pointer to the netlink message
@@ -629,6 +741,88 @@ EXPORT_SYMBOL bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint64_t), &data);
 }
 
+/**
+ * mnl_attr_put_s8_check - add 8-bit signed int attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param buflen size of buffer which stores the message
+ * \param type netlink attribute type
+ * \param data 8-bit signed integer data that is stored by the new attribute
+ *
+ * This function first checks that the data can be added to the message
+ * (fits into the buffer) and then updates the length field of the Netlink
+ * message (nlmsg_len) by adding the size (header + payload) of the new
+ * attribute. The function returns true if the attribute could be added
+ * to the message, otherwise false is returned.
+ */
+EXPORT_SYMBOL bool mnl_attr_put_s8_check(struct nlmsghdr *nlh, size_t buflen,
+					 uint16_t type, int8_t data)
+{
+	return mnl_attr_put_check(nlh, buflen, type, sizeof(data), &data);
+}
+
+/**
+ * mnl_attr_put_s16_check - add 16-bit signed int attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param buflen size of buffer which stores the message
+ * \param type netlink attribute type
+ * \param data 16-bit signed integer data that is stored by the new attribute
+ *
+ * This function first checks that the data can be added to the message
+ * (fits into the buffer) and then updates the length field of the Netlink
+ * message (nlmsg_len) by adding the size (header + payload) of the new
+ * attribute. The function returns true if the attribute could be added
+ * to the message, otherwise false is returned.
+ * This function updates the length field of the Netlink message (nlmsg_len)
+ * by adding the size (header + payload) of the new attribute.
+ */
+EXPORT_SYMBOL bool mnl_attr_put_s16_check(struct nlmsghdr *nlh, size_t buflen,
+					  uint16_t type, int16_t data)
+{
+	return mnl_attr_put_check(nlh, buflen, type, sizeof(data), &data);
+}
+
+/**
+ * mnl_attr_put_s32_check - add 32-bit signed int attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param buflen size of buffer which stores the message
+ * \param type netlink attribute type
+ * \param data 32-bit signed integer data that is stored by the new attribute
+ *
+ * This function first checks that the data can be added to the message
+ * (fits into the buffer) and then updates the length field of the Netlink
+ * message (nlmsg_len) by adding the size (header + payload) of the new
+ * attribute. The function returns true if the attribute could be added
+ * to the message, otherwise false is returned.
+ * This function updates the length field of the Netlink message (nlmsg_len)
+ * by adding the size (header + payload) of the new attribute.
+ */
+EXPORT_SYMBOL bool mnl_attr_put_s32_check(struct nlmsghdr *nlh, size_t buflen,
+					  uint16_t type, int32_t data)
+{
+	return mnl_attr_put_check(nlh, buflen, type, sizeof(data), &data);
+}
+
+/**
+ * mnl_attr_put_s64_check - add 64-bit signed int attribute to netlink message
+ * \param nlh pointer to the netlink message
+ * \param buflen size of buffer which stores the message
+ * \param type netlink attribute type
+ * \param data 64-bit signed integer data that is stored by the new attribute
+ *
+ * This function first checks that the data can be added to the message
+ * (fits into the buffer) and then updates the length field of the Netlink
+ * message (nlmsg_len) by adding the size (header + payload) of the new
+ * attribute. The function returns true if the attribute could be added
+ * to the message, otherwise false is returned.
+ * This function updates the length field of the Netlink message (nlmsg_len)
+ * by adding the size (header + payload) of the new attribute.
+ */
+EXPORT_SYMBOL bool mnl_attr_put_s64_check(struct nlmsghdr *nlh, size_t buflen,
+					  uint16_t type, int64_t data)
+{
+	return mnl_attr_put_check(nlh, buflen, type, sizeof(data), &data);
+}
+
 /**
  * mnl_attr_put_str_check - add string attribute to netlink message
  * \param nlh  pointer to the netlink message
-- 
2.37.1.208.ge72d93e88cb2

