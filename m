From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 6/6] netfilter: ipset: Use fix sized type for timeout in the extension part
Date: Thu,  2 May 2013 11:37:22 +0200
Message-ID: <1367487442-3571-7-git-send-email-kadlec@blackhole.kfki.hu>
References: <1367487442-3571-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:39791 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756848Ab3EBJhY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 May 2013 05:37:24 -0400
In-Reply-To: <1367487442-3571-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set.h b/include/linux/netfilter/ipset/ip_set.h
index 4d3e2cb..ba63d3d 100644
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

