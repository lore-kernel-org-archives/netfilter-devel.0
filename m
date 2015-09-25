From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] libmnl: Failed to build with clang, incompatible
 EXPORT_SYMBOL(x) macro
Date: Fri, 25 Sep 2015 11:07:45 +0700
Message-ID: <20150925040745.GA433@oxygen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34529 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbbIYEIz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 00:08:55 -0400
Received: by padhy16 with SMTP id hy16so93188930pad.1
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Sep 2015 21:08:54 -0700 (PDT)
Received: from oxygen (cm-27-145-116-2.revip12.asianet.co.th. [27.145.116.2])
        by smtp.gmail.com with ESMTPSA id tk4sm1213701pab.45.2015.09.24.21.08.52
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Sep 2015 21:08:53 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The EXPORT_SYMBOL(x) macro causes clang compile error and warning
messges:
  error,   "note: previous definition is here"
  warning, "warning: attribute declaration must precede definition
            [-Wignored-attributes]"
  See: [1]

This proposed patch has been prepared to fix this error which make the
EXPORT_SYMBOL macro define a precede definition of an attribute
declaration. This approach is both compatible with gcc and clang.

[1] http://clang.debian.net/logs/2014-09-03/libmnl_1.0.3-5_unstable_clang.l=
og

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 doxygen.cfg.in |   8 +--
 src/attr.c     | 162 ++++++++++++++++++++++++++---------------------------=
----
 src/callback.c |  12 ++---
 src/internal.h |   3 +-
 src/nlmsg.c    |  76 +++++++++++++--------------
 src/socket.c   |  42 +++++++--------
 6 files changed, 138 insertions(+), 165 deletions(-)

diff --git a/doxygen.cfg.in b/doxygen.cfg.in
index ee8fdfa..6fc842c 100644
--- a/doxygen.cfg.in
+++ b/doxygen.cfg.in
@@ -72,7 +72,7 @@ RECURSIVE              =3D YES
 EXCLUDE                =3D=20
 EXCLUDE_SYMLINKS       =3D NO
 EXCLUDE_PATTERNS       =3D */.git/* .*.d
-EXCLUDE_SYMBOLS        =3D EXPORT_SYMBOL
+EXCLUDE_SYMBOLS        =3D
 EXAMPLE_PATH           =3D=20
 EXAMPLE_PATTERNS       =3D=20
 EXAMPLE_RECURSIVE      =3D NO
@@ -144,12 +144,12 @@ PERLMOD_LATEX          =3D NO
 PERLMOD_PRETTY         =3D YES
 PERLMOD_MAKEVAR_PREFIX =3D=20
 ENABLE_PREPROCESSING   =3D YES
-MACRO_EXPANSION        =3D NO
-EXPAND_ONLY_PREDEF     =3D NO
+MACRO_EXPANSION        =3D YES
+EXPAND_ONLY_PREDEF     =3D YES
 SEARCH_INCLUDES        =3D YES
 INCLUDE_PATH           =3D=20
 INCLUDE_FILE_PATTERNS  =3D=20
-PREDEFINED             =3D=20
+PREDEFINED             =3D EXPORT_SYMBOL=3D
 EXPAND_AS_DEFINED      =3D=20
 SKIP_FUNCTION_MACROS   =3D YES
 TAGFILES               =3D=20
diff --git a/src/attr.c b/src/attr.c
index c551d0b..7dcb756 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -35,11 +35,11 @@
  *
  * This function returns the attribute type.
  */
-uint16_t mnl_attr_get_type(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t
+mnl_attr_get_type(const struct nlattr *attr)
 {
 	return attr->nla_type & NLA_TYPE_MASK;
 }
-EXPORT_SYMBOL(mnl_attr_get_type);
=20
 /**
  * mnl_attr_get_len - get length of netlink attribute
@@ -48,11 +48,11 @@ EXPORT_SYMBOL(mnl_attr_get_type);
  * This function returns the attribute length that is the attribute header
  * plus the attribute payload.
  */
-uint16_t mnl_attr_get_len(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t
+mnl_attr_get_len(const struct nlattr *attr)
 {
 	return attr->nla_len;
 }
-EXPORT_SYMBOL(mnl_attr_get_len);
=20
 /**
  * mnl_attr_get_payload_len - get the attribute payload-value length
@@ -60,11 +60,11 @@ EXPORT_SYMBOL(mnl_attr_get_len);
  *
  * This function returns the attribute payload-value length.
  */
-uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t
+mnl_attr_get_payload_len(const struct nlattr *attr)
 {
 	return attr->nla_len - MNL_ATTR_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_attr_get_payload_len);
=20
 /**
  * mnl_attr_get_payload - get pointer to the attribute payload
@@ -72,11 +72,11 @@ EXPORT_SYMBOL(mnl_attr_get_payload_len);
  *
  * This function return a pointer to the attribute payload.
  */
-void *mnl_attr_get_payload(const struct nlattr *attr)
+EXPORT_SYMBOL void *
+mnl_attr_get_payload(const struct nlattr *attr)
 {
 	return (void *)attr + MNL_ATTR_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_attr_get_payload);
=20
 /**
  * mnl_attr_ok - check if there is room for an attribute in a buffer
@@ -94,13 +94,13 @@ EXPORT_SYMBOL(mnl_attr_get_payload);
  * The len parameter may be negative in the case of malformed messages dur=
ing
  * attribute iteration, that is why we use a signed integer.
  */
-bool mnl_attr_ok(const struct nlattr *attr, int len)
+EXPORT_SYMBOL bool
+mnl_attr_ok(const struct nlattr *attr, int len)
 {
 	return len >=3D (int)sizeof(struct nlattr) &&
 	       attr->nla_len >=3D sizeof(struct nlattr) &&
 	       (int)attr->nla_len <=3D len;
 }
-EXPORT_SYMBOL(mnl_attr_ok);
=20
 /**
  * mnl_attr_next - get the next attribute in the payload of a netlink mess=
age
@@ -110,11 +110,11 @@ EXPORT_SYMBOL(mnl_attr_ok);
  * as parameter. You have to use mnl_attr_ok() to ensure that the next
  * attribute is valid.
  */
-struct nlattr *mnl_attr_next(const struct nlattr *attr)
+EXPORT_SYMBOL struct nlattr *
+mnl_attr_next(const struct nlattr *attr)
 {
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
 }
-EXPORT_SYMBOL(mnl_attr_next);
=20
 /**
  * mnl_attr_type_valid - check if the attribute type is valid
@@ -130,7 +130,8 @@ EXPORT_SYMBOL(mnl_attr_next);
  * This leads to backward compatibility breakages in user-space. Better ch=
eck
  * if you support an attribute, if not, skip it.
  */
-int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
+EXPORT_SYMBOL int
+mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 {
 	if (mnl_attr_get_type(attr) > max) {
 		errno =3D EOPNOTSUPP;
@@ -138,7 +139,6 @@ int mnl_attr_type_valid(const struct nlattr *attr, uint=
16_t max)
 	}
 	return 1;
 }
-EXPORT_SYMBOL(mnl_attr_type_valid);
=20
 static int __mnl_attr_validate(const struct nlattr *attr,
 			       enum mnl_attr_data_type type, size_t exp_len)
@@ -211,7 +211,8 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX=
] =3D {
  * integers (u8, u16, u32 and u64) have enough room for them. This function
  * returns -1 in case of error, and errno is explicitly set.
  */
-int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type t=
ype)
+EXPORT_SYMBOL int
+mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 {
 	int exp_len;
=20
@@ -222,7 +223,6 @@ int mnl_attr_validate(const struct nlattr *attr, enum m=
nl_attr_data_type type)
 	exp_len =3D mnl_attr_data_type_len[type];
 	return __mnl_attr_validate(attr, type, exp_len);
 }
-EXPORT_SYMBOL(mnl_attr_validate);
=20
 /**
  * mnl_attr_validate2 - validate netlink attribute (extended version)
@@ -234,9 +234,9 @@ EXPORT_SYMBOL(mnl_attr_validate);
  * whose size is variable. If the size of the attribute is not what we exp=
ect,
  * this functions returns -1 and errno is explicitly set.
  */
-int
+EXPORT_SYMBOL int
 mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
-		   size_t exp_len)
+                   size_t exp_len)
 {
 	if (type >=3D MNL_TYPE_MAX) {
 		errno =3D EINVAL;
@@ -244,7 +244,6 @@ mnl_attr_validate2(const struct nlattr *attr, enum mnl_=
attr_data_type type,
 	}
 	return __mnl_attr_validate(attr, type, exp_len);
 }
-EXPORT_SYMBOL(mnl_attr_validate2);
=20
 /**
  * mnl_attr_parse - parse attributes
@@ -261,9 +260,9 @@ EXPORT_SYMBOL(mnl_attr_validate2);
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-int
+EXPORT_SYMBOL int
 mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
-	       mnl_attr_cb_t cb, void *data)
+               mnl_attr_cb_t cb, void *data)
 {
 	int ret =3D MNL_CB_OK;
 	const struct nlattr *attr;
@@ -273,7 +272,6 @@ mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int=
 offset,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse);
=20
 /**
  * mnl_attr_parse_nested - parse attributes inside a nest
@@ -289,9 +287,8 @@ EXPORT_SYMBOL(mnl_attr_parse);
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-int
-mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
-		      void *data)
+EXPORT_SYMBOL int
+mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb, void =
*data)
 {
 	int ret =3D MNL_CB_OK;
 	const struct nlattr *attr;
@@ -301,7 +298,6 @@ mnl_attr_parse_nested(const struct nlattr *nested, mnl_=
attr_cb_t cb,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse_nested);
=20
 /**
  * mnl_attr_parse_payload - parse attributes in payload of Netlink message
@@ -322,9 +318,9 @@ EXPORT_SYMBOL(mnl_attr_parse_nested);
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-int
+EXPORT_SYMBOL int
 mnl_attr_parse_payload(const void *payload, size_t payload_len,
-		       mnl_attr_cb_t cb, void *data)
+                       mnl_attr_cb_t cb, void *data)
 {
 	int ret =3D MNL_CB_OK;
 	const struct nlattr *attr;
@@ -334,7 +330,6 @@ mnl_attr_parse_payload(const void *payload, size_t payl=
oad_len,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse_payload);
=20
 /**
  * mnl_attr_get_u8 - returns 8-bit unsigned integer attribute payload
@@ -342,11 +337,11 @@ EXPORT_SYMBOL(mnl_attr_parse_payload);
  *
  * This function returns the 8-bit value of the attribute payload.
  */
-uint8_t mnl_attr_get_u8(const struct nlattr *attr)
+EXPORT_SYMBOL uint8_t
+mnl_attr_get_u8(const struct nlattr *attr)
 {
 	return *((uint8_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u8);
=20
 /**
  * mnl_attr_get_u16 - returns 16-bit unsigned integer attribute payload
@@ -354,11 +349,11 @@ EXPORT_SYMBOL(mnl_attr_get_u8);
  *
  * This function returns the 16-bit value of the attribute payload.
  */
-uint16_t mnl_attr_get_u16(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t
+mnl_attr_get_u16(const struct nlattr *attr)
 {
 	return *((uint16_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u16);
=20
 /**
  * mnl_attr_get_u32 - returns 32-bit unsigned integer attribute payload
@@ -366,11 +361,11 @@ EXPORT_SYMBOL(mnl_attr_get_u16);
  *
  * This function returns the 32-bit value of the attribute payload.
  */
-uint32_t mnl_attr_get_u32(const struct nlattr *attr)
+EXPORT_SYMBOL uint32_t
+mnl_attr_get_u32(const struct nlattr *attr)
 {
 	return *((uint32_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u32);
=20
 /**
  * mnl_attr_get_u64 - returns 64-bit unsigned integer attribute.
@@ -380,13 +375,13 @@ EXPORT_SYMBOL(mnl_attr_get_u32);
  * function is align-safe, since accessing 64-bit Netlink attributes is a
  * common source of alignment issues.
  */
-uint64_t mnl_attr_get_u64(const struct nlattr *attr)
+EXPORT_SYMBOL uint64_t
+mnl_attr_get_u64(const struct nlattr *attr)
 {
 	uint64_t tmp;
 	memcpy(&tmp, mnl_attr_get_payload(attr), sizeof(tmp));
 	return tmp;
 }
-EXPORT_SYMBOL(mnl_attr_get_u64);
=20
 /**
  * mnl_attr_get_str - returns pointer to string attribute.
@@ -394,11 +389,11 @@ EXPORT_SYMBOL(mnl_attr_get_u64);
  *
  * This function returns the payload of string attribute value.
  */
-const char *mnl_attr_get_str(const struct nlattr *attr)
+EXPORT_SYMBOL const char *
+mnl_attr_get_str(const struct nlattr *attr)
 {
 	return mnl_attr_get_payload(attr);
 }
-EXPORT_SYMBOL(mnl_attr_get_str);
=20
 /**
  * mnl_attr_put - add an attribute to netlink message
@@ -410,7 +405,7 @@ EXPORT_SYMBOL(mnl_attr_get_str);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-void
+EXPORT_SYMBOL void
 mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, const void *=
data)
 {
 	struct nlattr *attr =3D mnl_nlmsg_get_payload_tail(nlh);
@@ -421,7 +416,6 @@ mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_=
t len, const void *data)
 	memcpy(mnl_attr_get_payload(attr), data, len);
 	nlh->nlmsg_len +=3D MNL_ALIGN(payload_len);
 }
-EXPORT_SYMBOL(mnl_attr_put);
=20
 /**
  * mnl_attr_put_u8 - add 8-bit unsigned integer attribute to netlink messa=
ge
@@ -432,11 +426,11 @@ EXPORT_SYMBOL(mnl_attr_put);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint8_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u8);
=20
 /**
  * mnl_attr_put_u16 - add 16-bit unsigned integer attribute to netlink mes=
sage
@@ -447,11 +441,11 @@ EXPORT_SYMBOL(mnl_attr_put_u8);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint16_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u16);
=20
 /**
  * mnl_attr_put_u32 - add 32-bit unsigned integer attribute to netlink mes=
sage
@@ -462,11 +456,11 @@ EXPORT_SYMBOL(mnl_attr_put_u16);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint32_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u32);
=20
 /**
  * mnl_attr_put_u64 - add 64-bit unsigned integer attribute to netlink mes=
sage
@@ -477,11 +471,11 @@ EXPORT_SYMBOL(mnl_attr_put_u32);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u64);
=20
 /**
  * mnl_attr_put_str - add string attribute to netlink message
@@ -492,11 +486,11 @@ EXPORT_SYMBOL(mnl_attr_put_u64);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *dat=
a)
+EXPORT_SYMBOL void
+mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
 }
-EXPORT_SYMBOL(mnl_attr_put_str);
=20
 /**
  * mnl_attr_put_strz - add string attribute to netlink message
@@ -510,11 +504,11 @@ EXPORT_SYMBOL(mnl_attr_put_str);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *da=
ta)
+EXPORT_SYMBOL void
+mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
-EXPORT_SYMBOL(mnl_attr_put_strz);
=20
 /**
  * mnl_attr_nest_start - start an attribute nest
@@ -525,7 +519,8 @@ EXPORT_SYMBOL(mnl_attr_put_strz);
  * an attribute nest. This function always returns a valid pointer to the
  * beginning of the nest.
  */
-struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
+EXPORT_SYMBOL struct nlattr *
+mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
 {
 	struct nlattr *start =3D mnl_nlmsg_get_payload_tail(nlh);
=20
@@ -535,7 +530,6 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh=
, uint16_t type)
=20
 	return start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_start);
=20
 /**
  * mnl_attr_put_check - add an attribute to netlink message
@@ -551,16 +545,15 @@ EXPORT_SYMBOL(mnl_attr_nest_start);
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-bool
-mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
-		   uint16_t type, size_t len, const void *data)
+EXPORT_SYMBOL bool
+mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type,
+                   size_t len, const void *data)
 {
 	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN + MNL_ALIGN(len) > buflen)
 		return false;
 	mnl_attr_put(nlh, type, len, data);
 	return true;
 }
-EXPORT_SYMBOL(mnl_attr_put_check);
=20
 /**
  * mnl_attr_put_u8_check - add 8-bit unsigned int attribute to netlink mes=
sage
@@ -575,13 +568,12 @@ EXPORT_SYMBOL(mnl_attr_put_check);
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-bool
-mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,
-		      uint16_t type, uint8_t data)
+EXPORT_SYMBOL bool
+mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type,
+                      uint8_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint8_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u8_check);
=20
 /**
  * mnl_attr_put_u16_check - add 16-bit unsigned int attribute to netlink m=
essage
@@ -598,13 +590,12 @@ EXPORT_SYMBOL(mnl_attr_put_u8_check);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-bool
-mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, uint16_t data)
+EXPORT_SYMBOL bool
+mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type,
+                       uint16_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint16_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u16_check);
=20
 /**
  * mnl_attr_put_u32_check - add 32-bit unsigned int attribute to netlink m=
essage
@@ -621,13 +612,12 @@ EXPORT_SYMBOL(mnl_attr_put_u16_check);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-bool
-mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, uint32_t data)
+EXPORT_SYMBOL bool
+mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type,
+                       uint32_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint32_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u32_check);
=20
 /**
  * mnl_attr_put_u64_check - add 64-bit unsigned int attribute to netlink m=
essage
@@ -644,13 +634,12 @@ EXPORT_SYMBOL(mnl_attr_put_u32_check);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-bool
-mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, uint64_t data)
+EXPORT_SYMBOL bool
+mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type,
+                       uint64_t data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint64_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u64_check);
=20
 /**
  * mnl_attr_put_str_check - add string attribute to netlink message
@@ -667,13 +656,12 @@ EXPORT_SYMBOL(mnl_attr_put_u64_check);
  * This function updates the length field of the Netlink message (nlmsg_le=
n)
  * by adding the size (header + payload) of the new attribute.
  */
-bool
-mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen,
-		       uint16_t type, const char *data)
+EXPORT_SYMBOL bool
+mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type,
+                       const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data), data);
 }
-EXPORT_SYMBOL(mnl_attr_put_str_check);
=20
 /**
  * mnl_attr_put_strz_check - add string attribute to netlink message
@@ -691,13 +679,12 @@ EXPORT_SYMBOL(mnl_attr_put_str_check);
  * attribute. The function returns true if the attribute could be added
  * to the message, otherwise false is returned.
  */
-bool
-mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen,
-			uint16_t type, const char *data)
+EXPORT_SYMBOL bool
+mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen, uint16_t type,
+                        const char *data)
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data)+1, data);
 }
-EXPORT_SYMBOL(mnl_attr_put_strz_check);
=20
 /**
  * mnl_attr_nest_start_check - start an attribute nest
@@ -709,14 +696,13 @@ EXPORT_SYMBOL(mnl_attr_put_strz_check);
  * an attribute nest. If the nested attribute cannot be added then NULL,
  * otherwise valid pointer to the beginning of the nest is returned.
  */
-struct nlattr *
+EXPORT_SYMBOL struct nlattr *
 mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t buflen, uint16_t ty=
pe)
 {
 	if (nlh->nlmsg_len + MNL_ATTR_HDRLEN > buflen)
 		return NULL;
 	return mnl_attr_nest_start(nlh, type);
 }
-EXPORT_SYMBOL(mnl_attr_nest_start_check);
=20
 /**
  * mnl_attr_nest_end - end an attribute nest
@@ -725,12 +711,11 @@ EXPORT_SYMBOL(mnl_attr_nest_start_check);
  *
  * This function updates the attribute header that identifies the nest.
  */
-void
+EXPORT_SYMBOL void
 mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	start->nla_len =3D mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_end);
=20
 /**
  * mnl_attr_nest_cancel - cancel an attribute nest
@@ -739,12 +724,11 @@ EXPORT_SYMBOL(mnl_attr_nest_end);
  *
  * This function updates the attribute header that identifies the nest.
  */
-void
+EXPORT_SYMBOL void
 mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	nlh->nlmsg_len -=3D mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_cancel);
=20
 /**
  * @}
diff --git a/src/callback.c b/src/callback.c
index f023401..c626916 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -126,15 +126,14 @@ out:
  * to EPROTO. If the dump was interrupted, errno is set to EINTR and you s=
hould
  * request a new fresh dump again.
  */
-int
+EXPORT_SYMBOL int
 mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
-	    unsigned int portid, mnl_cb_t cb_data, void *data,
-	    mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
+            unsigned int portid, mnl_cb_t cb_data, void *data,
+            mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data,
 			    cb_ctl_array, cb_ctl_array_len);
 }
-EXPORT_SYMBOL(mnl_cb_run2);
=20
 /**
  * mnl_cb_run - callback runqueue for netlink messages (simplified version)
@@ -155,13 +154,12 @@ EXPORT_SYMBOL(mnl_cb_run2);
  *
  * This function propagates the callback return value.
  */
-int
+EXPORT_SYMBOL int
 mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
-	   unsigned int portid, mnl_cb_t cb_data, void *data)
+           unsigned int portid, mnl_cb_t cb_data, void *data)
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
 }
-EXPORT_SYMBOL(mnl_cb_run);
=20
 /**
  * @}
diff --git a/src/internal.h b/src/internal.h
index 3a88d1a..47a8314 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -3,8 +3,7 @@
=20
 #include "config.h"
 #ifdef HAVE_VISIBILITY_HIDDEN
-#	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
+#	define EXPORT_SYMBOL	__attribute__((visibility("default")))
 #else
 #	define EXPORT_SYMBOL
 #endif
diff --git a/src/nlmsg.c b/src/nlmsg.c
index fd2f698..8f3d755 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -51,11 +51,11 @@
  * This function returns the size of a netlink message (header plus payloa=
d)
  * without alignment.
  */
-size_t mnl_nlmsg_size(size_t len)
+EXPORT_SYMBOL size_t
+mnl_nlmsg_size(size_t len)
 {
 	return len + MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_size);
=20
 /**
  * mnl_nlmsg_get_payload_len - get the length of the Netlink payload
@@ -64,11 +64,11 @@ EXPORT_SYMBOL(mnl_nlmsg_size);
  * This function returns the Length of the netlink payload, ie. the length
  * of the full message minus the size of the Netlink header.
  */
-size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL size_t
+mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
 {
 	return nlh->nlmsg_len - MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
=20
 /**
  * mnl_nlmsg_put_header - reserve and prepare room for Netlink header
@@ -79,7 +79,8 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
  * initializes the nlmsg_len field to the size of the Netlink header. This
  * function returns a pointer to the Netlink header structure.
  */
-struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
+EXPORT_SYMBOL struct nlmsghdr *
+mnl_nlmsg_put_header(void *buf)
 {
 	int len =3D MNL_ALIGN(sizeof(struct nlmsghdr));
 	struct nlmsghdr *nlh =3D buf;
@@ -88,7 +89,6 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 	nlh->nlmsg_len =3D len;
 	return nlh;
 }
-EXPORT_SYMBOL(mnl_nlmsg_put_header);
=20
 /**
  * mnl_nlmsg_put_extra_header - reserve and prepare room for an extra head=
er
@@ -101,7 +101,7 @@ EXPORT_SYMBOL(mnl_nlmsg_put_header);
  * you call this function. This function returns a pointer to the extra
  * header.
  */
-void *
+EXPORT_SYMBOL void *
 mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 {
 	char *ptr =3D (char *)nlh + nlh->nlmsg_len;
@@ -110,7 +110,6 @@ mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t=
 size)
 	memset(ptr, 0, len);
 	return ptr;
 }
-EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
=20
 /**
  * mnl_nlmsg_get_payload - get a pointer to the payload of the netlink mes=
sage
@@ -118,11 +117,11 @@ EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
  *
  * This function returns a pointer to the payload of the netlink message.
  */
-void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL void *
+mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload);
=20
 /**
  * mnl_nlmsg_get_payload_offset - get a pointer to the payload of the mess=
age
@@ -132,12 +131,11 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload);
  * This function returns a pointer to the payload of the netlink message p=
lus
  * a given offset.
  */
-void *
+EXPORT_SYMBOL void *
 mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
=20
 /**
  * mnl_nlmsg_ok - check a there is room for netlink message
@@ -155,13 +153,13 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
  * The len parameter may become negative in malformed messages during mess=
age
  * iteration, that is why we use a signed integer.
  */
-bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
+EXPORT_SYMBOL bool
+mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
 	return len >=3D (int)sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >=3D sizeof(struct nlmsghdr) &&
 	       (int)nlh->nlmsg_len <=3D len;
 }
-EXPORT_SYMBOL(mnl_nlmsg_ok);
=20
 /**
  * mnl_nlmsg_next - get the next netlink message in a multipart message
@@ -176,13 +174,12 @@ EXPORT_SYMBOL(mnl_nlmsg_ok);
  * You have to use mnl_nlmsg_ok() to check if the next Netlink message is
  * valid.
  */
-struct nlmsghdr *
+EXPORT_SYMBOL struct nlmsghdr *
 mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
 {
 	*len -=3D MNL_ALIGN(nlh->nlmsg_len);
 	return (struct nlmsghdr *)((void *)nlh + MNL_ALIGN(nlh->nlmsg_len));
 }
-EXPORT_SYMBOL(mnl_nlmsg_next);
=20
 /**
  * mnl_nlmsg_get_payload_tail - get the ending of the netlink message
@@ -192,11 +189,11 @@ EXPORT_SYMBOL(mnl_nlmsg_next);
  * to build a message since we continue adding attributes at the end of the
  * message.
  */
-void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL void *
+mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_ALIGN(nlh->nlmsg_len);
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
=20
 /**
  * mnl_nlmsg_seq_ok - perform sequence tracking
@@ -212,12 +209,11 @@ EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
  * socket to send commands to kernel-space (that we want to track) and to
  * listen to events (that we do not track).
  */
-bool
+EXPORT_SYMBOL bool
 mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq =3D=3D seq : true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
=20
 /**
  * mnl_nlmsg_portid_ok - perform portID origin check
@@ -233,12 +229,11 @@ EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
  * to kernel-space (that we want to track) and to listen to events (that we
  * do not track).
  */
-bool
+EXPORT_SYMBOL bool
 mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid =3D=3D portid : true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
=20
 static void mnl_nlmsg_fprintf_header(FILE *fd, const struct nlmsghdr *nlh)
 {
@@ -369,9 +364,9 @@ mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsgh=
dr *nlh,
  * - N, that indicates that NLA_F_NESTED is set.
  * - B, that indicates that NLA_F_NET_BYTEORDER is set.
  */
-void
+EXPORT_SYMBOL void
 mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
-		  size_t extra_header_size)
+                  size_t extra_header_size)
 {
 	const struct nlmsghdr *nlh =3D data;
 	int len =3D datalen;
@@ -382,7 +377,6 @@ mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t da=
talen,
 		nlh =3D mnl_nlmsg_next(nlh, &len);
 	}
 }
-EXPORT_SYMBOL(mnl_nlmsg_fprintf);
=20
 /**
  * \defgroup batch Netlink message batch helpers
@@ -440,7 +434,8 @@ struct mnl_nlmsg_batch {
  * the heap, no restrictions in this regard. This function returns NULL on
  * error.
  */
-struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t limit)
+EXPORT_SYMBOL struct mnl_nlmsg_batch *
+mnl_nlmsg_batch_start(void *buf, size_t limit)
 {
 	struct mnl_nlmsg_batch *b;
=20
@@ -456,7 +451,6 @@ struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf=
, size_t limit)
=20
 	return b;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_start);
=20
 /**
  * mnl_nlmsg_batch_stop - release a batch
@@ -464,11 +458,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_start);
  *
  * This function releases the batch allocated by mnl_nlmsg_batch_start().
  */
-void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void
+mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
 {
 	free(b);
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
=20
 /**
  * mnl_nlmsg_batch_next - get room for the next message in the batch
@@ -481,7 +475,8 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
  * You have to put at least one message in the batch before calling this
  * function, otherwise your application is likely to crash.
  */
-bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL bool
+mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 {
 	struct nlmsghdr *nlh =3D b->cur;
=20
@@ -493,7 +488,6 @@ bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 	b->buflen +=3D nlh->nlmsg_len;
 	return true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_next);
=20
 /**
  * mnl_nlmsg_batch_reset - reset the batch
@@ -503,7 +497,8 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_next);
  * new one. This function moves the last message which does not fit the
  * batch to the head of the buffer, if any.
  */
-void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void
+mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 {
 	if (b->overflow) {
 		struct nlmsghdr *nlh =3D b->cur;
@@ -516,7 +511,6 @@ void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 		b->cur =3D b->buf;
 	}
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
=20
 /**
  * mnl_nlmsg_batch_size - get current size of the batch
@@ -524,11 +518,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
  *
  * This function returns the current size of the batch.
  */
-size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL size_t
+mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_size);
=20
 /**
  * mnl_nlmsg_batch_head - get head of this batch
@@ -537,11 +531,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_size);
  * This function returns a pointer to the head of the batch, which is the
  * beginning of the buffer that is used.
  */
-void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void *
+mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
 {
 	return b->buf;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_head);
=20
 /**
  * mnl_nlmsg_batch_current - returns current position in the batch
@@ -550,11 +544,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_head);
  * This function returns a pointer to the current position in the buffer
  * that is used to store the batch.
  */
-void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL void *
+mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
 {
 	return b->cur;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_current);
=20
 /**
  * mnl_nlmsg_batch_is_empty - check if there is any message in the batch
@@ -562,11 +556,11 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_current);
  *
  * This function returns true if the batch is empty.
  */
-bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
+EXPORT_SYMBOL bool
+mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen =3D=3D 0;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
=20
 /**
  * @}
diff --git a/src/socket.c b/src/socket.c
index 86657d4..bd8763e 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -82,11 +82,11 @@ struct mnl_socket {
  *
  * This function returns the file descriptor of a given netlink socket.
  */
-int mnl_socket_get_fd(const struct mnl_socket *nl)
+EXPORT_SYMBOL int
+mnl_socket_get_fd(const struct mnl_socket *nl)
 {
 	return nl->fd;
 }
-EXPORT_SYMBOL(mnl_socket_get_fd);
=20
 /**
  * mnl_socket_get_portid - obtain Netlink PortID from netlink socket
@@ -97,11 +97,11 @@ EXPORT_SYMBOL(mnl_socket_get_fd);
  * which is not always true. This is the case if you open more than one
  * socket that is binded to the same Netlink subsystem from the same proce=
ss.
  */
-unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
+EXPORT_SYMBOL unsigned int
+mnl_socket_get_portid(const struct mnl_socket *nl)
 {
 	return nl->addr.nl_pid;
 }
-EXPORT_SYMBOL(mnl_socket_get_portid);
=20
 /**
  * mnl_socket_open - open a netlink socket
@@ -110,7 +110,8 @@ EXPORT_SYMBOL(mnl_socket_get_portid);
  * On error, it returns NULL and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-struct mnl_socket *mnl_socket_open(int bus)
+EXPORT_SYMBOL struct mnl_socket *
+mnl_socket_open(int bus)
 {
 	struct mnl_socket *nl;
=20
@@ -126,7 +127,6 @@ struct mnl_socket *mnl_socket_open(int bus)
=20
 	return nl;
 }
-EXPORT_SYMBOL(mnl_socket_open);
=20
 /**
  * mnl_socket_fdopen - associates a mnl_socket object with pre-existing so=
cket.
@@ -139,7 +139,8 @@ EXPORT_SYMBOL(mnl_socket_open);
  * Note that mnl_socket_get_portid() returns 0 if this function is used wi=
th
  * non-netlink socket.
  */
-struct mnl_socket *mnl_socket_fdopen(int fd)
+EXPORT_SYMBOL struct mnl_socket *
+mnl_socket_fdopen(int fd)
 {
 	int ret;
 	struct mnl_socket *nl;
@@ -160,7 +161,6 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
=20
 	return nl;
 }
-EXPORT_SYMBOL(mnl_socket_fdopen);
=20
 /**
  * mnl_socket_bind - bind netlink socket
@@ -172,7 +172,8 @@ EXPORT_SYMBOL(mnl_socket_fdopen);
  * success, 0 is returned. You can use MNL_SOCKET_AUTOPID which is 0 for
  * automatic port ID selection.
  */
-int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
+EXPORT_SYMBOL int
+mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 {
 	int ret;
 	socklen_t addr_len;
@@ -200,7 +201,6 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int=
 groups, pid_t pid)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(mnl_socket_bind);
=20
 /**
  * mnl_socket_sendto - send a netlink message of a certain size
@@ -211,7 +211,7 @@ EXPORT_SYMBOL(mnl_socket_bind);
  * On error, it returns -1 and errno is appropriately set. Otherwise, it=
=20
  * returns the number of bytes sent.
  */
-ssize_t
+EXPORT_SYMBOL ssize_t
 mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
 {
 	static const struct sockaddr_nl snl =3D {
@@ -220,7 +220,6 @@ mnl_socket_sendto(const struct mnl_socket *nl, const vo=
id *buf, size_t len)
 	return sendto(nl->fd, buf, len, 0,=20
 		      (struct sockaddr *) &snl, sizeof(snl));
 }
-EXPORT_SYMBOL(mnl_socket_sendto);
=20
 /**
  * mnl_socket_recvfrom - receive a netlink message
@@ -236,7 +235,7 @@ EXPORT_SYMBOL(mnl_socket_sendto);
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
  */
-ssize_t
+EXPORT_SYMBOL ssize_t
 mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
 {
 	ssize_t ret;
@@ -268,7 +267,6 @@ mnl_socket_recvfrom(const struct mnl_socket *nl, void *=
buf, size_t bufsiz)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_recvfrom);
=20
 /**
  * mnl_socket_close - close a given netlink socket
@@ -277,13 +275,13 @@ EXPORT_SYMBOL(mnl_socket_recvfrom);
  * On error, this function returns -1 and errno is appropriately set.
  * On success, it returns 0.
  */
-int mnl_socket_close(struct mnl_socket *nl)
+EXPORT_SYMBOL int
+mnl_socket_close(struct mnl_socket *nl)
 {
 	int ret =3D close(nl->fd);
 	free(nl);
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_close);
=20
 /**
  * mnl_socket_setsockopt - set Netlink socket option
@@ -310,12 +308,12 @@ EXPORT_SYMBOL(mnl_socket_close);
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
-			  void *buf, socklen_t len)
+EXPORT_SYMBOL int
+mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf,
+                      socklen_t len)
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_setsockopt);
=20
 /**
  * mnl_socket_getsockopt - get a Netlink socket option
@@ -326,12 +324,12 @@ EXPORT_SYMBOL(mnl_socket_setsockopt);
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
-			  void *buf, socklen_t *len)
+EXPORT_SYMBOL int
+mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf,
+                      socklen_t *len)
 {
 	return getsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_getsockopt);
=20
 /**
  * @}
--=20
2.5.3


--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJWBMiQAAoJEJ0EcL2mzcRXSsAQAMMJ5+EkSj/8jEzBCQEAQT8A
3Q0mLVwfluKyxXws6bURlaOFwk84fBGkVlOmCnp7vkwfeIYWfhiWBl7n3SZXQHtE
OnWJGUs9mlI+lQf9gxOaQIkgUID9FuAabsT8YhN2mjuwZnaz/ac4CyZfinPDvCrZ
lAo4KdY9bwbhve6eIsiUgliJyCDEpyfhfSuhuYblwj1oNGT9UBqWHgLC52lKndkF
YxnyKJR00VgRK+k5Qm6l2pW/MyjGe39Fvl4rxgjN5v7M12VlucdxhU680opCUb2G
COYbp6IzSZ1zg3EE9IkV3qX8eJ6cprjsFp7FfnJ3veuSOgAlIGt4io2foPudWOkF
RzJshaT340KMAqwIoE2Cf44isnqBjpDdq9UdA6WV2mX52JEHAdHg4epAL/TA6Crw
diZNk9YJfxlWnakWPurbq45MYo0iNMwRAALiIk0/Nj88VGZTN7f8ertTc6RkWgTo
pjonIHgiZ4+eqCKXVWUyDPMbe2JmHrSZozAhpeqORDayvH/BKI4ZRG53AVFCH9Ca
EkR+bC06NO1rWa6tkfoAGApmytyAexCmz8zqfe2ktNDdG0s+5KmzdDuxW8I85at+
GhxPhOVRljkWpO3q5G1lH/iUc6zDRhbVsrNLC6RIThTu1KV7qrt5SLGWCI6+Opip
eb4kNAesber3g+ZGvTPr
=urHj
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
