From: fgao@ikuai8.com
Subject: [PATCH 1/1] netfilter: tcp/udp: Only get 4 bytes to get tcp/udp ports
Date: Fri, 22 Jul 2016 23:59:22 +0800
Message-ID: <1469203162-12717-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, kaber@trash.net,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from SMTPBG252.QQ.COM ([183.60.52.105]:54030 "EHLO smtpbg252.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751914AbcGVQCU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2016 12:02:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

We use tcp/udp_pkt_to_tuple to get the ports of tcp/udp.
Actually only need to get 4 bytes by skb_header_pointer instead
of 8 bytes.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v2: Use 4 bytes intead of 8 bytes, and add more description
 v1: Initial Patch

 net/netfilter/nf_conntrack_proto_tcp.c | 4 ++--
 net/netfilter/nf_conntrack_proto_udp.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 70c8381..4abe9e1 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -282,8 +282,8 @@ static bool tcp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 	const struct tcphdr *hp;
 	struct tcphdr _hdr;
 
-	/* Actually only need first 8 bytes. */
-	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
+	/* Actually only need first 4 bytes to get ports. */
+	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
 	if (hp == NULL)
 		return false;
 
diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 4fd0405..8a057e1 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -44,8 +44,8 @@ static bool udp_pkt_to_tuple(const struct sk_buff *skb,
 	const struct udphdr *hp;
 	struct udphdr _hdr;
 
-	/* Actually only need first 8 bytes. */
-	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
+	/* Actually only need first 4 bytes to get ports. */
+	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
 	if (hp == NULL)
 		return false;
 
-- 
1.9.1


