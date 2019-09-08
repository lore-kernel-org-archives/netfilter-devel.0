Return-Path: <SRS0=xcdV=XD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B1A0C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 08:25:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8690206CD
	for <netfilter-devel@archiver.kernel.org>; Sun,  8 Sep 2019 08:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727168AbfIHIZf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 8 Sep 2019 04:25:35 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:43164 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726267AbfIHIZf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 8 Sep 2019 04:25:35 -0400
Received: from dimstar.local.net (unknown [49.176.30.160])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id 9B08F36108D
        for <netfilter-devel@vger.kernel.org>; Sun,  8 Sep 2019 18:25:06 +1000 (AEST)
Received: (qmail 3363 invoked by uid 501); 8 Sep 2019 08:25:05 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] src: Enable doxygen to generate Function Documentation
Date:   Sun,  8 Sep 2019 18:25:05 +1000
Message-Id: <20190908082505.3320-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=Z9xClQWs/QXK5X6ealIiYw==:117 a=Z9xClQWs/QXK5X6ealIiYw==:17
        a=J70Eh1EUuV4A:10 a=PO7r1zJSAAAA:8 a=96DeEFiCC475VYE6eRYA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19 a=RVphnnFC9Wx2EZeD:21
        a=IXcvFI7VXHIvl-w3:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The C source files all contain doxygen documentation for each defined function
but this was not appearing in the generated HTML.
Fix is to move all EXPORT_SYMBOL macro calls to after the function definition.
Doxygen seems to otherwise forget the documentation on encountering
EXPORT_SYMBOL which is flagged in the EXCLUDE_SYMBOLS tag in doxygen.cfg.in.
I encountered this "feature" in doxygen 1.8.9.1 but it still appears to be
present in 1.8.16

Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
---
 src/attr.c     | 70 +++++++++++++++++++++++++++++-----------------------------
 src/callback.c |  4 ++--
 src/nlmsg.c    | 40 ++++++++++++++++-----------------
 src/socket.c   | 22 +++++++++---------
 4 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 0359ba9..ca42d3e 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -35,11 +35,11 @@
  *
  * This function returns the attribute type.
  */
-EXPORT_SYMBOL(mnl_attr_get_type);
 uint16_t mnl_attr_get_type(const struct nlattr *attr)
 {
 	return attr->nla_type & NLA_TYPE_MASK;
 }
+EXPORT_SYMBOL(mnl_attr_get_type);
 
 /**
  * mnl_attr_get_len - get length of netlink attribute
@@ -48,11 +48,11 @@ uint16_t mnl_attr_get_type(const struct nlattr *attr)
  * This function returns the attribute length that is the attribute header
  * plus the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_len);
 uint16_t mnl_attr_get_len(const struct nlattr *attr)
 {
 	return attr->nla_len;
 }
+EXPORT_SYMBOL(mnl_attr_get_len);
 
 /**
  * mnl_attr_get_payload_len - get the attribute payload-value length
@@ -60,11 +60,11 @@ uint16_t mnl_attr_get_len(const struct nlattr *attr)
  *
  * This function returns the attribute payload-value length.
  */
-EXPORT_SYMBOL(mnl_attr_get_payload_len);
 uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 {
 	return attr->nla_len - MNL_ATTR_HDRLEN;
 }
+EXPORT_SYMBOL(mnl_attr_get_payload_len);
 
 /**
  * mnl_attr_get_payload - get pointer to the attribute payload
@@ -72,11 +72,11 @@ uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
  *
  * This function return a pointer to the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_payload);
 void *mnl_attr_get_payload(const struct nlattr *attr)
 {
 	return (void *)attr + MNL_ATTR_HDRLEN;
 }
+EXPORT_SYMBOL(mnl_attr_get_payload);
 
 /**
  * mnl_attr_ok - check if there is room for an attribute in a buffer
@@ -94,13 +94,13 @@ void *mnl_attr_get_payload(const struct nlattr *attr)
  * The len parameter may be negative in the case of malformed messages during
  * attribute iteration, that is why we use a signed integer.
  */
-EXPORT_SYMBOL(mnl_attr_ok);
 bool mnl_attr_ok(const struct nlattr *attr, int len)
 {
 	return len >= (int)sizeof(struct nlattr) &&
 	       attr->nla_len >= sizeof(struct nlattr) &&
 	       (int)attr->nla_len <= len;
 }
+EXPORT_SYMBOL(mnl_attr_ok);
 
 /**
  * mnl_attr_next - get the next attribute in the payload of a netlink message
@@ -110,11 +110,11 @@ bool mnl_attr_ok(const struct nlattr *attr, int len)
  * as parameter. You have to use mnl_attr_ok() to ensure that the next
  * attribute is valid.
  */
-EXPORT_SYMBOL(mnl_attr_next);
 struct nlattr *mnl_attr_next(const struct nlattr *attr)
 {
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
 }
+EXPORT_SYMBOL(mnl_attr_next);
 
 /**
  * mnl_attr_type_valid - check if the attribute type is valid
@@ -130,7 +130,6 @@ struct nlattr *mnl_attr_next(const struct nlattr *attr)
  * This leads to backward compatibility breakages in user-space. Better check
  * if you support an attribute, if not, skip it.
  */
-EXPORT_SYMBOL(mnl_attr_type_valid);
 int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 {
 	if (mnl_attr_get_type(attr) > max) {
@@ -139,6 +138,7 @@ int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 	}
 	return 1;
 }
+EXPORT_SYMBOL(mnl_attr_type_valid);
 
 static int __mnl_attr_validate(const struct nlattr *attr,
 			       enum mnl_attr_data_type type, size_t exp_len)
@@ -211,7 +211,6 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
  * integers (u8, u16, u32 and u64) have enough room for them. This function
  * returns -1 in case of error, and errno is explicitly set.
  */
-EXPORT_SYMBOL(mnl_attr_validate);
 int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 {
 	int exp_len;
@@ -223,6 +222,7 @@ int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 	exp_len = mnl_attr_data_type_len[type];
 	return __mnl_attr_validate(attr, type, exp_len);
 }
+EXPORT_SYMBOL(mnl_attr_validate);
 
 /**
  * mnl_attr_validate2 - validate netlink attribute (extended version)
@@ -234,7 +234,6 @@ int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
  * whose size is variable. If the size of the attribute is not what we expect,
  * this functions returns -1 and errno is explicitly set.
  */
-EXPORT_SYMBOL(mnl_attr_validate2);
 int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
 		       size_t exp_len)
 {
@@ -244,6 +243,7 @@ int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
 	}
 	return __mnl_attr_validate(attr, type, exp_len);
 }
+EXPORT_SYMBOL(mnl_attr_validate2);
 
 /**
  * mnl_attr_parse - parse attributes
@@ -260,7 +260,6 @@ int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse);
 int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 		   mnl_attr_cb_t cb, void *data)
 {
@@ -272,6 +271,7 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 			return ret;
 	return ret;
 }
+EXPORT_SYMBOL(mnl_attr_parse);
 
 /**
  * mnl_attr_parse_nested - parse attributes inside a nest
@@ -287,7 +287,6 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse_nested);
 int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
 			  void *data)
 {
@@ -299,6 +298,7 @@ int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
 			return ret;
 	return ret;
 }
+EXPORT_SYMBOL(mnl_attr_parse_nested);
 
 /**
  * mnl_attr_parse_payload - parse attributes in payload of Netlink message
@@ -319,7 +319,6 @@ int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse_payload);
 int mnl_attr_parse_payload(const void *payload, size_t payload_len,
 			   mnl_attr_cb_t cb, void *data)
 {
@@ -331,6 +330,7 @@ int mnl_attr_parse_payload(const void *payload, size_t payload_len,
 			return ret;
 	return ret;
 }
+EXPORT_SYMBOL(mnl_attr_parse_payload);
 
 /**
  * mnl_attr_get_u8 - returns 8-bit unsigned integer attribute payload
@@ -338,11 +338,11 @@ int mnl_attr_parse_payload(const void *payload, size_t payload_len,
  *
  * This function returns the 8-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u8);
 uint8_t mnl_attr_get_u8(const struct nlattr *attr)
 {
 	return *((uint8_t *)mnl_attr_get_payload(attr));
 }
+EXPORT_SYMBOL(mnl_attr_get_u8);
 
 /**
  * mnl_attr_get_u16 - returns 16-bit unsigned integer attribute payload
@@ -350,11 +350,11 @@ uint8_t mnl_attr_get_u8(const struct nlattr *attr)
  *
  * This function returns the 16-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u16);
 uint16_t mnl_attr_get_u16(const struct nlattr *attr)
 {
 	return *((uint16_t *)mnl_attr_get_payload(attr));
 }
+EXPORT_SYMBOL(mnl_attr_get_u16);
 
 /**
  * mnl_attr_get_u32 - returns 32-bit unsigned integer attribute payload
@@ -362,11 +362,11 @@ uint16_t mnl_attr_get_u16(const struct nlattr *attr)
  *
  * This function returns the 32-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u32);
 uint32_t mnl_attr_get_u32(const struct nlattr *attr)
 {
 	return *((uint32_t *)mnl_attr_get_payload(attr));
 }
+EXPORT_SYMBOL(mnl_attr_get_u32);
 
 /**
  * mnl_attr_get_u64 - returns 64-bit unsigned integer attribute.
@@ -376,13 +376,13 @@ uint32_t mnl_attr_get_u32(const struct nlattr *attr)
  * function is align-safe, since accessing 64-bit Netlink attributes is a
  * common source of alignment issues.
  */
-EXPORT_SYMBOL(mnl_attr_get_u64);
 uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 {
 	uint64_t tmp;
 	memcpy(&tmp, mnl_attr_get_payload(attr), sizeof(tmp));
 	return tmp;
 }
+EXPORT_SYMBOL(mnl_attr_get_u64);
 
 /**
  * mnl_attr_get_str - returns pointer to string attribute.
@@ -390,11 +390,11 @@ uint64_t mnl_attr_get_u64(const struct nlattr *attr)
  *
  * This function returns the payload of string attribute value.
  */
-EXPORT_SYMBOL(mnl_attr_get_str);
 const char *mnl_attr_get_str(const struct nlattr *attr)
 {
 	return mnl_attr_get_payload(attr);
 }
+EXPORT_SYMBOL(mnl_attr_get_str);
 
 /**
  * mnl_attr_put - add an attribute to netlink message
@@ -406,7 +406,6 @@ const char *mnl_attr_get_str(const struct nlattr *attr)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put);
 void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
 		  const void *data)
 {
@@ -423,6 +422,7 @@ void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
 
 	nlh->nlmsg_len += MNL_ALIGN(payload_len);
 }
+EXPORT_SYMBOL(mnl_attr_put);
 
 /**
  * mnl_attr_put_u8 - add 8-bit unsigned integer attribute to netlink message
@@ -433,11 +433,11 @@ void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u8);
 void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint8_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u8);
 
 /**
  * mnl_attr_put_u16 - add 16-bit unsigned integer attribute to netlink message
@@ -448,11 +448,11 @@ void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u16);
 void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint16_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u16);
 
 /**
  * mnl_attr_put_u32 - add 32-bit unsigned integer attribute to netlink message
@@ -463,11 +463,11 @@ void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u32);
 void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint32_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u32);
 
 /**
  * mnl_attr_put_u64 - add 64-bit unsigned integer attribute to netlink message
@@ -478,11 +478,11 @@ void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u64);
 void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u64);
 
 /**
  * mnl_attr_put_str - add string attribute to netlink message
@@ -493,11 +493,11 @@ void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_str);
 void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
 }
+EXPORT_SYMBOL(mnl_attr_put_str);
 
 /**
  * mnl_attr_put_strz - add string attribute to netlink message
@@ -511,11 +511,11 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_strz);
 void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
+EXPORT_SYMBOL(mnl_attr_put_strz);
 
 /**
  * mnl_attr_nest_start - start an attribute nest
@@ -526,7 +526,6 @@ void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * an attribute nest. This function always returns a valid pointer to the
  * beginning of the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_start);
 struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
 {
 	struct nlattr *start = mnl_nlmsg_get_payload_tail(nlh);
@@ -537,6 +536,7 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
 
 	return start;
 }
+EXPORT_SYMBOL(mnl_attr_nest_start);
 
 /**
  * mnl_attr_put_check - add an attribute to netlink message
@@ -552,7 +552,6 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_check);
 bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
 			uint16_t type, size_t len, const void *data)
 {
@@ -561,6 +560,7 @@ bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
 	mnl_attr_put(nlh, type, len, data);
 	return true;
 }
+EXPORT_SYMBOL(mnl_attr_put_check);
 
 /**
  * mnl_attr_put_u8_check - add 8-bit unsigned int attribute to netlink message
@@ -575,12 +575,12 @@ bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_u8_check);
 bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
 			   uint16_t type, uint8_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint8_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u8_check);
 
 /**
  * mnl_attr_put_u16_check - add 16-bit unsigned int attribute to netlink message
@@ -597,12 +597,12 @@ bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u16_check);
 bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, uint16_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint16_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u16_check);
 
 /**
  * mnl_attr_put_u32_check - add 32-bit unsigned int attribute to netlink message
@@ -619,12 +619,12 @@ bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u32_check);
 bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, uint32_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint32_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u32_check);
 
 /**
  * mnl_attr_put_u64_check - add 64-bit unsigned int attribute to netlink message
@@ -641,12 +641,12 @@ bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u64_check);
 bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, uint64_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint64_t), &data);
 }
+EXPORT_SYMBOL(mnl_attr_put_u64_check);
 
 /**
  * mnl_attr_put_str_check - add string attribute to netlink message
@@ -663,12 +663,12 @@ bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_str_check);
 bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data), data);
 }
+EXPORT_SYMBOL(mnl_attr_put_str_check);
 
 /**
  * mnl_attr_put_strz_check - add string attribute to netlink message
@@ -686,12 +686,12 @@ bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_strz_check);
 bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
 			     uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data)+1, data);
 }
+EXPORT_SYMBOL(mnl_attr_put_strz_check);
 
 /**
  * mnl_attr_nest_start_check - start an attribute nest
@@ -703,7 +703,6 @@ bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
  * an attribute nest. If the nested attribute cannot be added then NULL,
  * otherwise valid pointer to the beginning of the nest is returned.
  */
-EXPORT_SYMBOL(mnl_attr_nest_start_check);
 struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
 					 uint16_t type)
 {
@@ -711,6 +710,7 @@ struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
 		return NULL;
 	return mnl_attr_nest_start(nlh, type);
 }
+EXPORT_SYMBOL(mnl_attr_nest_start_check);
 
 /**
  * mnl_attr_nest_end - end an attribute nest
@@ -719,11 +719,11 @@ struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
  *
  * This function updates the attribute header that identifies the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_end);
 void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	start->nla_len = mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
+EXPORT_SYMBOL(mnl_attr_nest_end);
 
 /**
  * mnl_attr_nest_cancel - cancel an attribute nest
@@ -732,11 +732,11 @@ void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
  *
  * This function updates the attribute header that identifies the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_cancel);
 void mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	nlh->nlmsg_len -= mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
+EXPORT_SYMBOL(mnl_attr_nest_cancel);
 
 /**
  * @}
diff --git a/src/callback.c b/src/callback.c
index 01181e6..9ae54d7 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -127,7 +127,6 @@ out:
  * to EPROTO. If the dump was interrupted, errno is set to EINTR and you should
  * request a new fresh dump again.
  */
-EXPORT_SYMBOL(mnl_cb_run2);
 int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 		unsigned int portid, mnl_cb_t cb_data, void *data,
 		const mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
@@ -135,6 +134,7 @@ int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data,
 			    cb_ctl_array, cb_ctl_array_len);
 }
+EXPORT_SYMBOL(mnl_cb_run2);
 
 /**
  * mnl_cb_run - callback runqueue for netlink messages (simplified version)
@@ -155,12 +155,12 @@ int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
  *
  * This function propagates the callback return value.
  */
-EXPORT_SYMBOL(mnl_cb_run);
 int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
 	       unsigned int portid, mnl_cb_t cb_data, void *data)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
 }
+EXPORT_SYMBOL(mnl_cb_run);
 
 /**
  * @}
diff --git a/src/nlmsg.c b/src/nlmsg.c
index f9448a5..9051bbb 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -51,11 +51,11 @@
  * This function returns the size of a netlink message (header plus payload)
  * without alignment.
  */
-EXPORT_SYMBOL(mnl_nlmsg_size);
 size_t mnl_nlmsg_size(size_t len)
 {
 	return len + MNL_NLMSG_HDRLEN;
 }
+EXPORT_SYMBOL(mnl_nlmsg_size);
 
 /**
  * mnl_nlmsg_get_payload_len - get the length of the Netlink payload
@@ -64,11 +64,11 @@ size_t mnl_nlmsg_size(size_t len)
  * This function returns the Length of the netlink payload, ie. the length
  * of the full message minus the size of the Netlink header.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
 size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
 {
 	return nlh->nlmsg_len - MNL_NLMSG_HDRLEN;
 }
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
 
 /**
  * mnl_nlmsg_put_header - reserve and prepare room for Netlink header
@@ -79,7 +79,6 @@ size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
  * initializes the nlmsg_len field to the size of the Netlink header. This
  * function returns a pointer to the Netlink header structure.
  */
-EXPORT_SYMBOL(mnl_nlmsg_put_header);
 struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 {
 	int len = MNL_ALIGN(sizeof(struct nlmsghdr));
@@ -89,6 +88,7 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 	nlh->nlmsg_len = len;
 	return nlh;
 }
+EXPORT_SYMBOL(mnl_nlmsg_put_header);
 
 /**
  * mnl_nlmsg_put_extra_header - reserve and prepare room for an extra header
@@ -101,7 +101,6 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
  * you call this function. This function returns a pointer to the extra
  * header.
  */
-EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
 void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 {
 	char *ptr = (char *)nlh + nlh->nlmsg_len;
@@ -110,6 +109,7 @@ void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 	memset(ptr, 0, len);
 	return ptr;
 }
+EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
 
 /**
  * mnl_nlmsg_get_payload - get a pointer to the payload of the netlink message
@@ -117,11 +117,11 @@ void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
  *
  * This function returns a pointer to the payload of the netlink message.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload);
 void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN;
 }
+EXPORT_SYMBOL(mnl_nlmsg_get_payload);
 
 /**
  * mnl_nlmsg_get_payload_offset - get a pointer to the payload of the message
@@ -131,11 +131,11 @@ void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
  * This function returns a pointer to the payload of the netlink message plus
  * a given offset.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
 void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
 }
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
 
 /**
  * mnl_nlmsg_ok - check a there is room for netlink message
@@ -153,13 +153,13 @@ void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
  * The len parameter may become negative in malformed messages during message
  * iteration, that is why we use a signed integer.
  */
-EXPORT_SYMBOL(mnl_nlmsg_ok);
 bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
 	return len >= (int)sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >= sizeof(struct nlmsghdr) &&
 	       (int)nlh->nlmsg_len <= len;
 }
+EXPORT_SYMBOL(mnl_nlmsg_ok);
 
 /**
  * mnl_nlmsg_next - get the next netlink message in a multipart message
@@ -174,12 +174,12 @@ bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
  * You have to use mnl_nlmsg_ok() to check if the next Netlink message is
  * valid.
  */
-EXPORT_SYMBOL(mnl_nlmsg_next);
 struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
 {
 	*len -= MNL_ALIGN(nlh->nlmsg_len);
 	return (struct nlmsghdr *)((void *)nlh + MNL_ALIGN(nlh->nlmsg_len));
 }
+EXPORT_SYMBOL(mnl_nlmsg_next);
 
 /**
  * mnl_nlmsg_get_payload_tail - get the ending of the netlink message
@@ -189,11 +189,11 @@ struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
  * to build a message since we continue adding attributes at the end of the
  * message.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
 void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_ALIGN(nlh->nlmsg_len);
 }
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
 
 /**
  * mnl_nlmsg_seq_ok - perform sequence tracking
@@ -209,11 +209,11 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
  * socket to send commands to kernel-space (that we want to track) and to
  * listen to events (that we do not track).
  */
-EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
 bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : true;
 }
+EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
 
 /**
  * mnl_nlmsg_portid_ok - perform portID origin check
@@ -229,11 +229,11 @@ bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * to kernel-space (that we want to track) and to listen to events (that we
  * do not track).
  */
-EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
 bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : true;
 }
+EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
 
 static void mnl_nlmsg_fprintf_header(FILE *fd, const struct nlmsghdr *nlh)
 {
@@ -363,7 +363,6 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
  * - N, that indicates that NLA_F_NESTED is set.
  * - B, that indicates that NLA_F_NET_BYTEORDER is set.
  */
-EXPORT_SYMBOL(mnl_nlmsg_fprintf);
 void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
 		       size_t extra_header_size)
 {
@@ -376,6 +375,7 @@ void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
 		nlh = mnl_nlmsg_next(nlh, &len);
 	}
 }
+EXPORT_SYMBOL(mnl_nlmsg_fprintf);
 
 /**
  * \defgroup batch Netlink message batch helpers
@@ -433,7 +433,6 @@ struct mnl_nlmsg_batch {
  * the heap, no restrictions in this regard. This function returns NULL on
  * error.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_start);
 struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
 {
 	struct mnl_nlmsg_batch *b;
@@ -450,6 +449,7 @@ struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
 
 	return b;
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_start);
 
 /**
  * mnl_nlmsg_batch_stop - release a batch
@@ -457,11 +457,11 @@ struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
  *
  * This function releases the batch allocated by mnl_nlmsg_batch_start().
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
 void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
 {
 	free(b);
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
 
 /**
  * mnl_nlmsg_batch_next - get room for the next message in the batch
@@ -474,7 +474,6 @@ void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
  * You have to put at least one message in the batch before calling this
  * function, otherwise your application is likely to crash.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_next);
 bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 {
 	struct nlmsghdr *nlh = b->cur;
@@ -487,6 +486,7 @@ bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 	b->buflen += nlh->nlmsg_len;
 	return true;
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_next);
 
 /**
  * mnl_nlmsg_batch_reset - reset the batch
@@ -496,7 +496,6 @@ bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
  * new one. This function moves the last message which does not fit the
  * batch to the head of the buffer, if any.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
 void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 {
 	if (b->overflow) {
@@ -510,6 +509,7 @@ void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 		b->cur = b->buf;
 	}
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
 
 /**
  * mnl_nlmsg_batch_size - get current size of the batch
@@ -517,11 +517,11 @@ void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
  *
  * This function returns the current size of the batch.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_size);
 size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen;
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_size);
 
 /**
  * mnl_nlmsg_batch_head - get head of this batch
@@ -530,11 +530,11 @@ size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
  * This function returns a pointer to the head of the batch, which is the
  * beginning of the buffer that is used.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_head);
 void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
 {
 	return b->buf;
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_head);
 
 /**
  * mnl_nlmsg_batch_current - returns current position in the batch
@@ -543,11 +543,11 @@ void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
  * This function returns a pointer to the current position in the buffer
  * that is used to store the batch.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_current);
 void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
 {
 	return b->cur;
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_current);
 
 /**
  * mnl_nlmsg_batch_is_empty - check if there is any message in the batch
@@ -555,11 +555,11 @@ void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
  *
  * This function returns true if the batch is empty.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
 bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen == 0;
 }
+EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
 
 /**
  * @}
diff --git a/src/socket.c b/src/socket.c
index 31d6fbe..5715084 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -82,11 +82,11 @@ struct mnl_socket {
  *
  * This function returns the file descriptor of a given netlink socket.
  */
-EXPORT_SYMBOL(mnl_socket_get_fd);
 int mnl_socket_get_fd(const struct mnl_socket *nl)
 {
 	return nl->fd;
 }
+EXPORT_SYMBOL(mnl_socket_get_fd);
 
 /**
  * mnl_socket_get_portid - obtain Netlink PortID from netlink socket
@@ -97,11 +97,11 @@ int mnl_socket_get_fd(const struct mnl_socket *nl)
  * which is not always true. This is the case if you open more than one
  * socket that is binded to the same Netlink subsystem from the same process.
  */
-EXPORT_SYMBOL(mnl_socket_get_portid);
 unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
 {
 	return nl->addr.nl_pid;
 }
+EXPORT_SYMBOL(mnl_socket_get_portid);
 
 static struct mnl_socket *__mnl_socket_open(int bus, int flags)
 {
@@ -127,11 +127,11 @@ static struct mnl_socket *__mnl_socket_open(int bus, int flags)
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-EXPORT_SYMBOL(mnl_socket_open);
 struct mnl_socket *mnl_socket_open(int bus)
 {
 	return __mnl_socket_open(bus, 0);
 }
+EXPORT_SYMBOL(mnl_socket_open);
 
 /**
  * mnl_socket_open2 - open a netlink socket with appropriate flags
@@ -145,11 +145,11 @@ struct mnl_socket *mnl_socket_open(int bus)
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-EXPORT_SYMBOL(mnl_socket_open2);
 struct mnl_socket *mnl_socket_open2(int bus, int flags)
 {
 	return __mnl_socket_open(bus, flags);
 }
+EXPORT_SYMBOL(mnl_socket_open2);
 
 /**
  * mnl_socket_fdopen - associates a mnl_socket object with pre-existing socket.
@@ -162,7 +162,6 @@ struct mnl_socket *mnl_socket_open2(int bus, int flags)
  * Note that mnl_socket_get_portid() returns 0 if this function is used with
  * non-netlink socket.
  */
-EXPORT_SYMBOL(mnl_socket_fdopen);
 struct mnl_socket *mnl_socket_fdopen(int fd)
 {
 	int ret;
@@ -184,6 +183,7 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
 
 	return nl;
 }
+EXPORT_SYMBOL(mnl_socket_fdopen);
 
 /**
  * mnl_socket_bind - bind netlink socket
@@ -195,7 +195,6 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
  * success, 0 is returned. You can use MNL_SOCKET_AUTOPID which is 0 for
  * automatic port ID selection.
  */
-EXPORT_SYMBOL(mnl_socket_bind);
 int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 {
 	int ret;
@@ -224,6 +223,7 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 	}
 	return 0;
 }
+EXPORT_SYMBOL(mnl_socket_bind);
 
 /**
  * mnl_socket_sendto - send a netlink message of a certain size
@@ -234,7 +234,6 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
  * On error, it returns -1 and errno is appropriately set. Otherwise, it 
  * returns the number of bytes sent.
  */
-EXPORT_SYMBOL(mnl_socket_sendto);
 ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
 			  size_t len)
 {
@@ -244,6 +243,7 @@ ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
 	return sendto(nl->fd, buf, len, 0, 
 		      (struct sockaddr *) &snl, sizeof(snl));
 }
+EXPORT_SYMBOL(mnl_socket_sendto);
 
 /**
  * mnl_socket_recvfrom - receive a netlink message
@@ -259,7 +259,6 @@ ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
  */
-EXPORT_SYMBOL(mnl_socket_recvfrom);
 ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
 			    size_t bufsiz)
 {
@@ -292,6 +291,7 @@ ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
 	}
 	return ret;
 }
+EXPORT_SYMBOL(mnl_socket_recvfrom);
 
 /**
  * mnl_socket_close - close a given netlink socket
@@ -300,13 +300,13 @@ ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
  * On error, this function returns -1 and errno is appropriately set.
  * On success, it returns 0.
  */
-EXPORT_SYMBOL(mnl_socket_close);
 int mnl_socket_close(struct mnl_socket *nl)
 {
 	int ret = close(nl->fd);
 	free(nl);
 	return ret;
 }
+EXPORT_SYMBOL(mnl_socket_close);
 
 /**
  * mnl_socket_setsockopt - set Netlink socket option
@@ -333,12 +333,12 @@ int mnl_socket_close(struct mnl_socket *nl)
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-EXPORT_SYMBOL(mnl_socket_setsockopt);
 int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
 			  void *buf, socklen_t len)
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
+EXPORT_SYMBOL(mnl_socket_setsockopt);
 
 /**
  * mnl_socket_getsockopt - get a Netlink socket option
@@ -349,12 +349,12 @@ int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-EXPORT_SYMBOL(mnl_socket_getsockopt);
 int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
 			  void *buf, socklen_t *len)
 {
 	return getsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
+EXPORT_SYMBOL(mnl_socket_getsockopt);
 
 /**
  * @}
-- 
2.14.5

