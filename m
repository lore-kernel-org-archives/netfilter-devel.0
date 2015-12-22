From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: [PATCH v2] extensions: libxt_limit: Add translation to nft
Date: Wed, 23 Dec 2015 03:25:21 +0530
Message-ID: <20151222215521.GA18035@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34619 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932680AbbLVVz3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 16:55:29 -0500
Received: by mail-pf0-f193.google.com with SMTP id u7so9857694pfb.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 13:55:28 -0800 (PST)
Received: from gmail.com ([223.176.190.114])
        by smtp.gmail.com with ESMTPSA id i72sm24150535pfj.64.2015.12.22.13.55.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=AES128-SHA bits=128/128);
        Tue, 22 Dec 2015 13:55:27 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add translation for module limit to nftables.

Examples:

$ sudo iptables-translate -A INPUT -m limit --limit 5/s
nft add rule ip filter INPUT limit rate 5/second counter

$ sudo iptables-translate -A INPUT -m limit --limit 3/m --limit-burst 3
nft add rule ip filter INPUT limit rate 3/minute burst 3 packets counter

Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
---
Changes in v2:
	Fix coding style problems

 extensions/libxt_limit.c | 59 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 9 deletions(-)

diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index f75ef2f..1874686 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -25,8 +25,8 @@ static void limit_help(void)
 {
 	printf(
 "limit match options:\n"
-"--limit avg			max average match rate: default "XT_LIMIT_AVG"\n"
-"                                [Packets per second unless followed by \n"
+"--limit avg		max average match rate: default "XT_LIMIT_AVG"\n"
+"                                [Packets per second unless followed by\n"
 "                                /sec /minute /hour /day postfixes]\n"
 "--limit-burst number		number to match in a burst, default %u\n",
 XT_LIMIT_BURST);
@@ -73,7 +73,8 @@ int parse_rate(const char *rate, uint32_t *val)
 		 * The rate maps to infinity. (1/day is the minimum they can
 		 * specify, so we are ok at that end).
 		 */
-		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
+		xtables_error(PARAMETER_PROBLEM,
+			      "Rate too fast \"%s\"\n", rate);
 	return 1;
 }
 
@@ -86,10 +87,11 @@ static void limit_init(struct xt_entry_match *m)
 
 }
 
-/* FIXME: handle overflow:
-	if (r->avg*r->burst/r->burst != r->avg)
-		xtables_error(PARAMETER_PROBLEM,
-			   "Sorry: burst too large for that avg rate.\n");
+/*
+ * FIXME: handle overflow:
+ * if (r->avg*r->burst/r->burst != r->avg)
+ *	xtables_error(PARAMETER_PROBLEM,
+ *	"Sorry: burst too large for that avg rate.\n");
 */
 
 static void limit_parse(struct xt_option_call *cb)
@@ -128,8 +130,8 @@ static void print_rate(uint32_t period)
 	}
 
 	for (i = 1; i < ARRAY_SIZE(rates); ++i)
-		if (period > rates[i].mult
-            || rates[i].mult/period < rates[i].mult%period)
+		if (period > rates[i].mult ||
+		    rates[i].mult / period < rates[i].mult % period)
 			break;
 
 	printf(" %u/%s", rates[i-1].mult / period, rates[i-1].name);
@@ -139,6 +141,7 @@ static void
 limit_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_rateinfo *r = (const void *)match->data;
+
 	printf(" limit: avg"); print_rate(r->avg);
 	printf(" burst %u", r->burst);
 }
@@ -152,6 +155,43 @@ static void limit_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --limit-burst %u", r->burst);
 }
 
+static const struct rates rates_xlate[] = {
+		{ "day", XT_LIMIT_SCALE*24*60*60 },
+		{ "hour", XT_LIMIT_SCALE*60*60 },
+		{ "minute", XT_LIMIT_SCALE*60 },
+		{ "second", XT_LIMIT_SCALE } };
+
+static void print_rate_xlate(uint32_t period, struct xt_buf *buf)
+{
+	unsigned int i;
+
+	if (period == 0) {
+		xt_buf_add(buf, " %f ", INFINITY);
+		return;
+	}
+
+	for (i = 1; i < ARRAY_SIZE(rates); ++i)
+		if (period > rates_xlate[i].mult ||
+		    rates_xlate[i].mult / period < rates_xlate[i].mult % period)
+			break;
+
+	xt_buf_add(buf, " %u/%s ", rates_xlate[i-1].mult / period,
+		   rates_xlate[i-1].name);
+}
+
+static int limit_xlate(const struct xt_entry_match *match,
+		       struct xt_buf *buf, int numeric)
+{
+	const struct xt_rateinfo *r = (const void *)match->data;
+
+	xt_buf_add(buf, "limit rate");
+	print_rate_xlate(r->avg, buf);
+	if (r->burst != XT_LIMIT_BURST)
+		xt_buf_add(buf, "burst %u packets ", r->burst);
+
+	return 1;
+}
+
 static struct xtables_match limit_match = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "limit",
@@ -164,6 +204,7 @@ static struct xtables_match limit_match = {
 	.print		= limit_print,
 	.save		= limit_save,
 	.x6_options	= limit_opts,
+	.xlate		= limit_xlate,
 };
 
 void _init(void)
-- 
1.9.1

