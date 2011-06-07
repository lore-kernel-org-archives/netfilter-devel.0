From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 10/15] netfilter: ipset: Use unified from/to address masking and check the usage
Date: Tue,  7 Jun 2011 18:56:15 +0200
Message-ID: <1307465780-28980-11-git-send-email-kadlec@blackhole.kfki.hu>
References: <1307465780-28980-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-9-git-send-email-kadlec@blackhole.kfki.hu>
 <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:58853 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757191Ab1FGQ4Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2011 12:56:24 -0400
In-Reply-To: <1307465780-28980-10-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/linux/netfilter/ipset/pfxlen.h      |    6 ++++++
 net/netfilter/ipset/ip_set_bitmap_ip.c      |    6 ++----
 net/netfilter/ipset/ip_set_bitmap_ipmac.c   |    2 +-
 net/netfilter/ipset/ip_set_hash_ip.c        |    3 +--
 net/netfilter/ipset/ip_set_hash_ipport.c    |    3 +--
 net/netfilter/ipset/ip_set_hash_ipportip.c  |    3 +--
 net/netfilter/ipset/ip_set_hash_ipportnet.c |    6 ++----
 net/netfilter/ipset/ip_set_hash_netport.c   |    3 +--
 8 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter/ipset/pfxlen.h b/include/linux/netfilter/ipset/pfxlen.h
index 84efa33..d55a6cc 100644
--- a/include/linux/netfilter/ipset/pfxlen.h
+++ b/include/linux/netfilter/ipset/pfxlen.h
@@ -35,4 +35,10 @@ ip_set_hostmask6(u8 pfxlen)
 
 extern u32 ip_set_range_to_cidr(u32 from, u32 to, u8 *cidr);
 
+#define ip_set_mask_from_to(from, to, cidr)	\
+do {						\
+	from &= ip_set_hostmask(cidr);		\
+	to = from | ~ip_set_hostmask(cidr);	\
+} while (0)
+
 #endif /*_PFXLEN_H */
diff --git a/net/netfilter/ipset/ip_set_bitmap_ip.c b/net/netfilter/ipset/ip_set_bitmap_ip.c
index 4932311..c46e344 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ip.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ip.c
@@ -283,8 +283,7 @@ bitmap_ip_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
-		ip &= ip_set_hostmask(cidr);
-		ip_to = ip | ~ip_set_hostmask(cidr);
+		ip_set_mask_from_to(ip, ip_to, cidr);
 	} else
 		ip_to = ip;
 
@@ -478,8 +477,7 @@ bitmap_ip_create(struct ip_set *set, struct nlattr *tb[], u32 flags)
 
 		if (cidr >= 32)
 			return -IPSET_ERR_INVALID_CIDR;
-		first_ip &= ip_set_hostmask(cidr);
-		last_ip = first_ip | ~ip_set_hostmask(cidr);
+		ip_set_mask_from_to(first_ip, last_ip, cidr);
 	} else
 		return -IPSET_ERR_PROTOCOL;
 
diff --git a/net/netfilter/ipset/ip_set_bitmap_ipmac.c b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
index 5deb7bb..aa2cfa1 100644
--- a/net/netfilter/ipset/ip_set_bitmap_ipmac.c
+++ b/net/netfilter/ipset/ip_set_bitmap_ipmac.c
@@ -578,7 +578,7 @@ bitmap_ipmac_create(struct ip_set *set, struct nlattr *tb[],
 
 		if (cidr >= 32)
 			return -IPSET_ERR_INVALID_CIDR;
-		last_ip = first_ip | ~ip_set_hostmask(cidr);
+		ip_set_mask_from_to(first_ip, last_ip, cidr);
 	} else
 		return -IPSET_ERR_PROTOCOL;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index c3bc06d..bdb432e 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -177,8 +177,7 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
-		ip &= ip_set_hostmask(cidr);
-		ip_to = ip | ~ip_set_hostmask(cidr);
+		ip_set_mask_from_to(ip, ip_to, cidr);
 	} else
 		ip_to = ip;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipport.c b/net/netfilter/ipset/ip_set_hash_ipport.c
index de2e351..bdeb716 100644
--- a/net/netfilter/ipset/ip_set_hash_ipport.c
+++ b/net/netfilter/ipset/ip_set_hash_ipport.c
@@ -216,8 +216,7 @@ hash_ipport4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
-		ip &= ip_set_hostmask(cidr);
-		ip_to = ip | ~ip_set_hostmask(cidr);
+		ip_set_mask_from_to(ip, ip_to, cidr);
 	} else
 		ip_to = ip;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportip.c b/net/netfilter/ipset/ip_set_hash_ipportip.c
index 031ed05..fb986fc 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportip.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportip.c
@@ -224,8 +224,7 @@ hash_ipportip4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
-		ip &= ip_set_hostmask(cidr);
-		ip_to = ip | ~ip_set_hostmask(cidr);
+		ip_set_mask_from_to(ip, ip_to, cidr);
 	} else
 		ip_to = ip;
 
diff --git a/net/netfilter/ipset/ip_set_hash_ipportnet.c b/net/netfilter/ipset/ip_set_hash_ipportnet.c
index ef068b0..2ed5e75 100644
--- a/net/netfilter/ipset/ip_set_hash_ipportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_ipportnet.c
@@ -254,8 +254,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 		if (cidr > 32)
 			return -IPSET_ERR_INVALID_CIDR;
-		ip &= ip_set_hostmask(cidr);
-		ip_to = ip | ~ip_set_hostmask(cidr);
+		ip_set_mask_from_to(ip, ip_to, cidr);
 	}
 
 	port_to = port = ntohs(data.port);
@@ -273,8 +272,7 @@ hash_ipportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip2_from + UINT_MAX == ip2_to)
 			return -IPSET_ERR_HASH_RANGE;
 	} else {
-		ip2_from &= ip_set_hostmask(data.cidr);
-		ip2_to = ip2_from | ~ip_set_hostmask(data.cidr);
+		ip_set_mask_from_to(ip2_from, ip2_to, data.cidr);
 	}
 
 	if (retried)
diff --git a/net/netfilter/ipset/ip_set_hash_netport.c b/net/netfilter/ipset/ip_set_hash_netport.c
index 3001030..90adc2c 100644
--- a/net/netfilter/ipset/ip_set_hash_netport.c
+++ b/net/netfilter/ipset/ip_set_hash_netport.c
@@ -245,8 +245,7 @@ hash_netport4_uadt(struct ip_set *set, struct nlattr *tb[],
 		if (ip + UINT_MAX == ip_to)
 			return -IPSET_ERR_HASH_RANGE;
 	} else {
-		ip &= ip_set_hostmask(data.cidr);
-		ip_to = ip | ~ip_set_hostmask(data.cidr);
+		ip_set_mask_from_to(ip, ip_to, data.cidr);
 	}
 
 	if (retried)
-- 
1.7.0.4

