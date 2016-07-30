From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] iptables-translate: add in/out ifname wildcard match translation to nft
Date: Sat, 30 Jul 2016 13:20:59 +0800
Message-ID: <1469856059-11891-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:53059 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbcG3FVo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2016 01:21:44 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

In iptables, "-i eth+" means match all in ifname with the prefix "eth".
But in nftables, this was changed to "iifname eth*". So we should handle
this subtle difference.

Apply this patch, translation will become:
  # iptables-translate -A INPUT -i eth+
  nft add rule ip filter INPUT iifname eth* counter
  # ip6tables-translate -A OUTPUT ! -o eth+
  nft add rule ip6 filter OUTPUT oifname != eth* counter

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 iptables/nft-ipv4.c          | 14 ++++----------
 iptables/nft-ipv6.c          | 16 ++++------------
 iptables/nft.h               |  2 ++
 iptables/xtables-translate.c | 17 +++++++++++++++++
 4 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 814ca14..50706cb 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -444,16 +444,10 @@ static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
 	const char *comment;
 	int ret;
 
-	if (cs->fw.ip.iniface[0] != '\0') {
-		xt_xlate_add(xl, "iifname %s%s ",
-			   cs->fw.ip.invflags & IPT_INV_VIA_IN ? "!= " : "",
-			   cs->fw.ip.iniface);
-	}
-	if (cs->fw.ip.outiface[0] != '\0') {
-		xt_xlate_add(xl, "oifname %s%s ",
-			   cs->fw.ip.invflags & IPT_INV_VIA_OUT? "!= " : "",
-			   cs->fw.ip.outiface);
-	}
+	xlate_ifname(xl, "iifname", cs->fw.ip.iniface,
+		     cs->fw.ip.invflags & IPT_INV_VIA_IN);
+	xlate_ifname(xl, "oifname", cs->fw.ip.outiface,
+		     cs->fw.ip.invflags & IPT_INV_VIA_OUT);
 
 	if (cs->fw.ip.flags & IPT_F_FRAG) {
 		xt_xlate_add(xl, "ip frag-off %s%x ",
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index bfbf8df..8ca523c 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -404,18 +404,10 @@ static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
 	const char *comment;
 	int ret;
 
-	if (cs->fw6.ipv6.iniface[0] != '\0') {
-		xt_xlate_add(xl, "iifname %s%s ",
-			   cs->fw6.ipv6.invflags & IP6T_INV_VIA_IN ?
-				"!= " : "",
-			   cs->fw6.ipv6.iniface);
-	}
-	if (cs->fw6.ipv6.outiface[0] != '\0') {
-		xt_xlate_add(xl, "oifname %s%s ",
-			   cs->fw6.ipv6.invflags & IP6T_INV_VIA_OUT ?
-				"!= " : "",
-			   cs->fw6.ipv6.outiface);
-	}
+	xlate_ifname(xl, "iifname", cs->fw6.ipv6.iniface,
+		     cs->fw6.ipv6.invflags & IP6T_INV_VIA_IN);
+	xlate_ifname(xl, "oifname", cs->fw6.ipv6.outiface,
+		     cs->fw6.ipv6.invflags & IP6T_INV_VIA_OUT);
 
 	if (cs->fw6.ipv6.proto != 0) {
 		const struct protoent *pent =
diff --git a/iptables/nft.h b/iptables/nft.h
index 9e02eeb..8867434 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -165,6 +165,8 @@ bool xlate_find_match(const struct iptables_command_state *cs, const char *p_nam
 int xlate_matches(const struct iptables_command_state *cs, struct xt_xlate *xl);
 int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 		 struct xt_xlate *xl);
+void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
+		  bool invert);
 
 /*
  * ARP
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index 9044d27..3c577ed 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -34,6 +34,23 @@
 #include "xshared.h"
 #include "nft-shared.h"
 
+void xlate_ifname(struct xt_xlate *xl, const char *nftmeta, const char *ifname,
+		  bool invert)
+{
+	char iface[IFNAMSIZ];
+	int ifaclen;
+
+	if (ifname[0] == '\0')
+		return;
+
+	strcpy(iface, ifname);
+	ifaclen = strlen(iface);
+	if (iface[ifaclen - 1] == '+')
+		iface[ifaclen - 1] = '*';
+
+	xt_xlate_add(xl, "%s %s%s ", nftmeta, invert ? "!= " : "", iface);
+}
+
 int xlate_action(const struct iptables_command_state *cs, bool goto_set,
 		 struct xt_xlate *xl)
 {
-- 
2.5.5


