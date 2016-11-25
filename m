From: Phil Sutter <phil@nwl.cc>
Subject: [iptables PATCH] nft_ipv{4,6}_xlate: Respect prefix lengths
Date: Fri, 25 Nov 2016 18:52:55 +0100
Message-ID: <20161125175255.11878-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47547 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932258AbcKYRxJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Nov 2016 12:53:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This was an annoying bug in the translator since it silently dropped
crucial information which is easily overlooked:

| $ iptables-translate -A INPUT -s 192.168.0.0/24 -j ACCEPT
| nft add rule ip filter INPUT ip saddr 192.168.0.0 counter accept
| $ ip6tables-translate -A INPUT -s feed:babe::/64 -j ACCEPT
| nft add rule ip6 filter INPUT ip6 saddr feed:babe:: counter accept

To my surprise, this fix works really well in all kinds of situations:

| $ iptables-translate -A INPUT -s 1.2.3.4/0 -j ACCEPT
| nft add rule ip filter INPUT counter accept
|
| $ iptables-translate -A INPUT -s 1.2.3.4/23 -j ACCEPT
| nft add rule ip filter INPUT ip saddr 1.2.2.0/23 counter accept
|
| $ iptables-translate -A INPUT -s 1.2.3.4/24 -j ACCEPT
| nft add rule ip filter INPUT ip saddr 1.2.3.0/24 counter accept
|
| $ iptables-translate -A INPUT -s 1.2.3.4/32 -j ACCEPT
| nft add rule ip filter INPUT ip saddr 1.2.3.4 counter accept
|
| $ iptables-translate -A INPUT -s 1.2.3.4/255.255.0.0 -j ACCEPT
| nft add rule ip filter INPUT ip saddr 1.2.0.0/16 counter accept

Ditto for IPv6.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-ipv4.c | 10 ++++++----
 iptables/nft-ipv6.c |  8 +++++---
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 295dd425c14d5..52b1bed2a9ebc 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -471,14 +471,16 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 	}
 
 	if (cs->fw.ip.src.s_addr != 0) {
-		xt_xlate_add(xl, "ip saddr %s%s ",
+		xt_xlate_add(xl, "ip saddr %s%s%s ",
 			   cs->fw.ip.invflags & IPT_INV_SRCIP ? "!= " : "",
-			   inet_ntoa(cs->fw.ip.src));
+			   inet_ntoa(cs->fw.ip.src),
+			   xtables_ipmask_to_numeric(&cs->fw.ip.smsk));
 	}
 	if (cs->fw.ip.dst.s_addr != 0) {
-		xt_xlate_add(xl, "ip daddr %s%s ",
+		xt_xlate_add(xl, "ip daddr %s%s%s ",
 			   cs->fw.ip.invflags & IPT_INV_DSTIP ? "!= " : "",
-			   inet_ntoa(cs->fw.ip.dst));
+			   inet_ntoa(cs->fw.ip.dst),
+			   xtables_ipmask_to_numeric(&cs->fw.ip.dmsk));
 	}
 
 	ret = xlate_matches(cs, xl);
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 8bebf6bef0c09..c475b8e9513ee 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -387,6 +387,7 @@ static void nft_ipv6_save_counters(const void *data)
 }
 
 static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
+			    const struct in6_addr *mask,
 			    int invert, struct xt_xlate *xl)
 {
 	char addr_str[INET6_ADDRSTRLEN];
@@ -395,7 +396,8 @@ static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
 		return;
 
 	inet_ntop(AF_INET6, addr, addr_str, INET6_ADDRSTRLEN);
-	xt_xlate_add(xl, "%s %s%s ", selector, invert ? "!= " : "", addr_str);
+	xt_xlate_add(xl, "%s %s%s%s ", selector, invert ? "!= " : "", addr_str,
+			xtables_ip6mask_to_numeric(mask));
 }
 
 static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
@@ -425,9 +427,9 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 		}
 	}
 
-	xlate_ipv6_addr("ip6 saddr", &cs->fw6.ipv6.src,
+	xlate_ipv6_addr("ip6 saddr", &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
 			cs->fw6.ipv6.invflags & IP6T_INV_SRCIP, xl);
-	xlate_ipv6_addr("ip6 daddr", &cs->fw6.ipv6.dst,
+	xlate_ipv6_addr("ip6 daddr", &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
 			cs->fw6.ipv6.invflags & IP6T_INV_DSTIP, xl);
 
 	ret = xlate_matches(cs, xl);
-- 
2.10.0

