From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 46/51] netfilter: ip6t_srh: extend SRH matching for previous, next and last SID
Date: Mon,  7 May 2018 00:47:04 +0200
Message-ID: <20180506224709.29100-47-pablo@netfilter.org>
References: <20180506224709.29100-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180506224709.29100-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Ahmed Abdelsalam <amsalam20@gmail.com>

IPv6 Segment Routing Header (SRH) contains a list of SIDs to be crossed
by SR encapsulated packet. Each SID is encoded as an IPv6 prefix.

When a Firewall receives an SR encapsulated packet, it should be able
to identify which node previously processed the packet (previous SID),
which node is going to process the packet next (next SID), and which
node is the last to process the packet (last SID) which represent the
final destination of the packet in case of inline SR mode.

An example use-case of using these features could be SID list that
includes two firewalls. When the second firewall receives a packet,
it can check whether the packet has been processed by the first firewall
or not. Based on that check, it decides to apply all rules, apply just
subset of the rules, or totally skip all rules and forward the packet to
the next SID.

This patch extends SRH match to support matching previous SID, next SID,
and last SID.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h |  43 ++++++-
 net/ipv6/netfilter/ip6t_srh.c                | 173 +++++++++++++++++++++++++--
 2 files changed, 205 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_srh.h b/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
index f3cc0ef514a7..54ed83360dac 100644
--- a/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
+++ b/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
@@ -17,7 +17,10 @@
 #define IP6T_SRH_LAST_GT        0x0100
 #define IP6T_SRH_LAST_LT        0x0200
 #define IP6T_SRH_TAG            0x0400
-#define IP6T_SRH_MASK           0x07FF
+#define IP6T_SRH_PSID           0x0800
+#define IP6T_SRH_NSID           0x1000
+#define IP6T_SRH_LSID           0x2000
+#define IP6T_SRH_MASK           0x3FFF
 
 /* Values for "mt_invflags" field in struct ip6t_srh */
 #define IP6T_SRH_INV_NEXTHDR    0x0001
@@ -31,7 +34,10 @@
 #define IP6T_SRH_INV_LAST_GT    0x0100
 #define IP6T_SRH_INV_LAST_LT    0x0200
 #define IP6T_SRH_INV_TAG        0x0400
-#define IP6T_SRH_INV_MASK       0x07FF
+#define IP6T_SRH_INV_PSID       0x0800
+#define IP6T_SRH_INV_NSID       0x1000
+#define IP6T_SRH_INV_LSID       0x2000
+#define IP6T_SRH_INV_MASK       0x3FFF
 
 /**
  *      struct ip6t_srh - SRH match options
@@ -54,4 +60,37 @@ struct ip6t_srh {
 	__u16                   mt_invflags;
 };
 
+/**
+ *      struct ip6t_srh1 - SRH match options (revision 1)
+ *      @ next_hdr: Next header field of SRH
+ *      @ hdr_len: Extension header length field of SRH
+ *      @ segs_left: Segments left field of SRH
+ *      @ last_entry: Last entry field of SRH
+ *      @ tag: Tag field of SRH
+ *      @ psid_addr: Address of previous SID in SRH SID list
+ *      @ nsid_addr: Address of NEXT SID in SRH SID list
+ *      @ lsid_addr: Address of LAST SID in SRH SID list
+ *      @ psid_msk: Mask of previous SID in SRH SID list
+ *      @ nsid_msk: Mask of next SID in SRH SID list
+ *      @ lsid_msk: MAsk of last SID in SRH SID list
+ *      @ mt_flags: match options
+ *      @ mt_invflags: Invert the sense of match options
+ */
+
+struct ip6t_srh1 {
+	__u8                    next_hdr;
+	__u8                    hdr_len;
+	__u8                    segs_left;
+	__u8                    last_entry;
+	__u16                   tag;
+	struct in6_addr         psid_addr;
+	struct in6_addr         nsid_addr;
+	struct in6_addr         lsid_addr;
+	struct in6_addr         psid_msk;
+	struct in6_addr         nsid_msk;
+	struct in6_addr         lsid_msk;
+	__u16                   mt_flags;
+	__u16                   mt_invflags;
+};
+
 #endif /*_IP6T_SRH_H*/
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index 33719d5560c8..1059894a6f4c 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -117,6 +117,130 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	return true;
 }
 
+static bool srh1_mt6(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	int hdrlen, psidoff, nsidoff, lsidoff, srhoff = 0;
+	const struct ip6t_srh1 *srhinfo = par->matchinfo;
+	struct in6_addr *psid, *nsid, *lsid;
+	struct in6_addr _psid, _nsid, _lsid;
+	struct ipv6_sr_hdr *srh;
+	struct ipv6_sr_hdr _srh;
+
+	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
+		return false;
+	srh = skb_header_pointer(skb, srhoff, sizeof(_srh), &_srh);
+	if (!srh)
+		return false;
+
+	hdrlen = ipv6_optlen(srh);
+	if (skb->len - srhoff < hdrlen)
+		return false;
+
+	if (srh->type != IPV6_SRCRT_TYPE_4)
+		return false;
+
+	if (srh->segments_left > srh->first_segment)
+		return false;
+
+	/* Next Header matching */
+	if (srhinfo->mt_flags & IP6T_SRH_NEXTHDR)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NEXTHDR,
+				!(srh->nexthdr == srhinfo->next_hdr)))
+			return false;
+
+	/* Header Extension Length matching */
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_EQ)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LEN_EQ,
+				!(srh->hdrlen == srhinfo->hdr_len)))
+			return false;
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_GT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LEN_GT,
+				!(srh->hdrlen > srhinfo->hdr_len)))
+			return false;
+	if (srhinfo->mt_flags & IP6T_SRH_LEN_LT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LEN_LT,
+				!(srh->hdrlen < srhinfo->hdr_len)))
+			return false;
+
+	/* Segments Left matching */
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_EQ)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_SEGS_EQ,
+				!(srh->segments_left == srhinfo->segs_left)))
+			return false;
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_GT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_SEGS_GT,
+				!(srh->segments_left > srhinfo->segs_left)))
+			return false;
+	if (srhinfo->mt_flags & IP6T_SRH_SEGS_LT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_SEGS_LT,
+				!(srh->segments_left < srhinfo->segs_left)))
+			return false;
+
+	/**
+	 * Last Entry matching
+	 * Last_Entry field was introduced in revision 6 of the SRH draft.
+	 * It was called First_Segment in the previous revision
+	 */
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_EQ)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LAST_EQ,
+				!(srh->first_segment == srhinfo->last_entry)))
+			return false;
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_GT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LAST_GT,
+				!(srh->first_segment > srhinfo->last_entry)))
+			return false;
+	if (srhinfo->mt_flags & IP6T_SRH_LAST_LT)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LAST_LT,
+				!(srh->first_segment < srhinfo->last_entry)))
+			return false;
+
+	/**
+	 * Tag matchig
+	 * Tag field was introduced in revision 6 of the SRH draft
+	 */
+	if (srhinfo->mt_flags & IP6T_SRH_TAG)
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_TAG,
+				!(srh->tag == srhinfo->tag)))
+			return false;
+
+	/* Previous SID matching */
+	if (srhinfo->mt_flags & IP6T_SRH_PSID) {
+		if (srh->segments_left == srh->first_segment)
+			return false;
+		psidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
+			  ((srh->segments_left + 1) * sizeof(struct in6_addr));
+		psid = skb_header_pointer(skb, psidoff, sizeof(_psid), &_psid);
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_PSID,
+				ipv6_masked_addr_cmp(psid, &srhinfo->psid_msk,
+						     &srhinfo->psid_addr)))
+			return false;
+	}
+
+	/* Next SID matching */
+	if (srhinfo->mt_flags & IP6T_SRH_NSID) {
+		if (srh->segments_left == 0)
+			return false;
+		nsidoff = srhoff + sizeof(struct ipv6_sr_hdr) +
+			  ((srh->segments_left - 1) * sizeof(struct in6_addr));
+		nsid = skb_header_pointer(skb, nsidoff, sizeof(_nsid), &_nsid);
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_NSID,
+				ipv6_masked_addr_cmp(nsid, &srhinfo->nsid_msk,
+						     &srhinfo->nsid_addr)))
+			return false;
+	}
+
+	/* Last SID matching */
+	if (srhinfo->mt_flags & IP6T_SRH_LSID) {
+		lsidoff = srhoff + sizeof(struct ipv6_sr_hdr);
+		lsid = skb_header_pointer(skb, lsidoff, sizeof(_lsid), &_lsid);
+		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_LSID,
+				ipv6_masked_addr_cmp(lsid, &srhinfo->lsid_msk,
+						     &srhinfo->lsid_addr)))
+			return false;
+	}
+	return true;
+}
+
 static int srh_mt6_check(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_srh *srhinfo = par->matchinfo;
@@ -136,23 +260,54 @@ static int srh_mt6_check(const struct xt_mtchk_param *par)
 	return 0;
 }
 
-static struct xt_match srh_mt6_reg __read_mostly = {
-	.name		= "srh",
-	.family		= NFPROTO_IPV6,
-	.match		= srh_mt6,
-	.matchsize	= sizeof(struct ip6t_srh),
-	.checkentry	= srh_mt6_check,
-	.me		= THIS_MODULE,
+static int srh1_mt6_check(const struct xt_mtchk_param *par)
+{
+	const struct ip6t_srh1 *srhinfo = par->matchinfo;
+
+	if (srhinfo->mt_flags & ~IP6T_SRH_MASK) {
+		pr_info_ratelimited("unknown srh match flags  %X\n",
+				    srhinfo->mt_flags);
+		return -EINVAL;
+	}
+
+	if (srhinfo->mt_invflags & ~IP6T_SRH_INV_MASK) {
+		pr_info_ratelimited("unknown srh invflags %X\n",
+				    srhinfo->mt_invflags);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct xt_match srh_mt6_reg[] __read_mostly = {
+	{
+		.name		= "srh",
+		.revision	= 0,
+		.family		= NFPROTO_IPV6,
+		.match		= srh_mt6,
+		.matchsize	= sizeof(struct ip6t_srh),
+		.checkentry	= srh_mt6_check,
+		.me		= THIS_MODULE,
+	},
+	{
+		.name           = "srh",
+		.revision       = 1,
+		.family         = NFPROTO_IPV6,
+		.match          = srh1_mt6,
+		.matchsize      = sizeof(struct ip6t_srh1),
+		.checkentry     = srh1_mt6_check,
+		.me             = THIS_MODULE,
+	}
 };
 
 static int __init srh_mt6_init(void)
 {
-	return xt_register_match(&srh_mt6_reg);
+	return xt_register_matches(srh_mt6_reg, ARRAY_SIZE(srh_mt6_reg));
 }
 
 static void __exit srh_mt6_exit(void)
 {
-	xt_unregister_match(&srh_mt6_reg);
+	xt_unregister_matches(srh_mt6_reg, ARRAY_SIZE(srh_mt6_reg));
 }
 
 module_init(srh_mt6_init);
-- 
2.11.0
