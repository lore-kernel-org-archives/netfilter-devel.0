From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH 03/11] TProxy: reuse a 32bit hole in struct ipv6_pinfo
Date: Sun, 23 Aug 2009 11:02:11 +0200
Message-ID: <0a1c3e68b922eef13592d6b6ab9bf4b89251ea3f.1251295408.git.bazsi@balabit.hu>
References: <cover.1251295408.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: Harry Mason <harry.mason@smoothwall.net>
To: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:58549 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751973AbZH2Pu0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Aug 2009 11:50:26 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id B21A113A1B6
	for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2009 17:21:36 +0200 (CEST)
In-Reply-To: <cover.1251295408.git.bazsi@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While looking for a place to add a new bitfield in ipv6_pinfo,
I've found a 32 bit hole (in 64 bit mode) at the beginning of the struct.
Since dst_cookie is used in the output fastpath, I've moved this field to
fill the hole, thus decreasing the struct size on 64 bit platforms by
4 bytes.

On 32 bit platforms the struct size doesn't change.

Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>
---
 include/linux/ipv6.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index c662efa..52dcbf7 100644
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
@@ -348,8 +349,6 @@ struct ipv6_pinfo {
 						 */
 	__u8			tclass;
 
-	__u32			dst_cookie;
-
 	struct ipv6_mc_socklist	*ipv6_mc_list;
 	struct ipv6_ac_socklist	*ipv6_ac_list;
 	struct ipv6_fl_socklist *ipv6_fl_list;
-- 
1.6.0.4


