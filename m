From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH] Suppress compile-time warnings:
Date: Wed,  9 Nov 2011 19:37:35 +0100
Message-ID: <1320863855-2540-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:44625 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917Ab1KISiE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:38:04 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

warning: 'ip_to' may be used uninitialized in this function

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_ipport.c    |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportip.c  |    2 +-
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index 6ee10f5..37d667e 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -158,7 +158,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipport4_elem data = { };
-	u32 ip, ip_to, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to;
 	u32 timeout = h->timeout;
 	bool with_ports = false;
 	int ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index fb90e34..e69e271 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -162,7 +162,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportip4_elem data = { };
-	u32 ip, ip_to, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to;
 	u32 timeout = h->timeout;
 	bool with_ports = false;
 	int ret;
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index deb3e3d..64199b4 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -184,7 +184,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	const struct ip_set_hash *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_ipportnet4_elem data = { .cidr = HOST_MASK };
-	u32 ip, ip_to, p = 0, port, port_to;
+	u32 ip, ip_to = 0, p = 0, port, port_to;
 	u32 ip2_from = 0, ip2_to, ip2_last, ip2;
 	u32 timeout = h->timeout;
 	bool with_ports = false;
-- 
1.7.0.4

