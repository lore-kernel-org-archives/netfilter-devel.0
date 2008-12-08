From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH] fixed the position of the exclamation mark
Date: Mon, 08 Dec 2008 15:57:17 +0100
Message-ID: <20081208145717.30142.93140.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.netcologne.de ([194.8.194.137]:38864 "EHLO
	smtp4.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbYLHPTC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:19:02 -0500
Received: from squirrel.roonstrasse.net (static-87-79-236-163.netcologne.de [87.79.236.163])
	by smtp4.netcologne.de (Postfix) with ESMTP id 4170EDA4E5
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2008 15:57:00 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by squirrel.roonstrasse.net (Postfix) with ESMTP id 03C5EC04DA9
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2008 15:57:00 +0100 (CET)
Received: from squirrel.roonstrasse.net ([127.0.0.1])
	by localhost (squirrel.roonstrasse.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id IvS2eU6rFKeQ for <netfilter-devel@vger.kernel.org>;
	Mon,  8 Dec 2008 15:56:59 +0100 (CET)
Received: from woodpecker.roonstrasse.net (woodpecker.roonstrasse.net [172.28.0.7])
	by squirrel.roonstrasse.net (Postfix) with ESMTP id C4326C0008B
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2008 15:56:59 +0100 (CET)
Received: from woodpecker.roonstrasse.net (localhost [127.0.0.1])
	by woodpecker.roonstrasse.net (Postfix) with ESMTP id CD308C4F236
	for <netfilter-devel@vger.kernel.org>; Mon,  8 Dec 2008 15:57:17 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iptables-save misplaces the exclamation mark (negation): it puts the
the exclamation mark before the option name, although the option is
documented as requiring the negation specifier before the arguments.

Example:

  --tcp-flags [!] mask comp

iptables-save generates the following:

  -A INPUT -p tcp -m tcp ! --tcp-flags SYN,ACK SYN -j ACCEPT

In most cases, correcting this mistake requires an additional printf()
invocation.  This patch fixes several modules, probably not all.
---

 extensions/libip6t_icmp6.c   |    3 ++-
 extensions/libipt_icmp.c     |    5 +++--
 extensions/libipt_realm.c    |    2 +-
 extensions/libxt_conntrack.c |    8 ++++----
 extensions/libxt_dccp.c      |   10 ++++++----
 extensions/libxt_mac.c       |    2 +-
 extensions/libxt_physdev.c   |    4 ++--
 extensions/libxt_sctp.c      |   12 +++++++-----
 extensions/libxt_tcp.c       |   15 +++++++++------
 extensions/libxt_udp.c       |   10 ++++++----
 10 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index b87538f..fb0581c 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -228,10 +228,11 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_icmp *icmpv6 = (struct ip6t_icmp *)match->data;
 
+	printf("--icmpv6-type ");
 	if (icmpv6->invflags & IP6T_ICMP_INV)
 		printf("! ");
 
-	printf("--icmpv6-type %u", icmpv6->type);
+	printf("%u", icmpv6->type);
 	if (icmpv6->code[0] != 0 || icmpv6->code[1] != 0xFF)
 		printf("/%u", icmpv6->code[0]);
 	printf(" ");
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index d0b7bb3..e97719a 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -253,14 +253,15 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_icmp *icmp = (struct ipt_icmp *)match->data;
 
+	printf("--icmp-type ");
 	if (icmp->invflags & IPT_ICMP_INV)
 		printf("! ");
 
 	/* special hack for 'any' case */
 	if (icmp->type == 0xFF) {
-		printf("--icmp-type any ");
+		printf("any ");
 	} else {
-		printf("--icmp-type %u", icmp->type);
+		printf("%u", icmp->type);
 		if (icmp->code[0] != 0 || icmp->code[1] != 0xFF)
 			printf("/%u", icmp->code[0]);
 		printf(" ");
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 5af2fd4..368b655 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -220,10 +220,10 @@ static void realm_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
 
+	printf("--realm ");
 	if (ri->invert)
 		printf("! ");
 
-	printf("--realm ");
 	print_realm(ri->id, ri->mask, 0);
 }
 
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index d5dee7e..476cec6 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -909,33 +909,33 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
 	}
 
 	if (info->match_flags & XT_CONNTRACK_ORIGSRC) {
+		printf("%sctorigsrc ", prefix);
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
-		printf("%sctorigsrc ", prefix);
 		conntrack_dump_addr(&info->origsrc_addr, &info->origsrc_mask,
 		                    family, numeric);
 	}
 
 	if (info->match_flags & XT_CONNTRACK_ORIGDST) {
+		printf("%sctorigdst ", prefix);
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
-		printf("%sctorigdst ", prefix);
 		conntrack_dump_addr(&info->origdst_addr, &info->origdst_mask,
 		                    family, numeric);
 	}
 
 	if (info->match_flags & XT_CONNTRACK_REPLSRC) {
+		printf("%sctreplsrc ", prefix);
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
-		printf("%sctreplsrc ", prefix);
 		conntrack_dump_addr(&info->replsrc_addr, &info->replsrc_mask,
 		                    family, numeric);
 	}
 
 	if (info->match_flags & XT_CONNTRACK_REPLDST) {
+		printf("%sctrepldst ", prefix);
 		if (info->invert_flags & XT_CONNTRACK_PROTO)
 			printf("! ");
-		printf("%sctrepldst ", prefix);
 		conntrack_dump_addr(&info->repldst_addr, &info->repldst_mask,
 		                    family, numeric);
 	}
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 24bf6f7..5100641 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -304,23 +304,25 @@ static void dccp_save(const void *ip, const struct xt_entry_match *match)
 		(const struct xt_dccp_info *)match->data;
 
 	if (einfo->flags & XT_DCCP_SRC_PORTS) {
+		printf("--sport ");
 		if (einfo->invflags & XT_DCCP_SRC_PORTS)
 			printf("! ");
 		if (einfo->spts[0] != einfo->spts[1])
-			printf("--sport %u:%u ", 
+			printf("%u:%u ",
 			       einfo->spts[0], einfo->spts[1]);
 		else
-			printf("--sport %u ", einfo->spts[0]);
+			printf("%u ", einfo->spts[0]);
 	}
 
 	if (einfo->flags & XT_DCCP_DEST_PORTS) {
+		printf("--dport ");
 		if (einfo->invflags & XT_DCCP_DEST_PORTS)
 			printf("! ");
 		if (einfo->dpts[0] != einfo->dpts[1])
-			printf("--dport %u:%u ",
+			printf("%u:%u ",
 			       einfo->dpts[0], einfo->dpts[1]);
 		else
-			printf("--dport %u ", einfo->dpts[0]);
+			printf("%u ", einfo->dpts[0]);
 	}
 
 	if (einfo->flags & XT_DCCP_TYPE) {
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index f4128c0..627acce 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -104,10 +104,10 @@ static void mac_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_mac_info *info = (void *)match->data;
 
+	printf("--mac-source ");
 	if (info->invert)
 		printf("! ");
 
-	printf("--mac-source ");
 	print_mac(info->srcaddr);
 }
 
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 0572aba..ec8d806 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -146,7 +146,7 @@ static void physdev_save(const void *ip, const struct xt_entry_match *match)
 		printf("%s--physdev-is-in ",
 		       (info->invert & XT_PHYSDEV_OP_ISIN) ? "! " : "");
 	if (info->bitmask & XT_PHYSDEV_OP_IN)
-		printf("%s--physdev-in %s ",
+		printf("--physdev-in %s%s",
 		       (info->invert & XT_PHYSDEV_OP_IN) ? "! " : "",
 		       info->physindev);
 
@@ -154,7 +154,7 @@ static void physdev_save(const void *ip, const struct xt_entry_match *match)
 		printf("%s--physdev-is-out ",
 		       (info->invert & XT_PHYSDEV_OP_ISOUT) ? "! " : "");
 	if (info->bitmask & XT_PHYSDEV_OP_OUT)
-		printf("%s--physdev-out %s ",
+		printf("--physdev-out %s%s",
 		       (info->invert & XT_PHYSDEV_OP_OUT) ? "! " : "",
 		       info->physoutdev);
 	if (info->bitmask & XT_PHYSDEV_OP_BRIDGED)
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 37a6423..8fae5ec 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -480,29 +480,31 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 		(const struct xt_sctp_info *)match->data;
 
 	if (einfo->flags & XT_SCTP_SRC_PORTS) {
+		printf("--sport ");
 		if (einfo->invflags & XT_SCTP_SRC_PORTS)
 			printf("! ");
 		if (einfo->spts[0] != einfo->spts[1])
-			printf("--sport %u:%u ", 
+			printf("%u:%u ",
 			       einfo->spts[0], einfo->spts[1]);
 		else
-			printf("--sport %u ", einfo->spts[0]);
+			printf("%u ", einfo->spts[0]);
 	}
 
 	if (einfo->flags & XT_SCTP_DEST_PORTS) {
+		printf("--dport ");
 		if (einfo->invflags & XT_SCTP_DEST_PORTS)
 			printf("! ");
 		if (einfo->dpts[0] != einfo->dpts[1])
-			printf("--dport %u:%u ",
+			printf("%u:%u ",
 			       einfo->dpts[0], einfo->dpts[1]);
 		else
-			printf("--dport %u ", einfo->dpts[0]);
+			printf("%u ", einfo->dpts[0]);
 	}
 
 	if (einfo->flags & XT_SCTP_CHUNK_TYPES) {
+		printf("--chunk-types ");
 		if (einfo->invflags & XT_SCTP_CHUNK_TYPES)
 			printf("! ");
-		printf("--chunk-types ");
 
 		print_chunks(einfo, 0);
 	}
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 14d8c18..cd86dbc 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -330,44 +330,47 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 
 	if (tcpinfo->spts[0] != 0
 	    || tcpinfo->spts[1] != 0xFFFF) {
+		printf("--sport ");
 		if (tcpinfo->invflags & XT_TCP_INV_SRCPT)
 			printf("! ");
 		if (tcpinfo->spts[0]
 		    != tcpinfo->spts[1])
-			printf("--sport %u:%u ",
+			printf("%u:%u ",
 			       tcpinfo->spts[0],
 			       tcpinfo->spts[1]);
 		else
-			printf("--sport %u ",
+			printf("%u ",
 			       tcpinfo->spts[0]);
 	}
 
 	if (tcpinfo->dpts[0] != 0
 	    || tcpinfo->dpts[1] != 0xFFFF) {
+		printf("--dport ");
 		if (tcpinfo->invflags & XT_TCP_INV_DSTPT)
 			printf("! ");
 		if (tcpinfo->dpts[0]
 		    != tcpinfo->dpts[1])
-			printf("--dport %u:%u ",
+			printf("%u:%u ",
 			       tcpinfo->dpts[0],
 			       tcpinfo->dpts[1]);
 		else
-			printf("--dport %u ",
+			printf("%u ",
 			       tcpinfo->dpts[0]);
 	}
 
 	if (tcpinfo->option
 	    || (tcpinfo->invflags & XT_TCP_INV_OPTION)) {
+		printf("--tcp-option ");
 		if (tcpinfo->invflags & XT_TCP_INV_OPTION)
 			printf("! ");
-		printf("--tcp-option %u ", tcpinfo->option);
+		printf("%u ", tcpinfo->option);
 	}
 
 	if (tcpinfo->flg_mask
 	    || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
+		printf("--tcp-flags ");
 		if (tcpinfo->invflags & XT_TCP_INV_FLAGS)
 			printf("! ");
-		printf("--tcp-flags ");
 		if (tcpinfo->flg_mask != 0xFF) {
 			print_tcpf(tcpinfo->flg_mask);
 		}
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index f64fd1c..20d7c6e 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -163,29 +163,31 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 
 	if (udpinfo->spts[0] != 0
 	    || udpinfo->spts[1] != 0xFFFF) {
+		printf("--sport ");
 		if (udpinfo->invflags & XT_UDP_INV_SRCPT)
 			printf("! ");
 		if (udpinfo->spts[0]
 		    != udpinfo->spts[1])
-			printf("--sport %u:%u ",
+			printf("%u:%u ",
 			       udpinfo->spts[0],
 			       udpinfo->spts[1]);
 		else
-			printf("--sport %u ",
+			printf("%u ",
 			       udpinfo->spts[0]);
 	}
 
 	if (udpinfo->dpts[0] != 0
 	    || udpinfo->dpts[1] != 0xFFFF) {
+		printf("--dport ");
 		if (udpinfo->invflags & XT_UDP_INV_DSTPT)
 			printf("! ");
 		if (udpinfo->dpts[0]
 		    != udpinfo->dpts[1])
-			printf("--dport %u:%u ",
+			printf("%u:%u ",
 			       udpinfo->dpts[0],
 			       udpinfo->dpts[1]);
 		else
-			printf("--dport %u ",
+			printf("%u ",
 			       udpinfo->dpts[0]);
 	}
 }

