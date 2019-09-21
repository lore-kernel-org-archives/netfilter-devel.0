Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61336C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 10:32:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 145B02086A
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 10:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407426AbfIUKci (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 06:32:38 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:52871 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731142AbfIUKci (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 06:32:38 -0400
Received: from dimstar.local.net (n122-110-44-45.sun2.vic.optusnet.com.au [122.110.44.45])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 5024843E173
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Sep 2019 20:32:15 +1000 (AEST)
Received: (qmail 29612 invoked by uid 501); 21 Sep 2019 10:32:14 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH libmnl, v3] Enable doxygen to generate Function Documentation
Date:   Sat, 21 Sep 2019 20:32:14 +1000
Message-Id: <20190921103214.29569-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=4DzML1vCOQ6Odsy8BUtSXQ==:117 a=4DzML1vCOQ6Odsy8BUtSXQ==:17
        a=J70Eh1EUuV4A:10 a=qhLOVHrUzZAvz4SvXkwA:9
        a=7Zwj6sZBwVKJAoWSPKxL6X1jA+E=:19 a=fGjeIg8U-xbbA0qX:21
        a=_7BLhNcWpLgqkrr2:21
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The C source files all contain doxygen documentation for each defined function
but this was not appearing in the generated HTML or man pages.
Fix is to move all EXPORT_SYMBOL macro calls to near the start of each file.
Doxygen seems to otherwise forget the documentation on encountering
EXPORT_SYMBOL which is flagged in the EXCLUDE_SYMBOLS tag in doxygen.cfg.in.
I encountered this "feature" in doxygen 1.8.9.1 but it still appears to be
present in 1.8.16
Tested against gcc and clang builds
Also fixed a missing doxygen section trailer in nlmsg.c
---
v2: - Move EXPORT_SYMBOL lines to after last #include line
    - Slip in an extra fix for a missing doxygen section trailer
      (didn't think it warrantied an extra patch)
    - Tweak commit message
 
 src/attr.c     | 71 +++++++++++++++++++++++++++++-----------------------------
 src/callback.c |  5 +++--
 src/nlmsg.c    | 45 ++++++++++++++++++++-----------------
 src/socket.c   | 23 ++++++++++---------
 4 files changed, 76 insertions(+), 68 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index 0359ba9..00a5354 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -12,6 +12,42 @@
 #include <errno.h>
 #include "internal.h"
 
+EXPORT_SYMBOL(mnl_attr_get_type);
+EXPORT_SYMBOL(mnl_attr_get_len);
+EXPORT_SYMBOL(mnl_attr_get_payload_len);
+EXPORT_SYMBOL(mnl_attr_get_payload);
+EXPORT_SYMBOL(mnl_attr_ok);
+EXPORT_SYMBOL(mnl_attr_next);
+EXPORT_SYMBOL(mnl_attr_type_valid);
+EXPORT_SYMBOL(mnl_attr_validate);
+EXPORT_SYMBOL(mnl_attr_validate2);
+EXPORT_SYMBOL(mnl_attr_parse);
+EXPORT_SYMBOL(mnl_attr_parse_nested);
+EXPORT_SYMBOL(mnl_attr_parse_payload);
+EXPORT_SYMBOL(mnl_attr_get_u8);
+EXPORT_SYMBOL(mnl_attr_get_u16);
+EXPORT_SYMBOL(mnl_attr_get_u32);
+EXPORT_SYMBOL(mnl_attr_get_u64);
+EXPORT_SYMBOL(mnl_attr_get_str);
+EXPORT_SYMBOL(mnl_attr_put);
+EXPORT_SYMBOL(mnl_attr_put_u8);
+EXPORT_SYMBOL(mnl_attr_put_u16);
+EXPORT_SYMBOL(mnl_attr_put_u32);
+EXPORT_SYMBOL(mnl_attr_put_u64);
+EXPORT_SYMBOL(mnl_attr_put_str);
+EXPORT_SYMBOL(mnl_attr_put_strz);
+EXPORT_SYMBOL(mnl_attr_nest_start);
+EXPORT_SYMBOL(mnl_attr_put_check);
+EXPORT_SYMBOL(mnl_attr_put_u8_check);
+EXPORT_SYMBOL(mnl_attr_put_u16_check);
+EXPORT_SYMBOL(mnl_attr_put_u32_check);
+EXPORT_SYMBOL(mnl_attr_put_u64_check);
+EXPORT_SYMBOL(mnl_attr_put_str_check);
+EXPORT_SYMBOL(mnl_attr_put_strz_check);
+EXPORT_SYMBOL(mnl_attr_nest_start_check);
+EXPORT_SYMBOL(mnl_attr_nest_end);
+EXPORT_SYMBOL(mnl_attr_nest_cancel);
+
 /**
  * \defgroup attr Netlink attribute helpers
  *
@@ -35,7 +71,6 @@
  *
  * This function returns the attribute type.
  */
-EXPORT_SYMBOL(mnl_attr_get_type);
 uint16_t mnl_attr_get_type(const struct nlattr *attr)
 {
 	return attr->nla_type & NLA_TYPE_MASK;
@@ -48,7 +83,6 @@ uint16_t mnl_attr_get_type(const struct nlattr *attr)
  * This function returns the attribute length that is the attribute header
  * plus the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_len);
 uint16_t mnl_attr_get_len(const struct nlattr *attr)
 {
 	return attr->nla_len;
@@ -60,7 +94,6 @@ uint16_t mnl_attr_get_len(const struct nlattr *attr)
  *
  * This function returns the attribute payload-value length.
  */
-EXPORT_SYMBOL(mnl_attr_get_payload_len);
 uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 {
 	return attr->nla_len - MNL_ATTR_HDRLEN;
@@ -72,7 +105,6 @@ uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
  *
  * This function return a pointer to the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_payload);
 void *mnl_attr_get_payload(const struct nlattr *attr)
 {
 	return (void *)attr + MNL_ATTR_HDRLEN;
@@ -94,7 +126,6 @@ void *mnl_attr_get_payload(const struct nlattr *attr)
  * The len parameter may be negative in the case of malformed messages during
  * attribute iteration, that is why we use a signed integer.
  */
-EXPORT_SYMBOL(mnl_attr_ok);
 bool mnl_attr_ok(const struct nlattr *attr, int len)
 {
 	return len >= (int)sizeof(struct nlattr) &&
@@ -110,7 +141,6 @@ bool mnl_attr_ok(const struct nlattr *attr, int len)
  * as parameter. You have to use mnl_attr_ok() to ensure that the next
  * attribute is valid.
  */
-EXPORT_SYMBOL(mnl_attr_next);
 struct nlattr *mnl_attr_next(const struct nlattr *attr)
 {
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
@@ -130,7 +160,6 @@ struct nlattr *mnl_attr_next(const struct nlattr *attr)
  * This leads to backward compatibility breakages in user-space. Better check
  * if you support an attribute, if not, skip it.
  */
-EXPORT_SYMBOL(mnl_attr_type_valid);
 int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 {
 	if (mnl_attr_get_type(attr) > max) {
@@ -211,7 +240,6 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
  * integers (u8, u16, u32 and u64) have enough room for them. This function
  * returns -1 in case of error, and errno is explicitly set.
  */
-EXPORT_SYMBOL(mnl_attr_validate);
 int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 {
 	int exp_len;
@@ -234,7 +262,6 @@ int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
  * whose size is variable. If the size of the attribute is not what we expect,
  * this functions returns -1 and errno is explicitly set.
  */
-EXPORT_SYMBOL(mnl_attr_validate2);
 int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
 		       size_t exp_len)
 {
@@ -260,7 +287,6 @@ int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse);
 int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 		   mnl_attr_cb_t cb, void *data)
 {
@@ -287,7 +313,6 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse_nested);
 int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
 			  void *data)
 {
@@ -319,7 +344,6 @@ int mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-EXPORT_SYMBOL(mnl_attr_parse_payload);
 int mnl_attr_parse_payload(const void *payload, size_t payload_len,
 			   mnl_attr_cb_t cb, void *data)
 {
@@ -338,7 +362,6 @@ int mnl_attr_parse_payload(const void *payload, size_t payload_len,
  *
  * This function returns the 8-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u8);
 uint8_t mnl_attr_get_u8(const struct nlattr *attr)
 {
 	return *((uint8_t *)mnl_attr_get_payload(attr));
@@ -350,7 +373,6 @@ uint8_t mnl_attr_get_u8(const struct nlattr *attr)
  *
  * This function returns the 16-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u16);
 uint16_t mnl_attr_get_u16(const struct nlattr *attr)
 {
 	return *((uint16_t *)mnl_attr_get_payload(attr));
@@ -362,7 +384,6 @@ uint16_t mnl_attr_get_u16(const struct nlattr *attr)
  *
  * This function returns the 32-bit value of the attribute payload.
  */
-EXPORT_SYMBOL(mnl_attr_get_u32);
 uint32_t mnl_attr_get_u32(const struct nlattr *attr)
 {
 	return *((uint32_t *)mnl_attr_get_payload(attr));
@@ -376,7 +397,6 @@ uint32_t mnl_attr_get_u32(const struct nlattr *attr)
  * function is align-safe, since accessing 64-bit Netlink attributes is a
  * common source of alignment issues.
  */
-EXPORT_SYMBOL(mnl_attr_get_u64);
 uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 {
 	uint64_t tmp;
@@ -390,7 +410,6 @@ uint64_t mnl_attr_get_u64(const struct nlattr *attr)
  *
  * This function returns the payload of string attribute value.
  */
-EXPORT_SYMBOL(mnl_attr_get_str);
 const char *mnl_attr_get_str(const struct nlattr *attr)
 {
 	return mnl_attr_get_payload(attr);
@@ -406,7 +425,6 @@ const char *mnl_attr_get_str(const struct nlattr *attr)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put);
 void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
 		  const void *data)
 {
@@ -433,7 +451,6 @@ void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u8);
 void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint8_t), &data);
@@ -448,7 +465,6 @@ void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u16);
 void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint16_t), &data);
@@ -463,7 +479,6 @@ void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u32);
 void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint32_t), &data);
@@ -478,7 +493,6 @@ void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u64);
 void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
@@ -493,7 +507,6 @@ void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_str);
 void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
@@ -511,7 +524,6 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_strz);
 void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
@@ -526,7 +538,6 @@ void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * an attribute nest. This function always returns a valid pointer to the
  * beginning of the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_start);
 struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
 {
 	struct nlattr *start = mnl_nlmsg_get_payload_tail(nlh);
@@ -552,7 +563,6 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_check);
 bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
 			uint16_t type, size_t len, const void *data)
 {
@@ -575,7 +585,6 @@ bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_u8_check);
 bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
 			   uint16_t type, uint8_t data)
 {
@@ -597,7 +606,6 @@ bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u16_check);
 bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, uint16_t data)
 {
@@ -619,7 +627,6 @@ bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u32_check);
 bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, uint32_t data)
 {
@@ -641,7 +648,6 @@ bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_u64_check);
 bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, uint64_t data)
 {
@@ -663,7 +669,6 @@ bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-EXPORT_SYMBOL(mnl_attr_put_str_check);
 bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
 			    uint16_t type, const char *data)
 {
@@ -686,7 +691,6 @@ bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-EXPORT_SYMBOL(mnl_attr_put_strz_check);
 bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
 			     uint16_t type, const char *data)
 {
@@ -703,7 +707,6 @@ bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
  * an attribute nest. If the nested attribute cannot be added then NULL,
  * otherwise valid pointer to the beginning of the nest is returned.
  */
-EXPORT_SYMBOL(mnl_attr_nest_start_check);
 struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
 					 uint16_t type)
 {
@@ -719,7 +722,6 @@ struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen,
  *
  * This function updates the attribute header that identifies the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_end);
 void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	start->nla_len = mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
@@ -732,7 +734,6 @@ void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
  *
  * This function updates the attribute header that identifies the nest.
  */
-EXPORT_SYMBOL(mnl_attr_nest_cancel);
 void mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	nlh->nlmsg_len -= mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
diff --git a/src/callback.c b/src/callback.c
index 01181e6..b09c386 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -11,6 +11,9 @@
 #include <libmnl/libmnl.h>
 #include "internal.h"
 
+EXPORT_SYMBOL(mnl_cb_run2);
+EXPORT_SYMBOL(mnl_cb_run);
+
 static int mnl_cb_noop(const struct nlmsghdr *nlh, void *data)
 {
 	return MNL_CB_OK;
@@ -127,7 +130,6 @@ out:
  * to EPROTO. If the dump was interrupted, errno is set to EINTR and you should
  * request a new fresh dump again.
  */
-EXPORT_SYMBOL(mnl_cb_run2);
 int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 		unsigned int portid, mnl_cb_t cb_data, void *data,
 		const mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
@@ -155,7 +157,6 @@ int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
  *
  * This function propagates the callback return value.
  */
-EXPORT_SYMBOL(mnl_cb_run);
 int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
 	       unsigned int portid, mnl_cb_t cb_data, void *data)
 {
diff --git a/src/nlmsg.c b/src/nlmsg.c
index f9448a5..574b66d 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -15,6 +15,27 @@
 #include <libmnl/libmnl.h>
 #include "internal.h"
 
+EXPORT_SYMBOL(mnl_nlmsg_size);
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
+EXPORT_SYMBOL(mnl_nlmsg_put_header);
+EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
+EXPORT_SYMBOL(mnl_nlmsg_get_payload);
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
+EXPORT_SYMBOL(mnl_nlmsg_ok);
+EXPORT_SYMBOL(mnl_nlmsg_next);
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
+EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
+EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
+EXPORT_SYMBOL(mnl_nlmsg_fprintf);
+EXPORT_SYMBOL(mnl_nlmsg_batch_start);
+EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
+EXPORT_SYMBOL(mnl_nlmsg_batch_next);
+EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
+EXPORT_SYMBOL(mnl_nlmsg_batch_size);
+EXPORT_SYMBOL(mnl_nlmsg_batch_head);
+EXPORT_SYMBOL(mnl_nlmsg_batch_current);
+EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
+
 /**
  * \defgroup nlmsg Netlink message helpers
  *
@@ -51,7 +72,6 @@
  * This function returns the size of a netlink message (header plus payload)
  * without alignment.
  */
-EXPORT_SYMBOL(mnl_nlmsg_size);
 size_t mnl_nlmsg_size(size_t len)
 {
 	return len + MNL_NLMSG_HDRLEN;
@@ -64,7 +84,6 @@ size_t mnl_nlmsg_size(size_t len)
  * This function returns the Length of the netlink payload, ie. the length
  * of the full message minus the size of the Netlink header.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
 size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
 {
 	return nlh->nlmsg_len - MNL_NLMSG_HDRLEN;
@@ -79,7 +98,6 @@ size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
  * initializes the nlmsg_len field to the size of the Netlink header. This
  * function returns a pointer to the Netlink header structure.
  */
-EXPORT_SYMBOL(mnl_nlmsg_put_header);
 struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 {
 	int len = MNL_ALIGN(sizeof(struct nlmsghdr));
@@ -101,7 +119,6 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
  * you call this function. This function returns a pointer to the extra
  * header.
  */
-EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
 void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 {
 	char *ptr = (char *)nlh + nlh->nlmsg_len;
@@ -117,7 +134,6 @@ void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
  *
  * This function returns a pointer to the payload of the netlink message.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload);
 void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN;
@@ -131,7 +147,6 @@ void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
  * This function returns a pointer to the payload of the netlink message plus
  * a given offset.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
 void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
@@ -153,7 +168,6 @@ void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
  * The len parameter may become negative in malformed messages during message
  * iteration, that is why we use a signed integer.
  */
-EXPORT_SYMBOL(mnl_nlmsg_ok);
 bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
 	return len >= (int)sizeof(struct nlmsghdr) &&
@@ -174,7 +188,6 @@ bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
  * You have to use mnl_nlmsg_ok() to check if the next Netlink message is
  * valid.
  */
-EXPORT_SYMBOL(mnl_nlmsg_next);
 struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
 {
 	*len -= MNL_ALIGN(nlh->nlmsg_len);
@@ -189,7 +202,6 @@ struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
  * to build a message since we continue adding attributes at the end of the
  * message.
  */
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
 void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_ALIGN(nlh->nlmsg_len);
@@ -209,7 +221,6 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
  * socket to send commands to kernel-space (that we want to track) and to
  * listen to events (that we do not track).
  */
-EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
 bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : true;
@@ -229,7 +240,6 @@ bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * to kernel-space (that we want to track) and to listen to events (that we
  * do not track).
  */
-EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
 bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : true;
@@ -363,7 +373,6 @@ static void mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
  * - N, that indicates that NLA_F_NESTED is set.
  * - B, that indicates that NLA_F_NET_BYTEORDER is set.
  */
-EXPORT_SYMBOL(mnl_nlmsg_fprintf);
 void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
 		       size_t extra_header_size)
 {
@@ -377,6 +386,10 @@ void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
 	}
 }
 
+/**
+ * @}
+ */
+
 /**
  * \defgroup batch Netlink message batch helpers
  *
@@ -433,7 +446,6 @@ struct mnl_nlmsg_batch {
  * the heap, no restrictions in this regard. This function returns NULL on
  * error.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_start);
 struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
 {
 	struct mnl_nlmsg_batch *b;
@@ -457,7 +469,6 @@ struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
  *
  * This function releases the batch allocated by mnl_nlmsg_batch_start().
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
 void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
 {
 	free(b);
@@ -474,7 +485,6 @@ void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
  * You have to put at least one message in the batch before calling this
  * function, otherwise your application is likely to crash.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_next);
 bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 {
 	struct nlmsghdr *nlh = b->cur;
@@ -496,7 +506,6 @@ bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
  * new one. This function moves the last message which does not fit the
  * batch to the head of the buffer, if any.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
 void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 {
 	if (b->overflow) {
@@ -517,7 +526,6 @@ void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
  *
  * This function returns the current size of the batch.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_size);
 size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen;
@@ -530,7 +538,6 @@ size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
  * This function returns a pointer to the head of the batch, which is the
  * beginning of the buffer that is used.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_head);
 void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
 {
 	return b->buf;
@@ -543,7 +550,6 @@ void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
  * This function returns a pointer to the current position in the buffer
  * that is used to store the batch.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_current);
 void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
 {
 	return b->cur;
@@ -555,7 +561,6 @@ void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
  *
  * This function returns true if the batch is empty.
  */
-EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
 bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen == 0;
diff --git a/src/socket.c b/src/socket.c
index 31d6fbe..63f0bae 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -16,6 +16,18 @@
 #include <errno.h>
 #include "internal.h"
 
+EXPORT_SYMBOL(mnl_socket_get_fd);
+EXPORT_SYMBOL(mnl_socket_get_portid);
+EXPORT_SYMBOL(mnl_socket_open);
+EXPORT_SYMBOL(mnl_socket_open2);
+EXPORT_SYMBOL(mnl_socket_fdopen);
+EXPORT_SYMBOL(mnl_socket_bind);
+EXPORT_SYMBOL(mnl_socket_sendto);
+EXPORT_SYMBOL(mnl_socket_recvfrom);
+EXPORT_SYMBOL(mnl_socket_close);
+EXPORT_SYMBOL(mnl_socket_setsockopt);
+EXPORT_SYMBOL(mnl_socket_getsockopt);
+
 /**
  * \mainpage
  *
@@ -82,7 +94,6 @@ struct mnl_socket {
  *
  * This function returns the file descriptor of a given netlink socket.
  */
-EXPORT_SYMBOL(mnl_socket_get_fd);
 int mnl_socket_get_fd(const struct mnl_socket *nl)
 {
 	return nl->fd;
@@ -97,7 +108,6 @@ int mnl_socket_get_fd(const struct mnl_socket *nl)
  * which is not always true. This is the case if you open more than one
  * socket that is binded to the same Netlink subsystem from the same process.
  */
-EXPORT_SYMBOL(mnl_socket_get_portid);
 unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
 {
 	return nl->addr.nl_pid;
@@ -127,7 +137,6 @@ static struct mnl_socket *__mnl_socket_open(int bus, int flags)
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-EXPORT_SYMBOL(mnl_socket_open);
 struct mnl_socket *mnl_socket_open(int bus)
 {
 	return __mnl_socket_open(bus, 0);
@@ -145,7 +154,6 @@ struct mnl_socket *mnl_socket_open(int bus)
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-EXPORT_SYMBOL(mnl_socket_open2);
 struct mnl_socket *mnl_socket_open2(int bus, int flags)
 {
 	return __mnl_socket_open(bus, flags);
@@ -162,7 +170,6 @@ struct mnl_socket *mnl_socket_open2(int bus, int flags)
  * Note that mnl_socket_get_portid() returns 0 if this function is used with
  * non-netlink socket.
  */
-EXPORT_SYMBOL(mnl_socket_fdopen);
 struct mnl_socket *mnl_socket_fdopen(int fd)
 {
 	int ret;
@@ -195,7 +202,6 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
  * success, 0 is returned. You can use MNL_SOCKET_AUTOPID which is 0 for
  * automatic port ID selection.
  */
-EXPORT_SYMBOL(mnl_socket_bind);
 int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 {
 	int ret;
@@ -234,7 +240,6 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
  * On error, it returns -1 and errno is appropriately set. Otherwise, it 
  * returns the number of bytes sent.
  */
-EXPORT_SYMBOL(mnl_socket_sendto);
 ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
 			  size_t len)
 {
@@ -259,7 +264,6 @@ ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
  */
-EXPORT_SYMBOL(mnl_socket_recvfrom);
 ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
 			    size_t bufsiz)
 {
@@ -300,7 +304,6 @@ ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
  * On error, this function returns -1 and errno is appropriately set.
  * On success, it returns 0.
  */
-EXPORT_SYMBOL(mnl_socket_close);
 int mnl_socket_close(struct mnl_socket *nl)
 {
 	int ret = close(nl->fd);
@@ -333,7 +336,6 @@ int mnl_socket_close(struct mnl_socket *nl)
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-EXPORT_SYMBOL(mnl_socket_setsockopt);
 int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
 			  void *buf, socklen_t len)
 {
@@ -349,7 +351,6 @@ int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-EXPORT_SYMBOL(mnl_socket_getsockopt);
 int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
 			  void *buf, socklen_t *len)
 {
-- 
2.14.5

