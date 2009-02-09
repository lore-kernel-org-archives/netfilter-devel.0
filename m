From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/16] libxtables: prefix/order - move check_inverse to xtables.c
Date: Mon,  9 Feb 2009 18:34:58 +0100
Message-ID: <1234200900-5964-15-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51474 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755707AbZBIRfH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:07 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This also adds a warning that intrapositional negation support
is deprecated.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
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
 extensions/libip6t_policy.c     |    2 +-
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
 extensions/libipt_policy.c      |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libipt_set.c         |    2 +-
 extensions/libipt_ttl.c         |    2 +-
 extensions/libxt_NFLOG.c        |    4 ++--
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
 extensions/libxt_quota.c        |    2 +-
 extensions/libxt_rateest.c      |   20 ++++++++++----------
 extensions/libxt_recent.c       |    8 ++++----
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_string.c       |    4 ++--
 extensions/libxt_tcp.c          |    8 ++++----
 extensions/libxt_tcpmss.c       |    2 +-
 extensions/libxt_udp.c          |    4 ++--
 include/xtables.h.in            |    3 ++-
 ip6tables.c                     |   30 +++++-------------------------
 iptables.c                      |   30 +++++-------------------------
 xtables.c                       |   28 ++++++++++++++++++++++++++++
 64 files changed, 164 insertions(+), 175 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 4aed4fd..0a98713 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -40,7 +40,7 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 		exit_error(PARAMETER_PROBLEM, 
 				"HL: You must specify a value");
 
-	if (check_inverse(optarg, &invert, NULL, 0))
+	if (xtables_check_inverse(optarg, &invert, NULL, 0))
 		exit_error(PARAMETER_PROBLEM,
 				"HL: unexpected `!'");
 	
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index a8ac135..7987735 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -112,7 +112,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-level");
 
@@ -125,7 +125,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-prefix twice");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-prefix");
 
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 0e21202..1c2be68 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -85,7 +85,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '1':
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --reject-with");
 		for (i = 0; i < limit; i++) {
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 63d1573..83ed451 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -86,7 +86,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_AH_SPI)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_ah_spis(argv[optind-1], ahinfo->spis);
 		if (invert)
 			ahinfo->invflags |= IP6T_AH_INV_SPI;
@@ -96,7 +96,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_AH_LEN)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--ahlen' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		ahinfo->hdrlen = parse_ah_spi(argv[optind-1], "length");
 		if (invert)
 			ahinfo->invflags |= IP6T_AH_INV_LEN;
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 43562c1..e19abc4 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -125,7 +125,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_LEN)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-len' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
 		if (invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
@@ -136,7 +136,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_OPTS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-opts' allowed");
-                check_inverse(optarg, &invert, &optind, 0);
+                xtables_check_inverse(optarg, &invert, &optind, 0);
                 if (invert)
                         exit_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--dst-opts'");
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 7c22429..b55ef26 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -94,7 +94,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_FRAG_IDS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--fragid' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_frag_ids(argv[optind-1], fraginfo->ids);
 		if (invert)
 			fraginfo->invflags |= IP6T_FRAG_INV_IDS;
@@ -105,7 +105,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_FRAG_LEN)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--fraglen' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		fraginfo->hdrlen = parse_frag_id(argv[optind-1], "length");
 		if (invert)
 			fraginfo->invflags |= IP6T_FRAG_INV_LEN;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 6c7458d..3354eae 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -120,7 +120,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_LEN)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-len' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
 		if (invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
@@ -131,7 +131,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_OPTS_OPTS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-opts' allowed");
-                check_inverse(optarg, &invert, &optind, 0);
+                xtables_check_inverse(optarg, &invert, &optind, 0);
                 if (invert)
                         exit_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--hbh-opts'");
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 7727581..286f432 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -30,7 +30,7 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
 	u_int8_t value;
 
-	check_inverse(optarg, &invert, &optind, 0);
+	xtables_check_inverse(optarg, &invert, &optind, 0);
 	value = atoi(argv[optind-1]);
 
 	if (*flags) 
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 401c278..5af9b02 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -157,7 +157,7 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags == 1)
 			exit_error(PARAMETER_PROBLEM,
 				   "icmpv6 match: only use --icmpv6-type once!");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
 			     icmpv6info->code);
 		if (invert)
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index ea8870a..982e6a7 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -192,7 +192,7 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 				exit_error(PARAMETER_PROBLEM,
 					"Only one `--header' allowed");
 
-			check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0);
 
 			if (! (info->matchflags = parse_header(argv[optind-1])) )
 				exit_error(PARAMETER_PROBLEM, "ip6t_ipv6header: cannot parse header names");
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index f8c4e24..78fc804 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -134,7 +134,7 @@ static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & MH_TYPES)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--mh-type' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_mh_types(argv[optind-1], mhinfo->types);
 		if (invert)
 			mhinfo->invflags |= IP6T_MH_INV_TYPE;
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index fa855c1..83ee48e 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -160,7 +160,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 	unsigned int naddr = 0;
 	int mode;
 
-	check_inverse(optarg, &invert, &optind, 0);
+	xtables_check_inverse(optarg, &invert, &optind, 0);
 
 	switch (c) {
 	case '1':
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 49d86fa..64c98ef 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -158,7 +158,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_RT_TYP)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-type' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		rtinfo->rt_type = parse_rt_num(argv[optind-1], "type");
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_TYP;
@@ -169,7 +169,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_RT_SGS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-segsleft' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_rt_segsleft(argv[optind-1], rtinfo->segsleft);
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_SGS;
@@ -180,7 +180,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IP6T_RT_LEN)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-len' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		rtinfo->hdrlen = parse_rt_num(argv[optind-1], "length");
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_LEN;
@@ -204,7 +204,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if ( !(*flags & IP6T_RT_TYP) || (rtinfo->rt_type != 0) || (rtinfo->invflags & IP6T_RT_INV_TYP) )
 			exit_error(PARAMETER_PROBLEM,
 				   "`--rt-type 0' required before `--rt-0-addrs'");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   " '!' not allowed with `--rt-0-addrs'");
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 0d355a0..371ec79 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -152,7 +152,7 @@ static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-destination");
 
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 23790a0..bc7e8a4 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -112,7 +112,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-level");
 
@@ -125,7 +125,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-prefix twice");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-prefix");
 
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 1f93294..0ee155c 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -90,7 +90,7 @@ static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-ports");
 
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index f6c8bfd..9949c99 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -118,7 +118,7 @@ static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --%s", NETMAP_opts[0].name);
 
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 1ef2b2e..c6afbdc 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -97,7 +97,7 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-ports");
 
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index ef404e6..db94306 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -99,7 +99,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '1':
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --reject-with");
 		for (i = 0; i < limit; i++) {
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 6882242..007ebc3 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -93,7 +93,7 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Too many ranges specified, maximum "
 				   "is %i ranges.\n",
 				   IPT_SAME_MAX_RANGE);
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to");
 
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 7ec0c31..45967be 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -57,7 +57,7 @@ parse_target(char **argv, int invert, unsigned int *flags,
 		exit_error(PARAMETER_PROBLEM,
 			   "--%s can be specified only once", what);
 
-	if (check_inverse(optarg, &invert, NULL, 0))
+	if (xtables_check_inverse(optarg, &invert, NULL, 0))
 		exit_error(PARAMETER_PROBLEM,
 			   "Unexpected `!' after --%s", what);
 
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 0780aa1..96ef56e 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -152,7 +152,7 @@ static int SNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-source");
 
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 6036161..15d23ba 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -40,7 +40,7 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 		exit_error(PARAMETER_PROBLEM, 
 				"TTL: You must specify a value");
 
-	if (check_inverse(optarg, &invert, NULL, 0))
+	if (xtables_check_inverse(optarg, &invert, NULL, 0))
 		exit_error(PARAMETER_PROBLEM,
 				"TTL: unexpected `!'");
 	
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 6e346d8..89d0940 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -77,7 +77,7 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-nlgroup twice");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ulog-nlgroup");
 		group_d = atoi(optarg);
@@ -95,7 +95,7 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-prefix twice");
 
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ulog-prefix");
 
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index dc43a3f..446cf0f 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -107,7 +107,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags&IPT_ADDRTYPE_OPT_SRCTYPE)
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->source);
 		if (invert)
 			info->invert_source = 1;
@@ -117,7 +117,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags&IPT_ADDRTYPE_OPT_DSTTYPE)
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->dest);
 		if (invert)
 			info->invert_dest = 1;
@@ -142,7 +142,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->source);
 		if (invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
@@ -152,7 +152,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
 			exit_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->dest);
 		if (invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 10998d8..31977dd 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -82,7 +82,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & AH_SPI)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_ah_spis(argv[optind-1], ahinfo->spis);
 		if (invert)
 			ahinfo->invflags |= IPT_AH_INV_SPI;
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index c2276e9..3b9da71 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -44,7 +44,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_MATCH_CWR)
 			exit_error(PARAMETER_PROBLEM,
 			           "ECN match: can only use parameter ONCE!");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		einfo->operation |= IPT_ECN_OP_MATCH_CWR;
 		if (invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_CWR;
@@ -55,7 +55,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_MATCH_ECE)
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN match: can only use parameter ONCE!");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		einfo->operation |= IPT_ECN_OP_MATCH_ECE;
 		if (invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_ECE;
@@ -66,7 +66,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_MATCH_IP)
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN match: can only use parameter ONCE!");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			einfo->invert |= IPT_ECN_OP_MATCH_IP;
 		*flags |= IPT_ECN_OP_MATCH_IP;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index de4c338..0fd132b 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -182,7 +182,7 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags == 1)
 			exit_error(PARAMETER_PROBLEM,
 				   "icmp match: only use --icmp-type once!");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_icmp(argv[optind-1], &icmpinfo->type, 
 			   icmpinfo->code);
 		if (invert)
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index c9ce850..742eeba 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -128,7 +128,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 	unsigned int naddr = 0;
 	int mode;
 
-	check_inverse(optarg, &invert, &optind, 0);
+	xtables_check_inverse(optarg, &invert, &optind, 0);
 
 	switch (c) {
 	case '1':
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 22cbe27..e602dad 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -157,7 +157,7 @@ static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		char *end;
 	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		end = optarg = argv[optind-1];
 		realminfo->id = strtoul(optarg, &end, 0);
 		if (end != optarg && (*end == '/' || *end == '\0')) {
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 9bdb007..5b9e1fd 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -58,7 +58,7 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "--set can be specified only once");
 
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			info->flags[0] |= IPSET_MATCH_INV;
 
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 1fa7bd3..3387e92 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -29,7 +29,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
 	unsigned int value;
 
-	check_inverse(optarg, &invert, &optind, 0);
+	xtables_check_inverse(optarg, &invert, &optind, 0);
 
 	switch (c) {
 		case '2':
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index bedfbe9..6d8c9dc 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -51,7 +51,7 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & NFLOG_GROUP)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-group twice");
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --nflog-group");
 
@@ -65,7 +65,7 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & NFLOG_PREFIX)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-prefix twice");
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --nflog-prefix");
 
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index a7f96d4..9bad125 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -46,7 +46,7 @@ comment_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		if (invert) {
 			exit_error(PARAMETER_PROBLEM,
 					"Sorry, you can't have an inverted comment");
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index b77ba38..5fc0f2a 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -52,7 +52,7 @@ connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (check_inverse(optarg, &invert, &optind, 0))
+		if (xtables_check_inverse(optarg, &invert, &optind, 0))
 			optind++;
 
 		parse_range(argv[optind-1], sinfo);
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 117222a..f43eada 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -63,7 +63,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				"--connlimit-above may be given only once");
 		*flags |= 0x1;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		info->limit   = strtoul(argv[optind-1], NULL, 0);
 		info->inverse = invert;
 		break;
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 0f47a8f..d5ca4e0 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -82,7 +82,7 @@ connmark_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		char *end;
 	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		markinfo->mark = strtoul(optarg, &end, 0);
 		markinfo->mask = 0xffffffffUL;
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 958f842..914b253 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -297,7 +297,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		parse_states(argv[optind-1], sinfo);
 		if (invert) {
@@ -307,7 +307,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '2':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if(invert)
 			sinfo->invflags |= XT_CONNTRACK_PROTO;
@@ -328,7 +328,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '3':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGSRC;
@@ -348,7 +348,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '4':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGDST;
@@ -368,7 +368,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '5':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLSRC;
@@ -388,7 +388,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '6':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLDST;
@@ -408,7 +408,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '7':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		parse_statuses(argv[optind-1], sinfo);
 		if (invert) {
@@ -418,7 +418,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '8':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		parse_expires(argv[optind-1], sinfo);
 		if (invert) {
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 9be0658..dbf6223 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -141,7 +141,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_DCCP_SRC_PORTS;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_dccp_ports(argv[optind-1], einfo->spts);
 		if (invert)
 			einfo->invflags |= XT_DCCP_SRC_PORTS;
@@ -153,7 +153,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_DCCP_DEST_PORTS;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_dccp_ports(argv[optind-1], einfo->dpts);
 		if (invert)
 			einfo->invflags |= XT_DCCP_DEST_PORTS;
@@ -165,7 +165,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--dccp-types' allowed");
 		einfo->flags |= XT_DCCP_TYPE;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		einfo->typemask = parse_dccp_types(argv[optind-1]);
 		if (invert)
 			einfo->invflags |= XT_DCCP_TYPE;
@@ -177,7 +177,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--dccp-option' allowed");
 		einfo->flags |= XT_DCCP_OPTION;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		einfo->option = parse_dccp_option(argv[optind-1]);
 		if (invert)
 			einfo->invflags |= XT_DCCP_OPTION;
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index fce14c2..e57c267 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -82,7 +82,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 			           "DSCP match: Only use --dscp ONCE!");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_dscp(argv[optind-1], dinfo);
 		if (invert)
 			dinfo->invert = 1;
@@ -93,7 +93,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 					"DSCP match: Only use --dscp-class ONCE!");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_class(argv[optind - 1], dinfo);
 		if (invert)
 			dinfo->invert = 1;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 34df876..2cc6b60 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -88,7 +88,7 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & ESP_SPI)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--espspi' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_esp_spis(argv[optind-1], espinfo->spis);
 		if (invert)
 			espinfo->invflags |= XT_ESP_INV_SPI;
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index f63db64..b05e8c8 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -219,7 +219,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '%':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit",
 		          *flags & PARAM_LIMIT);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->cfg.avg))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
@@ -229,7 +229,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '$':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
 		          *flags & PARAM_BURST);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-burst `%s'", optarg);
@@ -239,7 +239,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '&':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-size: `%s'", optarg);
@@ -249,7 +249,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '*':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-max: `%s'", optarg);
@@ -260,7 +260,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-gcinterval: `%s'", 
@@ -272,7 +272,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case ')':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-expire: `%s'", optarg);
@@ -283,7 +283,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '_':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (parse_mode(&r->cfg.mode, optarg) < 0)
 			exit_error(PARAMETER_PROBLEM, 
 				   "bad --hashlimit-mode: `%s'\n", optarg);
@@ -292,7 +292,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '"':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
 		          *flags & PARAM_NAME);
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (strlen(optarg) == 0)
 			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
 		strncpy(r->name, optarg, sizeof(r->name));
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 23025cd..569ad69 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -31,7 +31,7 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 					"helper match: Only use --helper ONCE!");
-		check_inverse(optarg, &invert, &invert, 0);
+		xtables_check_inverse(optarg, &invert, &invert, 0);
 		strncpy(info->name, optarg, 29);
 		info->name[29] = '\0';
 		if (invert)
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index de079cb..df6be14 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -70,7 +70,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= IPRANGE_SRC;
 
 		info->flags |= IPRANGE_SRC;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			info->flags |= IPRANGE_SRC_INV;
 		parse_iprange(optarg, &info->src);
@@ -84,7 +84,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= IPRANGE_DST;
 
 		info->flags |= IPRANGE_DST;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			info->flags |= IPRANGE_DST_INV;
 
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index d039904..cf944e2 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -70,7 +70,7 @@ length_parse(int c, char **argv, int invert, unsigned int *flags,
 				exit_error(PARAMETER_PROBLEM,
 				           "length: `--length' may only be "
 				           "specified once");
-			check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0);
 			parse_lengths(argv[optind-1], info);
 			if (invert)
 				info->invert = 1;
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 1df9114..7edfa3d 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -94,14 +94,14 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '%':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->avg))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
 		break;
 
 	case '$':
-		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad --limit-burst `%s'", optarg);
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index f4128c0..b516d80 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -57,7 +57,7 @@ mac_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_mac(argv[optind-1], macinfo);
 		if (invert)
 			macinfo->invert = 1;
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 08bc9d9..1143ba9 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -62,7 +62,7 @@ mark_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		char *end;
 	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		markinfo->mark = strtoul(optarg, &end, 0);
 		if (*end == '/') {
 			markinfo->mask = strtoul(end+1, &end, 0);
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index a7db2a8..d0e830d 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -161,7 +161,7 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -169,7 +169,7 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '2':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -177,7 +177,7 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '3':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -228,21 +228,21 @@ __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
 
 	case '2':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
 
 	case '3':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 6152cb3..4275a1a 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -43,7 +43,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1':
 		if (*flags & XT_PHYSDEV_OP_IN)
 			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		xtables_parse_interface(argv[optind-1], info->physindev,
 				(unsigned char *)info->in_mask);
 		if (invert)
@@ -55,7 +55,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '2':
 		if (*flags & XT_PHYSDEV_OP_OUT)
 			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		xtables_parse_interface(argv[optind-1], info->physoutdev,
 				(unsigned char *)info->out_mask);
 		if (invert)
@@ -67,7 +67,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		if (*flags & XT_PHYSDEV_OP_ISIN)
 			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		info->bitmask |= XT_PHYSDEV_OP_ISIN;
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_ISIN;
@@ -77,7 +77,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '4':
 		if (*flags & XT_PHYSDEV_OP_ISOUT)
 			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		info->bitmask |= XT_PHYSDEV_OP_ISOUT;
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_ISOUT;
@@ -87,7 +87,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '5':
 		if (*flags & XT_PHYSDEV_OP_BRIDGED)
 			goto multiple_use;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_BRIDGED;
 		*flags |= XT_PHYSDEV_OP_BRIDGED;
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index ab2e225..8caba91 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -91,7 +91,7 @@ static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch(c)
 	{
 		case '1':
-			check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0);
 			parse_pkttype(argv[optind-1], info);
 			if(invert)
 				info->invert=1;
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 90da1cd..8c91fb8 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -60,7 +60,7 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (check_inverse(optarg, &invert, NULL, 0))
+		if (xtables_check_inverse(optarg, &invert, NULL, 0))
 			exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
 		if (!parse_quota(optarg, &info->quota))
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 285b7ba..8a8836b 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -118,7 +118,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case OPT_RATEEST1:
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
@@ -132,7 +132,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST2:
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
@@ -147,7 +147,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_BPS1:
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
@@ -171,7 +171,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_PPS1:
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
@@ -196,7 +196,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_BPS2:
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
@@ -220,7 +220,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_PPS2:
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
@@ -245,7 +245,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_DELTA:
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-delta can't be inverted");
@@ -259,7 +259,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_EQ:
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 
 		if (*flags & (1 << c))
 			exit_error(PARAMETER_PROBLEM,
@@ -272,7 +272,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_LT:
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 
 		if (*flags & (1 << c))
 			exit_error(PARAMETER_PROBLEM,
@@ -285,7 +285,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_GT:
-		check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 
 		if (*flags & (1 << c))
 			exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 1ae9013..1646705 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -73,7 +73,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				exit_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_SET;
 			if (invert) info->invert = 1;
 			*flags |= XT_RECENT_SET;
@@ -84,7 +84,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				exit_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_CHECK;
 			if(invert) info->invert = 1;
 			*flags |= XT_RECENT_CHECK;
@@ -95,7 +95,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				exit_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_UPDATE;
 			if (invert) info->invert = 1;
 			*flags |= XT_RECENT_UPDATE;
@@ -106,7 +106,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 				exit_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
-			check_inverse(optarg, &invert, &optind, 0);
+			xtables_check_inverse(optarg, &invert, &optind, 0);
 			info->check_set |= XT_RECENT_REMOVE;
 			if (invert) info->invert = 1;
 			*flags |= XT_RECENT_REMOVE;
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 6348a2f..2ee4861 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -270,7 +270,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_SCTP_SRC_PORTS;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_sctp_ports(argv[optind-1], einfo->spts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_SRC_PORTS;
@@ -282,7 +282,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_SCTP_DEST_PORTS;
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_sctp_ports(argv[optind-1], einfo->dpts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_DEST_PORTS;
@@ -293,7 +293,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & XT_SCTP_CHUNK_TYPES)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--chunk-types' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (!argv[optind] 
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 66af518..5182230 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -71,7 +71,7 @@ state_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		state_parse_states(argv[optind-1], sinfo);
 		if (invert)
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 0408c23..6bd27c0 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -199,7 +199,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & STRING)
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --string");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_string(argv[optind-1], stringinfo);
 		if (invert) {
 			if (revision == 0)
@@ -216,7 +216,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --hex-string");
 
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */
 		if (invert) {
 			if (revision == 0)
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index bb66747..069bb7f 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -150,7 +150,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_SRC_PORTS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_ports(argv[optind-1], tcpinfo->spts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_SRCPT;
@@ -161,7 +161,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_DST_PORTS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_ports(argv[optind-1], tcpinfo->dpts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_DSTPT;
@@ -182,7 +182,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one of `--syn' or `--tcp-flags' "
 				   " allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (!argv[optind]
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
@@ -199,7 +199,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_OPTION)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--tcp-option' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_option(argv[optind-1], &tcpinfo->option);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_OPTION;
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index d30aa24..5c013a7 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -65,7 +65,7 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--mss' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_mssvalues(argv[optind-1],
 				    &mssinfo->mss_min, &mssinfo->mss_max);
 		if (invert)
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 4012841..8f57f4e 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -72,7 +72,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & UDP_SRC_PORTS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_udp_ports(argv[optind-1], udpinfo->spts);
 		if (invert)
 			udpinfo->invflags |= XT_UDP_INV_SRCPT;
@@ -83,7 +83,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & UDP_DST_PORTS)
 			exit_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_udp_ports(argv[optind-1], udpinfo->dpts);
 		if (invert)
 			udpinfo->invflags |= XT_UDP_INV_DSTPT;
diff --git a/include/xtables.h.in b/include/xtables.h.in
index c3c960b..c1bf6d5 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -202,7 +202,8 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 /* this is a special 64bit data type that is 8-byte aligned */
 #define aligned_u64 u_int64_t __attribute__((aligned(8)))
 
-int check_inverse(const char option[], int *invert, int *my_optind, int argc);
+int xtables_check_inverse(const char option[], int *invert,
+	int *my_optind, int argc);
 void exit_error(enum xtables_exittype, const char *, ...)
 	__attribute__((noreturn, format(printf,2,3)));
 extern void xtables_param_act(unsigned int, const char *, ...);
diff --git a/ip6tables.c b/ip6tables.c
index 48a6bec..903e005 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -450,26 +450,6 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
 	*cmd |= newcmd;
 }
 
-int
-check_inverse(const char option[], int *invert, int *my_optind, int argc)
-{
-	if (option && strcmp(option, "!") == 0) {
-		if (*invert)
-			exit_error(PARAMETER_PROBLEM,
-				   "Multiple `!' flags not allowed");
-		*invert = TRUE;
-		if (my_optind != NULL) {
-			++*my_optind;
-			if (argc && *my_optind > argc)
-				exit_error(PARAMETER_PROBLEM,
-					   "no argument following `!'");
-		}
-
-		return TRUE;
-	}
-	return FALSE;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -1618,7 +1598,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			 * Option selection
 			 */
 		case 'p':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_PROTOCOL, &fw.ipv6.invflags,
 				   invert);
 
@@ -1644,14 +1624,14 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 's':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_SOURCE, &fw.ipv6.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_DESTINATION, &fw.ipv6.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
@@ -1697,7 +1677,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 
 		case 'i':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ipv6.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
@@ -1706,7 +1686,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 'o':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ipv6.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
diff --git a/iptables.c b/iptables.c
index 925464c..ea765b0 100644
--- a/iptables.c
+++ b/iptables.c
@@ -452,26 +452,6 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
 	*cmd |= newcmd;
 }
 
-int
-check_inverse(const char option[], int *invert, int *my_optind, int argc)
-{
-	if (option && strcmp(option, "!") == 0) {
-		if (*invert)
-			exit_error(PARAMETER_PROBLEM,
-				   "Multiple `!' flags not allowed");
-		*invert = TRUE;
-		if (my_optind != NULL) {
-			++*my_optind;
-			if (argc && *my_optind > argc)
-				exit_error(PARAMETER_PROBLEM,
-					   "no argument following `!'");
-		}
-
-		return TRUE;
-	}
-	return FALSE;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -1631,7 +1611,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			 * Option selection
 			 */
 		case 'p':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_PROTOCOL, &fw.ip.invflags,
 				   invert);
 
@@ -1649,14 +1629,14 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 's':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_SOURCE, &fw.ip.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_DESTINATION, &fw.ip.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
@@ -1702,7 +1682,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 
 		case 'i':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ip.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
@@ -1711,7 +1691,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 'o':
-			check_inverse(optarg, &invert, &optind, argc);
+			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ip.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
diff --git a/xtables.c b/xtables.c
index 8a79c5b..19e746c 100644
--- a/xtables.c
+++ b/xtables.c
@@ -1257,3 +1257,31 @@ void xtables_save_string(const char *value)
 		printf("\" ");
 	}
 }
+
+/**
+ * Check for option-intrapositional negation.
+ * Do not use in new code.
+ */
+int xtables_check_inverse(const char option[], int *invert,
+			  int *my_optind, int argc)
+{
+	if (option && strcmp(option, "!") == 0) {
+		fprintf(stderr, "Using intrapositioned negation "
+		        "(`--option ! this`) is deprecated in favor of "
+		        "extrapositioned (`! --option this`).\n");
+
+		if (*invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "Multiple `!' flags not allowed");
+		*invert = true;
+		if (my_optind != NULL) {
+			++*my_optind;
+			if (argc && *my_optind > argc)
+				exit_error(PARAMETER_PROBLEM,
+					   "no argument following `!'");
+		}
+
+		return true;
+	}
+	return false;
+}
-- 
1.6.1.2

