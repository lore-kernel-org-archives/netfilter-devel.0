From: Sergey Popovich <popovich_sergei@mail.ua>
Subject: netfilter: ipset: Use first timed out entry when no matching entry exists
Date: Mon, 16 Mar 2015 15:40:12 +0200
Message-ID: <ae7bbb6830d7690190e66ed4c9ccb4eda2fdb024.1426509747.git.popovich_sergei@mail.ua>
References: <cover.1426509747.git.popovich_sergei@mail.ua>
To: netfilter-devel@vger.kernel.org, popovich_sergei@mail.ru
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fallback4.mail.ru ([94.100.181.169]:49005 "EHLO
	fallback4.mail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbbCPNkY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 09:40:24 -0400
Received: from smtp32.i.mail.ru (smtp32.i.mail.ru [94.100.177.92])
	by fallback4.mail.ru (mPOP.Fallback_MX) with ESMTP id DDFEB34BB81
	for <netfilter-devel@vger.kernel.org>; Mon, 16 Mar 2015 16:40:20 +0300 (MSK)
In-Reply-To: <cover.1426509747.git.popovich_sergei@mail.ua>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In timeout enabled sets, when no matching entry is found, use
first timed out entry slot.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index 974ff38..c55bbbf 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -654,7 +654,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		/* Reuse first timed out entry */
 		if (SET_WITH_TIMEOUT(set) &&
 		    ip_set_timeout_expired(ext_timeout(data, set)) &&
-		    j != AHASH_MAX(h) + 1)
+		    j == AHASH_MAX(h) + 1)
 			j = i;
 	}
 	if (h->elements >= h->maxelem && SET_WITH_FORCEADD(set) && n->pos) {
-- 
1.7.10.4

