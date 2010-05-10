From: kaber@trash.net
Subject: [PATCH 01/84] netfilter: include/linux/netfilter/nf_conntrack_tuple_common.h: Checkpatch cleanup
Date: Mon, 10 May 2010 22:17:32 +0200
Message-ID: <1273522735-24672-2-git-send-email-kaber@trash.net>
References: <1273522735-24672-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54505 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756594Ab0EJUS6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 May 2010 16:18:58 -0400
In-Reply-To: <1273522735-24672-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Andrea Gelmini <andrea.gelmini@gelma.net>

include/linux/netfilter/nf_conntrack_tuple_common.h:5: ERROR: open brace '{' following enum go on the same line

Signed-off-by: Andrea Gelmini <andrea.gelmini@gelma.net>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 .../linux/netfilter/nf_conntrack_tuple_common.h    |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_tuple_common.h b/include/linux/netfilter/nf_conntrack_tuple_common.h
index 8e145f0..2ea22b0 100644
--- a/include/linux/netfilter/nf_conntrack_tuple_common.h
+++ b/include/linux/netfilter/nf_conntrack_tuple_common.h
@@ -1,8 +1,7 @@
 #ifndef _NF_CONNTRACK_TUPLE_COMMON_H
 #define _NF_CONNTRACK_TUPLE_COMMON_H
 
-enum ip_conntrack_dir
-{
+enum ip_conntrack_dir {
 	IP_CT_DIR_ORIGINAL,
 	IP_CT_DIR_REPLY,
 	IP_CT_DIR_MAX
-- 
1.7.0.4

