From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 01/15] netfilter: ipset: Use MSEC_PER_SEC consistently
Date: Sun, 14 Jun 2015 10:56:18 +0200
Message-ID: <1434272192-8620-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:55954 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbbFNI4c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jun 2015 04:56:32 -0400
In-Reply-To: <1434272192-8620-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_timeout.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index 83c2f9e..3c8842b 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -61,7 +61,7 @@ ip_set_timeout_set(unsigned long *timeout, u32 t)
 		return;
 	}
 
-	*timeout = msecs_to_jiffies(t * 1000) + jiffies;
+	*timeout = msecs_to_jiffies(t * MSEC_PER_SEC) + jiffies;
 	if (*timeout == IPSET_ELEM_PERMANENT)
 		/* Bingo! :-) */
 		(*timeout)--;
@@ -71,7 +71,7 @@ static inline u32
 ip_set_timeout_get(unsigned long *timeout)
 {
 	return *timeout == IPSET_ELEM_PERMANENT ? 0 :
-		jiffies_to_msecs(*timeout - jiffies)/1000;
+		jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
 }
 
 #endif	/* __KERNEL__ */
-- 
1.8.5.1

