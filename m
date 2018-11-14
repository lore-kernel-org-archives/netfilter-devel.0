From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 2/8] netfilter: ipset: actually allow allowable CIDR 0 in hash:net,port,net
Date: Wed, 14 Nov 2018 17:26:08 -0500
Message-ID: <20181114222618.100378-2-sashal@kernel.org>
References: <20181114222618.100378-1-sashal@kernel.org>
Cc: Eric Westbrook <eric@westbrook.io>,
        Eric Westbrook <linux@westbrook.io>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181114222618.100378-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Westbrook <eric@westbrook.io>

[ Upstream commit 886503f34d63e681662057448819edb5b1057a97 ]

Allow /0 as advertised for hash:net,port,net sets.

For "hash:net,port,net", ipset(8) says that "either subnet
is permitted to be a /0 should you wish to match port
between all destinations."

Make that statement true.

Before:

    # ipset create cidrzero hash:net,port,net
    # ipset add cidrzero 0.0.0.0/0,12345,0.0.0.0/0
    ipset v6.34: The value of the CIDR parameter of the IP address is invalid

    # ipset create cidrzero6 hash:net,port,net family inet6
    # ipset add cidrzero6 ::/0,12345,::/0
    ipset v6.34: The value of the CIDR parameter of the IP address is invalid

After:

    # ipset create cidrzero hash:net,port,net
    # ipset add cidrzero 0.0.0.0/0,12345,0.0.0.0/0
    # ipset test cidrzero 192.168.205.129,12345,172.16.205.129
    192.168.205.129,tcp:12345,172.16.205.129 is in set cidrzero.

    # ipset create cidrzero6 hash:net,port,net family inet6
    # ipset add cidrzero6 ::/0,12345,::/0
    # ipset test cidrzero6 fe80::1,12345,ff00::1
    fe80::1,tcp:12345,ff00::1 is in set cidrzero6.

See also:

  https://bugzilla.kernel.org/show_bug.cgi?id=200897
  https://github.com/ewestbrook/linux/commit/df7ff6efb0934ab6acc11f003ff1a7580d6c1d9c

Signed-off-by: Eric Westbrook <linux@westbrook.io>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 9a14c237830f..b259a5814965 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -213,13 +213,13 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CIDR]) {
 		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
-		if (!e.cidr[0] || e.cidr[0] > HOST_MASK)
+		if (e.cidr[0] > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
 	if (tb[IPSET_ATTR_CIDR2]) {
 		e.cidr[1] = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
-		if (!e.cidr[1] || e.cidr[1] > HOST_MASK)
+		if (e.cidr[1] > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
@@ -492,13 +492,13 @@ hash_netportnet6_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	if (tb[IPSET_ATTR_CIDR]) {
 		e.cidr[0] = nla_get_u8(tb[IPSET_ATTR_CIDR]);
-		if (!e.cidr[0] || e.cidr[0] > HOST_MASK)
+		if (e.cidr[0] > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
 	if (tb[IPSET_ATTR_CIDR2]) {
 		e.cidr[1] = nla_get_u8(tb[IPSET_ATTR_CIDR2]);
-		if (!e.cidr[1] || e.cidr[1] > HOST_MASK)
+		if (e.cidr[1] > HOST_MASK)
 			return -IPSET_ERR_INVALID_CIDR;
 	}
 
-- 
2.17.1
