From: fgao@ikuai8.com
Subject: [PATCH 1/1] netfilter: Only need first 4 bytes to get l4proto ports
Date: Sat, 23 Jul 2016 19:21:47 +0800
Message-ID: <1469272907-27761-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, kaber@trash.net,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg342.qq.com ([14.17.44.37]:41227 "EHLO smtpbg342.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335AbcGWL0O (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 07:26:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

We only need first 4 bytes instead of 8 bytes to get the ports of
tcp/udp/dccp/sctp/udplite in their pkt_to_tuple function.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v3: Keep consistent for tcp/udp/dccp/sctp/udplite to get 4 bytes instead of 8 bytes
 v2: Use 4 bytes intead of 8 bytes, and add more description
 v1: Intial Patch
 net/netfilter/nf_conntrack_proto_dccp.c    | 3 ++-
 net/netfilter/nf_conntrack_proto_sctp.c    | 4 ++--
 net/netfilter/nf_conntrack_proto_tcp.c     | 4 ++--
 net/netfilter/nf_conntrack_proto_udp.c     | 4 ++--
 net/netfilter/nf_conntrack_proto_udplite.c | 3 ++-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
index 399a38f..a45bee5 100644
--- a/net/netfilter/nf_conntrack_proto_dccp.c
+++ b/net/netfilter/nf_conntrack_proto_dccp.c
@@ -402,7 +402,8 @@ static bool dccp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 {
 	struct dccp_hdr _hdr, *dh;
 
-	dh = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
+	/* Actually only need first 4 bytes to get ports. */
+	dh = skb_header_pointer(skb, dataoff, 4, &_hdr);
 	if (dh == NULL)
 		return false;
 
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index 1d7ab96..e769f05 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -161,8 +161,8 @@ static bool sctp_pkt_to_tuple(const struct sk_buff *skb, unsigned int dataoff,
 	const struct sctphdr *hp;
 	struct sctphdr _hdr;
 
-	/* Actually only need first 8 bytes. */
-	hp = skb_header_pointer(skb, dataoff, 8, &_hdr);
+	/* Actually only need first 4 bytes to get ports. */
+	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
 	if (hp == NULL)
 		return false;
 
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
 
diff --git a/net/netfilter/nf_conntrack_proto_udplite.c b/net/netfilter/nf_conntrack_proto_udplite.c
index 9d692f5..029206e 100644
--- a/net/netfilter/nf_conntrack_proto_udplite.c
+++ b/net/netfilter/nf_conntrack_proto_udplite.c
@@ -54,7 +54,8 @@ static bool udplite_pkt_to_tuple(const struct sk_buff *skb,
 	const struct udphdr *hp;
 	struct udphdr _hdr;
 
-	hp = skb_header_pointer(skb, dataoff, sizeof(_hdr), &_hdr);
+	/* Actually only need first 4 bytes to get ports. */
+	hp = skb_header_pointer(skb, dataoff, 4, &_hdr);
 	if (hp == NULL)
 		return false;
 
-- 
1.9.1

