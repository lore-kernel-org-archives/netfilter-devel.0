From: Simon Horman <horms@verge.net.au>
Subject: [patch] netfilter: Use header-y instead of unifdef-y
Date: Mon, 23 Aug 2010 12:42:26 +0900
Message-ID: <20100823034226.GA29532@verge.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kirsty.vergenet.net ([202.4.237.240]:42269 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab0HWDma (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Aug 2010 23:42:30 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

According to Documentation/kbuild/makefiles.txt
the usage of unifdef is deprecated.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: nf-next-2.6/include/linux/netfilter/Kbuild
===================================================================
--- nf-next-2.6.orig/include/linux/netfilter/Kbuild	2010-08-21 12:25:11.000000000 +0900
+++ nf-next-2.6/include/linux/netfilter/Kbuild	2010-08-23 12:37:45.000000000 +0900
@@ -1,8 +1,14 @@
+header-y += nf_conntrack_common.h
+header-y += nf_conntrack_ftp.h
 header-y += nf_conntrack_sctp.h
+header-y += nf_conntrack_tcp.h
 header-y += nf_conntrack_tuple_common.h
+header-y += nfnetlink.h
+header-y += nfnetlink_compat.h
 header-y += nfnetlink_conntrack.h
 header-y += nfnetlink_log.h
 header-y += nfnetlink_queue.h
+header-y += x_tables.h
 header-y += xt_CHECKSUM.h
 header-y += xt_CLASSIFY.h
 header-y += xt_CONNMARK.h
@@ -41,7 +47,9 @@ header-y += xt_mark.h
 header-y += xt_multiport.h
 header-y += xt_osf.h
 header-y += xt_owner.h
+header-y += xt_physdev.h
 header-y += xt_pkttype.h
+header-y += xt_policy.h
 header-y += xt_quota.h
 header-y += xt_rateest.h
 header-y += xt_realm.h
@@ -54,12 +62,3 @@ header-y += xt_tcpmss.h
 header-y += xt_tcpudp.h
 header-y += xt_time.h
 header-y += xt_u32.h
-
-unifdef-y += nf_conntrack_common.h
-unifdef-y += nf_conntrack_ftp.h
-unifdef-y += nf_conntrack_tcp.h
-unifdef-y += nfnetlink.h
-unifdef-y += nfnetlink_compat.h
-unifdef-y += x_tables.h
-unifdef-y += xt_physdev.h
-unifdef-y += xt_policy.h
