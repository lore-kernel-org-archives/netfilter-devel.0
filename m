From: Ash Hughes <ashley.hughes@blueyonder.co.uk>
Subject: [PATCH] userspace SSDP conntrack helper
Date: Sat, 08 Mar 2014 15:59:47 +0000
Message-ID: <531B3E73.3080801@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from know-smtprelay-omc-2.server.virginmedia.net ([80.0.253.66]:56204
	"EHLO know-smtprelay-omc-2.server.virginmedia.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaCHQFa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 11:05:30 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Here is a patch which adds a userspace conntrack helper for the SSDP
protocol. This is based on the code found at:

http://marc.info/?t=132945775100001&r=1&w=2

I'm not sure how to get my laptop to play at IPv6, so I've not tested
this part, but I've tested the IPv4 section and it works. What more
needs to be done to get this merged in? :)

To get this to work, I've followed the instructions here:

http://conntrack-tools.netfilter.org/manual.html#helpers

That is:

nfct helper add ssdp inet udp
iptables --verbose -I OUTPUT 1 -t raw -p udp --dport 1900 -j CT --helper ssdp

And the following in conntrackd.conf:

Type ssdp inet udp {
	#
	# Set NFQUEUE number you want to use to receive traffic from
	# the kernel.
	#
	QueueNum 0

	#
	# Maximum number of packets waiting in the queue to receive
	# a verdict from user-space. Default is 1024.
	#
	# Rise value if you hit the following error message:
	# "nf_queue: full at X entries, dropping packets(s)"
	#
	QueueLen 10240

	#
	# Set the Expectation policy for this helper.
	#
	Policy ssdp {
		#
		# Maximum number of simultaneous expectations
		#
		ExpectMax 1
		#
		# Maximum living time for one expectation (in seconds).
		#
		ExpectTimeout 300
	}
}

Thanks,

Ash

---
diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
index fe28e83..947e58b 100644
--- a/src/helpers/Makefile.am
+++ b/src/helpers/Makefile.am
@@ -6,7 +6,8 @@ pkglib_LTLIBRARIES = ct_helper_amanda.la \
 		     ct_helper_rpc.la	\
 		     ct_helper_tftp.la	\
 		     ct_helper_tns.la	\
-		     ct_helper_sane.la
+		     ct_helper_sane.la  \
+             ct_helper_ssdp.la

 ct_helper_amanda_la_SOURCES = amanda.c
 ct_helper_amanda_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
@@ -35,3 +36,7 @@ ct_helper_tns_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
 ct_helper_sane_la_SOURCES = sane.c
 ct_helper_sane_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
 ct_helper_sane_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
+
+ct_helper_ssdp_la_SOURCES = ssdp.c
+ct_helper_ssdp_la_LDFLAGS = -avoid-version -module $(LIBNETFILTER_CONNTRACK_LIBS)
+ct_helper_ssdp_la_CFLAGS = $(AM_CFLAGS) $(LIBNETFILTER_CONNTRACK_CFLAGS)
diff --git a/src/helpers/ssdp.c b/src/helpers/ssdp.c
new file mode 100644
index 0000000..0011f51
--- /dev/null
+++ b/src/helpers/ssdp.c
@@ -0,0 +1,135 @@
+/*
+ * SSDP connection tracking helper
+ * (SSDP = Simple Service Discovery Protocol)
+ * For documentation about SSDP see
+ * http://en.wikipedia.org/wiki/Simple_Service_Discovery_Protocol
+ *
+ * Copyright (C) 2014 Ashley Hughes <ashley.hughes@blueyonder.co.uk>
+ * Based on the SSDP conntrack helper (nf_conntrack_ssdp.c),
+ * :http://marc.info/?t=132945775100001&r=1&w=2
+ *  (C) 2012 Ian Pilcher <arequipeno@gmail.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "conntrackd.h"
+#include "helper.h"
+#include "myct.h"
+#include "log.h"
+#include <errno.h>
+#include <arpa/inet.h>
+#include <netinet/ip.h>
+#include <netinet/udp.h>
+#include <libmnl/libmnl.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_queue/libnetfilter_queue.h>
+#include <libnetfilter_queue/libnetfilter_queue_tcp.h>
+#include <libnetfilter_queue/pktbuff.h>
+#include <linux/netfilter.h>
+
+#define SSDP_MCAST_ADDR		"239.255.255.250"
+#define UPNP_MCAST_LL_ADDR "FF02::C" /* link-local */
+#define UPNP_MCAST_SL_ADDR "FF05::C" /* site-local */
+
+#define SSDP_M_SEARCH		"M-SEARCH"
+#define SSDP_M_SEARCH_SIZE	(sizeof SSDP_M_SEARCH - 1)
+
+static int
+ssdp_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
+		 struct myct *myct, uint32_t ctinfo)
+{
+
+	int ret = NF_ACCEPT;
+	union nfct_attr_grp_addr daddr, saddr, taddr;
+    struct iphdr *net_hdr = (struct iphdr *)pktb_network_header(pkt);
+    int good_packet = 0;
+	struct nf_expect *exp;
+    u_int16_t port;
+	unsigned int dataoff;
+	void *sb_ptr;
+
+    cthelper_get_addr_dst(myct->ct, MYCT_DIR_ORIG, &daddr);
+    switch(nfct_get_attr_u8(myct->ct, ATTR_L3PROTO)) {
+		case AF_INET:
+            inet_pton(AF_INET, SSDP_MCAST_ADDR, &(taddr.ip));
+            if (daddr.ip == taddr.ip)
+                good_packet = 1;
+			break;
+		case AF_INET6:
+            inet_pton(AF_INET6, UPNP_MCAST_LL_ADDR, &(taddr.ip6));
+            if (daddr.ip6[0] == taddr.ip6[0] && daddr.ip6[1] == taddr.ip6[1]
+                && daddr.ip6[2] == taddr.ip6[2] && daddr.ip6[3] == taddr.ip6[3]) {
+                good_packet = 1;
+                break;
+            }
+            inet_pton(AF_INET6, UPNP_MCAST_SL_ADDR, &(taddr.ip6));
+            if (daddr.ip6[0] == taddr.ip6[0] && daddr.ip6[1] == taddr.ip6[1]
+                && daddr.ip6[2] == taddr.ip6[2] && daddr.ip6[3] == taddr.ip6[3]) {
+                good_packet = 1;
+                break;
+            }
+			break;
+		default:
+			break;
+    }
+
+    if (!good_packet) {
+        pr_debug("ssdp_help: destination address not multicast; ignoring\n");
+        return NF_ACCEPT;
+    }
+
+    /* No data? Ignore */
+	dataoff = net_hdr->ihl*4 + sizeof(struct udphdr);
+	if (dataoff >= pktb_len(pkt)) {
+		pr_debug("ssdp_help: UDP payload too small for M-SEARCH; ignoring\n");
+		return NF_ACCEPT;
+    }
+
+	sb_ptr = pktb_network_header(pkt) + dataoff;
+
+	if (memcmp(sb_ptr, SSDP_M_SEARCH, SSDP_M_SEARCH_SIZE) != 0) {
+		pr_debug("ssdp_help: UDP payload does not begin with 'M-SEARCH'; ignoring\n");
+		return NF_ACCEPT;
+	}
+
+
+
+	cthelper_get_addr_src(myct->ct, MYCT_DIR_ORIG, &saddr);
+    cthelper_get_port_src(myct->ct, MYCT_DIR_ORIG, &port);
+
+	exp = nfexp_new();
+	if (exp == NULL)
+		return NF_DROP;
+
+	if (cthelper_expect_init(exp, myct->ct, 0, NULL, &saddr,
+				 IPPROTO_UDP, NULL, &port, 0)) {
+		nfexp_destroy(exp);
+		return NF_DROP;
+	}
+
+    myct->exp = exp;
+
+	return ret;
+}
+
+static struct ctd_helper ssdp_helper = {
+	.name		= "ssdp",
+	.l4proto	= IPPROTO_UDP,
+	.priv_data_len	= 0,
+	.cb		= ssdp_helper_cb,
+	.policy		= {
+		[0] = {
+			.name			= "ssdp",
+			.expect_max		= 1,
+			.expect_timeout		= 5 * 60,
+		},
+	},
+};
+
+static void __attribute__ ((constructor)) ssdp_init(void)
+{
+	helper_register(&ssdp_helper);
+}
+
