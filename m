From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] build: implement export symbols
Date: Fri, 31 Dec 2010 00:40:09 +0100
Message-ID: <1293752411-12923-5-git-send-email-jengelh@medozas.de>
References: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50216 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752378Ab0L3XkS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:40:18 -0500
In-Reply-To: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This removed the rtnl symbols (7 pieces) that are not usable (there
are no prototypes in libnfnetlink.h) from the .dynsym section of the
library.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 .gitignore            |    1 +
 Make_global.am        |    2 +-
 configure.ac          |    2 +
 m4/gcc4_visibility.m4 |   21 +++++++
 src/iftable.c         |   23 ++++----
 src/internal.h        |   12 ++++
 src/libnfnetlink.c    |  159 ++++++++++++++++++++++++++++---------------------
 7 files changed, 140 insertions(+), 80 deletions(-)
 create mode 100644 m4/gcc4_visibility.m4
 create mode 100644 src/internal.h

diff --git a/.gitignore b/.gitignore
index 6f5ca1f..8c311aa 100644
--- a/.gitignore
+++ b/.gitignore
@@ -15,5 +15,6 @@ Makefile.in
 /libtool
 /ltmain.sh
 /missing
+/stamp-h1
 
 /*.pc
diff --git a/Make_global.am b/Make_global.am
index f091860..1837a62 100644
--- a/Make_global.am
+++ b/Make_global.am
@@ -5,4 +5,4 @@
 LIBVERSION=2:0:2
 
 AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall ${GCC_FVISIBILITY_HIDDEN}
diff --git a/configure.ac b/configure.ac
index dedf2f8..c99f07d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,6 +2,7 @@ dnl Process this file with autoconf to create configure.
 
 AC_INIT(libnfnetlink, 1.0.0)
 AC_CONFIG_MACRO_DIR([m4])
+AC_CONFIG_HEADERS([config.h])
 AC_CANONICAL_HOST
 
 AM_INIT_AUTOMAKE([-Wall foreign subdir-objects dist-bzip2 1.6])
@@ -10,6 +11,7 @@ AC_PROG_CC
 AC_EXEEXT
 AC_DISABLE_STATIC
 AM_PROG_LIBTOOL
+CHECK_GCC_FVISIBILITY
 
 case "$host" in 
 *-*-linux*) ;;
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
diff --git a/src/iftable.c b/src/iftable.c
index 959249a..9767408 100644
--- a/src/iftable.c
+++ b/src/iftable.c
@@ -23,6 +23,7 @@
 #include <libnfnetlink/libnfnetlink.h>
 #include "rtnl.h"
 #include "linux_list.h"
+#include "internal.h"
 
 struct ifindex_node {
 	struct list_head head;
@@ -146,9 +147,8 @@ static int iftable_del(struct nlmsghdr *n, void *arg)
  * \param name interface name, pass a buffer of IFNAMSIZ size
  * \return -1 on error, 1 on success 
  */
-int nlif_index2name(struct nlif_handle *h, 
-		    unsigned int index,
-		    char *name)
+EXPORT_SYMBOL int
+nlif_index2name(struct nlif_handle *h, unsigned int index, char *name)
 {
 	unsigned int hash;
 	struct ifindex_node *this;
@@ -180,9 +180,10 @@ int nlif_index2name(struct nlif_handle *h,
  * \param flags pointer to variable used to store the interface flags
  * \return -1 on error, 1 on success 
  */
-int nlif_get_ifflags(const struct nlif_handle *h,
-		     unsigned int index,
-		     unsigned int *flags)
+EXPORT_SYMBOL int
+nlif_get_ifflags(const struct nlif_handle *h,
+		 unsigned int index,
+		 unsigned int *flags)
 {
 	unsigned int hash;
 	struct ifindex_node *this;
@@ -213,7 +214,7 @@ int nlif_get_ifflags(const struct nlif_handle *h,
  *
  * \return file descriptor to netlink socket
  */
-struct nlif_handle *nlif_open(void)
+EXPORT_SYMBOL struct nlif_handle *nlif_open(void)
 {
 	int i;
 	struct nlif_handle *h;
@@ -258,7 +259,7 @@ err:
  * \param nlif_handle A pointer to a ::nlif_handle created 
  * via nlif_open()
  */
-void nlif_close(struct nlif_handle *h)
+EXPORT_SYMBOL void nlif_close(struct nlif_handle *h)
 {
 	int i;
 	struct ifindex_node *this, *tmp;
@@ -285,7 +286,7 @@ void nlif_close(struct nlif_handle *h)
  * \param nlif_handle A pointer to a ::nlif_handle created
  * \return 0 if OK
  */
-int nlif_catch(struct nlif_handle *h)
+EXPORT_SYMBOL int nlif_catch(struct nlif_handle *h)
 {
 	assert(h != NULL);
 
@@ -299,7 +300,7 @@ int nlif_catch(struct nlif_handle *h)
  * nlif_query - request a dump of interfaces available in the system
  * @h: pointer to a valid nlif_handler
  */
-int nlif_query(struct nlif_handle *h)
+EXPORT_SYMBOL int nlif_query(struct nlif_handle *h)
 {
 	assert(h != NULL);
 
@@ -314,7 +315,7 @@ int nlif_query(struct nlif_handle *h)
  * \param nlif_handle A pointer to a ::nlif_handle created
  * \return The fd or -1 if there's an error
  */
-int nlif_fd(struct nlif_handle *h)
+EXPORT_SYMBOL int nlif_fd(struct nlif_handle *h)
 {
 	assert(h != NULL);
 
diff --git a/src/internal.h b/src/internal.h
new file mode 100644
index 0000000..a6aa7d1
--- /dev/null
+++ b/src/internal.h
@@ -0,0 +1,12 @@
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
+#endif /* INTERNAL_H */
+
diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index 6e7afc6..fdd7d01 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -50,6 +50,7 @@
 #include <linux/netlink.h>
 
 #include <libnfnetlink/libnfnetlink.h>
+#include "internal.h"
 
 #ifndef NETLINK_ADD_MEMBERSHIP
 #define NETLINK_ADD_MEMBERSHIP 1
@@ -94,7 +95,8 @@ struct nfnl_handle {
 	struct nfnl_subsys_handle subsys[NFNL_MAX_SUBSYS+1];
 };
 
-void nfnl_dump_packet(struct nlmsghdr *nlh, int received_len, char *desc)
+EXPORT_SYMBOL void
+nfnl_dump_packet(struct nlmsghdr *nlh, int received_len, char *desc)
 {
 	void *nlmsg_data = NLMSG_DATA(nlh);
 	struct nfattr *nfa = NFM_NFA(NLMSG_DATA(nlh));
@@ -125,7 +127,7 @@ void nfnl_dump_packet(struct nlmsghdr *nlh, int received_len, char *desc)
  * Use this function if you need to interact with the socket. Common
  * scenarios are the use of poll()/select() to achieve multiplexation.
  */
-int nfnl_fd(struct nfnl_handle *h)
+EXPORT_SYMBOL int nfnl_fd(struct nfnl_handle *h)
 {
 	assert(h);
 	return h->fd;
@@ -135,7 +137,7 @@ int nfnl_fd(struct nfnl_handle *h)
  * nfnl_portid - returns the Netlink port ID of this socket
  * @h: nfnetlink handler
  */
-unsigned int nfnl_portid(const struct nfnl_handle *h)
+EXPORT_SYMBOL unsigned int nfnl_portid(const struct nfnl_handle *h)
 {
 	assert(h);
 	return h->local.nl_pid;
@@ -169,7 +171,7 @@ static int recalc_rebind_subscriptions(struct nfnl_handle *nfnlh)
  * On success, a valid address that points to a nfnl_handle structure
  * is returned. On error, NULL is returned and errno is set approapiately.
  */
-struct nfnl_handle *nfnl_open(void)
+EXPORT_SYMBOL struct nfnl_handle *nfnl_open(void)
 {
 	struct nfnl_handle *nfnlh;
 	unsigned int addr_len;
@@ -232,7 +234,7 @@ err_free:
  * nfnl_set_sequence_tracking - set netlink sequence tracking
  * @h: nfnetlink handler
  */
-void nfnl_set_sequence_tracking(struct nfnl_handle *h)
+EXPORT_SYMBOL void nfnl_set_sequence_tracking(struct nfnl_handle *h)
 {
 	h->flags |= NFNL_F_SEQTRACK_ENABLED;
 }
@@ -241,7 +243,7 @@ void nfnl_set_sequence_tracking(struct nfnl_handle *h)
  * nfnl_unset_sequence_tracking - set netlink sequence tracking
  * @h: nfnetlink handler
  */
-void nfnl_unset_sequence_tracking(struct nfnl_handle *h)
+EXPORT_SYMBOL void nfnl_unset_sequence_tracking(struct nfnl_handle *h)
 {
 	h->flags &= ~NFNL_F_SEQTRACK_ENABLED;
 }
@@ -254,7 +256,8 @@ void nfnl_unset_sequence_tracking(struct nfnl_handle *h)
  * This function sets the size of the receive buffer size, i.e. the size
  * of the buffer used by nfnl_recv. Default value is 4096 bytes.
  */
-void nfnl_set_rcv_buffer_size(struct nfnl_handle *h, unsigned int size)
+EXPORT_SYMBOL void
+nfnl_set_rcv_buffer_size(struct nfnl_handle *h, unsigned int size)
 {
 	h->rcv_buffer_size = size;
 }
@@ -274,7 +277,7 @@ void nfnl_set_rcv_buffer_size(struct nfnl_handle *h, unsigned int size)
  * On error, NULL is returned and errno is set appropiately. On success,
  * a valid address that points to a nfnl_subsys_handle structure is returned.
  */
-struct nfnl_subsys_handle *
+EXPORT_SYMBOL struct nfnl_subsys_handle *
 nfnl_subsys_open(struct nfnl_handle *nfnlh, u_int8_t subsys_id,
 		 u_int8_t cb_count, u_int32_t subscriptions)
 {
@@ -319,7 +322,7 @@ nfnl_subsys_open(struct nfnl_handle *nfnlh, u_int8_t subsys_id,
  *
  * Release all the callbacks registered in a subsystem handler.
  */
-void nfnl_subsys_close(struct nfnl_subsys_handle *ssh)
+EXPORT_SYMBOL void nfnl_subsys_close(struct nfnl_subsys_handle *ssh)
 {
 	assert(ssh);
 
@@ -338,7 +341,7 @@ void nfnl_subsys_close(struct nfnl_subsys_handle *ssh)
  * This function closes the nfnetlink handler. On success, 0 is returned.
  * On error, -1 is returned and errno is set appropiately.
  */
-int nfnl_close(struct nfnl_handle *nfnlh)
+EXPORT_SYMBOL int nfnl_close(struct nfnl_handle *nfnlh)
 {
 	int i, ret;
 
@@ -368,7 +371,8 @@ int nfnl_close(struct nfnl_handle *nfnlh)
  * On success, 0 is returned. On error, -1 is returned and errno is set
  * approapiately.
  */
-int nfnl_join(const struct nfnl_handle *nfnlh, unsigned int group)
+EXPORT_SYMBOL int
+nfnl_join(const struct nfnl_handle *nfnlh, unsigned int group)
 {
 	assert(nfnlh);
 	return setsockopt(nfnlh->fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP,
@@ -383,7 +387,7 @@ int nfnl_join(const struct nfnl_handle *nfnlh, unsigned int group)
  * On success, the number of bytes is returned. On error, -1 is returned 
  * and errno is set appropiately.
  */
-int nfnl_send(struct nfnl_handle *nfnlh, struct nlmsghdr *n)
+EXPORT_SYMBOL int nfnl_send(struct nfnl_handle *nfnlh, struct nlmsghdr *n)
 {
 	assert(nfnlh);
 	assert(n);
@@ -394,8 +398,9 @@ int nfnl_send(struct nfnl_handle *nfnlh, struct nlmsghdr *n)
 		      (struct sockaddr *)&nfnlh->peer, sizeof(nfnlh->peer));
 }
 
-int nfnl_sendmsg(const struct nfnl_handle *nfnlh, const struct msghdr *msg,
-		 unsigned int flags)
+EXPORT_SYMBOL int
+nfnl_sendmsg(const struct nfnl_handle *nfnlh, const struct msghdr *msg,
+	     unsigned int flags)
 {
 	assert(nfnlh);
 	assert(msg);
@@ -403,8 +408,9 @@ int nfnl_sendmsg(const struct nfnl_handle *nfnlh, const struct msghdr *msg,
 	return sendmsg(nfnlh->fd, msg, flags);
 }
 
-int nfnl_sendiov(const struct nfnl_handle *nfnlh, const struct iovec *iov,
-		 unsigned int num, unsigned int flags)
+EXPORT_SYMBOL int
+nfnl_sendiov(const struct nfnl_handle *nfnlh, const struct iovec *iov,
+	     unsigned int num, unsigned int flags)
 {
 	struct msghdr msg;
 
@@ -435,12 +441,13 @@ int nfnl_sendiov(const struct nfnl_handle *nfnlh, const struct iovec *iov,
  * pointer to the netlink message passed must point to a memory region of
  * at least the size of struct nlmsghdr + struct nfgenmsg.
  */
-void nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
-		    struct nlmsghdr *nlh, unsigned int len, 
-		    u_int8_t family,
-		    u_int16_t res_id,
-		    u_int16_t msg_type,
-		    u_int16_t msg_flags)
+EXPORT_SYMBOL void
+nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
+	      struct nlmsghdr *nlh, unsigned int len, 
+	      u_int8_t family,
+	      u_int16_t res_id,
+	      u_int16_t msg_type,
+	      u_int16_t msg_flags)
 {
 	assert(ssh);
 	assert(nlh);
@@ -467,7 +474,7 @@ void nfnl_fill_hdr(struct nfnl_subsys_handle *ssh,
 	nfg->res_id = htons(res_id);
 }
 
-struct nfattr *
+EXPORT_SYMBOL struct nfattr *
 nfnl_parse_hdr(const struct nfnl_handle *nfnlh,
 		const struct nlmsghdr *nlh,
 		struct nfgenmsg **genmsg)
@@ -503,7 +510,7 @@ nfnl_parse_hdr(const struct nfnl_handle *nfnlh,
  * Note that ENOBUFS is returned in case that nfnetlink is exhausted. In
  * that case is possible that the information requested is incomplete.
  */
-ssize_t 
+EXPORT_SYMBOL ssize_t 
 nfnl_recv(const struct nfnl_handle *h, unsigned char *buf, size_t len)
 {
 	socklen_t addrlen;
@@ -561,9 +568,10 @@ nfnl_recv(const struct nfnl_handle *h, unsigned char *buf, size_t len)
  * appropiately. For that reason, the use of this function is DEPRECATED. 
  * Please, use nfnl_receive_process() instead.
  */
-int nfnl_listen(struct nfnl_handle *nfnlh,
-		int (*handler)(struct sockaddr_nl *, struct nlmsghdr *n,
-			       void *), void *jarg)
+EXPORT_SYMBOL int
+nfnl_listen(struct nfnl_handle *nfnlh,
+	    int (*handler)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
+	    void *jarg)
 {
 	struct sockaddr_nl nladdr;
 	char buf[NFNL_BUFFSIZE] __attribute__ ((aligned));
@@ -670,10 +678,11 @@ int nfnl_listen(struct nfnl_handle *nfnlh,
  * set appropiately. For that reason, the use of this function is DEPRECATED.
  * Please, use nfnl_query() instead.
  */
-int nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,
-	      unsigned groups, struct nlmsghdr *answer,
-	      int (*junk)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
-	      void *jarg)
+EXPORT_SYMBOL int
+nfnl_talk(struct nfnl_handle *nfnlh, struct nlmsghdr *n, pid_t peer,
+	  unsigned groups, struct nlmsghdr *answer,
+	  int (*junk)(struct sockaddr_nl *, struct nlmsghdr *n, void *),
+	  void *jarg)
 {
 	char buf[NFNL_BUFFSIZE] __attribute__ ((aligned));
 	struct sockaddr_nl nladdr;
@@ -794,8 +803,9 @@ cont:
  * @data: content of new attribute
  * @len: attribute length
  */
-int nfnl_addattr_l(struct nlmsghdr *n, int maxlen, int type, const void *data,
-		   int alen)
+EXPORT_SYMBOL int
+nfnl_addattr_l(struct nlmsghdr *n, int maxlen, int type, const void *data,
+	       int alen)
 {
 	int len = NFA_LENGTH(alen);
 	struct nfattr *nfa;
@@ -827,8 +837,9 @@ int nfnl_addattr_l(struct nlmsghdr *n, int maxlen, int type, const void *data,
  * @alen: length of new attribute
  *
  */
-int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type, 
-		       const void *data, int alen)
+EXPORT_SYMBOL int
+nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type, 
+		   const void *data, int alen)
 {
 	struct nfattr *subnfa;
 	int len = NFA_LENGTH(alen);
@@ -859,7 +870,8 @@ int nfnl_nfa_addattr_l(struct nfattr *nfa, int maxlen, int type,
  * @type: type of new attribute
  * @data: content of new attribute
  */
-int nfnl_addattr8(struct nlmsghdr *n, int maxlen, int type, u_int8_t data)
+EXPORT_SYMBOL int
+nfnl_addattr8(struct nlmsghdr *n, int maxlen, int type, u_int8_t data)
 {
 	assert(n);
 	assert(maxlen > 0);
@@ -877,8 +889,8 @@ int nfnl_addattr8(struct nlmsghdr *n, int maxlen, int type, u_int8_t data)
  * @data: content of new attribute
  *
  */
-int nfnl_nfa_addattr16(struct nfattr *nfa, int maxlen, int type, 
-		       u_int16_t data)
+EXPORT_SYMBOL int
+nfnl_nfa_addattr16(struct nfattr *nfa, int maxlen, int type, u_int16_t data)
 {
 	assert(nfa);
 	assert(maxlen > 0);
@@ -896,8 +908,8 @@ int nfnl_nfa_addattr16(struct nfattr *nfa, int maxlen, int type,
  * @data: content of new attribute
  *
  */
-int nfnl_addattr16(struct nlmsghdr *n, int maxlen, int type,
-		   u_int16_t data)
+EXPORT_SYMBOL int
+nfnl_addattr16(struct nlmsghdr *n, int maxlen, int type, u_int16_t data)
 {
 	assert(n);
 	assert(maxlen > 0);
@@ -915,8 +927,8 @@ int nfnl_addattr16(struct nlmsghdr *n, int maxlen, int type,
  * @data: content of new attribute
  *
  */
-int nfnl_nfa_addattr32(struct nfattr *nfa, int maxlen, int type, 
-		       u_int32_t data)
+EXPORT_SYMBOL int
+nfnl_nfa_addattr32(struct nfattr *nfa, int maxlen, int type, u_int32_t data)
 {
 	assert(nfa);
 	assert(maxlen > 0);
@@ -934,8 +946,8 @@ int nfnl_nfa_addattr32(struct nfattr *nfa, int maxlen, int type,
  * @data: content of new attribute
  *
  */
-int nfnl_addattr32(struct nlmsghdr *n, int maxlen, int type,
-		   u_int32_t data)
+EXPORT_SYMBOL int
+nfnl_addattr32(struct nlmsghdr *n, int maxlen, int type, u_int32_t data)
 {
 	assert(n);
 	assert(maxlen > 0);
@@ -955,7 +967,8 @@ int nfnl_addattr32(struct nlmsghdr *n, int maxlen, int type,
  * The returned value is equal to the number of remaining bytes of the netlink
  * message that cannot be parsed.
  */
-int nfnl_parse_attr(struct nfattr *tb[], int max, struct nfattr *nfa, int len)
+EXPORT_SYMBOL int
+nfnl_parse_attr(struct nfattr *tb[], int max, struct nfattr *nfa, int len)
 {
 	assert(tb);
 	assert(max > 0);
@@ -982,8 +995,9 @@ int nfnl_parse_attr(struct nfattr *tb[], int max, struct nfattr *nfa, int len)
  * @val: pointer to buffer containing 'value'
  *
  */ 
-void nfnl_build_nfa_iovec(struct iovec *iov, struct nfattr *nfa, 
-			  u_int16_t type, u_int32_t len, unsigned char *val)
+EXPORT_SYMBOL void
+nfnl_build_nfa_iovec(struct iovec *iov, struct nfattr *nfa, 
+		     u_int16_t type, u_int32_t len, unsigned char *val)
 {
 	assert(iov);
 	assert(nfa);
@@ -1013,7 +1027,8 @@ void nfnl_build_nfa_iovec(struct iovec *iov, struct nfattr *nfa,
  *
  * This function returns the new size of the socket buffer.
  */
-unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h, unsigned int size)
+EXPORT_SYMBOL unsigned int
+nfnl_rcvbufsiz(const struct nfnl_handle *h, unsigned int size)
 {
 	int status;
 	socklen_t socklen = sizeof(size);
@@ -1047,9 +1062,10 @@ unsigned int nfnl_rcvbufsiz(const struct nfnl_handle *h, unsigned int size)
  * On success, a valid address that points to the netlink message is returned.
  * On error, NULL is returned.
  */
-struct nlmsghdr *nfnl_get_msg_first(struct nfnl_handle *h,
-				    const unsigned char *buf,
-				    size_t len)
+EXPORT_SYMBOL struct nlmsghdr *
+nfnl_get_msg_first(struct nfnl_handle *h,
+		   const unsigned char *buf,
+		   size_t len)
 {
 	struct nlmsghdr *nlh;
 
@@ -1066,9 +1082,10 @@ struct nlmsghdr *nfnl_get_msg_first(struct nfnl_handle *h,
 	return nlh;
 }
 
-struct nlmsghdr *nfnl_get_msg_next(struct nfnl_handle *h,
-				   const unsigned char *buf,
-				   size_t len)
+EXPORT_SYMBOL struct nlmsghdr *
+nfnl_get_msg_next(struct nfnl_handle *h,
+		  const unsigned char *buf,
+		  size_t len)
 {
 	struct nlmsghdr *nlh;
 	size_t remain_len;
@@ -1117,8 +1134,9 @@ struct nlmsghdr *nfnl_get_msg_next(struct nfnl_handle *h,
  * On success, 0 is returned. On error, -1 is returned and errno is set
  * appropiately.
  */
-int nfnl_callback_register(struct nfnl_subsys_handle *ssh,
-			   u_int8_t type, struct nfnl_callback *cb)
+EXPORT_SYMBOL int
+nfnl_callback_register(struct nfnl_subsys_handle *ssh,
+		       u_int8_t type, struct nfnl_callback *cb)
 {
 	assert(ssh);
 	assert(cb);
@@ -1141,7 +1159,8 @@ int nfnl_callback_register(struct nfnl_subsys_handle *ssh,
  * On sucess, 0 is returned. On error, -1 is returned and errno is
  * set appropiately.
  */
-int nfnl_callback_unregister(struct nfnl_subsys_handle *ssh, u_int8_t type)
+EXPORT_SYMBOL int
+nfnl_callback_unregister(struct nfnl_subsys_handle *ssh, u_int8_t type)
 {
 	assert(ssh);
 
@@ -1155,9 +1174,10 @@ int nfnl_callback_unregister(struct nfnl_subsys_handle *ssh, u_int8_t type)
 	return 0;
 }
 
-int nfnl_check_attributes(const struct nfnl_handle *h,
-			 const struct nlmsghdr *nlh,
-			 struct nfattr *nfa[])
+EXPORT_SYMBOL int
+nfnl_check_attributes(const struct nfnl_handle *h,
+		      const struct nlmsghdr *nlh,
+		      struct nfattr *nfa[])
 {
 	assert(h);
 	assert(nlh);
@@ -1242,7 +1262,7 @@ static int __nfnl_handle_msg(struct nfnl_handle *h, struct nlmsghdr *nlh,
 	return 0;
 }
 
-int nfnl_handle_packet(struct nfnl_handle *h, char *buf, int len)
+EXPORT_SYMBOL int nfnl_handle_packet(struct nfnl_handle *h, char *buf, int len)
 {
 
 	while (len >= NLMSG_SPACE(0)) {
@@ -1370,7 +1390,8 @@ static int nfnl_step(struct nfnl_handle *h, struct nlmsghdr *nlh)
  * for any reason, then it must return NFNL_CB_STOP. Otherwise, if the 
  * callback continues the processing NFNL_CB_CONTINUE is returned.
  */
-int nfnl_process(struct nfnl_handle *h, const unsigned char *buf, size_t len)
+EXPORT_SYMBOL int
+nfnl_process(struct nfnl_handle *h, const unsigned char *buf, size_t len)
 {
 	int ret = 0;
 	struct nlmsghdr *nlh = (struct nlmsghdr *)buf;
@@ -1417,7 +1438,7 @@ struct nfnl_iterator {
  * On success, a valid address is returned. On error, NULL is returned
  * and errno is set to the appropiate value.
  */
-struct nfnl_iterator *
+EXPORT_SYMBOL struct nfnl_iterator *
 nfnl_iterator_create(const struct nfnl_handle *h,
 		     const char *buf,
 		     size_t len)
@@ -1454,7 +1475,7 @@ nfnl_iterator_create(const struct nfnl_handle *h,
  *
  * This function destroys a certain iterator. Nothing is returned.
  */
-void nfnl_iterator_destroy(struct nfnl_iterator *it)
+EXPORT_SYMBOL void nfnl_iterator_destroy(struct nfnl_iterator *it)
 {
 	assert(it);
 	free(it);
@@ -1469,7 +1490,8 @@ void nfnl_iterator_destroy(struct nfnl_iterator *it)
  * On success, a value greater or equal to zero is returned. On error,
  * -1 is returned and errno is appropiately set.
  */
-int nfnl_iterator_process(struct nfnl_handle *h, struct nfnl_iterator *it)
+EXPORT_SYMBOL int
+nfnl_iterator_process(struct nfnl_handle *h, struct nfnl_iterator *it)
 {
 	assert(h);
 	assert(it->nlh);
@@ -1495,7 +1517,8 @@ int nfnl_iterator_process(struct nfnl_handle *h, struct nfnl_iterator *it)
  * It returns NFNL_CB_CONTINUE if there is still more messages to be 
  * processed, otherwise NFNL_CB_STOP is returned.
  */
-int nfnl_iterator_next(const struct nfnl_handle *h, struct nfnl_iterator *it)
+EXPORT_SYMBOL int
+nfnl_iterator_next(const struct nfnl_handle *h, struct nfnl_iterator *it)
 {
 	assert(h);
 	assert(it);
@@ -1522,7 +1545,7 @@ int nfnl_iterator_next(const struct nfnl_handle *h, struct nfnl_iterator *it)
  * Note that ENOBUFS is returned in case that nfnetlink is exhausted. In
  * that case is possible that the information requested is incomplete.
  */
-int nfnl_catch(struct nfnl_handle *h)
+EXPORT_SYMBOL int nfnl_catch(struct nfnl_handle *h)
 {
 	int ret;
 
@@ -1565,7 +1588,7 @@ int nfnl_catch(struct nfnl_handle *h)
  * Note that ENOBUFS is returned in case that nfnetlink is exhausted. In
  * that case is possible that the information requested is incomplete.
  */
-int nfnl_query(struct nfnl_handle *h, struct nlmsghdr *nlh)
+EXPORT_SYMBOL int nfnl_query(struct nfnl_handle *h, struct nlmsghdr *nlh)
 {
 	assert(h);
 	assert(nlh);
-- 
1.7.1

