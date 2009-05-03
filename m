From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/9] extensions: switch invert to bool
Date: Sun,  3 May 2009 21:54:30 +0200
Message-ID: <1241380473-22262-7-git-send-email-jengelh@medozas.de>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34573 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754450AbZECTyh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 May 2009 15:54:37 -0400
In-Reply-To: <1241380473-22262-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c         |    2 +-
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    7 +++----
 extensions/libip6t_dst.c        |    2 +-
 extensions/libip6t_eui64.c      |    3 ++-
 extensions/libip6t_frag.c       |    5 ++---
 extensions/libip6t_hbh.c        |    2 +-
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    4 ++--
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    4 ++--
 extensions/libip6t_policy.c     |    2 +-
 extensions/libip6t_rt.c         |    5 ++---
 extensions/libipt_CLUSTERIP.c   |    5 +++--
 extensions/libipt_DNAT.c        |    2 +-
 extensions/libipt_ECN.c         |    2 +-
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_MASQUERADE.c  |    5 +++--
 extensions/libipt_MIRROR.c      |    3 ++-
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |    2 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    2 +-
 extensions/libipt_SET.c         |    4 ++--
 extensions/libipt_SNAT.c        |    2 +-
 extensions/libipt_TTL.c         |    2 +-
 extensions/libipt_ULOG.c        |    2 +-
 extensions/libipt_addrtype.c    |    4 ++--
 extensions/libipt_ah.c          |    5 ++---
 extensions/libipt_ecn.c         |    2 +-
 extensions/libipt_icmp.c        |    4 ++--
 extensions/libipt_policy.c      |    2 +-
 extensions/libipt_realm.c       |    4 ++--
 extensions/libipt_set.c         |    2 +-
 extensions/libipt_ttl.c         |    2 +-
 extensions/libipt_unclean.c     |    3 ++-
 extensions/libxt_CLASSIFY.c     |    2 +-
 extensions/libxt_CONNMARK.c     |    4 ++--
 extensions/libxt_CONNSECMARK.c  |    2 +-
 extensions/libxt_DSCP.c         |    2 +-
 extensions/libxt_MARK.c         |    6 +++---
 extensions/libxt_NFLOG.c        |    2 +-
 extensions/libxt_NFQUEUE.c      |    2 +-
 extensions/libxt_NOTRACK.c      |    3 ++-
 extensions/libxt_RATEEST.c      |    2 +-
 extensions/libxt_SECMARK.c      |    2 +-
 extensions/libxt_TCPMSS.c       |    6 +++---
 extensions/libxt_TCPOPTSTRIP.c  |    2 +-
 extensions/libxt_TOS.c          |    7 ++++---
 extensions/libxt_TPROXY.c       |    5 +++--
 extensions/libxt_TRACE.c        |    3 ++-
 extensions/libxt_comment.c      |    2 +-
 extensions/libxt_connbytes.c    |    2 +-
 extensions/libxt_connlimit.c    |    9 +++++----
 extensions/libxt_connmark.c     |    6 +++---
 extensions/libxt_conntrack.c    |   13 +++++++------
 extensions/libxt_dccp.c         |    8 ++++----
 extensions/libxt_dscp.c         |    6 +++---
 extensions/libxt_esp.c          |    5 ++---
 extensions/libxt_hashlimit.c    |    8 ++++----
 extensions/libxt_helper.c       |    4 ++--
 extensions/libxt_iprange.c      |    6 +++---
 extensions/libxt_length.c       |    4 ++--
 extensions/libxt_limit.c        |    2 +-
 extensions/libxt_mac.c          |    4 ++--
 extensions/libxt_mark.c         |    6 +++---
 extensions/libxt_multiport.c    |   14 +++++++-------
 extensions/libxt_owner.c        |    6 +++---
 extensions/libxt_physdev.c      |    2 +-
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_quota.c        |    2 +-
 extensions/libxt_rateest.c      |    2 +-
 extensions/libxt_recent.c       |   14 +++++++++-----
 extensions/libxt_sctp.c         |    4 ++--
 extensions/libxt_socket.c       |    6 ++++--
 extensions/libxt_standard.c     |    3 ++-
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_statistic.c    |    2 +-
 extensions/libxt_string.c       |   10 +++++-----
 extensions/libxt_tcp.c          |   10 +++++-----
 extensions/libxt_tcpmss.c       |    4 ++--
 extensions/libxt_time.c         |    2 +-
 extensions/libxt_tos.c          |    7 ++++---
 extensions/libxt_u32.c          |    2 +-
 extensions/libxt_udp.c          |    4 ++--
 include/xtables.h.in            |    6 +++---
 ip6tables.c                     |   13 +++++++------
 iptables.c                      |   12 ++++++------
 xtables.c                       |    2 +-
 90 files changed, 195 insertions(+), 180 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 1cf5358..47f8e4e 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -25,7 +25,7 @@ static void HL_help(void)
 "  --hl-inc value		Increment HL by <value 1-255>\n");
 }
 
-static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
+static int HL_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_HL_info *info = (struct ip6t_HL_info *) (*target)->data;
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index a616694..a163487 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -101,7 +101,7 @@ parse_level(const char *level)
 #define IP6T_LOG_OPT_IPOPT 0x10
 #define IP6T_LOG_OPT_UID 0x20
 
-static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
+static int LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)(*target)->data;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 846e61e..c3077d4 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -75,7 +75,7 @@ static void REJECT_init(struct xt_entry_target *t)
 
 }
 
-static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
+static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	struct ip6t_reject_info *reject = 
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index cc3e5cb..c7d0763 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -77,7 +77,7 @@ static void ah_init(struct xt_entry_match *m)
 	ahinfo->hdrres = 0;
 }
 
-static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
+static int ah_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)(*match)->data;
@@ -118,8 +118,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
-	    int invert)
+print_spis(const char *name, u_int32_t min, u_int32_t max, bool invert)
 {
 	const char *inv = invert ? "!" : "";
 
@@ -132,7 +131,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
 }
 
 static void
-print_len(const char *name, u_int32_t len, int invert)
+print_len(const char *name, u_int32_t len, bool invert)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index b907225..6c54507 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -116,7 +116,7 @@ static void dst_init(struct xt_entry_match *m)
 	optinfo->optsnr = 0;
 }
 
-static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
+static int dst_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index c92c868..715a176 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add EUI64 address checking support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -19,7 +20,7 @@ static void eui64_help(void)
 " This module checks for EUI64 IPv6 addresses\n");
 }
 
-static int eui64_parse(int c, char **argv, int invert, unsigned int *flags,
+static int eui64_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_match **match)
 {
 	return 0;
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 946b8e2..d3be868 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -85,7 +85,7 @@ static void frag_init(struct xt_entry_match *m)
 	fraginfo->invflags = 0;
 }
 
-static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
+static int frag_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)(*match)->data;
@@ -149,8 +149,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_ids(const char *name, u_int32_t min, u_int32_t max,
-	    int invert)
+print_ids(const char *name, u_int32_t min, u_int32_t max, bool invert)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 18f60b2..29e4a23 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -111,7 +111,7 @@ static void hbh_init(struct xt_entry_match *m)
 	optinfo->optsnr = 0;
 }
 
-static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
+static int hbh_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 117bfb8..76d7760 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -24,7 +24,7 @@ static void hl_help(void)
 "  --hl-gt value	Match HL > value\n");
 }
 
-static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
+static int hl_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 7ef63e2..68fe2fa 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -149,7 +149,7 @@ static void icmp6_init(struct xt_entry_match *m)
 	icmpv6info->code[1] = 0xFF;
 }
 
-static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
+static int icmp6_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
@@ -176,7 +176,7 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void print_icmpv6type(u_int8_t type,
 			   u_int8_t code_min, u_int8_t code_max,
-			   int invert,
+			   bool invert,
 			   bool numeric)
 {
 	if (!numeric) {
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 8be284d..fd03d65 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -180,7 +180,7 @@ parse_header(const char *flags) {
 #define IPV6_HDR_SOFT	0x02
 
 static int
-ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
+ipv6header_parse(int c, char **argv, bool invert, unsigned int *flags,
                  const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)(*match)->data;
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index d63110a..69e3150 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -124,7 +124,7 @@ static void parse_mh_types(const char *mhtype, u_int8_t *types)
 
 #define MH_TYPES 0x01
 
-static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
+static int mh_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
@@ -169,7 +169,7 @@ static void print_type(u_int8_t type, bool numeric)
 		printf("%s", name);
 }
 
-static void print_types(u_int8_t min, u_int8_t max, int invert, bool numeric)
+static void print_types(u_int8_t min, u_int8_t max, bool invert, bool numeric)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 3efffe0..9a85f98 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -151,7 +151,7 @@ static int parse_mode(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
-static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
+static int policy_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_policy_info *info = (void *)(*match)->data;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index a242ea2..e560661 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -149,7 +149,7 @@ static void rt_init(struct xt_entry_match *m)
 	rtinfo->addrnr = 0;
 }
 
-static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
+static int rt_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)(*match)->data;
@@ -231,8 +231,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_nums(const char *name, u_int32_t min, u_int32_t max,
-	    int invert)
+print_nums(const char *name, u_int32_t min, u_int32_t max, bool invert)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 874e0bb..f6bc373 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -75,8 +75,9 @@ parse_mac(const char *mac, char *macbuf)
 	}
 }
 
-static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_target **target)
+static int
+CLUSTERIP_parse(int c, char **argv, bool invert, unsigned int *flags,
+                const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_clusterip_tgt_info *cipinfo
 		= (struct ipt_clusterip_tgt_info *)(*target)->data;
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index aad4f61..026c0ef 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -137,7 +137,7 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 	return &(append_range(info, &range)->t);
 }
 
-static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
+static int DNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 52ccd0f..38b70dd 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -40,7 +40,7 @@ static const struct option ECN_opts[] = {
 	{ .name = NULL }
 };
 
-static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
+static int ECN_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	unsigned int result;
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 07c7e5e..047201f 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -101,7 +101,7 @@ parse_level(const char *level)
 #define IPT_LOG_OPT_IPOPT 0x10
 #define IPT_LOG_OPT_UID 0x20
 
-static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
+static int LOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)(*target)->data;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index d7e2c8c..f0d4c40 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -69,8 +69,9 @@ parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 	}
 }
 
-static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
-                            const void *e, struct xt_entry_target **target)
+static int
+MASQUERADE_parse(int c, char **argv, bool invert, unsigned int *flags,
+                 const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
 	int portok;
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 81964dd..8c62721 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add MIRROR target support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -11,7 +12,7 @@ static void MIRROR_help(void)
 	printf("MIRROR target takes no options\n");
 }
 
-static int MIRROR_parse(int c, char **argv, int invert, unsigned int *flags,
+static int MIRROR_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 5974bf5..e65d434 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -110,7 +110,7 @@ parse_to(char *arg, struct nf_nat_range *range)
 	range->max_ip = range->min_ip | ~netmask;
 }
 
-static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
+static int NETMAP_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	struct nf_nat_multi_range *mr
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index a857de3..09053df 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -76,7 +76,7 @@ parse_ports(const char *arg, struct nf_nat_multi_range *mr)
 	}
 }
 
-static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
+static int REDIRECT_parse(int c, char **argv, bool invert, unsigned int *flags,
                           const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index e8737e5..75bc5fc 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -90,7 +90,7 @@ static void REJECT_init(struct xt_entry_target *t)
 
 }
 
-static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
+static int REJECT_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)(*target)->data;
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 3c361b8..266bce0 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -79,7 +79,7 @@ parse_to(char *arg, struct nf_nat_range *range)
 #define IPT_SAME_OPT_NODST		0x02
 #define IPT_SAME_OPT_RANDOM		0x04
 
-static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
+static int SAME_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_same_info *mr
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 7cd7882..0ce09c9 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -50,7 +50,7 @@ static void SET_init(struct xt_entry_target *target)
 }
 
 static void
-parse_target(char **argv, int invert, unsigned int *flags,
+parse_target(char **argv, bool invert, unsigned int *flags,
              struct ipt_set_info *info, const char *what)
 {
 	if (info->flags[0])
@@ -78,7 +78,7 @@ parse_target(char **argv, int invert, unsigned int *flags,
 	*flags = 1;
 }
 
-static int SET_parse(int c, char **argv, int invert, unsigned int *flags,
+static int SET_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_set_info_target *myinfo =
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 1d5caa4..1367494 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -137,7 +137,7 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 	return &(append_range(info, &range)->t);
 }
 
-static int SNAT_parse(int c, char **argv, int invert, unsigned int *flags,
+static int SNAT_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *e, struct xt_entry_target **target)
 {
 	const struct ipt_entry *entry = e;
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index f0bfeab..c25cb44 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -25,7 +25,7 @@ static void TTL_help(void)
 "  --ttl-inc value		Increment TTL by <value 1-255>\n");
 }
 
-static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
+static int TTL_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_TTL_info *info = (struct ipt_TTL_info *) (*target)->data;
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 333ac88..78f5d0a 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -64,7 +64,7 @@ static void ULOG_init(struct xt_entry_target *t)
 #define IPT_LOG_OPT_CPRANGE 0x04
 #define IPT_LOG_OPT_QTHRESHOLD 0x08
 
-static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
+static int ULOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_ulog_info *loginfo =
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index dca3a0e..1d72119 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -96,7 +96,7 @@ static void parse_types(const char *arg, u_int16_t *mask)
 #define IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT	0x8
 
 static int
-addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+addrtype_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_addrtype_info *info =
@@ -131,7 +131,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+addrtype_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_addrtype_info_v1 *info =
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 62a5b80..089220e 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -73,7 +73,7 @@ static void ah_init(struct xt_entry_match *m)
 
 #define AH_SPI 0x01
 
-static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
+static int ah_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)(*match)->data;
@@ -97,8 +97,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
-	    int invert)
+print_spis(const char *name, u_int32_t min, u_int32_t max, bool invert)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index ddbaeab..6fbf601 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -32,7 +32,7 @@ static const struct option ecn_opts[] = {
 	{ .name = NULL }
 };
 
-static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
+static int ecn_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	unsigned int result;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 6524fc9..a5b6517 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -174,7 +174,7 @@ static void icmp_init(struct xt_entry_match *m)
 	icmpinfo->code[1] = 0xFF;
 }
 
-static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
+static int icmp_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)(*match)->data;
@@ -201,7 +201,7 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void print_icmptype(u_int8_t type,
 			   u_int8_t code_min, u_int8_t code_max,
-			   int invert,
+			   bool invert,
 			   bool numeric)
 {
 	if (!numeric) {
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index ae416ba..fcd2564 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -119,7 +119,7 @@ static int parse_mode(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
-static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
+static int policy_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_policy_info *info = (void *)(*match)->data;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 279476e..05626dc 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -149,7 +149,7 @@ static const char *realm_id2name(int id)
 	return NULL;
 }
 
-static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
+static int realm_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_realm_info *realminfo = (struct ipt_realm_info *)(*match)->data;
@@ -178,7 +178,7 @@ static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
 			realminfo->mask = 0xffffffff;
 		}
 		if (invert)
-			realminfo->invert = 1;
+			realminfo->invert = true;
 		*flags = 1;
 		break;
 
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 8a3da13..c3ffc70 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -46,7 +46,7 @@ static void set_init(struct xt_entry_match *match)
 
 }
 
-static int set_parse(int c, char **argv, int invert, unsigned int *flags,
+static int set_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 860acf2..21cbf0d 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -23,7 +23,7 @@ static void ttl_help(void)
 "  --ttl-gt value	Match TTL > value\n");
 }
 
-static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
+static int ttl_parse(int c, char **argv, bool invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 93d9013..96c58bb 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables for unclean. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <getopt.h>
@@ -9,7 +10,7 @@ static void unclean_help(void)
 	printf("unclean match takes no options\n");
 }
 
-static int unclean_parse(int c, char **argv, int invert, unsigned int *flags,
+static int unclean_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	return 0;
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 8708c23..c5d37f9 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -36,7 +36,7 @@ static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
 }
 
 static int
-CLASSIFY_parse(int c, char **argv, int invert, unsigned int *flags,
+CLASSIFY_parse(int c, char **argv, bool invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_target **target)
 {
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index b39244d..2905fea 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -96,7 +96,7 @@ static void connmark_tg_init(struct xt_entry_target *target)
 }
 
 static int
-CONNMARK_parse(int c, char **argv, int invert, unsigned int *flags,
+CONNMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
                const void *entry, struct xt_entry_target **target)
 {
 	struct xt_connmark_target_info *markinfo
@@ -148,7 +148,7 @@ CONNMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static int connmark_tg_parse(int c, char **argv, int invert,
+static int connmark_tg_parse(int c, char **argv, bool invert,
                              unsigned int *flags, const void *entry,
                              struct xt_entry_target **target)
 {
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index c01b587..c32d03c 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -30,7 +30,7 @@ static const struct option CONNSECMARK_opts[] = {
 };
 
 static int
-CONNSECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
+CONNSECMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_target **target)
 {
 	struct xt_connsecmark_target_info *info =
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 22fd476..7af4166 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -71,7 +71,7 @@ parse_class(const char *s, struct xt_DSCP_info *dinfo)
 }
 
 
-static int DSCP_parse(int c, char **argv, int invert, unsigned int *flags,
+static int DSCP_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_target **target)
 {
 	struct xt_DSCP_info *dinfo
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index d8d83ed..64292ed 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -53,7 +53,7 @@ static void mark_tg_help(void)
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-MARK_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+MARK_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
 	struct xt_mark_target_info *markinfo
@@ -92,7 +92,7 @@ static void MARK_check(unsigned int flags)
 }
 
 static int
-MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+MARK_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
 	struct xt_mark_target_info_v1 *markinfo
@@ -124,7 +124,7 @@ MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
+static int mark_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	struct xt_mark_tginfo2 *info = (void *)(*target)->data;
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index a214631..023cfda 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -40,7 +40,7 @@ static void NFLOG_init(struct xt_entry_target *t)
 	info->threshold	= XT_NFLOG_DEFAULT_THRESHOLD;
 }
 
-static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
+static int NFLOG_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_target **target)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)(*target)->data;
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index c4cd335..9dcdd42 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -42,7 +42,7 @@ parse_num(const char *s, struct xt_NFQ_info *tinfo)
 }
 
 static int
-NFQUEUE_parse(int c, char **argv, int invert, unsigned int *flags,
+NFQUEUE_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
 	struct xt_NFQ_info *tinfo
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index ef26654..0621d15 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add NOTRACK target support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -13,7 +14,7 @@ static void NOTRACK_help(void)
 }
 
 static int
-NOTRACK_parse(int c, char **argv, int invert, unsigned int *flags,
+NOTRACK_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index da0963a..d5d391d 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -90,7 +90,7 @@ RATEEST_init(struct xt_entry_target *target)
 }
 
 static int
-RATEEST_parse(int c, char **argv, int invert, unsigned int *flags,
+RATEEST_parse(int c, char **argv, bool invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_target **target)
 {
 	struct xt_rateest_target_info *info = (void *)(*target)->data;
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 977321a..82752e8 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -27,7 +27,7 @@ static const struct option SECMARK_opts[] = {
 	{ .name = NULL }
 };
 
-static int SECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
+static int SECMARK_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	struct xt_secmark_target_info *info =
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index cff1dc1..54ae373 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -42,7 +42,7 @@ static const struct option TCPMSS_opts[] = {
 	{ .name = NULL }
 };
 
-static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
+static int __TCPMSS_parse(int c, char **argv, bool invert, unsigned int *flags,
                           const void *entry, struct xt_entry_target **target,
                           int hdrsize)
 {
@@ -79,13 +79,13 @@ static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static int TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
+static int TCPMSS_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_target **target)
 {
 	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 40);
 }
 
-static int TCPMSS_parse6(int c, char **argv, int invert, unsigned int *flags,
+static int TCPMSS_parse6(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	return __TCPMSS_parse(c, argv, invert, flags, entry, target, 60);
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index aa36a55..1c361e1 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -102,7 +102,7 @@ static void parse_list(struct xt_tcpoptstrip_target_info *info, char *arg)
 	}
 }
 
-static int tcpoptstrip_tg_parse(int c, char **argv, int invert,
+static int tcpoptstrip_tg_parse(int c, char **argv, bool invert,
                                 unsigned int *flags, const void *entry,
                                 struct xt_entry_target **target)
 {
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index b809f92..a12e3fc 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -75,8 +75,9 @@ XTABLES_VERSION);
 );
 }
 
-static int tos_tg_parse_v0(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_target **target)
+static int
+tos_tg_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
+                const void *entry, struct xt_entry_target **target)
 {
 	struct ipt_tos_target_info *info = (void *)(*target)->data;
 	struct tos_value_mask tvm;
@@ -99,7 +100,7 @@ static int tos_tg_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	return false;
 }
 
-static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
+static int tos_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	struct xt_tos_target_info *info = (void *)(*target)->data;
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 392833e..bf5b145 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -73,8 +73,9 @@ static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
 	info->mark_value = value;
 }
 
-static int tproxy_tg_parse(int c, char **argv, int invert, unsigned int *flags,
-			const void *entry, struct xt_entry_target **target)
+static int
+tproxy_tg_parse(int c, char **argv, bool invert, unsigned int *flags,
+                const void *entry, struct xt_entry_target **target)
 {
 	struct xt_tproxy_target_info *tproxyinfo = (void *)(*target)->data;
 
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index b8eb969..1361356 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add TRACE target support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -12,7 +13,7 @@ static void TRACE_help(void)
 	printf("TRACE target takes no options\n");
 }
 
-static int TRACE_parse(int c, char **argv, int invert, unsigned int *flags,
+static int TRACE_parse(int c, char **argv, bool invert, unsigned int *flags,
                        const void *entry, struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index c9ad07b..ff38f64 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -40,7 +40,7 @@ parse_comment(const char *s, struct xt_comment_info *info)
 }
 
 static int
-comment_parse(int c, char **argv, int invert, unsigned int *flags,
+comment_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_match **match)
 {
 	struct xt_comment_info *commentinfo = (struct xt_comment_info *)(*match)->data;
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index b34ef88..4fdf21c 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -45,7 +45,7 @@ parse_range(const char *arg, struct xt_connbytes_info *si)
 }
 
 static int
-connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
+connbytes_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
 	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)(*match)->data;
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index abb0d5d..15bd317 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -52,8 +52,9 @@ static void prefix_to_netmask(u_int32_t *mask, unsigned int prefix_len)
 	mask[3] = htonl(mask[3]);
 }
 
-static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
-                           struct xt_connlimit_info *info, unsigned int family)
+static int
+connlimit_parse(int c, char **argv, bool invert, unsigned int *flags,
+                struct xt_connlimit_info *info, unsigned int family)
 {
 	char *err;
 	int i;
@@ -99,7 +100,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static int connlimit_parse4(int c, char **argv, int invert,
+static int connlimit_parse4(int c, char **argv, bool invert,
                             unsigned int *flags, const void *entry,
                             struct xt_entry_match **match)
 {
@@ -107,7 +108,7 @@ static int connlimit_parse4(int c, char **argv, int invert,
 	       (void *)(*match)->data, NFPROTO_IPV4);
 }
 
-static int connlimit_parse6(int c, char **argv, int invert,
+static int connlimit_parse6(int c, char **argv, bool invert,
                             unsigned int *flags, const void *entry,
                             struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 9fe64a8..17fe03b 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -46,7 +46,7 @@ static const struct option connmark_mt_opts[] = {
 };
 
 static int
-connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+connmark_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct xt_connmark_mtinfo1 *info = (void *)(*match)->data;
@@ -75,7 +75,7 @@ connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-connmark_parse(int c, char **argv, int invert, unsigned int *flags,
+connmark_parse(int c, char **argv, bool invert, unsigned int *flags,
                const void *entry, struct xt_entry_match **match)
 {
 	struct xt_connmark_info *markinfo = (struct xt_connmark_info *)(*match)->data;
@@ -94,7 +94,7 @@ connmark_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*end != '\0' || end == optarg)
 			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
 		if (invert)
-			markinfo->invert = 1;
+			markinfo->invert = true;
 		*flags = 1;
 		break;
 
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 56451fa..2ed6e9a 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -286,8 +286,9 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
 	info->expires_max = max;
 }
 
-static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_match **match)
+static int
+conntrack_parse(int c, char **argv, bool invert, unsigned int *flags,
+                const void *entry, struct xt_entry_match **match)
 {
 	struct xt_conntrack_info *sinfo = (void *)(*match)->data;
 	char *protocol = NULL;
@@ -437,7 +438,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+conntrack_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                    struct xt_entry_match **match)
 {
 	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
@@ -543,7 +544,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+conntrack_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
@@ -613,7 +614,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+conntrack_mt6_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct xt_conntrack_mtinfo1 *info = (void *)(*match)->data;
@@ -779,7 +780,7 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 }
 
 static void
-print_addr(struct in_addr *addr, struct in_addr *mask, int inv, bool numeric)
+print_addr(struct in_addr *addr, struct in_addr *mask, bool inv, bool numeric)
 {
 	char buf[BUFSIZ];
 
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index b45405c..12180d4 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -130,7 +130,7 @@ static u_int8_t parse_dccp_option(char *optstring)
 }
 
 static int
-dccp_parse(int c, char **argv, int invert, unsigned int *flags,
+dccp_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
 	struct xt_dccp_info *einfo
@@ -214,7 +214,7 @@ print_port(u_int16_t port, bool numeric)
 
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, bool numeric)
+	    bool invert, bool numeric)
 {
 	const char *inv = invert ? "!" : "";
 
@@ -234,7 +234,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
 }
 
 static void
-print_types(u_int16_t types, int inverted, bool numeric)
+print_types(u_int16_t types, bool inverted, bool numeric)
 {
 	int have_type = 0;
 
@@ -261,7 +261,7 @@ print_types(u_int16_t types, int inverted, bool numeric)
 }
 
 static void
-print_option(u_int8_t option, int invert, bool numeric)
+print_option(u_int8_t option, bool invert, bool numeric)
 {
 	if (option || invert)
 		printf("option=%s%u ", invert ? "!" : "", option);
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 866c5e9..64ceedb 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -72,7 +72,7 @@ parse_class(const char *s, struct xt_dscp_info *dinfo)
 
 
 static int
-dscp_parse(int c, char **argv, int invert, unsigned int *flags,
+dscp_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
 	struct xt_dscp_info *dinfo
@@ -86,7 +86,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_dscp(argv[optind-1], dinfo);
 		if (invert)
-			dinfo->invert = 1;
+			dinfo->invert = true;
 		*flags = 1;
 		break;
 
@@ -97,7 +97,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_class(argv[optind - 1], dinfo);
 		if (invert)
-			dinfo->invert = 1;
+			dinfo->invert = true;
 		*flags = 1;
 		break;
 
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index fbce617..1cb906f 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -79,7 +79,7 @@ static void esp_init(struct xt_entry_match *m)
 #define ESP_SPI 0x01
 
 static int
-esp_parse(int c, char **argv, int invert, unsigned int *flags,
+esp_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_esp *espinfo = (struct xt_esp *)(*match)->data;
@@ -103,8 +103,7 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
-	    int invert)
+print_spis(const char *name, u_int32_t min, u_int32_t max, bool invert)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 3de0ff1..4d7f74b 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -208,7 +208,7 @@ enum {
 };
 
 static int
-hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
+hashlimit_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
 	struct xt_hashlimit_info *r = 
@@ -311,7 +311,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static int
 hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
-                   int c, int invert, unsigned int maxmask)
+                   int c, bool invert, unsigned int maxmask)
 {
 	unsigned int num;
 
@@ -434,7 +434,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 }
 
 static int
-hashlimit_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+hashlimit_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	return hashlimit_mt_parse((void *)(*match)->data,
@@ -442,7 +442,7 @@ hashlimit_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-hashlimit_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+hashlimit_mt6_parse(int c, char **argv, bool invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	return hashlimit_mt_parse((void *)(*match)->data,
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 2dda021..f29dd85 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -22,7 +22,7 @@ static const struct option helper_opts[] = {
 };
 
 static int
-helper_parse(int c, char **argv, int invert, unsigned int *flags,
+helper_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
 	struct xt_helper_info *info = (struct xt_helper_info *)(*match)->data;
@@ -36,7 +36,7 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 		strncpy(info->name, optarg, 29);
 		info->name[29] = '\0';
 		if (invert)
-			info->invert = 1;
+			info->invert = true;
 		*flags = 1;
 		break;
 
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index c89e022..33c0cb1 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -58,7 +58,7 @@ parse_iprange(char *arg, struct ipt_iprange *range)
 	}
 }
 
-static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
+static int iprange_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
@@ -100,7 +100,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+iprange_mt4_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
@@ -150,7 +150,7 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+iprange_mt6_parse(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 53d8089..7ee0e65 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -60,7 +60,7 @@ parse_lengths(const char *s, struct xt_length_info *info)
 }
 
 static int
-length_parse(int c, char **argv, int invert, unsigned int *flags,
+length_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
 	struct xt_length_info *info = (struct xt_length_info *)(*match)->data;
@@ -74,7 +74,7 @@ length_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_check_inverse(optarg, &invert, &optind, 0);
 			parse_lengths(argv[optind-1], info);
 			if (invert)
-				info->invert = 1;
+				info->invert = true;
 			*flags = 1;
 			break;
 			
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 6f86a4f..c96c39a 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -87,7 +87,7 @@ static void limit_init(struct xt_entry_match *m)
 */
 
 static int
-limit_parse(int c, char **argv, int invert, unsigned int *flags,
+limit_parse(int c, char **argv, bool invert, unsigned int *flags,
             const void *entry, struct xt_entry_match **match)
 {
 	struct xt_rateinfo *r = (struct xt_rateinfo *)(*match)->data;
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index bc1066c..27388af 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -51,7 +51,7 @@ parse_mac(const char *mac, struct xt_mac_info *info)
 }
 
 static int
-mac_parse(int c, char **argv, int invert, unsigned int *flags,
+mac_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_mac_info *macinfo = (struct xt_mac_info *)(*match)->data;
@@ -61,7 +61,7 @@ mac_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_mac(argv[optind-1], macinfo);
 		if (invert)
-			macinfo->invert = 1;
+			macinfo->invert = true;
 		*flags = 1;
 		break;
 
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 834edc4..481e341 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -25,7 +25,7 @@ static const struct option mark_mt_opts[] = {
 	{ .name = NULL }
 };
 
-static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+static int mark_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_mark_mtinfo1 *info = (void *)(*match)->data;
@@ -54,7 +54,7 @@ static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-mark_parse(int c, char **argv, int invert, unsigned int *flags,
+mark_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
 	struct xt_mark_info *markinfo = (struct xt_mark_info *)(*match)->data;
@@ -71,7 +71,7 @@ mark_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*end != '\0' || end == optarg)
 			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
 		if (invert)
-			markinfo->invert = 1;
+			markinfo->invert = true;
 		*flags = 1;
 		break;
 
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 2d36ab0..ce14d2f 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -155,7 +155,7 @@ check_proto(u_int16_t pnum, u_int8_t invflags)
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-__multiport_parse(int c, char **argv, int invert, unsigned int *flags,
+__multiport_parse(int c, char **argv, bool invert, unsigned int *flags,
                   struct xt_entry_match **match, u_int16_t pnum,
                   u_int8_t invflags)
 {
@@ -204,7 +204,7 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-multiport_parse(int c, char **argv, int invert, unsigned int *flags,
+multiport_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *e, struct xt_entry_match **match)
 {
 	const struct ipt_entry *entry = e;
@@ -213,7 +213,7 @@ multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-multiport_parse6(int c, char **argv, int invert, unsigned int *flags,
+multiport_parse6(int c, char **argv, bool invert, unsigned int *flags,
                  const void *e, struct xt_entry_match **match)
 {
 	const struct ip6t_entry *entry = e;
@@ -222,7 +222,7 @@ multiport_parse6(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-__multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+__multiport_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
                      struct xt_entry_match **match, u_int16_t pnum,
                      u_int8_t invflags)
 {
@@ -257,7 +257,7 @@ __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	}
 
 	if (invert)
-		multiinfo->invert = 1;
+		multiinfo->invert = true;
 
 	if (*flags)
 		xtables_error(PARAMETER_PROBLEM,
@@ -267,7 +267,7 @@ __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
+multiport_parse_v1(int c, char **argv, bool invert, unsigned int *flags,
                    const void *e, struct xt_entry_match **match)
 {
 	const struct ipt_entry *entry = e;
@@ -276,7 +276,7 @@ multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-multiport_parse6_v1(int c, char **argv, int invert, unsigned int *flags,
+multiport_parse6_v1(int c, char **argv, bool invert, unsigned int *flags,
                     const void *e, struct xt_entry_match **match)
 {
 	const struct ip6t_entry *entry = e;
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 5e7c581..ba9b17f 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -102,7 +102,7 @@ static const struct option owner_mt_opts[] = {
 };
 
 static int
-owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+owner_mt_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_owner_info *info = (void *)(*match)->data;
@@ -181,7 +181,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
+owner_mt6_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
                    const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_owner_info *info = (void *)(*match)->data;
@@ -261,7 +261,7 @@ static void owner_parse_range(const char *s, unsigned int *from,
 		xtables_param_act(XTF_BAD_VALUE, "owner", opt, s);
 }
 
-static int owner_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+static int owner_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_owner_match_info *info = (void *)(*match)->data;
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 9e477f1..e181633 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -34,7 +34,7 @@ static const struct option physdev_opts[] = {
 };
 
 static int
-physdev_parse(int c, char **argv, int invert, unsigned int *flags,
+physdev_parse(int c, char **argv, bool invert, unsigned int *flags,
               const void *entry, struct xt_entry_match **match)
 {
 	struct xt_physdev_info *info =
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index e2dca1a..9a7b53b 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -84,7 +84,7 @@ static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
 	xtables_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
 }
 
-static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
+static int pkttype_parse(int c, char **argv, bool invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_pkttype_info *info = (struct xt_pkttype_info *)(*match)->data;
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index d1c5023..119e13d 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -54,7 +54,7 @@ parse_quota(const char *s, u_int64_t * quota)
 }
 
 static int
-quota_parse(int c, char **argv, int invert, unsigned int *flags,
+quota_parse(int c, char **argv, bool invert, unsigned int *flags,
 	    const void *entry, struct xt_entry_match **match)
 {
 	struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index f9844c4..22a934b 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -109,7 +109,7 @@ rateest_get_rate(u_int32_t *rate, const char *str)
 }
 
 static int
-rateest_parse(int c, char **argv, int invert, unsigned int *flags,
+rateest_parse(int c, char **argv, bool invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_match **match)
 {
 	struct xt_rateest_match_info *info = (void *)(*match)->data;
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index ce281b2..2d1f6d5 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -63,7 +63,7 @@ static void recent_init(struct xt_entry_match *match)
 	(XT_RECENT_SET | XT_RECENT_CHECK | \
 	XT_RECENT_UPDATE | XT_RECENT_REMOVE)
 
-static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
+static int recent_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct xt_recent_mtinfo *info = (void *)(*match)->data;
@@ -76,7 +76,8 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_SET;
-			if (invert) info->invert = 1;
+			if (invert)
+				info->invert = true;
 			*flags |= XT_RECENT_SET;
 			break;
 
@@ -87,7 +88,8 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_CHECK;
-			if(invert) info->invert = 1;
+			if (invert)
+				info->invert = true;
 			*flags |= XT_RECENT_CHECK;
 			break;
 
@@ -98,7 +100,8 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_UPDATE;
-			if (invert) info->invert = 1;
+			if (invert)
+				info->invert = true;
 			*flags |= XT_RECENT_UPDATE;
 			break;
 
@@ -109,7 +112,8 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_REMOVE;
-			if (invert) info->invert = 1;
+			if (invert)
+				info->invert = true;
 			*flags |= XT_RECENT_REMOVE;
 			break;
 
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 3098859..928c33d 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -259,7 +259,7 @@ parse_sctp_chunks(struct xt_sctp_info *einfo,
 }
 
 static int
-sctp_parse(int c, char **argv, int invert, unsigned int *flags,
+sctp_parse(int c, char **argv, bool invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
 {
 	struct xt_sctp_info *einfo
@@ -339,7 +339,7 @@ print_port(u_int16_t port, bool numeric)
 
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, bool numeric)
+	    bool invert, bool numeric)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index eebc7c5..ed191b5 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2007 BalaBit IT Ltd.
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <getopt.h>
 #include <xtables.h>
@@ -12,8 +13,9 @@ static void socket_mt_help(void)
 	printf("socket v%s has no options\n\n", XTABLES_VERSION);
 }
 
-static int socket_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-			const void *entry, struct xt_entry_match **match)
+static int
+socket_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
+                const void *entry, struct xt_entry_match **match)
 {
 	return 0;
 }
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index 54e1348..3a0d8c8 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables for standard target support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -14,7 +15,7 @@ static void standard_help(void)
 "(If target is DROP, ACCEPT, RETURN or nothing)\n");
 }
 
-static int standard_parse(int c, char **argv, int invert, unsigned int *flags,
+static int standard_parse(int c, char **argv, bool invert, unsigned int *flags,
                           const void *entry, struct xt_entry_target **target)
 {
 	return 0;
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index bb21952..b5f0593 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -64,7 +64,7 @@ state_parse_states(const char *arg, struct xt_state_info *sinfo)
 }
 
 static int
-state_parse(int c, char **argv, int invert, unsigned int *flags,
+state_parse(int c, char **argv, bool invert, unsigned int *flags,
       const void *entry,
       struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 29541ee..ca65782 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -37,7 +37,7 @@ static void statistic_mt_init(struct xt_entry_match *match)
 }
 
 static int
-statistic_parse(int c, char **argv, int invert, unsigned int *flags,
+statistic_parse(int c, char **argv, bool invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
 	struct xt_statistic_info *info = (void *)(*match)->data;
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index ecdf31a..fc17d6c 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -170,7 +170,7 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 #define ICASE  0x10
 
 static int
-string_parse(int c, char **argv, int invert, unsigned int *flags,
+string_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
 	struct xt_string_info *stringinfo =
@@ -207,7 +207,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 		parse_string(argv[optind-1], stringinfo);
 		if (invert) {
 			if (revision == 0)
-				stringinfo->u.v0.invert = 1;
+				stringinfo->u.v0.invert = true;
 			else
 				stringinfo->u.v1.flags |= XT_STRING_FLAG_INVERT;
 		}
@@ -223,7 +223,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */
 		if (invert) {
 			if (revision == 0)
-				stringinfo->u.v0.invert = 1;
+				stringinfo->u.v0.invert = true;
 			else
 				stringinfo->u.v1.flags |= XT_STRING_FLAG_INVERT;
 		}
@@ -307,7 +307,7 @@ string_print(const void *ip, const struct xt_entry_match *match, bool numeric)
 	const struct xt_string_info *info =
 	    (const struct xt_string_info*) match->data;
 	const int revision = match->u.user.revision;
-	int invert = (revision == 0 ? info->u.v0.invert :
+	bool invert = (revision == 0 ? info->u.v0.invert :
 				    info->u.v1.flags & XT_STRING_FLAG_INVERT);
 
 	if (is_hex_string(info->pattern, info->patlen)) {
@@ -331,7 +331,7 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 	const struct xt_string_info *info =
 	    (const struct xt_string_info*) match->data;
 	const int revision = match->u.user.revision;
-	int invert = (revision == 0 ? info->u.v0.invert :
+	bool invert = (revision == 0 ? info->u.v0.invert :
 				    info->u.v1.flags & XT_STRING_FLAG_INVERT);
 
 	if (is_hex_string(info->pattern, info->patlen)) {
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index a1b115d..cbf813a 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -108,7 +108,7 @@ static void
 parse_tcp_flags(struct xt_tcp *tcpinfo,
 		const char *mask,
 		const char *cmp,
-		int invert)
+		bool invert)
 {
 	tcpinfo->flg_mask = parse_tcp_flag(mask);
 	tcpinfo->flg_cmp = parse_tcp_flag(cmp);
@@ -141,7 +141,7 @@ static void tcp_init(struct xt_entry_match *m)
 #define TCP_OPTION	0x08
 
 static int
-tcp_parse(int c, char **argv, int invert, unsigned int *flags,
+tcp_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_tcp *tcpinfo = (struct xt_tcp *)(*match)->data;
@@ -238,7 +238,7 @@ print_port(u_int16_t port, bool numeric)
 
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, bool numeric)
+	    bool invert, bool numeric)
 {
 	const char *inv = invert ? "!" : "";
 
@@ -258,7 +258,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
 }
 
 static void
-print_option(u_int8_t option, int invert, bool numeric)
+print_option(u_int8_t option, bool invert, bool numeric)
 {
 	if (option || invert)
 		printf("option=%s%u ", invert ? "!" : "", option);
@@ -287,7 +287,7 @@ print_tcpf(u_int8_t flags)
 }
 
 static void
-print_flags(u_int8_t mask, u_int8_t cmp, int invert, bool numeric)
+print_flags(u_int8_t mask, u_int8_t cmp, bool invert, bool numeric)
 {
 	if (mask || invert) {
 		printf("flags:%s", invert ? "!" : "");
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 1347b5f..d3e8b21 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -55,7 +55,7 @@ parse_tcp_mssvalues(const char *mssvaluestring,
 }
 
 static int
-tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
+tcpmss_parse(int c, char **argv, bool invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
 {
 	struct xt_tcpmss_match_info *mssinfo =
@@ -70,7 +70,7 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 		parse_tcp_mssvalues(argv[optind-1],
 				    &mssinfo->mss_min, &mssinfo->mss_max);
 		if (invert)
-			mssinfo->invert = 1;
+			mssinfo->invert = true;
 		*flags = 1;
 		break;
 	default:
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 7fbc6b5..2542fbf 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -246,7 +246,7 @@ static unsigned int time_parse_weekdays(const char *arg)
 	return ret;
 }
 
-static int time_parse(int c, char **argv, int invert, unsigned int *flags,
+static int time_parse(int c, char **argv, bool invert, unsigned int *flags,
                       const void *entry, struct xt_entry_match **match)
 {
 	struct xt_time_info *info = (void *)(*match)->data;
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index abac46e..90113ee 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -42,8 +42,9 @@ static void tos_mt_help(void)
 	printf("\n");
 }
 
-static int tos_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_match **match)
+static int
+tos_mt_parse_v0(int c, char **argv, bool invert, unsigned int *flags,
+                const void *entry, struct xt_entry_match **match)
 {
 	struct ipt_tos_info *info = (void *)(*match)->data;
 	struct tos_value_mask tvm;
@@ -66,7 +67,7 @@ static int tos_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	return false;
 }
 
-static int tos_mt_parse(int c, char **argv, int invert, unsigned int *flags,
+static int tos_mt_parse(int c, char **argv, bool invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
 	struct xt_tos_match_info *info = (void *)(*match)->data;
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index f0e0979..203e646 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -102,7 +102,7 @@ static u_int32_t parse_number(char **s, int pos)
 	return number;
 }
 
-static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
+static int u32_parse(int c, char **argv, bool invert, unsigned int *flags,
 		     const void *entry, struct xt_entry_match **match)
 {
 	struct xt_u32 *data = (void *)(*match)->data;
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 66372a4..0c5c3df 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -63,7 +63,7 @@ static void udp_init(struct xt_entry_match *m)
 #define UDP_DST_PORTS 0x02
 
 static int
-udp_parse(int c, char **argv, int invert, unsigned int *flags,
+udp_parse(int c, char **argv, bool invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
 {
 	struct xt_udp *udpinfo = (struct xt_udp *)(*match)->data;
@@ -122,7 +122,7 @@ print_port(u_int16_t port, bool numeric)
 
 static void
 print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, bool numeric)
+	    bool invert, bool numeric)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/include/xtables.h.in b/include/xtables.h.in
index ed599bc..97f4eea 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -67,7 +67,7 @@ struct xtables_match
 	/* Function which parses command options; returns true if it
            ate an option */
 	/* entry is struct ipt_entry for example */
-	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
+	int (*parse)(int c, char **argv, bool invert, unsigned int *flags,
 		     const void *entry,
 		     struct xt_entry_match **match);
 
@@ -129,7 +129,7 @@ struct xtables_target
 	/* Function which parses command options; returns true if it
            ate an option */
 	/* entry is struct ipt_entry for example */
-	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
+	int (*parse)(int c, char **argv, bool invert, unsigned int *flags,
 		     const void *entry,
 		     struct xt_entry_target **targetinfo);
 
@@ -243,7 +243,7 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 /* this is a special 64bit data type that is 8-byte aligned */
 #define aligned_u64 u_int64_t __attribute__((aligned(8)))
 
-int xtables_check_inverse(const char option[], int *invert,
+int xtables_check_inverse(const char option[], bool *invert,
 	int *my_optind, int argc);
 extern struct xtables_globals *xt_params;
 #define xtables_error (xt_params->exit_err)
diff --git a/ip6tables.c b/ip6tables.c
index cf1508b..9f70264 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -399,7 +399,7 @@ cmd2char(int option)
 
 static void
 add_command(unsigned int *cmd, const int newcmd, const int othercmds,
-	    int invert)
+	    bool invert)
 {
 	if (invert)
 		xtables_error(PARAMETER_PROBLEM, "unexpected '!' flag");
@@ -481,7 +481,7 @@ parse_target(const char *targetname)
 
 static void
 set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
-	   int invert)
+	   bool invert)
 {
 	if (*options & option)
 		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
@@ -1012,7 +1012,7 @@ list_entries(const ip6t_chainlabel chain, int rulenum, int verbose,
 /* This assumes that mask is contiguous, and byte-bounded. */
 static void
 print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
+	    bool invert)
 {
 	unsigned int i;
 
@@ -1038,7 +1038,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 }
 
 /* The ip6tables looks up the /etc/protocols. */
-static void print_proto(u_int16_t proto, int invert)
+static void print_proto(u_int16_t proto, bool invert)
 {
 	if (proto) {
 		unsigned int i;
@@ -1086,7 +1086,8 @@ static int print_match_save(const struct ip6t_entry_match *e,
 }
 
 /* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_addr *mask, int invert)
+static void print_ip(char *prefix, const struct in6_addr *ip,
+                     const struct in6_addr *mask, bool invert)
 {
 	char buf[51];
 	int l = ipv6_prefix_length(mask);
@@ -1301,7 +1302,7 @@ static void clear_rule_matches(struct xtables_rule_match **matches)
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
 	struct ip6t_entry fw, *e = NULL;
-	int invert = 0;
+	bool invert = false;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in6_addr *saddrs = NULL, *daddrs = NULL;
 	struct in6_addr *smasks = NULL, *dmasks = NULL;
diff --git a/iptables.c b/iptables.c
index e1f936a..27fa084 100644
--- a/iptables.c
+++ b/iptables.c
@@ -412,7 +412,7 @@ cmd2char(int option)
 
 static void
 add_command(unsigned int *cmd, const int newcmd, const int othercmds, 
-	    int invert)
+	    bool invert)
 {
 	if (invert)
 		xtables_error(PARAMETER_PROBLEM, "unexpected ! flag");
@@ -485,7 +485,7 @@ parse_target(const char *targetname)
 
 static void
 set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
-	   int invert)
+	   bool invert)
 {
 	if (*options & option)
 		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
@@ -1011,7 +1011,7 @@ list_entries(const ipt_chainlabel chain, int rulenum, int verbose,
 	return found;
 }
 
-static void print_proto(u_int16_t proto, int invert)
+static void print_proto(u_int16_t proto, bool invert)
 {
 	if (proto) {
 		unsigned int i;
@@ -1045,7 +1045,7 @@ static void print_proto(u_int16_t proto, int invert)
 /* This assumes that mask is contiguous, and byte-bounded. */
 static void
 print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
+	    bool invert)
 {
 	unsigned int i;
 
@@ -1094,7 +1094,7 @@ static int print_match_save(const struct ipt_entry_match *e,
 }
 
 /* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
+static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, bool invert)
 {
 	u_int32_t bits, hmask = ntohl(mask);
 	int i;
@@ -1324,7 +1324,7 @@ get_kernel_version(void) {
 int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
 {
 	struct ipt_entry fw, *e = NULL;
-	int invert = 0;
+	bool invert = false;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in_addr *saddrs = NULL, *smasks = NULL;
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
diff --git a/xtables.c b/xtables.c
index 73a4860..1de78a6 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1617,7 +1617,7 @@ void xtables_save_string(const char *value)
  * Check for option-intrapositional negation.
  * Do not use in new code.
  */
-int xtables_check_inverse(const char option[], int *invert,
+int xtables_check_inverse(const char option[], bool *invert,
 			  int *my_optind, int argc)
 {
 	if (option && strcmp(option, "!") == 0) {
-- 
1.6.2.2

