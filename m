From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 7/7] fix gcc warnings
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182503.15959.7989.stgit@woodpecker.roonstrasse.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:54077 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751658AbYA0SlX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:41:23 -0500
In-Reply-To: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 configure.ac                    |    5 +++--
 extensions/dscp_helper.c        |    2 +-
 extensions/libip6t_HL.c         |    2 +-
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    2 +-
 extensions/libip6t_dst.c        |    4 ++--
 extensions/libip6t_frag.c       |    2 +-
 extensions/libip6t_hbh.c        |    4 ++--
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_policy.c     |    2 +-
 extensions/libip6t_rt.c         |    4 ++--
 extensions/libipt_CLUSTERIP.c   |    2 +-
 extensions/libipt_DNAT.c        |    2 +-
 extensions/libipt_ECN.c         |    2 +-
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_MASQUERADE.c  |    2 +-
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |    2 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    8 ++++----
 extensions/libipt_SNAT.c        |    2 +-
 extensions/libipt_TTL.c         |    2 +-
 extensions/libipt_ULOG.c        |    2 +-
 extensions/libipt_addrtype.c    |    2 +-
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_ecn.c         |    2 +-
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_policy.c      |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libipt_recent.c      |    2 +-
 extensions/libipt_ttl.c         |    2 +-
 extensions/libxt_CLASSIFY.c     |    2 +-
 extensions/libxt_CONNMARK.c     |    2 +-
 extensions/libxt_CONNSECMARK.c  |    2 +-
 extensions/libxt_DSCP.c         |    2 +-
 extensions/libxt_MARK.c         |    4 ++--
 extensions/libxt_NFLOG.c        |    2 +-
 extensions/libxt_NFQUEUE.c      |    2 +-
 extensions/libxt_RATEEST.c      |    2 +-
 extensions/libxt_SECMARK.c      |    2 +-
 extensions/libxt_TCPMSS.c       |    2 +-
 extensions/libxt_TCPOPTSTRIP.c  |    6 +++---
 extensions/libxt_TOS.c          |    4 ++--
 extensions/libxt_comment.c      |    2 +-
 extensions/libxt_connbytes.c    |    2 +-
 extensions/libxt_connlimit.c    |    2 +-
 extensions/libxt_connmark.c     |    2 +-
 extensions/libxt_conntrack.c    |    6 ++++--
 extensions/libxt_dccp.c         |    2 +-
 extensions/libxt_dscp.c         |    2 +-
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_hashlimit.c    |    2 +-
 extensions/libxt_helper.c       |    2 +-
 extensions/libxt_iprange.c      |    2 +-
 extensions/libxt_length.c       |    2 +-
 extensions/libxt_limit.c        |    2 +-
 extensions/libxt_mac.c          |    2 +-
 extensions/libxt_mark.c         |    2 +-
 extensions/libxt_multiport.c    |    2 +-
 extensions/libxt_owner.c        |    6 +++---
 extensions/libxt_physdev.c      |    2 +-
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_quota.c        |    4 ++--
 extensions/libxt_rateest.c      |    4 ++--
 extensions/libxt_sctp.c         |    2 +-
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_statistic.c    |    4 ++--
 extensions/libxt_string.c       |    2 +-
 extensions/libxt_tcp.c          |    2 +-
 extensions/libxt_tcpmss.c       |    2 +-
 extensions/libxt_time.c         |    2 +-
 extensions/libxt_tos.c          |    2 +-
 extensions/libxt_u32.c          |    2 +-
 extensions/libxt_udp.c          |    2 +-
 extensions/tos_values.c         |    2 +-
 include/libiptc/libip6tc.h      |    2 +-
 include/libiptc/libiptc.h       |    2 +-
 ip6tables.c                     |    9 +++++----
 iptables-xml.c                  |   24 ++++++++++++------------
 xtables.c                       |    4 ++--
 84 files changed, 120 insertions(+), 116 deletions(-)


diff --git a/configure.ac b/configure.ac
index 3314df4..d80eeee 100644
--- a/configure.ac
+++ b/configure.ac
@@ -37,7 +37,7 @@ AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" == "yes"])
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" == "yes"])
 
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
-	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
+	-D_REENTRANT -W -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
 	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" \
@@ -46,7 +46,8 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 # Remove workarounds soon
 regular_CFLAGS="$regular_CFLAGS -Wno-aggregate-return \
 	-Wno-missing-declarations -Wno-missing-prototypes \
-	-Wno-redundant-decls -Wno-shadow -Wno-strict-prototypes -Wno-inline"
+        -Wno-unused-parameter \
+	-Wno-shadow -Wno-inline"
 
 AC_SUBST([regular_CFLAGS])
 AC_SUBST([kbuilddir])
diff --git a/extensions/dscp_helper.c b/extensions/dscp_helper.c
index 8b60d41..9e9a163 100644
--- a/extensions/dscp_helper.c
+++ b/extensions/dscp_helper.c
@@ -49,7 +49,7 @@ static const struct ds_class
 static unsigned int
 class_to_dscp(const char *name)
 {
-	int i;
+	unsigned i;
 
 	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
 		if (!strncasecmp(name, ds_classes[i].name,
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 73cb3ba..c20147b 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -136,7 +136,7 @@ static const struct option HL_opts[] = {
 	{ "hl-set", 1, NULL, '1' },
 	{ "hl-dec", 1, NULL, '2' },
 	{ "hl-inc", 1, NULL, '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct ip6tables_target hl_target6 = {
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 10d5b73..6fd4c0b 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -38,7 +38,7 @@ static const struct option LOG_opts[] = {
 	{ .name = "log-tcp-options",  .has_arg = 0, .val = '2' },
 	{ .name = "log-ip-options",   .has_arg = 0, .val = '3' },
 	{ .name = "log-uid",          .has_arg = 0, .val = '4' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Initialize the target. */
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index b765435..000096e 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -66,7 +66,7 @@ static void REJECT_help(void)
 
 static const struct option REJECT_opts[] = {
 	{ "reject-with", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Allocate and initialize the target. */
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index c372af5..46469ea 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -23,7 +23,7 @@ static const struct option ah_opts[] = {
 	{ .name = "ahspi", .has_arg = 1, .val = '1' },
 	{ .name = "ahlen", .has_arg = 1, .val = '2' },
 	{ .name = "ahres", .has_arg = 0, .val = '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int32_t
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 4b4dcf9..9e4d870 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -26,7 +26,7 @@ static const struct option dst_opts[] = {
 	{ .name = "dst-len",        .has_arg = 1, .val = '1' },
 	{ .name = "dst-opts",       .has_arg = 1, .val = '2' },
 	{ .name = "dst-not-strict", .has_arg = 1, .val = '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int32_t
@@ -168,7 +168,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_options(int optsnr, u_int16_t *optsp)
+print_options(unsigned optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
 
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index b8e15d3..86f40f4 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -29,7 +29,7 @@ static const struct option frag_opts[] = {
 	{ .name = "fragfirst", .has_arg = 0, .val = '4' },
 	{ .name = "fragmore",  .has_arg = 0, .val = '5' },
 	{ .name = "fraglast",  .has_arg = 0, .val = '6' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int32_t
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index f8753bb..1052575 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -29,7 +29,7 @@ static const struct option hbh_opts[] = {
 	{ "hbh-len", 1, NULL, '1' },
 	{ "hbh-opts", 1, NULL, '2' },
 	{ "hbh-not-strict", 1, NULL, '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int32_t
@@ -162,7 +162,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_options(int optsnr, u_int16_t *optsp)
+print_options(unsigned optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
 
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 87a1eeb..7f99598 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -122,7 +122,7 @@ static const struct option hl_opts[] = {
 	{ .name = "hl-eq", .has_arg = 1, .val = '2' },
 	{ .name = "hl-lt", .has_arg = 1, .val = '3' },
 	{ .name = "hl-gt", .has_arg = 1, .val = '4' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct ip6tables_match hl_match6 = {
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index febf523..8c9653f 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -86,7 +86,7 @@ static void icmp6_help(void)
 
 static const struct option icmp6_opts[] = {
 	{ "icmpv6-type", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 0d7ffd8..c20fb94 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -150,7 +150,7 @@ static void ipv6header_help(void)
 static const struct option ipv6header_opts[] = {
 	{ "header", 1, NULL, '1' },
 	{ "soft", 0, NULL, '2' },
-	{ }
+	{ .name = NULL }
 };
 
 static void ipv6header_init(struct xt_entry_match *m)
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 717a8be..dd0da2b 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -220,7 +220,7 @@ static void mh_save(const void *ip, const struct xt_entry_match *match)
 
 static const struct option mh_opts[] = {
 	{ "mh-type", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct ip6tables_match mh_match6 = {
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 1ecd66e..f706f98 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -91,7 +91,7 @@ static const struct option policy_opts[] =
 		.name		= "next",
 		.val		= 'a'
 	},
-	{ }
+	{ .name = NULL }
 };
 
 /* FIXME - Duplicated code from ip6tables.c */
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 8946900..a9ced6a 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -35,7 +35,7 @@ static const struct option rt_opts[] = {
 	{ "rt-0-res", 0, NULL, '4' },
 	{ "rt-0-addrs", 1, NULL, '5' },
 	{ "rt-0-not-strict", 0, NULL, '6' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int32_t
@@ -255,7 +255,7 @@ print_nums(const char *name, u_int32_t min, u_int32_t max,
 }
 
 static void
-print_addresses(int addrnr, struct in6_addr *addrp)
+print_addresses(unsigned addrnr, struct in6_addr *addrp)
 {
 	unsigned int i;
 
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 74b434f..fdeae86 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -50,7 +50,7 @@ static const struct option CLUSTERIP_opts[] = {
 	{ "total-nodes", 1, NULL, '4' },
 	{ "local-node", 1, NULL, '5' },
 	{ "hash-init", 1, NULL, '6' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 6999ee9..3ad412b 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -34,7 +34,7 @@ IPTABLES_VERSION);
 static const struct option DNAT_opts[] = {
 	{ "to-destination", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct ipt_natinfo *
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index d3f66fb..e5c8b22 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -38,7 +38,7 @@ static const struct option ECN_opts[] = {
 	{ "ecn-tcp-cwr", 1, NULL, 'G' },
 	{ "ecn-tcp-ece", 1, NULL, 'H' },
 	{ "ecn-ip-ect", 1, NULL, '9' },
-	{ }
+	{ .name = NULL }
 };
 
 static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index a3635e5..6b08f58 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -38,7 +38,7 @@ static const struct option LOG_opts[] = {
 	{ .name = "log-tcp-options",  .has_arg = 0, .val = '2' },
 	{ .name = "log-ip-options",   .has_arg = 0, .val = '3' },
 	{ .name = "log-uid",          .has_arg = 0, .val = '4' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Initialize the target. */
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 5b4787d..fc914c5 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -25,7 +25,7 @@ IPTABLES_VERSION);
 static const struct option MASQUERADE_opts[] = {
 	{ "to-ports", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Initialize the target. */
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 4073693..da0e5f4 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -15,7 +15,7 @@
 
 static const struct option NETMAP_opts[] = {
 	{ "to", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Function which prints out usage message. */
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index f749dd1..1918df8 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -24,7 +24,7 @@ IPTABLES_VERSION);
 static const struct option REDIRECT_opts[] = {
 	{ "to-ports", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Initialize the target. */
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 7e23ada..5901a5e 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -81,7 +81,7 @@ static void REJECT_help(void)
 
 static const struct option REJECT_opts[] = {
 	{ "reject-with", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Allocate and initialize the target. */
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 6aaac99..e03ae80 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -32,7 +32,7 @@ static const struct option SAME_opts[] = {
 	{ "to", 1, NULL, '1' },
 	{ "nodst", 0, NULL, '2'},
 	{ "random", 0, NULL, '3' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Initialize the target. */
@@ -90,7 +90,7 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 {
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)(*target)->data;
-	int count;
+	unsigned count;
 
 	switch (c) {
 	case '1':
@@ -146,7 +146,7 @@ static void SAME_check(unsigned int flags)
 static void SAME_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	int count;
+	unsigned count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
 	int random = 0;
@@ -180,7 +180,7 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void SAME_save(const void *ip, const struct xt_entry_target *target)
 {
-	int count;
+	unsigned count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
 	int random = 0;
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 7eae53c..7b9e176 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -34,7 +34,7 @@ IPTABLES_VERSION);
 static const struct option SNAT_opts[] = {
 	{ "to-source", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct ipt_natinfo *
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 919aea3..cbffd53 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -136,7 +136,7 @@ static const struct option TTL_opts[] = {
 	{ "ttl-set", 1, NULL, '1' },
 	{ "ttl-dec", 1, NULL, '2' },
 	{ "ttl-inc", 1, NULL, '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct iptables_target ttl_target = {
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index eddd79f..6fb2c66 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -49,7 +49,7 @@ static const struct option ULOG_opts[] = {
 	{"ulog-prefix", 1, NULL, '#'},
 	{"ulog-cprange", 1, NULL, 'A'},
 	{"ulog-qthreshold", 1, NULL, 'B'},
-	{ }
+	{ .name = NULL }
 };
 
 /* Initialize the target. */
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index b8605c7..5557af2 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -180,7 +180,7 @@ static void addrtype_save(const void *ip, const struct xt_entry_match *match)
 static const struct option addrtype_opts[] = {
 	{ "src-type", 1, NULL, '1' },
 	{ "dst-type", 1, NULL, '2' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct iptables_match addrtype_match = {
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 70ba03e..2555b5d 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option ah_opts[] = {
 	{ "ahspi", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int32_t
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index d32d314..9c07eab 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -30,7 +30,7 @@ static const struct option ecn_opts[] = {
 	{ .name = "ecn-tcp-cwr", .has_arg = 0, .val = 'F' },
 	{ .name = "ecn-tcp-ece", .has_arg = 0, .val = 'G' },
 	{ .name = "ecn-ip-ect",  .has_arg = 1, .val = 'H' },
-	{ }
+	{ .name = NULL }
 };
 
 static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index fa76601..b1fccbf 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -110,7 +110,7 @@ static void icmp_help(void)
 
 static const struct option icmp_opts[] = {
 	{ "icmp-type", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static void 
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index a805e13..48b96be 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -90,7 +90,7 @@ static const struct option policy_opts[] =
 		.name		= "next",
 		.val		= 'a'
 	},
-	{ }
+	{ .name = NULL }
 };
 
 static int parse_direction(char *s)
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 4f3416f..7026fc2 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -26,7 +26,7 @@ static void realm_help(void)
 
 static const struct option realm_opts[] = {
 	{ "realm", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 struct realmname { 
diff --git a/extensions/libipt_recent.c b/extensions/libipt_recent.c
index 76f9771..ace778e 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libipt_recent.c
@@ -33,7 +33,7 @@ static const struct option recent_opts[] = {
 	{ .name = "name",     .has_arg = 1, .val = 208 },
 	{ .name = "rsource",  .has_arg = 0, .val = 209 },
 	{ .name = "rdest",    .has_arg = 0, .val = 210 },
-	{ }
+	{ .name = NULL }
 };
 
 /* Function which prints out usage message. */
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 4f780bd..fc0d2c5 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -145,7 +145,7 @@ static const struct option ttl_opts[] = {
 	{ "ttl-eq", 1, NULL, '2'},
 	{ "ttl-lt", 1, NULL, '3'},
 	{ "ttl-gt", 1, NULL, '4'},
-	{ }
+	{ .name = NULL }
 };
 
 static struct iptables_match ttl_match = {
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 65a19e5..e39367a 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -23,7 +23,7 @@ IPTABLES_VERSION);
 
 static const struct option CLASSIFY_opts[] = {
 	{ "set-class", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index f8c3cab..3e60e85 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -52,7 +52,7 @@ static const struct option CONNMARK_opts[] = {
 	{ "save-mark", 0, NULL, '2' },
 	{ "restore-mark", 0, NULL, '3' },
 	{ "mask", 1, NULL, '4' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Function which parses command options; returns true if it
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index a7d7cf7..e8d0a5e 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -27,7 +27,7 @@ IPTABLES_VERSION);
 static const struct option CONNSECMARK_opts[] = {
 	{ "save", 0, 0, '1' },
 	{ "restore", 0, 0, '2' },
-	{ 0 }
+	{ .name = NULL }
 };
 
 static int
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 73b1042..c15f0e1 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -40,7 +40,7 @@ static void DSCP_help(void)
 static const struct option DSCP_opts[] = {
 	{ "set-dscp", 1, NULL, 'F' },
 	{ "set-dscp-class", 1, NULL, 'G' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 82beb4b..569d2e8 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -29,7 +29,7 @@ static const struct option MARK_opts[] = {
 	{ "set-mark", 1, NULL, '1' },
 	{ "and-mark", 1, NULL, '2' },
 	{ "or-mark", 1, NULL, '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static const struct option mark_tg_opts[] = {
@@ -38,7 +38,7 @@ static const struct option mark_tg_opts[] = {
 	{.name = "and-mark",  .has_arg = true, .val = '&'},
 	{.name = "or-mark",   .has_arg = true, .val = '|'},
 	{.name = "xor-mark",  .has_arg = true, .val = '^'},
-	{},
+	{ .name = NULL }
 };
 
 static void mark_tg_help(void)
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 1125c37..d4dc971 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -19,7 +19,7 @@ static const struct option NFLOG_opts[] = {
 	{ "nflog-prefix",    1, NULL, NFLOG_PREFIX },
 	{ "nflog-range",     1, NULL, NFLOG_RANGE },
 	{ "nflog-threshold", 1, NULL, NFLOG_THRESHOLD },
-	{NULL},
+	{ .name = NULL }
 };
 
 static void NFLOG_help(void)
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 3687e5a..b1c5ef3 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -25,7 +25,7 @@ static void NFQUEUE_help(void)
 
 static const struct option NFQUEUE_opts[] = {
 	{ "queue-num", 1, NULL, 'F' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 8445cdf..1871657 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -36,7 +36,7 @@ static const struct option RATEEST_opts[] = {
 	{ "rateest-name",	1, NULL, RATEEST_OPT_NAME },
 	{ "rateest-interval",	1, NULL, RATEEST_OPT_INTERVAL },
 	{ "rateest-ewmalog",	1, NULL, RATEEST_OPT_EWMALOG },
-	{ },
+	{ .name = NULL },
 };
 
 /* Copied from iproute */
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 0aeaee9..b794e7d 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -25,7 +25,7 @@ IPTABLES_VERSION);
 
 static const struct option SECMARK_opts[] = {
 	{ "selctx", 1, 0, '1' },
-	{ 0 }
+	{ .name = NULL }
 };
 
 /*
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 8d6974d..9ab69bf 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -39,7 +39,7 @@ static void TCPMSS_help6(void)
 static const struct option TCPMSS_opts[] = {
 	{ "set-mss", 1, NULL, '1' },
 	{ "clamp-mss-to-pmtu", 0, NULL, '2' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Function which parses command options; returns true if it
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index c3d558d..df107f4 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -22,12 +22,12 @@ enum {
 
 struct tcp_optionmap {
 	const char *name, *desc;
-	const int option;
+	const unsigned option;
 };
 
 static const struct option tcpoptstrip_tg_opts[] = {
 	{.name = "strip-options", .has_arg = true, .val = 's'},
-	{},
+	{ .name = NULL }
 };
 
 static const struct tcp_optionmap tcp_optionmap[] = {
@@ -37,7 +37,7 @@ static const struct tcp_optionmap tcp_optionmap[] = {
 	{"sack",           "Selective ACK",        TCPOPT_SACK},
 	{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
 	{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
-	{NULL},
+	{ .name = NULL }
 };
 
 static void tcpoptstrip_tg_help(void)
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 74ec2b5..777d7cf 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -20,7 +20,7 @@ enum {
 
 static const struct option tos_tg_opts_v0[] = {
 	{.name = "set-tos", .has_arg = true, .val = '='},
-	{},
+	{ .name = NULL }
 };
 
 static const struct option tos_tg_opts[] = {
@@ -28,7 +28,7 @@ static const struct option tos_tg_opts[] = {
 	{.name = "and-tos", .has_arg = true, .val = '&'},
 	{.name = "or-tos",  .has_arg = true, .val = '|'},
 	{.name = "xor-tos", .has_arg = true, .val = '^'},
-	{},
+	{ .name = NULL }
 };
 
 static void tos_tg_help_v0(void)
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index e29ce16..20277d4 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -25,7 +25,7 @@ static void comment_help(void)
 
 static const struct option comment_opts[] = {
 	{ "comment", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 3ec08d0..e6cb1f4 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -23,7 +23,7 @@ static const struct option connbytes_opts[] = {
 	{ "connbytes", 1, NULL, '1' },
 	{ "connbytes-dir", 1, NULL, '2' },
 	{ "connbytes-mode", 1, NULL, '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 31f9311..9e2137a 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -21,7 +21,7 @@ static void connlimit_help(void)
 static const struct option connlimit_opts[] = {
 	{"connlimit-above", 1, NULL, 'A'},
 	{"connlimit-mask",  1, NULL, 'M'},
-	{NULL},
+	{ .name = NULL }
 };
 
 static void connlimit_init(struct xt_entry_match *match)
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 65faa8e..1e38f7c 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -42,7 +42,7 @@ static void connmark_mt_help(void)
 
 static const struct option connmark_mt_opts[] = {
 	{.name = "mark", .has_arg = true, .val = '1'},
-	{},
+	{ .name = NULL }
 };
 
 static int
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 9c7b01a..f5c73ff 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -43,7 +43,7 @@ static const struct option conntrack_mt_opts[] = {
 	{.name = "ctrepldst", .has_arg = true, .val = '6'},
 	{.name = "ctstatus",  .has_arg = true, .val = '7'},
 	{.name = "ctexpire",  .has_arg = true, .val = '8'},
-	{},
+	{ .name = NULL }
 };
 
 static int
@@ -144,7 +144,9 @@ parse_expires(const char *s, struct xt_conntrack_info *sinfo)
 		cp++;
 
 		sinfo->expires_min = buffer[0] ? parse_expire(buffer) : 0;
-		sinfo->expires_max = cp[0] ? parse_expire(cp) : -1;
+		sinfo->expires_max = cp[0]
+			? parse_expire(cp)
+			: (unsigned long)-1;
 	}
 	free(buffer);
 
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 450f249..467a695 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -51,7 +51,7 @@ static const struct option dccp_opts[] = {
 	{ .name = "dport", .has_arg = 1, .val = '2' },
 	{ .name = "dccp-types", .has_arg = 1, .val = '3' },
 	{ .name = "dccp-option", .has_arg = 1, .val = '4' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 69be08b..a28af09 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -42,7 +42,7 @@ static void dscp_help(void)
 static const struct option dscp_opts[] = {
 	{ "dscp", 1, NULL, 'F' },
 	{ "dscp-class", 1, NULL, 'G' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index e5b5eaa..f37c088 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option esp_opts[] = {
 	{ "espspi", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int32_t
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 09455d9..d8a0035 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -54,7 +54,7 @@ static const struct option hashlimit_opts[] = {
 	{ "hashlimit-htable-expire", 1, NULL, ')' },
 	{ "hashlimit-mode", 1, NULL, '_' },
 	{ "hashlimit-name", 1, NULL, '"' },
-	{ }
+	{ .name = NULL }
 };
 
 static
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index f2f3a3d..31ae4fc 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option helper_opts[] = {
 	{ "helper", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 /* Function which parses command options; returns true if it
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 47d7464..51b35f8 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -27,7 +27,7 @@ static void iprange_mt_help(void)
 static const struct option iprange_mt_opts[] = {
 	{.name = "src-range", .has_arg = true, .val = '1'},
 	{.name = "dst-range", .has_arg = true, .val = '2'},
-	{},
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index c55b12b..b812b67 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -21,7 +21,7 @@ IPTABLES_VERSION);
   
 static const struct option length_opts[] = {
 	{ "length", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int16_t
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 92cecf4..65a8df3 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -32,7 +32,7 @@ static void limit_help(void)
 static const struct option limit_opts[] = {
 	{ "limit", 1, NULL, '%' },
 	{ "limit-burst", 1, NULL, '$' },
-	{ }
+	{ .name = NULL }
 };
 
 static
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 5d84aee..2284d2a 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -24,7 +24,7 @@ static void mac_help(void)
 
 static const struct option mac_opts[] = {
 	{ "mac-source", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index e757084..1dfcc58 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -23,7 +23,7 @@ static void mark_mt_help(void)
 
 static const struct option mark_mt_opts[] = {
 	{.name = "mark", .has_arg = true, .val = '1'},
-	{},
+	{ .name = NULL }
 };
 
 static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 809a349..6de7bc1 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -49,7 +49,7 @@ static const struct option multiport_opts[] = {
 	{ "destination-ports", 1, NULL, '2' },
 	{ "dports", 1, NULL, '2' }, /* synonym */
 	{ "ports", 1, NULL, '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static char *
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 28e2db4..2d77623 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -81,7 +81,7 @@ static const struct option owner_mt_opts_v0[] = {
 #ifdef IPT_OWNER_COMM
 	{.name = "cmd-owner", .has_arg = true, .val = 'c'},
 #endif
-	{},
+	{ .name = NULL }
 };
 
 static const struct option owner_mt6_opts_v0[] = {
@@ -89,14 +89,14 @@ static const struct option owner_mt6_opts_v0[] = {
 	{.name = "gid-owner", .has_arg = true, .val = 'g'},
 	{.name = "pid-owner", .has_arg = true, .val = 'p'},
 	{.name = "sid-owner", .has_arg = true, .val = 's'},
-	{},
+	{ .name = NULL }
 };
 
 static const struct option owner_mt_opts[] = {
 	{.name = "uid-owner",     .has_arg = true,  .val = 'u'},
 	{.name = "gid-owner",     .has_arg = true,  .val = 'g'},
 	{.name = "socket-exists", .has_arg = false, .val = 'k'},
-	{},
+	{ .name = NULL }
 };
 
 static int
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 144fbb4..e971d1e 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -30,7 +30,7 @@ static const struct option physdev_opts[] = {
 	{ "physdev-is-in", 0, NULL, '3' },
 	{ "physdev-is-out", 0, NULL, '4' },
 	{ "physdev-is-bridged", 0, NULL, '5' },
-	{ }
+	{ .name = NULL }
 };
 
 static int
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 2d73560..75194fc 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -66,7 +66,7 @@ static void pkttype_help(void)
 
 static const struct option pkttype_opts[] = {
 	{"pkt-type", 1, NULL, '1'},
-	{ }
+	{ .name = NULL }
 };
 
 static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 7d73033..57050f2 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -13,7 +13,7 @@
 
 static const struct option quota_opts[] = {
 	{"quota", 1, NULL, '1'},
-	{ }
+	{ .name = NULL }
 };
 
 /* print usage */
@@ -49,7 +49,7 @@ parse_quota(const char *s, u_int64_t * quota)
 	printf("Quota: %llu\n", *quota);
 #endif
 
-	if (*quota == -1)
+	if (*quota == (u_int64_t)-1)
 		exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
 	else
 		return 1;
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index cf78703..5f13340 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -55,7 +55,7 @@ static const struct option rateest_opts[] = {
 	{ "rateest-lt",		0, NULL, OPT_RATEEST_LT },
 	{ "rateest-gt",		0, NULL, OPT_RATEEST_GT },
 	{ "rateest-eq",		0, NULL, OPT_RATEEST_EQ },
-	{ },
+	{ .name = NULL }
 };
 
 /* Copied from iproute. See http://physics.nist.gov/cuu/Units/binary.html */
@@ -81,7 +81,7 @@ static const struct rate_suffix {
 	{ "GBps",	8000000000. },
 	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
 	{ "TBps",	8000000000000. },
-	{ }
+	{ .name = NULL }
 };
 
 static int
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index de8948c..4b9166a 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -73,7 +73,7 @@ static const struct option sctp_opts[] = {
 	{ .name = "destination-port", .has_arg = 1, .val = '2' },
 	{ .name = "dport", .has_arg = 1, .val = '2' },
 	{ .name = "chunk-types", .has_arg = 1, .val = '3' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 82f21cd..68f5280 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -25,7 +25,7 @@ state_help(void)
 
 static const struct option state_opts[] = {
 	{ "state", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static int
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 1b34527..19bb121 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -27,7 +27,7 @@ static const struct option statistic_opts[] = {
 	{ "probability", 1, NULL, '2' },
 	{ "every", 1, NULL, '3' },
 	{ "packet", 1, NULL, '4' },
-	{ }
+	{ .name = NULL }
 };
 
 static struct xt_statistic_info *info;
@@ -113,7 +113,7 @@ static void statistic_check(unsigned int flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "--packet can only be used with --every");
 	/* at this point, info->u.nth.every have been decreased. */
-	if (!(info->u.nth.packet >= 0 && info->u.nth.packet <= info->u.nth.every))
+	if (info->u.nth.packet > info->u.nth.every)
 		exit_error(PARAMETER_PROBLEM,
 			  "the --packet p must be 0 <= p <= n-1");
 
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 50b7f61..f1030bb 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -49,7 +49,7 @@ static const struct option string_opts[] = {
 	{ "algo", 1, NULL, '3' },
 	{ "string", 1, NULL, '4' },
 	{ "hex-string", 1, NULL, '5' },
-	{ }
+	{ .name = NULL }
 };
 
 static void string_init(struct xt_entry_match *m)
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index b1f12a4..3274f08 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -34,7 +34,7 @@ static const struct option tcp_opts[] = {
 	{ "syn", 0, NULL, '3' },
 	{ "tcp-flags", 1, NULL, '4' },
 	{ "tcp-option", 1, NULL, '5' },
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index e08be48..7a026bf 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option tcpmss_opts[] = {
 	{ "mss", 1, NULL, '1' },
-	{ }
+	{ .name = NULL }
 };
 
 static u_int16_t
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 29dd05d..c39ab1a 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -44,7 +44,7 @@ static const struct option time_opts[] = {
 	{"monthdays", true,  NULL, 'm'},
 	{"localtz",   false, NULL, 'l'},
 	{"utc",       false, NULL, 'u'},
-	{NULL},
+	{ .name = NULL }
 };
 
 static void time_help(void)
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index e437f47..16a90ef 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -22,7 +22,7 @@ enum {
 
 static const struct option tos_mt_opts[] = {
 	{.name = "tos", .has_arg = true, .val = 't'},
-	{},
+	{ .name = NULL }
 };
 
 static void tos_mt_help(void)
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index d01864f..251b2d4 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -24,7 +24,7 @@
 
 static const struct option u32_opts[] = {
 	{"u32", 1, NULL, 'u'},
-	{NULL},
+	{ .name = NULL }
 };
 
 static void u32_help(void)
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index dd64a40..4e83ae8 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -26,7 +26,7 @@ static const struct option udp_opts[] = {
 	{ "sport", 1, NULL, '1' }, /* synonym */
 	{ "destination-port", 1, NULL, '2' },
 	{ "dport", 1, NULL, '2' }, /* synonym */
-	{ }
+	{ .name = NULL }
 };
 
 static void
diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index 014b65b..1630834 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -15,7 +15,7 @@ static const struct tos_symbol_info {
 	{IPTOS_RELIABILITY, "Maximize-Reliability"},
 	{IPTOS_MINCOST,     "Minimize-Cost"},
 	{IPTOS_NORMALSVC,   "Normal-Service"},
-	{},
+	{ .name = NULL }
 };
 
 /*
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index dc416a2..5069689 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -144,7 +144,7 @@ int ip6tc_set_counter(const ip6t_chainlabel chain,
 int ip6tc_commit(ip6tc_handle_t *handle);
 
 /* Get raw socket. */
-int ip6tc_get_raw_socket();
+int ip6tc_get_raw_socket(void);
 
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *ip6tc_strerror(int err);
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index f9f92d5..30f5b7d 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -154,7 +154,7 @@ int iptc_set_counter(const ipt_chainlabel chain,
 int iptc_commit(iptc_handle_t *handle);
 
 /* Get raw socket. */
-int iptc_get_raw_socket();
+int iptc_get_raw_socket(void);
 
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *iptc_strerror(int err);
diff --git a/ip6tables.c b/ip6tables.c
index acdb043..c542377 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1177,6 +1177,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 	struct in6_addr *saddrs = NULL, *daddrs = NULL;
 
 	int c, verbose = 0;
+	unsigned i;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1825,11 +1826,11 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 		e = NULL;
 	}
 
-	for (c = 0; c < nsaddrs; c++)
-		free(&saddrs[c]);
+	for (i = 0; i < nsaddrs; i++)
+		free(&saddrs[i]);
 
-	for (c = 0; c < ndaddrs; c++)
-		free(&daddrs[c]);
+	for (i = 0; i < ndaddrs; i++)
+		free(&daddrs[i]);
 
 	free_opts(1);
 
diff --git a/iptables-xml.c b/iptables-xml.c
index 2aefb1a..087b7c7 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -54,7 +54,7 @@ static struct option options[] = {
 	{"verbose", 0, 0, 'v'},
 	{"combine", 0, 0, 'c'},
 	{"help", 0, 0, 'h'},
-	{0}
+	{ .name = NULL }
 };
 
 static void
@@ -85,10 +85,10 @@ parse_counters(char *string, struct ipt_counters *ctr)
 
 /* global new argv and argc */
 static char *newargv[255];
-static int newargc = 0;
+static unsigned newargc = 0;
 
 static char *oldargv[255];
-static int oldargc = 0;
+static unsigned oldargc = 0;
 
 /* arg meta data, were they quoted, frinstance */
 static int newargvattr[255];
@@ -129,7 +129,7 @@ add_argv(char *what, int quoted)
 static void
 free_argv(void)
 {
-	int i;
+	unsigned i;
 
 	for (i = 0; i < newargc; i++) {
 		free(newargv[i]);
@@ -149,7 +149,7 @@ free_argv(void)
 static void
 save_argv(void)
 {
-	int i;
+	unsigned i;
 
 	for (i = 0; i < oldargc; i++)
 		free(oldargv[i]);
@@ -228,7 +228,7 @@ xmlAttrI(char *name, long long int num)
 }
 
 static void
-closeChain()
+closeChain(void)
 {
 	if (curChain[0] == 0)
 		return;
@@ -316,7 +316,7 @@ saveChain(char *chain, char *policy, struct ipt_counters *ctr)
 }
 
 static void
-finishChains()
+finishChains(void)
 {
 	int c;
 
@@ -331,7 +331,7 @@ finishChains()
 }
 
 static void
-closeTable()
+closeTable(void)
 {
 	closeChain();
 	finishChains();
@@ -536,7 +536,7 @@ do_rule_part(char *leveltag1, char *leveltag2, int part, int argc,
 }
 
 static int
-compareRules()
+compareRules(void)
 {
 	/* compare arguments up to -j or -g for match.
 	   NOTE: We don't want to combine actions if there were no criteria 
@@ -545,8 +545,8 @@ compareRules()
 	   is the case when processing the ACTUAL output of actual iptables-save 
 	   rather than a file merely in a compatable format */
 
-	int old = 0;
-	int new = 0;
+	unsigned old = 0;
+	unsigned new = 0;
 
 	int compare = 0;
 
@@ -748,7 +748,7 @@ main(int argc, char *argv[])
 
 			ret = 1;
 		} else if (curTable[0]) {
-			int a;
+			unsigned a;
 			char *ptr = buffer;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
diff --git a/xtables.c b/xtables.c
index eba453b..af4d3dc 100644
--- a/xtables.c
+++ b/xtables.c
@@ -257,10 +257,10 @@ int service_to_port(const char *name, const char *proto)
 
 u_int16_t parse_port(const char *port, const char *proto)
 {
-	unsigned int portnum;
+	unsigned portnum;
 
 	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
-	    (portnum = service_to_port(port, proto)) != -1)
+	    (portnum = service_to_port(port, proto)) != (unsigned)-1)
 		return (u_int16_t)portnum;
 
 	exit_error(PARAMETER_PROBLEM,


