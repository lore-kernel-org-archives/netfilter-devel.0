From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/11] Line-based makefile
Date: Sat, 22 Dec 2007 03:44:15 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712220342260.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56599 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLVCoQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Dec 2007 21:44:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Transform the extensions' Makefile into a linear form to reduce
conflicts for patch stacks (very helpful during development).
Ideally, I'd just push in the automake patch, though,
which uses wildcards ;-)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/Makefile |   92 +++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 88 insertions(+), 4 deletions(-)

Index: iptables-modules/extensions/Makefile
===================================================================
--- iptables-modules.orig/extensions/Makefile
+++ iptables-modules/extensions/Makefile
@@ -5,13 +5,97 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
-PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+a :=
+a += CLUSTERIP
+a += DNAT
+a += ECN
+a += LOG
+a += MASQUERADE
+a += MIRROR
+a += NETMAP
+a += REDIRECT
+a += REJECT
+a += SAME
+a += SNAT
+a += TOS
+a += TTL
+a += ULOG
+a += addrtype
+a += ah
+a += conntrack
+a += ecn
+a += icmp
+a += iprange
+a += owner
+a += policy
+a += realm
+a += recent
+a += tos
+a += ttl
+a += unclean
+PF_EXT_SLIB := ${a}
+a :=
+a += HL
+a += LOG
+a += REJECT
+a += ah
+a += dst
+a += eui64
+a += frag
+a += hbh
+a += hl
+a += icmp6
+a += ipv6header
+a += mh
+a += owner
+a += policy
+a += rt
+PF6_EXT_SLIB := ${a}
+a :=
+a += CLASSIFY
+a += CONNMARK
+a += DSCP
+a += MARK
+a += NFLOG
+a += NFQUEUE
+a += NOTRACK
+a += TCPMSS
+a += TRACE
+a += comment
+a += connbytes
+a += connlimit
+a += connmark
+a += dccp
+a += dscp
+a += esp
+a += hashlimit
+a += helper
+a += length
+a += limit
+a += mac
+a += mark
+a += multiport
+a += physdev
+a += pkttype
+a += quota
+a += sctp
+a += standard
+a += state
+a += statistic
+a += string
+a += tcp
+a += tcpmss
+a += time
+a += u32
+a += udp
+PFX_EXT_SLIB := ${a}
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
-PFX_EXT_SELINUX_SLIB:=CONNSECMARK SECMARK
+a :=
+a += CONNSECMARK
+a += SECMARK
+PFX_EXT_SELINUX_SLIB := ${a}
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=$(PF_EXT_SELINUX_SLIB)

