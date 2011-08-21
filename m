From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 21/21] libxt_hashlimit: observe new default gc-expire time when saving
Date: Sun, 21 Aug 2011 13:09:36 +0200
Message-ID: <1313924977-8623-22-git-send-email-jengelh@medozas.de>
References: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:38790 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab1HULKD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Aug 2011 07:10:03 -0400
In-Reply-To: <1313924977-8623-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since a while, --htable-gc-expire defaults to the chosen time quantum
instead of 10 fixed seconds, which leads the expiry value to be always
printed, which is redundant.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_hashlimit.c |   33 ++++++++++++++++++++-------------
 tests/options-most.rules     |    1 +
 2 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index eb52b16..da34cb2 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -23,7 +23,6 @@
 
 /* miliseconds */
 #define XT_HASHLIMIT_GCINTERVAL	1000
-#define XT_HASHLIMIT_EXPIRE	10000
 
 struct hashlimit_mt_udata {
 	uint32_t mult;
@@ -187,7 +186,6 @@ static void hashlimit_init(struct xt_entry_match *m)
 
 	r->cfg.burst = XT_HASHLIMIT_BURST;
 	r->cfg.gc_interval = XT_HASHLIMIT_GCINTERVAL;
-	r->cfg.expire = XT_HASHLIMIT_EXPIRE;
 
 }
 
@@ -198,7 +196,6 @@ static void hashlimit_mt4_init(struct xt_entry_match *match)
 	info->cfg.mode        = 0;
 	info->cfg.burst       = XT_HASHLIMIT_BURST;
 	info->cfg.gc_interval = XT_HASHLIMIT_GCINTERVAL;
-	info->cfg.expire      = XT_HASHLIMIT_EXPIRE;
 	info->cfg.srcmask     = 32;
 	info->cfg.dstmask     = 32;
 }
@@ -210,7 +207,6 @@ static void hashlimit_mt6_init(struct xt_entry_match *match)
 	info->cfg.mode        = 0;
 	info->cfg.burst       = XT_HASHLIMIT_BURST;
 	info->cfg.gc_interval = XT_HASHLIMIT_GCINTERVAL;
-	info->cfg.expire      = XT_HASHLIMIT_EXPIRE;
 	info->cfg.srcmask     = 128;
 	info->cfg.dstmask     = 128;
 }
@@ -330,7 +326,7 @@ static const struct rates
 	      { "min", XT_HASHLIMIT_SCALE*60 },
 	      { "sec", XT_HASHLIMIT_SCALE } };
 
-static void print_rate(uint32_t period)
+static uint32_t print_rate(uint32_t period)
 {
 	unsigned int i;
 
@@ -340,6 +336,8 @@ static void print_rate(uint32_t period)
 			break;
 
 	printf(" %u/%s", rates[i-1].mult / period, rates[i-1].name);
+	/* return in msec */
+	return rates[i-1].mult / XT_HASHLIMIT_SCALE * 1000;
 }
 
 static void print_mode(unsigned int mode, char separator)
@@ -374,7 +372,10 @@ static void hashlimit_print(const void *ip,
                             const struct xt_entry_match *match, int numeric)
 {
 	const struct xt_hashlimit_info *r = (const void *)match->data;
-	fputs(" limit: avg", stdout); print_rate(r->cfg.avg);
+	uint32_t quantum;
+
+	fputs(" limit: avg", stdout);
+	quantum = print_rate(r->cfg.avg);
 	printf(" burst %u", r->cfg.burst);
 	fputs(" mode", stdout);
 	print_mode(r->cfg.mode, '-');
@@ -384,18 +385,20 @@ static void hashlimit_print(const void *ip,
 		printf(" htable-max %u", r->cfg.max);
 	if (r->cfg.gc_interval != XT_HASHLIMIT_GCINTERVAL)
 		printf(" htable-gcinterval %u", r->cfg.gc_interval);
-	if (r->cfg.expire != XT_HASHLIMIT_EXPIRE)
+	if (r->cfg.expire != quantum)
 		printf(" htable-expire %u", r->cfg.expire);
 }
 
 static void
 hashlimit_mt_print(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
 {
+	uint32_t quantum;
+
 	if (info->cfg.mode & XT_HASHLIMIT_INVERT)
 		fputs(" limit: above", stdout);
 	else
 		fputs(" limit: up to", stdout);
-	print_rate(info->cfg.avg);
+	quantum = print_rate(info->cfg.avg);
 	printf(" burst %u", info->cfg.burst);
 	if (info->cfg.mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
 	    XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT)) {
@@ -408,7 +411,7 @@ hashlimit_mt_print(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
 		printf(" htable-max %u", info->cfg.max);
 	if (info->cfg.gc_interval != XT_HASHLIMIT_GCINTERVAL)
 		printf(" htable-gcinterval %u", info->cfg.gc_interval);
-	if (info->cfg.expire != XT_HASHLIMIT_EXPIRE)
+	if (info->cfg.expire != quantum)
 		printf(" htable-expire %u", info->cfg.expire);
 
 	if (info->cfg.srcmask != dmask)
@@ -438,8 +441,10 @@ hashlimit_mt6_print(const void *ip, const struct xt_entry_match *match,
 static void hashlimit_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_hashlimit_info *r = (const void *)match->data;
+	uint32_t quantum;
 
-	fputs(" --hashlimit", stdout); print_rate(r->cfg.avg);
+	fputs(" --hashlimit", stdout);
+	quantum = print_rate(r->cfg.avg);
 	printf(" --hashlimit-burst %u", r->cfg.burst);
 
 	fputs(" --hashlimit-mode", stdout);
@@ -453,18 +458,20 @@ static void hashlimit_save(const void *ip, const struct xt_entry_match *match)
 		printf(" --hashlimit-htable-max %u", r->cfg.max);
 	if (r->cfg.gc_interval != XT_HASHLIMIT_GCINTERVAL)
 		printf(" --hashlimit-htable-gcinterval %u", r->cfg.gc_interval);
-	if (r->cfg.expire != XT_HASHLIMIT_EXPIRE)
+	if (r->cfg.expire != quantum)
 		printf(" --hashlimit-htable-expire %u", r->cfg.expire);
 }
 
 static void
 hashlimit_mt_save(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
 {
+	uint32_t quantum;
+
 	if (info->cfg.mode & XT_HASHLIMIT_INVERT)
 		fputs(" --hashlimit-above", stdout);
 	else
 		fputs(" --hashlimit-upto", stdout);
-	print_rate(info->cfg.avg);
+	quantum = print_rate(info->cfg.avg);
 	printf(" --hashlimit-burst %u", info->cfg.burst);
 
 	if (info->cfg.mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
@@ -481,7 +488,7 @@ hashlimit_mt_save(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
 		printf(" --hashlimit-htable-max %u", info->cfg.max);
 	if (info->cfg.gc_interval != XT_HASHLIMIT_GCINTERVAL)
 		printf(" --hashlimit-htable-gcinterval %u", info->cfg.gc_interval);
-	if (info->cfg.expire != XT_HASHLIMIT_EXPIRE)
+	if (info->cfg.expire != quantum)
 		printf(" --hashlimit-htable-expire %u", info->cfg.expire);
 
 	if (info->cfg.srcmask != dmask)
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 0e876e6..e54eb12 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -92,6 +92,7 @@
 -A matches
 -A matches -p esp -m esp --espspi 5:4294967295
 -A matches
+-A matches -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 1 --hashlimit-name mini1 --hashlimit-htable-expire 2000
 -A matches -m hashlimit --hashlimit-upto 1/sec --hashlimit-burst 1 --hashlimit-name mini1
 -A matches -m hashlimit --hashlimit-upto 1/min --hashlimit-burst 1 --hashlimit-name mini2
 -A matches -m hashlimit --hashlimit-upto 1/hour --hashlimit-burst 1 --hashlimit-name mini3
-- 
1.7.3.4

