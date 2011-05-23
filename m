From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/13] libxt_rateest: avoid optional arguments
Date: Mon, 23 May 2011 16:39:20 +0200
Message-ID: <1306161564-4370-11-git-send-email-jengelh@medozas.de>
References: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44641 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755552Ab1EWOjh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 May 2011 10:39:37 -0400
In-Reply-To: <1306161564-4370-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Optional arguments make parsing unnecessarily harder - even more so
than two-args. Right now, rateest even crashes because of it.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_rateest.c   |   75 +++++++++++++++++++-----------------------
 extensions/libxt_rateest.man |   20 +++++++----
 2 files changed, 46 insertions(+), 49 deletions(-)

diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 509b3e3..62d6033 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -15,16 +15,17 @@ static void rateest_help(void)
 {
 	printf(
 "rateest match options:\n"
-" --rateest1 name		Rate estimator name\n"
-" --rateest2 name		Rate estimator name\n"
 " --rateest-delta		Compare difference(s) to given rate(s)\n"
-" --rateest-bps1 [bps]		Compare bps\n"
-" --rateest-pps1 [pps]		Compare pps\n"
-" --rateest-bps2 [bps]		Compare bps\n"
-" --rateest-pps2 [pps]		Compare pps\n"
 " [!] --rateest-lt		Match if rate is less than given rate/estimator\n"
 " [!] --rateest-gt		Match if rate is greater than given rate/estimator\n"
-" [!] --rateest-eq		Match if rate is equal to given rate/estimator\n");
+" [!] --rateest-eq		Match if rate is equal to given rate/estimator\n"
+" --bytes, --packets            Pick byte/sec or packets/sec comparison\n"
+" --rateest1 name		Rate estimator name\n"
+" --rateest2 name		Rate estimator name\n"
+" --rateest-bps1 bps		Compare bps\n"
+" --rateest-pps1 pps		Compare pps\n"
+" --rateest-bps2 bps		Compare bps\n"
+" --rateest-pps2 pps		Compare pps\n");
 }
 
 enum rateest_options {
@@ -38,22 +39,26 @@ enum rateest_options {
 	OPT_RATEEST_LT,
 	OPT_RATEEST_GT,
 	OPT_RATEEST_EQ,
+	OPT_RATEEST_BYTES,
+	OPT_RATEEST_PACKETS,
 };
 
 static const struct option rateest_opts[] = {
 	{.name = "rateest1",      .has_arg = true,  .val = OPT_RATEEST1},
 	{.name = "rateest",       .has_arg = true,  .val = OPT_RATEEST1}, /* alias for absolute mode */
 	{.name = "rateest2",      .has_arg = true,  .val = OPT_RATEEST2},
-	{.name = "rateest-bps1",  .has_arg = false, .val = OPT_RATEEST_BPS1},
-	{.name = "rateest-pps1",  .has_arg = false, .val = OPT_RATEEST_PPS1},
-	{.name = "rateest-bps2",  .has_arg = false, .val = OPT_RATEEST_BPS2},
-	{.name = "rateest-pps2",  .has_arg = false, .val = OPT_RATEEST_PPS2},
-	{.name = "rateest-bps",   .has_arg = false, .val = OPT_RATEEST_BPS2}, /* alias for absolute mode */
-	{.name = "rateest-pps",   .has_arg = false, .val = OPT_RATEEST_PPS2}, /* alias for absolute mode */
+	{.name = "rateest-bps1",  .has_arg = true, .val = OPT_RATEEST_BPS1},
+	{.name = "rateest-pps1",  .has_arg = true, .val = OPT_RATEEST_PPS1},
+	{.name = "rateest-bps2",  .has_arg = true, .val = OPT_RATEEST_BPS2},
+	{.name = "rateest-pps2",  .has_arg = true, .val = OPT_RATEEST_PPS2},
+	{.name = "rateest-bps",   .has_arg = true, .val = OPT_RATEEST_BPS2}, /* alias for absolute mode */
+	{.name = "rateest-pps",   .has_arg = true, .val = OPT_RATEEST_PPS2}, /* alias for absolute mode */
 	{.name = "rateest-delta", .has_arg = false, .val = OPT_RATEEST_DELTA},
 	{.name = "rateest-lt",    .has_arg = false, .val = OPT_RATEEST_LT},
 	{.name = "rateest-gt",    .has_arg = false, .val = OPT_RATEEST_GT},
 	{.name = "rateest-eq",    .has_arg = false, .val = OPT_RATEEST_EQ},
+	{.name = "bytes",   .has_arg = false, .val = OPT_RATEEST_BYTES},
+	{.name = "packets", .has_arg = false, .val = OPT_RATEEST_PACKETS},
 	XT_GETOPT_TABLEEND,
 };
 
@@ -160,15 +165,10 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		info->flags |= XT_RATEEST_MATCH_BPS;
 
-		/* The rate is optional and only required in absolute mode */
-		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
-			break;
-
-		if (rateest_get_rate(&info->bps1, argv[optind]) < 0)
+		if (rateest_get_rate(&info->bps1, optarg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
-				   argv[optind]);
-		optind++;
+				   optarg);
 		break;
 
 	case OPT_RATEEST_PPS1:
@@ -184,16 +184,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		info->flags |= XT_RATEEST_MATCH_PPS;
 
-		/* The rate is optional and only required in absolute mode */
-		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
-			break;
-
-		if (!xtables_strtoui(argv[optind], NULL, &val, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse pps `%s'",
-				   argv[optind]);
+				   optarg);
 		info->pps1 = val;
-		optind++;
 		break;
 
 	case OPT_RATEEST_BPS2:
@@ -209,15 +204,10 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		info->flags |= XT_RATEEST_MATCH_BPS;
 
-		/* The rate is optional and only required in absolute mode */
-		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
-			break;
-
-		if (rateest_get_rate(&info->bps2, argv[optind]) < 0)
+		if (rateest_get_rate(&info->bps2, optarg) < 0)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
-				   argv[optind]);
-		optind++;
+				   optarg);
 		break;
 
 	case OPT_RATEEST_PPS2:
@@ -233,16 +223,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		info->flags |= XT_RATEEST_MATCH_PPS;
 
-		/* The rate is optional and only required in absolute mode */
-		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
-			break;
-
-		if (!xtables_strtoui(argv[optind], NULL, &val, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse pps `%s'",
-				   argv[optind]);
+				   optarg);
 		info->pps2 = val;
-		optind++;
 		break;
 
 	case OPT_RATEEST_DELTA:
@@ -297,6 +282,14 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (invert)
 			info->flags |= XT_RATEEST_MATCH_INVERT;
 		break;
+
+	case OPT_RATEEST_BYTES:
+		info->flags |= XT_RATEEST_MATCH_BPS;
+		break;
+
+	case OPT_RATEEST_PACKETS:
+		info->flags |= XT_RATEEST_MATCH_PPS;
+		break;
 	}
 
 	return 1;
diff --git a/extensions/libxt_rateest.man b/extensions/libxt_rateest.man
index 42a82f3..fb81e5c 100644
--- a/extensions/libxt_rateest.man
+++ b/extensions/libxt_rateest.man
@@ -16,9 +16,9 @@ combinations:
 (\fBrateest\fP minus \fBrateest-pps1\fP) \fIoperator\fP \fBrateest-pps2\fP
 .\" * Relative:
 .IP \(bu 4
-\fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-bps\fP(without rate!)
+\fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBbytes\fP
 .IP \(bu 4
-\fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBrateest-pps\fP(without rate!)
+\fBrateest1\fP \fIoperator\fP \fBrateest2\fP \fBpackets\fP
 .\" * Relative + Delta:
 .IP \(bu 4
 (\fBrateest1\fP minus \fBrateest-bps1\fP) \fIoperator\fP
@@ -55,21 +55,25 @@ Name of the one rate estimator for absolute mode.
 \fB\-\-rateest2\fP \fIname\fP
 The names of the two rate estimators for relative mode.
 .TP
-\fB\-\-rateest\-bps\fP [\fIvalue\fP]
+\fB\-\-rateest\-bps\fP \fIvalue\fP
 .TP
-\fB\-\-rateest\-pps\fP [\fIvalue\fP]
+\fB\-\-rateest\-pps\fP \fIvalue\fP
 .TP
-\fB\-\-rateest\-bps1\fP [\fIvalue\fP]
+\fB\-\-rateest\-bps1\fP \fIvalue\fP
 .TP
-\fB\-\-rateest\-bps2\fP [\fIvalue\fP]
+\fB\-\-rateest\-bps2\fP \fIvalue\fP
 .TP
-\fB\-\-rateest\-pps1\fP [\fIvalue\fP]
+\fB\-\-rateest\-pps1\fP \fIvalue\fP
 .TP
-\fB\-\-rateest\-pps2\fP [\fIvalue\fP]
+\fB\-\-rateest\-pps2\fP \fIvalue\fP
 Compare the estimator(s) by bytes or packets per second, and compare against
 the chosen value. See the above bullet list for which option is to be used in
 which case. A unit suffix may be used - available ones are: bit, [kmgt]bit,
 [KMGT]ibit, Bps, [KMGT]Bps, [KMGT]iBps.
+.TP
+\fB\-\-bytes\fP, \fB\-\-packets\fP
+Compare the estimators by bytes or packets. One of this option is required when
+comparing two estimators without using one of \-\-rateest\-[bp]s[12].
 .PP
 Example: This is what can be used to route outgoing data connections from an
 FTP server over two lines based on the available bandwidth at the time the data
-- 
1.7.3.4

