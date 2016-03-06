From: Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH libmnl] Move declaration of visibility attributes before definition.
Date: Sun,  6 Mar 2016 10:33:11 -0500
Message-ID: <1457278391-10086-1-git-send-email-pefoley2@pefoley.com>
Cc: Peter Foley <pefoley2@pefoley.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f67.google.com ([209.85.192.67]:33525 "EHLO
	mail-qg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbcCFPdQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Mar 2016 10:33:16 -0500
Received: by mail-qg0-f67.google.com with SMTP id y89so6735931qge.0
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Mar 2016 07:33:16 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When compiling with clang, the visibility attributes are ignored
since they are after the definition of the exported function.

Fix this by moving the attribute declaration before the function.

attr.c:439:1: error: attribute declaration must precede definition [-Werror,-Wignored-attributes]
EXPORT_SYMBOL(mnl_attr_put_u8);
^
./internal.h:7:41: note: expanded from macro 'EXPORT_SYMBOL'
                                              ^
./internal.h:6:35: note: expanded from macro '__visible'
                                               ^
attr.c:435:6: note: previous definition is here
void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
     ^

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 src/attr.c     | 70 +++++++++++++++++++++++++++++-----------------------------
 src/callback.c |  4 ++--
 src/nlmsg.c    | 40 ++++++++++++++++-----------------
 src/socket.c   | 22 +++++++++---------
 4 files changed, 68 insertions(+), 68 deletions(-)

diff --git a/src/attr.c b/src/attr.c
index c551d0b..5b418b0 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -35,11 +35,11 @@
  *
  * This function returns the attribute type.
  */
+EXPORT_SYMBOL(mnl_attr_get_type);
 uint16_t mnl_attr_get_type(const struct nlattr *attr)
 {
 	return attr->nla_type & NLA_TYPE_MASK;
 }
-EXPORT_SYMBOL(mnl_attr_get_type);
 
 /**
  * mnl_attr_get_len - get length of netlink attribute
@@ -48,11 +48,11 @@ EXPORT_SYMBOL(mnl_attr_get_type);
  * This function returns the attribute length that is the attribute header
  * plus the attribute payload.
  */
+EXPORT_SYMBOL(mnl_attr_get_len);
 uint16_t mnl_attr_get_len(const struct nlattr *attr)
 {
 	return attr->nla_len;
 }
-EXPORT_SYMBOL(mnl_attr_get_len);
 
 /**
  * mnl_attr_get_payload_len - get the attribute payload-value length
@@ -60,11 +60,11 @@ EXPORT_SYMBOL(mnl_attr_get_len);
  *
  * This function returns the attribute payload-value length.
  */
+EXPORT_SYMBOL(mnl_attr_get_payload_len);
 uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 {
 	return attr->nla_len - MNL_ATTR_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_attr_get_payload_len);
 
 /**
  * mnl_attr_get_payload - get pointer to the attribute payload
@@ -72,11 +72,11 @@ EXPORT_SYMBOL(mnl_attr_get_payload_len);
  *
  * This function return a pointer to the attribute payload.
  */
+EXPORT_SYMBOL(mnl_attr_get_payload);
 void *mnl_attr_get_payload(const struct nlattr *attr)
 {
 	return (void *)attr + MNL_ATTR_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_attr_get_payload);
 
 /**
  * mnl_attr_ok - check if there is room for an attribute in a buffer
@@ -94,13 +94,13 @@ EXPORT_SYMBOL(mnl_attr_get_payload);
  * The len parameter may be negative in the case of malformed messages during
  * attribute iteration, that is why we use a signed integer.
  */
+EXPORT_SYMBOL(mnl_attr_ok);
 bool mnl_attr_ok(const struct nlattr *attr, int len)
 {
 	return len >= (int)sizeof(struct nlattr) &&
 	       attr->nla_len >= sizeof(struct nlattr) &&
 	       (int)attr->nla_len <= len;
 }
-EXPORT_SYMBOL(mnl_attr_ok);
 
 /**
  * mnl_attr_next - get the next attribute in the payload of a netlink message
@@ -110,11 +110,11 @@ EXPORT_SYMBOL(mnl_attr_ok);
  * as parameter. You have to use mnl_attr_ok() to ensure that the next
  * attribute is valid.
  */
+EXPORT_SYMBOL(mnl_attr_next);
 struct nlattr *mnl_attr_next(const struct nlattr *attr)
 {
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
 }
-EXPORT_SYMBOL(mnl_attr_next);
 
 /**
  * mnl_attr_type_valid - check if the attribute type is valid
@@ -130,6 +130,7 @@ EXPORT_SYMBOL(mnl_attr_next);
  * This leads to backward compatibility breakages in user-space. Better check
  * if you support an attribute, if not, skip it.
  */
+EXPORT_SYMBOL(mnl_attr_type_valid);
 int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 {
 	if (mnl_attr_get_type(attr) > max) {
@@ -138,7 +139,6 @@ int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 	}
 	return 1;
 }
-EXPORT_SYMBOL(mnl_attr_type_valid);
 
 static int __mnl_attr_validate(const struct nlattr *attr,
 			       enum mnl_attr_data_type type, size_t exp_len)
@@ -211,6 +211,7 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
  * integers (u8, u16, u32 and u64) have enough room for them. This function
  * returns -1 in case of error, and errno is explicitly set.
  */
+EXPORT_SYMBOL(mnl_attr_validate);
 int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 {
 	int exp_len;
@@ -222,7 +223,6 @@ int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 	exp_len = mnl_attr_data_type_len[type];
 	return __mnl_attr_validate(attr, type, exp_len);
 }
-EXPORT_SYMBOL(mnl_attr_validate);
 
 /**
  * mnl_attr_validate2 - validate netlink attribute (extended version)
@@ -234,6 +234,7 @@ EXPORT_SYMBOL(mnl_attr_validate);
  * whose size is variable. If the size of the attribute is not what we expect,
  * this functions returns -1 and errno is explicitly set.
  */
+EXPORT_SYMBOL(mnl_attr_validate2);
 int
 mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
 		   size_t exp_len)
@@ -244,7 +245,6 @@ mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
 	}
 	return __mnl_attr_validate(attr, type, exp_len);
 }
-EXPORT_SYMBOL(mnl_attr_validate2);
 
 /**
  * mnl_attr_parse - parse attributes
@@ -261,6 +261,7 @@ EXPORT_SYMBOL(mnl_attr_validate2);
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
+EXPORT_SYMBOL(mnl_attr_parse);
 int
 mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 	       mnl_attr_cb_t cb, void *data)
@@ -273,7 +274,6 @@ mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse);
 
 /**
  * mnl_attr_parse_nested - parse attributes inside a nest
@@ -289,6 +289,7 @@ EXPORT_SYMBOL(mnl_attr_parse);
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
+EXPORT_SYMBOL(mnl_attr_parse_nested);
 int
 mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
 		      void *data)
@@ -301,7 +302,6 @@ mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse_nested);
 
 /**
  * mnl_attr_parse_payload - parse attributes in payload of Netlink message
@@ -322,6 +322,7 @@ EXPORT_SYMBOL(mnl_attr_parse_nested);
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
+EXPORT_SYMBOL(mnl_attr_parse_payload);
 int
 mnl_attr_parse_payload(const void *payload, size_t payload_len,
 		       mnl_attr_cb_t cb, void *data)
@@ -334,7 +335,6 @@ mnl_attr_parse_payload(const void *payload, size_t payload_len,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse_payload);
 
 /**
  * mnl_attr_get_u8 - returns 8-bit unsigned integer attribute payload
@@ -342,11 +342,11 @@ EXPORT_SYMBOL(mnl_attr_parse_payload);
  *
  * This function returns the 8-bit value of the attribute payload.
  */
+EXPORT_SYMBOL(mnl_attr_get_u8);
 uint8_t mnl_attr_get_u8(const struct nlattr *attr)
 {
 	return *((uint8_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u8);
 
 /**
  * mnl_attr_get_u16 - returns 16-bit unsigned integer attribute payload
@@ -354,11 +354,11 @@ EXPORT_SYMBOL(mnl_attr_get_u8);
  *
  * This function returns the 16-bit value of the attribute payload.
  */
+EXPORT_SYMBOL(mnl_attr_get_u16);
 uint16_t mnl_attr_get_u16(const struct nlattr *attr)
 {
 	return *((uint16_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u16);
 
 /**
  * mnl_attr_get_u32 - returns 32-bit unsigned integer attribute payload
@@ -366,11 +366,11 @@ EXPORT_SYMBOL(mnl_attr_get_u16);
  *
  * This function returns the 32-bit value of the attribute payload.
  */
+EXPORT_SYMBOL(mnl_attr_get_u32);
 uint32_t mnl_attr_get_u32(const struct nlattr *attr)
 {
 	return *((uint32_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u32);
 
 /**
  * mnl_attr_get_u64 - returns 64-bit unsigned integer attribute.
@@ -380,13 +380,13 @@ EXPORT_SYMBOL(mnl_attr_get_u32);
  * function is align-safe, since accessing 64-bit Netlink attributes is a
  * common source of alignment issues.
  */
+EXPORT_SYMBOL(mnl_attr_get_u64);
 uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 {
 	uint64_t tmp;
 	memcpy(&tmp, mnl_attr_get_payload(attr), sizeof(tmp));
 	return tmp;
 }
-EXPORT_SYMBOL(mnl_attr_get_u64);
 
 /**
  * mnl_attr_get_str - returns pointer to string attribute.
@@ -394,11 +394,11 @@ EXPORT_SYMBOL(mnl_attr_get_u64);
  *
  * This function returns the payload of string attribute value.
  */
+EXPORT_SYMBOL(mnl_attr_get_str);
 const char *mnl_attr_get_str(const struct nlattr *attr)
 {
 	return mnl_attr_get_payload(attr);
 }
-EXPORT_SYMBOL(mnl_attr_get_str);
 
 /**
  * mnl_attr_put - add an attribute to netlink message
@@ -410,6 +410,7 @@ EXPORT_SYMBOL(mnl_attr_get_str);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put);
 void
 mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, const void *data)
 {
@@ -421,7 +422,6 @@ mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, const void *data)
 	memcpy(mnl_attr_get_payload(attr), data, len);
 	nlh->nlmsg_len += MNL_ALIGN(payload_len);
 }
-EXPORT_SYMBOL(mnl_attr_put);
 
 /**
  * mnl_attr_put_u8 - add 8-bit unsigned integer attribute to netlink message
@@ -432,11 +432,11 @@ EXPORT_SYMBOL(mnl_attr_put);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_u8);
 void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint8_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u8);
 
 /**
  * mnl_attr_put_u16 - add 16-bit unsigned integer attribute to netlink message
@@ -447,11 +447,11 @@ EXPORT_SYMBOL(mnl_attr_put_u8);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_u16);
 void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint16_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u16);
 
 /**
  * mnl_attr_put_u32 - add 32-bit unsigned integer attribute to netlink message
@@ -462,11 +462,11 @@ EXPORT_SYMBOL(mnl_attr_put_u16);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_u32);
 void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint32_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u32);
 
 /**
  * mnl_attr_put_u64 - add 64-bit unsigned integer attribute to netlink message
@@ -477,11 +477,11 @@ EXPORT_SYMBOL(mnl_attr_put_u32);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_u64);
 void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u64);
 
 /**
  * mnl_attr_put_str - add string attribute to netlink message
@@ -492,11 +492,11 @@ EXPORT_SYMBOL(mnl_attr_put_u64);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_str);
 void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
 }
-EXPORT_SYMBOL(mnl_attr_put_str);
 
 /**
  * mnl_attr_put_strz - add string attribute to netlink message
@@ -510,11 +510,11 @@ EXPORT_SYMBOL(mnl_attr_put_str);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_strz);
 void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
-EXPORT_SYMBOL(mnl_attr_put_strz);
 
 /**
  * mnl_attr_nest_start - start an attribute nest
@@ -525,6 +525,7 @@ EXPORT_SYMBOL(mnl_attr_put_strz);
  * an attribute nest. This function always returns a valid pointer to the
  * beginning of the nest.
  */
+EXPORT_SYMBOL(mnl_attr_nest_start);
 struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
 {
 	struct nlattr *start = mnl_nlmsg_get_payload_tail(nlh);
@@ -535,7 +536,6 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
 
 	return start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_start);
 
 /**
  * mnl_attr_put_check - add an attribute to netlink message
@@ -551,6 +551,7 @@ EXPORT_SYMBOL(mnl_attr_nest_start);
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
+EXPORT_SYMBOL(mnl_attr_put_check);
 bool
 mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
 		   uint16_t type, size_t len, const void *data)
@@ -560,7 +561,6 @@ mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
 	mnl_attr_put(nlh, type, len, data);
 	return true;
 }
-EXPORT_SYMBOL(mnl_attr_put_check);
 
 /**
  * mnl_attr_put_u8_check - add 8-bit unsigned int attribute to netlink message
@@ -575,13 +575,13 @@ EXPORT_SYMBOL(mnl_attr_put_check);
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
+EXPORT_SYMBOL(mnl_attr_put_u8_check);
 bool
 mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
 		      uint16_t type, uint8_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint8_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u8_check);
 
 /**
  * mnl_attr_put_u16_check - add 16-bit unsigned int attribute to netlink message
@@ -598,13 +598,13 @@ EXPORT_SYMBOL(mnl_attr_put_u8_check);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_u16_check);
 bool
 mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
 		       uint16_t type, uint16_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint16_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u16_check);
 
 /**
  * mnl_attr_put_u32_check - add 32-bit unsigned int attribute to netlink message
@@ -621,13 +621,13 @@ EXPORT_SYMBOL(mnl_attr_put_u16_check);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_u32_check);
 bool
 mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
 		       uint16_t type, uint32_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint32_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u32_check);
 
 /**
  * mnl_attr_put_u64_check - add 64-bit unsigned int attribute to netlink message
@@ -644,13 +644,13 @@ EXPORT_SYMBOL(mnl_attr_put_u32_check);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_u64_check);
 bool
 mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
 		       uint16_t type, uint64_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint64_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u64_check);
 
 /**
  * mnl_attr_put_str_check - add string attribute to netlink message
@@ -667,13 +667,13 @@ EXPORT_SYMBOL(mnl_attr_put_u64_check);
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
+EXPORT_SYMBOL(mnl_attr_put_str_check);
 bool
 mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
 		       uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data), data);
 }
-EXPORT_SYMBOL(mnl_attr_put_str_check);
 
 /**
  * mnl_attr_put_strz_check - add string attribute to netlink message
@@ -691,13 +691,13 @@ EXPORT_SYMBOL(mnl_attr_put_str_check);
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
+EXPORT_SYMBOL(mnl_attr_put_strz_check);
 bool
 mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
 			uint16_t type, const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data)+1, data);
 }
-EXPORT_SYMBOL(mnl_attr_put_strz_check);
 
 /**
  * mnl_attr_nest_start_check - start an attribute nest
@@ -709,6 +709,7 @@ EXPORT_SYMBOL(mnl_attr_put_strz_check);
  * an attribute nest. If the nested attribute cannot be added then NULL,
  * otherwise valid pointer to the beginning of the nest is returned.
  */
+EXPORT_SYMBOL(mnl_attr_nest_start_check);
 struct nlattr *
 mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type)
 {
@@ -716,7 +717,6 @@ mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type)
 		return NULL;
 	return mnl_attr_nest_start(nlh, type);
 }
-EXPORT_SYMBOL(mnl_attr_nest_start_check);
 
 /**
  * mnl_attr_nest_end - end an attribute nest
@@ -725,12 +725,12 @@ EXPORT_SYMBOL(mnl_attr_nest_start_check);
  *
  * This function updates the attribute header that identifies the nest.
  */
+EXPORT_SYMBOL(mnl_attr_nest_end);
 void
 mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	start->nla_len = mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_end);
 
 /**
  * mnl_attr_nest_cancel - cancel an attribute nest
@@ -739,12 +739,12 @@ EXPORT_SYMBOL(mnl_attr_nest_end);
  *
  * This function updates the attribute header that identifies the nest.
  */
+EXPORT_SYMBOL(mnl_attr_nest_cancel);
 void
 mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	nlh->nlmsg_len -= mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_cancel);
 
 /**
  * @}
diff --git a/src/callback.c b/src/callback.c
index f023401..beaeb59 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -126,6 +126,7 @@ out:
  * to EPROTO. If the dump was interrupted, errno is set to EINTR and you should
  * request a new fresh dump again.
  */
+EXPORT_SYMBOL(mnl_cb_run2);
 int
 mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 	    unsigned int portid, mnl_cb_t cb_data, void *data,
@@ -134,7 +135,6 @@ mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data,
 			    cb_ctl_array, cb_ctl_array_len);
 }
-EXPORT_SYMBOL(mnl_cb_run2);
 
 /**
  * mnl_cb_run - callback runqueue for netlink messages (simplified version)
@@ -155,13 +155,13 @@ EXPORT_SYMBOL(mnl_cb_run2);
  *
  * This function propagates the callback return value.
  */
+EXPORT_SYMBOL(mnl_cb_run);
 int
 mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
 	   unsigned int portid, mnl_cb_t cb_data, void *data)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
 }
-EXPORT_SYMBOL(mnl_cb_run);
 
 /**
  * @}
diff --git a/src/nlmsg.c b/src/nlmsg.c
index fd2f698..3eaba93 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -51,11 +51,11 @@
  * This function returns the size of a netlink message (header plus payload)
  * without alignment.
  */
+EXPORT_SYMBOL(mnl_nlmsg_size);
 size_t mnl_nlmsg_size(size_t len)
 {
 	return len + MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_size);
 
 /**
  * mnl_nlmsg_get_payload_len - get the length of the Netlink payload
@@ -64,11 +64,11 @@ EXPORT_SYMBOL(mnl_nlmsg_size);
  * This function returns the Length of the netlink payload, ie. the length
  * of the full message minus the size of the Netlink header.
  */
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
 size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
 {
 	return nlh->nlmsg_len - MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
 
 /**
  * mnl_nlmsg_put_header - reserve and prepare room for Netlink header
@@ -79,6 +79,7 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
  * initializes the nlmsg_len field to the size of the Netlink header. This
  * function returns a pointer to the Netlink header structure.
  */
+EXPORT_SYMBOL(mnl_nlmsg_put_header);
 struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 {
 	int len = MNL_ALIGN(sizeof(struct nlmsghdr));
@@ -88,7 +89,6 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 	nlh->nlmsg_len = len;
 	return nlh;
 }
-EXPORT_SYMBOL(mnl_nlmsg_put_header);
 
 /**
  * mnl_nlmsg_put_extra_header - reserve and prepare room for an extra header
@@ -101,6 +101,7 @@ EXPORT_SYMBOL(mnl_nlmsg_put_header);
  * you call this function. This function returns a pointer to the extra
  * header.
  */
+EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
 void *
 mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 {
@@ -110,7 +111,6 @@ mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 	memset(ptr, 0, len);
 	return ptr;
 }
-EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
 
 /**
  * mnl_nlmsg_get_payload - get a pointer to the payload of the netlink message
@@ -118,11 +118,11 @@ EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
  *
  * This function returns a pointer to the payload of the netlink message.
  */
+EXPORT_SYMBOL(mnl_nlmsg_get_payload);
 void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload);
 
 /**
  * mnl_nlmsg_get_payload_offset - get a pointer to the payload of the message
@@ -132,12 +132,12 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload);
  * This function returns a pointer to the payload of the netlink message plus
  * a given offset.
  */
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
 void *
 mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
 
 /**
  * mnl_nlmsg_ok - check a there is room for netlink message
@@ -155,13 +155,13 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
  * The len parameter may become negative in malformed messages during message
  * iteration, that is why we use a signed integer.
  */
+EXPORT_SYMBOL(mnl_nlmsg_ok);
 bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
 	return len >= (int)sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >= sizeof(struct nlmsghdr) &&
 	       (int)nlh->nlmsg_len <= len;
 }
-EXPORT_SYMBOL(mnl_nlmsg_ok);
 
 /**
  * mnl_nlmsg_next - get the next netlink message in a multipart message
@@ -176,13 +176,13 @@ EXPORT_SYMBOL(mnl_nlmsg_ok);
  * You have to use mnl_nlmsg_ok() to check if the next Netlink message is
  * valid.
  */
+EXPORT_SYMBOL(mnl_nlmsg_next);
 struct nlmsghdr *
 mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
 {
 	*len -= MNL_ALIGN(nlh->nlmsg_len);
 	return (struct nlmsghdr *)((void *)nlh + MNL_ALIGN(nlh->nlmsg_len));
 }
-EXPORT_SYMBOL(mnl_nlmsg_next);
 
 /**
  * mnl_nlmsg_get_payload_tail - get the ending of the netlink message
@@ -192,11 +192,11 @@ EXPORT_SYMBOL(mnl_nlmsg_next);
  * to build a message since we continue adding attributes at the end of the
  * message.
  */
+EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
 void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_ALIGN(nlh->nlmsg_len);
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
 
 /**
  * mnl_nlmsg_seq_ok - perform sequence tracking
@@ -212,12 +212,12 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
  * socket to send commands to kernel-space (that we want to track) and to
  * listen to events (that we do not track).
  */
+EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
 bool
 mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
 
 /**
  * mnl_nlmsg_portid_ok - perform portID origin check
@@ -233,12 +233,12 @@ EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
  * to kernel-space (that we want to track) and to listen to events (that we
  * do not track).
  */
+EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
 bool
 mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
 
 static void mnl_nlmsg_fprintf_header(FILE *fd, const struct nlmsghdr *nlh)
 {
@@ -369,6 +369,7 @@ mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
  * - N, that indicates that NLA_F_NESTED is set.
  * - B, that indicates that NLA_F_NET_BYTEORDER is set.
  */
+EXPORT_SYMBOL(mnl_nlmsg_fprintf);
 void
 mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
 		  size_t extra_header_size)
@@ -382,7 +383,6 @@ mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
 		nlh = mnl_nlmsg_next(nlh, &len);
 	}
 }
-EXPORT_SYMBOL(mnl_nlmsg_fprintf);
 
 /**
  * \defgroup batch Netlink message batch helpers
@@ -440,6 +440,7 @@ struct mnl_nlmsg_batch {
  * the heap, no restrictions in this regard. This function returns NULL on
  * error.
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_start);
 struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
 {
 	struct mnl_nlmsg_batch *b;
@@ -456,7 +457,6 @@ struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
 
 	return b;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_start);
 
 /**
  * mnl_nlmsg_batch_stop - release a batch
@@ -464,11 +464,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_start);
  *
  * This function releases the batch allocated by mnl_nlmsg_batch_start().
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
 void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
 {
 	free(b);
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
 
 /**
  * mnl_nlmsg_batch_next - get room for the next message in the batch
@@ -481,6 +481,7 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
  * You have to put at least one message in the batch before calling this
  * function, otherwise your application is likely to crash.
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_next);
 bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 {
 	struct nlmsghdr *nlh = b->cur;
@@ -493,7 +494,6 @@ bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 	b->buflen += nlh->nlmsg_len;
 	return true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_next);
 
 /**
  * mnl_nlmsg_batch_reset - reset the batch
@@ -503,6 +503,7 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_next);
  * new one. This function moves the last message which does not fit the
  * batch to the head of the buffer, if any.
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
 void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 {
 	if (b->overflow) {
@@ -516,7 +517,6 @@ void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 		b->cur = b->buf;
 	}
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
 
 /**
  * mnl_nlmsg_batch_size - get current size of the batch
@@ -524,11 +524,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
  *
  * This function returns the current size of the batch.
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_size);
 size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_size);
 
 /**
  * mnl_nlmsg_batch_head - get head of this batch
@@ -537,11 +537,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_size);
  * This function returns a pointer to the head of the batch, which is the
  * beginning of the buffer that is used.
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_head);
 void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
 {
 	return b->buf;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_head);
 
 /**
  * mnl_nlmsg_batch_current - returns current position in the batch
@@ -550,11 +550,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_head);
  * This function returns a pointer to the current position in the buffer
  * that is used to store the batch.
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_current);
 void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
 {
 	return b->cur;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_current);
 
 /**
  * mnl_nlmsg_batch_is_empty - check if there is any message in the batch
@@ -562,11 +562,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_current);
  *
  * This function returns true if the batch is empty.
  */
+EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
 bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen == 0;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
 
 /**
  * @}
diff --git a/src/socket.c b/src/socket.c
index d63ab87..cc22f5b 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -82,11 +82,11 @@ struct mnl_socket {
  *
  * This function returns the file descriptor of a given netlink socket.
  */
+EXPORT_SYMBOL(mnl_socket_get_fd);
 int mnl_socket_get_fd(const struct mnl_socket *nl)
 {
 	return nl->fd;
 }
-EXPORT_SYMBOL(mnl_socket_get_fd);
 
 /**
  * mnl_socket_get_portid - obtain Netlink PortID from netlink socket
@@ -97,11 +97,11 @@ EXPORT_SYMBOL(mnl_socket_get_fd);
  * which is not always true. This is the case if you open more than one
  * socket that is binded to the same Netlink subsystem from the same process.
  */
+EXPORT_SYMBOL(mnl_socket_get_portid);
 unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
 {
 	return nl->addr.nl_pid;
 }
-EXPORT_SYMBOL(mnl_socket_get_portid);
 
 static struct mnl_socket *__mnl_socket_open(int bus, int flags)
 {
@@ -127,11 +127,11 @@ static struct mnl_socket *__mnl_socket_open(int bus, int flags)
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
+EXPORT_SYMBOL(mnl_socket_open);
 struct mnl_socket *mnl_socket_open(int bus)
 {
 	return __mnl_socket_open(bus, 0);
 }
-EXPORT_SYMBOL(mnl_socket_open);
 
 /**
  * mnl_socket_open2 - open a netlink socket with appropriate flags
@@ -145,11 +145,11 @@ EXPORT_SYMBOL(mnl_socket_open);
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
+EXPORT_SYMBOL(mnl_socket_open2);
 struct mnl_socket *mnl_socket_open2(int bus, int flags)
 {
 	return __mnl_socket_open(bus, flags);
 }
-EXPORT_SYMBOL(mnl_socket_open2);
 
 /**
  * mnl_socket_fdopen - associates a mnl_socket object with pre-existing socket.
@@ -162,6 +162,7 @@ EXPORT_SYMBOL(mnl_socket_open2);
  * Note that mnl_socket_get_portid() returns 0 if this function is used with
  * non-netlink socket.
  */
+EXPORT_SYMBOL(mnl_socket_fdopen);
 struct mnl_socket *mnl_socket_fdopen(int fd)
 {
 	int ret;
@@ -183,7 +184,6 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
 
 	return nl;
 }
-EXPORT_SYMBOL(mnl_socket_fdopen);
 
 /**
  * mnl_socket_bind - bind netlink socket
@@ -195,6 +195,7 @@ EXPORT_SYMBOL(mnl_socket_fdopen);
  * success, 0 is returned. You can use MNL_SOCKET_AUTOPID which is 0 for
  * automatic port ID selection.
  */
+EXPORT_SYMBOL(mnl_socket_bind);
 int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 {
 	int ret;
@@ -223,7 +224,6 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(mnl_socket_bind);
 
 /**
  * mnl_socket_sendto - send a netlink message of a certain size
@@ -234,6 +234,7 @@ EXPORT_SYMBOL(mnl_socket_bind);
  * On error, it returns -1 and errno is appropriately set. Otherwise, it 
  * returns the number of bytes sent.
  */
+EXPORT_SYMBOL(mnl_socket_sendto);
 ssize_t
 mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
 {
@@ -243,7 +244,6 @@ mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
 	return sendto(nl->fd, buf, len, 0, 
 		      (struct sockaddr *) &snl, sizeof(snl));
 }
-EXPORT_SYMBOL(mnl_socket_sendto);
 
 /**
  * mnl_socket_recvfrom - receive a netlink message
@@ -259,6 +259,7 @@ EXPORT_SYMBOL(mnl_socket_sendto);
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
  */
+EXPORT_SYMBOL(mnl_socket_recvfrom);
 ssize_t
 mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
 {
@@ -291,7 +292,6 @@ mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_recvfrom);
 
 /**
  * mnl_socket_close - close a given netlink socket
@@ -300,13 +300,13 @@ EXPORT_SYMBOL(mnl_socket_recvfrom);
  * On error, this function returns -1 and errno is appropriately set.
  * On success, it returns 0.
  */
+EXPORT_SYMBOL(mnl_socket_close);
 int mnl_socket_close(struct mnl_socket *nl)
 {
 	int ret = close(nl->fd);
 	free(nl);
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_close);
 
 /**
  * mnl_socket_setsockopt - set Netlink socket option
@@ -333,12 +333,12 @@ EXPORT_SYMBOL(mnl_socket_close);
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
+EXPORT_SYMBOL(mnl_socket_setsockopt);
 int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
 			  void *buf, socklen_t len)
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_setsockopt);
 
 /**
  * mnl_socket_getsockopt - get a Netlink socket option
@@ -349,12 +349,12 @@ EXPORT_SYMBOL(mnl_socket_setsockopt);
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
+EXPORT_SYMBOL(mnl_socket_getsockopt);
 int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
 			  void *buf, socklen_t *len)
 {
 	return getsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_getsockopt);
 
 /**
  * @}
-- 
2.7.2

