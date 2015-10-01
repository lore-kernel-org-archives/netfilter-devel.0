From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: [PATCH] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Thu, 1 Oct 2015 18:05:21 +0700
Message-ID: <20151001110521.GA11642@oxygen>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:36714 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbbJALGr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 07:06:47 -0400
Received: by pablk4 with SMTP id lk4so71278852pab.3
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Oct 2015 04:06:46 -0700 (PDT)
Received: from oxygen (cm-27-145-116-2.revip12.asianet.co.th. [27.145.116.2])
        by smtp.gmail.com with ESMTPSA id w5sm6037892pbs.31.2015.10.01.04.06.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2015 04:06:45 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* libmnl using an export map (-Wl,--version-script=3D),
  hence, no need to explicitly use the EXPORT_SYMBOL() tags.

  Drop the EXPORT_SYMBOL() tags also fix the failed to build with
  clang.

Signed-off-by: Neutron Soutmun <neo.neutron@gmail.com>
---
 configure.ac   |  1 -
 src/attr.c     | 35 -----------------------------------
 src/callback.c |  2 --
 src/internal.h |  6 ------
 src/nlmsg.c    | 20 --------------------
 src/socket.c   | 10 ----------
 6 files changed, 74 deletions(-)

diff --git a/configure.ac b/configure.ac
index 313a015..4cb59a9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -15,7 +15,6 @@ AM_PROG_CC_C_O
 AC_EXEEXT
 AC_DISABLE_STATIC
 LT_INIT
-CHECK_GCC_FVISIBILITY
 case "$host" in
 *-*-linux* | *-*-uclinux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
diff --git a/src/attr.c b/src/attr.c
index c551d0b..b7db7a7 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -39,7 +39,6 @@ uint16_t mnl_attr_get_type(const struct nlattr *attr)
 {
 	return attr->nla_type & NLA_TYPE_MASK;
 }
-EXPORT_SYMBOL(mnl_attr_get_type);
=20
 /**
  * mnl_attr_get_len - get length of netlink attribute
@@ -52,7 +51,6 @@ uint16_t mnl_attr_get_len(const struct nlattr *attr)
 {
 	return attr->nla_len;
 }
-EXPORT_SYMBOL(mnl_attr_get_len);
=20
 /**
  * mnl_attr_get_payload_len - get the attribute payload-value length
@@ -64,7 +62,6 @@ uint16_t mnl_attr_get_payload_len(const struct nlattr *at=
tr)
 {
 	return attr->nla_len - MNL_ATTR_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_attr_get_payload_len);
=20
 /**
  * mnl_attr_get_payload - get pointer to the attribute payload
@@ -76,7 +73,6 @@ void *mnl_attr_get_payload(const struct nlattr *attr)
 {
 	return (void *)attr + MNL_ATTR_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_attr_get_payload);
=20
 /**
  * mnl_attr_ok - check if there is room for an attribute in a buffer
@@ -100,7 +96,6 @@ bool mnl_attr_ok(const struct nlattr *attr, int len)
 	       attr->nla_len >=3D sizeof(struct nlattr) &&
 	       (int)attr->nla_len <=3D len;
 }
-EXPORT_SYMBOL(mnl_attr_ok);
=20
 /**
  * mnl_attr_next - get the next attribute in the payload of a netlink mess=
age
@@ -114,7 +109,6 @@ struct nlattr *mnl_attr_next(const struct nlattr *attr)
 {
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
 }
-EXPORT_SYMBOL(mnl_attr_next);
=20
 /**
  * mnl_attr_type_valid - check if the attribute type is valid
@@ -138,7 +132,6 @@ int mnl_attr_type_valid(const struct nlattr *attr, uint=
16_t max)
 	}
 	return 1;
 }
-EXPORT_SYMBOL(mnl_attr_type_valid);
=20
 static int __mnl_attr_validate(const struct nlattr *attr,
 			       enum mnl_attr_data_type type, size_t exp_len)
@@ -222,7 +215,6 @@ int mnl_attr_validate(const struct nlattr *attr, enum m=
nl_attr_data_type type)
 	exp_len =3D mnl_attr_data_type_len[type];
 	return __mnl_attr_validate(attr, type, exp_len);
 }
-EXPORT_SYMBOL(mnl_attr_validate);
=20
 /**
  * mnl_attr_validate2 - validate netlink attribute (extended version)
@@ -244,7 +236,6 @@ mnl_attr_validate2(const struct nlattr *attr, enum mnl_=
attr_data_type type,
 	}
 	return __mnl_attr_validate(attr, type, exp_len);
 }
-EXPORT_SYMBOL(mnl_attr_validate2);
=20
 /**
  * mnl_attr_parse - parse attributes
@@ -273,7 +264,6 @@ mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int=
 offset,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse);
=20
 /**
  * mnl_attr_parse_nested - parse attributes inside a nest
@@ -301,7 +291,6 @@ mnl_attr_parse_nested(const struct nlattr *nested, mnl_=
attr_cb_t cb,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse_nested);
=20
 /**
  * mnl_attr_parse_payload - parse attributes in payload of Netlink message
@@ -334,7 +323,6 @@ mnl_attr_parse_payload(const void *payload, size_t payl=
oad_len,
 			return ret;
 	return ret;
 }
-EXPORT_SYMBOL(mnl_attr_parse_payload);
=20
 /**
  * mnl_attr_get_u8 - returns 8-bit unsigned integer attribute payload
@@ -346,7 +334,6 @@ uint8_t mnl_attr_get_u8(const struct nlattr *attr)
 {
 	return *((uint8_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u8);
=20
 /**
  * mnl_attr_get_u16 - returns 16-bit unsigned integer attribute payload
@@ -358,7 +345,6 @@ uint16_t mnl_attr_get_u16(const struct nlattr *attr)
 {
 	return *((uint16_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u16);
=20
 /**
  * mnl_attr_get_u32 - returns 32-bit unsigned integer attribute payload
@@ -370,7 +356,6 @@ uint32_t mnl_attr_get_u32(const struct nlattr *attr)
 {
 	return *((uint32_t *)mnl_attr_get_payload(attr));
 }
-EXPORT_SYMBOL(mnl_attr_get_u32);
=20
 /**
  * mnl_attr_get_u64 - returns 64-bit unsigned integer attribute.
@@ -386,7 +371,6 @@ uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 	memcpy(&tmp, mnl_attr_get_payload(attr), sizeof(tmp));
 	return tmp;
 }
-EXPORT_SYMBOL(mnl_attr_get_u64);
=20
 /**
  * mnl_attr_get_str - returns pointer to string attribute.
@@ -398,7 +382,6 @@ const char *mnl_attr_get_str(const struct nlattr *attr)
 {
 	return mnl_attr_get_payload(attr);
 }
-EXPORT_SYMBOL(mnl_attr_get_str);
=20
 /**
  * mnl_attr_put - add an attribute to netlink message
@@ -421,7 +404,6 @@ mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_=
t len, const void *data)
 	memcpy(mnl_attr_get_payload(attr), data, len);
 	nlh->nlmsg_len +=3D MNL_ALIGN(payload_len);
 }
-EXPORT_SYMBOL(mnl_attr_put);
=20
 /**
  * mnl_attr_put_u8 - add 8-bit unsigned integer attribute to netlink messa=
ge
@@ -436,7 +418,6 @@ void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t typ=
e, uint8_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint8_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u8);
=20
 /**
  * mnl_attr_put_u16 - add 16-bit unsigned integer attribute to netlink mes=
sage
@@ -451,7 +432,6 @@ void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t ty=
pe, uint16_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint16_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u16);
=20
 /**
  * mnl_attr_put_u32 - add 32-bit unsigned integer attribute to netlink mes=
sage
@@ -466,7 +446,6 @@ void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t ty=
pe, uint32_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint32_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u32);
=20
 /**
  * mnl_attr_put_u64 - add 64-bit unsigned integer attribute to netlink mes=
sage
@@ -481,7 +460,6 @@ void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t ty=
pe, uint64_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u64);
=20
 /**
  * mnl_attr_put_str - add string attribute to netlink message
@@ -496,7 +474,6 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t ty=
pe, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
 }
-EXPORT_SYMBOL(mnl_attr_put_str);
=20
 /**
  * mnl_attr_put_strz - add string attribute to netlink message
@@ -514,7 +491,6 @@ void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t t=
ype, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
-EXPORT_SYMBOL(mnl_attr_put_strz);
=20
 /**
  * mnl_attr_nest_start - start an attribute nest
@@ -535,7 +511,6 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh=
, uint16_t type)
=20
 	return start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_start);
=20
 /**
  * mnl_attr_put_check - add an attribute to netlink message
@@ -560,7 +535,6 @@ mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen,
 	mnl_attr_put(nlh, type, len, data);
 	return true;
 }
-EXPORT_SYMBOL(mnl_attr_put_check);
=20
 /**
  * mnl_attr_put_u8_check - add 8-bit unsigned int attribute to netlink mes=
sage
@@ -581,7 +555,6 @@ mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t bufl=
en,
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint8_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u8_check);
=20
 /**
  * mnl_attr_put_u16_check - add 16-bit unsigned int attribute to netlink m=
essage
@@ -604,7 +577,6 @@ mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buf=
len,
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint16_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u16_check);
=20
 /**
  * mnl_attr_put_u32_check - add 32-bit unsigned int attribute to netlink m=
essage
@@ -627,7 +599,6 @@ mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buf=
len,
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint32_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u32_check);
=20
 /**
  * mnl_attr_put_u64_check - add 64-bit unsigned int attribute to netlink m=
essage
@@ -650,7 +621,6 @@ mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buf=
len,
 {
 	return mnl_attr_put_check(nlh, buflen, type, sizeof(uint64_t), &data);
 }
-EXPORT_SYMBOL(mnl_attr_put_u64_check);
=20
 /**
  * mnl_attr_put_str_check - add string attribute to netlink message
@@ -673,7 +643,6 @@ mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buf=
len,
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data), data);
 }
-EXPORT_SYMBOL(mnl_attr_put_str_check);
=20
 /**
  * mnl_attr_put_strz_check - add string attribute to netlink message
@@ -697,7 +666,6 @@ mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t bu=
flen,
 {
 	return mnl_attr_put_check(nlh, buflen, type, strlen(data)+1, data);
 }
-EXPORT_SYMBOL(mnl_attr_put_strz_check);
=20
 /**
  * mnl_attr_nest_start_check - start an attribute nest
@@ -716,7 +684,6 @@ mnl_attr_nest_start_check(struct nlmsghdr *nlh, size_t =
buflen, uint16_t type)
 		return NULL;
 	return mnl_attr_nest_start(nlh, type);
 }
-EXPORT_SYMBOL(mnl_attr_nest_start_check);
=20
 /**
  * mnl_attr_nest_end - end an attribute nest
@@ -730,7 +697,6 @@ mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *=
start)
 {
 	start->nla_len =3D mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_end);
=20
 /**
  * mnl_attr_nest_cancel - cancel an attribute nest
@@ -744,7 +710,6 @@ mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlatt=
r *start)
 {
 	nlh->nlmsg_len -=3D mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
-EXPORT_SYMBOL(mnl_attr_nest_cancel);
=20
 /**
  * @}
diff --git a/src/callback.c b/src/callback.c
index f023401..0ecd430 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -134,7 +134,6 @@ mnl_cb_run2(const void *buf, size_t numbytes, unsigned =
int seq,
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data,
 			    cb_ctl_array, cb_ctl_array_len);
 }
-EXPORT_SYMBOL(mnl_cb_run2);
=20
 /**
  * mnl_cb_run - callback runqueue for netlink messages (simplified version)
@@ -161,7 +160,6 @@ mnl_cb_run(const void *buf, size_t numbytes, unsigned i=
nt seq,
 {
 	return __mnl_cb_run(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
 }
-EXPORT_SYMBOL(mnl_cb_run);
=20
 /**
  * @}
diff --git a/src/internal.h b/src/internal.h
index 3a88d1a..1012df2 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -2,11 +2,5 @@
 #define INTERNAL_H 1
=20
 #include "config.h"
-#ifdef HAVE_VISIBILITY_HIDDEN
-#	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
-#else
-#	define EXPORT_SYMBOL
-#endif
=20
 #endif
diff --git a/src/nlmsg.c b/src/nlmsg.c
index fd2f698..6662d0b 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -55,7 +55,6 @@ size_t mnl_nlmsg_size(size_t len)
 {
 	return len + MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_size);
=20
 /**
  * mnl_nlmsg_get_payload_len - get the length of the Netlink payload
@@ -68,7 +67,6 @@ size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *n=
lh)
 {
 	return nlh->nlmsg_len - MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_len);
=20
 /**
  * mnl_nlmsg_put_header - reserve and prepare room for Netlink header
@@ -88,7 +86,6 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 	nlh->nlmsg_len =3D len;
 	return nlh;
 }
-EXPORT_SYMBOL(mnl_nlmsg_put_header);
=20
 /**
  * mnl_nlmsg_put_extra_header - reserve and prepare room for an extra head=
er
@@ -110,7 +107,6 @@ mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t=
 size)
 	memset(ptr, 0, len);
 	return ptr;
 }
-EXPORT_SYMBOL(mnl_nlmsg_put_extra_header);
=20
 /**
  * mnl_nlmsg_get_payload - get a pointer to the payload of the netlink mes=
sage
@@ -122,7 +118,6 @@ void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN;
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload);
=20
 /**
  * mnl_nlmsg_get_payload_offset - get a pointer to the payload of the mess=
age
@@ -137,7 +132,6 @@ mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh=
, size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_offset);
=20
 /**
  * mnl_nlmsg_ok - check a there is room for netlink message
@@ -161,7 +155,6 @@ bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 	       nlh->nlmsg_len >=3D sizeof(struct nlmsghdr) &&
 	       (int)nlh->nlmsg_len <=3D len;
 }
-EXPORT_SYMBOL(mnl_nlmsg_ok);
=20
 /**
  * mnl_nlmsg_next - get the next netlink message in a multipart message
@@ -182,7 +175,6 @@ mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
 	*len -=3D MNL_ALIGN(nlh->nlmsg_len);
 	return (struct nlmsghdr *)((void *)nlh + MNL_ALIGN(nlh->nlmsg_len));
 }
-EXPORT_SYMBOL(mnl_nlmsg_next);
=20
 /**
  * mnl_nlmsg_get_payload_tail - get the ending of the netlink message
@@ -196,7 +188,6 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr =
*nlh)
 {
 	return (void *)nlh + MNL_ALIGN(nlh->nlmsg_len);
 }
-EXPORT_SYMBOL(mnl_nlmsg_get_payload_tail);
=20
 /**
  * mnl_nlmsg_seq_ok - perform sequence tracking
@@ -217,7 +208,6 @@ mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned i=
nt seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq =3D=3D seq : true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_seq_ok);
=20
 /**
  * mnl_nlmsg_portid_ok - perform portID origin check
@@ -238,7 +228,6 @@ mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigne=
d int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid =3D=3D portid : true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_portid_ok);
=20
 static void mnl_nlmsg_fprintf_header(FILE *fd, const struct nlmsghdr *nlh)
 {
@@ -382,7 +371,6 @@ mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t da=
talen,
 		nlh =3D mnl_nlmsg_next(nlh, &len);
 	}
 }
-EXPORT_SYMBOL(mnl_nlmsg_fprintf);
=20
 /**
  * \defgroup batch Netlink message batch helpers
@@ -456,7 +444,6 @@ struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf=
, size_t limit)
=20
 	return b;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_start);
=20
 /**
  * mnl_nlmsg_batch_stop - release a batch
@@ -468,7 +455,6 @@ void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b)
 {
 	free(b);
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
=20
 /**
  * mnl_nlmsg_batch_next - get room for the next message in the batch
@@ -493,7 +479,6 @@ bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 	b->buflen +=3D nlh->nlmsg_len;
 	return true;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_next);
=20
 /**
  * mnl_nlmsg_batch_reset - reset the batch
@@ -516,7 +501,6 @@ void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b)
 		b->cur =3D b->buf;
 	}
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_reset);
=20
 /**
  * mnl_nlmsg_batch_size - get current size of the batch
@@ -528,7 +512,6 @@ size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_size);
=20
 /**
  * mnl_nlmsg_batch_head - get head of this batch
@@ -541,7 +524,6 @@ void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b)
 {
 	return b->buf;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_head);
=20
 /**
  * mnl_nlmsg_batch_current - returns current position in the batch
@@ -554,7 +536,6 @@ void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b)
 {
 	return b->cur;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_current);
=20
 /**
  * mnl_nlmsg_batch_is_empty - check if there is any message in the batch
@@ -566,7 +547,6 @@ bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b)
 {
 	return b->buflen =3D=3D 0;
 }
-EXPORT_SYMBOL(mnl_nlmsg_batch_is_empty);
=20
 /**
  * @}
diff --git a/src/socket.c b/src/socket.c
index 86657d4..ee0277a 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -86,7 +86,6 @@ int mnl_socket_get_fd(const struct mnl_socket *nl)
 {
 	return nl->fd;
 }
-EXPORT_SYMBOL(mnl_socket_get_fd);
=20
 /**
  * mnl_socket_get_portid - obtain Netlink PortID from netlink socket
@@ -101,7 +100,6 @@ unsigned int mnl_socket_get_portid(const struct mnl_soc=
ket *nl)
 {
 	return nl->addr.nl_pid;
 }
-EXPORT_SYMBOL(mnl_socket_get_portid);
=20
 /**
  * mnl_socket_open - open a netlink socket
@@ -126,7 +124,6 @@ struct mnl_socket *mnl_socket_open(int bus)
=20
 	return nl;
 }
-EXPORT_SYMBOL(mnl_socket_open);
=20
 /**
  * mnl_socket_fdopen - associates a mnl_socket object with pre-existing so=
cket.
@@ -160,7 +157,6 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
=20
 	return nl;
 }
-EXPORT_SYMBOL(mnl_socket_fdopen);
=20
 /**
  * mnl_socket_bind - bind netlink socket
@@ -200,7 +196,6 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int=
 groups, pid_t pid)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(mnl_socket_bind);
=20
 /**
  * mnl_socket_sendto - send a netlink message of a certain size
@@ -220,7 +215,6 @@ mnl_socket_sendto(const struct mnl_socket *nl, const vo=
id *buf, size_t len)
 	return sendto(nl->fd, buf, len, 0,=20
 		      (struct sockaddr *) &snl, sizeof(snl));
 }
-EXPORT_SYMBOL(mnl_socket_sendto);
=20
 /**
  * mnl_socket_recvfrom - receive a netlink message
@@ -268,7 +262,6 @@ mnl_socket_recvfrom(const struct mnl_socket *nl, void *=
buf, size_t bufsiz)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_recvfrom);
=20
 /**
  * mnl_socket_close - close a given netlink socket
@@ -283,7 +276,6 @@ int mnl_socket_close(struct mnl_socket *nl)
 	free(nl);
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_close);
=20
 /**
  * mnl_socket_setsockopt - set Netlink socket option
@@ -315,7 +307,6 @@ int mnl_socket_setsockopt(const struct mnl_socket *nl, =
int type,
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_setsockopt);
=20
 /**
  * mnl_socket_getsockopt - get a Netlink socket option
@@ -331,7 +322,6 @@ int mnl_socket_getsockopt(const struct mnl_socket *nl, =
int type,
 {
 	return getsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_getsockopt);
=20
 /**
  * @}
--=20
2.5.3


--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJWDRNxAAoJEJ0EcL2mzcRXp8cQAMAG28+QdaXC56wWca3Tzm9y
sbF4gxCKQvrEKoa334MKqAG7cXhvnyb15n7dGAESMqzeFZbLlHGTBRAgGiY8gRGB
1/NddPUIyc96lhUkaNCUgbdzSQmaUXp6p3/z3ETab5yg7xUrTzV5ozq8cUFsnzuR
NcYRmtMKUAbYNW28uaVNdCuolvuhLbhEylq29f+RwYGCrSGXDBuRI4EStLFHN6EZ
1yFhzHRfs1iG7fZbXtzT6lFT6/dH+wtKtlElk2SrrUx10iqSWdwlD6n3Sr32OEzg
SYaNkiY/+AE912NpdhYOWHWz54tAQINfs9fjKKdyK6uoTf0UyePCZa8Fg76SdV7q
4AJXv1as5DVSGjiY3hcp4n81Gy/s80TI2g3BFpxzFpe4a4ZqjP8DEF5kRPiuIf98
Q3Agbkw3w3O/EsPhUENnXbuxG+dvHbIF2M+p4xKimg+sI9aWLksBz535C08uc2ch
nYA7dOViVCziPSiDD6GwO19N4xilTjaHmiItDN7LsdhVu9XGhsoV7U1N1fTZKnfj
anYvRPbKuxe3RbaKgCrcgzFKJonBZDDZ0shtpwxf9Jzh6wYjg1uGeCseY184MuS0
tPtzKDM/2SlCfyOHGEcdH+FopDgv2MWhNZeoTTLv3FQkVJs2qCt+4dOxYCTWruC0
ybVz/r5+qMRc0BZxIZtm
=a9c9
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
