From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 017/103] netfilter: xtables: use better unconditional check
Date: Tue,  4 Aug 2009 09:25:01 +0200
Message-ID: <1249370787-17583-18-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50623 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547AbZHDH0w (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:52 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The use of memcmp should enable architecture-preferred comparison
methods, for example 64-bit comparisons that would complete in [more
than] half the time than inspecting just each u32/char.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   10 +++-------
 net/ipv4/netfilter/ip_tables.c  |   11 +++--------
 net/ipv6/netfilter/ip6_tables.c |   11 +++--------
 3 files changed, 9 insertions(+), 23 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 7505dff..b9f7243 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -341,15 +341,11 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 }
 
 /* All zeroes == unconditional rule. */
-static inline int unconditional(const struct arpt_arp *arp)
+static inline bool unconditional(const struct arpt_arp *arp)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(*arp)/sizeof(__u32); i++)
-		if (((__u32 *)arp)[i])
-			return 0;
+	static const struct arpt_arp uncond;
 
-	return 1;
+	return memcmp(arp, &uncond, sizeof(uncond)) == 0;
 }
 
 /* Figures out from what hook each rule can be called: returns 0 if
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 3856aa3..3431a77 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -190,16 +190,11 @@ get_entry(void *base, unsigned int offset)
 
 /* All zeroes == unconditional rule. */
 /* Mildly perf critical (only if packet tracing is on) */
-static inline int
-unconditional(const struct ipt_ip *ip)
+static inline bool unconditional(const struct ipt_ip *ip)
 {
-	unsigned int i;
+	static const struct ipt_ip uncond;
 
-	for (i = 0; i < sizeof(*ip)/sizeof(__u32); i++)
-		if (((__u32 *)ip)[i])
-			return 0;
-
-	return 1;
+	return memcmp(ip, &uncond, sizeof(uncond)) == 0;
 #undef FWINV
 }
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ced1f2c..1389ad9 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -222,16 +222,11 @@ get_entry(void *base, unsigned int offset)
 
 /* All zeroes == unconditional rule. */
 /* Mildly perf critical (only if packet tracing is on) */
-static inline int
-unconditional(const struct ip6t_ip6 *ipv6)
+static inline bool unconditional(const struct ip6t_ip6 *ipv6)
 {
-	unsigned int i;
-
-	for (i = 0; i < sizeof(*ipv6); i++)
-		if (((char *)ipv6)[i])
-			break;
+	static const struct ip6t_ip6 uncond;
 
-	return (i == sizeof(*ipv6));
+	return memcmp(ipv6, &uncond, sizeof(uncond)) == 0;
 }
 
 #if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
-- 
1.6.3.3

