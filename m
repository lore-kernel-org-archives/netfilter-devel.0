From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] libxt_connbytes: fix handling of --connbytes FROM
Date: Fri, 16 Dec 2011 18:34:06 +0100
Message-ID: <1324056846-557-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:52257 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751955Ab1LPRcU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Dec 2011 12:32:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

quoting man page:

match packets  from  a  connection  whose packets/bytes/average
packet size is more than FROM and less than TO bytes/packets. if
TO is omitted only FROM check is done.

But, when TO was omitted, we did treat it like "x:x" which is not
the same at all.

Before commit 09631dc60ce41bc484a42fcf4d4ddf7036820bd1
(libxt_connbytes: use guided option parser), we failed to parse
"--connbytes x" ('Bad range "x"'), but treated "x:" like "x:0xffffffff".

Also, restore the "from must be smaller than to" check.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libxt_connbytes.c |   42 +++++++++++++++++++++++++-----------------
 1 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 46a7e4b..ed2ad25 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -37,9 +37,14 @@ static void connbytes_parse(struct xt_option_call *cb)
 	switch (cb->entry->id) {
 	case O_CONNBYTES:
 		sinfo->count.from = cb->val.u64_range[0];
-		sinfo->count.to   = cb->val.u64_range[0];
+		sinfo->count.to   = UINT64_MAX;
 		if (cb->nvals == 2)
 			sinfo->count.to = cb->val.u64_range[1];
+
+		if (sinfo->count.to < sinfo->count.from)
+			xtables_error(PARAMETER_PROBLEM, "%llu should be less than %llu",
+					(unsigned long long)sinfo->count.from,
+					(unsigned long long)sinfo->count.to);
 		if (cb->invert) {
 			i = sinfo->count.from;
 			sinfo->count.from = sinfo->count.to;
@@ -107,19 +112,29 @@ static void print_direction(const struct xt_connbytes_info *sinfo)
 	}
 }
 
+static void print_from_to(const struct xt_connbytes_info *sinfo, const char *prefix)
+{
+	unsigned long long from, to;
+
+	if (sinfo->count.from > sinfo->count.to) {
+		fputs(" !", stdout);
+		from = sinfo->count.to;
+		to = sinfo->count.from;
+	} else {
+		to = sinfo->count.to;
+		from = sinfo->count.from;
+	}
+	printf(" %sconnbytes %llu", prefix, from);
+	if (to && to < UINT64_MAX)
+		printf(":%llu", to);
+}
+
 static void
 connbytes_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_connbytes_info *sinfo = (const void *)match->data;
 
-	if (sinfo->count.from > sinfo->count.to) 
-		printf(" connbytes ! %llu:%llu",
-			(unsigned long long)sinfo->count.to,
-			(unsigned long long)sinfo->count.from);
-	else
-		printf(" connbytes %llu:%llu",
-			(unsigned long long)sinfo->count.from,
-			(unsigned long long)sinfo->count.to);
+	print_from_to(sinfo, "");
 
 	fputs(" connbytes mode", stdout);
 	print_mode(sinfo);
@@ -132,14 +147,7 @@ static void connbytes_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_connbytes_info *sinfo = (const void *)match->data;
 
-	if (sinfo->count.from > sinfo->count.to) 
-		printf(" ! --connbytes %llu:%llu",
-			(unsigned long long)sinfo->count.to,
-			(unsigned long long)sinfo->count.from);
-	else
-		printf(" --connbytes %llu:%llu",
-			(unsigned long long)sinfo->count.from,
-			(unsigned long long)sinfo->count.to);
+	print_from_to(sinfo, "--");
 
 	fputs(" --connbytes-mode", stdout);
 	print_mode(sinfo);
-- 
1.7.3.4

