From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/6] build: tag function headers rather than decls as exported
Date: Tue, 16 Nov 2010 12:43:31 +0100
Message-ID: <1289907814-32706-5-git-send-email-jengelh@medozas.de>
References: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47729 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933600Ab0KPLnk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Nov 2010 06:43:40 -0500
In-Reply-To: <1289907814-32706-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Make_global.am          |    2 +-
 configure.ac            |    3 +-
 include/libmnl/libmnl.h |  104 ++++++++++++++++++++++-------------------------
 m4/gcc4_visibility.m4   |   21 +++++++++
 m4/visibility.m4        |   52 -----------------------
 src/Makefile.am         |    2 -
 src/attr.c              |   71 +++++++++++++++++++-------------
 src/callback.c          |   13 ++++--
 src/internal.h          |   11 +++++
 src/nlmsg.c             |   33 +++++++++------
 src/socket.c            |   28 +++++++------
 11 files changed, 169 insertions(+), 171 deletions(-)
 create mode 100644 m4/gcc4_visibility.m4
 delete mode 100644 m4/visibility.m4
 create mode 100644 src/internal.h

diff --git a/Make_global.am b/Make_global.am
index b0dc429..a86e3e9 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -21,4 +21,4 @@
 LIBVERSION=0:0:0
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -Wall -Wextra -Wno-unused-parameter
+AM_CFLAGS = -Wall -Wextra -Wno-unused-parameter ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index 6373fab..74efa45 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,6 +3,7 @@ dnl Process this file with autoconf to create configure.
 AC_INIT([libmnl], [1.0.0-beta0])
 AC_CANONICAL_TARGET
 AC_CONFIG_MACRO_DIR([m4])
+AC_CONFIG_HEADERS([config.h])
 AM_INIT_AUTOMAKE([foreign dist-bzip2 1.6 subdir-objects])
 
 AC_PROG_CC
@@ -10,7 +11,7 @@ AM_PROG_CC_C_O
 AC_EXEEXT
 AC_DISABLE_STATIC
 LT_INIT
-gl_VISIBILITY
+CHECK_GCC_FVISIBILITY
 case $target in 
 *-*-linux*) ;;
 *) AC_MSG_ERROR([Linux only, dude!]);;
diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 01ae484..c1fffa5 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -16,12 +16,6 @@
 extern "C" {
 #endif
 
-#if defined(HAVE_VISIBILITY) && defined(BUILDING_MNL)
-#define MNL_API extern  __attribute__ ((visibility("default")))
-#else
-#define MNL_API extern
-#endif
-
 /*
  * Netlink socket API
  */
@@ -31,15 +25,15 @@ extern "C" {
 
 struct mnl_socket;
 
-MNL_API struct mnl_socket *mnl_socket_open(int type);
-MNL_API int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
-MNL_API int mnl_socket_close(struct mnl_socket *nl);
-MNL_API int mnl_socket_get_fd(const struct mnl_socket *nl);
-MNL_API unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
-MNL_API ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
-MNL_API ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
-MNL_API int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t len);
-MNL_API int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
+extern struct mnl_socket *mnl_socket_open(int type);
+extern int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid);
+extern int mnl_socket_close(struct mnl_socket *nl);
+extern int mnl_socket_get_fd(const struct mnl_socket *nl);
+extern unsigned int mnl_socket_get_portid(const struct mnl_socket *nl);
+extern ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *req, size_t siz);
+extern ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t siz);
+extern int mnl_socket_setsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t len);
+extern int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *buf, socklen_t *len);
 
 /*
  * Netlink message API
@@ -49,31 +43,31 @@ MNL_API int mnl_socket_getsockopt(const struct mnl_socket *nl, int type, void *b
 #define MNL_ALIGN(len)		(((len)+MNL_ALIGNTO-1) & ~(MNL_ALIGNTO-1))
 #define MNL_NLMSG_HDRLEN	MNL_ALIGN(sizeof(struct nlmsghdr))
 
-MNL_API size_t mnl_nlmsg_size(size_t len);
-MNL_API size_t mnl_nlmsg_total_size(size_t len);
-MNL_API size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
+extern size_t mnl_nlmsg_size(size_t len);
+extern size_t mnl_nlmsg_total_size(size_t len);
+extern size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh);
 
 /* Netlink message header builder */
-MNL_API struct nlmsghdr *mnl_nlmsg_put_header(void *buf);
-MNL_API void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size);
+extern struct nlmsghdr *mnl_nlmsg_put_header(void *buf);
+extern void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size);
 
 /* Netlink message iterators */
-MNL_API bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
-MNL_API struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len);
+extern bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len);
+extern struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len);
 
 /* Netlink sequence tracking */
-MNL_API bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq);
+extern bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq);
 
 /* Netlink portID checking */
-MNL_API bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid);
+extern bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid);
 
 /* Netlink message getters */
-MNL_API void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh);
-MNL_API void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset);
-MNL_API void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh);
+extern void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh);
+extern void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset);
+extern void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh);
 
 /* Netlink message printer */
-MNL_API void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen, size_t extra_header_size);
+extern void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen, size_t extra_header_size);
 
 /*
  * Netlink attributes API
@@ -81,31 +75,31 @@ MNL_API void mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen, size_
 #define MNL_ATTR_HDRLEN	MNL_ALIGN(sizeof(struct nlattr))
 
 /* TLV attribute getters */
-MNL_API uint16_t mnl_attr_get_type(const struct nlattr *attr);
-MNL_API uint16_t mnl_attr_get_len(const struct nlattr *attr);
-MNL_API uint16_t mnl_attr_get_payload_len(const struct nlattr *attr);
-MNL_API void *mnl_attr_get_payload(const struct nlattr *attr);
-MNL_API uint8_t mnl_attr_get_u8(const struct nlattr *attr);
-MNL_API uint16_t mnl_attr_get_u16(const struct nlattr *attr);
-MNL_API uint32_t mnl_attr_get_u32(const struct nlattr *attr);
-MNL_API uint64_t mnl_attr_get_u64(const struct nlattr *attr);
-MNL_API const char *mnl_attr_get_str(const struct nlattr *attr);
+extern uint16_t mnl_attr_get_type(const struct nlattr *attr);
+extern uint16_t mnl_attr_get_len(const struct nlattr *attr);
+extern uint16_t mnl_attr_get_payload_len(const struct nlattr *attr);
+extern void *mnl_attr_get_payload(const struct nlattr *attr);
+extern uint8_t mnl_attr_get_u8(const struct nlattr *attr);
+extern uint16_t mnl_attr_get_u16(const struct nlattr *attr);
+extern uint32_t mnl_attr_get_u32(const struct nlattr *attr);
+extern uint64_t mnl_attr_get_u64(const struct nlattr *attr);
+extern const char *mnl_attr_get_str(const struct nlattr *attr);
 
 /* TLV attribute putters */
-MNL_API void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, const void *data);
-MNL_API void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data);
-MNL_API void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data);
-MNL_API void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data);
-MNL_API void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data);
-MNL_API void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data);
-MNL_API void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data);
+extern void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, const void *data);
+extern void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data);
+extern void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data);
+extern void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data);
+extern void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data);
+extern void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data);
+extern void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data);
 
 /* TLV attribute nesting */
-MNL_API struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type);
-MNL_API void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start);
+extern struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type);
+extern void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start);
 
 /* TLV validation */
-MNL_API int mnl_attr_type_valid(const struct nlattr *attr, uint16_t maxtype);
+extern int mnl_attr_type_valid(const struct nlattr *attr, uint16_t maxtype);
 
 enum mnl_attr_data_type {
 	MNL_TYPE_UNSPEC,
@@ -123,12 +117,12 @@ enum mnl_attr_data_type {
 	MNL_TYPE_MAX,
 };
 
-MNL_API int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type);
-MNL_API int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type, size_t len);
+extern int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type);
+extern int mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type, size_t len);
 
 /* TLV iterators */
-MNL_API bool mnl_attr_ok(const struct nlattr *attr, int len);
-MNL_API struct nlattr *mnl_attr_next(const struct nlattr *attr);
+extern bool mnl_attr_ok(const struct nlattr *attr, int len);
+extern struct nlattr *mnl_attr_next(const struct nlattr *attr);
 
 #define mnl_attr_for_each(attr, nlh, offset) \
 	for ((attr) = mnl_nlmsg_get_payload_offset((nlh), (offset)); \
@@ -143,8 +137,8 @@ MNL_API struct nlattr *mnl_attr_next(const struct nlattr *attr);
 /* TLV callback-based attribute parsers */
 typedef int (*mnl_attr_cb_t)(const struct nlattr *attr, void *data);
 
-MNL_API int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset, mnl_attr_cb_t cb, void *data);
-MNL_API int mnl_attr_parse_nested(const struct nlattr *attr, mnl_attr_cb_t cb, void *data);
+extern int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset, mnl_attr_cb_t cb, void *data);
+extern int mnl_attr_parse_nested(const struct nlattr *attr, mnl_attr_cb_t cb, void *data);
 
 /*
  * callback API
@@ -155,10 +149,10 @@ MNL_API int mnl_attr_parse_nested(const struct nlattr *attr, mnl_attr_cb_t cb, v
 
 typedef int (*mnl_cb_t)(const struct nlmsghdr *nlh, void *data);
 
-MNL_API int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
+extern int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
 		      unsigned int portid, mnl_cb_t cb_data, void *data);
 
-MNL_API int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
+extern int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
 		       unsigned int portid, mnl_cb_t cb_data, void *data,
 		       mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len);
 
diff --git a/m4/gcc4_visibility.m4 b/m4/gcc4_visibility.m4
new file mode 100644
index 0000000..84959f3
--- /dev/null
+++ b/m4/gcc4_visibility.m4
@@ -0,0 +1,21 @@
+
+# GCC 4.x -fvisibility=hidden
+
+AC_DEFUN([CHECK_GCC_FVISIBILITY], [
+	AC_LANG_PUSH([C])
+	saved_CFLAGS="$CFLAGS"
+	CFLAGS="$saved_CFLAGS -fvisibility=hidden"
+	AC_CACHE_CHECK([whether compiler accepts -fvisibility=hidden],
+	  [ac_cv_fvisibility_hidden], AC_COMPILE_IFELSE(
+		AC_LANG_PROGRAM([], []),
+		[ac_cv_fvisibility_hidden=yes],
+		[ac_cv_fvisibility_hidden=no]
+	))
+	if test "$ac_cv_fvisibility_hidden" = "yes"; then
+		AC_DEFINE([HAVE_VISIBILITY_HIDDEN], [1],
+		  [True if compiler supports -fvisibility=hidden])
+		AC_SUBST([GCC_FVISIBILITY_HIDDEN], [-fvisibility=hidden])
+	fi
+	CFLAGS="$saved_CFLAGS"
+	AC_LANG_POP([C])
+])
diff --git a/m4/visibility.m4 b/m4/visibility.m4
deleted file mode 100644
index 2ff6330..0000000
--- a/m4/visibility.m4
+++ /dev/null
@@ -1,52 +0,0 @@
-# visibility.m4 serial 1 (gettext-0.15)
-dnl Copyright (C) 2005 Free Software Foundation, Inc.
-dnl This file is free software; the Free Software Foundation
-dnl gives unlimited permission to copy and/or distribute it,
-dnl with or without modifications, as long as this notice is preserved.
-
-dnl From Bruno Haible.
-
-dnl Tests whether the compiler supports the command-line option
-dnl -fvisibility=hidden and the function and variable attributes
-dnl __attribute__((__visibility__("hidden"))) and
-dnl __attribute__((__visibility__("default"))).
-dnl Does *not* test for __visibility__("protected") - which has tricky
-dnl semantics (see the 'vismain' test in glibc) and does not exist e.g. on
-dnl MacOS X.
-dnl Does *not* test for __visibility__("internal") - which has processor
-dnl dependent semantics.
-dnl Does *not* test for #pragma GCC visibility push(hidden) - which is
-dnl "really only recommended for legacy code".
-dnl Set the variable CFLAG_VISIBILITY.
-dnl Defines and sets the variable HAVE_VISIBILITY.
-
-AC_DEFUN([gl_VISIBILITY],
-[
-  AC_REQUIRE([AC_PROG_CC])
-  CFLAG_VISIBILITY=
-  HAVE_VISIBILITY=0
-  if test -n "$GCC"; then
-    AC_MSG_CHECKING([for simple visibility declarations])
-    AC_CACHE_VAL(gl_cv_cc_visibility, [
-      gl_save_CFLAGS="$CFLAGS"
-      CFLAGS="$CFLAGS -fvisibility=hidden"
-      AC_TRY_COMPILE(
-        [extern __attribute__((__visibility__("hidden"))) int hiddenvar;
-         extern __attribute__((__visibility__("default"))) int exportedvar;
-         extern __attribute__((__visibility__("hidden"))) int hiddenfunc (void);
-         extern __attribute__((__visibility__("default"))) int exportedfunc (void);],
-        [],
-        gl_cv_cc_visibility=yes,
-        gl_cv_cc_visibility=no)
-      CFLAGS="$gl_save_CFLAGS"])
-    AC_MSG_RESULT([$gl_cv_cc_visibility])
-    if test $gl_cv_cc_visibility = yes; then
-      CFLAG_VISIBILITY="-fvisibility=hidden"
-      HAVE_VISIBILITY=1
-    fi
-  fi
-  AC_SUBST([CFLAG_VISIBILITY])
-  AC_SUBST([HAVE_VISIBILITY])
-  AC_DEFINE_UNQUOTED([HAVE_VISIBILITY], [$HAVE_VISIBILITY],
-    [Define to 1 or 0, depending whether the compiler supports simple visibility declarations.])
-])
diff --git a/src/Makefile.am b/src/Makefile.am
index dd1b1b7..7e99f2c 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,6 +1,4 @@
 include $(top_srcdir)/Make_global.am
-AM_CFLAGS += $(CFLAG_VISIBILITY)
-AM_CPPFLAGS += -DBUILDING_MNL
 lib_LTLIBRARIES = libmnl.la
 
 libmnl_la_LDFLAGS = -Wl,--version-script=$(srcdir)/libmnl.map -version-info $(LIBVERSION)
diff --git a/src/attr.c b/src/attr.c
index 5137395..2eb4e0e 100644
--- a/src/attr.c
+++ b/src/attr.c
@@ -11,6 +11,7 @@
 #include <string.h>
 #include <values.h>	/* for INT_MAX */
 #include <errno.h>
+#include "internal.h"
 
 /**
  * \defgroup attr Netlink attribute helpers
@@ -35,7 +36,7 @@
  *
  * This function returns the attribute type.
  */
-uint16_t mnl_attr_get_type(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_type(const struct nlattr *attr)
 {
 	return attr->nla_type & NLA_TYPE_MASK;
 }
@@ -47,7 +48,7 @@ uint16_t mnl_attr_get_type(const struct nlattr *attr)
  * This function returns the attribute length that is the attribute header
  * plus the attribute payload.
  */
-uint16_t mnl_attr_get_len(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_len(const struct nlattr *attr)
 {
 	return attr->nla_len;
 }
@@ -58,7 +59,7 @@ uint16_t mnl_attr_get_len(const struct nlattr *attr)
  *
  * This function returns the attribute payload-value length.
  */
-uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
 {
 	return attr->nla_len - MNL_ATTR_HDRLEN;
 }
@@ -69,7 +70,7 @@ uint16_t mnl_attr_get_payload_len(const struct nlattr *attr)
  *
  * This function return a pointer to the attribute payload.
  */
-void *mnl_attr_get_payload(const struct nlattr *attr)
+EXPORT_SYMBOL void *mnl_attr_get_payload(const struct nlattr *attr)
 {
 	return (void *)attr + MNL_ATTR_HDRLEN;
 }
@@ -90,7 +91,7 @@ void *mnl_attr_get_payload(const struct nlattr *attr)
  * The len parameter may be negative in the case of malformed messages during
  * attribute iteration, that is why we use a signed integer.
  */
-bool mnl_attr_ok(const struct nlattr *attr, int len)
+EXPORT_SYMBOL bool mnl_attr_ok(const struct nlattr *attr, int len)
 {
 	return len >= (int)sizeof(struct nlattr) &&
 	       attr->nla_len >= sizeof(struct nlattr) &&
@@ -106,7 +107,7 @@ bool mnl_attr_ok(const struct nlattr *attr, int len)
  * as parameter. You have to use mnl_attr_ok() to ensure that the next
  * attribute is valid.
  */
-struct nlattr *mnl_attr_next(const struct nlattr *attr)
+EXPORT_SYMBOL struct nlattr *mnl_attr_next(const struct nlattr *attr)
 {
 	return (struct nlattr *)((void *)attr + MNL_ALIGN(attr->nla_len));
 }
@@ -125,7 +126,7 @@ struct nlattr *mnl_attr_next(const struct nlattr *attr)
  * This leads to backward compatibility breakages in user-space. Better check
  * if you support an attribute, if not, skip it.
  */
-int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
+EXPORT_SYMBOL int mnl_attr_type_valid(const struct nlattr *attr, uint16_t max)
 {
 	if (mnl_attr_get_type(attr) > max) {
 		errno = EOPNOTSUPP;
@@ -204,7 +205,8 @@ static const size_t mnl_attr_data_type_len[MNL_TYPE_MAX] = {
  * integers (u8, u16, u32 and u64) have enough room for them. This function
  * returns -1 in case of error, and errno is explicitly set.
  */
-int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
+EXPORT_SYMBOL int
+mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
 {
 	int exp_len;
 
@@ -226,8 +228,9 @@ int mnl_attr_validate(const struct nlattr *attr, enum mnl_attr_data_type type)
  * whose size is variable. If the size of the attribute is not what we expect,
  * this functions returns -1 and errno is explicitly set.
  */
-int mnl_attr_validate2(const struct nlattr *attr, 
-		       enum mnl_attr_data_type type, size_t exp_len)
+EXPORT_SYMBOL int
+mnl_attr_validate2(const struct nlattr *attr, enum mnl_attr_data_type type,
+		   size_t exp_len)
 {
 	if (type >= MNL_TYPE_MAX) {
 		errno = EINVAL;
@@ -251,8 +254,9 @@ int mnl_attr_validate2(const struct nlattr *attr,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
-		   mnl_attr_cb_t cb, void *data)
+EXPORT_SYMBOL int
+mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
+	       mnl_attr_cb_t cb, void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -277,8 +281,9 @@ int mnl_attr_parse(const struct nlmsghdr *nlh, unsigned int offset,
  * This function propagates the return value of the callback, which can be
  * MNL_CB_ERROR, MNL_CB_OK or MNL_CB_STOP.
  */
-int mnl_attr_parse_nested(const struct nlattr *nested,
-			  mnl_attr_cb_t cb, void *data)
+EXPORT_SYMBOL int
+mnl_attr_parse_nested(const struct nlattr *nested, mnl_attr_cb_t cb,
+		      void *data)
 {
 	int ret = MNL_CB_OK;
 	const struct nlattr *attr;
@@ -295,7 +300,7 @@ int mnl_attr_parse_nested(const struct nlattr *nested,
  *
  * This function returns the 8-bit value of the attribute payload.
  */
-uint8_t mnl_attr_get_u8(const struct nlattr *attr)
+EXPORT_SYMBOL uint8_t mnl_attr_get_u8(const struct nlattr *attr)
 {
 	return *((uint8_t *)mnl_attr_get_payload(attr));
 }
@@ -306,7 +311,7 @@ uint8_t mnl_attr_get_u8(const struct nlattr *attr)
  *
  * This function returns the 16-bit value of the attribute payload.
  */
-uint16_t mnl_attr_get_u16(const struct nlattr *attr)
+EXPORT_SYMBOL uint16_t mnl_attr_get_u16(const struct nlattr *attr)
 {
 	return *((uint16_t *)mnl_attr_get_payload(attr));
 }
@@ -317,7 +322,7 @@ uint16_t mnl_attr_get_u16(const struct nlattr *attr)
  *
  * This function returns the 32-bit value of the attribute payload.
  */
-uint32_t mnl_attr_get_u32(const struct nlattr *attr)
+EXPORT_SYMBOL uint32_t mnl_attr_get_u32(const struct nlattr *attr)
 {
 	return *((uint32_t *)mnl_attr_get_payload(attr));
 }
@@ -330,7 +335,7 @@ uint32_t mnl_attr_get_u32(const struct nlattr *attr)
  * function is align-safe, since accessing 64-bit Netlink attributes is a
  * common source of alignment issues.
  */
-uint64_t mnl_attr_get_u64(const struct nlattr *attr)
+EXPORT_SYMBOL uint64_t mnl_attr_get_u64(const struct nlattr *attr)
 {
 	uint64_t tmp;
 	memcpy(&tmp, mnl_attr_get_payload(attr), sizeof(tmp));
@@ -343,7 +348,7 @@ uint64_t mnl_attr_get_u64(const struct nlattr *attr)
  *
  * This function returns the payload of string attribute value.
  */
-const char *mnl_attr_get_str(const struct nlattr *attr)
+EXPORT_SYMBOL const char *mnl_attr_get_str(const struct nlattr *attr)
 {
 	return mnl_attr_get_payload(attr);
 }
@@ -358,8 +363,8 @@ const char *mnl_attr_get_str(const struct nlattr *attr)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type,
-		  size_t len, const void *data)
+EXPORT_SYMBOL void
+mnl_attr_put(struct nlmsghdr *nlh, uint16_t type, size_t len, const void *data)
 {
 	struct nlattr *attr = mnl_nlmsg_get_payload_tail(nlh);
 	uint16_t payload_len = MNL_ALIGN(sizeof(struct nlattr)) + len;
@@ -380,7 +385,8 @@ void mnl_attr_put(struct nlmsghdr *nlh, uint16_t type,
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint8_t), &data);
 }
@@ -394,7 +400,8 @@ void mnl_attr_put_u8(struct nlmsghdr *nlh, uint16_t type, uint8_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint16_t), &data);
 }
@@ -408,7 +415,8 @@ void mnl_attr_put_u16(struct nlmsghdr *nlh, uint16_t type, uint16_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint32_t), &data);
 }
@@ -422,7 +430,8 @@ void mnl_attr_put_u32(struct nlmsghdr *nlh, uint16_t type, uint32_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
+EXPORT_SYMBOL void
+mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
 {
 	mnl_attr_put(nlh, type, sizeof(uint64_t), &data);
 }
@@ -436,7 +445,8 @@ void mnl_attr_put_u64(struct nlmsghdr *nlh, uint16_t type, uint64_t data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
+EXPORT_SYMBOL void
+mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data), data);
 }
@@ -453,7 +463,8 @@ void mnl_attr_put_str(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * This function updates the length field of the Netlink message (nlmsg_len)
  * by adding the size (header + payload) of the new attribute.
  */
-void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
+EXPORT_SYMBOL void
+mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
 {
 	mnl_attr_put(nlh, type, strlen(data)+1, data);
 }
@@ -467,7 +478,8 @@ void mnl_attr_put_strz(struct nlmsghdr *nlh, uint16_t type, const char *data)
  * an attribute nest. This function always returns a valid pointer to the
  * beginning of the nest.
  */
-struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
+EXPORT_SYMBOL struct nlattr *
+mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
 {
 	struct nlattr *start = mnl_nlmsg_get_payload_tail(nlh);
 
@@ -485,7 +497,8 @@ struct nlattr *mnl_attr_nest_start(struct nlmsghdr *nlh, uint16_t type)
  *
  * This function updates the attribute header that identifies the nest.
  */
-void mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
+EXPORT_SYMBOL void
+mnl_attr_nest_end(struct nlmsghdr *nlh, struct nlattr *start)
 {
 	start->nla_len = mnl_nlmsg_get_payload_tail(nlh) - (void *)start;
 }
diff --git a/src/callback.c b/src/callback.c
index 4a8fa2d..bba19a7 100644
--- a/src/callback.c
+++ b/src/callback.c
@@ -9,6 +9,7 @@
 
 #include <errno.h>
 #include <libmnl/libmnl.h>
+#include "internal.h"
 
 static int mnl_cb_noop(const struct nlmsghdr *nlh, void *data)
 {
@@ -74,9 +75,10 @@ static const mnl_cb_t default_cb_array[NLMSG_MIN_TYPE] = {
  * is set to ESRCH. If the sequence number is not the expected, errno is set
  * to EPROTO.
  */
-int mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
-		unsigned int portid, mnl_cb_t cb_data, void *data,
-		mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
+EXPORT_SYMBOL int
+mnl_cb_run2(const void *buf, size_t numbytes, unsigned int seq,
+	    unsigned int portid, mnl_cb_t cb_data, void *data,
+	    mnl_cb_t *cb_ctl_array, unsigned int cb_ctl_array_len)
 {
 	int ret = MNL_CB_OK, len = numbytes;
 	const struct nlmsghdr *nlh = buf;
@@ -136,8 +138,9 @@ out:
  *
  * This function propagates the callback return value.
  */
-int mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
-	       unsigned int portid, mnl_cb_t cb_data, void *data)
+EXPORT_SYMBOL int
+mnl_cb_run(const void *buf, size_t numbytes, unsigned int seq,
+	   unsigned int portid, mnl_cb_t cb_data, void *data)
 {
 	return mnl_cb_run2(buf, numbytes, seq, portid, cb_data, data, NULL, 0);
 }
diff --git a/src/internal.h b/src/internal.h
new file mode 100644
index 0000000..ed8028f
--- /dev/null
+++ b/src/internal.h
@@ -0,0 +1,11 @@
+#ifndef INTERNAL_H
+#define INTERNAL_H 1
+
+#include "config.h"
+#ifdef HAVE_VISIBILITY_HIDDEN
+#	define EXPORT_SYMBOL __attribute__((visibility("default")))
+#else
+#	define EXPORT_SYMBOL
+#endif
+
+#endif
\ No newline at end of file
diff --git a/src/nlmsg.c b/src/nlmsg.c
index e05fb50..e09e46a 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -12,6 +12,7 @@
 #include <errno.h>
 #include <string.h>
 #include <libmnl/libmnl.h>
+#include "internal.h"
 
 /**
  * \defgroup nlmsg Netlink message helpers
@@ -49,7 +50,7 @@
  * This function returns the size of a netlink message (header plus payload)
  * without alignment.
  */
-size_t mnl_nlmsg_size(size_t len)
+EXPORT_SYMBOL size_t mnl_nlmsg_size(size_t len)
 {
 	return len + MNL_NLMSG_HDRLEN;
 }
@@ -73,7 +74,7 @@ size_t mnl_nlmsg_aligned_size(size_t len)
  * This function returns the Length of the netlink payload, ie. the length
  * of the full message minus the size of the Netlink header.
  */
-size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
 {
 	return nlh->nlmsg_len - MNL_NLMSG_HDRLEN;
 }
@@ -87,7 +88,7 @@ size_t mnl_nlmsg_get_payload_len(const struct nlmsghdr *nlh)
  * initializes the nlmsg_len field to the size of the Netlink header. This
  * function returns a pointer to the Netlink header structure.
  */
-struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
+EXPORT_SYMBOL struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
 {
 	int len = MNL_ALIGN(sizeof(struct nlmsghdr));
 	struct nlmsghdr *nlh = buf;
@@ -108,7 +109,8 @@ struct nlmsghdr *mnl_nlmsg_put_header(void *buf)
  * you call this function. This function returns a pointer to the extra
  * header.
  */
-void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
+EXPORT_SYMBOL void *
+mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
 {
 	char *ptr = (char *)nlh + nlh->nlmsg_len;
 	nlh->nlmsg_len += MNL_ALIGN(size);
@@ -122,7 +124,7 @@ void *mnl_nlmsg_put_extra_header(struct nlmsghdr *nlh, size_t size)
  *
  * This function returns a pointer to the payload of the netlink message.
  */
-void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN;
 }
@@ -135,7 +137,8 @@ void *mnl_nlmsg_get_payload(const struct nlmsghdr *nlh)
  * This function returns a pointer to the payload of the netlink message plus
  * a given offset.
  */
-void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
+EXPORT_SYMBOL void *
+mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
 {
 	return (void *)nlh + MNL_NLMSG_HDRLEN + MNL_ALIGN(offset);
 }
@@ -156,7 +159,7 @@ void *mnl_nlmsg_get_payload_offset(const struct nlmsghdr *nlh, size_t offset)
  * The len parameter may become negative in malformed messages during message
  * iteration, that is why we use a signed integer.
  */
-bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
+EXPORT_SYMBOL bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
 {
 	return len >= (int)sizeof(struct nlmsghdr) &&
 	       nlh->nlmsg_len >= sizeof(struct nlmsghdr) &&
@@ -176,7 +179,8 @@ bool mnl_nlmsg_ok(const struct nlmsghdr *nlh, int len)
  * You have to use mnl_nlmsg_ok() to check if the next Netlink message is
  * valid.
  */
-struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
+EXPORT_SYMBOL struct nlmsghdr *
+mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
 {
 	*len -= MNL_ALIGN(nlh->nlmsg_len);
 	return (struct nlmsghdr *)((void *)nlh + MNL_ALIGN(nlh->nlmsg_len));
@@ -190,7 +194,7 @@ struct nlmsghdr *mnl_nlmsg_next(const struct nlmsghdr *nlh, int *len)
  * to build a message since we continue adding attributes at the end of the
  * message.
  */
-void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
+EXPORT_SYMBOL void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
 {
 	return (void *)nlh + MNL_ALIGN(nlh->nlmsg_len);
 }
@@ -209,7 +213,8 @@ void *mnl_nlmsg_get_payload_tail(const struct nlmsghdr *nlh)
  * socket to send commands to kernel-space (that we want to track) and to
  * listen to events (that we do not track).
  */
-bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
+EXPORT_SYMBOL bool
+mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
 {
 	return nlh->nlmsg_seq && seq ? nlh->nlmsg_seq == seq : true;
 }
@@ -228,7 +233,8 @@ bool mnl_nlmsg_seq_ok(const struct nlmsghdr *nlh, unsigned int seq)
  * to kernel-space (that we want to track) and to listen to events (that we
  * do not track).
  */
-bool mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
+EXPORT_SYMBOL bool
+mnl_nlmsg_portid_ok(const struct nlmsghdr *nlh, unsigned int portid)
 {
 	return nlh->nlmsg_pid && portid ? nlh->nlmsg_pid == portid : true;
 }
@@ -362,8 +368,9 @@ mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
  * - N, that indicates that NLA_F_NESTED is set.
  * - B, that indicates that NLA_F_NET_BYTEORDER is set.
  */
-void mnl_nlmsg_fprintf(FILE *fd, const void *data,
-		       size_t datalen, size_t extra_header_size)
+EXPORT_SYMBOL void
+mnl_nlmsg_fprintf(FILE *fd, const void *data, size_t datalen,
+		  size_t extra_header_size)
 {
 	const struct nlmsghdr *nlh = data;
 	int len = datalen;
diff --git a/src/socket.c b/src/socket.c
index 9b102e7..5e33568 100644
--- a/src/socket.c
+++ b/src/socket.c
@@ -14,6 +14,7 @@
 #include <unistd.h>
 #include <time.h>
 #include <errno.h>
+#include "internal.h"
 
 /**
  * \mainpage
@@ -78,7 +79,7 @@ struct mnl_socket {
  *
  * This function returns the file descriptor of a given netlink socket.
  */
-int mnl_socket_get_fd(const struct mnl_socket *nl)
+EXPORT_SYMBOL int mnl_socket_get_fd(const struct mnl_socket *nl)
 {
 	return nl->fd;
 }
@@ -92,7 +93,7 @@ int mnl_socket_get_fd(const struct mnl_socket *nl)
  * which is not always true. This is the case if you open more than one
  * socket that is binded to the same Netlink subsystem from the same process.
  */
-unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
+EXPORT_SYMBOL unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
 {
 	return nl->addr.nl_pid;
 }
@@ -104,7 +105,7 @@ unsigned int mnl_socket_get_portid(const struct mnl_socket *nl)
  * On error, it returns -1 and errno is appropriately set. Otherwise, it
  * returns a valid pointer to the mnl_socket structure.
  */
-struct mnl_socket *mnl_socket_open(int bus)
+EXPORT_SYMBOL struct mnl_socket *mnl_socket_open(int bus)
 {
 	struct mnl_socket *nl;
 
@@ -131,7 +132,8 @@ struct mnl_socket *mnl_socket_open(int bus)
  * success, 0 is returned. You can use MNL_SOCKET_AUTOPID which is 0 for
  * automatic port ID selection.
  */
-int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
+EXPORT_SYMBOL int
+mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
 {
 	int ret;
 	socklen_t addr_len;
@@ -169,8 +171,8 @@ int mnl_socket_bind(struct mnl_socket *nl, unsigned int groups, pid_t pid)
  * On error, it returns -1 and errno is appropriately set. Otherwise, it 
  * returns the number of bytes sent.
  */
-ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
-			  size_t len)
+EXPORT_SYMBOL ssize_t
+mnl_socket_sendto(const struct mnl_socket *nl, const void *buf, size_t len)
 {
 	static const struct sockaddr_nl snl = {
 		.nl_family = AF_NETLINK
@@ -193,8 +195,8 @@ ssize_t mnl_socket_sendto(const struct mnl_socket *nl, const void *buf,
  * buffer size ensures that your buffer is big enough to store the netlink
  * message without truncating it.
  */
-ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
-			    size_t bufsiz)
+EXPORT_SYMBOL ssize_t
+mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf, size_t bufsiz)
 {
 	ssize_t ret;
 	struct sockaddr_nl addr;
@@ -233,7 +235,7 @@ ssize_t mnl_socket_recvfrom(const struct mnl_socket *nl, void *buf,
  * On error, this function returns -1 and errno is appropriately set.
  * On success, it returns 0.
  */
-int mnl_socket_close(struct mnl_socket *nl)
+EXPORT_SYMBOL int mnl_socket_close(struct mnl_socket *nl)
 {
 	int ret = close(nl->fd);
 	free(nl);
@@ -265,8 +267,8 @@ int mnl_socket_close(struct mnl_socket *nl)
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
-			  void *buf, socklen_t len)
+EXPORT_SYMBOL int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
+					void *buf, socklen_t len)
 {
 	return setsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
@@ -280,8 +282,8 @@ int mnl_socket_setsockopt(const struct mnl_socket *nl, int type,
  *
  * On error, this function returns -1 and errno is appropriately set.
  */
-int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
-			  void *buf, socklen_t *len)
+EXPORT_SYMBOL int mnl_socket_getsockopt(const struct mnl_socket *nl, int type,
+					void *buf, socklen_t *len)
 {
 	return getsockopt(nl->fd, SOL_NETLINK, type, buf, len);
 }
-- 
1.7.1

