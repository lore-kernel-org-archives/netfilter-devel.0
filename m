From: Zhang Chunyu <zhangcy@cn.fujitsu.com>
Subject: [PATCH V2 4/4] Add --and-mark and --or-mark
Date: Tue, 24 Mar 2015 21:57:36 -0400
Message-ID: <1427248656-8851-5-git-send-email-zhangcy@cn.fujitsu.com>
References: <1427248656-8851-1-git-send-email-zhangcy@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Zhang Chunyu <zhangcy@cn.fujitsu.com>,
	Gao feng <gaofeng@cn.fujitsu.com>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2952 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752508AbbCYCLn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Mar 2015 22:11:43 -0400
In-Reply-To: <1427248656-8851-1-git-send-email-zhangcy@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
Signed-off-by: Zhang Chunyu <zhangcy@cn.fujitsu.com>
---
 arptables.8            | 11 +++++++++--
 extensions/arpt_MARK.c | 47 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 51 insertions(+), 7 deletions(-)

diff --git a/arptables.8 b/arptables.8
index a0ada83..676b884 100644
--- a/arptables.8
+++ b/arptables.8
@@ -321,9 +321,16 @@ the packet by the mark in u32)
 
 .TP
 .BR "--set-mark mark"
+Set the mark value. The  values  are  always
+interpreted as hexadecimal even if no 0x prefix is given
 
-Set the mark value.  The  values  are  always
-interpreted as hexadecimal even if no 0x prefix is given.
+.TP
+.BR "--and-mark mark"
+Binary AND the mark with bits.
+
+.TP
+.BR "--or-mark mark"
+Binary OR the mark with bits.
 
 .SH MAILINGLISTS
 .BR "" "See " http://netfilter.org/mailinglists.html
diff --git a/extensions/arpt_MARK.c b/extensions/arpt_MARK.c
index d9aec8b..b03a8fc 100644
--- a/extensions/arpt_MARK.c
+++ b/extensions/arpt_MARK.c
@@ -30,14 +30,21 @@ help(void)
 {
 	printf(
 "MARK target v%s options:\n"
-"--set-mark mark : set the mark value\n",
+"--set-mark mark : set the mark value\n"
+"--and-mark value : binary AND the mark with value\n"
+"--or-mark value : binary OR the mark with value\n",
 	ARPTABLES_VERSION);
 }
 
 #define MARK_OPT 1
+#define AND_MARK_OPT 2
+#define OR_MARK_OPT 3
+
 
 static struct option opts[] = {
 	{ "set-mark"   , required_argument, 0, MARK_OPT },
+	{ "and-mark"   , required_argument, 0, AND_MARK_OPT },
+	{ "or-mark"    , required_argument, 0, OR_MARK_OPT },
 	{0}
 };
 
@@ -67,9 +74,34 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 			info->mark = i;
 			if (*flags)
 				exit_error(PARAMETER_PROBLEM,
-						"CLASSIFY: Can't specify --set-mark twice");
+						"MARK: Can't specify --set-mark twice");
+			*flags = 1;
+			break;
+		case AND_MARK_OPT:
+		    if (sscanf(argv[optind-1], "%x", &i) != 1) {
+				exit_error(PARAMETER_PROBLEM,
+						"Bad mark value `%s'", optarg);
+				return 0;
+			}
+			info->mark = 0;
+			info->mask = ~i;
+			if (*flags)
+				exit_error(PARAMETER_PROBLEM,
+						"MARK: Can't specify --and-mark twice");
 			*flags = 1;
 			break;
+		case OR_MARK_OPT:
+		    if (sscanf(argv[optind-1], "%x", &i) != 1) {
+				exit_error(PARAMETER_PROBLEM,
+						"Bad mark value `%s'", optarg);
+				return 0;
+			}
+			info->mark = info->mask = i;
+			if (*flags)
+				exit_error(PARAMETER_PROBLEM,
+						"MARK: Can't specify --or-mark twice");
+			*flags = 1;
+			break;    
 		default:
 			return 0;
 	}
@@ -79,15 +111,20 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 static void final_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "MARK: Parameter --set-mark is required");
+		exit_error(PARAMETER_PROBLEM, "MARK: Parameter --set-mark/--and-mark/--or-mark is required");
 }
 
 static void print(const struct arpt_arp *ip,
 	const struct arpt_entry_target *target, int numeric)
 {
 	struct xt_mark_tginfo2 *info = (struct xt_mark_tginfo2 *)(target->data);
-
-	printf("--set-mark %x ", info->mark);
+	
+	if (info->mark == 0)
+		printf("--and-mark %x", (unsigned int)(uint32_t)~info->mask);
+	else if (info->mark == info->mask)
+		printf("--or-mark %x", info->mark);
+	else
+		printf("--set-mark %x", info->mark);
 }
 
 static void
-- 
1.7.12.4

