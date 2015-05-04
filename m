From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iptables] libxt_CT: add support for flextuples
Date: Mon,  4 May 2015 12:23:56 +0200
Message-ID: <92ac128c5849a4e3da0287e37a00ba47e06aecee.1430733890.git.daniel@iogearbox.net>
Cc: netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>,
	Thomas Graf <tgraf@suug.ch>,
	Madhu Challa <challa@noironetworks.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:38134 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbbEDKYB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 06:24:01 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds iptables user space part for configuration of flextuples.
I also noticed that ct_print*() zone reporting had a whitespace bug,
which is fixed here as well (it needs to be prefixed).

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Thomas Graf <tgraf@suug.ch>
Signed-off-by: Madhu Challa <challa@noironetworks.com>
---
 extensions/libxt_CT.c           | 41 +++++++++++++++++++++++++++++++++++++++--
 extensions/libxt_CT.man         |  7 +++++++
 include/linux/netfilter/xt_CT.h |  2 ++
 3 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 6b28fe1..e7df772 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -40,6 +40,7 @@ enum {
 	O_CTEVENTS,
 	O_EXPEVENTS,
 	O_ZONE,
+	O_FLEXTUPLE,
 };
 
 #define s struct xt_ct_target_info
@@ -51,6 +52,7 @@ static const struct xt_option_entry ct_opts[] = {
 	{.name = "expevents", .id = O_EXPEVENTS, .type = XTTYPE_STRING},
 	{.name = "zone", .id = O_ZONE, .type = XTTYPE_UINT16,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, zone)},
+	{.name = "flextuple", .id = O_FLEXTUPLE, .type = XTTYPE_STRING},
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -66,6 +68,7 @@ static const struct xt_option_entry ct_opts_v1[] = {
 	{.name = "expevents", .id = O_EXPEVENTS, .type = XTTYPE_STRING},
 	{.name = "zone", .id = O_ZONE, .type = XTTYPE_UINT16,
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, zone)},
+	{.name = "flextuple", .id = O_FLEXTUPLE, .type = XTTYPE_STRING},
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -138,6 +141,15 @@ static void ct_parse(struct xt_option_call *cb)
 	case O_NOTRACK:
 		info->flags |= XT_CT_NOTRACK;
 		break;
+	case O_FLEXTUPLE:
+		if (strcasecmp(cb->arg, "ORIGINAL") == 0)
+			info->flags |= XT_CT_FLEX_ORIG;
+		else if (strcasecmp(cb->arg, "REPLY") == 0)
+			info->flags |= XT_CT_FLEX_REPL;
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				      "Unknown direction type \"%s\"", cb->arg);
+		break;
 	case O_CTEVENTS:
 		info->ct_events = ct_parse_events(ct_event_tbl, ARRAY_SIZE(ct_event_tbl), cb->arg);
 		break;
@@ -156,6 +168,15 @@ static void ct_parse_v1(struct xt_option_call *cb)
 	case O_NOTRACK:
 		info->flags |= XT_CT_NOTRACK;
 		break;
+	case O_FLEXTUPLE:
+		if (strcasecmp(cb->arg, "ORIGINAL") == 0)
+			info->flags |= XT_CT_FLEX_ORIG;
+		else if (strcasecmp(cb->arg, "REPLY") == 0)
+			info->flags |= XT_CT_FLEX_REPL;
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				      "Unknown direction type \"%s\"", cb->arg);
+		break;
 	case O_CTEVENTS:
 		info->ct_events = ct_parse_events(ct_event_tbl,
 						  ARRAY_SIZE(ct_event_tbl),
@@ -186,7 +207,11 @@ static void ct_print(const void *ip, const struct xt_entry_target *target, int n
 		ct_print_events("expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
 	if (info->zone)
-		printf("zone %u ", info->zone);
+		printf(" zone %u", info->zone);
+	if (info->flags & XT_CT_FLEX_ORIG)
+		printf(" flextuple ORIGINAL");
+	if (info->flags & XT_CT_FLEX_REPL)
+		printf(" flextuple REPLY");
 }
 
 static void
@@ -213,7 +238,11 @@ ct_print_v1(const void *ip, const struct xt_entry_target *target, int numeric)
 		ct_print_events("expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
 	if (info->zone)
-		printf("zone %u ", info->zone);
+		printf(" zone %u", info->zone);
+	if (info->flags & XT_CT_FLEX_ORIG)
+		printf(" flextuple ORIGINAL");
+	if (info->flags & XT_CT_FLEX_REPL)
+		printf(" flextuple REPLY");
 }
 
 static void ct_save(const void *ip, const struct xt_entry_target *target)
@@ -235,6 +264,10 @@ static void ct_save(const void *ip, const struct xt_entry_target *target)
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
 	if (info->zone)
 		printf(" --zone %u", info->zone);
+	if (info->flags & XT_CT_FLEX_ORIG)
+		printf(" --flextuple ORIGINAL");
+	if (info->flags & XT_CT_FLEX_REPL)
+		printf(" --flextuple REPLY");
 }
 
 static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
@@ -258,6 +291,10 @@ static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
 	if (info->zone)
 		printf(" --zone %u", info->zone);
+	if (info->flags & XT_CT_FLEX_ORIG)
+		printf(" --flextuple ORIGINAL");
+	if (info->flags & XT_CT_FLEX_REPL)
+		printf(" --flextuple REPLY");
 }
 
 static const char *
diff --git a/extensions/libxt_CT.man b/extensions/libxt_CT.man
index a93eb14..04c2eb8 100644
--- a/extensions/libxt_CT.man
+++ b/extensions/libxt_CT.man
@@ -24,6 +24,13 @@ Possible event types are: \fBnew\fP.
 Assign this packet to zone \fIid\fP and only have lookups done in that zone.
 By default, packets have zone 0.
 .TP
+\fB\-\-flextuple\fP {\fBORIGINAL\fP|\fBREPLY\fP}
+Based on the specified direction, allow the connection tracking tuple to
+act as a flexible tuple by including the connection mark in the match.
+This allows, for example, for doing SNAT in a destination zone, where one
+can SNAT multiple source zones with overlapping IP addresses to a single
+resp. pool of IP addresses. By default, flextuples are off.
+.TP
 \fB\-\-timeout\fP \fIname\fP
 Use the timeout policy identified by \fIname\fP for the connection. This is
 provides more flexible timeout policy definition than global timeout values
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
index 54528fd..bae381f 100644
--- a/include/linux/netfilter/xt_CT.h
+++ b/include/linux/netfilter/xt_CT.h
@@ -6,6 +6,8 @@
 enum {
 	XT_CT_NOTRACK		= 1 << 0,
 	XT_CT_NOTRACK_ALIAS	= 1 << 1,
+	XT_CT_FLEX_ORIG         = 1 << 2,
+	XT_CT_FLEX_REPL         = 1 << 3,
 };
 
 struct xt_ct_target_info {
-- 
1.9.3

