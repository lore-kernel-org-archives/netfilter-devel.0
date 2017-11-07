From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 02/23] netfilter: ipset: Fix sparse warnings
Date: Tue,  7 Nov 2017 01:51:52 +0100
Message-ID: <20171107005213.22618-3-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipset/ip_set_hash_ipportnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index 5ab1b99a53c2..24bf55860108 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -434,7 +434,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (unlikely(tb[IPSET_ATTR_IP_TO]))
 		return -IPSET_ERR_HASH_RANGE_UNSUPPORTED;
 	if (unlikely(tb[IPSET_ATTR_CIDR])) {
-		u8 cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
+		cidr = nla_get_u8(tb[IPSET_ATTR_CIDR]);
 
 		if (cidr != HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
-- 
2.11.0
