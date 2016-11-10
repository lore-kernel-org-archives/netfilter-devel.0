From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 05/22] netfilter: ipset: Use kmalloc() in comment extension helper
Date: Thu, 10 Nov 2016 13:57:39 +0100
Message-ID: <1478782676-9770-6-git-send-email-kadlec@blackhole.kfki.hu>
References: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:48974 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932961AbcKJM6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2016 07:58:03 -0500
In-Reply-To: <1478782676-9770-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allocate memory with kmalloc() rather than kzalloc(): the string
is immediately initialized so it is unnecessary to zero out
the allocated memory area.

Ported from a patch proposed by Sergey Popovich <popovich_sergei@mail.ua>.

Suggested-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 include/linux/netfilter/ipset/ip_set_comment.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netfilter/ipset/ip_set_comment.h b/include/linux/netfilter/ipset/ip_set_comment.h
index bae5c76..5444b1b 100644
--- a/include/linux/netfilter/ipset/ip_set_comment.h
+++ b/include/linux/netfilter/ipset/ip_set_comment.h
@@ -34,7 +34,7 @@
 		return;
 	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
 		len = IPSET_MAX_COMMENT_SIZE;
-	c = kzalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
+	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
 	if (unlikely(!c))
 		return;
 	strlcpy(c->str, ext->comment, len + 1);
-- 
1.8.5.1

