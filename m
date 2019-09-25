Return-Path: <SRS0=+tY6=XU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 682C1C4360C
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 13:14:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1690420640
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Sep 2019 13:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Z2OH5+8I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406268AbfIYNO0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Sep 2019 09:14:26 -0400
Received: from mx1.riseup.net ([198.252.153.129]:41934 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405921AbfIYNO0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Sep 2019 09:14:26 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id B3BC71A0F1E;
        Wed, 25 Sep 2019 06:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1569417264; bh=woXc8wRYCLJsAJu9CFJYwAhWjQz4SpyeNsVo7Gved08=;
        h=From:To:Cc:Subject:Date:From;
        b=Z2OH5+8IpaGQ03UfdtxUPkdiAW711L44JcsH3d5H3Gsiwculvo4Xkb634qteGH1Na
         hhcWJPh4Q85e15gwui1UpPh6FxJhYNXxWd7oeqkqdmtk73H/mSaTknwtgJpTFnKiOA
         ePtIAJ0lzRIAFa7JVqACnPS8OLC6fr5289pfyK+4=
X-Riseup-User-ID: A52DF5788CE899FF1F725538266A51908F84A214B885E8F7713D208BB1BF4196
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id AB83F2255D6;
        Wed, 25 Sep 2019 06:14:22 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: [PATCH libmnl] src: fix doxygen function documentation
Date:   Wed, 25 Sep 2019 15:14:19 +0200
Message-Id: <20190925131418.7711-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently clang requires EXPORT_SYMBOL() to be above the function
implementation. At the same time doxygen is not generating the proper
documentation because of that.

This patch solves that problem but EXPORT_SYMBOL looks less like the Linux
kernel way exporting symbols.

Reported-by: Duncan Roe <duncan_roe@optusnet.com.au>
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 src/attr.c     | 145 +++++++++++++++++++++----------------------------
 src/callback.c |  14 ++---
 src/internal.h |   3 +-
 src/nlmsg.c    |  68 +++++++++--------------
 src/socket.c   |  42 ++++++--------
 5 files changed, 113 insertions(+), 159 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 0359ba9..838eab0 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -35,8 +35,7 @@
  *
  * This function returns the attribute type.
  */
-EXPORT_SYMBOL(mnl_attr_get_type);
-uint16_t mnl_attr_get_type(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_type(const struct nlattr *attr)
 {
 	return attr->nla_type & NLA_TYPE_MASK;
 }
@@ -48,8 +47,7 @@ uint16_t mnl_attr_get_type(const struct nlattr *attr)
  * This function returns the attribute length that is the attribute header
  * plus the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_len);
-uint16_t mnl_attr_get_len(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_len(const struct nlattr *attr)
 {
 	return attr->nla_len;
 }
@@ -60,8 +58,7 @@ uint16_t mnl_attr_get_len(const struct nlattr *attr)
  *
  * This function returns the attribute payload-value length.
  */
-EXPORT_SYMBOL(mnl_attr_get_payload_len);
-uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 {
 	return attr->nla_len - MNL_ATTR_HDRLEN;
 }
@@ -72,8 +69,7 @@ uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
  *
  * This function return a pointer to the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_payload);
-void *mnl_attr_get_payload(const struct nlattr *attr)
+EXPORT_SYMBOL void *mnl_attr_get_payload(const struct nlattr *attr)
 {
 	return (void *)attr + MNL_ATTR_HDRLEN;
 }
@@ -94,8 +90,7 @@ void *mnl_attr_get_payload(const struct nlattr *attr)
  * The len parameter may be negative in the case of malformed messages during
  * attribute iteration, that is why we use a signed integer.
  */
-EXPORT_SYMBOL(mnl_attr_ok);
-bool mnl_attr_ok(const struct nlattr *attr, int len)
+EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int len)
 {
 	return len >= (int)sizeof(struct nlattr) &&
 	       attr->nla_len >= sizeof(struct nlattr) &&
@@ -110,8 +105,7 @@ bool mnl_attr_ok(const struct nlattr *attr, int len)
  * as parameter. You have to use mnl_attr_ok() to ensure that the next
  * attribute is valid.
  */
-EXPORT_SYMBOL(mnl_attr_next);
-struct nlattr *mnl_attr_next(const struct nlattr *attr)
+EXPORT_SYMBOL struct nlattr *mnl_attr_next(const struct nlattr *attr)
 {
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
 }
@@ -130,8 +124,7 @@ struct nlattr *mnl_attr_next(const struct nlattr *attr)
  * This leads to backward compatibility breakages in user-space. Better check
  * if you support an attribute, if not, skip it.
  */
-EXPORT_SYMBOL(mnl_attr_type_valid);
-int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
+EXPORT_SYMBOL int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 {
 	if (mnl_attr_get_type(attr) > max) {
 		errno = EOPNOTSUPP;
@@ -211,8 +204,7 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
  * integers (u8, u16, u32 and u64) have enough room for them. This function
  * returns -1 in case of error, and errno is explicitly set.
  */
-EXPORT_SYMBOL(mnl_attr_validate);
-int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
+EXPORT_SYMBOL int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 {
 	int exp_len;
 
@@ -234,9 +226,9 @@ int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
  * whose size is variable. If the size of the attribute is not what we expect,
  * this functions returns -1 and errno is explicitly set.
  */
-EXPORT_SYMBOL(mnl_attr_validate2);
-int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
-		       size_t exp_len)
+EXPORT_SYMBOL int mnl_attr_validate2(const struct nlattr *attr,
+				     enum mnl_attr_data_type type,
+				     size_t exp_len)
 {
 	if (type >= MNL_TYPE_MAX) {
 		errno = EINVAL;
@@ -260,9 +252,9 @@ int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse);
-int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
-		   mnl_attr_cb_t cb, void *data)
+EXPORT_SYMBOL int mnl_attr_parse(const struct nlmsghdr *nlh,
+				 unsigned int offset, mnl_attr_cb_t cb,
+				 void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -287,9 +279,8 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse_nested);
-int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
-			  void *data)
+EXPORT_SYMBOL int mnl_attr_parse_nested(const struct nlattr *nested,
+					mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -319,9 +310,9 @@ int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse_payload);
-int mnl_attr_parse_payload(const void *payload, size_t payload_len,
-			   mnl_attr_cb_t cb, void *data)
+EXPORT_SYMBOL int mnl_attr_parse_payload(const void *payload,
+					 size_t payload_len,
+					 mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -338,8 +329,7 @@ int mnl_attr_parse_payload(const void *payload, size_t payload_len,
  *
  * This function returns the 8-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u8);
-uint8_t mnl_attr_get_u8(const struct nlattr *attr)
+EXPORT_SYMBOL uint8_t mnl_attr_get_u8(const struct nlattr *attr)
 {
 	return *((uint8_t *)mnl_attr_get_payload(attr));
 }
@@ -350,8 +340,7 @@ uint8_t mnl_attr_get_u8(const struct nlattr *attr)
  *
  * This function returns the 16-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u16);
-uint16_t mnl_attr_get_u16(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_u16(const struct nlattr *attr)
 {
 	return *((uint16_t *)mnl_attr_get_payload(attr));
 }
@@ -362,8 +351,7 @@ uint16_t mnl_attr_get_u16(const struct nlattr *attr)
  *
  * This function returns the 32-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u32);
-uint32_t mnl_attr_get_u32(const struct nlattr *attr)
+EXPORT_SYMBOL uint32_t mnl_attr_get_u32(const struct nlattr *attr)
 {
 	return *((uint32_t *)mnl_attr_get_payload(attr));
 }
@@ -376,8 +364,7 @@ uint32_t mnl_attr_get_u32(const struct nlattr *attr)
  * function is align-safe, since accessing 64-bit Netlink attributes is a
  * common source of alignment issues.
  */
-EXPORT_SYMBOL(mnl_attr_get_u64);
-uint64_t mnl_attr_get_u64(const struct nlattr *attr)
+EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 {
 	uint64_t tmp;
 	memcpy(&tmp, mnl_attr_get_payload(attr), sizeof(tmp));
@@ -390,8 +377,7 @@ uint64_t mnl_attr_get_u64(const struct nlattr *attr)
  *
  * This function returns the payload of string attribute value.
  */
-EXPORT_SYMBOL(mnl_attr_get_str);
-const char *mnl_attr_get_str(const struct nlattr *attr)
+EXPORT_SYMBOL const char *mnl_attr_get_str(const struct nlattr *attr)
 {
 	return mnl_attr_get_payload(attr);
 }
@@ -406,9 +392,8 @@ const char *mnl_attr_get_str(const struct nlattr *attr)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put);
-void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
-		  const void *data)
+EXPORT_SYMBOL void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type,
+				size_t len, const void *data)
 {
 	struct nlattr *attr = mnl_nlmsg_get_payload_tail(nlh);
 	uint16_t payload_len = MNL_ALIGN(sizeof(struct nlattr)) + len;
@@ -433,8 +418,8 @@ void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u8);
-void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
+EXPORT_SYMBOL void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type,
+				   uint8_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint8_t), &data);
 }
@@ -448,8 +433,8 @@ void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u16);
-void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
+EXPORT_SYMBOL void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type,
+				    uint16_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint16_t), &data);
 }
@@ -463,8 +448,8 @@ void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u32);
-void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
+EXPORT_SYMBOL void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type,
+				    uint32_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint32_t), &data);
 }
@@ -478,8 +463,8 @@ void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u64);
-void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
+EXPORT_SYMBOL void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type,
+				    uint64_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
 }
@@ -493,8 +478,8 @@ void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_str);
-void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
+EXPORT_SYMBOL void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type,
+				    const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
 }
@@ -511,8 +496,8 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_strz);
-void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
+EXPORT_SYMBOL void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type,
+				     const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
@@ -526,8 +511,8 @@ void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * an attribute nest. This function always returns a valid pointer to the
  * beginning of the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_start);
-struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
+EXPORT_SYMBOL struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh,
+						 uint16_t type)
 {
 	struct nlattr *start = mnl_nlmsg_get_payload_tail(nlh);
 
@@ -552,9 +537,9 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_check);
-bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
-			uint16_t type, size_t len, const void *data)
+EXPORT_SYMBOL bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
+				      uint16_t type, size_t len,
+				      const void *data)
 {
 	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN + MNL_ALIGN(len) > buflen)
 		return false;
@@ -575,9 +560,8 @@ bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_u8_check);
-bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
-			   uint16_t type, uint8_t data)
+EXPORT_SYMBOL bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
+					 uint16_t type, uint8_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint8_t), &data);
 }
@@ -597,9 +581,8 @@ bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u16_check);
-bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
-			    uint16_t type, uint16_t data)
+EXPORT_SYMBOL bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
+					  uint16_t type, uint16_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint16_t), &data);
 }
@@ -619,9 +602,8 @@ bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u32_check);
-bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
-			    uint16_t type, uint32_t data)
+EXPORT_SYMBOL bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
+					  uint16_t type, uint32_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint32_t), &data);
 }
@@ -641,9 +623,8 @@ bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u64_check);
-bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
-			    uint16_t type, uint64_t data)
+EXPORT_SYMBOL bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
+					  uint16_t type, uint64_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint64_t), &data);
 }
@@ -663,9 +644,8 @@ bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_str_check);
-bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
-			    uint16_t type, const char *data)
+EXPORT_SYMBOL bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
+					  uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data), data);
 }
@@ -686,9 +666,8 @@ bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_strz_check);
-bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
-			     uint16_t type, const char *data)
+EXPORT_SYMBOL bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
+					   uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data)+1, data);
 }
@@ -703,9 +682,9 @@ bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
  * an attribute nest. If the nested attribute cannot be added then NULL,
  * otherwise valid pointer to the beginning of the nest is returned.
  */
-EXPORT_SYMBOL(mnl_attr_nest_start_check);
-struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
-					 uint16_t type)
+EXPORT_SYMBOL struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh,
+						       size_t buflen,
+						       uint16_t type)
 {
 	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN > buflen)
 		return NULL;
@@ -719,8 +698,8 @@ struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
  *
  * This function updates the attribute header that identifies the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_end);
-void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
+EXPORT_SYMBOL void mnl_attr_nest_end(struct nlmsghdr *nlh,
+				     struct nlattr *start)
 {
 	start->nla_len = mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
@@ -732,8 +711,8 @@ void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
  *
  * This function updates the attribute header that identifies the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_cancel);
-void mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *start)
+EXPORT_SYMBOL void mnl_attr_nest_cancel(struct nlmsghdr *nlh,
+					struct nlattr *start)
 {
 	nlh->nlmsg_len -= mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
diff --git a/src/callback.c b/src/callback.c
index 01181e6..f5349c3 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -127,10 +127,11 @@ out:
  * to EPROTO. If the dump was interrupted, errno is set to EINTR and you should
  * request a new fresh dump again.
  */
-EXPORT_SYMBOL(mnl_cb_run2);
-int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
-		unsigned int portid, mnl_cb_t cb_data, void *data,
-		const mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
+EXPORT_SYMBOL int mnl_cb_run2(const void *buf, size_t numbytes,
+			      unsigned int seq, unsigned int portid,
+			      mnl_cb_t cb_data, void *data,
+			      const mnl_cb_t *cb_ctl_array,
+			      unsigned int cb_ctl_array_len)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data,
 			    cb_ctl_array, cb_ctl_array_len);
@@ -155,9 +156,8 @@ int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
  *
  * This function propagates the callback return value.
  */
-EXPORT_SYMBOL(mnl_cb_run);
-int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
-	       unsigned int portid, mnl_cb_t cb_data, void *data)
+EXPORT_SYMBOL int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
+			     unsigned int portid, mnl_cb_t cb_data, void *data)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
 }
diff --git a/src/internal.h b/src/internal.h
index 3a88d1a..d69eaf3 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -3,8 +3,7 @@
 
 #include "config.h"
 #ifdef HAVE_VISIBILITY_HIDDEN
-#	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
+#	define EXPORT_SYMBOL __attribute__((visibility("default")))
 #else
 #	define EXPORT_SYMBOL
 #endif
diff --git a/src/nlmsg.c b/src/nlmsg.c
index f9448a5..fb99135 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -51,8 +51,7 @@
  * This function returns the size of a netlink message (header plus payload)
  * without alignment.
  */
-EXPORT_SYMBOL(mnl_nlmsg_size);
-size_t mnl_nlmsg_size(size_t len)
+EXPORT_SYMBOL size_t mnl_nlmsg_size(size_t len)
 {
 	return len + MNL_NLMSG_HDRLEN;
 }
@@ -64,8 +63,7 @@ size_t mnl_nlmsg_size(size_t len)
  * This function returns the Length of the netlink payload, ie. the length
  * of the full message minus the size of the Netlink header.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
-size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
 {
 	return nlh->nlmsg_len - MNL_NLMSG_HDRLEN;
 }
@@ -79,8 +77,7 @@ size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
  * initializes the nlmsg_len field to the size of the Netlink header. This
  * function returns a pointer to the Netlink header structure.
  */
-EXPORT_SYMBOL(mnl_nlmsg_put_header);
-struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
+EXPORT_SYMBOL struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 {
 	int len = MNL_ALIGN(sizeof(struct nlmsghdr));
 	struct nlmsghdr *nlh = buf;
@@ -101,8 +98,8 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
  * you call this function. This function returns a pointer to the extra
  * header.
  */
-EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
-void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
+EXPORT_SYMBOL void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh,
+					       size_t size)
 {
 	char *ptr = (char *)nlh + nlh->nlmsg_len;
 	size_t len = MNL_ALIGN(size);
@@ -117,8 +114,7 @@ void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
  *
  * This function returns a pointer to the payload of the netlink message.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload);
-void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN;
 }
@@ -131,8 +127,8 @@ void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
  * This function returns a pointer to the payload of the netlink message plus
  * a given offset.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
-void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
+EXPORT_SYMBOL void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh,
+						 size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
 }
@@ -153,8 +149,7 @@ void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
  * The len parameter may become negative in malformed messages during message
  * iteration, that is why we use a signed integer.
  */
-EXPORT_SYMBOL(mnl_nlmsg_ok);
-bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
+EXPORT_SYMBOL bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
 	return len >= (int)sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >= sizeof(struct nlmsghdr) &&
@@ -174,8 +169,8 @@ bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
  * You have to use mnl_nlmsg_ok() to check if the next Netlink message is
  * valid.
  */
-EXPORT_SYMBOL(mnl_nlmsg_next);
-struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
+EXPORT_SYMBOL struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh,
+					      int *len)
 {
 	*len -= MNL_ALIGN(nlh->nlmsg_len);
 	return (struct nlmsghdr *)((void *)nlh + MNL_ALIGN(nlh->nlmsg_len));
@@ -189,8 +184,7 @@ struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
  * to build a message since we continue adding attributes at the end of the
  * message.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
-void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_ALIGN(nlh->nlmsg_len);
 }
@@ -209,8 +203,8 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
  * socket to send commands to kernel-space (that we want to track) and to
  * listen to events (that we do not track).
  */
-EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
-bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
+EXPORT_SYMBOL bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh,
+				    unsigned int seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : true;
 }
@@ -229,8 +223,8 @@ bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * to kernel-space (that we want to track) and to listen to events (that we
  * do not track).
  */
-EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
-bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
+EXPORT_SYMBOL bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh,
+				       unsigned int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : true;
 }
@@ -363,9 +357,8 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
  * - N, that indicates that NLA_F_NESTED is set.
  * - B, that indicates that NLA_F_NET_BYTEORDER is set.
  */
-EXPORT_SYMBOL(mnl_nlmsg_fprintf);
-void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
-		       size_t extra_header_size)
+EXPORT_SYMBOL void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
+				     size_t extra_header_size)
 {
 	const struct nlmsghdr *nlh = data;
 	int len = datalen;
@@ -433,8 +426,8 @@ struct mnl_nlmsg_batch {
  * the heap, no restrictions in this regard. This function returns NULL on
  * error.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_start);
-struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
+EXPORT_SYMBOL struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf,
+							    size_t limit)
 {
 	struct mnl_nlmsg_batch *b;
 
@@ -457,8 +450,7 @@ struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
  *
  * This function releases the batch allocated by mnl_nlmsg_batch_start().
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
-void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
 {
 	free(b);
 }
@@ -474,8 +466,7 @@ void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
  * You have to put at least one message in the batch before calling this
  * function, otherwise your application is likely to crash.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_next);
-bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 {
 	struct nlmsghdr *nlh = b->cur;
 
@@ -496,8 +487,7 @@ bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
  * new one. This function moves the last message which does not fit the
  * batch to the head of the buffer, if any.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
-void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 {
 	if (b->overflow) {
 		struct nlmsghdr *nlh = b->cur;
@@ -517,8 +507,7 @@ void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
  *
  * This function returns the current size of the batch.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_size);
-size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen;
 }
@@ -530,8 +519,7 @@ size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
  * This function returns a pointer to the head of the batch, which is the
  * beginning of the buffer that is used.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_head);
-void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
 {
 	return b->buf;
 }
@@ -543,8 +531,7 @@ void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
  * This function returns a pointer to the current position in the buffer
  * that is used to store the batch.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_current);
-void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
 {
 	return b->cur;
 }
@@ -555,8 +542,7 @@ void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
  *
  * This function returns true if the batch is empty.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
-bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen == 0;
 }
diff --git a/src/socket.c b/src/socket.c
index 31d6fbe..d7c67a8 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -82,8 +82,7 @@ struct mnl_socket {
  *
  * This function returns the file descriptor of a given netlink socket.
  */
-EXPORT_SYMBOL(mnl_socket_get_fd);
-int mnl_socket_get_fd(const struct mnl_socket *nl)
+EXPORT_SYMBOL int mnl_socket_get_fd(const struct mnl_socket *nl)
 {
 	return nl->fd;
 }
@@ -97,8 +96,7 @@ int mnl_socket_get_fd(const struct mnl_socket *nl)
  * which is not always true. This is the case if you open more than one
  * socket that is binded to the same Netlink subsystem from the same process.
  */
-EXPORT_SYMBOL(mnl_socket_get_portid);
-unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
+EXPORT_SYMBOL unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
 {
 	return nl->addr.nl_pid;
 }
@@ -127,8 +125,7 @@ static struct mnl_socket *__mnl_socket_open(int bus, int flags)
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-EXPORT_SYMBOL(mnl_socket_open);
-struct mnl_socket *mnl_socket_open(int bus)
+EXPORT_SYMBOL struct mnl_socket *mnl_socket_open(int bus)
 {
 	return __mnl_socket_open(bus, 0);
 }
@@ -145,8 +142,7 @@ struct mnl_socket *mnl_socket_open(int bus)
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-EXPORT_SYMBOL(mnl_socket_open2);
-struct mnl_socket *mnl_socket_open2(int bus, int flags)
+EXPORT_SYMBOL struct mnl_socket *mnl_socket_open2(int bus, int flags)
 {
 	return __mnl_socket_open(bus, flags);
 }
@@ -162,8 +158,7 @@ struct mnl_socket *mnl_socket_open2(int bus, int flags)
  * Note that mnl_socket_get_portid() returns 0 if this function is used with
  * non-netlink socket.
  */
-EXPORT_SYMBOL(mnl_socket_fdopen);
-struct mnl_socket *mnl_socket_fdopen(int fd)
+EXPORT_SYMBOL struct mnl_socket *mnl_socket_fdopen(int fd)
 {
 	int ret;
 	struct mnl_socket *nl;
@@ -195,8 +190,8 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
  * success, 0 is returned. You can use MNL_SOCKET_AUTOPID which is 0 for
  * automatic port ID selection.
  */
-EXPORT_SYMBOL(mnl_socket_bind);
-int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
+EXPORT_SYMBOL int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,
+				  pid_t pid)
 {
 	int ret;
 	socklen_t addr_len;
@@ -234,9 +229,8 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
  * On error, it returns -1 and errno is appropriately set. Otherwise, it 
  * returns the number of bytes sent.
  */
-EXPORT_SYMBOL(mnl_socket_sendto);
-ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
-			  size_t len)
+EXPORT_SYMBOL ssize_t mnl_socket_sendto(const struct mnl_socket *nl,
+					const void *buf, size_t len)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -259,9 +253,8 @@ ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
  */
-EXPORT_SYMBOL(mnl_socket_recvfrom);
-ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
-			    size_t bufsiz)
+EXPORT_SYMBOL ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl,
+					  void *buf, size_t bufsiz)
 {
 	ssize_t ret;
 	struct sockaddr_nl addr;
@@ -300,8 +293,7 @@ ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
  * On error, this function returns -1 and errno is appropriately set.
  * On success, it returns 0.
  */
-EXPORT_SYMBOL(mnl_socket_close);
-int mnl_socket_close(struct mnl_socket *nl)
+EXPORT_SYMBOL int mnl_socket_close(struct mnl_socket *nl)
 {
 	int ret = close(nl->fd);
 	free(nl);
@@ -333,9 +325,8 @@ int mnl_socket_close(struct mnl_socket *nl)
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-EXPORT_SYMBOL(mnl_socket_setsockopt);
-int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
-			  void *buf, socklen_t len)
+EXPORT_SYMBOL int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
+					void *buf, socklen_t len)
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
@@ -349,9 +340,8 @@ int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-EXPORT_SYMBOL(mnl_socket_getsockopt);
-int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
-			  void *buf, socklen_t *len)
+EXPORT_SYMBOL int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
+					void *buf, socklen_t *len)
 {
 	return getsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-- 
2.20.1

