From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [nf-next] netfilter: extend SRH match to support matching previous, next and last SID
Date: Mon, 23 Apr 2018 05:48:22 -0500
Message-ID: <1524480503-1883-2-git-send-email-amsalam20@gmail.com>
References: <1524480503-1883-1-git-send-email-amsalam20@gmail.com>
Cc: Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, davem@davemloft.net,
        dav.lebrun@gmail.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524480503-1883-1-git-send-email-amsalam20@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

IPv6 Segment Routing Header (SRH) contains a list of SIDs to be crossed by
SR encapsulated packet. Each SID is encoded as an IPv6 prefix.

When a Firewall receives an SR encapsulated packet, it should be able to
identify which node previously processed the packet (previous SID), which
node is going to process the packet next (next SID), and which node is the
last to process the packet (last SID) which represent the final destination
of the packet in case of inline SR mode.

An example use-case of using these features could be SID list that includes
two firewalls. When the second firewall receives a packet, it can check
whether the packet has been processed by the first firewall or not. Based on
that check, it decides to apply all rules, apply just subset of the rules,
or totally skip all rules and forward the packet to the next SID.

This patch extends SRH match to support matching previous SID, next SID, and
last SID.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 include/uapi/linux/netfilter_ipv6/ip6t_srh.h | 22 +++++++++++++--
 net/ipv6/netfilter/ip6t_srh.c                | 41 +++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/include/uapi/linux/netfilter_ipv6/ip6t_srh.h b/include/uapi/linux/netfilter_ipv6/ip6t_srh.h
index f3cc0ef..9808382 100644
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
@@ -40,6 +46,12 @@
  *      @ segs_left: Segments left field of SRH
  *      @ last_entry: Last entry field of SRH
  *      @ tag: Tag field of SRH
+ *      @ psid_addr: Address of previous SID in SRH SID list
+ *      @ nsid_addr: Address of NEXT SID in SRH SID list
+ *      @ lsid_addr: Address of LAST SID in SRH SID list
+ *      @ psid_msk: Mask of previous SID in SRH SID list
+ *      @ nsid_msk: Mask of next SID in SRH SID list
+ *      @ lsid_msk: MAsk of last SID in SRH SID list
  *      @ mt_flags: match options
  *      @ mt_invflags: Invert the sense of match options
  */
@@ -50,6 +62,12 @@ struct ip6t_srh {
 	__u8                    segs_left;
 	__u8                    last_entry;
 	__u16                   tag;
+	struct in6_addr		psid_addr;
+	struct in6_addr		nsid_addr;
+	struct in6_addr		lsid_addr;
+	struct in6_addr		psid_msk;
+	struct in6_addr		nsid_msk;
+	struct in6_addr		lsid_msk;
 	__u16                   mt_flags;
 	__u16                   mt_invflags;
 };
diff --git a/net/ipv6/netfilter/ip6t_srh.c b/net/ipv6/netfilter/ip6t_srh.c
index 33719d5..2b5cc73 100644
--- a/net/ipv6/netfilter/ip6t_srh.c
+++ b/net/ipv6/netfilter/ip6t_srh.c
@@ -30,7 +30,9 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	const struct ip6t_srh *srhinfo = par->matchinfo;
 	struct ipv6_sr_hdr *srh;
 	struct ipv6_sr_hdr _srh;
-	int hdrlen, srhoff = 0;
+	int hdrlen, psidoff, nsidoff, lsidoff, srhoff = 0;
+	struct in6_addr *psid, *nsid, *lsid;
+	struct in6_addr _psid, _nsid, _lsid;
 
 	if (ipv6_find_hdr(skb, &srhoff, IPPROTO_ROUTING, NULL, NULL) < 0)
 		return false;
@@ -114,6 +116,43 @@ static bool srh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 		if (NF_SRH_INVF(srhinfo, IP6T_SRH_INV_TAG,
 				!(srh->tag == srhinfo->tag)))
 			return false;
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
+
 	return true;
 }
 
-- 
2.1.4
