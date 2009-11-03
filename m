From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] libxtables: hand argv to xtables_check_inverse
Date: Tue,  3 Nov 2009 21:58:19 +0100
Message-ID: <1257281901-5063-3-git-send-email-jengelh@medozas.de>
References: <1257281901-5063-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50742 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187AbZKCU6U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 15:58:20 -0500
In-Reply-To: <1257281901-5063-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In going to fix NF bug #611, "argv" is needed in
xtables_check_inverse to set "optarg" to the right spot in case of an
intrapositional negation.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=611
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac                    |    4 ++--
 extensions/libip6t_HL.c         |    2 +-
 extensions/libip6t_LOG.c        |    4 ++--
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    4 ++--
 extensions/libip6t_dst.c        |    4 ++--
 extensions/libip6t_frag.c       |    4 ++--
 extensions/libip6t_hbh.c        |    4 ++--
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_rt.c         |    8 ++++----
 extensions/libipt_DNAT.c        |    2 +-
 extensions/libipt_LOG.c         |    4 ++--
 extensions/libipt_MASQUERADE.c  |    2 +-
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |    2 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    2 +-
 extensions/libipt_SET.c         |    2 +-
 extensions/libipt_SNAT.c        |    2 +-
 extensions/libipt_TTL.c         |    2 +-
 extensions/libipt_ULOG.c        |    4 ++--
 extensions/libipt_addrtype.c    |    8 ++++----
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_ecn.c         |    6 +++---
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libipt_set.c         |    2 +-
 extensions/libipt_ttl.c         |    2 +-
 extensions/libxt_NFLOG.c        |    4 ++--
 extensions/libxt_cluster.c      |    4 ++--
 extensions/libxt_comment.c      |    2 +-
 extensions/libxt_connbytes.c    |    2 +-
 extensions/libxt_connlimit.c    |    2 +-
 extensions/libxt_connmark.c     |    2 +-
 extensions/libxt_conntrack.c    |   16 ++++++++--------
 extensions/libxt_dccp.c         |    8 ++++----
 extensions/libxt_dscp.c         |    4 ++--
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_hashlimit.c    |   16 ++++++++--------
 extensions/libxt_helper.c       |    2 +-
 extensions/libxt_iprange.c      |    4 ++--
 extensions/libxt_length.c       |    2 +-
 extensions/libxt_limit.c        |    4 ++--
 extensions/libxt_mac.c          |    2 +-
 extensions/libxt_mark.c         |    2 +-
 extensions/libxt_multiport.c    |   12 ++++++------
 extensions/libxt_physdev.c      |   10 +++++-----
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_policy.c       |    8 ++++----
 extensions/libxt_quota.c        |    2 +-
 extensions/libxt_rateest.c      |   20 ++++++++++----------
 extensions/libxt_recent.c       |    8 ++++----
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_string.c       |    4 ++--
 extensions/libxt_tcp.c          |    8 ++++----
 extensions/libxt_tcpmss.c       |    2 +-
 extensions/libxt_udp.c          |    4 ++--
 include/xtables.h.in            |    2 +-
 ip6tables.c                     |   10 +++++-----
 iptables.c                      |   10 +++++-----
 xtables.c                       |    3 ++-
 65 files changed, 143 insertions(+), 142 deletions(-)

diff --git a/configure.ac b/configure.ac
index 0419ea7..6091ba5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,8 +2,8 @@
 AC_INIT([iptables], [1.4.5])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=3
-libxtables_vage=1
+libxtables_vcurrent=4
+libxtables_vage=0
 
 AC_CONFIG_HEADERS([config.h])
 AC_CONFIG_MACRO_DIR([m4])
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 12d8e72..bff0611 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -39,7 +39,7 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 				"HL: You must specify a value");
 
-	if (xtables_check_inverse(optarg, &invert, NULL, 0))
+	if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 		xtables_error(PARAMETER_PROBLEM,
 				"HL: unexpected `!'");
 	
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index f713201..423d988 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -108,7 +108,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-level");
 
@@ -121,7 +121,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-prefix twice");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-prefix");
 
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 9ad3b68..b8195d7 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -83,7 +83,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --reject-with");
 		for (i = 0; i < ARRAY_SIZE(reject_table); ++i)
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 19b7ad4..474dd8f 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -86,7 +86,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_AH_SPI)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_ah_spis(argv[optind-1], ahinfo->spis);
 		if (invert)
 			ahinfo->invflags |= IP6T_AH_INV_SPI;
@@ -96,7 +96,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_AH_LEN)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahlen' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		ahinfo->hdrlen = parse_ah_spi(argv[optind-1], "length");
 		if (invert)
 			ahinfo->invflags |= IP6T_AH_INV_LEN;
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index a47e3a3..dfa4daf 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -125,7 +125,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_LEN)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-len' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
 		if (invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
@@ -136,7 +136,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_OPTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-opts' allowed");
-                xtables_check_inverse(optarg, &invert, &optind, 0);
+                xtables_check_inverse(optarg, &invert, &optind, 0, argv);
                 if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--dst-opts'");
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 905b494..8cc432b 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -94,7 +94,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_FRAG_IDS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fragid' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_frag_ids(argv[optind-1], fraginfo->ids);
 		if (invert)
 			fraginfo->invflags |= IP6T_FRAG_INV_IDS;
@@ -105,7 +105,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_FRAG_LEN)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fraglen' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		fraginfo->hdrlen = parse_frag_id(argv[optind-1], "length");
 		if (invert)
 			fraginfo->invflags |= IP6T_FRAG_INV_LEN;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index e08d84a..b7532b6 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -120,7 +120,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_LEN)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-len' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
 		if (invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
@@ -131,7 +131,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_OPTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-opts' allowed");
-                xtables_check_inverse(optarg, &invert, &optind, 0);
+                xtables_check_inverse(optarg, &invert, &optind, 0, argv);
                 if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--hbh-opts'");
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index ff76b74..1abada0 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -29,7 +29,7 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
 	u_int8_t value;
 
-	xtables_check_inverse(optarg, &invert, &optind, 0);
+	xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 	value = atoi(argv[optind-1]);
 
 	if (*flags) 
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index e41a670..3cee0f9 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -158,7 +158,7 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags == 1)
 			xtables_error(PARAMETER_PROBLEM,
 				   "icmpv6 match: only use --icmpv6-type once!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
 			     icmpv6info->code);
 		if (invert)
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 2674c8f..4a4e1df 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -185,7 +185,7 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 					"Only one `--header' allowed");
 
-			xtables_check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 			if (! (info->matchflags = parse_header(argv[optind-1])) )
 				xtables_error(PARAMETER_PROBLEM, "ip6t_ipv6header: cannot parse header names");
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 47d5544..b659c5d 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -133,7 +133,7 @@ static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & MH_TYPES)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--mh-type' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_mh_types(argv[optind-1], mhinfo->types);
 		if (invert)
 			mhinfo->invflags |= IP6T_MH_INV_TYPE;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index c9bf994..851a600 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -158,7 +158,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_RT_TYP)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-type' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		rtinfo->rt_type = parse_rt_num(argv[optind-1], "type");
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_TYP;
@@ -169,7 +169,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_RT_SGS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-segsleft' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_rt_segsleft(argv[optind-1], rtinfo->segsleft);
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_SGS;
@@ -180,7 +180,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_RT_LEN)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-len' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		rtinfo->hdrlen = parse_rt_num(argv[optind-1], "length");
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_LEN;
@@ -204,7 +204,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if ( !(*flags & IP6T_RT_TYP) || (rtinfo->rt_type != 0) || (rtinfo->invflags & IP6T_RT_INV_TYP) )
 			xtables_error(PARAMETER_PROBLEM,
 				   "`--rt-type 0' required before `--rt-0-addrs'");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   " '!' not allowed with `--rt-0-addrs'");
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 8b2caec..380294a 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -154,7 +154,7 @@ static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-destination");
 
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 5b90033..9afb91d 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -108,7 +108,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-level");
 
@@ -121,7 +121,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-prefix twice");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-prefix");
 
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 90084d8..9d7fc17 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -91,7 +91,7 @@ static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-ports");
 
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index f03c05b..b05022b 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -117,7 +117,7 @@ static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --%s", NETMAP_opts[0].name);
 
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 01f9d0f..d39f0bd 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -98,7 +98,7 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-ports");
 
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 888ff39..85d9e53 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -98,7 +98,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --reject-with");
 		for (i = 0; i < limit; i++) {
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 5cb0d3f..ed02ef9 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -92,7 +92,7 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Too many ranges specified, maximum "
 				   "is %i ranges.\n",
 				   IPT_SAME_MAX_RANGE);
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to");
 
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index d53fc1b..20daf3b 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -56,7 +56,7 @@ parse_target(char **argv, int invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 			   "--%s can be specified only once", what);
 
-	if (xtables_check_inverse(optarg, &invert, NULL, 0))
+	if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 		xtables_error(PARAMETER_PROBLEM,
 			   "Unexpected `!' after --%s", what);
 
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index e592d80..f7c93d8 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -154,7 +154,7 @@ static int SNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-source");
 
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 0e2be0b..4db9bbe 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -39,7 +39,7 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 				"TTL: You must specify a value");
 
-	if (xtables_check_inverse(optarg, &invert, NULL, 0))
+	if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 		xtables_error(PARAMETER_PROBLEM,
 				"TTL: unexpected `!'");
 	
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 3fa91f2..4d009b7 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -76,7 +76,7 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-nlgroup twice");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ulog-nlgroup");
 		group_d = atoi(optarg);
@@ -94,7 +94,7 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-prefix twice");
 
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ulog-prefix");
 
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index cda7051..c305281 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -106,7 +106,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags&IPT_ADDRTYPE_OPT_SRCTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(argv[optind-1], &info->source);
 		if (invert)
 			info->invert_source = 1;
@@ -116,7 +116,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags&IPT_ADDRTYPE_OPT_DSTTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(argv[optind-1], &info->dest);
 		if (invert)
 			info->invert_dest = 1;
@@ -141,7 +141,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(argv[optind-1], &info->source);
 		if (invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
@@ -151,7 +151,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_types(argv[optind-1], &info->dest);
 		if (invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index d049b42..a2239f6 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -82,7 +82,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & AH_SPI)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_ah_spis(argv[optind-1], ahinfo->spis);
 		if (invert)
 			ahinfo->invflags |= IPT_AH_INV_SPI;
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 3ee190e..ec3ff2d 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -43,7 +43,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_MATCH_CWR)
 			xtables_error(PARAMETER_PROBLEM,
 			           "ECN match: can only use parameter ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		einfo->operation |= IPT_ECN_OP_MATCH_CWR;
 		if (invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_CWR;
@@ -54,7 +54,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_MATCH_ECE)
 			xtables_error(PARAMETER_PROBLEM,
 				   "ECN match: can only use parameter ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		einfo->operation |= IPT_ECN_OP_MATCH_ECE;
 		if (invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_ECE;
@@ -65,7 +65,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_MATCH_IP)
 			xtables_error(PARAMETER_PROBLEM,
 				   "ECN match: can only use parameter ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_IP;
 		*flags |= IPT_ECN_OP_MATCH_IP;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 5667955..b109c8e 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -183,7 +183,7 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags == 1)
 			xtables_error(PARAMETER_PROBLEM,
 				   "icmp match: only use --icmp-type once!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_icmp(argv[optind-1], &icmpinfo->type, 
 			   icmpinfo->code);
 		if (invert)
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index be1943e..8eb2067 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -156,7 +156,7 @@ static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		char *end;
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		end = optarg = argv[optind-1];
 		realminfo->id = strtoul(optarg, &end, 0);
 		if (end != optarg && (*end == '/' || *end == '\0')) {
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 5075359..d2bb78e 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -64,7 +64,7 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "--match-set can be specified only once");
 
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			info->flags[0] |= IPSET_MATCH_INV;
 
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 019a556..e2fbcd5 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -28,7 +28,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
 	unsigned int value;
 
-	xtables_check_inverse(optarg, &invert, &optind, 0);
+	xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 	switch (c) {
 		case '2':
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 0768e88..e2185d5 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -51,7 +51,7 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & NFLOG_GROUP)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-group twice");
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --nflog-group");
 
@@ -65,7 +65,7 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & NFLOG_PREFIX)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-prefix twice");
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --nflog-prefix");
 
diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index c80afe6..ea5d9fb 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -80,7 +80,7 @@ cluster_parse(int c, char **argv, int invert, unsigned int *flags,
 				      "`--cluster-local-nodemask' and "
 				      "`--cluster-local-node'");
 		}
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (!xtables_strtoui(optarg, NULL, &num, 1,
 				     XT_CLUSTER_NODES_MAX)) {
@@ -105,7 +105,7 @@ cluster_parse(int c, char **argv, int invert, unsigned int *flags,
 				      "`--cluster-local-nodemask' and "
 				      "`--cluster-local-node'");
 		}
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (!xtables_strtoui(optarg, NULL, &num, 1,
 				     XT_CLUSTER_NODES_MAX)) {
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 2e665b1..e0e70b6 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -46,7 +46,7 @@ comment_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		if (invert) {
 			xtables_error(PARAMETER_PROBLEM,
 					"Sorry, you can't have an inverted comment");
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index d6c3b1b..48a79eb 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -52,7 +52,7 @@ connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (xtables_check_inverse(optarg, &invert, &optind, 0))
+		if (xtables_check_inverse(optarg, &invert, &optind, 0, argv))
 			optind++;
 
 		parse_range(argv[optind-1], sinfo);
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 1698561..6f24d51 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -65,7 +65,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				"--connlimit-above may be given only once");
 		*flags |= 0x1;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		info->limit   = strtoul(argv[optind-1], NULL, 0);
 		info->inverse = invert;
 		break;
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 48c10b5..bbe3596 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -82,7 +82,7 @@ connmark_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		char *end;
 	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		markinfo->mark = strtoul(optarg, &end, 0);
 		markinfo->mask = 0xffffffffUL;
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index c9f8182..c4be9b1 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -298,7 +298,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		parse_states(argv[optind-1], sinfo);
 		if (invert) {
@@ -308,7 +308,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '2':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if(invert)
 			sinfo->invflags |= XT_CONNTRACK_PROTO;
@@ -330,7 +330,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '3':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGSRC;
@@ -350,7 +350,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '4':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGDST;
@@ -370,7 +370,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '5':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLSRC;
@@ -390,7 +390,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '6':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLDST;
@@ -410,7 +410,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '7':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		parse_statuses(argv[optind-1], sinfo);
 		if (invert) {
@@ -420,7 +420,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '8':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		parse_expires(argv[optind-1], sinfo);
 		if (invert) {
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index ae23225..f2beb7f 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -140,7 +140,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_DCCP_SRC_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_dccp_ports(argv[optind-1], einfo->spts);
 		if (invert)
 			einfo->invflags |= XT_DCCP_SRC_PORTS;
@@ -152,7 +152,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_DCCP_DEST_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_dccp_ports(argv[optind-1], einfo->dpts);
 		if (invert)
 			einfo->invflags |= XT_DCCP_DEST_PORTS;
@@ -164,7 +164,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dccp-types' allowed");
 		einfo->flags |= XT_DCCP_TYPE;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		einfo->typemask = parse_dccp_types(argv[optind-1]);
 		if (invert)
 			einfo->invflags |= XT_DCCP_TYPE;
@@ -176,7 +176,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dccp-option' allowed");
 		einfo->flags |= XT_DCCP_OPTION;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		einfo->option = parse_dccp_option(argv[optind-1]);
 		if (invert)
 			einfo->invflags |= XT_DCCP_OPTION;
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 306643e..03e4763 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -82,7 +82,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			xtables_error(PARAMETER_PROBLEM,
 			           "DSCP match: Only use --dscp ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_dscp(argv[optind-1], dinfo);
 		if (invert)
 			dinfo->invert = 1;
@@ -93,7 +93,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			xtables_error(PARAMETER_PROBLEM,
 					"DSCP match: Only use --dscp-class ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_class(argv[optind - 1], dinfo);
 		if (invert)
 			dinfo->invert = 1;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 89c3fb4..6655ec9 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -88,7 +88,7 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & ESP_SPI)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--espspi' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_esp_spis(argv[optind-1], espinfo->spis);
 		if (invert)
 			espinfo->invflags |= XT_ESP_INV_SPI;
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index cdb407a..5ff1ae0 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -219,7 +219,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '%':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit",
 		          *flags & PARAM_LIMIT);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!parse_rate(optarg, &r->cfg.avg))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
@@ -229,7 +229,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '$':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
 		          *flags & PARAM_BURST);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-burst `%s'", optarg);
@@ -239,7 +239,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '&':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-size: `%s'", optarg);
@@ -249,7 +249,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '*':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-max: `%s'", optarg);
@@ -260,7 +260,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-gcinterval: `%s'", 
@@ -272,7 +272,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case ')':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-expire: `%s'", optarg);
@@ -283,7 +283,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '_':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (parse_mode(&r->cfg.mode, optarg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-mode: `%s'\n", optarg);
@@ -292,7 +292,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '"':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
 		          *flags & PARAM_NAME);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (strlen(optarg) == 0)
 			xtables_error(PARAMETER_PROBLEM, "Zero-length name?");
 		strncpy(r->name, optarg, sizeof(r->name));
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index adced43..35b5f15 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -31,7 +31,7 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			xtables_error(PARAMETER_PROBLEM,
 					"helper match: Only use --helper ONCE!");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		strncpy(info->name, optarg, 29);
 		info->name[29] = '\0';
 		if (invert)
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 9e544ea..2cf7a17 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -92,7 +92,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= IPRANGE_SRC;
 
 		info->flags |= IPRANGE_SRC;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			info->flags |= IPRANGE_SRC_INV;
 		iprange_parse_range(optarg, range, NFPROTO_IPV4, "--src-range");
@@ -106,7 +106,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= IPRANGE_DST;
 
 		info->flags |= IPRANGE_DST;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			info->flags |= IPRANGE_DST_INV;
 
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 0f954cf..7b049ce 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -70,7 +70,7 @@ length_parse(int c, char **argv, int invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 				           "length: `--length' may only be "
 				           "specified once");
-			xtables_check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 			parse_lengths(argv[optind-1], info);
 			if (invert)
 				info->invert = 1;
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 8ca921c..d4baf5f 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -94,14 +94,14 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '%':
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!parse_rate(optarg, &r->avg))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
 		break;
 
 	case '$':
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad --limit-burst `%s'", optarg);
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 449fff9..2722ef0 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -57,7 +57,7 @@ mac_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_mac(argv[optind-1], macinfo);
 		if (invert)
 			macinfo->invert = 1;
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index fc3d646..691cd04 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -62,7 +62,7 @@ mark_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		char *end;
 	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		markinfo->mark = strtoul(optarg, &end, 0);
 		if (*end == '/') {
 			markinfo->mask = strtoul(end+1, &end, 0);
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index d9b6e74..2be0700 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -164,7 +164,7 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -172,7 +172,7 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '2':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -180,7 +180,7 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '3':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -231,21 +231,21 @@ __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
 
 	case '2':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
 
 	case '3':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 74d311d..bd10766 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -43,7 +43,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1':
 		if (*flags & XT_PHYSDEV_OP_IN)
 			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		xtables_parse_interface(argv[optind-1], info->physindev,
 				(unsigned char *)info->in_mask);
 		if (invert)
@@ -55,7 +55,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '2':
 		if (*flags & XT_PHYSDEV_OP_OUT)
 			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		xtables_parse_interface(argv[optind-1], info->physoutdev,
 				(unsigned char *)info->out_mask);
 		if (invert)
@@ -67,7 +67,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		if (*flags & XT_PHYSDEV_OP_ISIN)
 			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		info->bitmask |= XT_PHYSDEV_OP_ISIN;
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_ISIN;
@@ -77,7 +77,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '4':
 		if (*flags & XT_PHYSDEV_OP_ISOUT)
 			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		info->bitmask |= XT_PHYSDEV_OP_ISOUT;
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_ISOUT;
@@ -87,7 +87,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '5':
 		if (*flags & XT_PHYSDEV_OP_BRIDGED)
 			goto multiple_use;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_BRIDGED;
 		*flags |= XT_PHYSDEV_OP_BRIDGED;
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 7586c7f..b9cb93c 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -87,7 +87,7 @@ static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch(c)
 	{
 		case '1':
-			xtables_check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 			parse_pkttype(argv[optind-1], info);
 			if(invert)
 				info->invert=1;
diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 858eaaa..521bac1 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -118,7 +118,7 @@ static int parse_mode(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
-static int policy_parse(int c, int invert, unsigned int *flags,
+static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
                         struct xt_policy_info *info, uint8_t family)
 {
 	struct xt_policy_elem *e = &info->pol[info->len];
@@ -127,7 +127,7 @@ static int policy_parse(int c, int invert, unsigned int *flags,
 	unsigned int naddr = 0, num;
 	int mode;
 
-	xtables_check_inverse(optarg, &invert, &optind, 0);
+	xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 	switch (c) {
 	case '1':
@@ -269,14 +269,14 @@ static int policy_parse(int c, int invert, unsigned int *flags,
 static int policy4_parse(int c, char **argv, int invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
-	return policy_parse(c, invert, flags, (void *)(*match)->data,
+	return policy_parse(c, argv, invert, flags, (void *)(*match)->data,
 	       NFPROTO_IPV4);
 }
 
 static int policy6_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
-	return policy_parse(c, invert, flags, (void *)(*match)->data,
+	return policy_parse(c, argv, invert, flags, (void *)(*match)->data,
 	       NFPROTO_IPV6);
 }
 
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 0ccc94b..69d2746 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -60,7 +60,7 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (xtables_check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
 			xtables_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
 		if (!parse_quota(optarg, &info->quota))
 			xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 54a7579..b105529 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -118,7 +118,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case OPT_RATEEST1:
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
@@ -132,7 +132,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST2:
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
@@ -147,7 +147,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_BPS1:
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
@@ -171,7 +171,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_PPS1:
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
@@ -196,7 +196,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_BPS2:
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
@@ -220,7 +220,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_PPS2:
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
@@ -245,7 +245,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_DELTA:
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-delta can't be inverted");
@@ -259,7 +259,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_EQ:
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
@@ -272,7 +272,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_LT:
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
@@ -285,7 +285,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_GT:
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0, argv);
 
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index d503685..5add228 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -73,7 +73,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 			info->check_set |= XT_RECENT_SET;
 			if (invert) info->invert = 1;
 			*flags |= XT_RECENT_SET;
@@ -84,7 +84,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 			info->check_set |= XT_RECENT_CHECK;
 			if(invert) info->invert = 1;
 			*flags |= XT_RECENT_CHECK;
@@ -95,7 +95,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 			info->check_set |= XT_RECENT_UPDATE;
 			if (invert) info->invert = 1;
 			*flags |= XT_RECENT_UPDATE;
@@ -106,7 +106,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			xtables_check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 			info->check_set |= XT_RECENT_REMOVE;
 			if (invert) info->invert = 1;
 			*flags |= XT_RECENT_REMOVE;
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index dfa72d3..f4844e3 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -257,7 +257,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_SCTP_SRC_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_sctp_ports(argv[optind-1], einfo->spts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_SRC_PORTS;
@@ -269,7 +269,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_SCTP_DEST_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_sctp_ports(argv[optind-1], einfo->dpts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_DEST_PORTS;
@@ -280,7 +280,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & XT_SCTP_CHUNK_TYPES)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--chunk-types' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (!argv[optind] 
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index c8a7454..94ef6b7 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -71,7 +71,7 @@ state_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		state_parse_states(argv[optind-1], sinfo);
 		if (invert)
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 62c3a97..ce2d30d 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -202,7 +202,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & STRING)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --string");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_string(argv[optind-1], stringinfo);
 		if (invert) {
 			if (revision == 0)
@@ -218,7 +218,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --hex-string");
 
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */
 		if (invert) {
 			if (revision == 0)
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 7abecc1..0f3e27d 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -147,7 +147,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_SRC_PORTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_tcp_ports(argv[optind-1], tcpinfo->spts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_SRCPT;
@@ -158,7 +158,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_DST_PORTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_tcp_ports(argv[optind-1], tcpinfo->dpts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_DSTPT;
@@ -179,7 +179,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one of `--syn' or `--tcp-flags' "
 				   " allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
 		if (!argv[optind]
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
@@ -196,7 +196,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_OPTION)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--tcp-option' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_tcp_option(argv[optind-1], &tcpinfo->option);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_OPTION;
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 36785a3..35ddcd6 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -65,7 +65,7 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--mss' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_tcp_mssvalues(argv[optind-1],
 				    &mssinfo->mss_min, &mssinfo->mss_max);
 		if (invert)
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index bf0b34f..8a80b6e 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -72,7 +72,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & UDP_SRC_PORTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_udp_ports(argv[optind-1], udpinfo->spts);
 		if (invert)
 			udpinfo->invflags |= XT_UDP_INV_SRCPT;
@@ -83,7 +83,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & UDP_DST_PORTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_udp_ports(argv[optind-1], udpinfo->dpts);
 		if (invert)
 			udpinfo->invflags |= XT_UDP_INV_DSTPT;
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 3955716..788ad7d 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -246,7 +246,7 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 #define aligned_u64 u_int64_t __attribute__((aligned(8)))
 
 int xtables_check_inverse(const char option[], int *invert,
-	int *my_optind, int argc);
+	int *my_optind, int argc, char **argv);
 extern struct xtables_globals *xt_params;
 #define xtables_error (xt_params->exit_err)
 
diff --git a/ip6tables.c b/ip6tables.c
index 53a1a5d..36d10e5 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1492,7 +1492,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			 * Option selection
 			 */
 		case 'p':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_PROTOCOL, &fw.ipv6.invflags,
 				   invert);
 
@@ -1518,14 +1518,14 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 's':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_SOURCE, &fw.ipv6.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_DESTINATION, &fw.ipv6.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
@@ -1571,7 +1571,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 
 		case 'i':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEIN, &fw.ipv6.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
@@ -1580,7 +1580,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 'o':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ipv6.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
diff --git a/iptables.c b/iptables.c
index 1160171..d778c12 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1515,7 +1515,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			 * Option selection
 			 */
 		case 'p':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_PROTOCOL, &fw.ip.invflags,
 				   invert);
 
@@ -1533,14 +1533,14 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 's':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_SOURCE, &fw.ip.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_DESTINATION, &fw.ip.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
@@ -1586,7 +1586,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 
 		case 'i':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEIN, &fw.ip.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
@@ -1595,7 +1595,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 'o':
-			xtables_check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ip.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
diff --git a/xtables.c b/xtables.c
index 35a87e8..63c5db7 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1643,7 +1643,7 @@ void xtables_save_string(const char *value)
  * Do not use in new code.
  */
 int xtables_check_inverse(const char option[], int *invert,
-			  int *my_optind, int argc)
+			  int *my_optind, int argc, char **argv)
 {
 	if (option == NULL || strcmp(option, "!") != 0)
 		return false;
@@ -1657,6 +1657,7 @@ int xtables_check_inverse(const char option[], int *invert,
 			   "Multiple `!' flags not allowed");
 	*invert = true;
 	if (my_optind != NULL) {
+		optarg = argv[*my_optind];
 		++*my_optind;
 		if (argc && *my_optind > argc)
 			xt_params->exit_err(PARAMETER_PROBLEM,
-- 
1.6.5.2

