From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/2] netfilter: ipset: avoid use of kernel-only types
Date: Wed, 31 Aug 2011 14:10:04 +0200
Message-ID: <1314792606-9930-2-git-send-email-jengelh@medozas.de>
References: <1314792606-9930-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60286 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755294Ab1HaMKJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Aug 2011 08:10:09 -0400
In-Reply-To: <1314792606-9930-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using the xt_set.h header in userspace, one will get these gcc
reports:

ipset/ip_set.h:184:1: error: unknown type name "u16"
In file included from libxt_SET.c:21:0:
netfilter/xt_set.h:61:2: error: unknown type name "u32"
netfilter/xt_set.h:62:2: error: unknown type name "u32"

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/xt_set.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/xt_set.h b/include/linux/netfilter/xt_set.h
index c0405ac..e3a9978 100644
--- a/include/linux/netfilter/xt_set.h
+++ b/include/linux/netfilter/xt_set.h
@@ -58,8 +58,8 @@ struct xt_set_info_target_v1 {
 struct xt_set_info_target_v2 {
 	struct xt_set_info add_set;
 	struct xt_set_info del_set;
-	u32 flags;
-	u32 timeout;
+	__u32 flags;
+	__u32 timeout;
 };
 
 #endif /*_XT_SET_H*/
-- 
1.7.3.4

