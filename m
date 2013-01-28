From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 2/3] Add the "state" alias to the "conntrack" match
Date: Mon, 28 Jan 2013 21:32:54 +0100
Message-ID: <1359405175-4394-3-git-send-email-kadlec@blackhole.kfki.hu>
References: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:49367 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab3A1Ujl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 15:39:41 -0500
In-Reply-To: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 extensions/libxt_conntrack.c           |   27 ++++++++++++++++++++++++---
 extensions/libxt_state.man             |    2 +-
 include/linux/netfilter/xt_conntrack.h |    1 +
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index c37f14d..f7704eb 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -801,7 +801,9 @@ conntrack_dump(const struct xt_conntrack_mtinfo3 *info, const char *prefix,
 	if (info->match_flags & XT_CONNTRACK_STATE) {
 		if (info->invert_flags & XT_CONNTRACK_STATE)
 			printf(" !");
-		printf(" %sctstate", prefix);
+		printf(" %s%s", prefix,
+			info->match_flags & XT_CONNTRACK_STATE_ALIAS
+				? "state" : "ctstate");
 		print_state(info->state_mask);
 	}
 
@@ -902,6 +904,15 @@ conntrack_dump(const struct xt_conntrack_mtinfo3 *info, const char *prefix,
 	}
 }
 
+static const char *
+conntrack_print_name_alias(const struct xt_entry_match *match)
+{
+	struct xt_conntrack_mtinfo1 *info = (void *)match->data;
+
+	return info->match_flags & XT_CONNTRACK_STATE_ALIAS
+		? "state" : "conntrack";
+}
+
 static void conntrack_print(const void *ip, const struct xt_entry_match *match,
                             int numeric)
 {
@@ -1083,7 +1094,7 @@ static void state_ct1_parse(struct xt_option_call *cb)
 	struct xt_conntrack_mtinfo1 *sinfo = cb->data;
 
 	xtables_option_parse(cb);
-	sinfo->match_flags = XT_CONNTRACK_STATE;
+	sinfo->match_flags = XT_CONNTRACK_STATE | XT_CONNTRACK_STATE_ALIAS;
 	sinfo->state_mask = state_parse_states(cb->arg);
 	if (cb->invert)
 		sinfo->invert_flags |= XT_CONNTRACK_STATE;
@@ -1094,7 +1105,7 @@ static void state_ct23_parse(struct xt_option_call *cb)
 	struct xt_conntrack_mtinfo3 *sinfo = cb->data;
 
 	xtables_option_parse(cb);
-	sinfo->match_flags = XT_CONNTRACK_STATE;
+	sinfo->match_flags = XT_CONNTRACK_STATE | XT_CONNTRACK_STATE_ALIAS;
 	sinfo->state_mask = state_parse_states(cb->arg);
 	if (cb->invert)
 		sinfo->invert_flags |= XT_CONNTRACK_STATE;
@@ -1158,6 +1169,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack_print,
 		.save          = conntrack_save,
+		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack_mt_opts_v0,
 	},
 	{
@@ -1172,6 +1184,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack1_mt4_print,
 		.save          = conntrack1_mt4_save,
+		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1186,6 +1199,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack1_mt6_print,
 		.save          = conntrack1_mt6_save,
+		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1200,6 +1214,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack2_mt_print,
 		.save          = conntrack2_mt_save,
+		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1214,6 +1229,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack2_mt6_print,
 		.save          = conntrack2_mt6_save,
+		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack2_mt_opts,
 	},
 	{
@@ -1228,6 +1244,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack3_mt_print,
 		.save          = conntrack3_mt_save,
+		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack3_mt_opts,
 	},
 	{
@@ -1242,6 +1259,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.x6_fcheck     = conntrack_mt_check,
 		.print         = conntrack3_mt6_print,
 		.save          = conntrack3_mt6_save,
+		.alias	       = conntrack_print_name_alias,
 		.x6_options    = conntrack3_mt_opts,
 	},
 	{
@@ -1249,6 +1267,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.name          = "state",
 		.real_name     = "conntrack",
 		.revision      = 1,
+		.ext_flags     = XTABLES_EXT_ALIAS,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo1)),
@@ -1261,6 +1280,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.name          = "state",
 		.real_name     = "conntrack",
 		.revision      = 2,
+		.ext_flags     = XTABLES_EXT_ALIAS,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo2)),
@@ -1273,6 +1293,7 @@ static struct xtables_match conntrack_mt_reg[] = {
 		.name          = "state",
 		.real_name     = "conntrack",
 		.revision      = 3,
+		.ext_flags     = XTABLES_EXT_ALIAS,
 		.version       = XTABLES_VERSION,
 		.size          = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_mtinfo3)),
diff --git a/extensions/libxt_state.man b/extensions/libxt_state.man
index bd60468..ec096ca 100644
--- a/extensions/libxt_state.man
+++ b/extensions/libxt_state.man
@@ -1,4 +1,4 @@
-The "state" module is an obsolete version of "conntrack".
+The "state" extension is a subset of the "conntrack" module.
 "state" allows access to the connection tracking state for this packet.
 .TP
 [\fB!\fP] \fB\-\-state\fP \fIstate\fP
diff --git a/include/linux/netfilter/xt_conntrack.h b/include/linux/netfilter/xt_conntrack.h
index 74b904d..e971501 100644
--- a/include/linux/netfilter/xt_conntrack.h
+++ b/include/linux/netfilter/xt_conntrack.h
@@ -30,6 +30,7 @@ enum {
 	XT_CONNTRACK_REPLSRC_PORT = 1 << 10,
 	XT_CONNTRACK_REPLDST_PORT = 1 << 11,
 	XT_CONNTRACK_DIRECTION    = 1 << 12,
+	XT_CONNTRACK_STATE_ALIAS  = 1 << 13,
 };
 
 struct xt_conntrack_mtinfo1 {
-- 
1.7.0.4

