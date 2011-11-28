From: pablo@netfilter.org
Subject: [PATCH 1/3] netfilter: ipset: suppress compile-time warnings in ip_set_hash_ipport*.c
Date: Mon, 28 Nov 2011 04:30:58 +0100
Message-ID: <1322451060-4883-2-git-send-email-pablo@netfilter.org>
References: <1322451060-4883-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753732Ab1K1Db0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Nov 2011 22:31:26 -0500
In-Reply-To: <1322451060-4883-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

warning: 'ip_to' may be used uninitialized in this function

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
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
1.7.2.5

