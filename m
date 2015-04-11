From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] src: restore interface to index cache
Date: Sat, 11 Apr 2015 18:43:47 +0200
Message-ID: <1428770627-7963-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35704 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbbDKQjj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Apr 2015 12:39:39 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira <pablo@netfilter.org>

nftables used to have a cache to speed up interface name <-> index lookup,
restore it using libmnl.

This reduces netlink traffic since if_nametoindex() and if_indextoname() open,
send a request, receive the list of interface and close a netlink socket for
each call.  I think this is also good for consistency since nft -f will operate
with the same index number when reloading the ruleset.

The cache is populated by when nft_if_nametoindex() and nft_if_indextoname()
are used for first time. Then, it it released in the output path. In the
interactive mode, it is invalidated after each command.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/Makefile.am |    1 +
 include/iface.h     |   18 +++++++
 src/Makefile.am     |    1 +
 src/cli.c           |    2 +
 src/iface.c         |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++
 src/main.c          |    4 +-
 src/meta.c          |    5 +-
 7 files changed, 175 insertions(+), 3 deletions(-)
 create mode 100644 include/iface.h
 create mode 100644 src/iface.c

diff --git a/include/Makefile.am b/include/Makefile.am
index f22561b..465d804 100644
--- a/include/Makefile.am
+++ b/include/Makefile.am
@@ -4,6 +4,7 @@ noinst_HEADERS = 	cli.h		\
 			datatype.h	\
 			expression.h	\
 			gmputil.h	\
+			iface.h		\
 			mnl.h		\
 			nftables.h	\
 			payload.h	\
diff --git a/include/iface.h b/include/iface.h
new file mode 100644
index 0000000..f41ee8b
--- /dev/null
+++ b/include/iface.h
@@ -0,0 +1,18 @@
+#ifndef _NFTABLES_IFACE_H_
+#define _NFTABLES_IFACE_H_
+
+#include <net/if.h>
+
+struct iface {
+	struct list_head	list;
+	char			name[IFNAMSIZ];
+	uint32_t		ifindex;
+};
+
+unsigned int nft_if_nametoindex(const char *name);
+char *nft_if_indextoname(unsigned int ifindex, char *name);
+
+void iface_cache_update(void);
+void iface_cache_release(void);
+
+#endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 2410fd3..fd63219 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -44,6 +44,7 @@ nft_SOURCES =	main.c				\
 		utils.c				\
 		erec.c				\
 		mnl.c				\
+		iface.c				\
 		scanner.l			\
 		parser_bison.y
 
diff --git a/src/cli.c b/src/cli.c
index f3827b8..fbae0ef 100644
--- a/src/cli.c
+++ b/src/cli.c
@@ -28,6 +28,7 @@
 #include <parser.h>
 #include <erec.h>
 #include <utils.h>
+#include <iface.h>
 #include <cli.h>
 
 #define CMDLINE_HISTFILE	".nft.history"
@@ -123,6 +124,7 @@ static void cli_complete(char *line)
 	nft_run(scanner, state, &msgs);
 	erec_print_list(stdout, &msgs);
 	xfree(line);
+	iface_cache_release();
 }
 
 static char **cli_completion(const char *text, int start, int end)
diff --git a/src/iface.c b/src/iface.c
new file mode 100644
index 0000000..9936388
--- /dev/null
+++ b/src/iface.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <net/if.h>
+#include <time.h>
+#include <string.h>
+#include <errno.h>
+
+#include <libmnl/libmnl.h>
+#include <linux/rtnetlink.h>
+
+#include <nftables.h>
+#include <list.h>
+#include <netlink.h>
+#include <iface.h>
+
+static LIST_HEAD(iface_list);
+static bool iface_cache_init;
+
+static int data_attr_cb(const struct nlattr *attr, void *data)
+{
+	const struct nlattr **tb = data;
+	int type = mnl_attr_get_type(attr);
+
+	if (mnl_attr_type_valid(attr, IFLA_MAX) < 0)
+		return MNL_CB_OK;
+
+	switch(type) {
+	case IFLA_IFNAME:
+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
+			netlink_abi_error();
+		break;
+	default:
+		return MNL_CB_OK;
+	}
+	tb[type] = attr;
+	return MNL_CB_OK;
+}
+
+static int data_cb(const struct nlmsghdr *nlh, void *data)
+{
+	struct nlattr *tb[IFLA_MAX + 1] = {};
+	struct ifinfomsg *ifm = mnl_nlmsg_get_payload(nlh);
+	struct iface *iface;
+
+	iface = xmalloc(sizeof(struct iface));
+	iface->ifindex = ifm->ifi_index;
+	mnl_attr_parse(nlh, sizeof(*ifm), data_attr_cb, tb);
+	strncpy(iface->name, mnl_attr_get_str(tb[IFLA_IFNAME]), IFNAMSIZ);
+	list_add(&iface->list, &iface_list);
+
+	return MNL_CB_OK;
+}
+
+void iface_cache_update(void)
+{
+	char buf[MNL_SOCKET_BUFFER_SIZE];
+	struct mnl_socket *nl;
+	struct nlmsghdr *nlh;
+	struct rtgenmsg *rt;
+	uint32_t seq, portid;
+	int ret;
+
+	nlh = mnl_nlmsg_put_header(buf);
+	nlh->nlmsg_type	= RTM_GETLINK;
+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
+	nlh->nlmsg_seq = seq = time(NULL);
+	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
+	rt->rtgen_family = AF_PACKET;
+
+	nl = mnl_socket_open(NETLINK_ROUTE);
+	if (nl == NULL)
+		netlink_init_error();
+
+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
+		netlink_init_error();
+
+	portid = mnl_socket_get_portid(nl);
+
+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
+		netlink_init_error();
+
+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	while (ret > 0) {
+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
+		if (ret <= MNL_CB_STOP)
+			break;
+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
+	}
+	if (ret == -1)
+		netlink_init_error();
+
+	mnl_socket_close(nl);
+
+	iface_cache_init = true;
+}
+
+void iface_cache_release(void)
+{
+	struct iface *iface, *next;
+
+	if (!iface_cache_init)
+		return;
+
+	list_for_each_entry_safe(iface, next, &iface_list, list) {
+		list_del(&iface->list);
+		free(iface);
+	}
+	iface_cache_init = false;
+}
+
+unsigned int nft_if_nametoindex(const char *name)
+{
+	struct iface *iface;
+
+	if (!iface_cache_init)
+		iface_cache_update();
+
+	list_for_each_entry(iface, &iface_list, list) {
+		if (strncmp(name, iface->name, IFNAMSIZ) == 0)
+			return iface->ifindex;
+	}
+	return 0;
+}
+
+char *nft_if_indextoname(unsigned int ifindex, char *name)
+{
+	struct iface *iface;
+
+	if (!iface_cache_init)
+		iface_cache_update();
+
+	list_for_each_entry(iface, &iface_list, list) {
+		if (iface->ifindex == ifindex) {
+			strncpy(name, iface->name, IFNAMSIZ);
+			return name;
+		}
+	}
+	return NULL;
+}
diff --git a/src/main.c b/src/main.c
index 4590c30..bfe589a 100644
--- a/src/main.c
+++ b/src/main.c
@@ -25,6 +25,7 @@
 #include <netlink.h>
 #include <erec.h>
 #include <mnl.h>
+#include <iface.h>
 #include <cli.h>
 
 unsigned int max_errors = 10;
@@ -362,7 +363,8 @@ int main(int argc, char * const *argv)
 out:
 	scanner_destroy(scanner);
 	erec_print_list(stderr, &msgs);
-
 	xfree(buf);
+	iface_cache_release();
+
 	return rc;
 }
diff --git a/src/meta.c b/src/meta.c
index ad57228..bfc1258 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -30,6 +30,7 @@
 #include <gmputil.h>
 #include <utils.h>
 #include <erec.h>
+#include <iface.h>
 
 static struct symbol_table *realm_tbl;
 static void __init realm_table_init(void)
@@ -138,7 +139,7 @@ static void ifindex_type_print(const struct expr *expr)
 	int ifindex;
 
 	ifindex = mpz_get_uint32(expr->value);
-	if (if_indextoname(ifindex, name))
+	if (nft_if_indextoname(ifindex, name))
 		printf("%s", name);
 	else
 		printf("%d", ifindex);
@@ -149,7 +150,7 @@ static struct error_record *ifindex_type_parse(const struct expr *sym,
 {
 	int ifindex;
 
-	ifindex = if_nametoindex(sym->identifier);
+	ifindex = nft_if_nametoindex(sym->identifier);
 	if (ifindex == 0)
 		return error(&sym->location, "Interface does not exist");
 
-- 
1.7.10.4

