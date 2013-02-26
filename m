From: pablo@netfilter.org
Subject: [PATCH] conntrackd: cthelper: add DHCPv6 support
Date: Tue, 26 Feb 2013 01:22:30 +0100
Message-ID: <1361838150-24011-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:50240 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010Ab3BZAWj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:22:39 -0500
Received: from 22.229.78.188.dynamic.jazztel.es ([188.78.229.22]:42120 helo=localhost.localdomain)
	by slan-550-85.anhosting.com with esmtpa (Exim 4.80)
	(envelope-from <pablo@netfilter.org>)
	id 1UA8Ja-002EDl-ED
	for netfilter-devel@vger.kernel.org; Mon, 25 Feb 2013 17:22:38 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds the DHCPv6 helper.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/helper.h        |    2 +
 src/expect.c            |   20 +++++++++
 src/helpers/Makefile.am |    7 +++-
 src/helpers/dhcpv6.c    |  104 +++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 132 insertions(+), 1 deletion(-)
 create mode 100644 src/helpers/dhcpv6.c

diff --git a/include/helper.h b/include/helper.h
index 9d96fb7..c9cb4a6 100644
--- a/include/helper.h
+++ b/include/helper.h
@@ -46,6 +46,8 @@ extern int cthelper_expect_init(struct nf_expect *exp, struct nf_conntrack *mast
 extern int cthelper_add_expect(struct nf_expect *exp);
 extern int cthelper_del_expect(struct nf_expect *exp);
 
+extern int cthelper_update_ct(struct nf_conntrack *ct);
+
 extern void cthelper_get_addr_src(struct nf_conntrack *ct, int dir, union nfct_attr_grp_addr *addr);
 extern void cthelper_get_addr_dst(struct nf_conntrack *ct, int dir, union nfct_attr_grp_addr *addr);
 
diff --git a/src/expect.c b/src/expect.c
index 6069770..552facb 100644
--- a/src/expect.c
+++ b/src/expect.c
@@ -175,6 +175,26 @@ static int cthelper_expect_cmd(struct nf_expect *exp, int cmd)
 	return ret;
 }
 
+static int cthelper_ct_cmd(struct nf_conntrack *ct, int cmd)
+{
+	int ret;
+	struct nfct_handle *h;
+
+	h = nfct_open(CONNTRACK, 0);
+	if (!h)
+		return -1;
+
+	ret = nfct_query(h, cmd, ct);
+
+	nfct_close(h);
+	return ret;
+}
+
+int cthelper_update_ct(struct nf_conntrack *ct)
+{
+	return cthelper_ct_cmd(ct, NFCT_Q_UPDATE);
+}
+
 int cthelper_add_expect(struct nf_expect *exp)
 {
 	return cthelper_expect_cmd(exp, NFCT_Q_CREATE_UPDATE);
diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
index 589b4f3..e254111 100644
--- a/src/helpers/Makefile.am
+++ b/src/helpers/Makefile.am
@@ -2,7 +2,8 @@ include $(top_srcdir)/Make_global.am
 
 pkglib_LTLIBRARIES = ct_helper_ftp.la	\
 		     ct_helper_rpc.la	\
-		     ct_helper_tns.la
+		     ct_helper_tns.la	\
+		     ct_helper_dhcpv6.la
 
 ct_helper_ftp_la_SOURCES = ftp.c
 ct_helper_ftp_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
@@ -15,3 +16,7 @@ ct_helper_rpc_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
 ct_helper_tns_la_SOURCES = tns.c
 ct_helper_tns_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
 ct_helper_tns_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
+
+ct_helper_dhcpv6_la_SOURCES = dhcpv6.c
+ct_helper_dhcpv6_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
+ct_helper_dhcpv6_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
diff --git a/src/helpers/dhcpv6.c b/src/helpers/dhcpv6.c
new file mode 100644
index 0000000..60b5c8c
--- /dev/null
+++ b/src/helpers/dhcpv6.c
@@ -0,0 +1,104 @@
+/*
+ * (C) 2013 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * Based on code from Linux kernel module:
+ *
+ * DHCPv6 multicast connection tracking helper.
+ *
+ * (c) 2012 Google Inc.
+ *
+ * Original author: Darren Willis <djw@google.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include "conntrackd.h"
+#include "helper.h"
+#include "myct.h"
+#include "log.h"
+#include <errno.h>
+#include <netinet/ip.h>
+#include <netinet/ip6.h>
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue_udp.h>
+#include <libnetfilter_queue/pktbuff.h>
+#include <linux/netfilter.h>
+
+#define DHCPV6_CLIENT_PORT 546
+
+static uint16_t dhcpv6_port;
+static unsigned int timeout = 120; /* FIXME: make this configurable */
+
+static inline int ipv6_addr_is_multicast(const struct in6_addr *addr)
+{
+	return (addr->s6_addr32[0] & htonl(0xFF000000)) == htonl(0xFF000000);
+}
+
+static int
+dhcpv6_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
+		 struct myct *myct, uint32_t ctinfo)
+{
+	struct iphdr *iph = (struct iphdr *)pktb_network_header(pkt);
+	struct ip6_hdr *ip6h = (struct ip6_hdr *)pktb_network_header(pkt);
+	int dir = CTINFO2DIR(ctinfo);
+	union nfct_attr_grp_addr addr;
+	struct nf_expect *exp;
+	int ret = NF_ACCEPT;
+
+	if (iph->version != 6)
+		return NF_ACCEPT;
+
+	if (!ipv6_addr_is_multicast(&ip6h->ip6_dst))
+		return NF_ACCEPT;
+
+	exp = nfexp_new();
+	if (exp == NULL)
+		return NF_ACCEPT;
+
+	cthelper_get_addr_src(myct->ct, !dir, &addr);
+
+	if (cthelper_expect_init(exp, myct->ct, 0, NULL, &addr,
+				 IPPROTO_UDP, NULL, &dhcpv6_port,
+				 NF_CT_EXPECT_PERMANENT)) {
+		goto err_exp;
+	}
+
+	if (cthelper_add_expect(exp) < 0) {
+		ret = NF_DROP;
+		goto err_exp;
+	}
+
+	nfct_set_attr_u32(myct->ct, ATTR_TIMEOUT, timeout);
+	cthelper_update_ct(myct->ct);
+
+	ret = NF_ACCEPT;
+err_exp:
+	nfexp_destroy(exp);
+	return ret;
+}
+
+static struct ctd_helper dhcpv6_helper = {
+	.name		= "dhcpv6",
+	.l4proto	= IPPROTO_UDP,
+	.cb		= dhcpv6_helper_cb,
+	.policy		= {
+		[0] = {
+			.name			= "dhcpv6",
+			.expect_max		= 1,
+			.expect_timeout		= 300,
+		},
+	},
+};
+
+void __attribute__ ((constructor)) dhcpv6_init(void);
+
+void dhcpv6_init(void)
+{
+	dhcpv6_port = htons(DHCPV6_CLIENT_PORT);
+	helper_register(&dhcpv6_helper);
+}
-- 
1.7.10.4

