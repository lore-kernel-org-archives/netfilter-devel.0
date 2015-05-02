From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 16/34] netfilter: ipset: No need to make nomatch bitfield
Date: Sat,  2 May 2015 19:28:05 +0200
Message-ID: <1430587703-3387-17-git-send-email-kadlec@blackhole.kfki.hu>
References: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:51368 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbbEBR2G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 May 2015 13:28:06 -0400
In-Reply-To: <1430587703-3387-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Sergey Popovich <popovich_sergei@mail.ua>

We do not store cidr packed with no match, so there is no
need to make nomatch bitfield.

This simplifies mtype_data_reset_flags() a bit.

Signed-off-by: Sergey Popovich <popovich_sergei@mail.ua>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 9c3558a..fcf8020 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -54,7 +54,7 @@ struct hash_netportnet4_elem {
 		u16 ccmp;
 	};
 	u16 padding;
-	u8 nomatch:1;
+	u8 nomatch;
 	u8 proto;
 };
 
@@ -326,7 +326,7 @@ struct hash_netportnet6_elem {
 		u16 ccmp;
 	};
 	u16 padding;
-	u8 nomatch:1;
+	u8 nomatch;
 	u8 proto;
 };
 
-- 
1.8.5.1

