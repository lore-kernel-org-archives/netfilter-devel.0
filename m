From: Ahmed Abdelsalam <amsalam20@gmail.com>
Subject: [iptables 1/2] extensions: libip6t_srh: support matching previous, next and last SID
Date: Mon, 23 Apr 2018 05:48:21 -0500
Message-ID: <1524480503-1883-1-git-send-email-amsalam20@gmail.com>
Cc: Ahmed Abdelsalam <amsalam20@gmail.com>
To: pablo@netfilter.org, fw@strlen.de, davem@davemloft.net,
        dav.lebrun@gmail.com, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch extends the libip6t_srh shared library to support matching
previous SID, next SID, and last SID.

Signed-off-by: Ahmed Abdelsalam <amsalam20@gmail.com>
---
 extensions/libip6t_srh.c                | 65 ++++++++++++++++++++++++++++++++-
 include/linux/netfilter_ipv6/ip6t_srh.h | 22 ++++++++++-
 2 files changed, 84 insertions(+), 3 deletions(-)

diff --git a/extensions/libip6t_srh.c b/extensions/libip6t_srh.c
index ac0ae08..5acc2ee 100644
--- a/extensions/libip6t_srh.c
+++ b/extensions/libip6t_srh.c
@@ -22,6 +22,9 @@ enum {
 	O_SRH_LAST_GT,
 	O_SRH_LAST_LT,
 	O_SRH_TAG,
+	O_SRH_PSID,
+	O_SRH_NSID,
+	O_SRH_LSID,
 };
 
 static void srh_help(void)
@@ -38,7 +41,10 @@ static void srh_help(void)
 "[!] --srh-last-entry-eq 	last_entry      Last Entry value of SRH\n"
 "[!] --srh-last-entry-gt 	last_entry      Last Entry value of SRH\n"
 "[!] --srh-last-entry-lt 	last_entry      Last Entry value of SRH\n"
-"[!] --srh-tag			tag             Tag value of SRH\n");
+"[!] --srh-tag			tag             Tag value of SRH\n"
+"[!] --srh-psid			addr[/mask]	SRH previous SID\n"
+"[!] --srh-nsid			addr[/mask]	SRH next SID\n"
+"[!] --srh-lsid			addr[/mask]	SRH Last SID\n");
 }
 
 #define s struct ip6t_srh
@@ -65,6 +71,12 @@ static const struct xt_option_entry srh_opts[] = {
 	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, last_entry)},
 	{ .name = "srh-tag", .id = O_SRH_TAG, .type = XTTYPE_UINT16,
 	.flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, tag)},
+	{ .name = "srh-psid", .id = O_SRH_PSID, .type = XTTYPE_HOSTMASK,
+	.flags = XTOPT_INVERT},
+	{ .name = "srh-nsid", .id = O_SRH_NSID, .type = XTTYPE_HOSTMASK,
+	.flags = XTOPT_INVERT},
+	{ .name = "srh-lsid", .id = O_SRH_LSID, .type = XTTYPE_HOSTMASK,
+	.flags = XTOPT_INVERT},
 	{ }
 };
 #undef s
@@ -75,6 +87,12 @@ static void srh_init(struct xt_entry_match *m)
 
 	srhinfo->mt_flags = 0;
 	srhinfo->mt_invflags = 0;
+	memset(srhinfo->psid_addr.s6_addr, 0, sizeof(srhinfo->psid_addr.s6_addr));
+	memset(srhinfo->nsid_addr.s6_addr, 0, sizeof(srhinfo->nsid_addr.s6_addr));
+	memset(srhinfo->lsid_addr.s6_addr, 0, sizeof(srhinfo->lsid_addr.s6_addr));
+	memset(srhinfo->psid_msk.s6_addr, 0, sizeof(srhinfo->psid_msk.s6_addr));
+	memset(srhinfo->nsid_msk.s6_addr, 0, sizeof(srhinfo->nsid_msk.s6_addr));
+	memset(srhinfo->lsid_msk.s6_addr, 0, sizeof(srhinfo->lsid_msk.s6_addr));
 }
 
 static void srh_parse(struct xt_option_call *cb)
@@ -138,6 +156,27 @@ static void srh_parse(struct xt_option_call *cb)
 		if (cb->invert)
 			srhinfo->mt_invflags |= IP6T_SRH_INV_TAG;
 		break;
+	case O_SRH_PSID:
+		srhinfo->mt_flags |= IP6T_SRH_PSID;
+		srhinfo->psid_addr = cb->val.haddr.in6;
+		srhinfo->psid_msk  = cb->val.hmask.in6;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_PSID;
+		break;
+	case O_SRH_NSID:
+		srhinfo->mt_flags |= IP6T_SRH_NSID;
+		srhinfo->nsid_addr = cb->val.haddr.in6;
+		srhinfo->nsid_msk  = cb->val.hmask.in6;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_NSID;
+		break;
+	case O_SRH_LSID:
+		srhinfo->mt_flags |= IP6T_SRH_LSID;
+		srhinfo->lsid_addr = cb->val.haddr.in6;
+		srhinfo->lsid_msk  = cb->val.hmask.in6;
+		if (cb->invert)
+			srhinfo->mt_invflags |= IP6T_SRH_INV_LSID;
+		break;
 	}
 }
 
@@ -180,6 +219,18 @@ static void srh_print(const void *ip, const struct xt_entry_match *match,
 	if (srhinfo->mt_flags & IP6T_SRH_TAG)
 		printf(" tag:%s%d", srhinfo->mt_invflags & IP6T_SRH_INV_TAG ? "!" : "",
 			srhinfo->tag);
+	if (srhinfo->mt_flags & IP6T_SRH_PSID)
+		printf(" psid %s %s/%u", srhinfo->mt_invflags & IP6T_SRH_INV_PSID ? "!" : "",
+			xtables_ip6addr_to_numeric(&srhinfo->psid_addr),
+			xtables_ip6mask_to_cidr(&srhinfo->psid_msk));
+	if (srhinfo->mt_flags & IP6T_SRH_NSID)
+		printf(" nsid %s %s/%u", srhinfo->mt_invflags & IP6T_SRH_INV_NSID ? "!" : "",
+			xtables_ip6addr_to_numeric(&srhinfo->nsid_addr),
+			xtables_ip6mask_to_cidr(&srhinfo->nsid_msk));
+	if (srhinfo->mt_flags & IP6T_SRH_LSID)
+		printf(" lsid %s %s/%u", srhinfo->mt_invflags & IP6T_SRH_INV_LSID ? "!" : "",
+			xtables_ip6addr_to_numeric(&srhinfo->lsid_addr),
+			xtables_ip6mask_to_cidr(&srhinfo->lsid_msk));
 }
 
 static void srh_save(const void *ip, const struct xt_entry_match *match)
@@ -219,6 +270,18 @@ static void srh_save(const void *ip, const struct xt_entry_match *match)
 	if (srhinfo->mt_flags & IP6T_SRH_TAG)
 		printf("%s --srh-tag %u", (srhinfo->mt_invflags & IP6T_SRH_INV_TAG) ? " !" : "",
 			srhinfo->tag);
+	if (srhinfo->mt_flags & IP6T_SRH_PSID)
+		printf("%s --srh-psid %s/%u", srhinfo->mt_invflags & IP6T_SRH_INV_PSID ? " !" : "",
+			xtables_ip6addr_to_numeric(&srhinfo->psid_addr),
+			xtables_ip6mask_to_cidr(&srhinfo->psid_msk));
+	if (srhinfo->mt_flags & IP6T_SRH_NSID)
+		printf("%s --srh-nsid %s/%u", srhinfo->mt_invflags & IP6T_SRH_INV_NSID ? " !" : "",
+			xtables_ip6addr_to_numeric(&srhinfo->nsid_addr),
+			xtables_ip6mask_to_cidr(&srhinfo->nsid_msk));
+	if (srhinfo->mt_flags & IP6T_SRH_LSID)
+		printf("%s --srh-lsid %s/%u", srhinfo->mt_invflags & IP6T_SRH_INV_LSID ? " !" : "",
+			xtables_ip6addr_to_numeric(&srhinfo->lsid_addr),
+			xtables_ip6mask_to_cidr(&srhinfo->lsid_msk));
 }
 
 static struct xtables_match srh_mt6_reg = {
diff --git a/include/linux/netfilter_ipv6/ip6t_srh.h b/include/linux/netfilter_ipv6/ip6t_srh.h
index 087efa1..3d77241 100644
--- a/include/linux/netfilter_ipv6/ip6t_srh.h
+++ b/include/linux/netfilter_ipv6/ip6t_srh.h
@@ -16,7 +16,10 @@
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
@@ -30,7 +33,10 @@
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
@@ -39,6 +45,12 @@
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
@@ -49,6 +61,12 @@ struct ip6t_srh {
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
-- 
2.1.4
