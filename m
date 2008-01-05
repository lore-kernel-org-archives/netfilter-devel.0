From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/21] Use line-based Makefile
Date: Sat, 5 Jan 2008 15:42:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051542130.14194@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37429 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbYAEOmi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:42:38 -0500
In-Reply-To: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Transform the extensions' Makefile into a linear form to reduce
conflicts for patch stacks (very helpful during development).
Ideally, I'd just push in the automake patch, though,
which uses wildcards ;-)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile |   96 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 89 insertions(+), 7 deletions(-)

Index: iptables-modules/extensions/Makefile
===================================================================
--- iptables-modules.orig/extensions/Makefile
+++ iptables-modules/extensions/Makefile
@@ -5,13 +5,95 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
-PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
-
-PF_EXT_SELINUX_SLIB:=
-PF6_EXT_SELINUX_SLIB:=
-PFX_EXT_SELINUX_SLIB:=CONNSECMARK SECMARK
+PF_EXT_SLIB :=
+PF_EXT_SLIB += CLUSTERIP
+PF_EXT_SLIB += DNAT
+PF_EXT_SLIB += ECN
+PF_EXT_SLIB += LOG
+PF_EXT_SLIB += MASQUERADE
+PF_EXT_SLIB += MIRROR
+PF_EXT_SLIB += NETMAP
+PF_EXT_SLIB += REDIRECT
+PF_EXT_SLIB += REJECT
+PF_EXT_SLIB += SAME
+PF_EXT_SLIB += SNAT
+PF_EXT_SLIB += TOS
+PF_EXT_SLIB += TTL
+PF_EXT_SLIB += ULOG
+PF_EXT_SLIB += addrtype
+PF_EXT_SLIB += ah
+PF_EXT_SLIB += conntrack
+PF_EXT_SLIB += ecn
+PF_EXT_SLIB += icmp
+PF_EXT_SLIB += iprange
+PF_EXT_SLIB += owner
+PF_EXT_SLIB += policy
+PF_EXT_SLIB += realm
+PF_EXT_SLIB += recent
+PF_EXT_SLIB += tos
+PF_EXT_SLIB += ttl
+PF_EXT_SLIB += unclean
+
+PF6_EXT_SLIB :=
+PF6_EXT_SLIB += HL
+PF6_EXT_SLIB += LOG
+PF6_EXT_SLIB += REJECT
+PF6_EXT_SLIB += ah
+PF6_EXT_SLIB += dst
+PF6_EXT_SLIB += eui64
+PF6_EXT_SLIB += frag
+PF6_EXT_SLIB += hbh
+PF6_EXT_SLIB += hl
+PF6_EXT_SLIB += icmp6
+PF6_EXT_SLIB += ipv6header
+PF6_EXT_SLIB += mh
+PF6_EXT_SLIB += owner
+PF6_EXT_SLIB += policy
+PF6_EXT_SLIB += rt
+
+PFX_EXT_SLIB :=
+PFX_EXT_SLIB += CLASSIFY
+PFX_EXT_SLIB += CONNMARK
+PFX_EXT_SLIB += DSCP
+PFX_EXT_SLIB += MARK
+PFX_EXT_SLIB += NFLOG
+PFX_EXT_SLIB += NFQUEUE
+PFX_EXT_SLIB += NOTRACK
+PFX_EXT_SLIB += TCPMSS
+PFX_EXT_SLIB += TRACE
+PFX_EXT_SLIB += comment
+PFX_EXT_SLIB += connbytes
+PFX_EXT_SLIB += connlimit
+PFX_EXT_SLIB += connmark
+PFX_EXT_SLIB += dccp
+PFX_EXT_SLIB += dscp
+PFX_EXT_SLIB += esp
+PFX_EXT_SLIB += hashlimit
+PFX_EXT_SLIB += helper
+PFX_EXT_SLIB += length
+PFX_EXT_SLIB += limit
+PFX_EXT_SLIB += mac
+PFX_EXT_SLIB += mark
+PFX_EXT_SLIB += multiport
+PFX_EXT_SLIB += physdev
+PFX_EXT_SLIB += pkttype
+PFX_EXT_SLIB += quota
+PFX_EXT_SLIB += sctp
+PFX_EXT_SLIB += standard
+PFX_EXT_SLIB += state
+PFX_EXT_SLIB += statistic
+PFX_EXT_SLIB += string
+PFX_EXT_SLIB += tcp
+PFX_EXT_SLIB += tcpmss
+PFX_EXT_SLIB += time
+PFX_EXT_SLIB += u32
+PFX_EXT_SLIB += udp
+
+PF_EXT_SELINUX_SLIB  :=
+PF6_EXT_SELINUX_SLIB :=
+PFX_EXT_SELINUX_SLIB :=
+PFX_EXT_SELINUX_SLIB += CONNSECMARK
+PFX_EXT_SELINUX_SLIB += SECMARK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)
