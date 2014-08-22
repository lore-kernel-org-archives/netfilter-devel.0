From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 3/5 v2] nft: compare layer 4 protocol in first place
Date: Fri, 22 Aug 2014 11:16:31 +0200
Message-ID: <1408698993-17706-3-git-send-email-giuseppelng@gmail.com>
References: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36426 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaHVJM6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:12:58 -0400
Received: by mail-wi0-f170.google.com with SMTP id f8so717557wiw.5
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2014 02:12:57 -0700 (PDT)
In-Reply-To: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently the protocol is tested after the ip address,
this fixes the order testing the protocol before the ip address.

Now the code generated is incorrect:

ip filter INPUT 16
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x0100a8c0 ]
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ match name tcp rev 0 ]
  [ match name conntrack rev 3 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

With this patch, the code generated is:
ip filter INPUT 16
  [ payload load 1b @ network header + 9 => reg 1 ]
  [ cmp eq reg 1 0x00000006 ]
  [ payload load 4b @ network header + 12 => reg 1 ]
  [ cmp eq reg 1 0x0100a8c0 ]
  [ bitwise reg 1 = (reg=1 & 0xffffffff ) ^ 0x00000000 ]
  [ match name tcp rev 0 ]
  [ match name conntrack rev 3 ]
  [ counter pkts 0 bytes 0 ]
  [ immediate reg 0 accept ]

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-ipv4.c | 8 ++++----
 iptables/nft-ipv6.c | 8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 33bc581..70050ba 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -37,6 +37,10 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 	if (cs->fw.ip.outiface[0] != '\0')
 		add_outiface(r, cs->fw.ip.outiface, cs->fw.ip.invflags);
 
+	if (cs->fw.ip.proto != 0)
+		add_proto(r, offsetof(struct iphdr, protocol), 1,
+			  cs->fw.ip.proto, cs->fw.ip.invflags);
+
 	if (cs->fw.ip.src.s_addr != 0)
 		add_addr(r, offsetof(struct iphdr, saddr),
 			 &cs->fw.ip.src.s_addr, 4, cs->fw.ip.invflags);
@@ -45,10 +49,6 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 		add_addr(r, offsetof(struct iphdr, daddr),
 			 &cs->fw.ip.dst.s_addr, 4, cs->fw.ip.invflags);
 
-	if (cs->fw.ip.proto != 0)
-		add_proto(r, offsetof(struct iphdr, protocol), 1,
-			  cs->fw.ip.proto, cs->fw.ip.invflags);
-
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		add_payload(r, offsetof(struct iphdr, frag_off), 2);
 		/* get the 13 bits that contain the fragment offset */
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 00f1bf8..52de5b6 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -34,6 +34,10 @@ static int nft_ipv6_add(struct nft_rule *r, void *data)
 	if (cs->fw6.ipv6.outiface[0] != '\0')
 		add_outiface(r, cs->fw6.ipv6.outiface, cs->fw6.ipv6.invflags);
 
+	if (cs->fw6.ipv6.proto != 0)
+		add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
+			  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
+
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src))
 		add_addr(r, offsetof(struct ip6_hdr, ip6_src),
 			 &cs->fw6.ipv6.src, 16, cs->fw6.ipv6.invflags);
@@ -42,10 +46,6 @@ static int nft_ipv6_add(struct nft_rule *r, void *data)
 		add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
 			 &cs->fw6.ipv6.dst, 16, cs->fw6.ipv6.invflags);
 
-	if (cs->fw6.ipv6.proto != 0)
-		add_proto(r, offsetof(struct ip6_hdr, ip6_nxt), 1,
-			  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
-
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-- 
1.8.3.2

