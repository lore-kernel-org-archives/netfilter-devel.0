From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: [iptables-compat PATCH 4/5 v2] nft: adds a bitwise operation to a rule
Date: Fri, 22 Aug 2014 11:16:32 +0200
Message-ID: <1408698993-17706-4-git-send-email-giuseppelng@gmail.com>
References: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Cc: Giuseppe Longo <giuseppelng@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:34348 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaHVJNB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:13:01 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so10343354wes.35
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2014 02:12:59 -0700 (PDT)
In-Reply-To: <1408698993-17706-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds a bitwise operation to a rule

Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
---
 iptables/nft-arp.c    |  9 +++++----
 iptables/nft-ipv4.c   | 10 ++++++----
 iptables/nft-ipv6.c   | 10 ++++++----
 iptables/nft-shared.c | 13 +++++++++++--
 iptables/nft-shared.h |  4 ++--
 5 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index bc25de3..c9dbee6 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -202,8 +202,8 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 	}
 
 	if (fw->arp.src.s_addr != 0)
-		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln,
-			 &fw->arp.src.s_addr, 4, flags);
+		add_addr(r, AF_INET, sizeof(struct arphdr) + fw->arp.arhln,
+			 &fw->arp.src.s_addr, NULL, 4, flags);
 
 	if (fw->arp.tgt_devaddr.addr[0] != '\0') {
 		add_payload(r, sizeof(struct arphdr) + fw->arp.arhln + 4, fw->arp.arhln);
@@ -211,8 +211,9 @@ static int nft_arp_add(struct nft_rule *r, void *data)
 	}
 
 	if (fw->arp.tgt.s_addr != 0)
-		add_addr(r, sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
-			 &fw->arp.tgt.s_addr, 4, flags);
+		add_addr(r, AF_INET,
+			 sizeof(struct arphdr) + fw->arp.arhln + sizeof(struct in_addr),
+			 &fw->arp.tgt.s_addr, NULL, 4, flags);
 
 	/* Counters need to me added before the target, otherwise they are
 	 * increased for each rule because of the way nf_tables works.
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 70050ba..6e520b2 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -42,12 +42,14 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 			  cs->fw.ip.proto, cs->fw.ip.invflags);
 
 	if (cs->fw.ip.src.s_addr != 0)
-		add_addr(r, offsetof(struct iphdr, saddr),
-			 &cs->fw.ip.src.s_addr, 4, cs->fw.ip.invflags);
+		add_addr(r, AF_INET, offsetof(struct iphdr, saddr),
+			 &cs->fw.ip.src.s_addr, &cs->fw.ip.smsk.s_addr,
+			 4, cs->fw.ip.invflags);
 
 	if (cs->fw.ip.dst.s_addr != 0)
-		add_addr(r, offsetof(struct iphdr, daddr),
-			 &cs->fw.ip.dst.s_addr, 4, cs->fw.ip.invflags);
+		add_addr(r, AF_INET, offsetof(struct iphdr, daddr),
+			 &cs->fw.ip.dst.s_addr, &cs->fw.ip.dmsk.s_addr,
+			 4, cs->fw.ip.invflags);
 
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		add_payload(r, offsetof(struct iphdr, frag_off), 2);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 52de5b6..662c563 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -39,12 +39,14 @@ static int nft_ipv6_add(struct nft_rule *r, void *data)
 			  cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
 
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.src))
-		add_addr(r, offsetof(struct ip6_hdr, ip6_src),
-			 &cs->fw6.ipv6.src, 16, cs->fw6.ipv6.invflags);
+		add_addr(r, AF_INET6, offsetof(struct ip6_hdr, ip6_src),
+			 &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
+			 16, cs->fw6.ipv6.invflags);
 
 	if (!IN6_IS_ADDR_UNSPECIFIED(&cs->fw6.ipv6.dst))
-		add_addr(r, offsetof(struct ip6_hdr, ip6_dst),
-			 &cs->fw6.ipv6.dst, 16, cs->fw6.ipv6.invflags);
+		add_addr(r, AF_INET6, offsetof(struct ip6_hdr, ip6_dst),
+			 &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
+			 16, cs->fw6.ipv6.invflags);
 
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags);
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 3ffe877..2dcdfd1 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -184,8 +184,8 @@ void add_outiface(struct nft_rule *r, char *iface, int invflags)
 		add_cmp_ptr(r, op, iface, iface_len + 1);
 }
 
-void add_addr(struct nft_rule *r, int offset,
-	      void *data, size_t len, int invflags)
+void add_addr(struct nft_rule *r, int family, int offset,
+	      void *data, void *mask, size_t len, int invflags)
 {
 	uint32_t op;
 
@@ -197,6 +197,15 @@ void add_addr(struct nft_rule *r, int offset,
 		op = NFT_CMP_EQ;
 
 	add_cmp_ptr(r, op, data, len);
+
+	if (family == AF_INET) {
+		uint32_t *msk = mask;
+		add_bitwise_u32(r, *msk, 0x00000000);
+	} else {
+		uint8_t mask6[16] = {0};
+		uint8_t xor[16] = {0};
+		add_bitwise_u128(r, mask6, xor);
+	}
 }
 
 void add_proto(struct nft_rule *r, int offset, size_t len,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index f2896bb..e5b6f1d 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -83,8 +83,8 @@ void add_cmp_u16(struct nft_rule *r, uint16_t val, uint32_t op);
 void add_cmp_u32(struct nft_rule *r, uint32_t val, uint32_t op);
 void add_iniface(struct nft_rule *r, char *iface, int invflags);
 void add_outiface(struct nft_rule *r, char *iface, int invflags);
-void add_addr(struct nft_rule *r, int offset,
-	      void *data, size_t len, int invflags);
+void add_addr(struct nft_rule *r, int family, int offset,
+	      void *data, void *mask, size_t len, int invflags);
 void add_proto(struct nft_rule *r, int offset, size_t len,
 	       uint8_t proto, int invflags);
 void add_compat(struct nft_rule *r, uint32_t proto, bool inv);
-- 
1.8.3.2

