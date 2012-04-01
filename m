From: Changli Gao <xiaosuo@gmail.com>
Subject: [PATCH] netfilter: check the length of the data before dereferencing it
Date: Sun,  1 Apr 2012 22:22:50 +0800
Message-ID: <1333290170-26898-1-git-send-email-xiaosuo@gmail.com>
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	Changli Gao <xiaosuo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40479 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2DAOZf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Apr 2012 10:25:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We should check the length of the data before dereferencing it when parsing
the TCP options.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
---
 net/netfilter/nf_conntrack_proto_tcp.c |    4 ++++
 1 file changed, 4 insertions(+)
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 361eade..9e446c5 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -404,6 +404,8 @@ static void tcp_options(const struct sk_buff *skb,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return;
 			opsize=*ptr++;
 			if (opsize < 2) /* "silly options" */
 				return;
@@ -464,6 +466,8 @@ static void tcp_sack(const struct sk_buff *skb, unsigned int dataoff,
 			length--;
 			continue;
 		default:
+			if (length < 2)
+				return;
 			opsize = *ptr++;
 			if (opsize < 2) /* "silly options" */
 				return;
