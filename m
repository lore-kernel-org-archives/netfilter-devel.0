From: Mike Frysinger <vapier@gentoo.org>
Subject: Re: [PATCH v4] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Thu, 29 Oct 2015 15:07:17 -0400
Message-ID: <20151029190717.GE5154@vapier.lan>
Reply-To: 20151006012711.GA5372@oxygen.gentoo.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="EgVrEAR5UttbsTXg"
Cc: neo.neutron@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:56404 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbbJ2THT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 15:07:19 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--EgVrEAR5UttbsTXg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Neutron Soutmun wrote:
> * libmnl using an export map (-Wl,--version-script=3D),
>  hence, no need to explicitly use the EXPORT_SYMBOL() tags.

this isn't entirely accurate.  the use of hidden visibility allows for
optimizations (e.g. bypassing the PLT).  export maps merely control the
final visibility of the symbols at link time ... gcc is forced to assume
every function call otherwise is still globally visible (exported).

it doesn't make a big difference in the libmnl case as there aren't any
real internal-only symbols, but in larger libraries, this sort of change
increases code size and runtime overhead.

this is why libraries take a different approach: set default visibility
to hidden and then update the header with a macro like EXPORT.  there is
only one file to declare the prototypes and the visibility markings are
right there.  no need for EXPORT_SYMBOL() lines.  the export map is only
really for toolchains that lack visibility support.

something as simple as the patch below
-mike

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 5adb13c..787882e 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -12,6 +12,10 @@
 extern "C" {
 #endif
=20
+#ifndef MNL_EXPORT
+# define MNL_EXPORT extern
+#endif
+
 /*
  * Netlink socket API
  */
@@ -21,17 +25,17 @@ extern "C" {
=20
 struct mnl_socket;
=20
-extern struct mnl_socket *mnl_socket_open(int bus);
-extern struct mnl_socket *mnl_socket_open2(int bus, int flags);
-extern struct mnl_socket *mnl_socket_fdopen(int fd);
-extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid=
_t pid);
-extern int mnl_socket_close(struct mnl_socket *nl);
-extern int mnl_socket_get_fd(const struct mnl_socket *nl);
-extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
-extern ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *=
req, size_t siz);
-extern ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,=
 size_t siz);
-extern int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, vo=
id *buf, socklen_t len);
-extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, vo=
id *buf, socklen_t *len);
+MNL_EXPORT struct mnl_socket *mnl_socket_open(int bus);
+MNL_EXPORT struct mnl_socket *mnl_socket_open2(int bus, int flags);
+MNL_EXPORT struct mnl_socket *mnl_socket_fdopen(int fd);
+MNL_EXPORT int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups,=
 pid_t pid);
+MNL_EXPORT int mnl_socket_close(struct mnl_socket *nl);
+MNL_EXPORT int mnl_socket_get_fd(const struct mnl_socket *nl);
+MNL_EXPORT unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
+MNL_EXPORT ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const vo=
id *req, size_t siz);
+MNL_EXPORT ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *=
buf, size_t siz);
+MNL_EXPORT int mnl_socket_setsockopt(const struct mnl_socket *nl, int type=
, void *buf, socklen_t len);
+MNL_EXPORT int mnl_socket_getsockopt(const struct mnl_socket *nl, int type=
, void *buf, socklen_t *len);
=20
 /*
  * Netlink message API
@@ -41,41 +45,41 @@ extern int mnl_socket_getsockopt(const struct mnl_socke=
t *nl, int type, void *bu
 #define MNL_ALIGN(len)		(((len)+MNL_ALIGNTO-1) & ~(MNL_ALIGNTO-1))
 #define MNL_NLMSG_HDRLEN	MNL_ALIGN(sizeof(struct nlmsghdr))
=20
-extern size_t mnl_nlmsg_size(size_t len);
-extern size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
+MNL_EXPORT size_t mnl_nlmsg_size(size_t len);
+MNL_EXPORT size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
=20
 /* Netlink message header builder */
-extern struct nlmsghdr *mnl_nlmsg_put_header(void *buf);
-extern void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size);
+MNL_EXPORT struct nlmsghdr *mnl_nlmsg_put_header(void *buf);
+MNL_EXPORT void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t s=
ize);
=20
 /* Netlink message iterators */
-extern bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
-extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *le=
n);
+MNL_EXPORT bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
+MNL_EXPORT struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int=
 *len);
=20
 /* Netlink sequence tracking */
-extern bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq);
+MNL_EXPORT bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int =
seq);
=20
 /* Netlink portID checking */
-extern bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int p=
ortid);
+MNL_EXPORT bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned i=
nt portid);
=20
 /* Netlink message getters */
-extern void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh);
-extern void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size=
_t offset);
-extern void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh);
+MNL_EXPORT void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh);
+MNL_EXPORT void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, =
size_t offset);
+MNL_EXPORT void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh);
=20
 /* Netlink message printer */
-extern void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen, =
size_t extra_header_size);
+MNL_EXPORT void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datal=
en, size_t extra_header_size);
=20
 /* Message batch helpers */
 struct mnl_nlmsg_batch;
-extern struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t buf=
siz);
-extern bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b);
-extern void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b);
-extern size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b);
-extern void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b);
-extern void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b);
-extern void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b);
-extern bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b);
+MNL_EXPORT struct mnl_nlmsg_batch *mnl_nlmsg_batch_start(void *buf, size_t=
 bufsiz);
+MNL_EXPORT bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b);
+MNL_EXPORT void mnl_nlmsg_batch_stop(struct mnl_nlmsg_batch *b);
+MNL_EXPORT size_t mnl_nlmsg_batch_size(struct mnl_nlmsg_batch *b);
+MNL_EXPORT void mnl_nlmsg_batch_reset(struct mnl_nlmsg_batch *b);
+MNL_EXPORT void *mnl_nlmsg_batch_head(struct mnl_nlmsg_batch *b);
+MNL_EXPORT void *mnl_nlmsg_batch_current(struct mnl_nlmsg_batch *b);
+MNL_EXPORT bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_batch *b);
=20
 /*
  * Netlink attributes API
@@ -83,42 +87,42 @@ extern bool mnl_nlmsg_batch_is_empty(struct mnl_nlmsg_b=
atch *b);
 #define MNL_ATTR_HDRLEN	MNL_ALIGN(sizeof(struct nlattr))
=20
 /* TLV attribute getters */
-extern uint16_t mnl_attr_get_type(const struct nlattr *attr);
-extern uint16_t mnl_attr_get_len(const struct nlattr *attr);
-extern uint16_t mnl_attr_get_payload_len(const struct nlattr *attr);
-extern void *mnl_attr_get_payload(const struct nlattr *attr);
-extern uint8_t mnl_attr_get_u8(const struct nlattr *attr);
-extern uint16_t mnl_attr_get_u16(const struct nlattr *attr);
-extern uint32_t mnl_attr_get_u32(const struct nlattr *attr);
-extern uint64_t mnl_attr_get_u64(const struct nlattr *attr);
-extern const char *mnl_attr_get_str(const struct nlattr *attr);
+MNL_EXPORT uint16_t mnl_attr_get_type(const struct nlattr *attr);
+MNL_EXPORT uint16_t mnl_attr_get_len(const struct nlattr *attr);
+MNL_EXPORT uint16_t mnl_attr_get_payload_len(const struct nlattr *attr);
+MNL_EXPORT void *mnl_attr_get_payload(const struct nlattr *attr);
+MNL_EXPORT uint8_t mnl_attr_get_u8(const struct nlattr *attr);
+MNL_EXPORT uint16_t mnl_attr_get_u16(const struct nlattr *attr);
+MNL_EXPORT uint32_t mnl_attr_get_u32(const struct nlattr *attr);
+MNL_EXPORT uint64_t mnl_attr_get_u64(const struct nlattr *attr);
+MNL_EXPORT const char *mnl_attr_get_str(const struct nlattr *attr);
=20
 /* TLV attribute putters */
-extern void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, =
const void *data);
-extern void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t d=
ata);
-extern void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t=
 data);
-extern void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t=
 data);
-extern void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t=
 data);
-extern void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const ch=
ar *data);
-extern void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const c=
har *data);
+MNL_EXPORT void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t l=
en, const void *data);
+MNL_EXPORT void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8=
_t data);
+MNL_EXPORT void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint=
16_t data);
+MNL_EXPORT void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint=
32_t data);
+MNL_EXPORT void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint=
64_t data);
+MNL_EXPORT void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, cons=
t char *data);
+MNL_EXPORT void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, con=
st char *data);
=20
 /* TLV attribute putters with buffer boundary checkings */
-extern bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen, uint16=
_t type, size_t len, const void *data);
-extern bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen, uin=
t16_t type, uint8_t data);
-extern bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen, ui=
nt16_t type, uint16_t data);
-extern bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen, ui=
nt16_t type, uint32_t data);
-extern bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen, ui=
nt16_t type, uint64_t data);
-extern bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen, ui=
nt16_t type, const char *data);
-extern bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t buflen, u=
int16_t type, const char *data);
+MNL_EXPORT bool mnl_attr_put_check(struct nlmsghdr *nlh, size_t buflen, ui=
nt16_t type, size_t len, const void *data);
+MNL_EXPORT bool mnl_attr_put_u8_check(struct nlmsghdr *nlh, size_t buflen,=
 uint16_t type, uint8_t data);
+MNL_EXPORT bool mnl_attr_put_u16_check(struct nlmsghdr *nlh, size_t buflen=
, uint16_t type, uint16_t data);
+MNL_EXPORT bool mnl_attr_put_u32_check(struct nlmsghdr *nlh, size_t buflen=
, uint16_t type, uint32_t data);
+MNL_EXPORT bool mnl_attr_put_u64_check(struct nlmsghdr *nlh, size_t buflen=
, uint16_t type, uint64_t data);
+MNL_EXPORT bool mnl_attr_put_str_check(struct nlmsghdr *nlh, size_t buflen=
, uint16_t type, const char *data);
+MNL_EXPORT bool mnl_attr_put_strz_check(struct nlmsghdr *nlh, size_t bufle=
n, uint16_t type, const char *data);
=20
 /* TLV attribute nesting */
-extern struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t t=
ype);
-extern struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, size=
_t buflen, uint16_t type);
-extern void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start);
-extern void mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *star=
t);
+MNL_EXPORT struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16=
_t type);
+MNL_EXPORT struct nlattr *mnl_attr_nest_start_check(struct nlmsghdr *nlh, =
size_t buflen, uint16_t type);
+MNL_EXPORT void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *sta=
rt);
+MNL_EXPORT void mnl_attr_nest_cancel(struct nlmsghdr *nlh, struct nlattr *=
start);
=20
 /* TLV validation */
-extern int mnl_attr_type_valid(const struct nlattr *attr, uint16_t maxtype=
);
+MNL_EXPORT int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max=
type);
=20
 enum mnl_attr_data_type {
 	MNL_TYPE_UNSPEC,
@@ -136,12 +140,12 @@ enum mnl_attr_data_type {
 	MNL_TYPE_MAX,
 };
=20
-extern int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data=
_type type);
-extern int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_dat=
a_type type, size_t len);
+MNL_EXPORT int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_=
data_type type);
+MNL_EXPORT int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr=
_data_type type, size_t len);
=20
 /* TLV iterators */
-extern bool mnl_attr_ok(const struct nlattr *attr, int len);
-extern struct nlattr *mnl_attr_next(const struct nlattr *attr);
+MNL_EXPORT bool mnl_attr_ok(const struct nlattr *attr, int len);
+MNL_EXPORT struct nlattr *mnl_attr_next(const struct nlattr *attr);
=20
 #define mnl_attr_for_each(attr, nlh, offset) \
 	for ((attr) =3D mnl_nlmsg_get_payload_offset((nlh), (offset)); \
@@ -161,9 +165,9 @@ extern struct nlattr *mnl_attr_next(const struct nlattr=
 *attr);
 /* TLV callback-based attribute parsers */
 typedef int (*mnl_attr_cb_t)(const struct nlattr *attr, void *data);
=20
-extern int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,=
 mnl_attr_cb_t cb, void *data);
-extern int mnl_attr_parse_nested(const struct nlattr *attr, mnl_attr_cb_t =
cb, void *data);
-extern int mnl_attr_parse_payload(const void *payload, size_t payload_len,=
 mnl_attr_cb_t cb, void *data);
+MNL_EXPORT int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int off=
set, mnl_attr_cb_t cb, void *data);
+MNL_EXPORT int mnl_attr_parse_nested(const struct nlattr *attr, mnl_attr_c=
b_t cb, void *data);
+MNL_EXPORT int mnl_attr_parse_payload(const void *payload, size_t payload_=
len, mnl_attr_cb_t cb, void *data);
=20
 /*
  * callback API
@@ -174,10 +178,10 @@ extern int mnl_attr_parse_payload(const void *payload=
, size_t payload_len, mnl_a
=20
 typedef int (*mnl_cb_t)(const struct nlmsghdr *nlh, void *data);
=20
-extern int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
+MNL_EXPORT int mnl_cb_run(const void *buf, size_t numbytes, unsigned int s=
eq,
 		      unsigned int portid, mnl_cb_t cb_data, void *data);
=20
-extern int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
+MNL_EXPORT int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int =
seq,
 		       unsigned int portid, mnl_cb_t cb_data, void *data,
 		       mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len);
=20
@@ -194,7 +198,7 @@ extern int mnl_cb_run2(const void *buf, size_t numbytes=
, unsigned int seq,
 #endif
=20
 #ifdef __cplusplus
-} /* extern "C" */
+} /* MNL_EXPORT "C" */
 #endif
=20
 #endif
diff --git a/src/attr.c b/src/attr.c
index c551d0b..55b0f8c 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -6,11 +6,11 @@
  * by the Free Software Foundation; either version 2.1 of the License, or
  * (at your option) any later version.
  */
+#include "internal.h"
 #include <limits.h>	/* for INT_MAX */
 #include <libmnl/libmnl.h>
 #include <string.h>
 #include <errno.h>
-#include "internal.h"
=20
 /**
  * \defgroup attr Netlink attribute helpers
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
index f023401..a7a1791 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -7,9 +7,9 @@
  * (at your option) any later version.
  */
=20
+#include "internal.h"
 #include <errno.h>
 #include <libmnl/libmnl.h>
-#include "internal.h"
=20
 static int mnl_cb_noop(const struct nlmsghdr *nlh, void *data)
 {
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
index 3a88d1a..7592c09 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -3,10 +3,7 @@
=20
 #include "config.h"
 #ifdef HAVE_VISIBILITY_HIDDEN
-#	define __visible	__attribute__((visibility("default")))
-#	define EXPORT_SYMBOL(x)	typeof(x) (x) __visible
-#else
-#	define EXPORT_SYMBOL
+#	define MNL_EXPORT extern __attribute__((visibility("default")))
 #endif
=20
 #endif
diff --git a/src/nlmsg.c b/src/nlmsg.c
index fd2f698..9c6b223 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -6,6 +6,7 @@
  * by the Free Software Foundation; either version 2.1 of the License, or
  * (at your option) any later version.
  */
+#include "internal.h"
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -13,7 +14,6 @@
 #include <errno.h>
 #include <string.h>
 #include <libmnl/libmnl.h>
-#include "internal.h"
=20
 /**
  * \defgroup nlmsg Netlink message helpers
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
index d63ab87..40f5c6f 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -7,6 +7,7 @@
  * (at your option) any later version.
  */
=20
+#include "internal.h"
 #include <libmnl/libmnl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
@@ -14,7 +15,6 @@
 #include <unistd.h>
 #include <time.h>
 #include <errno.h>
-#include "internal.h"
=20
 /**
  * \mainpage
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
 static struct mnl_socket *__mnl_socket_open(int bus, int flags)
 {
@@ -131,7 +129,6 @@ struct mnl_socket *mnl_socket_open(int bus)
 {
 	return __mnl_socket_open(bus, 0);
 }
-EXPORT_SYMBOL(mnl_socket_open);
=20
 /**
  * mnl_socket_open2 - open a netlink socket with appropriate flags
@@ -149,7 +146,6 @@ struct mnl_socket *mnl_socket_open2(int bus, int flags)
 {
 	return __mnl_socket_open(bus, flags);
 }
-EXPORT_SYMBOL(mnl_socket_open2);
=20
 /**
  * mnl_socket_fdopen - associates a mnl_socket object with pre-existing so=
cket.
@@ -183,7 +179,6 @@ struct mnl_socket *mnl_socket_fdopen(int fd)
=20
 	return nl;
 }
-EXPORT_SYMBOL(mnl_socket_fdopen);
=20
 /**
  * mnl_socket_bind - bind netlink socket
@@ -223,7 +218,6 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int=
 groups, pid_t pid)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(mnl_socket_bind);
=20
 /**
  * mnl_socket_sendto - send a netlink message of a certain size
@@ -243,7 +237,6 @@ mnl_socket_sendto(const struct mnl_socket *nl, const vo=
id *buf, size_t len)
 	return sendto(nl->fd, buf, len, 0,=20
 		      (struct sockaddr *) &snl, sizeof(snl));
 }
-EXPORT_SYMBOL(mnl_socket_sendto);
=20
 /**
  * mnl_socket_recvfrom - receive a netlink message
@@ -291,7 +284,6 @@ mnl_socket_recvfrom(const struct mnl_socket *nl, void *=
buf, size_t bufsiz)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_recvfrom);
=20
 /**
  * mnl_socket_close - close a given netlink socket
@@ -306,7 +298,6 @@ int mnl_socket_close(struct mnl_socket *nl)
 	free(nl);
 	return ret;
 }
-EXPORT_SYMBOL(mnl_socket_close);
=20
 /**
  * mnl_socket_setsockopt - set Netlink socket option
@@ -338,7 +329,6 @@ int mnl_socket_setsockopt(const struct mnl_socket *nl, =
int type,
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_setsockopt);
=20
 /**
  * mnl_socket_getsockopt - get a Netlink socket option
@@ -354,7 +344,6 @@ int mnl_socket_getsockopt(const struct mnl_socket *nl, =
int type,
 {
 	return getsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-EXPORT_SYMBOL(mnl_socket_getsockopt);
=20
 /**
  * @}

--EgVrEAR5UttbsTXg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWMm5lAAoJEEFjO5/oN/WB10gP/RHnXEkUdn9RfCQV1rh5G1E7
BPLetjbApMtjTj6kDeorZzTJr/AIPumDwlgEgerjTNNNXkzI6CzWKkD6qsvxozo4
rqZ9WsShLmCmeNMW2oL5yaO+ugUgcIotHQeUB3Tad5CgXygVQkCYGwqcQitJ2DaI
4cvNE20hXvVSagRYuBmJJposqpiTa/3FAr3NbfmqUrnDEPRk7cXEQe8NaVDviHRH
B7T0C7eKfC0BfKSUBWDnMp8u+nR0PvtNJjOlMKfBX3pw0wDtNTxP39r9xTvvV47K
yKZLCqdsboivzZcicbOkRm6Ylhr06TQyRmMgld3dBKDQALlzzmvDjQ1yhpPqq3xS
rq277Z/YLUFMt8o/2eAMTVyKfFGIqVf6CPggPaWHsds/mPt5hEoa+tdU0lm+oyys
jVS4NCA6kcsGEJ86FHb+5/lpAhE7yyIkaYSIjXIR+DK6YImekaX4nOfmS7OwKhuF
P5tTe4cCQrCzlfrh+nk06fhFqCx9zQY2bsvO71izQ8DeKNba+CI3LAP42I6+sQi0
ANWduhfa++YUZzSySsFR7em7SWbO70gvaV1Aie+Xp5gOpjqZd9HEvFFreAV7Ksra
gMKBY7UVVmAVDAmPuBE7nqVc3cL6WpCO+fkaHX7b+ucptgsVqGhf2lMdHIdBWCh4
ZynyJyhPf7VhpwYp/GwZ
=0bKK
-----END PGP SIGNATURE-----

--EgVrEAR5UttbsTXg--
