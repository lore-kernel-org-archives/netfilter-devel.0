From: Florian Westphal <fw@strlen.de>
Subject: [PATCH] libxt_hashlimit: add support for byte-based operation
Date: Tue,  8 May 2012 15:16:52 +0200
Message-ID: <1336483012-12169-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:52160 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753277Ab2EHNOz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 09:14:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

allows --hashlimit-(upto|above) Xb/s [ --hashlimit-burst Yb ]
to make hashlimit match when X bytes/second are exceeded;
optionally, Y bytes will not be matched (i.e. bursted).

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 Note:
 I've re-used the existing options. For example,
 --hashlimit-mode srcip,dstip,srcport,dstport --hashlimit\-above 512kb/s would
 match when the flow exceeded 512kbytes per second.

 Similarily, the --hashlimit-burst parameter now either a number (packetcount)
 number, or a "byte" suffix, e.g. "--hashlimit-burst 1mb".

 If you believe that we should introduce new options instead, please
 let me know and I'll re-spin the patch.

 extensions/libxt_hashlimit.c           |  171 +++++++++++++++++++++++++++++--
 extensions/libxt_hashlimit.man         |   19 +++-
 include/linux/netfilter/xt_hashlimit.h |    6 +-
 tests/options-most.rules               |    3 +
 4 files changed, 183 insertions(+), 16 deletions(-)

diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index da34cb2..c4e8777 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -20,6 +20,10 @@
 #include <linux/netfilter/xt_hashlimit.h>
 
 #define XT_HASHLIMIT_BURST	5
+#define XT_HASHLIMIT_BURST_MAX	10000
+
+#define XT_HASHLIMIT_BYTE_EXPIRE	15
+#define XT_HASHLIMIT_BYTE_EXPIRE_BURST	60
 
 /* miliseconds */
 #define XT_HASHLIMIT_GCINTERVAL	1000
@@ -59,6 +63,7 @@ enum {
 	O_HTABLE_MAX,
 	O_HTABLE_GCINT,
 	O_HTABLE_EXPIRE,
+	F_BURST         = 1 << O_BURST,
 	F_UPTO          = 1 << O_UPTO,
 	F_ABOVE         = 1 << O_ABOVE,
 	F_HTABLE_EXPIRE = 1 << O_HTABLE_EXPIRE,
@@ -90,7 +95,7 @@ static const struct xt_option_entry hashlimit_opts[] = {
 	{.name = "hashlimit", .id = O_UPTO, .excl = F_ABOVE,
 	 .type = XTTYPE_STRING},
 	{.name = "hashlimit-burst", .id = O_BURST, .type = XTTYPE_UINT32,
-	 .min = 1, .max = 10000, .flags = XTOPT_PUT,
+	 .min = 1, .max = XT_HASHLIMIT_BURST_MAX, .flags = XTOPT_PUT,
 	 XTOPT_POINTER(s, cfg.burst)},
 	{.name = "hashlimit-htable-size", .id = O_HTABLE_SIZE,
 	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
@@ -122,9 +127,7 @@ static const struct xt_option_entry hashlimit_mt_opts[] = {
 	 .type = XTTYPE_STRING, .flags = XTOPT_INVERT}, /* old name */
 	{.name = "hashlimit-srcmask", .id = O_SRCMASK, .type = XTTYPE_PLEN},
 	{.name = "hashlimit-dstmask", .id = O_DSTMASK, .type = XTTYPE_PLEN},
-	{.name = "hashlimit-burst", .id = O_BURST, .type = XTTYPE_UINT32,
-	 .min = 1, .max = 10000, .flags = XTOPT_PUT,
-	 XTOPT_POINTER(s, cfg.burst)},
+	{.name = "hashlimit-burst", .id = O_BURST, .type = XTTYPE_STRING},
 	{.name = "hashlimit-htable-size", .id = O_HTABLE_SIZE,
 	 .type = XTTYPE_UINT32, .flags = XTOPT_PUT,
 	 XTOPT_POINTER(s, cfg.size)},
@@ -144,6 +147,82 @@ static const struct xt_option_entry hashlimit_mt_opts[] = {
 };
 #undef s
 
+static uint32_t cost_to_bytes(uint32_t cost)
+{
+	uint32_t r;
+
+	r = cost ? UINT32_MAX / cost : UINT32_MAX;
+	r = (r - 1) << XT_HASHLIMIT_BYTE_SHIFT;
+	return r;
+}
+
+static uint64_t bytes_to_cost(uint32_t bytes)
+{
+	uint32_t r = bytes >> XT_HASHLIMIT_BYTE_SHIFT;
+	return UINT32_MAX / (r+1);
+}
+
+static uint32_t get_factor(int chr)
+{
+	switch (chr) {
+	case 'm': return 1024 * 1024;
+	case 'k': return 1024;
+	}
+	return 1;
+}
+
+static void burst_error(void)
+{
+	xtables_error(PARAMETER_PROBLEM, "bad value for option "
+			"\"--hashlimit-burst\", or out of range (1-%u).", XT_HASHLIMIT_BURST_MAX);
+}
+
+static uint32_t parse_burst(const char *burst, struct xt_hashlimit_mtinfo1 *info)
+{
+	uintmax_t v;
+	char *end;
+
+	if (!xtables_strtoul(burst, &end, &v, 1, UINT32_MAX) ||
+	    (*end == 0 && v > XT_HASHLIMIT_BURST_MAX))
+		burst_error();
+
+	v *= get_factor(*end);
+	if (v > UINT32_MAX)
+		xtables_error(PARAMETER_PROBLEM, "bad value for option "
+			"\"--hashlimit-burst\", value \"%s\" too large "
+				"(max %umb).", burst, UINT32_MAX/1024/1024);
+	return v;
+}
+
+static bool parse_bytes(const char *rate, uint32_t *val, struct hashlimit_mt_udata *ud)
+{
+	unsigned int factor = 1;
+	uint64_t tmp;
+	int r;
+	const char *mode = strstr(rate, "b/s");
+	if (!mode || mode == rate)
+		return false;
+
+	mode--;
+	r = atoi(rate);
+	if (r == 0)
+		return false;
+
+	factor = get_factor(*mode);
+	tmp = (uint64_t) r * factor;
+	if (tmp > UINT32_MAX)
+		xtables_error(PARAMETER_PROBLEM,
+			"Rate value too large \"%llu\" (max %u)\n",
+					tmp, UINT32_MAX);
+
+	*val = bytes_to_cost(tmp);
+	if (*val == 0)
+		xtables_error(PARAMETER_PROBLEM, "Rate too high \"%s\"\n", rate);
+
+	ud->mult = XT_HASHLIMIT_BYTE_EXPIRE;
+	return true;
+}
+
 static
 int parse_rate(const char *rate, uint32_t *val, struct hashlimit_mt_udata *ud)
 {
@@ -265,17 +344,24 @@ static void hashlimit_mt_parse(struct xt_option_call *cb)
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
+	case O_BURST:
+		info->cfg.burst = parse_burst(cb->arg, info);
+		break;
 	case O_UPTO:
 		if (cb->invert)
 			info->cfg.mode |= XT_HASHLIMIT_INVERT;
-		if (!parse_rate(cb->arg, &info->cfg.avg, cb->udata))
+		if (parse_bytes(cb->arg, &info->cfg.avg, cb->udata))
+			info->cfg.mode |= XT_HASHLIMIT_BYTES;
+		else if (!parse_rate(cb->arg, &info->cfg.avg, cb->udata))
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-upto", cb->arg);
 		break;
 	case O_ABOVE:
 		if (!cb->invert)
 			info->cfg.mode |= XT_HASHLIMIT_INVERT;
-		if (!parse_rate(cb->arg, &info->cfg.avg, cb->udata))
+		if (parse_bytes(cb->arg, &info->cfg.avg, cb->udata))
+			info->cfg.mode |= XT_HASHLIMIT_BYTES;
+		else if (!parse_rate(cb->arg, &info->cfg.avg, cb->udata))
 			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-above", cb->arg);
 		break;
@@ -315,6 +401,24 @@ static void hashlimit_mt_check(struct xt_fcheck_call *cb)
 				"You have to specify --hashlimit");
 	if (!(cb->xflags & F_HTABLE_EXPIRE))
 		info->cfg.expire = udata->mult * 1000; /* from s to msec */
+
+	if (info->cfg.mode & XT_HASHLIMIT_BYTES) {
+		uint32_t burst = 0;
+		if (cb->xflags & F_BURST) {
+			if (info->cfg.burst < cost_to_bytes(info->cfg.avg))
+				xtables_error(PARAMETER_PROBLEM,
+					"burst cannot be smaller than %ub", cost_to_bytes(info->cfg.avg));
+
+			burst = info->cfg.burst;
+			burst /= cost_to_bytes(info->cfg.avg);
+			if (info->cfg.burst % cost_to_bytes(info->cfg.avg))
+				burst++;
+			if (!(cb->xflags & F_HTABLE_EXPIRE))
+				info->cfg.expire = XT_HASHLIMIT_BYTE_EXPIRE_BURST * 1000;
+		}
+		info->cfg.burst = burst;
+	} else if (info->cfg.burst > XT_HASHLIMIT_BURST_MAX)
+		burst_error();
 }
 
 static const struct rates
@@ -340,6 +444,41 @@ static uint32_t print_rate(uint32_t period)
 	return rates[i-1].mult / XT_HASHLIMIT_SCALE * 1000;
 }
 
+static const struct {
+	const char *name;
+	uint32_t thresh;
+} units[] = {
+	{ "m", 1024 * 1024 },
+	{ "k", 1024 },
+	{ "", 1 },
+};
+
+static uint32_t print_bytes(uint32_t avg, uint32_t burst, const char *prefix)
+{
+	unsigned int i;
+	unsigned long long r;
+
+	r = cost_to_bytes(avg);
+
+	for (i = 0; i < ARRAY_SIZE(units) -1; ++i)
+		if (r >= units[i].thresh &&
+		    bytes_to_cost(r & ~(units[i].thresh - 1)) == avg)
+			break;
+	printf(" %llu%sb/s", r/units[i].thresh, units[i].name);
+
+	if (burst == 0)
+		return XT_HASHLIMIT_BYTE_EXPIRE * 1000;
+
+	r *= burst;
+	printf(" %s", prefix);
+	for (i = 0; i < ARRAY_SIZE(units) -1; ++i)
+		if (r >= units[i].thresh)
+			break;
+
+	printf("burst %llu%sb", r / units[i].thresh, units[i].name);
+	return XT_HASHLIMIT_BYTE_EXPIRE_BURST * 1000;
+}
+
 static void print_mode(unsigned int mode, char separator)
 {
 	bool prevmode = false;
@@ -398,8 +537,13 @@ hashlimit_mt_print(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
 		fputs(" limit: above", stdout);
 	else
 		fputs(" limit: up to", stdout);
-	quantum = print_rate(info->cfg.avg);
-	printf(" burst %u", info->cfg.burst);
+
+	if (info->cfg.mode & XT_HASHLIMIT_BYTES) {
+		quantum = print_bytes(info->cfg.avg, info->cfg.burst, "");
+	} else {
+		quantum = print_rate(info->cfg.avg);
+		printf(" burst %u", info->cfg.burst);
+	}
 	if (info->cfg.mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
 	    XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT)) {
 		fputs(" mode", stdout);
@@ -449,7 +593,7 @@ static void hashlimit_save(const void *ip, const struct xt_entry_match *match)
 
 	fputs(" --hashlimit-mode", stdout);
 	print_mode(r->cfg.mode, ',');
-	
+
 	printf(" --hashlimit-name %s", r->name);
 
 	if (r->cfg.size)
@@ -471,8 +615,13 @@ hashlimit_mt_save(const struct xt_hashlimit_mtinfo1 *info, unsigned int dmask)
 		fputs(" --hashlimit-above", stdout);
 	else
 		fputs(" --hashlimit-upto", stdout);
-	quantum = print_rate(info->cfg.avg);
-	printf(" --hashlimit-burst %u", info->cfg.burst);
+
+	if (info->cfg.mode & XT_HASHLIMIT_BYTES) {
+		quantum = print_bytes(info->cfg.avg, info->cfg.burst, "--hashlimit-");
+	} else {
+		quantum = print_rate(info->cfg.avg);
+		printf(" --hashlimit-burst %u", info->cfg.burst);
+	}
 
 	if (info->cfg.mode & (XT_HASHLIMIT_HASH_SIP | XT_HASHLIMIT_HASH_SPT |
 	    XT_HASHLIMIT_HASH_DIP | XT_HASHLIMIT_HASH_DPT)) {
diff --git a/extensions/libxt_hashlimit.man b/extensions/libxt_hashlimit.man
index f90577e..17cb2b0 100644
--- a/extensions/libxt_hashlimit.man
+++ b/extensions/libxt_hashlimit.man
@@ -2,14 +2,15 @@
 \fBlimit\fP match) for a group of connections using a \fBsingle\fP iptables
 rule. Grouping can be done per-hostgroup (source and/or destination address)
 and/or per-port. It gives you the ability to express "\fIN\fP packets per time
-quantum per group" (see below for some examples).
+quantum per group" or "\fIN\fP bytes per seconds" (see below for some examples).
 .PP
 A hash limit option (\fB\-\-hashlimit\-upto\fP, \fB\-\-hashlimit\-above\fP) and
 \fB\-\-hashlimit\-name\fP are required.
 .TP
 \fB\-\-hashlimit\-upto\fP \fIamount\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
-Match if the rate is below or equal to \fIamount\fP/quantum. It is specified as
-a number, with an optional time quantum suffix; the default is 3/hour.
+Match if the rate is below or equal to \fIamount\fP/quantum. It is specified either as
+a number, with an optional time quantum suffix (the default is 3/hour), or as
+\fIamount\fPb/second (number of bytes per second).
 .TP
 \fB\-\-hashlimit\-above\fP \fIamount\fP[\fB/second\fP|\fB/minute\fP|\fB/hour\fP|\fB/day\fP]
 Match if the rate is above \fIamount\fP/quantum.
@@ -17,7 +18,9 @@ Match if the rate is above \fIamount\fP/quantum.
 \fB\-\-hashlimit\-burst\fP \fIamount\fP
 Maximum initial number of packets to match: this number gets recharged by one
 every time the limit specified above is not reached, up to this number; the
-default is 5.
+default is 5.  When byte-based rate matching is requested, this option specifies
+the amount of bytes that can exceed the given rate.  This option should be used
+with caution -- if the entry expires, the burst value is reset too.
 .TP
 \fB\-\-hashlimit\-mode\fP {\fBsrcip\fP|\fBsrcport\fP|\fBdstip\fP|\fBdstport\fP}\fB,\fP...
 A comma-separated list of objects to take into consideration. If no
@@ -63,3 +66,11 @@ matching on subnet
 "10000 packets per minute for every /28 subnet (groups of 8 addresses)
 in 10.0.0.0/8" =>
 \-s 10.0.0.8 \-\-hashlimit\-mask 28 \-\-hashlimit\-upto 10000/min
+.TP
+matching bytes per second
+"flows exceeding 512kbyte/s" =>
+\-\-hashlimit-mode srcip,dstip,srcport,dstport \-\-hashlimit\-above 512kb/s
+.TP
+matching bytes per second
+"hosts that exceed 512kbyte/s, but permit up to 1Megabytes without matching"
+\-\-hashlimit-mode dstip \-\-hashlimit\-above 512kb/s \-\-hashlimit-burst 1mb
diff --git a/include/linux/netfilter/xt_hashlimit.h b/include/linux/netfilter/xt_hashlimit.h
index b1925b5..141efbd 100644
--- a/include/linux/netfilter/xt_hashlimit.h
+++ b/include/linux/netfilter/xt_hashlimit.h
@@ -6,7 +6,10 @@
 /* timings are in milliseconds. */
 #define XT_HASHLIMIT_SCALE 10000
 /* 1/10,000 sec period => max of 10,000/sec.  Min rate is then 429490
-   seconds, or one every 59 hours. */
+   seconds, or one packet every 59 hours. */
+
+/* packet length accounting is done in 16-byte steps */
+#define XT_HASHLIMIT_BYTE_SHIFT 4
 
 /* details of this structure hidden by the implementation */
 struct xt_hashlimit_htable;
@@ -17,6 +20,7 @@ enum {
 	XT_HASHLIMIT_HASH_SIP = 1 << 2,
 	XT_HASHLIMIT_HASH_SPT = 1 << 3,
 	XT_HASHLIMIT_INVERT   = 1 << 4,
+	XT_HASHLIMIT_BYTES    = 1 << 5,
 };
 
 struct hashlimit_cfg {
diff --git a/tests/options-most.rules b/tests/options-most.rules
index 7573361..908acbf 100644
--- a/tests/options-most.rules
+++ b/tests/options-most.rules
@@ -97,6 +97,9 @@
 -A matches -m hashlimit --hashlimit-upto 1/min --hashlimit-burst 1 --hashlimit-name mini2
 -A matches -m hashlimit --hashlimit-upto 1/hour --hashlimit-burst 1 --hashlimit-name mini3
 -A matches -m hashlimit --hashlimit-upto 1/day --hashlimit-burst 1 --hashlimit-name mini4
+-A matches -m hashlimit --hashlimit-upto 4kb/s --hashlimit-burst 400kb --hashlimit-name mini5
+-A matches -m hashlimit --hashlimit-upto 10mb/s --hashlimit-name mini6
+-A matches -m hashlimit --hashlimit-upto 123456b/s --hashlimit-burst 1mb --hashlimit-name mini7
 -A matches
 -A matches -m hbh ! --hbh-len 5
 -A matches
-- 
1.7.3.4

