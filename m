From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] iptables/extensions: make bundled options work again
Date: Fri, 30 Oct 2009 09:39:28 +0100
Message-ID: <1256891969-18437-4-git-send-email-jengelh@medozas.de>
References: <1256891969-18437-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:46771 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421AbZJ3Ijd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Oct 2009 04:39:33 -0400
In-Reply-To: <1256891969-18437-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using a bundled option like "-ptcp", 'argv[optind-1]' would
logically point to "-ptcp", but this is obviously not right.
'optarg' is needed instead, which if properly offset to "tcp".

Not all places change optind-based access to optarg; where
look-ahead is needed, such as for tcp's --tcp-flags option for
example, optind is ok.

References: http://bugzilla.netfilter.org/show_bug.cgi?id=611
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ah.c         |    4 ++--
 extensions/libip6t_dst.c        |    4 ++--
 extensions/libip6t_frag.c       |    4 ++--
 extensions/libip6t_hbh.c        |    4 ++--
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_rt.c         |    8 ++++----
 extensions/libipt_SET.c         |    6 +++---
 extensions/libipt_addrtype.c    |    8 ++++----
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_realm.c       |    4 ++--
 extensions/libipt_set.c         |    6 +++---
 extensions/libxt_comment.c      |    4 ++--
 extensions/libxt_connbytes.c    |    2 +-
 extensions/libxt_connlimit.c    |    4 ++--
 extensions/libxt_conntrack.c    |   18 +++++++++---------
 extensions/libxt_dccp.c         |    8 ++++----
 extensions/libxt_dscp.c         |    4 ++--
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_hashlimit.c    |   16 ++++++++--------
 extensions/libxt_length.c       |    2 +-
 extensions/libxt_limit.c        |    4 ++--
 extensions/libxt_mac.c          |    2 +-
 extensions/libxt_multiport.c    |   24 ++++++++++++------------
 extensions/libxt_physdev.c      |    4 ++--
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_rateest.c      |    6 +++---
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_string.c       |    4 ++--
 extensions/libxt_tcp.c          |    8 ++++----
 extensions/libxt_tcpmss.c       |    2 +-
 extensions/libxt_u32.c          |    2 +-
 extensions/libxt_udp.c          |    4 ++--
 ip6tables.c                     |   12 ++++++------
 iptables.c                      |   15 ++++++---------
 39 files changed, 107 insertions(+), 110 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 19b7ad4..91de864 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -87,7 +87,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_ah_spis(argv[optind-1], ahinfo->spis);
+		parse_ah_spis(optarg, ahinfo->spis);
 		if (invert)
 			ahinfo->invflags |= IP6T_AH_INV_SPI;
 		*flags |= IP6T_AH_SPI;
@@ -97,7 +97,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahlen' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		ahinfo->hdrlen = parse_ah_spi(argv[optind-1], "length");
+		ahinfo->hdrlen = parse_ah_spi(optarg, "length");
 		if (invert)
 			ahinfo->invflags |= IP6T_AH_INV_LEN;
 		*flags |= IP6T_AH_LEN;
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index a47e3a3..43fc59a 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -126,7 +126,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-len' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
+		optinfo->hdrlen = parse_opts_num(optarg, "length");
 		if (invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
 		optinfo->flags |= IP6T_OPTS_LEN;
@@ -140,7 +140,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
                 if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--dst-opts'");
-		optinfo->optsnr = parse_options(argv[optind-1], optinfo->opts);
+		optinfo->optsnr = parse_options(optarg, optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
 		*flags |= IP6T_OPTS_OPTS;
 		break;
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 905b494..ecb394a 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -95,7 +95,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fragid' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_frag_ids(argv[optind-1], fraginfo->ids);
+		parse_frag_ids(optarg, fraginfo->ids);
 		if (invert)
 			fraginfo->invflags |= IP6T_FRAG_INV_IDS;
 		fraginfo->flags |= IP6T_FRAG_IDS;
@@ -106,7 +106,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fraglen' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		fraginfo->hdrlen = parse_frag_id(argv[optind-1], "length");
+		fraginfo->hdrlen = parse_frag_id(optarg, "length");
 		if (invert)
 			fraginfo->invflags |= IP6T_FRAG_INV_LEN;
 		fraginfo->flags |= IP6T_FRAG_LEN;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index e08d84a..87944c5 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -121,7 +121,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-len' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
+		optinfo->hdrlen = parse_opts_num(optarg, "length");
 		if (invert)
 			optinfo->invflags |= IP6T_OPTS_INV_LEN;
 		optinfo->flags |= IP6T_OPTS_LEN;
@@ -135,7 +135,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
                 if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--hbh-opts'");
-		optinfo->optsnr = parse_options(argv[optind-1], optinfo->opts);
+		optinfo->optsnr = parse_options(optarg, optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
 		*flags |= IP6T_OPTS_OPTS;
 		break;
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index ff76b74..d11de63 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -30,7 +30,7 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 	u_int8_t value;
 
 	xtables_check_inverse(optarg, &invert, &optind, 0);
-	value = atoi(argv[optind-1]);
+	value = atoi(optarg);
 
 	if (*flags) 
 		xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index e41a670..e081770 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -159,7 +159,7 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "icmpv6 match: only use --icmpv6-type once!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
+		parse_icmpv6(optarg, &icmpv6info->type,
 			     icmpv6info->code);
 		if (invert)
 			icmpv6info->invflags |= IP6T_ICMP_INV;
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 2674c8f..71eec62 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -187,7 +187,7 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 
 			xtables_check_inverse(optarg, &invert, &optind, 0);
 
-			if (! (info->matchflags = parse_header(argv[optind-1])) )
+			if (!(info->matchflags = parse_header(optarg)))
 				xtables_error(PARAMETER_PROBLEM, "ip6t_ipv6header: cannot parse header names");
 
 			if (invert) 
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 47d5544..71a804a 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -134,7 +134,7 @@ static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--mh-type' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_mh_types(argv[optind-1], mhinfo->types);
+		parse_mh_types(optarg, mhinfo->types);
 		if (invert)
 			mhinfo->invflags |= IP6T_MH_INV_TYPE;
 		*flags |= MH_TYPES;
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index c9bf994..1509f9d 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -159,7 +159,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-type' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		rtinfo->rt_type = parse_rt_num(argv[optind-1], "type");
+		rtinfo->rt_type = parse_rt_num(optarg, "type");
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_TYP;
 		rtinfo->flags |= IP6T_RT_TYP;
@@ -170,7 +170,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-segsleft' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_rt_segsleft(argv[optind-1], rtinfo->segsleft);
+		parse_rt_segsleft(optarg, rtinfo->segsleft);
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_SGS;
 		rtinfo->flags |= IP6T_RT_SGS;
@@ -181,7 +181,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-len' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		rtinfo->hdrlen = parse_rt_num(argv[optind-1], "length");
+		rtinfo->hdrlen = parse_rt_num(optarg, "length");
 		if (invert)
 			rtinfo->invflags |= IP6T_RT_INV_LEN;
 		rtinfo->flags |= IP6T_RT_LEN;
@@ -208,7 +208,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   " '!' not allowed with `--rt-0-addrs'");
-		rtinfo->addrnr = parse_addresses(argv[optind-1], rtinfo->addrs);
+		rtinfo->addrnr = parse_addresses(optarg, rtinfo->addrs);
 		rtinfo->flags |= IP6T_RT_FST;
 		*flags |= IP6T_RT_FST;
 		break;
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index d53fc1b..8697312 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -65,12 +65,12 @@ parse_target(char **argv, int invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 			   "--%s requires two args.", what);
 
-	if (strlen(argv[optind-1]) > IP_SET_MAXNAMELEN - 1)
+	if (strlen(optarg) > IP_SET_MAXNAMELEN - 1)
 		xtables_error(PARAMETER_PROBLEM,
 			   "setname `%s' too long, max %d characters.",
-			   argv[optind-1], IP_SET_MAXNAMELEN - 1);
+			   optarg, IP_SET_MAXNAMELEN - 1);
 
-	get_set_byname(argv[optind - 1], info);
+	get_set_byname(optarg, info);
 	parse_bindings(argv[optind], info);
 	optind++;
 	
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index cda7051..904b2d7 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -107,7 +107,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->source);
+		parse_types(optarg, &info->source);
 		if (invert)
 			info->invert_source = 1;
 		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
@@ -117,7 +117,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->dest);
+		parse_types(optarg, &info->dest);
 		if (invert)
 			info->invert_dest = 1;
 		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
@@ -142,7 +142,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->source);
+		parse_types(optarg, &info->source);
 		if (invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_SOURCE;
 		*flags |= IPT_ADDRTYPE_OPT_SRCTYPE;
@@ -152,7 +152,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_types(argv[optind-1], &info->dest);
+		parse_types(optarg, &info->dest);
 		if (invert)
 			info->flags |= IPT_ADDRTYPE_INVERT_DEST;
 		*flags |= IPT_ADDRTYPE_OPT_DSTTYPE;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index d049b42..eeae0c7 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -83,7 +83,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_ah_spis(argv[optind-1], ahinfo->spis);
+		parse_ah_spis(optarg, ahinfo->spis);
 		if (invert)
 			ahinfo->invflags |= IPT_AH_INV_SPI;
 		*flags |= AH_SPI;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 5667955..2027082 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -184,7 +184,7 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "icmp match: only use --icmp-type once!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_icmp(argv[optind-1], &icmpinfo->type, 
+		parse_icmp(optarg, &icmpinfo->type,
 			   icmpinfo->code);
 		if (invert)
 			icmpinfo->invflags |= IPT_ICMP_INV;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index be1943e..ef4a3a8 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -156,8 +156,8 @@ static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		char *end;
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
-		end = optarg = argv[optind-1];
+		xtables_check_inverse(optarg, &invert, &optind, 0);
+		end = optarg = optarg;
 		realminfo->id = strtoul(optarg, &end, 0);
 		if (end != optarg && (*end == '/' || *end == '\0')) {
 			if (*end == '/')
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 5075359..8edd739 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -74,12 +74,12 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "--match-set requires two args.");
 
-		if (strlen(argv[optind-1]) > IP_SET_MAXNAMELEN - 1)
+		if (strlen(optarg) > IP_SET_MAXNAMELEN - 1)
 			xtables_error(PARAMETER_PROBLEM,
 				   "setname `%s' too long, max %d characters.",
-				   argv[optind-1], IP_SET_MAXNAMELEN - 1);
+				   optarg, IP_SET_MAXNAMELEN - 1);
 
-		get_set_byname(argv[optind - 1], info);
+		get_set_byname(optarg, info);
 		parse_bindings(argv[optind], info);
 		DEBUGP("parse: set index %u\n", info->index);
 		optind++;
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 2e665b1..d2f0590 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -46,12 +46,12 @@ comment_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert) {
 			xtables_error(PARAMETER_PROBLEM,
 					"Sorry, you can't have an inverted comment");
 		}
-		parse_comment(argv[optind-1], commentinfo);
+		parse_comment(optarg, commentinfo);
 		*flags = 1;
 		break;
 
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index d6c3b1b..a021576 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -55,7 +55,7 @@ connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (xtables_check_inverse(optarg, &invert, &optind, 0))
 			optind++;
 
-		parse_range(argv[optind-1], sinfo);
+		parse_range(optarg, sinfo);
 		if (invert) {
 			i = sinfo->count.from;
 			sinfo->count.from = sinfo->count.to;
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 1698561..4336671 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -66,7 +66,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 				"--connlimit-above may be given only once");
 		*flags |= 0x1;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		info->limit   = strtoul(argv[optind-1], NULL, 0);
+		info->limit   = strtoul(optarg, NULL, 0);
 		info->inverse = invert;
 		break;
 	case 'M':
@@ -75,7 +75,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 				"--connlimit-mask may be given only once");
 
 		*flags |= 0x2;
-		i = strtoul(argv[optind-1], &err, 0);
+		i = strtoul(optarg, &err, 0);
 		if (family == NFPROTO_IPV6) {
 			if (i > 128 || *err != '\0')
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index c9f8182..6276f89 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -300,7 +300,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1':
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 
-		parse_states(argv[optind-1], sinfo);
+		parse_states(optarg, sinfo);
 		if (invert) {
 			sinfo->invflags |= XT_CONNTRACK_STATE;
 		}
@@ -314,10 +314,10 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 			sinfo->invflags |= XT_CONNTRACK_PROTO;
 
 		/* Canonicalize into lower case */
-		for (protocol = argv[optind-1]; *protocol; protocol++)
+		for (protocol = optarg; *protocol; protocol++)
 			*protocol = tolower(*protocol);
 
-		protocol = argv[optind-1];
+		protocol = optarg;
 		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum =
 			xtables_parse_protocol(protocol);
 
@@ -335,7 +335,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGSRC;
 
-		xtables_ipparse_any(argv[optind-1], &addrs,
+		xtables_ipparse_any(optarg, &addrs,
 					&sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
@@ -355,7 +355,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGDST;
 
-		xtables_ipparse_any(argv[optind-1], &addrs,
+		xtables_ipparse_any(optarg, &addrs,
 					&sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
@@ -375,7 +375,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLSRC;
 
-		xtables_ipparse_any(argv[optind-1], &addrs,
+		xtables_ipparse_any(optarg, &addrs,
 					&sinfo->sipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
@@ -395,7 +395,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLDST;
 
-		xtables_ipparse_any(argv[optind-1], &addrs,
+		xtables_ipparse_any(optarg, &addrs,
 					&sinfo->dipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
@@ -412,7 +412,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '7':
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 
-		parse_statuses(argv[optind-1], sinfo);
+		parse_statuses(optarg, sinfo);
 		if (invert) {
 			sinfo->invflags |= XT_CONNTRACK_STATUS;
 		}
@@ -422,7 +422,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '8':
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 
-		parse_expires(argv[optind-1], sinfo);
+		parse_expires(optarg, sinfo);
 		if (invert) {
 			sinfo->invflags |= XT_CONNTRACK_EXPIRES;
 		}
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index ae23225..ca64675 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -141,7 +141,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_DCCP_SRC_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_dccp_ports(argv[optind-1], einfo->spts);
+		parse_dccp_ports(optarg, einfo->spts);
 		if (invert)
 			einfo->invflags |= XT_DCCP_SRC_PORTS;
 		*flags |= XT_DCCP_SRC_PORTS;
@@ -153,7 +153,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_DCCP_DEST_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_dccp_ports(argv[optind-1], einfo->dpts);
+		parse_dccp_ports(optarg, einfo->dpts);
 		if (invert)
 			einfo->invflags |= XT_DCCP_DEST_PORTS;
 		*flags |= XT_DCCP_DEST_PORTS;
@@ -165,7 +165,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Only one `--dccp-types' allowed");
 		einfo->flags |= XT_DCCP_TYPE;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		einfo->typemask = parse_dccp_types(argv[optind-1]);
+		einfo->typemask = parse_dccp_types(optarg);
 		if (invert)
 			einfo->invflags |= XT_DCCP_TYPE;
 		*flags |= XT_DCCP_TYPE;
@@ -177,7 +177,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Only one `--dccp-option' allowed");
 		einfo->flags |= XT_DCCP_OPTION;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		einfo->option = parse_dccp_option(argv[optind-1]);
+		einfo->option = parse_dccp_option(optarg);
 		if (invert)
 			einfo->invflags |= XT_DCCP_OPTION;
 		*flags |= XT_DCCP_OPTION;
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 306643e..3deb357 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -83,7 +83,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "DSCP match: Only use --dscp ONCE!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_dscp(argv[optind-1], dinfo);
+		parse_dscp(optarg, dinfo);
 		if (invert)
 			dinfo->invert = 1;
 		*flags = 1;
@@ -94,7 +94,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 					"DSCP match: Only use --dscp-class ONCE!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_class(argv[optind - 1], dinfo);
+		parse_class(optarg, dinfo);
 		if (invert)
 			dinfo->invert = 1;
 		*flags = 1;
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 89c3fb4..3951e9b 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -89,7 +89,7 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--espspi' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_esp_spis(argv[optind-1], espinfo->spis);
+		parse_esp_spis(optarg, espinfo->spis);
 		if (invert)
 			espinfo->invflags |= XT_ESP_INV_SPI;
 		*flags |= ESP_SPI;
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index cdb407a..1b3d590 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -219,7 +219,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '%':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit",
 		          *flags & PARAM_LIMIT);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->cfg.avg))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
@@ -229,7 +229,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '$':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
 		          *flags & PARAM_BURST);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-burst `%s'", optarg);
@@ -239,7 +239,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '&':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-size: `%s'", optarg);
@@ -249,7 +249,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '*':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-max: `%s'", optarg);
@@ -260,7 +260,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-gcinterval: `%s'", 
@@ -272,7 +272,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case ')':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-expire: `%s'", optarg);
@@ -283,7 +283,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '_':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (parse_mode(&r->cfg.mode, optarg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-mode: `%s'\n", optarg);
@@ -292,7 +292,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '"':
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
 		          *flags & PARAM_NAME);
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (strlen(optarg) == 0)
 			xtables_error(PARAMETER_PROBLEM, "Zero-length name?");
 		strncpy(r->name, optarg, sizeof(r->name));
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 0f954cf..6fc4609 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -71,7 +71,7 @@ length_parse(int c, char **argv, int invert, unsigned int *flags,
 				           "length: `--length' may only be "
 				           "specified once");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
-			parse_lengths(argv[optind-1], info);
+			parse_lengths(optarg, info);
 			if (invert)
 				info->invert = 1;
 			*flags = 1;
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 8ca921c..4e79251 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -94,14 +94,14 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '%':
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->avg))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
 		break;
 
 	case '$':
-		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
+		if (xtables_check_inverse(optarg, &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			xtables_error(PARAMETER_PROBLEM,
 				   "bad --limit-burst `%s'", optarg);
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 449fff9..fb21fd6 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -58,7 +58,7 @@ mac_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_mac(argv[optind-1], macinfo);
+		parse_mac(optarg, macinfo);
 		if (invert)
 			macinfo->invert = 1;
 		*flags = 1;
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index d9b6e74..da60aa5 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -164,25 +164,25 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
+		multiinfo->count = parse_multi_ports(optarg,
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
 
 	case '2':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
+		multiinfo->count = parse_multi_ports(optarg,
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
 
 	case '3':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
+		multiinfo->count = parse_multi_ports(optarg,
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
@@ -231,23 +231,23 @@ __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
-		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		parse_multi_ports_v1(optarg, multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
 
 	case '2':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
-		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		parse_multi_ports_v1(optarg, multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
 
 	case '3':
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 		proto = check_proto(pnum, invflags);
-		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
+		parse_multi_ports_v1(optarg, multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
 
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 74d311d..7b74247 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -44,7 +44,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & XT_PHYSDEV_OP_IN)
 			goto multiple_use;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		xtables_parse_interface(argv[optind-1], info->physindev,
+		xtables_parse_interface(optarg, info->physindev,
 				(unsigned char *)info->in_mask);
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_IN;
@@ -56,7 +56,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & XT_PHYSDEV_OP_OUT)
 			goto multiple_use;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		xtables_parse_interface(argv[optind-1], info->physoutdev,
+		xtables_parse_interface(optarg, info->physoutdev,
 				(unsigned char *)info->out_mask);
 		if (invert)
 			info->invert |= XT_PHYSDEV_OP_OUT;
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 7586c7f..fb9cdcc 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -88,7 +88,7 @@ static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
 	{
 		case '1':
 			xtables_check_inverse(optarg, &invert, &optind, 0);
-			parse_pkttype(argv[optind-1], info);
+			parse_pkttype(optarg, info);
 			if(invert)
 				info->invert=1;
 			*flags=1;
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 54a7579..91fbb09 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -259,7 +259,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_EQ:
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
@@ -272,7 +272,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_LT:
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
@@ -285,7 +285,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_GT:
-		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index dfa72d3..a100bfb 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -258,7 +258,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_SCTP_SRC_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_sctp_ports(argv[optind-1], einfo->spts);
+		parse_sctp_ports(optarg, einfo->spts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_SRC_PORTS;
 		*flags |= XT_SCTP_SRC_PORTS;
@@ -270,7 +270,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_SCTP_DEST_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_sctp_ports(argv[optind-1], einfo->dpts);
+		parse_sctp_ports(optarg, einfo->dpts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_DEST_PORTS;
 		*flags |= XT_SCTP_DEST_PORTS;
@@ -288,7 +288,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "--chunk-types requires two args");
 
 		einfo->flags |= XT_SCTP_CHUNK_TYPES;
-		parse_sctp_chunks(einfo, argv[optind-1], argv[optind]);
+		parse_sctp_chunks(einfo, optarg, argv[optind]);
 		if (invert)
 			einfo->invflags |= XT_SCTP_CHUNK_TYPES;
 		optind++;
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index c8a7454..5db76fc 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -73,7 +73,7 @@ state_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1':
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 
-		state_parse_states(argv[optind-1], sinfo);
+		state_parse_states(optarg, sinfo);
 		if (invert)
 			sinfo->statemask = ~sinfo->statemask;
 		*flags = 1;
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 62c3a97..70ef5f4 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -203,7 +203,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --string");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_string(argv[optind-1], stringinfo);
+		parse_string(optarg, stringinfo);
 		if (invert) {
 			if (revision == 0)
 				stringinfo->u.v0.invert = 1;
@@ -219,7 +219,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 				   "Can't specify multiple --hex-string");
 
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_hex_string(argv[optind-1], stringinfo);  /* sets length */
+		parse_hex_string(optarg, stringinfo);  /* sets length */
 		if (invert) {
 			if (revision == 0)
 				stringinfo->u.v0.invert = 1;
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 7abecc1..fe7e487 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -148,7 +148,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_ports(argv[optind-1], tcpinfo->spts);
+		parse_tcp_ports(optarg, tcpinfo->spts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_SRCPT;
 		*flags |= TCP_SRC_PORTS;
@@ -159,7 +159,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_ports(argv[optind-1], tcpinfo->dpts);
+		parse_tcp_ports(optarg, tcpinfo->dpts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_DSTPT;
 		*flags |= TCP_DST_PORTS;
@@ -186,7 +186,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "--tcp-flags requires two args.");
 
-		parse_tcp_flags(tcpinfo, argv[optind-1], argv[optind],
+		parse_tcp_flags(tcpinfo, optarg, argv[optind],
 				invert);
 		optind++;
 		*flags |= TCP_FLAGS;
@@ -197,7 +197,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--tcp-option' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_option(argv[optind-1], &tcpinfo->option);
+		parse_tcp_option(optarg, &tcpinfo->option);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_OPTION;
 		*flags |= TCP_OPTION;
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 36785a3..4954c9e 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -66,7 +66,7 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--mss' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_mssvalues(argv[optind-1],
+		parse_tcp_mssvalues(optarg,
 				    &mssinfo->mss_min, &mssinfo->mss_max);
 		if (invert)
 			mssinfo->invert = 1;
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 8e149c1..9a61c8a 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -107,7 +107,7 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 	struct xt_u32 *data = (void *)(*match)->data;
 	unsigned int testind = 0, locind = 0, valind = 0;
 	struct xt_u32_test *ct = &data->tests[testind]; /* current test */
-	char *arg = argv[optind-1]; /* the argument string */
+	char *arg = optarg; /* the argument string */
 	char *start = arg;
 	int state = 0;
 
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index bf0b34f..9a31231 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -73,7 +73,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_udp_ports(argv[optind-1], udpinfo->spts);
+		parse_udp_ports(optarg, udpinfo->spts);
 		if (invert)
 			udpinfo->invflags |= XT_UDP_INV_SRCPT;
 		*flags |= UDP_SRC_PORTS;
@@ -84,7 +84,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
-		parse_udp_ports(argv[optind-1], udpinfo->dpts);
+		parse_udp_ports(optarg, udpinfo->dpts);
 		if (invert)
 			udpinfo->invflags |= XT_UDP_INV_DSTPT;
 		*flags |= UDP_DST_PORTS;
diff --git a/ip6tables.c b/ip6tables.c
index 53a1a5d..991ba00 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1497,10 +1497,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				   invert);
 
 			/* Canonicalize into lower case */
-			for (protocol = argv[optind-1]; *protocol; protocol++)
+			for (protocol = optarg; *protocol; protocol++)
 				*protocol = tolower(*protocol);
 
-			protocol = argv[optind-1];
+			protocol = optarg;
 			fw.ipv6.proto = xtables_parse_protocol(protocol);
 			fw.ipv6.flags |= IP6T_F_PROTO;
 
@@ -1521,14 +1521,14 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_SOURCE, &fw.ipv6.invflags,
 				   invert);
-			shostnetworkmask = argv[optind-1];
+			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_DESTINATION, &fw.ipv6.invflags,
 				   invert);
-			dhostnetworkmask = argv[optind-1];
+			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IP6T_F_GOTO
@@ -1574,7 +1574,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ipv6.invflags,
 				   invert);
-			xtables_parse_interface(argv[optind-1],
+			xtables_parse_interface(optarg,
 					fw.ipv6.iniface,
 					fw.ipv6.iniface_mask);
 			break;
@@ -1583,7 +1583,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ipv6.invflags,
 				   invert);
-			xtables_parse_interface(argv[optind-1],
+			xtables_parse_interface(optarg,
 					fw.ipv6.outiface,
 					fw.ipv6.outiface_mask);
 			break;
diff --git a/iptables.c b/iptables.c
index 1160171..ce50520 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1501,9 +1501,6 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			break;
 
 		case 'h':
-			if (!optarg)
-				optarg = argv[optind];
-
 			/* iptables -p icmp -h */
 			if (!matches && protocol)
 				xtables_find_match(protocol,
@@ -1520,10 +1517,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				   invert);
 
 			/* Canonicalize into lower case */
-			for (protocol = argv[optind-1]; *protocol; protocol++)
+			for (protocol = optarg; *protocol; protocol++)
 				*protocol = tolower(*protocol);
 
-			protocol = argv[optind-1];
+			protocol = optarg;
 			fw.ip.proto = xtables_parse_protocol(protocol);
 
 			if (fw.ip.proto == 0
@@ -1536,14 +1533,14 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_SOURCE, &fw.ip.invflags,
 				   invert);
-			shostnetworkmask = argv[optind-1];
+			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_DESTINATION, &fw.ip.invflags,
 				   invert);
-			dhostnetworkmask = argv[optind-1];
+			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
@@ -1589,7 +1586,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEIN, &fw.ip.invflags,
 				   invert);
-			xtables_parse_interface(argv[optind-1],
+			xtables_parse_interface(optarg,
 					fw.ip.iniface,
 					fw.ip.iniface_mask);
 			break;
@@ -1598,7 +1595,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			xtables_check_inverse(optarg, &invert, &optind, argc);
 			set_option(&options, OPT_VIANAMEOUT, &fw.ip.invflags,
 				   invert);
-			xtables_parse_interface(argv[optind-1],
+			xtables_parse_interface(optarg,
 					fw.ip.outiface,
 					fw.ip.outiface_mask);
 			break;
-- 
1.6.5.1

