From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 5/9] Remove to support resizing from kernel context.
Date: Tue,  2 Nov 2010 15:35:30 +0100
Message-ID: <1288708534-14510-6-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-5-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33594 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 3C3C21F4140
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Yz5wqXm5TK2L for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 165AD1F4131
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
In-Reply-To: <1288708534-14510-5-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Resizing in kernel context is simply too expensive. Drop the feature:
if a set is used as a dynamic container by a SET target, then the set
must be created with a proper size from now on.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 kernel/ip_set.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0005-Remove-to-support-resizing-from-kernel-context.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0005-Remove-to-support-resizing-from-kernel-context.patch"

diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index 5e91d50..ad1505d 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -243,7 +243,7 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	   u8 family, u8 dim, u8 flags)
 {
 	struct ip_set *set = ip_set_list[index];
-	int ret = 0, retried = 0;
+	int ret;
 
 	BUG_ON(set == NULL || atomic_read(&set->ref) == 0);
 	pr_debug("set %s, index %u", set->name, index);
@@ -252,17 +252,10 @@ ip_set_add(ip_set_id_t index, const struct sk_buff *skb,
 	    || !(family == set->family || set->family == AF_UNSPEC))
 	    	return 0;
 
-retry:
 	write_lock_bh(&set->lock);
 	ret = set->variant->kadt(set, skb, IPSET_ADD, family, dim, flags);
 	write_unlock_bh(&set->lock);
 
-	/* Resize function must be called without holding any lock */
-	if (ret == -EAGAIN
-	    && set->variant->resize
-	    && (ret = set->variant->resize(set, GFP_ATOMIC, retried++)) == 0)
-	    	goto retry;
-	
 	return ret;
 }
 EXPORT_SYMBOL(ip_set_add);

--------------1.7.0.4--


