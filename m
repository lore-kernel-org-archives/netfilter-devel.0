From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH 3/8] net: introduce proto_ports_offset()
Date: Wed, 18 Aug 2010 13:03:44 +0800
Message-ID: <1282107824-3507-1-git-send-email-xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
	Jamal Hadi Salim <hadi@cyberus.ca>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Changli Gao <xiaosuo@gmail.com>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60487 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493Ab0HRFD4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:03:56 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce proto_ports_offset() for getting the position of the ports or
SPI in the message of a protocol.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 include/linux/in.h |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)
diff --git a/include/linux/in.h b/include/linux/in.h
index 41d88a4..beeb6de 100644
--- a/include/linux/in.h
+++ b/include/linux/in.h
@@ -250,6 +250,25 @@ struct sockaddr_in {
 
 #ifdef __KERNEL__
 
+#include <linux/errno.h>
+
+static inline int proto_ports_offset(int proto)
+{
+	switch (proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_DCCP:
+	case IPPROTO_ESP:	/* SPI */
+	case IPPROTO_SCTP:
+	case IPPROTO_UDPLITE:
+		return 0;
+	case IPPROTO_AH:	/* SPI */
+		return 4;
+	default:
+		return -EINVAL;
+	}
+}
+
 static inline bool ipv4_is_loopback(__be32 addr)
 {
 	return (addr & htonl(0xff000000)) == htonl(0x7f000000);
