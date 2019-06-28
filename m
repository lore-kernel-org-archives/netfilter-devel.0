Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD584C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 06:53:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 77C0F2063F
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 06:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbfF1Gx3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 02:53:29 -0400
Received: from fnsib-smtp05.srv.cat ([46.16.61.54]:43396 "EHLO
        fnsib-smtp05.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbfF1Gx3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 02:53:29 -0400
Received: from bubu.das-nano.com (242.red-83-48-67.staticip.rima-tde.net [83.48.67.242])
        by fnsib-smtp05.srv.cat (Postfix) with ESMTPSA id 294BB1EF1BB
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 08:53:23 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH v3 1/4] meta: Introduce new conditions 'time', 'day' and 'hour'
Date:   Fri, 28 Jun 2019 08:53:16 +0200
Message-Id: <20190628065319.15834-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

These keywords introduce new checks for a timestamp, an absolute date (which is converted to a timestamp),
an hour in the day (which is converted to the number of seconds since midnight) and a day of week.

When converting an ISO date (eg. 2019-06-06 17:00) to a timestamp,
we need to substract it the GMT difference in seconds, that is, the value
of the 'tm_gmtoff' field in the tm structure. This is because the kernel
doesn't know about time zones. And hence the kernel manages different timestamps
than those that are advertised in userspace when running, for instance, date +%s.

The same conversion needs to be done when converting hours (e.g 17:00) to seconds since midnight
as well.

We also introduce a new command line option (-t, --seconds) to show the actual
timestamps when printing the values, rather than the ISO dates, or the hour.

Some usage examples:

	time < "2019-06-06 17:00" drop;
	time < "2019-06-06 17:20:20" drop;
	time < 12341234 drop;
	day "Sat" drop;
	day 6 drop;
	hour >= 17:00 drop;
	hour >= "17:00:01" drop;
	hour >= 63000 drop;

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/datatype.h                  |   3 +
 include/linux/netfilter/nf_tables.h |   6 +
 include/meta.h                      |   3 +
 include/nftables.h                  |   5 +
 include/nftables/libnftables.h      |   1 +
 src/datatype.c                      |   3 +
 src/main.c                          |  11 +-
 src/meta.c                          | 292 ++++++++++++++++++++++++++++
 src/parser_bison.y                  |   4 +
 src/scanner.l                       |   4 +-
 10 files changed, 330 insertions(+), 2 deletions(-)

diff --git a/include/datatype.h b/include/datatype.h
index 63617eb..1f46eb0 100644
--- a/include/datatype.h
+++ b/include/datatype.h
@@ -90,6 +90,9 @@ enum datatypes {
 	TYPE_CT_EVENTBIT,
 	TYPE_IFNAME,
 	TYPE_IGMP_TYPE,
+	TYPE_TIME_DATE,
+	TYPE_TIME_HOUR,
+	TYPE_TIME_DAY,
 	__TYPE_MAX
 };
 #define TYPE_MAX		(__TYPE_MAX - 1)
diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
index 7bdb234..ce621ed 100644
--- a/include/linux/netfilter/nf_tables.h
+++ b/include/linux/netfilter/nf_tables.h
@@ -793,6 +793,9 @@ enum nft_exthdr_attributes {
  * @NFT_META_SECPATH: boolean, secpath_exists (!!skb->sp)
  * @NFT_META_IIFKIND: packet input interface kind name (dev->rtnl_link_ops->kind)
  * @NFT_META_OIFKIND: packet output interface kind name (dev->rtnl_link_ops->kind)
+ * @NFT_META_TIME: a UNIX timestamp
+ * @NFT_META_TIME_DAY: day of week
+ * @NFT_META_TIME_HOUR: hour of day
  */
 enum nft_meta_keys {
 	NFT_META_LEN,
@@ -823,6 +826,9 @@ enum nft_meta_keys {
 	NFT_META_SECPATH,
 	NFT_META_IIFKIND,
 	NFT_META_OIFKIND,
+	NFT_META_TIME,
+	NFT_META_TIME_DAY,
+	NFT_META_TIME_HOUR,
 };
 
 /**
diff --git a/include/meta.h b/include/meta.h
index a49b4ff..a62a130 100644
--- a/include/meta.h
+++ b/include/meta.h
@@ -41,6 +41,9 @@ extern const struct datatype uid_type;
 extern const struct datatype devgroup_type;
 extern const struct datatype pkttype_type;
 extern const struct datatype ifname_type;
+extern const struct datatype date_type;
+extern const struct datatype hour_type;
+extern const struct datatype day_type;
 
 extern struct symbol_table *devgroup_tbl;
 
diff --git a/include/nftables.h b/include/nftables.h
index ed446e2..52aff12 100644
--- a/include/nftables.h
+++ b/include/nftables.h
@@ -62,6 +62,11 @@ static inline bool nft_output_guid(const struct output_ctx *octx)
 	return octx->flags & NFT_CTX_OUTPUT_GUID;
 }
 
+static inline bool nft_output_seconds(const struct output_ctx *octx)
+{
+	return octx->flags & NFT_CTX_OUTPUT_SECONDS;
+}
+
 static inline bool nft_output_numeric_proto(const struct output_ctx *octx)
 {
 	return octx->flags & NFT_CTX_OUTPUT_NUMERIC_PROTO;
diff --git a/include/nftables/libnftables.h b/include/nftables/libnftables.h
index e39c588..87d4ff5 100644
--- a/include/nftables/libnftables.h
+++ b/include/nftables/libnftables.h
@@ -52,6 +52,7 @@ enum {
 	NFT_CTX_OUTPUT_NUMERIC_PROTO	= (1 << 7),
 	NFT_CTX_OUTPUT_NUMERIC_PRIO     = (1 << 8),
 	NFT_CTX_OUTPUT_NUMERIC_SYMBOL	= (1 << 9),
+	NFT_CTX_OUTPUT_SECONDS          = (1 << 10),
 	NFT_CTX_OUTPUT_NUMERIC_ALL	= (NFT_CTX_OUTPUT_NUMERIC_PROTO |
 					   NFT_CTX_OUTPUT_NUMERIC_PRIO |
 					   NFT_CTX_OUTPUT_NUMERIC_SYMBOL),
diff --git a/src/datatype.c b/src/datatype.c
index 6d6826e..0a00535 100644
--- a/src/datatype.c
+++ b/src/datatype.c
@@ -71,6 +71,9 @@ static const struct datatype *datatypes[TYPE_MAX + 1] = {
 	[TYPE_BOOLEAN]		= &boolean_type,
 	[TYPE_IFNAME]		= &ifname_type,
 	[TYPE_IGMP_TYPE]	= &igmp_type_type,
+	[TYPE_TIME_DATE]	= &date_type,
+	[TYPE_TIME_HOUR]	= &hour_type,
+	[TYPE_TIME_DAY]		= &day_type,
 };
 
 const struct datatype *datatype_lookup(enum datatypes type)
diff --git a/src/main.c b/src/main.c
index 9a50f30..dc8ad91 100644
--- a/src/main.c
+++ b/src/main.c
@@ -43,8 +43,9 @@ enum opt_vals {
 	OPT_NUMERIC_PRIO	= 'y',
 	OPT_NUMERIC_PROTO	= 'p',
 	OPT_INVALID		= '?',
+	OPT_SECONDS		= 't',
 };
-#define OPTSTRING	"hvcf:iI:jvnsNaeSupyp"
+#define OPTSTRING	"hvcf:iI:jvnsNaeSupypt"
 
 static const struct option options[] = {
 	{
@@ -114,6 +115,10 @@ static const struct option options[] = {
 		.name		= "numeric-priority",
 		.val		= OPT_NUMERIC_PRIO,
 	},
+	{
+		.name		= "seconds",
+		.val		= OPT_SECONDS,
+	},
 	{
 		.name		= NULL
 	}
@@ -143,6 +148,7 @@ static void show_help(const char *name)
 "  -a, --handle			Output rule handle.\n"
 "  -e, --echo			Echo what has been added, inserted or replaced.\n"
 "  -I, --includepath <directory>	Add <directory> to the paths searched for include files. Default is: %s\n"
+"  -t, --seconds                Show hour values in seconds since midnight.\n"
 "  --debug <level [,level...]>	Specify debugging level (scanner, parser, eval, netlink, mnl, proto-ctx, segtree, all)\n"
 "\n",
 	name, DEFAULT_INCLUDE_PATH);
@@ -282,6 +288,9 @@ int main(int argc, char * const *argv)
 		case OPT_GUID:
 			output_flags |= NFT_CTX_OUTPUT_GUID;
 			break;
+		case OPT_SECONDS:
+			output_flags |= NFT_CTX_OUTPUT_SECONDS;
+			break;
 		case OPT_NUMERIC_PRIO:
 			output_flags |= NFT_CTX_OUTPUT_NUMERIC_PRIO;
 			break;
diff --git a/src/meta.c b/src/meta.c
index 1e8964e..152d97d 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -37,6 +37,10 @@
 #include <iface.h>
 #include <json.h>
 
+#define _XOPEN_SOURCE
+#define __USE_XOPEN
+#include <time.h>
+
 static struct symbol_table *realm_tbl;
 void realm_table_meta_init(void)
 {
@@ -383,6 +387,285 @@ const struct datatype ifname_type = {
 	.basetype	= &string_type,
 };
 
+static void date_type_print(const struct expr *expr, struct output_ctx *octx)
+{
+	char timestr[21];
+	struct tm *tm;
+	uint64_t tstamp = mpz_get_uint64(expr->value);
+
+	if (!nft_output_seconds(octx)) {
+		if ((tm = localtime((time_t *) &tstamp)) == NULL ||
+			!strftime(timestr, sizeof(timestr) - 1, "%F %T", tm))
+			nft_print(octx, "Error converting timestamp to printed time");
+
+		nft_print(octx, "\"%s\"", timestr);
+		return;
+	}
+
+	expr_basetype(expr)->print(expr, octx);
+}
+
+static time_t parse_iso_date(const char *sym)
+{
+	time_t ts = time(NULL);
+	long int gmtoff;
+	struct tm tm, *cur_tm;
+
+	memset(&tm, 0, sizeof(struct tm));
+
+	/* Obtain current tm as well, so that we can substract tm_gmtoff */
+	cur_tm = localtime(&ts);
+
+	if (strptime(sym, "%F %T", &tm))
+		goto success;
+	if (strptime(sym, "%F %R", &tm))
+		goto success;
+	if (strptime(sym, "%F", &tm))
+		goto success;
+
+	return -1;
+
+success:
+	setenv("TZ", "UTC", true);
+	tzset();
+
+	ts = mktime(&tm);
+	if (ts == (time_t) -1 || cur_tm == NULL)
+		return ts;
+
+	/* Substract tm_gmtoff to get the current time */
+	gmtoff = cur_tm->tm_gmtoff;
+	if (cur_tm->tm_isdst == 1)
+		gmtoff -= 3600;
+	return ts - gmtoff;
+}
+
+static struct error_record *date_type_parse(const struct expr *sym,
+					    struct expr **res)
+{
+	time_t tstamp;
+	const char *endptr = sym->identifier;
+
+	if ((tstamp = parse_iso_date(sym->identifier)) != -1)
+		goto success;
+
+	tstamp = strtoul(sym->identifier, (char **) &endptr, 10);
+	if (*endptr == '\0' && endptr != sym->identifier)
+		goto success;
+
+	return error(&sym->location, "Cannot parse date");
+
+success:
+	*res = constant_expr_alloc(&sym->location, sym->dtype,
+				   BYTEORDER_HOST_ENDIAN,
+				   8 * BITS_PER_BYTE,
+				   &tstamp);
+	return NULL;
+}
+
+static void day_type_print(const struct expr *expr, struct output_ctx *octx)
+{
+	const char *days[] = {
+		"Sunday",
+		"Monday",
+		"Tuesday",
+		"Wednesday",
+		"Thursday",
+		"Friday",
+		"Saturday"
+	};
+	uint8_t daynum = mpz_get_uint8(expr->value),
+		 numdays = array_size(days);
+
+	if (daynum >= 0 && daynum < numdays)
+		nft_print(octx, "\"%s\"", days[daynum]);
+	else
+		nft_print(octx, "Unknown day");
+}
+
+static int parse_day_type_numeric(const char *sym)
+{
+	char c = *sym;
+	return (c >= '0' && c <= '6') ?
+		(c - '0') :
+		-1;
+}
+
+static struct error_record *day_type_parse(const struct expr *sym,
+					   struct expr **res)
+{
+	const char *days[] = {
+		"Sunday",
+		"Monday",
+		"Tuesday",
+		"Wednesday",
+		"Thursday",
+		"Friday",
+		"Saturday"
+	};
+	int daynum = -1, numdays = array_size(days);
+	int symlen = strlen(sym->identifier), daylen;
+
+	if (symlen < 3) {
+		if (symlen == 1)
+			daynum = parse_day_type_numeric(sym->identifier);
+
+		if (daynum >= 0)
+			goto success;
+
+		return error(&sym->location, "Day name must be at least three characters long");
+	}
+
+	for (unsigned i = 0; i < numdays && daynum == -1; i++) {
+		daylen = strlen(days[i]);
+
+		if (strncasecmp(sym->identifier,
+				days[i],
+				min(symlen, daylen)) == 0)
+			daynum = i;
+	}
+
+	if (daynum == -1)
+		return error(&sym->location, "Cannot parse day");
+
+success:
+	*res = constant_expr_alloc(&sym->location, sym->dtype,
+				   BYTEORDER_HOST_ENDIAN,
+				   1 * BITS_PER_BYTE,
+				   &daynum);
+	return NULL;
+}
+
+static void __hour_type_print_r(int hours, int minutes, int seconds, char *out, size_t buflen)
+{
+	if (minutes == 60)
+		return __hour_type_print_r(++hours, 0, seconds, out, buflen);
+	else if (minutes > 60)
+		return __hour_type_print_r((int) (minutes / 60), minutes % 60, seconds, out, buflen);
+
+	if (seconds == 60)
+		return __hour_type_print_r(hours, ++minutes, 0, out, buflen);
+	else if (seconds > 60)
+		return __hour_type_print_r(hours, (int) (seconds / 60), seconds % 60, out, buflen);
+
+	if (seconds == 0)
+		snprintf(out, buflen, "%02d:%02d", hours, minutes);
+	else
+		snprintf(out, buflen, "%02d:%02d:%02d", hours, minutes, seconds);
+}
+
+static void hour_type_print(const struct expr *expr, struct output_ctx *octx)
+{
+	char out[9];
+	time_t ts;
+	struct tm *cur_tm;
+	uint64_t seconds = mpz_get_uint64(expr->value);
+
+	if (!nft_output_seconds(octx)) {
+		/* Obtain current tm, so that we can add tm_gmtoff */
+		ts = time(NULL);
+		cur_tm = localtime(&ts);
+
+		if (cur_tm)
+			seconds = (seconds + cur_tm->tm_gmtoff) % 86400;
+
+		__hour_type_print_r(0, 0, seconds, out, sizeof(out));
+		nft_print(octx, "\"%s\"", out);
+
+		return;
+	}
+	
+	expr_basetype(expr)->print(expr, octx);
+}
+
+static struct error_record *hour_type_parse(const struct expr *sym,
+					    struct expr **res)
+{
+	time_t ts;
+	char *endptr;
+	struct tm tm, *cur_tm;
+	uint64_t result = 0;
+	struct error_record *er;
+
+	memset(&tm, 0, sizeof(struct tm));
+
+	/* First, try to parse it as a number */
+	result = strtoul(sym->identifier, (char **) &endptr, 10);
+	if (*endptr == '\0' && endptr != sym->identifier)
+		goto success;
+
+	result = 0;
+
+	/* Obtain current tm, so that we can substract tm_gmtoff */
+	ts = time(NULL);
+	cur_tm = localtime(&ts);
+
+	if (strptime(sym->identifier, "%T", &tm))
+		goto convert;
+	if (strptime(sym->identifier, "%R", &tm))
+		goto convert;
+
+	if ((er = time_parse(&sym->location, sym->identifier, &result)) == NULL) {
+		result /= 1000;
+		goto convert;
+	}
+
+	return er;
+
+convert:
+	/* Convert the hour to the number of seconds since midnight */
+	if (result == 0)
+		result = tm.tm_hour * 3600 + tm.tm_min * 60 + tm.tm_sec;
+
+	/* Substract tm_gmtoff to get the current time */
+	if (cur_tm) {
+		if (result >= cur_tm->tm_gmtoff)
+			result -= cur_tm->tm_gmtoff;
+		else
+			result = 86400 - cur_tm->tm_gmtoff + result;
+	}
+
+success:
+	*res = constant_expr_alloc(&sym->location, sym->dtype,
+				   BYTEORDER_HOST_ENDIAN,
+				   8 * BITS_PER_BYTE,
+				   &result);
+	return NULL;
+}
+
+const struct datatype date_type = {
+	.type = TYPE_TIME_DATE,
+	.name = "time",
+	.desc = "Relative time of packet reception",
+	.byteorder = BYTEORDER_HOST_ENDIAN,
+	.size = sizeof(uint64_t) * BITS_PER_BYTE,
+	.basetype = &integer_type,
+	.print = date_type_print,
+	.parse = date_type_parse,
+};
+
+const struct datatype day_type = {
+	.type = TYPE_TIME_DAY,
+	.name = "day",
+	.desc = "Day of week of packet reception",
+	.byteorder = BYTEORDER_HOST_ENDIAN,
+	.size = 1 * BITS_PER_BYTE,
+	.basetype = &integer_type,
+	.print = day_type_print,
+	.parse = day_type_parse,
+};
+
+const struct datatype hour_type = {
+	.type = TYPE_TIME_HOUR,
+	.name = "hour",
+	.desc = "Hour of day of packet reception",
+	.byteorder = BYTEORDER_HOST_ENDIAN,
+	.size = sizeof(uint64_t) * BITS_PER_BYTE,
+	.basetype = &integer_type,
+	.print = hour_type_print,
+	.parse = hour_type_parse,
+};
+
 const struct meta_template meta_templates[] = {
 	[NFT_META_LEN]		= META_TEMPLATE("length",    &integer_type,
 						4 * 8, BYTEORDER_HOST_ENDIAN),
@@ -450,6 +733,15 @@ const struct meta_template meta_templates[] = {
 	[NFT_META_OIFKIND]	= META_TEMPLATE("oifkind",   &ifname_type,
 						IFNAMSIZ * BITS_PER_BYTE,
 						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_TIME]		= META_TEMPLATE("time",   &date_type,
+						8 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_TIME_DAY]	= META_TEMPLATE("day", &day_type,
+						1 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
+	[NFT_META_TIME_HOUR]	= META_TEMPLATE("hour", &hour_type,
+						8 * BITS_PER_BYTE,
+						BYTEORDER_HOST_ENDIAN),
 };
 
 static bool meta_key_is_unqualified(enum nft_meta_keys key)
diff --git a/src/parser_bison.y b/src/parser_bison.y
index 670e91f..26b64da 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -415,6 +415,7 @@ int nft_lex(void *, void *, void *);
 %token IIFGROUP			"iifgroup"
 %token OIFGROUP			"oifgroup"
 %token CGROUP			"cgroup"
+%token TIME			"time"
 
 %token CLASSID			"classid"
 %token NEXTHOP			"nexthop"
@@ -3886,6 +3887,9 @@ meta_key_unqualified	:	MARK		{ $$ = NFT_META_MARK; }
 			|       OIFGROUP	{ $$ = NFT_META_OIFGROUP; }
 			|       CGROUP		{ $$ = NFT_META_CGROUP; }
 			|       IPSEC		{ $$ = NFT_META_SECPATH; }
+			|       TIME		{ $$ = NFT_META_TIME; }
+			|       DAY		{ $$ = NFT_META_TIME_DAY; }
+			|       HOUR		{ $$ = NFT_META_TIME_HOUR; }
 			;
 
 meta_stmt		:	META	meta_key	SET	stmt_expr
diff --git a/src/scanner.l b/src/scanner.l
index d1f6e87..bd28141 100644
--- a/src/scanner.l
+++ b/src/scanner.l
@@ -411,7 +411,9 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
 "sack2"			{ return SACK2; }
 "sack3"			{ return SACK3; }
 "sack-permitted"	{ return SACK_PERMITTED; }
-"timestamp"		{ return TIMESTAMP; }
+"time"			{ return TIME; }
+"day"			{ return DAY; }
+"hour"			{ return HOUR; }
 
 "kind"			{ return KIND; }
 "count"			{ return COUNT; }
-- 
2.17.1

