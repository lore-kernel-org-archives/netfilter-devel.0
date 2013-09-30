From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 06/26] netfilter: ipset: Use fix sized type for timeout in the extension part
Date: Mon, 30 Sep 2013 21:50:17 +0200
Message-ID: <1380570637-31235-7-git-send-email-kadlec@blackhole.kfki.hu>
References: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:49326 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab3I3Tum (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:50:42 -0400
In-Reply-To: <1380570637-31235-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index f900f33..69aa604 100644
--- a/include/linux/netfilter/ipset/ip_set.h
+++ b/include/linux/netfilter/ipset/ip_set.h
@@ -67,7 +67,7 @@ enum ip_set_offset {
 #define SET_WITH_COUNTER(s)	((s)->extensions & IPSET_EXT_COUNTER)
 
 struct ip_set_ext {
-	unsigned long timeout;
+	u32 timeout;
 	u64 packets;
 	u64 bytes;
 };
-- 
1.7.0.4

