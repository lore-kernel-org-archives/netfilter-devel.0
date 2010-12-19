From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/11] kernel: do not mix const and __read_mostly
Date: Sun, 19 Dec 2010 06:18:05 +0100
Message-ID: <1292735894-17534-4-git-send-email-jengelh@medozas.de>
References: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42662 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab0LSFSS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 19 Dec 2010 00:18:18 -0500
In-Reply-To: <1292735894-17534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It makes no sense to mix these two. Either it is
writable-plus-read-mostly, or it is constant.
---
 kernel/include/linux/netfilter/ipset/ip_set.h      |    3 +--
 .../include/linux/netfilter/ipset/ip_set_ahash.h   |    4 ++--
 .../include/linux/netfilter/ipset/ip_set_chash.h   |    4 ++--
 kernel/ip_set.c                                    |   18 +++++++-----------
 kernel/ip_set_bitmap_ip.c                          |    9 ++++-----
 kernel/ip_set_bitmap_ipmac.c                       |    8 ++++----
 kernel/ip_set_bitmap_port.c                        |    9 ++++-----
 kernel/ip_set_hash_ip.c                            |    8 +++-----
 kernel/ip_set_hash_ipport.c                        |    4 ++--
 kernel/ip_set_hash_ipportip.c                      |    4 ++--
 kernel/ip_set_hash_ipportnet.c                     |    4 ++--
 kernel/ip_set_hash_net.c                           |    5 ++---
 kernel/ip_set_hash_netport.c                       |    4 ++--
 kernel/ip_set_list_set.c                           |    7 +++----
 14 files changed, 40 insertions(+), 51 deletions(-)

diff --git a/kernel/include/linux/netfilter/ipset/ip_set.h b/kernel/include/linux/netfilter/ipset/ip_set.h
index df144cc..23661c4 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set.h
@@ -383,8 +383,7 @@ ip_set_get_n16(const struct nlattr *attr)
 	return attr->nla_type & NLA_F_NET_BYTEORDER ? value : htons(value);
 }
 
-static const struct nla_policy
-ipaddr_policy[IPSET_ATTR_IPADDR_MAX + 1] __read_mostly = {
+static const struct nla_policy ipaddr_policy[IPSET_ATTR_IPADDR_MAX + 1] = {
 	[IPSET_ATTR_IPADDR_IPV4]	= { .type = NLA_U32 },
 	[IPSET_ATTR_IPADDR_IPV6]	= { .type = NLA_BINARY,
 					    .len = sizeof(struct in6_addr) },
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_ahash.h b/kernel/include/linux/netfilter/ipset/ip_set_ahash.h
index 85e23b2..589b157 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_ahash.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set_ahash.h
@@ -592,7 +592,7 @@ static int
 type_pf_uadt(struct ip_set *set, struct nlattr *head, int len,
 	     enum ipset_adt adt, u32 *lineno, u32 flags);
 
-static const struct ip_set_type_variant type_pf_variant __read_mostly = {
+static const struct ip_set_type_variant type_pf_variant = {
 	.kadt	= type_pf_kadt,
 	.uadt	= type_pf_uadt,
 	.adt	= {
@@ -986,7 +986,7 @@ nla_put_failure:
 	return 0;
 }
 
-static const struct ip_set_type_variant type_pf_tvariant __read_mostly = {
+static const struct ip_set_type_variant type_pf_tvariant = {
 	.kadt	= type_pf_kadt,
 	.uadt	= type_pf_uadt,
 	.adt	= {
diff --git a/kernel/include/linux/netfilter/ipset/ip_set_chash.h b/kernel/include/linux/netfilter/ipset/ip_set_chash.h
index 04955ef..62756e5 100644
--- a/kernel/include/linux/netfilter/ipset/ip_set_chash.h
+++ b/kernel/include/linux/netfilter/ipset/ip_set_chash.h
@@ -636,7 +636,7 @@ static int
 type_pf_uadt(struct ip_set *set, struct nlattr *head, int len,
 	     enum ipset_adt adt, u32 *lineno, u32 flags);
 
-static const struct ip_set_type_variant type_pf_variant __read_mostly = {
+static const struct ip_set_type_variant type_pf_variant = {
 	.kadt	= type_pf_kadt,
 	.uadt	= type_pf_uadt,
 	.adt	= {
@@ -1072,7 +1072,7 @@ nla_put_failure:
 	return 0;
 }
 
-static const struct ip_set_type_variant type_pf_tvariant __read_mostly = {
+static const struct ip_set_type_variant type_pf_tvariant = {
 	.kadt	= type_pf_kadt,
 	.uadt	= type_pf_uadt,
 	.adt	= {
diff --git a/kernel/ip_set.c b/kernel/ip_set.c
index ea4e888..19a0571 100644
--- a/kernel/ip_set.c
+++ b/kernel/ip_set.c
@@ -747,8 +747,7 @@ start_msg(struct sk_buff *skb, u32 pid, u32 seq, unsigned int flags,
 
 /* Create a set */
 
-static const struct nla_policy
-ip_set_create_policy[IPSET_ATTR_CMD_MAX + 1] __read_mostly = {
+static const struct nla_policy ip_set_create_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
 	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
 				    .len = IPSET_MAXNAMELEN - 1 },
@@ -929,7 +928,7 @@ out:
 /* Destroy sets */
 
 static const struct nla_policy
-ip_set_setname_policy[IPSET_ATTR_CMD_MAX + 1] __read_mostly = {
+ip_set_setname_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
 	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
 				    .len = IPSET_MAXNAMELEN - 1 },
@@ -1022,7 +1021,7 @@ ip_set_flush(struct sock *ctnl, struct sk_buff *skb,
 /* Rename a set */
 
 static const struct nla_policy
-ip_set_setname2_policy[IPSET_ATTR_CMD_MAX + 1] __read_mostly = {
+ip_set_setname2_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
 	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
 				    .len = IPSET_MAXNAMELEN - 1 },
@@ -1306,8 +1305,7 @@ ip_set_dump(struct sock *ctnl, struct sk_buff *skb,
 
 /* Add, del and test */
 
-static const struct nla_policy
-ip_set_adt_policy[IPSET_ATTR_CMD_MAX + 1] __read_mostly = {
+static const struct nla_policy ip_set_adt_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
 	[IPSET_ATTR_SETNAME]	= { .type = NLA_NUL_STRING,
 				    .len = IPSET_MAXNAMELEN - 1 },
@@ -1519,8 +1517,7 @@ nlmsg_failure:
 
 /* Get type data */
 
-static const struct nla_policy
-ip_set_type_policy[IPSET_ATTR_CMD_MAX + 1] __read_mostly = {
+static const struct nla_policy ip_set_type_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
 	[IPSET_ATTR_TYPENAME]	= { .type = NLA_NUL_STRING,
 				    .len = IPSET_MAXNAMELEN - 1 },
@@ -1587,7 +1584,7 @@ nlmsg_failure:
 /* Get protocol version */
 
 static const struct nla_policy
-ip_set_protocol_policy[IPSET_ATTR_CMD_MAX + 1] __read_mostly = {
+ip_set_protocol_policy[IPSET_ATTR_CMD_MAX + 1] = {
 	[IPSET_ATTR_PROTOCOL]	= { .type = NLA_U8 },
 };
 
@@ -1627,8 +1624,7 @@ nlmsg_failure:
 	return -EFAULT;
 }
 
-static const struct nfnl_callback __read_mostly
-ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
+static const struct nfnl_callback ip_set_netlink_subsys_cb[IPSET_MSG_MAX] = {
 	[IPSET_CMD_CREATE]	= {
 		.call		= ip_set_create,
 		.attr_count	= IPSET_ATTR_CMD_MAX,
diff --git a/kernel/ip_set_bitmap_ip.c b/kernel/ip_set_bitmap_ip.c
index 054c717..470a42d 100644
--- a/kernel/ip_set_bitmap_ip.c
+++ b/kernel/ip_set_bitmap_ip.c
@@ -100,8 +100,7 @@ bitmap_ip_kadt(struct ip_set *set, const struct sk_buff *skb,
 	}
 }
 
-static const struct nla_policy
-bitmap_ip_adt_policy[IPSET_ATTR_ADT_MAX+1] __read_mostly = {
+static const struct nla_policy bitmap_ip_adt_policy[IPSET_ATTR_ADT_MAX+1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 	[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
@@ -269,7 +268,7 @@ bitmap_ip_same_set(const struct ip_set *a, const struct ip_set *b)
 	       && x->netmask == y->netmask;
 }
 
-static const struct ip_set_type_variant bitmap_ip __read_mostly = {
+static const struct ip_set_type_variant bitmap_ip = {
 	.kadt	= bitmap_ip_kadt,
 	.uadt	= bitmap_ip_uadt,
 	.destroy = bitmap_ip_destroy,
@@ -517,7 +516,7 @@ bitmap_ip_timeout_same_set(const struct ip_set *a, const struct ip_set *b)
 	       && x->timeout == y->timeout;
 }
 
-static const struct ip_set_type_variant bitmap_ip_timeout __read_mostly = {
+static const struct ip_set_type_variant bitmap_ip_timeout = {
 	.kadt	= bitmap_ip_timeout_kadt,
 	.uadt	= bitmap_ip_timeout_uadt,
 	.destroy = bitmap_ip_timeout_destroy,
@@ -562,7 +561,7 @@ bitmap_ip_gc_init(struct ip_set *set)
 /* Create bitmap:ip type of sets */
 
 static const struct nla_policy
-bitmap_ip_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+bitmap_ip_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 	[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
diff --git a/kernel/ip_set_bitmap_ipmac.c b/kernel/ip_set_bitmap_ipmac.c
index 9b2c02c..0bd9a89 100644
--- a/kernel/ip_set_bitmap_ipmac.c
+++ b/kernel/ip_set_bitmap_ipmac.c
@@ -358,7 +358,7 @@ bitmap_ipmac_kadt(struct ip_set *set, const struct sk_buff *skb,
 }
 
 static const struct nla_policy
-bitmap_ipmac_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+bitmap_ipmac_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_ETHER]	= { .type = NLA_BINARY, .len  = ETH_ALEN },
 	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
@@ -468,7 +468,7 @@ bitmap_ipmac_same_set(const struct ip_set *a, const struct ip_set *b)
 	       && x->timeout == y->timeout;
 }
 
-const struct ip_set_type_variant bitmap_ipmac __read_mostly = {
+const struct ip_set_type_variant bitmap_ipmac = {
 	.kadt	= bitmap_ipmac_kadt,
 	.uadt	= bitmap_ipmac_uadt,
 	.adt	= {
@@ -483,7 +483,7 @@ const struct ip_set_type_variant bitmap_ipmac __read_mostly = {
 	.same_set = bitmap_ipmac_same_set,
 };
 
-const struct ip_set_type_variant bitmap_tipmac __read_mostly = {
+const struct ip_set_type_variant bitmap_tipmac = {
 	.kadt	= bitmap_ipmac_kadt,
 	.uadt	= bitmap_ipmac_uadt,
 	.adt	= {
@@ -536,7 +536,7 @@ bitmap_ipmac_gc_init(struct ip_set *set)
 /* Create bitmap:ip,mac type of sets */
 
 static const struct nla_policy
-bitmap_ipmac_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+bitmap_ipmac_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/kernel/ip_set_bitmap_port.c b/kernel/ip_set_bitmap_port.c
index a430c0b..eccef08 100644
--- a/kernel/ip_set_bitmap_port.c
+++ b/kernel/ip_set_bitmap_port.c
@@ -95,8 +95,7 @@ bitmap_port_kadt(struct ip_set *set, const struct sk_buff *skb,
 	}
 }
 
-static const struct nla_policy
-bitmap_port_adt_policy[IPSET_ATTR_ADT_MAX+1] __read_mostly = {
+static const struct nla_policy bitmap_port_adt_policy[IPSET_ATTR_ADT_MAX+1] = {
 	[IPSET_ATTR_PORT]	= { .type = NLA_U16 },
 	[IPSET_ATTR_PORT_TO]	= { .type = NLA_U16 },
 	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
@@ -251,7 +250,7 @@ bitmap_port_same_set(const struct ip_set *a, const struct ip_set *b)
 	       && x->last_port == y->last_port;
 }
 
-const struct ip_set_type_variant bitmap_port __read_mostly = {
+const struct ip_set_type_variant bitmap_port = {
 	.kadt	= bitmap_port_kadt,
 	.uadt	= bitmap_port_uadt,
 	.destroy = bitmap_port_destroy,
@@ -489,7 +488,7 @@ bitmap_port_timeout_same_set(const struct ip_set *a, const struct ip_set *b)
 	       && x->timeout == y->timeout;
 }
 
-const struct ip_set_type_variant bitmap_port_timeout __read_mostly = {
+const struct ip_set_type_variant bitmap_port_timeout = {
 	.kadt	= bitmap_port_timeout_kadt,
 	.uadt	= bitmap_port_timeout_uadt,
 	.destroy = bitmap_port_timeout_destroy,
@@ -535,7 +534,7 @@ bitmap_port_gc_init(struct ip_set *set)
 /* Create bitmap:ip type of sets */
 
 static const struct nla_policy
-bitmap_port_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+bitmap_port_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_PORT]	= { .type = NLA_U16 },
 	[IPSET_ATTR_PORT_TO]	= { .type = NLA_U16 },
 	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
diff --git a/kernel/ip_set_hash_ip.c b/kernel/ip_set_hash_ip.c
index bc0c706..583b572 100644
--- a/kernel/ip_set_hash_ip.c
+++ b/kernel/ip_set_hash_ip.c
@@ -133,8 +133,7 @@ hash_ip4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return adtfn(set, &ip, h->timeout);
 }
 
-static const struct nla_policy
-hash_ip4_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+static const struct nla_policy hash_ip4_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 	[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
@@ -323,8 +322,7 @@ hash_ip6_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return adtfn(set, &ip, h->timeout);
 }
 
-static const struct nla_policy
-hash_ip6_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+static const struct nla_policy hash_ip6_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 	[IPSET_ATTR_LINENO]	= { .type = NLA_U32 },
@@ -370,7 +368,7 @@ hash_ip6_uadt(struct ip_set *set, struct nlattr *head, int len,
 /* Create hash:ip type of sets */
 
 static const struct nla_policy
-hash_ip_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+hash_ip_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 	[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
 	[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
diff --git a/kernel/ip_set_hash_ipport.c b/kernel/ip_set_hash_ipport.c
index d9ee214..16eed36 100644
--- a/kernel/ip_set_hash_ipport.c
+++ b/kernel/ip_set_hash_ipport.c
@@ -154,7 +154,7 @@ hash_ipport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 }
 
 static const struct nla_policy
-hash_ipport_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+hash_ipport_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 	[IPSET_ATTR_PORT]	= { .type = NLA_U16 },
@@ -466,7 +466,7 @@ hash_ipport6_uadt(struct ip_set *set, struct nlattr *head, int len,
 /* Create hash:ip type of sets */
 
 static const struct nla_policy
-hash_ipport_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+hash_ipport_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 	[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
 	[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
diff --git a/kernel/ip_set_hash_ipportip.c b/kernel/ip_set_hash_ipportip.c
index b0aaf08..396273b 100644
--- a/kernel/ip_set_hash_ipportip.c
+++ b/kernel/ip_set_hash_ipportip.c
@@ -160,7 +160,7 @@ hash_ipportip4_kadt(struct ip_set *set, const struct sk_buff *skb,
 }
 
 static const struct nla_policy
-hash_ipportip_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+hash_ipportip_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP2]	= { .type = NLA_NESTED },
@@ -487,7 +487,7 @@ hash_ipportip6_uadt(struct ip_set *set, struct nlattr *head, int len,
 /* Create hash:ip type of sets */
 
 static const struct nla_policy
-hash_ipportip_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+hash_ipportip_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 	[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
 	[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
diff --git a/kernel/ip_set_hash_ipportnet.c b/kernel/ip_set_hash_ipportnet.c
index 6886aa8..0021c0c 100644
--- a/kernel/ip_set_hash_ipportnet.c
+++ b/kernel/ip_set_hash_ipportnet.c
@@ -180,7 +180,7 @@ hash_ipportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 }
 
 static const struct nla_policy
-hash_ipportnet_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+hash_ipportnet_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP_TO]	= { .type = NLA_NESTED },
 	[IPSET_ATTR_IP2]	= { .type = NLA_NESTED },
@@ -550,7 +550,7 @@ hash_ipportnet6_uadt(struct ip_set *set, struct nlattr *head, int len,
 /* Create hash:ip type of sets */
 
 static const struct nla_policy
-hash_ipportnet_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+hash_ipportnet_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 	[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
 	[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
diff --git a/kernel/ip_set_hash_net.c b/kernel/ip_set_hash_net.c
index b13ed98..1282839 100644
--- a/kernel/ip_set_hash_net.c
+++ b/kernel/ip_set_hash_net.c
@@ -155,8 +155,7 @@ hash_net4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return adtfn(set, &data, h->timeout);
 }
 
-static const struct nla_policy
-hash_net_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+static const struct nla_policy hash_net_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_CIDR]	= { .type = NLA_U8 },
 	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
@@ -382,7 +381,7 @@ hash_net6_uadt(struct ip_set *set, struct nlattr *head, int len,
 /* Create hash:ip type of sets */
 
 static const struct nla_policy
-hash_net_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+hash_net_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 	[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
 	[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
diff --git a/kernel/ip_set_hash_netport.c b/kernel/ip_set_hash_netport.c
index 2c42c5b..9c4767e 100644
--- a/kernel/ip_set_hash_netport.c
+++ b/kernel/ip_set_hash_netport.c
@@ -175,7 +175,7 @@ hash_netport4_kadt(struct ip_set *set, const struct sk_buff *skb,
 }
 
 static const struct nla_policy
-hash_netport_adt_policy[IPSET_ATTR_ADT_MAX + 1] __read_mostly = {
+hash_netport_adt_policy[IPSET_ATTR_ADT_MAX + 1] = {
 	[IPSET_ATTR_IP]		= { .type = NLA_NESTED },
 	[IPSET_ATTR_PORT]	= { .type = NLA_U16 },
 	[IPSET_ATTR_PORT_TO]	= { .type = NLA_U16 },
@@ -500,7 +500,7 @@ hash_netport6_uadt(struct ip_set *set, struct nlattr *head, int len,
 /* Create hash:ip type of sets */
 
 static const struct nla_policy
-hash_netport_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+hash_netport_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_HASHSIZE]	= { .type = NLA_U32 },
 	[IPSET_ATTR_MAXELEM]	= { .type = NLA_U32 },
 	[IPSET_ATTR_PROBES]	= { .type = NLA_U8 },
diff --git a/kernel/ip_set_list_set.c b/kernel/ip_set_list_set.c
index fe4b410..a2c2eef 100644
--- a/kernel/ip_set_list_set.c
+++ b/kernel/ip_set_list_set.c
@@ -112,8 +112,7 @@ list_set_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return -EINVAL;
 }
 
-static const struct nla_policy
-list_set_adt_policy[IPSET_ATTR_ADT_MAX+1] __read_mostly = {
+static const struct nla_policy list_set_adt_policy[IPSET_ATTR_ADT_MAX+1] = {
 	[IPSET_ATTR_NAME]	= { .type = NLA_STRING,
 				    .len = IPSET_MAXNAMELEN },
 	[IPSET_ATTR_NAMEREF]	= { .type = NLA_STRING,
@@ -454,7 +453,7 @@ list_set_same_set(const struct ip_set *a, const struct ip_set *b)
 	       && x->timeout == y->timeout;
 }
 
-static const struct ip_set_type_variant list_set __read_mostly = {
+static const struct ip_set_type_variant list_set = {
 	.kadt	= list_set_kadt,
 	.uadt	= list_set_uadt,
 	.destroy = list_set_destroy,
@@ -502,7 +501,7 @@ list_set_gc_init(struct ip_set *set)
 /* Create list:set type of sets */
 
 static const struct nla_policy
-list_set_create_policy[IPSET_ATTR_CREATE_MAX+1] __read_mostly = {
+list_set_create_policy[IPSET_ATTR_CREATE_MAX+1] = {
 	[IPSET_ATTR_SIZE]	= { .type = NLA_U32 },
 	[IPSET_ATTR_TIMEOUT]	= { .type = NLA_U32 },
 };
-- 
1.7.1

