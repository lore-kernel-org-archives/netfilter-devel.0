From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 04/22] netfilter: ipset: Improve comment extension helpers
Date: Sun, 23 Oct 2016 22:37:37 +0200
Message-ID: <1477255075-15255-5-git-send-email-kadlec@blackhole.kfki.hu>
References: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:50852 "EHLO smtp2.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756744AbcJWUiD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Oct 2016 16:38:03 -0400
In-Reply-To: <1477255075-15255-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Allocate memory with kmalloc() rather than kzalloc().

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

