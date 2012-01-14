From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/8] netfilter: ipset: avoid use of kernel-only types
Date: Sat, 14 Jan 2012 17:38:55 +0100
Message-ID: <1326559141-26783-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@medozas.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:60281 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516Ab2ANQjV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Jan 2012 11:39:21 -0500
In-Reply-To: <1326559141-26783-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jan Engelhardt <jengelh@medozas.de>

When using the xt_set.h header in userspace, one will get these gcc
reports:

ipset/ip_set.h:184:1: error: unknown type name "u16"
In file included from libxt_SET.c:21:0:
netfilter/xt_set.h:61:2: error: unknown type name "u32"
netfilter/xt_set.h:62:2: error: unknown type name "u32"

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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
1.7.0.4

