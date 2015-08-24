From: Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iptables v2] libxt_CT: add support for recently introduced zone options
Date: Mon, 24 Aug 2015 17:38:15 +0200
Message-ID: <72b31901e75137ef8a3c54cf07d0be560995b59a.1440430141.git.daniel@iogearbox.net>
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org,
	Daniel Borkmann <daniel@iogearbox.net>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:59583 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbbHXPiT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Aug 2015 11:38:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the user space front-end and man-page bits for the additional
zone features (direction, mark) of the CT target.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 v1 -> v2:
  - Match same style as ctnetlink interface, so have zone{-orig,-reply} options
  - Also consolidate option parsing and printing to reduce code duplication

 extensions/libxt_CT.c           | 87 ++++++++++++++++++++++++++++++++++-------
 extensions/libxt_CT.man         | 16 +++++++-
 include/linux/netfilter/xt_CT.h |  3 ++
 3 files changed, 90 insertions(+), 16 deletions(-)

diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 6b28fe1..371b217 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -16,7 +16,9 @@ static void ct_help(void)
 " --helper name			Use conntrack helper 'name' for connection\n"
 " --ctevents event[,event...]	Generate specified conntrack events for connection\n"
 " --expevents event[,event...]	Generate specified expectation events for connection\n"
-" --zone ID			Assign/Lookup connection in zone ID\n"
+" --zone {ID|mark}		Assign/Lookup connection in zone ID/packet nfmark\n"
+" --zone-orig {ID|mark}		Same as 'zone' option, but only applies to ORIGINAL direction\n"
+" --zone-reply {ID|mark} 	Same as 'zone' option, but only applies to REPLY direction\n"
 	);
 }
 
@@ -29,7 +31,9 @@ static void ct_help_v1(void)
 " --timeout name 		Use timeout policy 'name' for connection\n"
 " --ctevents event[,event...]	Generate specified conntrack events for connection\n"
 " --expevents event[,event...]	Generate specified expectation events for connection\n"
-" --zone ID			Assign/Lookup connection in zone ID\n"
+" --zone {ID|mark}		Assign/Lookup connection in zone ID/packet nfmark\n"
+" --zone-orig {ID|mark}		Same as 'zone' option, but only applies to ORIGINAL direction\n"
+" --zone-reply {ID|mark} 	Same as 'zone' option, but only applies to REPLY direction\n"
 	);
 }
 
@@ -40,6 +44,8 @@ enum {
 	O_CTEVENTS,
 	O_EXPEVENTS,
 	O_ZONE,
+	O_ZONE_ORIG,
+	O_ZONE_REPLY,
 };
 
 #define s struct xt_ct_target_info
@@ -49,8 +55,9 @@ static const struct xt_option_entry ct_opts[] = {
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, helper)},
 	{.name = "ctevents", .id = O_CTEVENTS, .type = XTTYPE_STRING},
 	{.name = "expevents", .id = O_EXPEVENTS, .type = XTTYPE_STRING},
-	{.name = "zone", .id = O_ZONE, .type = XTTYPE_UINT16,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, zone)},
+	{.name = "zone-orig", .id = O_ZONE_ORIG, .type = XTTYPE_STRING},
+	{.name = "zone-reply", .id = O_ZONE_REPLY, .type = XTTYPE_STRING},
+	{.name = "zone", .id = O_ZONE, .type = XTTYPE_STRING},
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -64,8 +71,9 @@ static const struct xt_option_entry ct_opts_v1[] = {
 	 .flags = XTOPT_PUT, XTOPT_POINTER(s, timeout)},
 	{.name = "ctevents", .id = O_CTEVENTS, .type = XTTYPE_STRING},
 	{.name = "expevents", .id = O_EXPEVENTS, .type = XTTYPE_STRING},
-	{.name = "zone", .id = O_ZONE, .type = XTTYPE_UINT16,
-	 .flags = XTOPT_PUT, XTOPT_POINTER(s, zone)},
+	{.name = "zone-orig", .id = O_ZONE_ORIG, .type = XTTYPE_STRING},
+	{.name = "zone-reply", .id = O_ZONE_REPLY, .type = XTTYPE_STRING},
+	{.name = "zone", .id = O_ZONE, .type = XTTYPE_STRING},
 	XTOPT_TABLEEND,
 };
 #undef s
@@ -92,6 +100,45 @@ static const struct event_tbl exp_event_tbl[] = {
 	{ "new",		IPEXP_NEW },
 };
 
+static void ct_parse_zone_id(const char *opt, unsigned int opt_id,
+			     uint16_t *zone_id, uint16_t *flags)
+{
+	if (opt_id == O_ZONE_ORIG)
+		*flags |= XT_CT_ZONE_DIR_ORIG;
+	if (opt_id == O_ZONE_REPLY)
+		*flags |= XT_CT_ZONE_DIR_REPL;
+
+	*zone_id = 0;
+
+	if (strcasecmp(opt, "mark") == 0) {
+		*flags |= XT_CT_ZONE_MARK;
+	} else {
+		uintmax_t val;
+
+		if (!xtables_strtoul(opt, NULL, &val, 0, UINT16_MAX))
+			xtables_error(PARAMETER_PROBLEM,
+				      "Cannot parse %s as a zone ID\n", opt);
+
+		*zone_id = (uint16_t)val;
+	}
+}
+
+static void ct_print_zone_id(const char *pfx, uint16_t zone_id, uint16_t flags)
+{
+	printf(" %s", pfx);
+
+	if ((flags & (XT_CT_ZONE_DIR_ORIG |
+		      XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_ORIG)
+		printf("-orig");
+	if ((flags & (XT_CT_ZONE_DIR_ORIG |
+		      XT_CT_ZONE_DIR_REPL)) == XT_CT_ZONE_DIR_REPL)
+		printf("-reply");
+	if (flags & XT_CT_ZONE_MARK)
+		printf(" mark");
+	else
+		printf(" %u", zone_id);
+}
+
 static uint32_t ct_parse_events(const struct event_tbl *tbl, unsigned int size,
 				const char *events)
 {
@@ -138,6 +185,12 @@ static void ct_parse(struct xt_option_call *cb)
 	case O_NOTRACK:
 		info->flags |= XT_CT_NOTRACK;
 		break;
+	case O_ZONE_ORIG:
+	case O_ZONE_REPLY:
+	case O_ZONE:
+		ct_parse_zone_id(cb->arg, cb->entry->id, &info->zone,
+				 &info->flags);
+		break;
 	case O_CTEVENTS:
 		info->ct_events = ct_parse_events(ct_event_tbl, ARRAY_SIZE(ct_event_tbl), cb->arg);
 		break;
@@ -156,6 +209,12 @@ static void ct_parse_v1(struct xt_option_call *cb)
 	case O_NOTRACK:
 		info->flags |= XT_CT_NOTRACK;
 		break;
+	case O_ZONE_ORIG:
+	case O_ZONE_REPLY:
+	case O_ZONE:
+		ct_parse_zone_id(cb->arg, cb->entry->id, &info->zone,
+				 &info->flags);
+		break;
 	case O_CTEVENTS:
 		info->ct_events = ct_parse_events(ct_event_tbl,
 						  ARRAY_SIZE(ct_event_tbl),
@@ -185,8 +244,8 @@ static void ct_print(const void *ip, const struct xt_entry_target *target, int n
 	if (info->exp_events)
 		ct_print_events("expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
-		printf("zone %u ", info->zone);
+	if (info->flags & XT_CT_ZONE_MARK || info->zone)
+		ct_print_zone_id("zone", info->zone, info->flags);
 }
 
 static void
@@ -212,8 +271,8 @@ ct_print_v1(const void *ip, const struct xt_entry_target *target, int numeric)
 	if (info->exp_events)
 		ct_print_events("expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
-		printf("zone %u ", info->zone);
+	if (info->flags & XT_CT_ZONE_MARK || info->zone)
+		ct_print_zone_id("zone", info->zone, info->flags);
 }
 
 static void ct_save(const void *ip, const struct xt_entry_target *target)
@@ -233,8 +292,8 @@ static void ct_save(const void *ip, const struct xt_entry_target *target)
 	if (info->exp_events)
 		ct_print_events("--expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
-		printf(" --zone %u", info->zone);
+	if (info->flags & XT_CT_ZONE_MARK || info->zone)
+		ct_print_zone_id("--zone", info->zone, info->flags);
 }
 
 static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
@@ -256,8 +315,8 @@ static void ct_save_v1(const void *ip, const struct xt_entry_target *target)
 	if (info->exp_events)
 		ct_print_events("--expevents", exp_event_tbl,
 				ARRAY_SIZE(exp_event_tbl), info->exp_events);
-	if (info->zone)
-		printf(" --zone %u", info->zone);
+	if (info->flags & XT_CT_ZONE_MARK || info->zone)
+		ct_print_zone_id("--zone", info->zone, info->flags);
 }
 
 static const char *
diff --git a/extensions/libxt_CT.man b/extensions/libxt_CT.man
index a93eb14..e992120 100644
--- a/extensions/libxt_CT.man
+++ b/extensions/libxt_CT.man
@@ -20,9 +20,21 @@ the ctmark, not nfmark), \fBnatseqinfo\fP, \fBsecmark\fP (ctsecmark).
 Only generate the specified expectation events for this connection.
 Possible event types are: \fBnew\fP.
 .TP
-\fB\-\-zone\fP \fIid\fP
+\fB\-\-zone-orig\fP {\fIid\fP|\fBmark\fP}
+For traffic coming from ORIGINAL direction, assign this packet to zone
+\fIid\fP and only have lookups done in that zone. If \fBmark\fP is used
+instead of \fIid\fP, the zone is derived from the packet nfmark.
+.TP
+\fB\-\-zone-reply\fP {\fIid\fP|\fBmark\fP}
+For traffic coming from REPLY direction, assign this packet to zone
+\fIid\fP and only have lookups done in that zone. If \fBmark\fP is used
+instead of \fIid\fP, the zone is derived from the packet nfmark.
+.TP
+\fB\-\-zone\fP {\fIid\fP|\fBmark\fP}
 Assign this packet to zone \fIid\fP and only have lookups done in that zone.
-By default, packets have zone 0.
+If \fBmark\fP is used instead of \fIid\fP, the zone is derived from the
+packet nfmark. By default, packets have zone 0. This option applies to both
+directions.
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

