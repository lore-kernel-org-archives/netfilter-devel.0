From: Jan Engelhardt <jengelh@medozas.de>
Subject: iptables-save: output ! in position according to manpage
Date: Mon, 8 Dec 2008 18:17:05 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812081815510.2016@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, max@duempel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59103 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453AbYLHRRI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 12:17:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 0e874f0223d047bcb2c125a701e15b9e8af39106
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Dec 8 18:16:10 2008 +0100

iptables-save: output ! in position according to manpage

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ah.c         |    4 +-
 extensions/libip6t_dst.c        |    2 +-
 extensions/libip6t_frag.c       |    4 +-
 extensions/libip6t_hbh.c        |    2 +-
 extensions/libip6t_hl.c         |   12 +++++-----
 extensions/libip6t_ipv6header.c |    3 +-
 extensions/libip6t_rt.c         |    6 ++--
 extensions/libipt_addrtype.c    |    8 +++---
 extensions/libipt_ah.c          |    2 +-
 extensions/libxt_dscp.c         |   15 +-----------
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_length.c       |   26 +++++++++++------------
 extensions/libxt_multiport.c    |    6 ++--
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_string.c       |    4 +-
 extensions/libxt_tcpmss.c       |   34 +++++++++++--------------------
 16 files changed, 54 insertions(+), 78 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 6a3e784..0bbd475 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -164,7 +164,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 
 	if (!(ahinfo->spis[0] == 0
 	    && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("--ahspi %s", 
+		printf("%s--ahspi ",
 			(ahinfo->invflags & IP6T_AH_INV_SPI) ? "! " : "");
 		if (ahinfo->spis[0]
 		    != ahinfo->spis[1])
@@ -177,7 +177,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 	}
 
 	if (ahinfo->hdrlen != 0 || (ahinfo->invflags & IP6T_AH_INV_LEN) ) {
-		printf("--ahlen %s%u ", 
+		printf("%s--ahlen %u ", 
 			(ahinfo->invflags & IP6T_AH_INV_LEN) ? "! " : "", 
 			ahinfo->hdrlen);
 	}
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 17e8780..215e2d9 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -207,7 +207,7 @@ static void dst_save(const void *ip, const struct xt_entry_match *match)
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
 	if (optinfo->flags & IP6T_OPTS_LEN) {
-		printf("--dst-len %s%u ",
+		printf("%s--dst-len %u ",
 			(optinfo->invflags & IP6T_OPTS_INV_LEN) ? "! " : "", 
 			optinfo->hdrlen);
 	}
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 1f8f801..5ded1c6 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -200,7 +200,7 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 
 	if (!(fraginfo->ids[0] == 0
 	    && fraginfo->ids[1] == 0xFFFFFFFF)) {
-		printf("--fragid %s", 
+		printf("%s--fragid ", 
 			(fraginfo->invflags & IP6T_FRAG_INV_IDS) ? "! " : "");
 		if (fraginfo->ids[0]
 		    != fraginfo->ids[1])
@@ -213,7 +213,7 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 	}
 
 	if (fraginfo->flags & IP6T_FRAG_LEN) {
-		printf("--fraglen %s%u ", 
+		printf("%s--fraglen %u ", 
 			(fraginfo->invflags & IP6T_FRAG_INV_LEN) ? "! " : "", 
 			fraginfo->hdrlen);
 	}
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index ce79af9..419c250 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -196,7 +196,7 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 	const struct ip6t_opts *optinfo = (struct ip6t_opts *)match->data;
 
 	if (optinfo->flags & IP6T_OPTS_LEN) {
-		printf("--hbh-len %s%u ",
+		printf("%s--hbh-len %u ",
 			(optinfo->invflags & IP6T_OPTS_INV_LEN) ? "! " : "", 
 			optinfo->hdrlen);
 	}
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index f683dc7..7727581 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -104,16 +104,16 @@ static void hl_print(const void *ip, const struct xt_entry_match *match,
 
 static void hl_save(const void *ip, const struct xt_entry_match *match)
 {
-	static const char *op[] = {
-		[IP6T_HL_EQ] = "eq",
-		[IP6T_HL_NE] = "eq !",
-		[IP6T_HL_LT] = "lt",
-		[IP6T_HL_GT] = "gt" };
+	static const char *const op[] = {
+		[IP6T_HL_EQ] = "--hl-eq",
+		[IP6T_HL_NE] = "! --hl-eq",
+		[IP6T_HL_LT] = "--hl-lt",
+		[IP6T_HL_GT] = "--hl-gt" };
 
 	const struct ip6t_hl_info *info =
 		(struct ip6t_hl_info *) match->data;
 
-	printf("--hl-%s %u ", op[info->mode], info->hop_limit);
+	printf("%s %u ", op[info->mode], info->hop_limit);
 }
 
 static const struct option hl_opts[] = {
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index e114451..3006124 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -271,8 +271,7 @@ static void ipv6header_save(const void *ip, const struct xt_entry_match *match)
 
 	const struct ip6t_ipv6header_info *info = (const struct ip6t_ipv6header_info *)match->data;
 
-	printf("--header ");
-	printf("%s", info->invflags ? "!" : "");
+	printf("%s--header ", info->invflags ? "! " : "");
 	print_header(info->matchflags);
 	printf(" ");
 	if (info->modeflag)
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index c1f72af..9468da1 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -291,14 +291,14 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 	const struct ip6t_rt *rtinfo = (struct ip6t_rt *)match->data;
 
 	if (rtinfo->flags & IP6T_RT_TYP) {
-		printf("--rt-type %s%u ", 
+		printf("%s--rt-type %u ", 
 			(rtinfo->invflags & IP6T_RT_INV_TYP) ? "! " : "", 
 			rtinfo->rt_type);
 	}
 
 	if (!(rtinfo->segsleft[0] == 0
 	    && rtinfo->segsleft[1] == 0xFFFFFFFF)) {
-		printf("--rt-segsleft %s", 
+		printf("%s--rt-segsleft ",
 			(rtinfo->invflags & IP6T_RT_INV_SGS) ? "! " : "");
 		if (rtinfo->segsleft[0]
 		    != rtinfo->segsleft[1])
@@ -311,7 +311,7 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 	}
 
 	if (rtinfo->flags & IP6T_RT_LEN) {
-		printf("--rt-len %s%u ", 
+		printf("%s--rt-len %u ",
 			(rtinfo->invflags & IP6T_RT_INV_LEN) ? "! " : "", 
 			rtinfo->hdrlen);
 	}
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 3c83a01..dc43a3f 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -266,15 +266,15 @@ static void addrtype_save_v0(const void *ip, const struct xt_entry_match *match)
 		(struct ipt_addrtype_info *) match->data;
 
 	if (info->source) {
-		printf("--src-type ");
 		if (info->invert_source)
 			printf("! ");
+		printf("--src-type ");
 		print_types(info->source);
 	}
 	if (info->dest) {
-		printf("--dst-type ");
 		if (info->invert_dest)
 			printf("! ");
+		printf("--dst-type ");
 		print_types(info->dest);
 	}
 }
@@ -285,15 +285,15 @@ static void addrtype_save_v1(const void *ip, const struct xt_entry_match *match)
 		(struct ipt_addrtype_info_v1 *) match->data;
 
 	if (info->source) {
-		printf("--src-type ");
 		if (info->flags & IPT_ADDRTYPE_INVERT_SOURCE)
 			printf("! ");
+		printf("--src-type ");
 		print_types(info->source);
 	}
 	if (info->dest) {
-		printf("--dst-type ");
 		if (info->flags & IPT_ADDRTYPE_INVERT_DEST)
 			printf("! ");
+		printf("--dst-type ");
 		print_types(info->dest);
 	}
 	if (info->flags & IPT_ADDRTYPE_LIMIT_IFACE_IN) {
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 5084332..fec87a7 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -135,7 +135,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 
 	if (!(ahinfo->spis[0] == 0
 	    && ahinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("--ahspi %s", 
+		printf("%s--ahspi ",
 			(ahinfo->invflags & IPT_AH_INV_SPI) ? "! " : "");
 		if (ahinfo->spis[0]
 		    != ahinfo->spis[1])
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 307d800..eefb186 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -116,21 +116,11 @@ static void dscp_check(unsigned int flags)
 }
 
 static void
-print_dscp(u_int8_t dscp, int invert, int numeric)
-{
-	if (invert)
-		printf("! ");
-
- 	printf("0x%02x ", dscp);
-}
-
-static void
 dscp_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_dscp_info *dinfo =
 		(const struct xt_dscp_info *)match->data;
-	printf("DSCP match ");
-	print_dscp(dinfo->dscp, dinfo->invert, numeric);
+	printf("DSCP match %s0x%02x", dinfo->invert ? "!" : "", dinfo->dscp);
 }
 
 static void dscp_save(const void *ip, const struct xt_entry_match *match)
@@ -138,8 +128,7 @@ static void dscp_save(const void *ip, const struct xt_entry_match *match)
 	const struct xt_dscp_info *dinfo =
 		(const struct xt_dscp_info *)match->data;
 
-	printf("--dscp ");
-	print_dscp(dinfo->dscp, dinfo->invert, 1);
+	printf("%s--dscp 0x%02x ", dinfo->invert ? "! " : "", dinfo->dscp);
 }
 
 static struct xtables_match dscp_match = {
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 524449a..999733c 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -134,7 +134,7 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
 
 	if (!(espinfo->spis[0] == 0
 	    && espinfo->spis[1] == 0xFFFFFFFF)) {
-		printf("--espspi %s", 
+		printf("%s--espspi ",
 			(espinfo->invflags & XT_ESP_INV_SPI) ? "! " : "");
 		if (espinfo->spis[0]
 		    != espinfo->spis[1])
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index c5c411e..98e8167 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -91,28 +91,26 @@ static void length_check(unsigned int flags)
 }
 
 static void
-print_length(struct xt_length_info *info)
+length_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	if (info->invert)
-		printf("! ");
-	
-	if (info->max == info->min)
+	const struct xt_length_info *info = (void *)match->data;
+
+	printf("length %s", info->invert ? "!" : "");
+	if (info->min == info->max)
 		printf("%u ", info->min);
 	else
 		printf("%u:%u ", info->min, info->max);
 }
 
-static void
-length_print(const void *ip, const struct xt_entry_match *match, int numeric)
-{
-	printf("length ");
-	print_length((struct xt_length_info *)match->data);
-}
-
 static void length_save(const void *ip, const struct xt_entry_match *match)
 {
-	printf("--length ");
-	print_length((struct xt_length_info *)match->data);
+	const struct xt_length_info *info = (void *)match->data;
+
+	printf("%s--length ", info->invert ? "! " : "");
+	if (info->min == info->max)
+		printf("%u ", info->min);
+	else
+		printf("%u:%u ", info->min, info->max);
 }
 
 static struct xtables_match length_match = {
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 2552bbd..dae6e33 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -464,6 +464,9 @@ static void __multiport_save_v1(const struct xt_entry_match *match,
 		= (const struct xt_multiport_v1 *)match->data;
 	unsigned int i;
 
+	if (multiinfo->invert)
+		printf("! ");
+
 	switch (multiinfo->flags) {
 	case XT_MULTIPORT_SOURCE:
 		printf("--sports ");
@@ -478,9 +481,6 @@ static void __multiport_save_v1(const struct xt_entry_match *match,
 		break;
 	}
 
-	if (multiinfo->invert)
-		printf("! ");
-
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], proto, 1);
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 5e5e7ca..ab2e225 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -140,7 +140,7 @@ static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 {
 	struct xt_pkttype_info *info = (struct xt_pkttype_info *)match->data;
 	
-	printf("--pkt-type %s", info->invert?"! ":"");
+	printf("%s--pkt-type ", info->invert ? "! " : "");
 	print_pkttype(info);
 }
 
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 5b3ebf6..b440fc9 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -332,10 +332,10 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 				    info->u.v1.flags & XT_STRING_FLAG_INVERT);
 
 	if (is_hex_string(info->pattern, info->patlen)) {
-		printf("--hex-string %s", (invert) ? "! ": "");
+		printf("%s--hex-string ", (invert) ? "! ": "");
 		print_hex_string(info->pattern, info->patlen);
 	} else {
-		printf("--string %s", (invert) ? "! ": "");
+		printf("%s--string ", (invert) ? "! ": "");
 		print_string(info->pattern, info->patlen);
 	}
 	printf("--algo %s ", info->algo);
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 14be919..000d85a 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -78,18 +78,6 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static void
-print_tcpmss(u_int16_t mss_min, u_int16_t mss_max, int invert, int numeric)
-{
-	if (invert)
-		printf("! ");
-
-	if (mss_min == mss_max)
-		printf("%u ", mss_min);
-	else
-		printf("%u:%u ", mss_min, mss_max);
-}
-
 static void tcpmss_check(unsigned int flags)
 {
 	if (!flags)
@@ -100,22 +88,24 @@ static void tcpmss_check(unsigned int flags)
 static void
 tcpmss_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	const struct xt_tcpmss_match_info *mssinfo =
-		(const struct xt_tcpmss_match_info *)match->data;
+	const struct xt_tcpmss_match_info *info = (void *)match->data;
 
-	printf("tcpmss match ");
-	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
-		     mssinfo->invert, numeric);
+	printf("tcpmss match %s", info->invert ? "!" : "");
+	if (info->mss_min == info->mss_max)
+		printf("%u ", info->mss_min);
+	else
+		printf("%u:%u ", info->mss_min, info->mss_max);
 }
 
 static void tcpmss_save(const void *ip, const struct xt_entry_match *match)
 {
-	const struct xt_tcpmss_match_info *mssinfo =
-		(const struct xt_tcpmss_match_info *)match->data;
+	const struct xt_tcpmss_match_info *info = (void *)match->data;
 
-	printf("--mss ");
-	print_tcpmss(mssinfo->mss_min, mssinfo->mss_max,
-		     mssinfo->invert, 0);
+	printf("%s--mss ", info->invert ? "! " : "");
+	if (info->mss_min == info->mss_max)
+		printf("%u ", info->mss_min);
+	else
+		printf("%u:%u ", info->mss_min, info->mss_max);
 }
 
 static struct xtables_match tcpmss_match = {

