From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 10/15] netfilter: ipset: forbid family for hash:mac sets
Date: Mon, 11 Jun 2018 11:22:28 +0200
Message-ID: <20180611092233.3219-11-pablo@netfilter.org>
References: <20180611092233.3219-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180611092233.3219-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>

Userspace `ipset` command forbids family option for hash:mac type:

ipset create test hash:mac family inet4
ipset v6.30: Unknown argument: `family'

However, this check is not done in kernel itself. When someone use
external netlink applications (pyroute2 python library for example), one
can create hash:mac with invalid family and inconsistant results from
userspace (`ipset` command cannot read set content anymore).

This patch enforce the logic in kernel, and forbids insertion of
hash:mac with a family set.

Since IP_SET_PROTO_UNDEF is defined only for hash:mac, this patch has no
impact on other hash:* sets

Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>
Signed-off-by: Victorien Molle <victorien.molle@wifirst.fr>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index bbad940c0137..8a33dac4e805 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1234,7 +1234,10 @@ IPSET_TOKEN(HTYPE, _create)(struct net *net, struct ip_set *set,
 	pr_debug("Create set %s with family %s\n",
 		 set->name, set->family == NFPROTO_IPV4 ? "inet" : "inet6");
 
-#ifndef IP_SET_PROTO_UNDEF
+#ifdef IP_SET_PROTO_UNDEF
+	if (set->family != NFPROTO_UNSPEC)
+		return -IPSET_ERR_INVALID_FAMILY;
+#else
 	if (!(set->family == NFPROTO_IPV4 || set->family == NFPROTO_IPV6))
 		return -IPSET_ERR_INVALID_FAMILY;
 #endif
-- 
2.11.0
