From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [PATCH 03/11] TProxy: reuse a 32bit hole in struct ipv6_pinfo
Date: Sun, 30 Aug 2009 08:56:01 +0200
Message-ID: <1251615361.18025.32.camel@bzorp.balabit>
References: <cover.1251295408.git.bazsi@balabit.hu>
	 <0a1c3e68b922eef13592d6b6ab9bf4b89251ea3f.1251295408.git.bazsi@balabit.hu>
	 <alpine.LSU.2.00.0908291842320.25008@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:57288 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751290AbZH3G4H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Aug 2009 02:56:07 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 0F94B11E176
	for <netfilter-devel@vger.kernel.org>; Sun, 30 Aug 2009 08:56:07 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0908291842320.25008@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 2009-08-29 at 18:46 +0200, Jan Engelhardt wrote:
> On Sunday 2009-08-23 11:02, Balazs Scheidler wrote:
> 
> >While looking for a place to add a new bitfield in ipv6_pinfo,
> >I've found a 32 bit hole (in 64 bit mode) at the beginning of the struct.
> >Since dst_cookie is used in the output fastpath, I've moved this field to
> >fill the hole, thus decreasing the struct size on 64 bit platforms by
> >4 bytes.
> 
> Hm? I do not see a size reduction. pahole(1) tells me [for a base of 
> v2.6.31-rc1-103-g644fc2c] the size is the same before and after.

you are right. I was inserting another bitfield and with that the size
didn't grow. at the end the bitfield wasn't needed, but I still felt
that dst_cookie should be moved to the first cacheline. it is used in
the output fastpath.

However since that's not necessarily worth in itself I can completely
drop this patch.

An updated version follows. 

By the way, what should be the proper procedure for posting patches that
are tproxy specific but touch the core networking code? Should those go
through Patrick, or should I just post them to netdev? Or just
cross-post the patch series to both lists?

commit 5ddc846b926be02c6cab93406d6e8adb1e3c9124
Author: Balazs Scheidler <bazsi@balabit.hu>
Date:   Sun Aug 30 08:52:01 2009 +0200

    TProxy: move dst_cookie to the first cacheline in ipv6_pinfo
    
    While looking for a place to add a new bitfield in ipv6_pinfo,
    I've found a 32 bit hole (in 64 bit mode) at the beginning of the struct.
    Since dst_cookie is used in the output fastpath, I've moved this field to
    fill the hole. The original place of dst_cookie is now empty, but
    can become a place to add further fields to the struct.
    
    Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index c662efa..be4c9c6 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -285,6 +285,7 @@ struct ipv6_pinfo {
 	struct in6_addr 	saddr;
 	struct in6_addr 	rcv_saddr;
 	struct in6_addr		daddr;
+	__u32			dst_cookie;
 	struct in6_pktinfo	sticky_pktinfo;
 	struct in6_addr		*daddr_cache;
 #ifdef CONFIG_IPV6_SUBTREES
@@ -348,7 +349,7 @@ struct ipv6_pinfo {
 						 */
 	__u8			tclass;
 
-	__u32			dst_cookie;
+	/* 32 bits hole on 64 bit platforms */
 
 	struct ipv6_mc_socklist	*ipv6_mc_list;
 	struct ipv6_ac_socklist	*ipv6_ac_list;


> 
> 
> --- p.1	2009-08-29 18:45:37.996787299 +0200
> +++ p.2	2009-08-29 18:43:08.152753849 +0200
> @@ -21824,10 +21824,8 @@ struct ipv6_pinfo {
>  	struct in6_addr            saddr;                /*     0    16 */
>  	struct in6_addr            rcv_saddr;            /*    16    16 */
>  	struct in6_addr            daddr;                /*    32    16 */
> -	struct in6_pktinfo         sticky_pktinfo;       /*    48    20 */
> -
> -	/* XXX 4 bytes hole, try to pack */
> -
> +	__u32                      dst_cookie;           /*    48     4 */
> +	struct in6_pktinfo         sticky_pktinfo;       /*    52    20 */
>  	/* --- cacheline 1 boundary (64 bytes) was 8 bytes ago --- */
>  	struct in6_addr *          daddr_cache;          /*    72     8 */
>  	struct in6_addr *          saddr_cache;          /*    80     8 */
> @@ -21862,7 +21860,9 @@ struct ipv6_pinfo {
>  	__u8                       ipv6only:1;           /*   106: 3  1 */
>  	__u8                       srcprefs:3;           /*   106: 0  1 */
>  	__u8                       tclass;               /*   107     1 */
> -	__u32                      dst_cookie;           /*   108     4 */
> +
> +	/* XXX 4 bytes hole, try to pack */
> +
>  	struct ipv6_mc_socklist *  ipv6_mc_list;         /*   112     8 */
>  	struct ipv6_ac_socklist *  ipv6_ac_list;         /*   120     8 */
>  	/* --- cacheline 2 boundary (128 bytes) --- */
> 
-- 
Bazsi


