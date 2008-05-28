From: Max Kellermann <max@duempel.org>
Subject: [PATCH] fixed the position of the exclamation mark
Date: Wed, 28 May 2008 17:04:25 +0200
Message-ID: <20080528150425.20290.58521.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:40614 "EHLO swift.blarg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbYE1Pfl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 May 2008 11:35:41 -0400
Received: from localhost (localhost [127.0.0.1])
	by swift.blarg.de (Postfix) with ESMTP id 236FF1EFA1
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2008 17:04:23 +0200 (CEST)
Received: from swift.blarg.de ([127.0.0.1])
	by localhost (swift.blarg.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 9d6Je1CX1dwI for <netfilter-devel@vger.kernel.org>;
	Wed, 28 May 2008 17:04:22 +0200 (CEST)
Received: from squirrel.roonstrasse.net (squirrel.roonstrasse.net [87.79.236.163])
	by swift.blarg.de (Postfix) with ESMTP id D838B1EF99
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2008 17:04:22 +0200 (CEST)
Received: from woodpecker.roonstrasse.net (woodpecker.roonstrasse.net [172.28.0.7])
	by squirrel.roonstrasse.net (Postfix) with ESMTP id B8955C00085
	for <netfilter-devel@vger.kernel.org>; Wed, 28 May 2008 17:04:22 +0200 (CEST)
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
index caecc4f..9ca2778 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -234,10 +234,11 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
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
index 4361f13..4a48125 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -259,14 +259,15 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
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
index 7fdc293..0f726fa 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -227,10 +227,10 @@ static void realm_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
 
+	printf("--realm ");
 	if (ri->invert)
 		printf("! ");
 
-	printf("--realm ");
 	print_realm(ri->id, ri->mask, 0);
 }
 
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 1d339a0..309211f 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -897,33 +897,33 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *info, const char *prefix,
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
index c368ba4..3192d0c 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -306,23 +306,25 @@ static void dccp_save(const void *ip, const struct xt_entry_match *match)
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
index f13d905..02b249c 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -107,10 +107,10 @@ mac_print(const void *ip, const struct xt_entry_match *match, int numeric)
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void mac_save(const void *ip, const struct xt_entry_match *match)
 {
+	printf("--mac-source ");
 	if (((struct xt_mac_info *)match->data)->invert)
 		printf("! ");
 
-	printf("--mac-source ");
 	print_mac(((struct xt_mac_info *)match->data)->srcaddr);
 }
 
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 34547c8..edd6c76 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -146,14 +146,14 @@ static void physdev_save(const void *ip, const struct xt_entry_match *match)
 		printf("%s --physdev-is-in",
 		       info->invert & XT_PHYSDEV_OP_ISIN ? " !":"");
 	if (info->bitmask & XT_PHYSDEV_OP_IN)
-		printf("%s --physdev-in %s",
+		printf("--physdev-in%s %s",
 		(info->invert & XT_PHYSDEV_OP_IN) ? " !":"", info->physindev);
 
 	if (info->bitmask & XT_PHYSDEV_OP_ISOUT)
 		printf("%s --physdev-is-out",
 		       info->invert & XT_PHYSDEV_OP_ISOUT ? " !":"");
 	if (info->bitmask & XT_PHYSDEV_OP_OUT)
-		printf("%s --physdev-out %s",
+		printf("--physdev-out%s %s",
 		(info->invert & XT_PHYSDEV_OP_OUT) ? " !":"", info->physoutdev);
 	if (info->bitmask & XT_PHYSDEV_OP_BRIDGED)
 		printf("%s --physdev-is-bridged",
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 653b601..e8c6028 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -482,29 +482,31 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
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
index 743c5a2..c611f06 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -335,44 +335,47 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 
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
index 9c3665a..0158d1f 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -168,29 +168,31 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 
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

