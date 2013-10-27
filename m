From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/2] netfilter:ipset: Fix memory allocation for bitmap:port
Date: Sun, 27 Oct 2013 19:31:58 +0100
Message-ID: <1382898719-7003-2-git-send-email-kadlec@blackhole.kfki.hu>
References: <1382898719-7003-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:52878 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab3J0ScA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Oct 2013 14:32:00 -0400
In-Reply-To: <1382898719-7003-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

At the restructuring of the bitmap types creation in ipset, for the
bitmap:port type wrong (too large) memory allocation was copied
(netfilter bugzilla id #859).

Reported-by: Quentin Armitage <quentin@armitage.org.uk>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_bitmap_port.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_bitmap_port.c b/net/netfilter/ipset/ip_set_bitmap_port.c
index e7603c5..cf99676 100644
--- a/net/netfilter/ipset/ip_set_bitmap_port.c
+++ b/net/netfilter/ipset/ip_set_bitmap_port.c
@@ -254,7 +254,7 @@ bitmap_port_create(struct net *net, struct ip_set *set, struct nlattr *tb[],
 		return -ENOMEM;
 
 	map->elements = last_port - first_port + 1;
-	map->memsize = map->elements * sizeof(unsigned long);
+	map->memsize = bitmap_bytes(0, map->elements);
 	set->variant = &bitmap_port;
 	set->dsize = ip_set_elem_len(set, tb, 0);
 	if (!init_map_port(set, map, first_port, last_port)) {
-- 
1.7.10.4

