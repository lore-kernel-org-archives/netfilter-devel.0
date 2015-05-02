From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 08/34] netfilter: ipset: Use MSEC_PER_SEC consistently
Date: Sat,  2 May 2015 19:27:57 +0200
Message-ID: <1430587703-3387-9-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36672 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390AbbEBR2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:05 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_timeout.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index cfe8a3f..1d6a935 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -55,7 +55,7 @@ ip_set_timeout_set(unsigned long *timeout, u32 value)
 		return;
 	}
 
-	t = msecs_to_jiffies(value * 1000) + jiffies;
+	t = msecs_to_jiffies(value * MSEC_PER_SEC) + jiffies;
 	if (t == IPSET_ELEM_PERMANENT)
 		/* Bingo! :-) */
 		t--;
@@ -66,7 +66,7 @@ static inline u32
 ip_set_timeout_get(unsigned long *timeout)
 {
 	return *timeout == IPSET_ELEM_PERMANENT ? 0 :
-		jiffies_to_msecs(*timeout - jiffies)/1000;
+		jiffies_to_msecs(*timeout - jiffies)/MSEC_PER_SEC;
 }
 
 #endif	/* __KERNEL__ */
-- 
1.8.5.1

