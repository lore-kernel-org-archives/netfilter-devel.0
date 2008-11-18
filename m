From: Jan Engelhardt <jengelh@medozas.de>
Subject: src: use NFPROTO_ constants
Date: Tue, 18 Nov 2008 11:55:39 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811181155280.17946@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51595 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbYKRKzl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2008 05:55:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a0b17007cd1eb4075af40f909a049552f847c93a
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Nov 18 11:54:46 2008 +0100

src: use NFPROTO_ constants

Resync netfilter.h from the latest kernel and make use of the new
NFPROTO_ constants that have been introduced.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c         |    2 +-
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    2 +-
 extensions/libip6t_dst.c        |    2 +-
 extensions/libip6t_eui64.c      |    2 +-
 extensions/libip6t_frag.c       |    2 +-
 extensions/libip6t_hbh.c        |    2 +-
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_policy.c     |    2 +-
 extensions/libip6t_rt.c         |    2 +-
 extensions/libipt_CLUSTERIP.c   |    2 +-
 extensions/libipt_DNAT.c        |    2 +-
 extensions/libipt_ECN.c         |    2 +-
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_MASQUERADE.c  |    2 +-
 extensions/libipt_MIRROR.c      |    2 +-
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |    2 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    2 +-
 extensions/libipt_SET.c         |    2 +-
 extensions/libipt_SNAT.c        |    2 +-
 extensions/libipt_TTL.c         |    2 +-
 extensions/libipt_ULOG.c        |    2 +-
 extensions/libipt_addrtype.c    |    4 ++--
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_ecn.c         |    2 +-
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_policy.c      |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libipt_set.c         |    2 +-
 extensions/libipt_ttl.c         |    2 +-
 extensions/libipt_unclean.c     |    2 +-
 extensions/libxt_CONNMARK.c     |    8 ++++----
 extensions/libxt_CONNSECMARK.c  |    4 ++--
 extensions/libxt_DSCP.c         |    4 ++--
 extensions/libxt_MARK.c         |    6 +++---
 extensions/libxt_NFLOG.c        |    4 ++--
 extensions/libxt_NFQUEUE.c      |    4 ++--
 extensions/libxt_NOTRACK.c      |    4 ++--
 extensions/libxt_TCPMSS.c       |    4 ++--
 extensions/libxt_TCPOPTSTRIP.c  |    4 ++--
 extensions/libxt_TOS.c          |    6 +++---
 extensions/libxt_TPROXY.c       |    2 +-
 extensions/libxt_comment.c      |    4 ++--
 extensions/libxt_connbytes.c    |    4 ++--
 extensions/libxt_connlimit.c    |   10 +++++-----
 extensions/libxt_connmark.c     |    8 ++++----
 extensions/libxt_conntrack.c    |   18 +++++++++---------
 extensions/libxt_dccp.c         |    4 ++--
 extensions/libxt_dscp.c         |    4 ++--
 extensions/libxt_esp.c          |    4 ++--
 extensions/libxt_hashlimit.c    |    8 ++++----
 extensions/libxt_helper.c       |    4 ++--
 extensions/libxt_iprange.c      |    6 +++---
 extensions/libxt_mac.c          |    4 ++--
 extensions/libxt_multiport.c    |    8 ++++----
 extensions/libxt_owner.c        |    8 ++++----
 extensions/libxt_physdev.c      |    4 ++--
 extensions/libxt_recent.c       |    4 ++--
 extensions/libxt_sctp.c         |    4 ++--
 extensions/libxt_socket.c       |    2 +-
 extensions/libxt_state.c        |    4 ++--
 extensions/libxt_tcp.c          |    4 ++--
 extensions/libxt_tcpmss.c       |    4 ++--
 extensions/libxt_tos.c          |    6 +++---
 extensions/libxt_udp.c          |    4 ++--
 include/linux/netfilter.h       |   10 ++++++++++
 include/xtables.h.in            |    2 ++
 ip6tables.c                     |    2 +-
 iptables.c                      |    2 +-
 libipq/ipq_create_handle.3      |    2 +-
 libipq/libipq.3                 |    2 +-
 libipq/libipq.c                 |    4 ++--
 78 files changed, 146 insertions(+), 134 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index e726a94..b806428 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -141,7 +141,7 @@ static const struct option HL_opts[] = {
 static struct xtables_target hl_tg6_reg = {
 	.name 		= "HL",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_HL_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_HL_info)),
 	.help		= HL_help,
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 07e741c..b75d806 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -252,7 +252,7 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target log_tg6_reg = {
     .name          = "LOG",
     .version       = XTABLES_VERSION,
-    .family        = PF_INET6,
+    .family        = NFPROTO_IPV6,
     .size          = XT_ALIGN(sizeof(struct ip6t_log_info)),
     .userspacesize = XT_ALIGN(sizeof(struct ip6t_log_info)),
     .help          = LOG_help,
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 9144809..9c6fe7a 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -133,7 +133,7 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target reject_tg6_reg = {
 	.name = "REJECT",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size 		= XT_ALIGN(sizeof(struct ip6t_reject_info)),
 	.userspacesize 	= XT_ALIGN(sizeof(struct ip6t_reject_info)),
 	.help		= REJECT_help,
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 96b07ef..9f7cfab 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -189,7 +189,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match ah_mt6_reg = {
 	.name          = "ah",
 	.version       = XTABLES_VERSION,
-	.family        = PF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct ip6t_ah)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_ah)),
 	.help          = ah_help,
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index aff20b7..dabca0d 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -224,7 +224,7 @@ static void dst_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match dst_mt6_reg = {
 	.name          = "dst",
 	.version       = XTABLES_VERSION,
-	.family        = PF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_opts)),
 	.help          = dst_help,
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index 8754b93..4caa66a 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -28,7 +28,7 @@ static int eui64_parse(int c, char **argv, int invert, unsigned int *flags,
 static struct xtables_match eui64_mt6_reg = {
 	.name 		= "eui64",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= eui64_help,
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index b651a95..1a6e3be 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -234,7 +234,7 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match frag_mt6_reg = {
 	.name          = "frag",
 	.version       = XTABLES_VERSION,
-	.family        = PF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct ip6t_frag)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_frag)),
 	.help          = frag_help,
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index d981f66..e07955f 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -211,7 +211,7 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match hbh_mt6_reg = {
 	.name 		= "hbh",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_opts)),
 	.help		= hbh_help,
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index b895e36..1046b2e 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -127,7 +127,7 @@ static const struct option hl_opts[] = {
 static struct xtables_match hl_mt6_reg = {
 	.name          = "hl",
 	.version       = XTABLES_VERSION,
-	.family        = PF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct ip6t_hl_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_hl_info)),
 	.help          = hl_help,
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index e60c5bd..2b3bd68 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -247,7 +247,7 @@ static void icmp6_check(unsigned int flags)
 static struct xtables_match icmp6_mt6_reg = {
 	.name 		= "icmp6",
 	.version 	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_icmp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_icmp)),
 	.help		= icmp6_help,
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index a3cfc62..63c60bf 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -284,7 +284,7 @@ static void ipv6header_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match ipv6header_mt6_reg = {
 	.name		= "ipv6header",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.help		= ipv6header_help,
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index cc7476e..305fadb 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -225,7 +225,7 @@ static const struct option mh_opts[] = {
 static struct xtables_match mh_mt6_reg = {
 	.name		= "mh",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_mh)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_mh)),
 	.help		= mh_help,
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 2a64caa..92e6d0d 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -444,7 +444,7 @@ static void policy_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match policy_mt6_reg = {
 	.name		= "policy",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_policy_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_policy_info)),
 	.help		= policy_help,
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 207f515..25e410c 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -326,7 +326,7 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match rt_mt6_reg = {
 	.name		= "rt",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET6,
+	.family		= NFPROTO_IPV6,
 	.size		= XT_ALIGN(sizeof(struct ip6t_rt)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_rt)),
 	.help		= rt_help,
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index e9789e9..7e73b9e 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -233,7 +233,7 @@ static void CLUSTERIP_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target clusterip_tg_reg = {
 	.name		= "CLUSTERIP",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
 	.userspacesize	= offsetof(struct ipt_clusterip_tgt_info, config),
  	.help		= CLUSTERIP_help,
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 5608947..da99b7f 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -240,7 +240,7 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target dnat_tg_reg = {
 	.name		= "DNAT",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= DNAT_help,
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 0ef480b..1336bb9 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -153,7 +153,7 @@ static void ECN_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target ecn_tg_reg = {
 	.name		= "ECN",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.help		= ECN_help,
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 57c35b0..d4f5e46 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -254,7 +254,7 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target log_tg_reg = {
     .name          = "LOG",
     .version       = XTABLES_VERSION,
-    .family        = PF_INET,
+    .family        = NFPROTO_IPV4,
     .size          = XT_ALIGN(sizeof(struct ipt_log_info)),
     .userspacesize = XT_ALIGN(sizeof(struct ipt_log_info)),
     .help          = LOG_help,
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 32410c0..ffbff58 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -147,7 +147,7 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target masquerade_tg_reg = {
 	.name		= "MASQUERADE",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= MASQUERADE_help,
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 0365f47..1322f59 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -21,7 +21,7 @@ static int MIRROR_parse(int c, char **argv, int invert, unsigned int *flags,
 static struct xtables_target mirror_tg_reg = {
 	.name		= "MIRROR",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
  	.help		= MIRROR_help,
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 3a5c613..85334bc 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -166,7 +166,7 @@ static void NETMAP_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target netmap_tg_reg = {
 	.name		= MODULENAME,
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= NETMAP_help,
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index e30c139..79e4731 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -158,7 +158,7 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target redirect_tg_reg = {
 	.name		= "REDIRECT",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= REDIRECT_help,
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 5f9407c..2aeb6df 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -152,7 +152,7 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target reject_tg_reg = {
 	.name		= "REJECT",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_reject_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_reject_info)),
 	.help		= REJECT_help,
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index baf5fee..51507eb 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -202,7 +202,7 @@ static void SAME_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target same_tg_reg = {
 	.name		= "SAME",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_same_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_same_info)),
 	.help		= SAME_help,
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index fa81571..7bf3510 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -149,7 +149,7 @@ static void SET_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target set_tg_reg = {
 	.name		= "SET",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_set_info_target)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_set_info_target)),
 	.help		= SET_help,
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 7d04761..fbd2a80 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -241,7 +241,7 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target snat_tg_reg = {
 	.name		= "SNAT",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= SNAT_help,
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 9c22ba3..7939dac 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -141,7 +141,7 @@ static const struct option TTL_opts[] = {
 static struct xtables_target ttl_tg_reg = {
 	.name		= "TTL",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.help		= TTL_help,
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index bec693d..8c191d0 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -182,7 +182,7 @@ static void ULOG_print(const void *ip, const struct xt_entry_target *target,
 static struct xtables_target ulog_tg_reg = {
 	.name		= "ULOG",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_ulog_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ulog_info)),
 	.help		= ULOG_help,
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 97ad804..e0de799 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -327,7 +327,7 @@ static const struct option addrtype_opts_v1[] = {
 static struct xtables_match addrtype_mt_reg_v0 = {
 	.name 		= "addrtype",
 	.version 	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size 		= XT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.help 		= addrtype_help_v0,
@@ -341,7 +341,7 @@ static struct xtables_match addrtype_mt_reg_v0 = {
 static struct xtables_match addrtype_mt_reg_v1 = {
 	.name 		= "addrtype",
 	.version 	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size 		= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
 	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_addrtype_info_v1)),
 	.help 		= addrtype_help_v1,
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 1f4f397..b308053 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -152,7 +152,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match ah_mt_reg = {
 	.name 		= "ah",
 	.version 	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_ah)),
 	.userspacesize 	= XT_ALIGN(sizeof(struct ipt_ah)),
 	.help 		= ah_help,
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 4dfaac9..30eaec2 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -144,7 +144,7 @@ static void ecn_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match ecn_mt_reg = {
     .name          = "ecn",
     .version       = XTABLES_VERSION,
-    .family        = PF_INET,
+    .family        = NFPROTO_IPV4,
     .size          = XT_ALIGN(sizeof(struct ipt_ecn_info)),
     .userspacesize = XT_ALIGN(sizeof(struct ipt_ecn_info)),
     .help          = ecn_help,
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 8faf66f..314a122 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -270,7 +270,7 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match icmp_mt_reg = {
 	.name		= "icmp",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_icmp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_icmp)),
 	.help		= icmp_help,
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index fc55fac..0268685 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -410,7 +410,7 @@ static void policy_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match policy_mt_reg = {
 	.name		= "policy",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_policy_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_policy_info)),
 	.help		= policy_help,
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index ba89abf..3812853 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -237,7 +237,7 @@ static void realm_check(unsigned int flags)
 static struct xtables_match realm_mt_reg = {
 	.name		= "realm",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_realm_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_realm_info)),
 	.help		= realm_help,
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 1bacdda..8aa4d1e 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -138,7 +138,7 @@ static void set_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match set_mt_reg = {
 	.name		= "set",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_set_info_match)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_set_info_match)),
 	.help		= set_help,
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 25b9206..cd93ca0 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -150,7 +150,7 @@ static const struct option ttl_opts[] = {
 static struct xtables_match ttl_mt_reg = {
 	.name		= "ttl",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.help		= ttl_help,
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 968e034..50a3ec3 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -18,7 +18,7 @@ static int unclean_parse(int c, char **argv, int invert, unsigned int *flags,
 static struct xtables_match unclean_mt_reg = {
 	.name		= "unclean",
 	.version	= XTABLES_VERSION,
-	.family		= PF_INET,
+	.family		= NFPROTO_IPV4,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= unclean_help,
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 9f83111..2ad2759 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -399,7 +399,7 @@ connmark_tg_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target connmark_target = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "CONNMARK",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
@@ -415,7 +415,7 @@ static struct xtables_target connmark_target = {
 };
 
 static struct xtables_target connmark_target6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "CONNMARK",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
@@ -434,7 +434,7 @@ static struct xtables_target connmark_tg_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "CONNMARK",
 	.revision       = 1,
-	.family         = AF_INET,
+	.family         = NFPROTO_IPV4,
 	.size           = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
 	.help           = connmark_tg_help,
@@ -450,7 +450,7 @@ static struct xtables_target connmark_tg6_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "CONNMARK",
 	.revision       = 1,
-	.family         = AF_INET6,
+	.family         = NFPROTO_IPV6,
 	.size           = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_tginfo1)),
 	.help           = connmark_tg_help,
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 2c425cb..05dbf70 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -107,7 +107,7 @@ CONNSECMARK_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target connsecmark_target = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "CONNSECMARK",
 	.version	= XTABLES_VERSION,
 	.revision	= 0,
@@ -122,7 +122,7 @@ static struct xtables_target connsecmark_target = {
 };
 
 static struct xtables_target connsecmark_target6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "CONNSECMARK",
 	.version	= XTABLES_VERSION,
 	.revision	= 0,
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 17bad16..6625db1 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -131,7 +131,7 @@ static void DSCP_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target dscp_target = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "DSCP",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
@@ -145,7 +145,7 @@ static struct xtables_target dscp_target = {
 };
 
 static struct xtables_target dscp_target6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "DSCP",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 8184976..95bce89 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -276,7 +276,7 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target mark_target_v0 = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "MARK",
 	.version	= XTABLES_VERSION,
 	.revision	= 0,
@@ -291,7 +291,7 @@ static struct xtables_target mark_target_v0 = {
 };
 
 static struct xtables_target mark_target_v1 = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "MARK",
 	.version	= XTABLES_VERSION,
 	.revision	= 1,
@@ -306,7 +306,7 @@ static struct xtables_target mark_target_v1 = {
 };
 
 static struct xtables_target mark_target6_v0 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "MARK",
 	.version	= XTABLES_VERSION,
 	.revision	= 0,
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index e5b6719..fe22e98 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -139,7 +139,7 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target nflog_target = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "NFLOG",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
@@ -153,7 +153,7 @@ static struct xtables_target nflog_target = {
 };
 
 static struct xtables_target nflog_target6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "NFLOG",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index d0b171a..7daed18 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -79,7 +79,7 @@ static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target nfqueue_target = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "NFQUEUE",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
@@ -92,7 +92,7 @@ static struct xtables_target nfqueue_target = {
 };
 
 static struct xtables_target nfqueue_target6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "NFQUEUE",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index ab54b47..ef26654 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -20,7 +20,7 @@ NOTRACK_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static struct xtables_target notrack_target = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "NOTRACK",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
@@ -30,7 +30,7 @@ static struct xtables_target notrack_target = {
 };
 
 static struct xtables_target notrack_target6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "NOTRACK",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index bffd260..2227eb4 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -119,7 +119,7 @@ static void TCPMSS_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target tcpmss_target = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "TCPMSS",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
@@ -133,7 +133,7 @@ static struct xtables_target tcpmss_target = {
 };
 
 static struct xtables_target tcpmss_target6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "TCPMSS",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index a00c82b..758f847 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -179,7 +179,7 @@ tcpoptstrip_tg_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target tcpoptstrip_tg_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "TCPOPTSTRIP",
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
 	.help          = tcpoptstrip_tg_help,
@@ -194,7 +194,7 @@ static struct xtables_target tcpoptstrip_tg_reg = {
 static struct xtables_target tcpoptstrip_tg6_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "TCPOPTSTRIP",
-	.family        = AF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
 	.help          = tcpoptstrip_tg_help,
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 55a7172..c185681 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -209,7 +209,7 @@ static struct xtables_target tos_tg_reg_v0 = {
 	.version       = XTABLES_VERSION,
 	.name          = "TOS",
 	.revision      = 0,
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct xt_tos_target_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_target_info)),
 	.help          = tos_tg_help_v0,
@@ -224,7 +224,7 @@ static struct xtables_target tos_tg_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "TOS",
 	.revision      = 1,
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct xt_tos_target_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_target_info)),
 	.help          = tos_tg_help,
@@ -238,7 +238,7 @@ static struct xtables_target tos_tg_reg = {
 static struct xtables_target tos_tg6_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "TOS",
-	.family        = AF_INET6,
+	.family        = NFPROTO_IPV6,
 	.revision      = 1,
 	.size          = XT_ALIGN(sizeof(struct xt_tos_target_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_target_info)),
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 0f910f4..d4b5c0a 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -133,7 +133,7 @@ static void tproxy_tg_save(const void *ip, const struct xt_entry_target *target)
 
 static struct xtables_target tproxy_tg_reg = {
 	.name	       = "TPROXY",
-	.family	       = AF_INET,
+	.family	       = NFPROTO_IPV4,
 	.version       = XTABLES_VERSION,
 	.size	       = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index b02f09b..a7f96d4 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -88,7 +88,7 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match comment_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "comment",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
@@ -102,7 +102,7 @@ static struct xtables_match comment_match = {
 };
 
 static struct xtables_match comment_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "comment",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 0867091..b77ba38 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -180,7 +180,7 @@ static void connbytes_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match connbytes_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name 		= "connbytes",
 	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
@@ -194,7 +194,7 @@ static struct xtables_match connbytes_match = {
 };
 
 static struct xtables_match connbytes_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name 		= "connbytes",
 	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 7a2fb45..65de193 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -74,7 +74,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		*flags |= 0x2;
 		i = strtoul(argv[optind-1], &err, 0);
-		if (family == AF_INET6) {
+		if (family == NFPROTO_IPV6) {
 			if (i > 128 || *err != '\0')
 				exit_error(PARAMETER_PROBLEM,
 					"--connlimit-mask must be between "
@@ -103,7 +103,7 @@ static int connlimit_parse4(int c, char **argv, int invert,
                             struct xt_entry_match **match)
 {
 	return connlimit_parse(c, argv, invert, flags,
-	       (void *)(*match)->data, AF_INET);
+	       (void *)(*match)->data, NFPROTO_IPV4);
 }
 
 static int connlimit_parse6(int c, char **argv, int invert,
@@ -111,7 +111,7 @@ static int connlimit_parse6(int c, char **argv, int invert,
                             struct xt_entry_match **match)
 {
 	return connlimit_parse(c, argv, invert, flags,
-	       (void *)(*match)->data, AF_INET6);
+	       (void *)(*match)->data, NFPROTO_IPV6);
 }
 
 static void connlimit_check(unsigned int flags)
@@ -179,7 +179,7 @@ static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match connlimit_match = {
 	.name          = "connlimit",
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
 	.userspacesize = offsetof(struct xt_connlimit_info, data),
@@ -194,7 +194,7 @@ static struct xtables_match connlimit_match = {
 
 static struct xtables_match connlimit_match6 = {
 	.name          = "connlimit",
-	.family        = AF_INET6,
+	.family        = NFPROTO_IPV6,
 	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
 	.userspacesize = offsetof(struct xt_connlimit_info, data),
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 2358f68..bc7ef45 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -164,7 +164,7 @@ connmark_mt_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match connmark_mt_reg_v0 = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "connmark",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
@@ -179,7 +179,7 @@ static struct xtables_match connmark_mt_reg_v0 = {
 };
 
 static struct xtables_match connmark_mt6_reg_v0 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "connmark",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
@@ -197,7 +197,7 @@ static struct xtables_match connmark_mt_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "connmark",
 	.revision       = 1,
-	.family         = AF_INET,
+	.family         = NFPROTO_IPV4,
 	.size           = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
 	.help           = connmark_mt_help,
@@ -212,7 +212,7 @@ static struct xtables_match connmark_mt6_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "connmark",
 	.revision       = 1,
-	.family         = AF_INET6,
+	.family         = NFPROTO_IPV6,
 	.size           = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_connmark_mtinfo1)),
 	.help           = connmark_mt_help,
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 1e5f141..3cec9dd 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -753,7 +753,7 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
                     const union nf_inet_addr *mask,
                     unsigned int family, bool numeric)
 {
-	if (family == AF_INET) {
+	if (family == NFPROTO_IPV4) {
 		if (!numeric && addr->ip == 0) {
 			printf("anywhere ");
 			return;
@@ -762,7 +762,7 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 			printf("%s ", ipaddr_to_numeric(&addr->in));
 		else
 			printf("%s ", ipaddr_to_anyname(&addr->in));
-	} else if (family == AF_INET6) {
+	} else if (family == NFPROTO_IPV6) {
 		if (!numeric && addr->ip6[0] == 0 && addr->ip6[1] == 0 &&
 		    addr->ip6[2] == 0 && addr->ip6[3] == 0) {
 			printf("anywhere ");
@@ -1003,14 +1003,14 @@ static void
 conntrack_mt_print(const void *ip, const struct xt_entry_match *match,
                    int numeric)
 {
-	conntrack_dump((const void *)match->data, "", AF_INET, numeric);
+	conntrack_dump((const void *)match->data, "", NFPROTO_IPV4, numeric);
 }
 
 static void
 conntrack_mt6_print(const void *ip, const struct xt_entry_match *match,
                     int numeric)
 {
-	conntrack_dump((const void *)match->data, "", AF_INET6, numeric);
+	conntrack_dump((const void *)match->data, "", NFPROTO_IPV6, numeric);
 }
 
 static void conntrack_save(const void *ip, const struct xt_entry_match *match)
@@ -1021,20 +1021,20 @@ static void conntrack_save(const void *ip, const struct xt_entry_match *match)
 static void conntrack_mt_save(const void *ip,
                               const struct xt_entry_match *match)
 {
-	conntrack_dump((const void *)match->data, "--", AF_INET, true);
+	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV4, true);
 }
 
 static void conntrack_mt6_save(const void *ip,
                                const struct xt_entry_match *match)
 {
-	conntrack_dump((const void *)match->data, "--", AF_INET6, true);
+	conntrack_dump((const void *)match->data, "--", NFPROTO_IPV6, true);
 }
 
 static struct xtables_match conntrack_match = {
 	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 0,
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct xt_conntrack_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_info)),
 	.help          = conntrack_mt_help,
@@ -1049,7 +1049,7 @@ static struct xtables_match conntrack_mt_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 1,
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.help          = conntrack_mt_help,
@@ -1064,7 +1064,7 @@ static struct xtables_match conntrack_mt6_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 1,
-	.family        = AF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 	.help          = conntrack_mt_help,
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index e33ddc3..24bf6f7 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -337,7 +337,7 @@ static void dccp_save(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match dccp_match = {
 	.name		= "dccp",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
@@ -351,7 +351,7 @@ static struct xtables_match dccp_match = {
 
 static struct xtables_match dccp_match6 = {
 	.name		= "dccp",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 42ca71d..307d800 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -143,7 +143,7 @@ static void dscp_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match dscp_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name 		= "dscp",
 	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
@@ -157,7 +157,7 @@ static struct xtables_match dscp_match = {
 };
 
 static struct xtables_match dscp_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name 		= "dscp",
 	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 06da33e..524449a 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -149,7 +149,7 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match esp_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name 		= "esp",
 	.version 	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
@@ -163,7 +163,7 @@ static struct xtables_match esp_match = {
 };
 
 static struct xtables_match esp_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name 		= "esp",
 	.version 	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 3960417..1c50685 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -663,7 +663,7 @@ hashlimit_mt6_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match hashlimit_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "hashlimit",
 	.version	= XTABLES_VERSION,
 	.revision	= 0,
@@ -679,7 +679,7 @@ static struct xtables_match hashlimit_match = {
 };
 
 static struct xtables_match hashlimit_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "hashlimit",
 	.version	= XTABLES_VERSION,
 	.revision	= 0,
@@ -698,7 +698,7 @@ static struct xtables_match hashlimit_mt_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "hashlimit",
 	.revision       = 1,
-	.family         = AF_INET,
+	.family         = NFPROTO_IPV4,
 	.size           = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
 	.userspacesize  = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
 	.help           = hashlimit_mt_help,
@@ -714,7 +714,7 @@ static struct xtables_match hashlimit_mt6_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "hashlimit",
 	.revision       = 1,
-	.family         = AF_INET6,
+	.family         = NFPROTO_IPV6,
 	.size           = XT_ALIGN(sizeof(struct xt_hashlimit_mtinfo1)),
 	.userspacesize  = offsetof(struct xt_hashlimit_mtinfo1, hinfo),
 	.help           = hashlimit_mt_help,
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index e8f1635..b60c982 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -69,7 +69,7 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match helper_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "helper",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
@@ -82,7 +82,7 @@ static struct xtables_match helper_match = {
 };
 
 static struct xtables_match helper_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "helper",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index ee87a6f..09e9fb7 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -348,7 +348,7 @@ static struct xtables_match iprange_match = {
 	.version       = XTABLES_VERSION,
 	.name          = "iprange",
 	.revision      = 0,
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct ipt_iprange_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ipt_iprange_info)),
 	.help          = iprange_mt_help,
@@ -363,7 +363,7 @@ static struct xtables_match iprange_mt_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "iprange",
 	.revision       = 1,
-	.family         = AF_INET,
+	.family         = NFPROTO_IPV4,
 	.size           = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 	.help           = iprange_mt_help,
@@ -378,7 +378,7 @@ static struct xtables_match iprange_mt6_reg = {
 	.version        = XTABLES_VERSION,
 	.name           = "iprange",
 	.revision       = 1,
-	.family         = AF_INET6,
+	.family         = NFPROTO_IPV6,
 	.size           = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 	.userspacesize  = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
 	.help           = iprange_mt_help,
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 2fe5e7b..f4128c0 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -112,7 +112,7 @@ static void mac_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match mac_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
  	.name		= "mac",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
@@ -126,7 +126,7 @@ static struct xtables_match mac_match = {
 };
 
 static struct xtables_match mac_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
  	.name		= "mac",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 6efd642..2552bbd 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -507,7 +507,7 @@ static void multiport_save6_v1(const void *ip_void,
 }
 
 static struct xtables_match multiport_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "multiport",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
@@ -522,7 +522,7 @@ static struct xtables_match multiport_match = {
 };
 
 static struct xtables_match multiport_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "multiport",
 	.revision	= 0,
 	.version	= XTABLES_VERSION,
@@ -537,7 +537,7 @@ static struct xtables_match multiport_match6 = {
 };
 
 static struct xtables_match multiport_match_v1 = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "multiport",
 	.version	= XTABLES_VERSION,
 	.revision	= 1,
@@ -552,7 +552,7 @@ static struct xtables_match multiport_match_v1 = {
 };
 
 static struct xtables_match multiport_match6_v1 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "multiport",
 	.version	= XTABLES_VERSION,
 	.revision	= 1,
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 7cad35c..298075e 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -532,7 +532,7 @@ static struct xtables_match owner_mt_reg_v0 = {
 	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 0,
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct ipt_owner_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ipt_owner_info)),
 	.help          = owner_mt_help_v0,
@@ -547,7 +547,7 @@ static struct xtables_match owner_mt6_reg_v0 = {
 	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 0,
-	.family        = AF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct ip6t_owner_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_owner_info)),
 	.help          = owner_mt6_help_v0,
@@ -562,7 +562,7 @@ static struct xtables_match owner_mt_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 1,
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.size          = XT_ALIGN(sizeof(struct xt_owner_match_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_owner_match_info)),
 	.help          = owner_mt_help,
@@ -577,7 +577,7 @@ static struct xtables_match owner_mt6_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 1,
-	.family        = AF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct xt_owner_match_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_owner_match_info)),
 	.help          = owner_mt_help,
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index a40cdf7..0572aba 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -163,7 +163,7 @@ static void physdev_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match physdev_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "physdev",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
@@ -177,7 +177,7 @@ static struct xtables_match physdev_match = {
 };
 
 static struct xtables_match physdev_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "physdev",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 59a3ca8..1ae9013 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -215,7 +215,7 @@ static void recent_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match recent_mt_reg = {
     .name          = "recent",
     .version       = XTABLES_VERSION,
-    .family        = PF_INET,
+    .family        = NFPROTO_IPV4,
     .size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
     .userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
     .help          = recent_help,
@@ -231,7 +231,7 @@ static struct xtables_match recent_mt6_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "recent",
 	.revision      = 0,
-	.family        = PF_INET6,
+	.family        = NFPROTO_IPV6,
 	.size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
 	.help          = recent_help,
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 5bd06a3..37a6423 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -510,7 +510,7 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 
 static struct xtables_match sctp_match = {
 	.name		= "sctp",
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_sctp_info)),
@@ -524,7 +524,7 @@ static struct xtables_match sctp_match = {
 
 static struct xtables_match sctp_match6 = {
 	.name		= "sctp",
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_sctp_info)),
diff --git a/extensions/libxt_socket.c b/extensions/libxt_socket.c
index 26ac9e3..eebc7c5 100644
--- a/extensions/libxt_socket.c
+++ b/extensions/libxt_socket.c
@@ -25,7 +25,7 @@ static void socket_mt_check(unsigned int flags)
 static struct xtables_match socket_mt_reg = {
 	.name	       = "socket",
 	.version       = XTABLES_VERSION,
-	.family	       = AF_INET,
+	.family	       = NFPROTO_IPV4,
 	.size	       = XT_ALIGN(0),
 	.userspacesize = XT_ALIGN(0),
 	.parse	       = socket_mt_parse,
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 3af2e48..95d7db5 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -136,7 +136,7 @@ static void state_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match state_match = { 
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "state",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
@@ -150,7 +150,7 @@ static struct xtables_match state_match = {
 };
 
 static struct xtables_match state_match6 = { 
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "state",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index a720ba4..14d8c18 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -378,7 +378,7 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match tcp_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "tcp",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
@@ -392,7 +392,7 @@ static struct xtables_match tcp_match = {
 };
 
 static struct xtables_match tcp_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "tcp",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 59218b8..14be919 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -119,7 +119,7 @@ static void tcpmss_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match tcpmss_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "tcpmss",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
@@ -133,7 +133,7 @@ static struct xtables_match tcpmss_match = {
 };
 
 static struct xtables_match tcpmss_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "tcpmss",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 92f7d84..9f8d6fa 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -140,7 +140,7 @@ static void tos_mt_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match tos_mt_reg_v0 = {
 	.version       = XTABLES_VERSION,
 	.name          = "tos",
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.revision      = 0,
 	.size          = XT_ALIGN(sizeof(struct ipt_tos_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct ipt_tos_info)),
@@ -155,7 +155,7 @@ static struct xtables_match tos_mt_reg_v0 = {
 static struct xtables_match tos_mt_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "tos",
-	.family        = AF_INET,
+	.family        = NFPROTO_IPV4,
 	.revision      = 1,
 	.size          = XT_ALIGN(sizeof(struct xt_tos_match_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_match_info)),
@@ -170,7 +170,7 @@ static struct xtables_match tos_mt_reg = {
 static struct xtables_match tos_mt6_reg = {
 	.version       = XTABLES_VERSION,
 	.name          = "tos",
-	.family        = AF_INET6,
+	.family        = NFPROTO_IPV6,
 	.revision      = 1,
 	.size          = XT_ALIGN(sizeof(struct xt_tos_match_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tos_match_info)),
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 37e3036..f64fd1c 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -191,7 +191,7 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match udp_match = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.name		= "udp",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
@@ -205,7 +205,7 @@ static struct xtables_match udp_match = {
 };
 
 static struct xtables_match udp_match6 = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.name		= "udp",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 4196a51..dc7ac57 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -36,6 +36,16 @@ enum nf_inet_hooks {
 	NF_INET_NUMHOOKS
 };
 
+enum {
+	NFPROTO_UNSPEC =  0,
+	NFPROTO_IPV4   =  2,
+	NFPROTO_ARP    =  3,
+	NFPROTO_BRIDGE =  7,
+	NFPROTO_IPV6   = 10,
+	NFPROTO_DECNET = 12,
+	NFPROTO_NUMPROTO,
+};
+
 union nf_inet_addr {
 	__u32		all[4];
 	__be32		ip;
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 51cb67d..8327c42 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -4,8 +4,10 @@
 #include <sys/socket.h> /* PF_* */
 #include <sys/types.h>
 #include <stdbool.h>
+#include <netinet/in.h>
 #include <net/if.h>
 #include <linux/types.h>
+#include <linux/netfilter.h>
 #include <linux/netfilter/x_tables.h>
 
 #ifndef IPPROTO_SCTP
diff --git a/ip6tables.c b/ip6tables.c
index 989f3bc..293ba37 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -199,7 +199,7 @@ struct pprot {
 };
 
 struct afinfo afinfo = {
-	.family		= AF_INET6,
+	.family		= NFPROTO_IPV6,
 	.libprefix	= "libip6t_",
 	.ipproto	= IPPROTO_IPV6,
 	.kmod		= "ip6_tables",
diff --git a/iptables.c b/iptables.c
index 7efd3cf..2c6b4dc 100644
--- a/iptables.c
+++ b/iptables.c
@@ -201,7 +201,7 @@ struct pprot {
 };
 
 struct afinfo afinfo = {
-	.family		= AF_INET,
+	.family		= NFPROTO_IPV4,
 	.libprefix	= "libipt_",
 	.ipproto	= IPPROTO_IP,
 	.kmod		= "ip_tables",
diff --git a/libipq/ipq_create_handle.3 b/libipq/ipq_create_handle.3
index c833e88..7840277 100644
--- a/libipq/ipq_create_handle.3
+++ b/libipq/ipq_create_handle.3
@@ -46,7 +46,7 @@ for forward compatibility.
 The
 .I protocol
 parameter is used to specify the protocol of the packets to be queued.
-Valid values are PF_INET for IPv4 and PF_INET6 for IPv6.  Currently, 
+Valid values are NFPROTO_IPV4 for IPv4 and NFPROTO_IPV6 for IPv6. Currently,
 only one protocol may be queued at a time for a handle.
 .PP
 The
diff --git a/libipq/libipq.3 b/libipq/libipq.3
index c2295c1..9dafa4a 100644
--- a/libipq/libipq.3
+++ b/libipq/libipq.3
@@ -187,7 +187,7 @@ int main(int argc, char **argv)
 	unsigned char buf[BUFSIZE];
 	struct ipq_handle *h;
 	
-	h = ipq_create_handle(0, PF_INET);
+	h = ipq_create_handle(0, NFPROTO_IPV4);
 	if (!h)
 		die(h);
 		
diff --git a/libipq/libipq.c b/libipq/libipq.c
index 658af97..495fce1 100644
--- a/libipq/libipq.c
+++ b/libipq/libipq.c
@@ -217,9 +217,9 @@ struct ipq_handle *ipq_create_handle(u_int32_t flags, u_int32_t protocol)
 	
 	memset(h, 0, sizeof(struct ipq_handle));
 	
-        if (protocol == PF_INET)
+        if (protocol == NFPROTO_IPV4)
                 h->fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_FIREWALL);
-        else if (protocol == PF_INET6)
+        else if (protocol == NFPROTO_IPV6)
                 h->fd = socket(PF_NETLINK, SOCK_RAW, NETLINK_IP6_FW);
         else {
 		ipq_errno = IPQ_ERR_PROTOCOL;

