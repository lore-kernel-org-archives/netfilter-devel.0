From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iptables] libxt_CT: add support for recently introduced zone options
Date: Sat, 11 Jul 2015 03:18:28 +0200
Message-ID: <a404309b0cc722e4b98abf23a48abb05cd8c9860.1436577274.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41722 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbbGKGMh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 Jul 2015 02:12:37 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the user space front-end and man-page bits for the
additional zone options (direction, mark) of the CT target.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 extensions/libxt_CT.c           | 102 +++++++++++++++++++++++++++++++++++-----
 extensions/libxt_CT.man         |   9 +++-
 include/linux/netfilter/xt_CT.h |   3 ++
 3 files changed, 100 insertions(+), 14 deletions(-)

diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 6b28fe1..86b1221 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -16,7 +16,8 @@ static void ct_help(void)
 " --helper name			Use conntrack helper 'name' for connection\n"
 " --ctevents event[,event...]	Generate specified conntrack events for connection\n"
 " --expevents event[,event...]	Generate specified expectation events for connection\n"
-" --zone ID			Assign/Lookup connection in zone ID\n"
+" --zone {ID|mark}		Assign/Lookup connection in zone ID/packet nfmark\n"
+" --zone-dir {ORIGINAL|REPLY}	Only apply zone in a particular direction\n"
 	);
 }
 
@@ -29,7 +30,8 @@ static void ct_help_v1(void)
 " --timeout name 		Use timeout policy 'name' for connection\n"
 " --ctevents event[,event...]	Generate specified conntrack events for connection\n"
 " --expevents event[,event...]	Generate specified expectation events for connection\n"
-" --zone ID			Assign/Lookup connection in zone ID\n"
+" --zone {ID|mark}		Assign/Lookup connection in zone ID/packet nfmark\n"
+" --zone-dir {ORIGINAL|REPLY}	Only apply zone in a particular direction\n"
 	);
 }
 
@@ -40,6 +42,7 @@ enum {
 	O_CTEVENTS,
 	O_EXPEVENTS,
 	O_ZONE,
+	O_DIR,
 };
 
 #define s struct xt_ct_target_info
@@ -49,8 +52,8 @@ static const struct xt_option_entry ct_opts[] = {
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, helper)},
 	{.name = "ctevents", .id = O_CTEVENTS, .type = XTTYPE_STRING},
 	{.name = "expevents", .id = O_EXPEVENTS, .type = XTTYPE_STRING},
-	{.name = "zone", .id = O_ZONE, .type = XTTYPE_UINT16,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, zone)},
+	{.name = "zone", .id = O_ZONE, .type = XTTYPE_STRING},
+	{.name = "zone-dir", .id = O_DIR, .type = XTTYPE_STRING},
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -64,8 +67,8 @@ static const struct xt_option_entry ct_opts_v1[] = {
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, timeout)},
 	{.name = "ctevents", .id = O_CTEVENTS, .type = XTTYPE_STRING},
 	{.name = "expevents", .id = O_EXPEVENTS, .type = XTTYPE_STRING},
-	{.name = "zone", .id = O_ZONE, .type = XTTYPE_UINT16,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, zone)},
+	{.name = "zone", .id = O_ZONE, .type = XTTYPE_STRING},
+	{.name = "zone-dir", .id = O_DIR, .type = XTTYPE_STRING},
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -92,6 +95,17 @@ static const struct event_tbl exp_event_tbl[] = {
 	{ "new",		IPEXP_NEW },
 };
 
+static uint16_t ct_parse_zone(const char *opt)
+{
+	uintmax_t value;
+
+	if (!xtables_strtoul(opt, NULL, &value, 0, UINT16_MAX))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Cannot parse %s as a zone ID\n", opt);
+
+	return (uint16_t)value;
+}
+
 static uint32_t ct_parse_events(const struct event_tbl *tbl, unsigned int size,
 				const char *events)
 {
@@ -138,6 +152,22 @@ static void ct_parse(struct xt_option_call *cb)
 	case O_NOTRACK:
 		info->flags |= XT_CT_NOTRACK;
 		break;
+	case O_DIR:
+		if (strcasecmp(cb->arg, "ORIGINAL") == 0)
+			info->flags |= XT_CT_ZONE_DIR_ORIG;
+		else if (strcasecmp(cb->arg, "REPLY") == 0)
+			info->flags |= XT_CT_ZONE_DIR_REPL;
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				      "Unsupported direction type \"%s\"", cb->arg);
+		break;
+	case O_ZONE:
+		info->zone = 0;
+		if (strcasecmp(cb->arg, "mark") == 0)
+			info->flags |= XT_CT_ZONE_MARK;
+		else
+			info->zone = ct_parse_zone(cb->arg);
+		break;
 	case O_CTEVENTS:
 		info->ct_events = ct_parse_events(ct_event_tbl, ARRAY_SIZE(ct_event_tbl), cb->arg);
 		break;
@@ -156,6 +186,22 @@ static void ct_parse_v1(struct xt_option_call *cb)
 	case O_NOTRACK:
 		info->flags |= XT_CT_NOTRACK;
 		break;
+	case O_DIR:
+		if (strcasecmp(cb->arg, "ORIGINAL") == 0)
+			info->flags |= XT_CT_ZONE_DIR_ORIG;
+		else if (strcasecmp(cb->arg, "REPLY") == 0)
+			info->flags |= XT_CT_ZONE_DIR_REPL;
+		else
+			xtables_error(PARAMETER_PROBLEM,
+				      "Unsupported direction type \"%s\"", cb->arg);
+		break;
+	case O_ZONE:
+		info->zone = 0;
+		if (strcasecmp(cb->arg, "mark") == 0)
+			info->flags |= XT_CT_ZONE_MARK;
+		else
+			info->zone = ct_parse_zone(cb->arg);
+		break;
 	case O_CTEVENTS:
 		info->ct_events = ct_parse_events(ct_event_tbl,
 						  ARRAY_SIZE(ct_event_tbl),
@@ -185,8 +231,16 @@ static void ct_print(const void *ip, const struct xt_entry_target *target, int n
 	if (info->exp_events)
 		ct_print_events("expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
-		printf("zone %u ", info->zone);
+	if (info->flags & XT_CT_ZONE_MARK)
+		printf(" zone mark");
+	else if (info->zone)
+		printf(" zone %u", info->zone);
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_ORIG)
+		printf(" zone-dir ORIGINAL");
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_REPL)
+		printf(" zone-dir REPLY");
 }
 
 static void
@@ -212,8 +266,16 @@ ct_print_v1(const void *ip, const struct xt_entry_target *target, int numeric)
 	if (info->exp_events)
 		ct_print_events("expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
-		printf("zone %u ", info->zone);
+	if (info->flags & XT_CT_ZONE_MARK)
+		printf(" zone mark");
+	else if (info->zone)
+		printf(" zone %u", info->zone);
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_ORIG)
+		printf(" zone-dir ORIGINAL");
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_REPL)
+		printf(" zone-dir REPLY");
 }
 
 static void ct_save(const void *ip, const struct xt_entry_target *target)
@@ -233,8 +295,16 @@ static void ct_save(const void *ip, const struct xt_entry_target *target)
 	if (info->exp_events)
 		ct_print_events("--expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
+	if (info->flags & XT_CT_ZONE_MARK)
+		printf(" --zone mark");
+	else if (info->zone)
 		printf(" --zone %u", info->zone);
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_ORIG)
+		printf(" --zone-dir ORIGINAL");
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_REPL)
+		printf(" --zone-dir REPLY");
 }
 
 static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
@@ -256,8 +326,16 @@ static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
 	if (info->exp_events)
 		ct_print_events("--expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
+	if (info->flags & XT_CT_ZONE_MARK)
+		printf(" --zone mark");
+	else if (info->zone)
 		printf(" --zone %u", info->zone);
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_ORIG)
+		printf(" --zone-dir ORIGINAL");
+	if ((info->flags & (XT_CT_ZONE_DIR_ORIG |
+			    XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_REPL)
+		printf(" --zone-dir REPLY");
 }
 
 static const char *
diff --git a/extensions/libxt_CT.man b/extensions/libxt_CT.man
index a93eb14..34389a2 100644
--- a/extensions/libxt_CT.man
+++ b/extensions/libxt_CT.man
@@ -20,9 +20,14 @@ the ctmark, not nfmark), \fBnatseqinfo\fP, \fBsecmark\fP (ctsecmark).
 Only generate the specified expectation events for this connection.
 Possible event types are: \fBnew\fP.
 .TP
-\fB\-\-zone\fP \fIid\fP
+\fB\-\-zone\fP {\fIid\fP|\fBmark\fP}
 Assign this packet to zone \fIid\fP and only have lookups done in that zone.
-By default, packets have zone 0.
+If \fBmark\fP is used instead of \fIid\fP, the zone is derived from the
+packet nfmark. By default, packets have zone 0.
+.TP
+\fB\-\-zone-dir\fP {\fBORIGINAL\fP|\fBREPLY\fP}
+Only apply a provided zone in a particular direction. By default, a zone
+is applied in both directions.
 .TP
 \fB\-\-timeout\fP \fIname\fP
 Use the timeout policy identified by \fIname\fP for the connection. This is
diff --git a/include/linux/netfilter/xt_CT.h b/include/linux/netfilter/xt_CT.h
index 54528fd..c3907db 100644
--- a/include/linux/netfilter/xt_CT.h
+++ b/include/linux/netfilter/xt_CT.h
@@ -6,6 +6,9 @@
 enum {
 	XT_CT_NOTRACK		= 1 << 0,
 	XT_CT_NOTRACK_ALIAS	= 1 << 1,
+	XT_CT_ZONE_DIR_ORIG	= 1 << 2,
+	XT_CT_ZONE_DIR_REPL	= 1 << 3,
+	XT_CT_ZONE_MARK		= 1 << 4,
 };
 
 struct xt_ct_target_info {
-- 
1.9.3

