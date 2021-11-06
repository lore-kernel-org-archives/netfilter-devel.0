Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46784C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21286611EE
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 20:58:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbhKFVAx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 17:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhKFVAx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 17:00:53 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C70D8C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 13:58:11 -0700 (PDT)
Received: from localhost ([::1]:58752 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mjSlO-000467-7V; Sat, 06 Nov 2021 21:58:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 05/10] xshared: Share save_ipv{4,6}_addr() with legacy
Date:   Sat,  6 Nov 2021 21:57:51 +0100
Message-Id: <20211106205756.14529-6-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211106205756.14529-1-phil@nwl.cc>
References: <20211106205756.14529-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

While being at it, make save_ipv4_addr() accept an in_addr* as mask -
mask_to_str() needs it anyway.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 29 ++++------------------
 iptables/iptables.c  | 36 +++-------------------------
 iptables/nft-ipv4.c  | 43 ++-------------------------------
 iptables/nft-ipv6.c  | 20 ----------------
 iptables/xshared.c   | 57 ++++++++++++++++++++++++++++++++++++++++++++
 iptables/xshared.h   |  4 ++++
 6 files changed, 70 insertions(+), 119 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index eacbf704f9769..5c118626a5d23 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -738,27 +738,6 @@ static int print_match_save(const struct xt_entry_match *e,
 	return 0;
 }
 
-/* Print a given ip including mask if necessary. */
-static void print_ip(const char *prefix, const struct in6_addr *ip,
-		     const struct in6_addr *mask, int invert)
-{
-	char buf[51];
-	int l = xtables_ip6mask_to_cidr(mask);
-
-	if (l == 0 && !invert)
-		return;
-
-	printf("%s %s %s",
-		invert ? " !" : "",
-		prefix,
-		inet_ntop(AF_INET6, ip, buf, sizeof buf));
-
-	if (l == -1)
-		printf("/%s", inet_ntop(AF_INET6, mask, buf, sizeof buf));
-	else
-		printf("/%d", l);
-}
-
 /* We want this to be readable, so only print out necessary fields.
  * Because that's the kind of world I want to live in.
  */
@@ -776,11 +755,11 @@ void print_rule6(const struct ip6t_entry *e,
 	printf("-A %s", chain);
 
 	/* Print IP part. */
-	print_ip("-s", &(e->ipv6.src), &(e->ipv6.smsk),
-			e->ipv6.invflags & IP6T_INV_SRCIP);
+	save_ipv6_addr('s', &e->ipv6.src, &e->ipv6.smsk,
+		       e->ipv6.invflags & IP6T_INV_SRCIP);
 
-	print_ip("-d", &(e->ipv6.dst), &(e->ipv6.dmsk),
-			e->ipv6.invflags & IP6T_INV_DSTIP);
+	save_ipv6_addr('d', &e->ipv6.dst, &e->ipv6.dmsk,
+		       e->ipv6.invflags & IP6T_INV_DSTIP);
 
 	save_rule_details(e->ipv6.iniface, e->ipv6.iniface_mask,
 			  e->ipv6.outiface, e->ipv6.outiface_mask,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 85fb7bdcd0ca1..0d8beb04c0f99 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -738,36 +738,6 @@ static int print_match_save(const struct xt_entry_match *e,
 	return 0;
 }
 
-/* Print a given ip including mask if necessary. */
-static void print_ip(const char *prefix, uint32_t ip,
-		     uint32_t mask, int invert)
-{
-	uint32_t bits, hmask = ntohl(mask);
-	int i;
-
-	if (!mask && !ip && !invert)
-		return;
-
-	printf("%s %s %u.%u.%u.%u",
-		invert ? " !" : "",
-		prefix,
-		IP_PARTS(ip));
-
-	if (mask == 0xFFFFFFFFU) {
-		printf("/32");
-		return;
-	}
-
-	i    = 32;
-	bits = 0xFFFFFFFEU;
-	while (--i >= 0 && hmask != bits)
-		bits <<= 1;
-	if (i >= 0)
-		printf("/%u", i);
-	else
-		printf("/%u.%u.%u.%u", IP_PARTS(mask));
-}
-
 /* We want this to be readable, so only print out necessary fields.
  * Because that's the kind of world I want to live in.
  */
@@ -785,10 +755,10 @@ void print_rule4(const struct ipt_entry *e,
 	printf("-A %s", chain);
 
 	/* Print IP part. */
-	print_ip("-s", e->ip.src.s_addr,e->ip.smsk.s_addr,
-			e->ip.invflags & IPT_INV_SRCIP);
+	save_ipv4_addr('s', &e->ip.src, &e->ip.smsk,
+		       e->ip.invflags & IPT_INV_SRCIP);
 
-	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
+	save_ipv4_addr('d', &e->ip.dst, &e->ip.dmsk,
 			e->ip.invflags & IPT_INV_DSTIP);
 
 	save_rule_details(e->ip.iniface, e->ip.iniface_mask,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 39d6e61232cdb..dcc009cf67a81 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -134,32 +134,6 @@ static void get_frag(struct nft_xt_ctx *ctx, struct nftnl_expr *e, bool *inv)
 	ctx->flags &= ~NFT_XT_CTX_BITWISE;
 }
 
-static const char *mask_to_str(uint32_t mask)
-{
-	static char mask_str[INET_ADDRSTRLEN];
-	uint32_t bits, hmask = ntohl(mask);
-	struct in_addr mask_addr = {
-		.s_addr = mask,
-	};
-	int i;
-
-	if (mask == 0xFFFFFFFFU) {
-		sprintf(mask_str, "32");
-		return mask_str;
-	}
-
-	i    = 32;
-	bits = 0xFFFFFFFEU;
-	while (--i >= 0 && hmask != bits)
-		bits <<= 1;
-	if (i >= 0)
-		sprintf(mask_str, "%u", i);
-	else
-		inet_ntop(AF_INET, &mask_addr, mask_str, sizeof(mask_str));
-
-	return mask_str;
-}
-
 static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
 				void *data)
 {
@@ -295,26 +269,13 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	nft_clear_iptables_command_state(&cs);
 }
 
-static void save_ipv4_addr(char letter, const struct in_addr *addr,
-			   uint32_t mask, int invert)
-{
-	char addrbuf[INET_ADDRSTRLEN];
-
-	if (!mask && !invert && !addr->s_addr)
-		return;
-
-	printf("%s -%c %s/%s", invert ? " !" : "", letter,
-	       inet_ntop(AF_INET, addr, addrbuf, sizeof(addrbuf)),
-	       mask_to_str(mask));
-}
-
 static void nft_ipv4_save_rule(const void *data, unsigned int format)
 {
 	const struct iptables_command_state *cs = data;
 
-	save_ipv4_addr('s', &cs->fw.ip.src, cs->fw.ip.smsk.s_addr,
+	save_ipv4_addr('s', &cs->fw.ip.src, &cs->fw.ip.smsk,
 		       cs->fw.ip.invflags & IPT_INV_SRCIP);
-	save_ipv4_addr('d', &cs->fw.ip.dst, cs->fw.ip.dmsk.s_addr,
+	save_ipv4_addr('d', &cs->fw.ip.dst, &cs->fw.ip.dmsk,
 		       cs->fw.ip.invflags & IPT_INV_DSTIP);
 
 	save_rule_details(cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 0c73cedd71c96..0b35e0457a067 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -224,26 +224,6 @@ static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	nft_clear_iptables_command_state(&cs);
 }
 
-static void save_ipv6_addr(char letter, const struct in6_addr *addr,
-			   const struct in6_addr *mask,
-			   int invert)
-{
-	char addr_str[INET6_ADDRSTRLEN];
-	int l = xtables_ip6mask_to_cidr(mask);
-
-	if (!invert && l == 0)
-		return;
-
-	printf("%s -%c %s",
-		invert ? " !" : "", letter,
-		inet_ntop(AF_INET6, addr, addr_str, sizeof(addr_str)));
-
-	if (l == -1)
-		printf("/%s", inet_ntop(AF_INET6, mask, addr_str, sizeof(addr_str)));
-	else
-		printf("/%d", l);
-}
-
 static void nft_ipv6_save_rule(const void *data, unsigned int format)
 {
 	const struct iptables_command_state *cs = data;
diff --git a/iptables/xshared.c b/iptables/xshared.c
index db701ead4811f..3e06960fcf015 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -9,6 +9,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <arpa/inet.h>
 #include <sys/file.h>
 #include <sys/socket.h>
 #include <sys/un.h>
@@ -578,6 +579,42 @@ void print_ipv4_addresses(const struct ipt_entry *fw, unsigned int format)
 	       ipv4_addr_to_string(&fw->ip.dst, &fw->ip.dmsk, format));
 }
 
+static const char *mask_to_str(const struct in_addr *mask)
+{
+	uint32_t bits, hmask = ntohl(mask->s_addr);
+	static char mask_str[INET_ADDRSTRLEN];
+	int i;
+
+	if (mask->s_addr == 0xFFFFFFFFU) {
+		sprintf(mask_str, "32");
+		return mask_str;
+	}
+
+	i    = 32;
+	bits = 0xFFFFFFFEU;
+	while (--i >= 0 && hmask != bits)
+		bits <<= 1;
+	if (i >= 0)
+		sprintf(mask_str, "%u", i);
+	else
+		inet_ntop(AF_INET, mask, mask_str, sizeof(mask_str));
+
+	return mask_str;
+}
+
+void save_ipv4_addr(char letter, const struct in_addr *addr,
+		    const struct in_addr *mask, int invert)
+{
+	char addrbuf[INET_ADDRSTRLEN];
+
+	if (!mask->s_addr && !invert && !addr->s_addr)
+		return;
+
+	printf("%s -%c %s/%s", invert ? " !" : "", letter,
+	       inet_ntop(AF_INET, addr, addrbuf, sizeof(addrbuf)),
+	       mask_to_str(mask));
+}
+
 static const char *ipv6_addr_to_string(const struct in6_addr *addr,
 				       const struct in6_addr *mask,
 				       unsigned int format)
@@ -612,6 +649,26 @@ void print_ipv6_addresses(const struct ip6t_entry *fw6, unsigned int format)
 				   &fw6->ipv6.dmsk, format));
 }
 
+void save_ipv6_addr(char letter, const struct in6_addr *addr,
+		    const struct in6_addr *mask, int invert)
+{
+	int l = xtables_ip6mask_to_cidr(mask);
+	char addr_str[INET6_ADDRSTRLEN];
+
+	if (!invert && l == 0)
+		return;
+
+	printf("%s -%c %s",
+		invert ? " !" : "", letter,
+		inet_ntop(AF_INET6, addr, addr_str, sizeof(addr_str)));
+
+	if (l == -1)
+		printf("/%s", inet_ntop(AF_INET6, mask,
+					addr_str, sizeof(addr_str)));
+	else
+		printf("/%d", l);
+}
+
 /* Luckily, IPT_INV_VIA_IN and IPT_INV_VIA_OUT
  * have the same values as IP6T_INV_VIA_IN and IP6T_INV_VIA_OUT
  * so this function serves for both iptables and ip6tables */
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 484ade126404c..46ad5a2962c71 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -222,7 +222,11 @@ const char *ipv4_addr_to_string(const struct in_addr *addr,
 				const struct in_addr *mask,
 				unsigned int format);
 void print_ipv4_addresses(const struct ipt_entry *fw, unsigned int format);
+void save_ipv4_addr(char letter, const struct in_addr *addr,
+		    const struct in_addr *mask, int invert);
 void print_ipv6_addresses(const struct ip6t_entry *fw6, unsigned int format);
+void save_ipv6_addr(char letter, const struct in6_addr *addr,
+		    const struct in6_addr *mask, int invert);
 
 void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 		  unsigned int format);
-- 
2.33.0

