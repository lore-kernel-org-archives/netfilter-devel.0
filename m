From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 044/103] netfilter: xtables: deconstify struct xt_action_param for matches
Date: Tue,  4 Aug 2009 09:25:28 +0200
Message-ID: <1249370787-17583-45-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbZHDH1V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:21 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In future, layer-3 matches will be an xt module of their own, and
need to set the fragoff and thoff fields. Adding more pointers would
needlessy increase memory requirements (esp. so for 64-bit, where
pointers are wider).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h   |    2 +-
 net/bridge/netfilter/ebt_802_3.c     |    2 +-
 net/bridge/netfilter/ebt_among.c     |    2 +-
 net/bridge/netfilter/ebt_arp.c       |    2 +-
 net/bridge/netfilter/ebt_ip.c        |    2 +-
 net/bridge/netfilter/ebt_ip6.c       |    2 +-
 net/bridge/netfilter/ebt_limit.c     |    2 +-
 net/bridge/netfilter/ebt_mark_m.c    |    2 +-
 net/bridge/netfilter/ebt_pkttype.c   |    2 +-
 net/bridge/netfilter/ebt_stp.c       |    2 +-
 net/bridge/netfilter/ebt_vlan.c      |    2 +-
 net/ipv4/netfilter/ip_tables.c       |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c    |    4 ++--
 net/ipv4/netfilter/ipt_ah.c          |    2 +-
 net/ipv4/netfilter/ipt_ecn.c         |    2 +-
 net/ipv6/netfilter/ip6_tables.c      |    2 +-
 net/ipv6/netfilter/ip6t_ah.c         |    2 +-
 net/ipv6/netfilter/ip6t_eui64.c      |    2 +-
 net/ipv6/netfilter/ip6t_frag.c       |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c        |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 +-
 net/ipv6/netfilter/ip6t_mh.c         |    2 +-
 net/ipv6/netfilter/ip6t_rt.c         |    2 +-
 net/netfilter/xt_cluster.c           |    2 +-
 net/netfilter/xt_comment.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    2 +-
 net/netfilter/xt_connlimit.c         |    2 +-
 net/netfilter/xt_connmark.c          |    2 +-
 net/netfilter/xt_conntrack.c         |    2 +-
 net/netfilter/xt_dccp.c              |    2 +-
 net/netfilter/xt_dscp.c              |    6 +++---
 net/netfilter/xt_esp.c               |    2 +-
 net/netfilter/xt_hashlimit.c         |    4 ++--
 net/netfilter/xt_helper.c            |    2 +-
 net/netfilter/xt_hl.c                |    4 ++--
 net/netfilter/xt_iprange.c           |    4 ++--
 net/netfilter/xt_length.c            |    4 ++--
 net/netfilter/xt_limit.c             |    2 +-
 net/netfilter/xt_mac.c               |    2 +-
 net/netfilter/xt_mark.c              |    2 +-
 net/netfilter/xt_multiport.c         |    4 ++--
 net/netfilter/xt_osf.c               |    2 +-
 net/netfilter/xt_owner.c             |    2 +-
 net/netfilter/xt_physdev.c           |    2 +-
 net/netfilter/xt_pkttype.c           |    2 +-
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_quota.c             |    2 +-
 net/netfilter/xt_rateest.c           |    2 +-
 net/netfilter/xt_realm.c             |    2 +-
 net/netfilter/xt_recent.c            |    2 +-
 net/netfilter/xt_sctp.c              |    2 +-
 net/netfilter/xt_socket.c            |    6 +++---
 net/netfilter/xt_state.c             |    2 +-
 net/netfilter/xt_statistic.c         |    2 +-
 net/netfilter/xt_string.c            |    2 +-
 net/netfilter/xt_tcpmss.c            |    2 +-
 net/netfilter/xt_tcpudp.c            |    4 ++--
 net/netfilter/xt_time.c              |    2 +-
 net/netfilter/xt_u32.c               |    2 +-
 59 files changed, 70 insertions(+), 70 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b20225f..d8f8e2a 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -289,7 +289,7 @@ struct xt_match
 	   non-linear skb, using skb_header_pointer and
 	   skb_ip_make_writable. */
 	bool (*match)(const struct sk_buff *skb,
-		      const struct xt_action_param *);
+		      struct xt_action_param *);
 
 	/* Called when user tries to insert an entry of this type. */
 	bool (*checkentry)(const struct xt_mtchk_param *);
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 8a2347f..127cb0b 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -13,7 +13,7 @@
 #include <linux/netfilter_bridge/ebt_802_3.h>
 
 static bool
-ebt_802_3_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_802_3_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_802_3_info *info = par->matchinfo;
 	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 39f1b4f..c3f29d5 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -128,7 +128,7 @@ static int get_ip_src(const struct sk_buff *skb, __be32 *addr)
 }
 
 static bool
-ebt_among_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_among_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_among_info *info = par->matchinfo;
 	const char *dmac, *smac;
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 488840e..988740a 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter_bridge/ebt_arp.h>
 
 static bool
-ebt_arp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_arp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_arp_info *info = par->matchinfo;
 	const struct arphdr *ah;
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 87701ec..934d16c 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -25,7 +25,7 @@ struct tcpudphdr {
 };
 
 static bool
-ebt_ip_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_ip_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_ip_info *info = par->matchinfo;
 	const struct iphdr *ih;
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index ef73859..559cd0a 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -28,7 +28,7 @@ struct tcpudphdr {
 };
 
 static bool
-ebt_ip6_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_ip6_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_ip6_info *info = par->matchinfo;
 	const struct ipv6hdr *ih6;
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 7dd55f8..2e97bba 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -31,7 +31,7 @@ static DEFINE_SPINLOCK(limit_lock);
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static bool
-ebt_limit_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_limit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct ebt_limit_info *info = (void *)par->matchinfo;
 	unsigned long now = jiffies;
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 598be12..a357f48 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -13,7 +13,7 @@
 #include <linux/netfilter_bridge/ebt_mark_m.h>
 
 static bool
-ebt_mark_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_mark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_mark_m_info *info = par->matchinfo;
 
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index c0e17a2..85b4b58 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -13,7 +13,7 @@
 #include <linux/netfilter_bridge/ebt_pkttype.h>
 
 static bool
-ebt_pkttype_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_pkttype_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_pkttype_info *info = par->matchinfo;
 
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index dd1ca65..608406b 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -120,7 +120,7 @@ static bool ebt_filter_config(const struct ebt_stp_info *info,
 }
 
 static bool
-ebt_stp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_stp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_stp_info *info = par->matchinfo;
 	const struct stp_header *sp;
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 528691c..8c5927b 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -41,7 +41,7 @@ MODULE_LICENSE("GPL");
 #define EXIT_ON_MISMATCH(_MATCH_,_MASK_) {if (!((info->_MATCH_ == _MATCH_)^!!(info->invflags & _MASK_))) return false; }
 
 static bool
-ebt_vlan_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+ebt_vlan_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ebt_vlan_info *info = par->matchinfo;
 	const struct vlan_hdr *fp;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8483d57..a8398ae 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2124,7 +2124,7 @@ icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 }
 
 static bool
-icmp_match(const struct sk_buff *skb, const struct xt_action_param *par)
+icmp_match(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct icmphdr *ic;
 	struct icmphdr _icmph;
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 4d6c51d..be1d2fa 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -30,7 +30,7 @@ static inline bool match_type(struct net *net, const struct net_device *dev,
 }
 
 static bool
-addrtype_mt_v0(const struct sk_buff *skb, const struct xt_action_param *par)
+addrtype_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct net *net = dev_net(par->in ? par->in : par->out);
 	const struct ipt_addrtype_info *info = par->matchinfo;
@@ -48,7 +48,7 @@ addrtype_mt_v0(const struct sk_buff *skb, const struct xt_action_param *par)
 }
 
 static bool
-addrtype_mt_v1(const struct sk_buff *skb, const struct xt_action_param *par)
+addrtype_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct net *net = dev_net(par->in ? par->in : par->out);
 	const struct ipt_addrtype_info_v1 *info = par->matchinfo;
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 15b7b4a..90bc2be 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -36,7 +36,7 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool ah_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool ah_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct ip_auth_hdr _ahdr;
 	const struct ip_auth_hdr *ah;
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index 19dde8b..96056b0 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -67,7 +67,7 @@ static inline bool match_tcp(const struct sk_buff *skb,
 	return true;
 }
 
-static bool ecn_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool ecn_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_ecn_info *info = par->matchinfo;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 0df417b..46c675d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -2138,7 +2138,7 @@ icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
 }
 
 static bool
-icmp6_match(const struct sk_buff *skb, const struct xt_action_param *par)
+icmp6_match(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct icmp6hdr *ic;
 	struct icmp6hdr _icmph;
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index b40e3b9..c25af95 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -36,7 +36,7 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool ah_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct ip_auth_hdr _ah;
 	const struct ip_auth_hdr *ah;
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index bd937c2..86eb6ae 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -20,7 +20,7 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 static bool
-eui64_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+eui64_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	unsigned char eui64[8];
 	int i = 0;
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index ab3e5eb..35b9553 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -35,7 +35,7 @@ id_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 }
 
 static bool
-frag_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+frag_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct frag_hdr _frag;
 	const struct frag_hdr *fh;
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index ccce583..e8a845e 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -42,7 +42,7 @@ MODULE_ALIAS("ip6t_dst");
  */
 
 static bool
-hbh_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct ipv6_opt_hdr _optsh;
 	const struct ipv6_opt_hdr *oh;
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index a1dca01..77350c3 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -27,7 +27,7 @@ MODULE_DESCRIPTION("Xtables: IPv6 header types match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 static bool
-ipv6header_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+ipv6header_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip6t_ipv6header_info *info = par->matchinfo;
 	unsigned int temp;
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index 774ef11..c001965 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -37,7 +37,7 @@ type_match(u_int8_t min, u_int8_t max, u_int8_t type, bool invert)
 	return (type >= min && type <= max) ^ invert;
 }
 
-static bool mh_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool mh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct ip6_mh _mh;
 	const struct ip6_mh *mh;
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 51d20e8..cd060f4 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -36,7 +36,7 @@ segsleft_match(u_int32_t min, u_int32_t max, u_int32_t id, bool invert)
 	return r;
 }
 
-static bool rt_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct ipv6_rt_hdr _route;
 	const struct ipv6_rt_hdr *rh;
diff --git a/net/netfilter/xt_cluster.c b/net/netfilter/xt_cluster.c
index fc3e5fb..b3c2eb1 100644
--- a/net/netfilter/xt_cluster.c
+++ b/net/netfilter/xt_cluster.c
@@ -85,7 +85,7 @@ xt_cluster_is_multicast_addr(const struct sk_buff *skb, u_int8_t family)
 }
 
 static bool
-xt_cluster_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+xt_cluster_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct sk_buff *pskb = (struct sk_buff *)skb;
 	const struct xt_cluster_match_info *info = par->matchinfo;
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 1dbb3e1..5c861d2 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -16,7 +16,7 @@ MODULE_ALIAS("ipt_comment");
 MODULE_ALIAS("ip6t_comment");
 
 static bool
-comment_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+comment_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	/* We always match */
 	return true;
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index a43b635..a7ca4ac 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -17,7 +17,7 @@ MODULE_ALIAS("ipt_connbytes");
 MODULE_ALIAS("ip6t_connbytes");
 
 static bool
-connbytes_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+connbytes_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_connbytes_info *sinfo = par->matchinfo;
 	const struct nf_conn *ct;
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index f580eea..645a91c 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -180,7 +180,7 @@ static int count_them(struct xt_connlimit_data *data,
 }
 
 static bool
-connlimit_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_connlimit_info *info = par->matchinfo;
 	union nf_inet_addr addr;
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 3da9a9c..4f1e92d 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -34,7 +34,7 @@ MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
 
 static bool
-connmark_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+connmark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_connmark_mtinfo1 *info = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index fd9efe8..da28808 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -113,7 +113,7 @@ ct_proto_port_check(const struct xt_conntrack_mtinfo1 *info,
 }
 
 static bool
-conntrack_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+conntrack_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_conntrack_mtinfo1 *info = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 4ae8284..d39a637 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -95,7 +95,7 @@ match_option(u_int8_t option, const struct sk_buff *skb, unsigned int protoff,
 }
 
 static bool
-dccp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+dccp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dccp_info *info = par->matchinfo;
 	const struct dccp_hdr *dh;
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 42787e1..e81a284 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -25,7 +25,7 @@ MODULE_ALIAS("ipt_tos");
 MODULE_ALIAS("ip6t_tos");
 
 static bool
-dscp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+dscp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
@@ -34,7 +34,7 @@ dscp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
 }
 
 static bool
-dscp_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+dscp_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_dscp_info *info = par->matchinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
@@ -54,7 +54,7 @@ static bool dscp_mt_check(const struct xt_mtchk_param *par)
 	return true;
 }
 
-static bool tos_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool tos_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_tos_match_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index 0f67833..2ae4a59 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -42,7 +42,7 @@ spi_match(u_int32_t min, u_int32_t max, u_int32_t spi, bool invert)
 	return r;
 }
 
-static bool esp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool esp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip_esp_hdr *eh;
 	struct ip_esp_hdr _esp;
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 45100b0..32fb029 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -563,7 +563,7 @@ hashlimit_init_dst(const struct xt_hashlimit_htable *hinfo,
 }
 
 static bool
-hashlimit_mt_v0(const struct sk_buff *skb, const struct xt_action_param *par)
+hashlimit_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_hashlimit_info *r = par->matchinfo;
 	struct xt_hashlimit_htable *hinfo = r->hinfo;
@@ -614,7 +614,7 @@ hotdrop:
 }
 
 static bool
-hashlimit_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_hashlimit_mtinfo1 *info = par->matchinfo;
 	struct xt_hashlimit_htable *hinfo = info->hinfo;
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index a163c9b..e030174 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -24,7 +24,7 @@ MODULE_ALIAS("ip6t_helper");
 
 
 static bool
-helper_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+helper_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_helper_info *info = par->matchinfo;
 	const struct nf_conn *ct;
diff --git a/net/netfilter/xt_hl.c b/net/netfilter/xt_hl.c
index ba7c86f..de6af40 100644
--- a/net/netfilter/xt_hl.c
+++ b/net/netfilter/xt_hl.c
@@ -25,7 +25,7 @@ MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_ttl");
 MODULE_ALIAS("ip6t_hl");
 
-static bool ttl_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool ttl_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ipt_ttl_info *info = par->matchinfo;
 	const u8 ttl = ip_hdr(skb)->ttl;
@@ -48,7 +48,7 @@ static bool ttl_mt(const struct sk_buff *skb, const struct xt_action_param *par)
 	return false;
 }
 
-static bool hl_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool hl_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct ip6t_hl_info *info = par->matchinfo;
 	const struct ipv6hdr *ip6h = ipv6_hdr(skb);
diff --git a/net/netfilter/xt_iprange.c b/net/netfilter/xt_iprange.c
index 8c7e815..5606a0d 100644
--- a/net/netfilter/xt_iprange.c
+++ b/net/netfilter/xt_iprange.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/xt_iprange.h>
 
 static bool
-iprange_mt4(const struct sk_buff *skb, const struct xt_action_param *par)
+iprange_mt4(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_iprange_mtinfo *info = par->matchinfo;
 	const struct iphdr *iph = ip_hdr(skb);
@@ -67,7 +67,7 @@ iprange_ipv6_sub(const struct in6_addr *a, const struct in6_addr *b)
 }
 
 static bool
-iprange_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+iprange_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_iprange_mtinfo *info = par->matchinfo;
 	const struct ipv6hdr *iph = ipv6_hdr(skb);
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index 842149b..176e557 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -21,7 +21,7 @@ MODULE_ALIAS("ipt_length");
 MODULE_ALIAS("ip6t_length");
 
 static bool
-length_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+length_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
 	u_int16_t pktlen = ntohs(ip_hdr(skb)->tot_len);
@@ -30,7 +30,7 @@ length_mt(const struct sk_buff *skb, const struct xt_action_param *par)
 }
 
 static bool
-length_mt6(const struct sk_buff *skb, const struct xt_action_param *par)
+length_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_length_info *info = par->matchinfo;
 	const u_int16_t pktlen = ntohs(ipv6_hdr(skb)->payload_len) +
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 6b038ad..b670b29 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -63,7 +63,7 @@ static DEFINE_SPINLOCK(limit_lock);
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static bool
-limit_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+limit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateinfo *r = par->matchinfo;
 	struct xt_limit_priv *priv = r->master;
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 12249d7..367f66f 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -24,7 +24,7 @@ MODULE_DESCRIPTION("Xtables: MAC address match");
 MODULE_ALIAS("ipt_mac");
 MODULE_ALIAS("ip6t_mac");
 
-static bool mac_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool mac_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
     const struct xt_mac_info *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 0c1a972..132f193 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -23,7 +23,7 @@ MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
 static bool
-mark_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+mark_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_mark_mtinfo1 *info = par->matchinfo;
 
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index d601791..ab967a5 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -95,7 +95,7 @@ ports_match_v1(const struct xt_multiport_v1 *minfo,
 }
 
 static bool
-multiport_mt_v0(const struct sk_buff *skb, const struct xt_action_param *par)
+multiport_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const __be16 *pptr;
 	__be16 _ports[2];
@@ -119,7 +119,7 @@ multiport_mt_v0(const struct sk_buff *skb, const struct xt_action_param *par)
 }
 
 static bool
-multiport_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+multiport_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const __be16 *pptr;
 	__be16 _ports[2];
diff --git a/net/netfilter/xt_osf.c b/net/netfilter/xt_osf.c
index e7fe1fc..ac632bc 100644
--- a/net/netfilter/xt_osf.c
+++ b/net/netfilter/xt_osf.c
@@ -192,7 +192,7 @@ static inline int xt_osf_ttl(const struct sk_buff *skb, const struct xt_osf_info
 }
 
 static bool xt_osf_match_packet(const struct sk_buff *skb,
-		const struct xt_action_param *p)
+		struct xt_action_param *p)
 {
 	const struct xt_osf_info *info = p->matchinfo;
 	const struct iphdr *ip = ip_hdr(skb);
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 3dd1391..772d738 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -18,7 +18,7 @@
 #include <linux/netfilter/xt_owner.h>
 
 static bool
-owner_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+owner_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_owner_match_info *info = par->matchinfo;
 	const struct file *filp;
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index a344d82..97f9078 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -22,7 +22,7 @@ MODULE_ALIAS("ip6t_physdev");
 
 
 static bool
-physdev_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+physdev_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct xt_physdev_info *info = par->matchinfo;
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index d95f214..5b645cb 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -23,7 +23,7 @@ MODULE_ALIAS("ipt_pkttype");
 MODULE_ALIAS("ip6t_pkttype");
 
 static bool
-pkttype_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+pkttype_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_pkttype_info *info = par->matchinfo;
 	u_int8_t type;
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 74125b5..6e48cb5 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -110,7 +110,7 @@ match_policy_out(const struct sk_buff *skb, const struct xt_policy_info *info,
 }
 
 static bool
-policy_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+policy_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_policy_info *info = par->matchinfo;
 	int ret;
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 4fb170d..ad0ed79 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -22,7 +22,7 @@ MODULE_ALIAS("ip6t_quota");
 static DEFINE_SPINLOCK(quota_lock);
 
 static bool
-quota_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+quota_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	struct xt_quota_info *q = (void *)par->matchinfo;
 	struct xt_quota_priv *priv = q->master;
diff --git a/net/netfilter/xt_rateest.c b/net/netfilter/xt_rateest.c
index 80a9336..f440410 100644
--- a/net/netfilter/xt_rateest.c
+++ b/net/netfilter/xt_rateest.c
@@ -15,7 +15,7 @@
 
 
 static bool
-xt_rateest_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+xt_rateest_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_rateest_match_info *info = par->matchinfo;
 	struct gnet_stats_rate_est *r;
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index b063c78..459a7b2 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -22,7 +22,7 @@ MODULE_DESCRIPTION("Xtables: Routing realm match");
 MODULE_ALIAS("ipt_realm");
 
 static bool
-realm_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+realm_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_realm_info *info = par->matchinfo;
 	const struct dst_entry *dst = skb_dst(skb);
diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 23763c0..6929c0b 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -198,7 +198,7 @@ static void recent_table_flush(struct recent_table *t)
 }
 
 static bool
-recent_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+recent_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_recent_mtinfo *info = par->matchinfo;
 	struct recent_table *t;
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index e81e7e2..182a272 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -117,7 +117,7 @@ match_packet(const struct sk_buff *skb,
 }
 
 static bool
-sctp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+sctp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_sctp_info *info = par->matchinfo;
 	const sctp_sctphdr_t *sh;
diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index 456e426..2dd6b72 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -88,7 +88,7 @@ extract_icmp_fields(const struct sk_buff *skb,
 
 
 static bool
-socket_match(const struct sk_buff *skb, const struct xt_action_param *par,
+socket_match(const struct sk_buff *skb, struct xt_action_param *par,
 	     const struct xt_socket_mtinfo1 *info)
 {
 	const struct iphdr *iph = ip_hdr(skb);
@@ -175,13 +175,13 @@ socket_match(const struct sk_buff *skb, const struct xt_action_param *par,
 }
 
 static bool
-socket_mt_v0(const struct sk_buff *skb, const struct xt_action_param *par)
+socket_mt_v0(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	return socket_match(skb, par, NULL);
 }
 
 static bool
-socket_mt_v1(const struct sk_buff *skb, const struct xt_action_param *par)
+socket_mt_v1(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	return socket_match(skb, par, par->matchinfo);
 }
diff --git a/net/netfilter/xt_state.c b/net/netfilter/xt_state.c
index b12c72e..fbfb7fb 100644
--- a/net/netfilter/xt_state.c
+++ b/net/netfilter/xt_state.c
@@ -21,7 +21,7 @@ MODULE_ALIAS("ipt_state");
 MODULE_ALIAS("ip6t_state");
 
 static bool
-state_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+state_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_state_info *sinfo = par->matchinfo;
 	enum ip_conntrack_info ctinfo;
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index 427cd63..c75d299 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -29,7 +29,7 @@ MODULE_ALIAS("ip6t_statistic");
 static DEFINE_SPINLOCK(nth_lock);
 
 static bool
-statistic_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+statistic_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_statistic_info *info = par->matchinfo;
 	bool ret = info->flags & XT_STATISTIC_INVERT;
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index d99d063..d896291 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -22,7 +22,7 @@ MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
 
 static bool
-string_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+string_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_string_info *conf = par->matchinfo;
 	struct ts_state state;
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 5c8a7b4..f90728f 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -25,7 +25,7 @@ MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
 
 static bool
-tcpmss_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_tcpmss_match_info *info = par->matchinfo;
 	const struct tcphdr *th;
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index af2a4e7..d04ef76 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -68,7 +68,7 @@ tcp_find_option(u_int8_t option,
 	return invert;
 }
 
-static bool tcp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool tcp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
@@ -134,7 +134,7 @@ static bool tcp_mt_check(const struct xt_mtchk_param *par)
 	return !(tcpinfo->invflags & ~XT_TCP_INV_MASK);
 }
 
-static bool udp_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool udp_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct udphdr *uh;
 	struct udphdr _udph;
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 69acfbd..744b87a 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -153,7 +153,7 @@ static void localtime_3(struct xtm *r, time_t time)
 }
 
 static bool
-time_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+time_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_time_info *info = par->matchinfo;
 	unsigned int packet_time;
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 2bbd138..218e247 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -87,7 +87,7 @@ static bool u32_match_it(const struct xt_u32 *data,
 	return true;
 }
 
-static bool u32_mt(const struct sk_buff *skb, const struct xt_action_param *par)
+static bool u32_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
 	const struct xt_u32 *data = par->matchinfo;
 	bool ret;
-- 
1.6.3.3

