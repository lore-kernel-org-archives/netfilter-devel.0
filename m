From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] Use index2name capabilities of libnfnetlink in IFINDEX filter.
Date: Wed,  6 Feb 2008 11:04:34 +0100
Message-ID: <12022922743115-git-send-email-eric@inl.fr>
References: <47A5B0C0.1060003@netfilter.org>
Cc: Eric Leblond <eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:36002 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760036AbYBFKEi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Feb 2008 05:04:38 -0500
In-Reply-To: <47A5B0C0.1060003@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modify ulogd_filter_IFINDEX to use libnfnetlink for index to
interface name mapping instead of using local version. This requires at least
libnfnetlink 0.0.30. This dependancy is checked in configure (thanks to
Sebastien Tricaud for his patch).

Signed-off-by: Eric Leblond <eric@inl.fr>
---
:100644 100644 086e4cb... a70848c... M	configure.in
:100644 100644 51bcc3f... 52b639c... M	filter/Makefile.am
:100644 000000 02a5f7e... 0000000... D	filter/iftable.c
:100644 000000 6725d67... 0000000... D	filter/iftable.h
:100644 000000 5365af6... 0000000... D	filter/rtnl.c
:100644 000000 18f0963... 0000000... D	filter/rtnl.h
:100644 100644 b386f4a... 468a4c4... M	filter/ulogd_filter_IFINDEX.c
 configure.in                  |    5 +
 filter/Makefile.am            |    6 +-
 filter/iftable.c              |  259 -----------------------------------------
 filter/iftable.h              |   11 --
 filter/rtnl.c                 |  246 --------------------------------------
 filter/rtnl.h                 |   29 -----
 filter/ulogd_filter_IFINDEX.c |   84 +++++++-------
 7 files changed, 51 insertions(+), 589 deletions(-)

diff --git a/configure.in b/configure.in
index 086e4cb..a70848c 100644
--- a/configure.in
+++ b/configure.in
@@ -30,6 +30,11 @@ dnl Checks for library functions.
 AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
+dnl Check for the right nfnetlink version
+LIBNFNETLINK_REQUIRED=0.0.30
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
+               AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+
 AC_CHECK_HEADER([libnetfilter_log/linux_nfnetlink_log.h], [AC_MSG_RESULT([found])],
 		[AC_MSG_ERROR([libnetfilter_log Version 0.0.11 or later needed])])
 
diff --git a/filter/Makefile.am b/filter/Makefile.am
index 51bcc3f..52b639c 100644
--- a/filter/Makefile.am
+++ b/filter/Makefile.am
@@ -2,14 +2,12 @@ SUBDIRS = raw2packet packet2flow
 
 INCLUDES = $(all_includes) -I$(top_srcdir)/include
 
-noinst_HEADERS = rtnl.h iftable.h
-
 pkglib_LTLIBRARIES = ulogd_filter_IFINDEX.la ulogd_filter_PWSNIFF.la \
 		     ulogd_filter_PRINTPKT.la ulogd_filter_PRINTFLOW.la \
 		     ulogd_filter_IP2STR.la ulogd_filter_IP2BIN.la
 
-ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c rtnl.c iftable.c
-ulogd_filter_IFINDEX_la_LDFLAGS = -module
+ulogd_filter_IFINDEX_la_SOURCES = ulogd_filter_IFINDEX.c
+ulogd_filter_IFINDEX_la_LDFLAGS = -module -lnfnetlink
 
 ulogd_filter_PWSNIFF_la_SOURCES = ulogd_filter_PWSNIFF.c
 ulogd_filter_PWSNIFF_la_LDFLAGS = -module
diff --git a/filter/iftable.c b/filter/iftable.c
deleted file mode 100644
index 02a5f7e..0000000
--- a/filter/iftable.c
+++ /dev/null
@@ -1,259 +0,0 @@
-/* iftable - table of network interfaces
- *
- * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
- *
- * This software is Free Software and licensed under GNU GPLv2. 
- *
- */
-
-/* IFINDEX handling */
-
-#include <unistd.h>
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
-#include <sys/types.h>
-
-#include <netinet/in.h>
-#include <arpa/inet.h>
-
-#include <linux/netdevice.h>
-
-#include "rtnl.h"
-
-#define iftb_log(x, ...)
-
-struct ifindex_map {
-	struct ifindex_map *next;
-
-	u_int32_t	index;
-	u_int32_t	type;
-	u_int32_t	alen;
-	u_int32_t	flags;
-	char		addr[8];
-	char		name[16];
-};
-
-static struct ifindex_map *ifindex_map[16];
-
-/* iftable_dump - Dump the interface table to a given file stream
- * @outfd:	file stream to which table should be dumped
- */
-int iftable_dump(FILE *outfd)
-{
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		struct ifindex_map *im;
-		for (im = ifindex_map[i]; im; im = im->next) {
-			fprintf(outfd, "%u %s", im->index, im->name);
-			if (!(im->flags & IFF_UP))
-				fputs(" DOWN", outfd);
-			fputc('\n', outfd);
-		}
-	}
-	fflush(outfd);
-	return 0;
-}
-
-/* iftable_add - Add/Update an entry to/in the interface table
- * @n:		netlink message header of a RTM_NEWLINK message
- * @arg:	not used
- *
- * This function adds/updates an entry in the intrface table.
- * Returns -1 on error, 1 on success.
- */
-static int iftable_add(struct nlmsghdr *n, void *arg)
-{
-	unsigned int hash;
-	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
-	struct ifindex_map *im, **imp;
-	struct rtattr *cb[IFLA_MAX+1];
-
-	if (n->nlmsg_type != RTM_NEWLINK)
-		return -1;
-
-	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg))) {
-		iftb_log(LOG_ERROR, "short message (%u < %u)",
-			 n->nlmsg_len, NLMSG_LENGTH(sizeof(ifi_msg)));
-		return -1;
-	}
-
-	memset(&cb, 0, sizeof(cb));
-	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
-	if (!cb[IFLA_IFNAME]) {
-		iftb_log(LOG_ERROR, "interface without name?");
-		return -1;
-	}
-
-	hash = ifi_msg->ifi_index&0xF;
-	for (imp = &ifindex_map[hash]; (im=*imp)!=NULL; imp = &im->next) {
-		if (im->index == ifi_msg->ifi_index) {
-			iftb_log(LOG_DEBUG,
-				 "updating iftable (ifindex=%u)", im->index);
-			break;
-		}
-	}
-
-	if (!im) {
-		im = malloc(sizeof(*im));
-		if (!im) {
-			iftb_log(LOG_ERROR,
-				 "ENOMEM while allocating ifindex_map");
-			return 0;
-		}
-		im->next = *imp;
-		im->index = ifi_msg->ifi_index;
-		*imp = im;
-		iftb_log(LOG_DEBUG, "creating new iftable (ifindex=%u)",
-			 im->index);
-	}
-	
-	im->type = ifi_msg->ifi_type;
-	im->flags = ifi_msg->ifi_flags;
-	if (cb[IFLA_ADDRESS]) {
-		unsigned int alen;
-		im->alen = alen = RTA_PAYLOAD(cb[IFLA_ADDRESS]);
-		if (alen > sizeof(im->addr))
-			alen = sizeof(im->addr);
-		memcpy(im->addr, RTA_DATA(cb[IFLA_ADDRESS]), alen);
-	} else {
-		im->alen = 0;
-		memset(im->addr, 0, sizeof(im->addr));
-	}
-	strcpy(im->name, RTA_DATA(cb[IFLA_IFNAME]));
-	return 1;
-}
-
-/* iftable_del - Delete an entry from the interface table
- * @n:		netlink message header of a RTM_DELLINK nlmsg
- * @arg:	not used
- *
- * Delete an entry from the interface table.  
- * Returns -1 on error, 0 if no matching entry was found or 1 on success.
- */
-static int iftable_del(struct nlmsghdr *n, void *arg)
-{
-	struct ifinfomsg *ifi_msg = NLMSG_DATA(n);
-	struct rtattr *cb[IFLA_MAX+1];
-	struct ifindex_map *im;
-
-	if (n->nlmsg_type != RTM_DELLINK) {
-		iftb_log(LOG_ERROR,
-			 "called with wrong nlmsg_type %u", n->nlmsg_type);
-		return -1;
-	}
-
-	if (n->nlmsg_len < NLMSG_LENGTH(sizeof(ifi_msg))) {
-		iftb_log(LOG_ERROR, "short message (%u < %u)",
-			 n->nlmsg_len, NLMSG_LENGTH(sizeof(ifi_msg)));
-		return -1;
-	}
-
-	memset(&cb, 0, sizeof(cb));
-	rtnl_parse_rtattr(cb, IFLA_MAX, IFLA_RTA(ifi_msg), IFLA_PAYLOAD(n));
-
-	/* FIXME */
-
-	return 1;
-}
-	
-/* ifindex_2name - get the name for an ifindex
- * @index:	ifindex to be resolved
- *
- * Return value: character string containing name of interface
- */
-char *ifindex_2name(unsigned int index)
-{
-	struct ifindex_map *im;
-
-	if (index == 0)
-		return "";
-	for (im = ifindex_map[index&0xF]; im; im = im->next)
-		if (im->index == index)
-			return im->name;
-
-	return NULL;
-}
-
-/* iftable_up - Determine whether a given interface is UP
- * @index:	ifindex of interface
- *
- * Return value: -1 if interface unknown, 1 if interface up, 0 if not.
- */
-int iftable_up(unsigned int index)
-{
-	struct ifindex_map *im;
-
-	for (im = ifindex_map[index&0xF]; im; im = im->next) {
-		if (im->index == index) {
-			if (im->flags & IFF_UP)
-				return 1;
-			else
-				return 0;
-		}
-	}
-	return -1;
-}
-
-static struct rtnl_handler handlers[] = {
-	{ .nlmsg_type = RTM_NEWLINK, .handlefn = &iftable_add },
-	{ .nlmsg_type = RTM_DELLINK, .handlefn = &iftable_del },
-};
-
-static int init_or_fini(int fini)
-{
-	int ret = 0;
-
-	if (fini)
-		goto cleanup;
-
-	if (rtnl_handler_register(&handlers[0]) < 0) {
-		ret = -1;
-		goto cleanup_none;
-	}
-
-	if (rtnl_handler_register(&handlers[1]) < 0) {
-		ret = -1;
-		goto cleanup_0;
-	}
-
-	if (rtnl_dump_type(RTM_GETLINK) < 0) {
-		ret = -1;
-		goto cleanup_1;
-	}
-
-	return 0;
-
-#if 0
-	if (rtnl_wilddump_requet(rtnl_fd, AF_UNSPEC, RTM_GETLINK) < 0) {
-		iftb_log(LOG_ERROR, "unable to send dump request");
-		return -1;
-	}
-
-#endif
-
-cleanup:
-
-cleanup_1:
-	rtnl_handler_unregister(&handlers[1]);
-cleanup_0:
-	rtnl_handler_unregister(&handlers[0]);
-cleanup_none:
-	return ret;
-}
-
-/* iftable_init - Initialize interface table
- */
-int iftable_init(void)
-{
-	iftb_log(LOG_DEBUG, "%s", __FUNCTION__);
-	return init_or_fini(0);
-}
-
-/* iftable_fini - Destructor of interface table
- */
-void iftable_fini(void)
-{
-	init_or_fini(1);
-}
diff --git a/filter/iftable.h b/filter/iftable.h
deleted file mode 100644
index 6725d67..0000000
--- a/filter/iftable.h
+++ /dev/null
@@ -1,11 +0,0 @@
-#ifndef _IFTABLE_H
-#define _IFTABLE_H
-
-extern char *ifindex_2name(unsigned int index);
-extern int iftable_up(unsigned int index);
-
-extern int iftable_init(void);
-extern void iftable_fini(void);
-
-extern int iftable_dump(FILE *outfd);
-#endif
diff --git a/filter/rtnl.c b/filter/rtnl.c
deleted file mode 100644
index 5365af6..0000000
--- a/filter/rtnl.c
+++ /dev/null
@@ -1,246 +0,0 @@
-/* rtnl - rtnetlink utility functions
- *
- * (C) 2004 by Astaro AG, written by Harald Welte <hwelte@astaro.com>
- *
- * This software is free software and licensed under GNU GPLv2. 
- *
- */
-
-/* rtnetlink - routing table netlink interface */
-
-#include <unistd.h>
-#include <stdlib.h>
-#include <string.h>
-#include <errno.h>
-#include <time.h>
-#include <sys/types.h>
-
-#include <netinet/in.h>
-
-#include <linux/types.h>
-#include <sys/socket.h>
-#include <linux/netlink.h>
-#include <linux/rtnetlink.h>
-
-#include "rtnl.h"
-
-#define rtnl_log(x, ...)
-
-static int rtnl_fd;
-static int rtnl_seq = 0;
-static int rtnl_dump;
-static struct sockaddr_nl rtnl_local;
-
-static struct rtnl_handler *handlers = NULL;
-
-static inline struct rtnl_handler *find_handler(u_int16_t type)
-{
-	struct rtnl_handler *h;
-	for (h = handlers; h; h = h->next) {
-		if (h->nlmsg_type == type)
-			return h;
-	}
-	return NULL;
-}
-
-static int call_handler(u_int16_t type, struct nlmsghdr *hdr)
-{
-	struct rtnl_handler *h = find_handler(type);
-
-	if (!h) {
-		rtnl_log(LOG_DEBUG, "no registered handler for type %u",
-			 type);
-		return 0;
-	}
-
-	return (h->handlefn)(hdr, h->arg);
-}
-
-/* rtnl_handler_register - register handler for given nlmsg type
- * @hdlr:	handler structure
- */
-int rtnl_handler_register(struct rtnl_handler *hdlr)
-{
-	rtnl_log(LOG_DEBUG, "registering handler for type %u",
-		 hdlr->nlmsg_type);
-	hdlr->next = handlers;
-	handlers = hdlr;
-	return 1;
-}
-
-/* rtnl_handler_unregister - unregister handler for given nlmst type
- * @hdlr:	handler structure
- */
-int rtnl_handler_unregister(struct rtnl_handler *hdlr)
-{
-	struct rtnl_handler *h, *prev = NULL;
-
-	rtnl_log(LOG_DEBUG, "unregistering handler for type %u",
-		 hdlr->nlmsg_type);
-
-	for (h = handlers; h; h = h->next) {
-		if (h == hdlr) {
-			if (prev)
-				prev->next = h->next;
-			else
-				handlers = h->next;
-			return 1;
-		}
-		prev = h;
-	}
-	return 0;
-}
-
-/* rtnl_arse_rtattr - parse rtattr */
-int rtnl_parse_rtattr(struct rtattr *tb[], int max, struct rtattr *rta, int len)
-{
-	while (RTA_OK(rta, len)) {
-		if (rta->rta_type <= max)
-			tb[rta->rta_type] = rta;
-		rta = RTA_NEXT(rta,len);
-	}
-	if (len)
-		return -1;
-	return 0;
-}
-
-/* rtnl_dump_type - ask rtnetlink to dump a specific table
- * @type:	type of table to be dumped
- */
-int rtnl_dump_type(unsigned int type)
-{
-        struct {
-                struct nlmsghdr nlh;
-                struct rtgenmsg g;
-        } req;
-        struct sockaddr_nl nladdr;
-
-        memset(&nladdr, 0, sizeof(nladdr));
-	memset(&req, 0, sizeof(req));
-        nladdr.nl_family = AF_NETLINK;
-
-        req.nlh.nlmsg_len = sizeof(req);
-        req.nlh.nlmsg_type = type;
-        req.nlh.nlmsg_flags = NLM_F_ROOT|NLM_F_MATCH|NLM_F_REQUEST;
-        req.nlh.nlmsg_pid = 0;
-        req.nlh.nlmsg_seq = rtnl_dump = ++rtnl_seq;
-        req.g.rtgen_family = AF_INET;
-
-        return sendto(rtnl_fd, (void*)&req, sizeof(req), 0, 
-		      (struct sockaddr*)&nladdr, sizeof(nladdr));
-}
-
-/* rtnl_receive - receive netlink packets from rtnetlink socket */
-int rtnl_receive()
-{
-	int status;
-	char buf[8192];
-	struct sockaddr_nl nladdr;
-	struct iovec iov = { buf, sizeof(buf) };
-	struct nlmsghdr *h;
-
-	struct msghdr msg = {
-		(void *)&nladdr, sizeof(nladdr),
-		&iov, 1,
-		NULL, 0,
-		0
-	};
-
-	status = recvmsg(rtnl_fd, &msg, 0);
-	if (status < 0) {
-		if (errno == EINTR)
-			return 0;
-		rtnl_log(LOG_NOTICE, "OVERRUN on rtnl socket");
-		return -1;
-	}
-	if (status == 0) {
-		rtnl_log(LOG_ERROR, "EOF on rtnl socket");
-		return -1;
-	}
-	if (msg.msg_namelen != sizeof(nladdr)) {
-		rtnl_log(LOG_ERROR, "invalid address size");
-		return -1;
-	}
-
-	h = (struct nlmsghdr *) buf;
-	while (NLMSG_OK(h, status)) {
-#if 0
-		if (h->nlmsg_pid != rtnl_local.nl_pid ||
-		    h->nlmsg_seq != rtnl_dump) {
-			goto skip;
-		}
-#endif
-
-		if (h->nlmsg_type == NLMSG_DONE) {
-			rtnl_log(LOG_NOTICE, "NLMSG_DONE");
-			return 0;
-		}
-		if (h->nlmsg_type == NLMSG_ERROR) { 
-			struct nlmsgerr *err = (struct nlmsgerr *)NLMSG_DATA(h);
-			if (h->nlmsg_len>=NLMSG_LENGTH(sizeof(struct nlmsgerr)))
-				errno = -err->error;
-			rtnl_log(LOG_ERROR, "NLMSG_ERROR, errnp=%d",
-				 errno);
-			return -1;
-		}
-
-		if (call_handler(h->nlmsg_type, h) == 0) 
-			rtnl_log(LOG_NOTICE, "unhandled nlmsg_type %u",
-				 h->nlmsg_type);
-		h = NLMSG_NEXT(h, status);
-	}
-	return 1;
-}
-
-/* rtnl_init - constructor of rtnetlink module */
-int rtnl_init(void)
-{
-	socklen_t addr_len;
-
-	rtnl_local.nl_pid = getpid();
-	rtnl_fd = socket(AF_NETLINK, SOCK_RAW, NETLINK_ROUTE);
-	if (rtnl_fd < 0) {
-		rtnl_log(LOG_ERROR, "unable to create rtnetlink socket");
-		return -1;
-	}
-
-	memset(&rtnl_local, 0, sizeof(rtnl_local));
-	rtnl_local.nl_family = AF_NETLINK;
-	rtnl_local.nl_groups = RTMGRP_IPV4_ROUTE|RTMGRP_IPV4_IFADDR|RTMGRP_LINK;
-
-	if (bind(rtnl_fd, (struct sockaddr *)&rtnl_local, sizeof(rtnl_local)) < 0) {
-		rtnl_log(LOG_ERROR, "unable to bind rtnetlink socket");
-		return -1;
-	}
-
-	addr_len = sizeof(rtnl_local);
-	if (getsockname(rtnl_fd, (struct sockaddr *)&rtnl_local, 
-			&addr_len) < 0) {
-		rtnl_log(LOG_ERROR, "cannot gescockname(rtnl_socket)");
-		return -1;
-	}
-
-	if (addr_len != sizeof(rtnl_local)) {
-		rtnl_log(LOG_ERROR, "invalid address size %u", addr_len);
-		return -1;
-	}
-
-	if (rtnl_local.nl_family != AF_NETLINK) {
-		rtnl_log(LOG_ERROR, "invalid AF %u", rtnl_local.nl_family);
-		return -1;
-	}
-
-	rtnl_seq = time(NULL);
-
-	return rtnl_fd;
-}
-
-/* rtnl_fini - destructor of rtnetlink module */
-void rtnl_fini(void)
-{
-	close(rtnl_fd);
-	return;
-}
-
-
-
diff --git a/filter/rtnl.h b/filter/rtnl.h
deleted file mode 100644
index 18f0963..0000000
--- a/filter/rtnl.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef _RTNL_H
-#define _RTNL_H
-
-#include <sys/socket.h>
-#include <linux/types.h>
-#include <linux/rtnetlink.h>
-
-struct rtnl_handler {
-	struct rtnl_handler *next;
-
-	u_int16_t	nlmsg_type;
-	int		(*handlefn)(struct nlmsghdr *h, void *arg);
-	void		*arg;
-};
-
-
-/* api for handler plugins */
-int rtnl_handler_register(struct rtnl_handler *hdlr);
-int rtnl_handler_unregister(struct rtnl_handler *hdlr);
-int rtnl_parse_rtattr(struct rtattr *tb[], int max, struct rtattr *rta, int len);
-int rtnl_dump_type(unsigned int type);
-
-/* api for core program */
-int rtnl_init(void);
-void rtnl_fini(void);
-int rtnl_receive();
-  
-
-#endif
diff --git a/filter/ulogd_filter_IFINDEX.c b/filter/ulogd_filter_IFINDEX.c
index b386f4a..468a4c4 100644
--- a/filter/ulogd_filter_IFINDEX.c
+++ b/filter/ulogd_filter_IFINDEX.c
@@ -24,19 +24,17 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <ulogd/ulogd.h>
-
-#include "rtnl.h"
-#include "iftable.h"
+#include <libnfnetlink/libnfnetlink.h>
 
 static struct ulogd_key ifindex_keys[] = {
 	{ 
 		.type = ULOGD_RET_STRING,
-		.flags = ULOGD_RETF_NONE,
+		.flags = ULOGD_RETF_NONE | ULOGD_RETF_FREE,
 		.name = "oob.in", 
 	},
 	{ 
 		.type = ULOGD_RET_STRING,
-		.flags = ULOGD_RETF_NONE,
+		.flags = ULOGD_RETF_NONE | ULOGD_RETF_FREE,
 		.name = "oob.out", 
 	},
 };
@@ -52,31 +50,41 @@ static struct ulogd_key ifindex_inp[] = {
 	},
 };
 
+/* we only need one global static cache of ifindex to ifname mappings, 
+ * so all state is global (as opposed to per-instance local state in almost
+ * all other plugins */
+static struct ulogd_fd nlif_u_fd = { .fd = -1 };
+static int nlif_users;
+static struct nlif_handle *nlif_inst;
+
 static int interp_ifindex(struct ulogd_pluginstance *pi)
 {
 	struct ulogd_key *ret = pi->output.keys;
 	struct ulogd_key *inp = pi->input.keys;
 
-	ret[0].u.value.ptr = ifindex_2name(inp[0].u.source->u.value.ui32);
+	ret[0].u.value.ptr = calloc(IFNAMSIZ, sizeof(char)); 
+	nlif_index2name(nlif_inst, inp[0].u.source->u.value.ui32,
+			ret[0].u.value.ptr);
+	if (((char *)ret[0].u.value.ptr)[0] == '*')
+		((char *)(ret[0].u.value.ptr))[0] = 0; 
 	ret[0].flags |= ULOGD_RETF_VALID;
-	ret[1].u.value.ptr = ifindex_2name(inp[1].u.source->u.value.ui32);
+
+	ret[1].u.value.ptr = calloc(IFNAMSIZ, sizeof(char)); 
+	nlif_index2name(nlif_inst, inp[1].u.source->u.value.ui32,
+			ret[1].u.value.ptr);
+	if (((char *)ret[1].u.value.ptr)[0] == '*')
+		((char *)(ret[1].u.value.ptr))[0] = 0; 
 	ret[1].flags |= ULOGD_RETF_VALID;
 
 	return 0;
 }
 
-/* we only need one global static cache of ifindex to ifname mappings, 
- * so all state is global (as opposed to per-instance local state in almost
- * all other plugins */
-static struct ulogd_fd rtnl_fd = { .fd = -1 };
-static int rtnl_users;
-
-static int rtnl_read_cb(int fd, unsigned int what, void *param)
+static int nlif_read_cb(int fd, unsigned int what, void *param)
 {
 	if (!(what & ULOGD_FD_READ))
 		return 0;
 
-	rtnl_receive();
+	nlif_catch(nlif_inst);
 }
 
 static int ifindex_start(struct ulogd_pluginstance *upi)
@@ -84,44 +92,40 @@ static int ifindex_start(struct ulogd_pluginstance *upi)
 	int rc;
 
 	/* if we're already initialized, inc usage count and exit */
-	if (rtnl_fd.fd >= 0) {
-		rtnl_users++;
+	if (nlif_u_fd.fd >= 0) {
+		nlif_users++;
 		return 0;
 	}
 
 	/* if we reach here, we need to initialize */
-	rtnl_fd.fd = rtnl_init();
-	if (rtnl_fd.fd < 0)
-		return rtnl_fd.fd;
-
-	rc = iftable_init();
-	if (rc < 0)
-		goto out_rtnl;
-
-	rtnl_fd.when = ULOGD_FD_READ;
-	rtnl_fd.cb = &rtnl_read_cb;
-	rc = ulogd_register_fd(&rtnl_fd);
+	nlif_inst = nlif_open();
+	if (nlif_inst == NULL) {
+		return nlif_u_fd.fd;
+	}
+	nlif_query(nlif_inst);
+	
+	nlif_u_fd.fd = nlif_fd(nlif_inst);
+	nlif_u_fd.when = ULOGD_FD_READ;
+	nlif_u_fd.cb = &nlif_read_cb;
+	rc = ulogd_register_fd(&nlif_u_fd);
 	if (rc < 0)
-		goto out_iftable;
+		goto out_nlif;
 
-	rtnl_users++;
+	nlif_users++;
 	return 0;
 
-out_iftable:
-	iftable_fini();
-out_rtnl:
-	rtnl_fini();
-	rtnl_fd.fd = -1;
+out_nlif:
+	nlif_close(nlif_inst);
+	nlif_u_fd.fd = -1;
 	return rc;
 }
 
 static int ifindex_fini(struct ulogd_pluginstance *upi)
 {
-	if (--rtnl_users == 0) {
-		ulogd_unregister_fd(&rtnl_fd);
-		iftable_fini();
-		rtnl_fini();
-		rtnl_fd.fd = -1;
+	if (--nlif_users == 0) {
+		ulogd_unregister_fd(&nlif_u_fd);
+		nlif_close(nlif_inst);
+		nlif_u_fd.fd = -1;
 	}
 
 	return 0;
-- 
1.5.2.5

