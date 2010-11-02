From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 4/9] Fix gfp_flags at resizing
Date: Tue,  2 Nov 2010 15:35:29 +0100
Message-ID: <1288708534-14510-5-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:48096 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab0KBOfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 51F724D402B
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp0.kfki.hu ([127.0.0.1])
	by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EeslKL5sVQrt for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp0.kfki.hu (Postfix) with ESMTP id 3A3464D4020
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
In-Reply-To: <1288708534-14510-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


Resizing functions are called without holding any lock. So we can
allocate using the flag GFP_KERNEL.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 kernel/include/linux/netfilter/ip_set_chash.h |    4 ++--
 kernel/ip_set.c                               |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0004-Fix-gfp_flags-at-resizing.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0004-Fix-gfp_flags-at-resizing.patch"

diff --git a/kernel/include/linux/netfilter/ip_set_chash.h b/kernel/include/linux/netfilter/ip_set_chash.h
index 9a1e26c..f0ef580 100644
--- a/kernel/include/linux/netfilter/ip_set_chash.h
+++ b/kernel/include/linux/netfilter/ip_set_chash.h
@@ -338,7 +338,7 @@ retry:
 		/* In case we have plenty of memory :-) */
 		return -IPSET_ERR_HASH_FULL;
 	t = ip_set_alloc(jhash_size(htable_bits) * sizeof(struct slist),
-			 gfp_flags);
+			 GFP_KERNEL);
 	if (!t)
 		return -ENOMEM;
 
@@ -809,7 +809,7 @@ retry:
 		/* In case we have plenty of memory :-) */
 		return -IPSET_ERR_HASH_FULL;
 	t = ip_set_alloc(jhash_size(htable_bits) * sizeof(struct slist),
-			 gfp_flags);
+			 GFP_KERNEL);
 	if (!t)
 		return -ENOMEM;
 
diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index a1813e2..5e91d50 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -257,7 +257,7 @@ retry:
 	ret = set->variant->kadt(set, skb, IPSET_ADD, family, dim, flags);
 	write_unlock_bh(&set->lock);
 
-	/* Retry function must be called without holding any lock */
+	/* Resize function must be called without holding any lock */
 	if (ret == -EAGAIN
 	    && set->variant->resize
 	    && (ret = set->variant->resize(set, GFP_ATOMIC, retried++)) == 0)

--------------1.7.0.4--


