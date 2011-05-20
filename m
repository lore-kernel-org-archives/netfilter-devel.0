From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] netfilter: ipset: Use proper timeout value to jiffies conversion
Date: Fri, 20 May 2011 20:51:42 +0200
Message-ID: <1305917503-14427-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1305917503-14427-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Patrick McHardy <kaber@trash.net>,
	David Miller <davem@davemloft.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:35951 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934817Ab1ETSvp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2011 14:51:45 -0400
In-Reply-To: <1305917503-14427-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_timeout.h |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/linux/netfilter/ipset/ip_set_timeout.h b/include/linux/netfilter/ipset/ip_set_timeout.h
index 9f30c5f..bcdd40a 100644
--- a/include/linux/netfilter/ipset/ip_set_timeout.h
+++ b/include/linux/netfilter/ipset/ip_set_timeout.h
@@ -45,7 +45,7 @@ ip_set_timeout_test(unsigned long timeout)
 {
 	return timeout != IPSET_ELEM_UNSET &&
 	       (timeout == IPSET_ELEM_PERMANENT ||
-		time_after(timeout, jiffies));
+		time_is_after_jiffies(timeout));
 }
 
 static inline bool
@@ -53,7 +53,7 @@ ip_set_timeout_expired(unsigned long timeout)
 {
 	return timeout != IPSET_ELEM_UNSET &&
 	       timeout != IPSET_ELEM_PERMANENT &&
-	       time_before(timeout, jiffies);
+	       time_is_before_jiffies(timeout);
 }
 
 static inline unsigned long
@@ -64,7 +64,7 @@ ip_set_timeout_set(u32 timeout)
 	if (!timeout)
 		return IPSET_ELEM_PERMANENT;
 
-	t = timeout * HZ + jiffies;
+	t = msecs_to_jiffies(timeout * 1000) + jiffies;
 	if (t == IPSET_ELEM_UNSET || t == IPSET_ELEM_PERMANENT)
 		/* Bingo! */
 		t++;
@@ -75,7 +75,8 @@ ip_set_timeout_set(u32 timeout)
 static inline u32
 ip_set_timeout_get(unsigned long timeout)
 {
-	return timeout == IPSET_ELEM_PERMANENT ? 0 : (timeout - jiffies)/HZ;
+	return timeout == IPSET_ELEM_PERMANENT ? 0 : 
+		jiffies_to_msecs(timeout - jiffies)/1000;
 }
 
 #else
@@ -89,14 +90,14 @@ static inline bool
 ip_set_timeout_test(unsigned long timeout)
 {
 	return timeout == IPSET_ELEM_PERMANENT ||
-	       time_after(timeout, jiffies);
+	       time_is_after_jiffies(timeout);
 }
 
 static inline bool
 ip_set_timeout_expired(unsigned long timeout)
 {
 	return timeout != IPSET_ELEM_PERMANENT &&
-	       time_before(timeout, jiffies);
+	       time_is_before_jiffies(timeout);
 }
 
 static inline unsigned long
@@ -107,7 +108,7 @@ ip_set_timeout_set(u32 timeout)
 	if (!timeout)
 		return IPSET_ELEM_PERMANENT;
 
-	t = timeout * HZ + jiffies;
+	t = msecs_to_jiffies(timeout * 1000) + jiffies;
 	if (t == IPSET_ELEM_PERMANENT)
 		/* Bingo! :-) */
 		t++;
@@ -118,7 +119,8 @@ ip_set_timeout_set(u32 timeout)
 static inline u32
 ip_set_timeout_get(unsigned long timeout)
 {
-	return timeout == IPSET_ELEM_PERMANENT ? 0 : (timeout - jiffies)/HZ;
+	return timeout == IPSET_ELEM_PERMANENT ? 0 :
+		jiffies_to_msecs(timeout - jiffies)/1000;
 }
 #endif /* ! IP_SET_BITMAP_TIMEOUT */
 
-- 
1.7.0.4

