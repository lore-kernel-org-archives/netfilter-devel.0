From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 20/39] netfilter: ipset: Use kmalloc() in comment extension helper
Date: Sun, 13 Nov 2016 23:25:14 +0100
Message-ID: <1479075933-4491-21-git-send-email-pablo@netfilter.org>
References: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1479075933-4491-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

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
index bae5c7609be2..5444b1bbe656 100644
--- a/include/linux/netfilter/ipset/ip_set_comment.h
+++ b/include/linux/netfilter/ipset/ip_set_comment.h
@@ -34,7 +34,7 @@ ip_set_init_comment(struct ip_set_comment *comment,
 		return;
 	if (unlikely(len > IPSET_MAX_COMMENT_SIZE))
 		len = IPSET_MAX_COMMENT_SIZE;
-	c = kzalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
+	c = kmalloc(sizeof(*c) + len + 1, GFP_ATOMIC);
 	if (unlikely(!c))
 		return;
 	strlcpy(c->str, ext->comment, len + 1);
-- 
2.1.4
