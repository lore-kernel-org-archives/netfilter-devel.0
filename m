From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 2/2] src: restore interface to index cache
Date: Mon, 06 Apr 2015 14:39:26 +0200
Message-ID: <3C9F7A57-9442-4E37-952D-38A071E71B14@trash.net>
References: <1428321991-10125-1-git-send-email-pablo@netfilter.org> <1428321991-10125-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34220 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbbDFMji (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Apr 2015 08:39:38 -0400
In-Reply-To: <1428321991-10125-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 6. April 2015 14:06:31 MESZ, schrieb Pablo Neira Ayuso <pablo@netfilter.org>:
>nftables used to have a cache to speed up interface name <-> index,
>restore it
>using libmnl.
>
>This reduces netlink traffic since if_nametoindex() and
>if_indexto_name() open,
>send request, receive and close a netlink socket for each call.  I
>think this
>is also good for consistency since nft -f will operate with the same
>index
>number when reloading the ruleset.
>
>We still need special handling for the nft -i case.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
> include/iface.h |   13 ++++++
> src/Makefile.am |    1 +
>src/iface.c     |  134
>+++++++++++++++++++++++++++++++++++++++++++++++++++++++
> src/meta.c      |    5 ++-
> 4 files changed, 151 insertions(+), 2 deletions(-)
> create mode 100644 include/iface.h
> create mode 100644 src/iface.c
>
>diff --git a/include/iface.h b/include/iface.h
>new file mode 100644
>index 0000000..62e6a33
>--- /dev/null
>+++ b/include/iface.h
>@@ -0,0 +1,13 @@
>+#ifndef _NFTABLES_IFACE_H_
>+#define _NFTABLES_IFACE_H_
>+
>+struct iface {
>+	struct list_head	list;
>+	char			name[IFNAMSIZ];
>+	uint32_t		ifindex;
>+};
>+
>+unsigned int nft_if_nametoindex(const char *name);
>+int nft_if_indextoname(unsigned int ifindex, char *name);
>+
>+#endif
>diff --git a/src/Makefile.am b/src/Makefile.am
>index 2410fd3..fd63219 100644
>--- a/src/Makefile.am
>+++ b/src/Makefile.am
>@@ -44,6 +44,7 @@ nft_SOURCES =	main.c				\
> 		utils.c				\
> 		erec.c				\
> 		mnl.c				\
>+		iface.c				\
> 		scanner.l			\
> 		parser_bison.y
> 
>diff --git a/src/iface.c b/src/iface.c
>new file mode 100644
>index 0000000..8c5f99c
>--- /dev/null
>+++ b/src/iface.c
>@@ -0,0 +1,134 @@
>+/*
>+ * Copyright (c) 2015 Pablo Neira Ayuso <pablo@netfilter.org>
>+ *
>+ * This program is free software; you can redistribute it and/or
>modify
>+ * it under the terms of the GNU General Public License version 2 as
>+ * published by the Free Software Foundation.
>+ */
>+
>+#include <stdio.h>
>+#include <stdlib.h>
>+#include <net/if.h>
>+#include <time.h>
>+#include <string.h>
>+#include <errno.h>
>+
>+#include <libmnl/libmnl.h>
>+#include <linux/rtnetlink.h>
>+
>+#include <list.h>
>+#include <netlink.h>
>+#include <iface.h>
>+
>+static LIST_HEAD(iface_list);
>+
>+unsigned int nft_if_nametoindex(const char *name)
>+{
>+	struct iface *iface;
>+
>+	list_for_each_entry(iface, &iface_list, list) {
>+		if (strncmp(name, iface->name, IFNAMSIZ) == 0)
>+			return iface->ifindex;
>+	}
>+	return 0;
>+}
>+
>+int nft_if_indextoname(unsigned int ifindex, char *name)
>+{
>+	struct iface *iface;
>+
>+	list_for_each_entry(iface, &iface_list, list) {
>+		if (iface->ifindex == ifindex) {
>+			strncpy(name, iface->name, IFNAMSIZ);
>+			return 1;
>+		}
>+	}
>+	return 0;
>+}
>+
>+static int data_attr_cb(const struct nlattr *attr, void *data)
>+{
>+	const struct nlattr **tb = data;
>+	int type = mnl_attr_get_type(attr);
>+
>+	if (mnl_attr_type_valid(attr, IFLA_MAX) < 0)
>+		return MNL_CB_OK;
>+
>+	switch(type) {
>+	case IFLA_IFNAME:
>+		if (mnl_attr_validate(attr, MNL_TYPE_STRING) < 0)
>+			netlink_abi_error();
>+		break;
>+	default:
>+		return MNL_CB_OK;
>+	}
>+	tb[type] = attr;
>+	return MNL_CB_OK;
>+}
>+
>+static int data_cb(const struct nlmsghdr *nlh, void *data)
>+{
>+	struct nlattr *tb[IFLA_MAX + 1] = {};
>+	struct ifinfomsg *ifm = mnl_nlmsg_get_payload(nlh);
>+	struct iface *iface;
>+
>+	iface = malloc(sizeof(struct iface));
>+	if (iface == NULL)
>+		memory_allocation_error();

Why not use x*alloc here?

Besides this:

Acked-by: Patrick McHardy <kaber@trash.net>

>+
>+	iface->ifindex = ifm->ifi_index;
>+	mnl_attr_parse(nlh, sizeof(*ifm), data_attr_cb, tb);
>+	strncpy(iface->name, mnl_attr_get_str(tb[IFLA_IFNAME]), IFNAMSIZ);
>+	list_add(&iface->list, &iface_list);
>+
>+	return MNL_CB_OK;
>+}
>+
>+static void __init iface_cache_init(void)
>+{
>+	char buf[MNL_SOCKET_BUFFER_SIZE];
>+	struct mnl_socket *nl;
>+	struct nlmsghdr *nlh;
>+	struct rtgenmsg *rt;
>+	uint32_t seq, portid;
>+	int ret;
>+
>+	nlh = mnl_nlmsg_put_header(buf);
>+	nlh->nlmsg_type	= RTM_GETLINK;
>+	nlh->nlmsg_flags = NLM_F_REQUEST | NLM_F_DUMP;
>+	nlh->nlmsg_seq = seq = time(NULL);
>+	rt = mnl_nlmsg_put_extra_header(nlh, sizeof(struct rtgenmsg));
>+	rt->rtgen_family = AF_PACKET;
>+
>+	nl = mnl_socket_open(NETLINK_ROUTE);
>+	if (nl == NULL)
>+		netlink_init_error();
>+
>+	if (mnl_socket_bind(nl, 0, MNL_SOCKET_AUTOPID) < 0)
>+		netlink_init_error();
>+
>+	portid = mnl_socket_get_portid(nl);
>+
>+	if (mnl_socket_sendto(nl, nlh, nlh->nlmsg_len) < 0)
>+		netlink_init_error();
>+
>+	ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>+	while (ret > 0) {
>+		ret = mnl_cb_run(buf, ret, seq, portid, data_cb, NULL);
>+		if (ret <= MNL_CB_STOP)
>+			break;
>+		ret = mnl_socket_recvfrom(nl, buf, sizeof(buf));
>+	}
>+	if (ret == -1)
>+		netlink_init_error();
>+
>+	mnl_socket_close(nl);
>+}
>+
>+static void __exit iface_cache_fini(void)
>+{
>+	struct iface *iface, *next;
>+
>+	list_for_each_entry_safe(iface, next, &iface_list, list)
>+		free(iface);
>+}
>diff --git a/src/meta.c b/src/meta.c
>index ad57228..bfc1258 100644
>--- a/src/meta.c
>+++ b/src/meta.c
>@@ -30,6 +30,7 @@
> #include <gmputil.h>
> #include <utils.h>
> #include <erec.h>
>+#include <iface.h>
> 
> static struct symbol_table *realm_tbl;
> static void __init realm_table_init(void)
>@@ -138,7 +139,7 @@ static void ifindex_type_print(const struct expr
>*expr)
> 	int ifindex;
> 
> 	ifindex = mpz_get_uint32(expr->value);
>-	if (if_indextoname(ifindex, name))
>+	if (nft_if_indextoname(ifindex, name))
> 		printf("%s", name);
> 	else
> 		printf("%d", ifindex);
>@@ -149,7 +150,7 @@ static struct error_record
>*ifindex_type_parse(const struct expr *sym,
> {
> 	int ifindex;
> 
>-	ifindex = if_nametoindex(sym->identifier);
>+	ifindex = nft_if_nametoindex(sym->identifier);
> 	if (ifindex == 0)
> 		return error(&sym->location, "Interface does not exist");
> 


