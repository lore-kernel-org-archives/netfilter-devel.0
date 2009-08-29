From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 03/11] TProxy: reuse a 32bit hole in struct ipv6_pinfo
Date: Sat, 29 Aug 2009 18:46:40 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908291842320.25008@fbirervta.pbzchgretzou.qr>
References: <cover.1251295408.git.bazsi@balabit.hu> <0a1c3e68b922eef13592d6b6ab9bf4b89251ea3f.1251295408.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56045 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbZH2Qqj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2009 12:46:39 -0400
In-Reply-To: <0a1c3e68b922eef13592d6b6ab9bf4b89251ea3f.1251295408.git.bazsi@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-08-23 11:02, Balazs Scheidler wrote:

>While looking for a place to add a new bitfield in ipv6_pinfo,
>I've found a 32 bit hole (in 64 bit mode) at the beginning of the struct.
>Since dst_cookie is used in the output fastpath, I've moved this field to
>fill the hole, thus decreasing the struct size on 64 bit platforms by
>4 bytes.

Hm? I do not see a size reduction. pahole(1) tells me [for a base of 
v2.6.31-rc1-103-g644fc2c] the size is the same before and after.


--- p.1	2009-08-29 18:45:37.996787299 +0200
+++ p.2	2009-08-29 18:43:08.152753849 +0200
@@ -21824,10 +21824,8 @@ struct ipv6_pinfo {
 	struct in6_addr            saddr;                /*     0    16 */
 	struct in6_addr            rcv_saddr;            /*    16    16 */
 	struct in6_addr            daddr;                /*    32    16 */
-	struct in6_pktinfo         sticky_pktinfo;       /*    48    20 */
-
-	/* XXX 4 bytes hole, try to pack */
-
+	__u32                      dst_cookie;           /*    48     4 */
+	struct in6_pktinfo         sticky_pktinfo;       /*    52    20 */
 	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
 	struct in6_addr *          daddr_cache;          /*    72     8 */
 	struct in6_addr *          saddr_cache;          /*    80     8 */
@@ -21862,7 +21860,9 @@ struct ipv6_pinfo {
 	__u8                       ipv6only:1;           /*   106: 3  1 */
 	__u8                       srcprefs:3;           /*   106: 0  1 */
 	__u8                       tclass;               /*   107     1 */
-	__u32                      dst_cookie;           /*   108     4 */
+
+	/* XXX 4 bytes hole, try to pack */
+
 	struct ipv6_mc_socklist *  ipv6_mc_list;         /*   112     8 */
 	struct ipv6_ac_socklist *  ipv6_ac_list;         /*   120     8 */
 	/* --- cacheline 2 boundary (128 bytes) --- */
