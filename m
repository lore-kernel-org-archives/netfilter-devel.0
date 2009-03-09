From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: [PATCH] netfilter: remove IPvX specific parts from nf_conntrack_l4proto.h
Date: Mon,  9 Mar 2009 17:14:18 +0100
Message-ID: <1236615258-12897-1-git-send-email-christoph.paasch@gmail.com>
Cc: Christoph Paasch <christoph.paasch@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:39519 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZCIQOY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:14:24 -0400
Received: by ewy25 with SMTP id 25so916587ewy.37
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Mar 2009 09:14:21 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Moving the structure definitions to the corresponding IPvX specific header files.
---
 include/net/netfilter/nf_conntrack_l4proto.h   |    5 +----
 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
 net/netfilter/nf_conntrack_proto_tcp.c         |    2 ++
 net/netfilter/nf_conntrack_proto_udp.c         |    2 ++
 4 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index debdaf7..16ab604 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -90,10 +90,7 @@ struct nf_conntrack_l4proto
 	struct module *me;
 };
 
-/* Existing built-in protocols */
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp6;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4;
-extern struct nf_conntrack_l4proto nf_conntrack_l4proto_udp6;
+/* Existing built-in generic protocol */
 extern struct nf_conntrack_l4proto nf_conntrack_l4proto_generic;
 
 #define MAX_NF_CT_PROTO 256
diff --git a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
index 727b953..e6852f6 100644
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
@@ -26,6 +26,7 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_l3proto.h>
 #include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
 static bool ipv6_pkt_to_tuple(const struct sk_buff *skb, unsigned int nhoff,
 			      struct nf_conntrack_tuple *tuple)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index a1edb9c..7d3944f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -25,6 +25,8 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_log.h>
+#include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
 /* Protects ct->proto.tcp */
 static DEFINE_RWLOCK(tcp_lock);
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 2b8b1f5..d402117 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -22,6 +22,8 @@
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_ecache.h>
 #include <net/netfilter/nf_log.h>
+#include <net/netfilter/ipv4/nf_conntrack_ipv4.h>
+#include <net/netfilter/ipv6/nf_conntrack_ipv6.h>
 
 static unsigned int nf_ct_udp_timeout __read_mostly = 30*HZ;
 static unsigned int nf_ct_udp_timeout_stream __read_mostly = 180*HZ;
-- 
1.5.6.3

