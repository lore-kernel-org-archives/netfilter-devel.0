From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/16] extensions: use UINT_MAX constants over open-coded bits (1/2)
Date: Mon,  9 Feb 2009 18:34:48 +0100
Message-ID: <1234200900-5964-5-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51464 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780AbZBIRfD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:03 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

~0 depends on the sizeof(int), so it is better to use UINT32_MAX.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CONNMARK.c  |   26 +++++++++++++-------------
 extensions/libxt_MARK.c      |   12 ++++++------
 extensions/libxt_TPROXY.c    |    2 +-
 extensions/libxt_connmark.c  |    6 +++---
 extensions/libxt_conntrack.c |   10 +++++-----
 extensions/libxt_mark.c      |    6 +++---
 extensions/libxt_quota.c     |    2 +-
 extensions/libxt_string.c    |    2 +-
 8 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 2ad2759..d5d963d 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -90,8 +90,8 @@ static void connmark_tg_init(struct xt_entry_target *target)
 	 * Need these defaults for --save-mark/--restore-mark if no
 	 * --ctmark or --nfmask is given.
 	 */
-	info->ctmask = ~0U;
-	info->nfmask = ~0U;
+	info->ctmask = UINT32_MAX;
+	info->nfmask = UINT32_MAX;
 }
 
 static int
@@ -152,17 +152,17 @@ static int connmark_tg_parse(int c, char **argv, int invert,
                              struct xt_entry_target **target)
 {
 	struct xt_connmark_tginfo1 *info = (void *)(*target)->data;
-	unsigned int value, mask = ~0U;
+	unsigned int value, mask = UINT32_MAX;
 	char *end;
 
 	switch (c) {
 	case '=': /* --set-xmark */
 	case '-': /* --set-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, &end, &value, 0, ~0U))
+		if (!strtonum(optarg, &end, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
+			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
@@ -176,7 +176,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case '&': /* --and-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, NULL, &mask, 0, ~0U))
+		if (!strtonum(optarg, NULL, &mask, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--and-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = 0;
@@ -186,7 +186,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case '|': /* --or-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--or-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = value;
@@ -196,7 +196,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case '^': /* --xor-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--xor-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = value;
@@ -221,7 +221,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--nfmask");
-		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--nfmask", optarg);
 		info->nfmask = value;
 		return true;
@@ -231,7 +231,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--ctmask");
-		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--ctmask", optarg);
 		info->ctmask = value;
 		return true;
@@ -241,7 +241,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--mask");
-		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--mask", optarg);
 		info->nfmask = info->ctmask = value;
 		return true;
@@ -317,7 +317,7 @@ connmark_tg_print(const void *ip, const struct xt_entry_target *target,
 			       info->ctmark, info->ctmask);
 		break;
 	case XT_CONNMARK_SAVE:
-		if (info->nfmask == ~0U && info->ctmask == ~0U)
+		if (info->nfmask == UINT32_MAX && info->ctmask == UINT32_MAX)
 			printf("CONNMARK save ");
 		else if (info->nfmask == info->ctmask)
 			printf("CONNMARK save mask 0x%x ", info->nfmask);
@@ -326,7 +326,7 @@ connmark_tg_print(const void *ip, const struct xt_entry_target *target,
 			       info->nfmask, info->ctmask);
 		break;
 	case XT_CONNMARK_RESTORE:
-		if (info->ctmask == ~0U && info->nfmask == ~0U)
+		if (info->ctmask == UINT32_MAX && info->nfmask == UINT32_MAX)
 			printf("CONNMARK restore ");
 		else if (info->ctmask == info->nfmask)
 			printf("CONNMARK restore mask 0x%x ", info->ctmask);
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 95bce89..b02322b 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -126,7 +126,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
                          const void *entry, struct xt_entry_target **target)
 {
 	struct xt_mark_tginfo2 *info = (void *)(*target)->data;
-	unsigned int value, mask = ~0U;
+	unsigned int value, mask = UINT32_MAX;
 	char *end;
 
 	switch (c) {
@@ -134,10 +134,10 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '=': /* --set-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--set-xmark/--set-mark", invert);
-		if (!strtonum(optarg, &end, &value, 0, ~0U))
+		if (!strtonum(optarg, &end, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
+			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
@@ -151,7 +151,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '&': /* --and-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--and-mark", invert);
-		if (!strtonum(optarg, NULL, &mask, 0, ~0U))
+		if (!strtonum(optarg, NULL, &mask, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--and-mark", optarg);
 		info->mark = 0;
 		info->mask = ~mask;
@@ -160,7 +160,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '|': /* --or-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--or-mark", invert);
-		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--or-mark", optarg);
 		info->mark = value;
 		info->mask = value;
@@ -169,7 +169,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '^': /* --xor-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--xor-mark", invert);
-		if (!strtonum(optarg, NULL, &value, 0, ~0U))
+		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--xor-mark", optarg);
 		info->mark = value;
 		info->mask = 0;
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index deb214f..e9a41a1 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -58,7 +58,7 @@ static void parse_tproxy_laddr(const char *s, struct xt_tproxy_target_info *info
 
 static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
 {
-	unsigned int value, mask = ~0U;
+	unsigned int value, mask = UINT32_MAX;
 	char *end;
 
 	if (!strtonum(s, &end, &value, 0, UINT_MAX))
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index bc7ef45..fbd3e62 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -49,16 +49,16 @@ connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
                   const void *entry, struct xt_entry_match **match)
 {
 	struct xt_connmark_mtinfo1 *info = (void *)(*match)->data;
-	unsigned int mark, mask = ~0U;
+	unsigned int mark, mask = UINT32_MAX;
 	char *end;
 
 	switch (c) {
 	case '1': /* --mark */
 		param_act(P_ONLY_ONCE, "connmark", "--mark", *flags & F_MARK);
-		if (!strtonum(optarg, &end, &mark, 0, ~0U))
+		if (!strtonum(optarg, &end, &mark, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
+			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index d5dee7e..532f5ee 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -272,7 +272,7 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
 		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
 	max = min;
 	if (*end == ':')
-		if (!strtonum(s, &end, &max, 0, ~0U))
+		if (!strtonum(s, &end, &max, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "conntrack", "--expires", s);
 	if (*end != '\0')
 		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
@@ -481,7 +481,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'a': /* --ctorigsrcport */
-		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctorigsrcport", optarg);
 		info->match_flags |= XT_CONNTRACK_ORIGSRC_PORT;
@@ -491,7 +491,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'b': /* --ctorigdstport */
-		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctorigdstport", optarg);
 		info->match_flags |= XT_CONNTRACK_ORIGDST_PORT;
@@ -501,7 +501,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'c': /* --ctreplsrcport */
-		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctreplsrcport", optarg);
 		info->match_flags |= XT_CONNTRACK_REPLSRC_PORT;
@@ -511,7 +511,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'd': /* --ctrepldstport */
-		if (!strtonum(optarg, NULL, &port, 0, ~(u_int16_t)0))
+		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctrepldstport", optarg);
 		info->match_flags |= XT_CONNTRACK_REPLDST_PORT;
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 811cc77..5a95d51 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -29,16 +29,16 @@ static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
                          const void *entry, struct xt_entry_match **match)
 {
 	struct xt_mark_mtinfo1 *info = (void *)(*match)->data;
-	unsigned int mark, mask = ~0U;
+	unsigned int mark, mask = UINT32_MAX;
 	char *end;
 
 	switch (c) {
 	case '1': /* --mark */
 		param_act(P_ONLY_ONCE, "mark", "--mark", *flags & F_MARK);
-		if (!strtonum(optarg, &end, &mark, 0, ~0U))
+		if (!strtonum(optarg, &end, &mark, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, ~0U))
+			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "mark", "--mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 5007f7c..90da1cd 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -46,7 +46,7 @@ parse_quota(const char *s, u_int64_t * quota)
 	printf("Quota: %llu\n", *quota);
 #endif
 
-	if (*quota == (u_int64_t)-1)
+	if (*quota == UINT64_MAX)
 		exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
 	else
 		return 1;
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index b440fc9..0408c23 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -57,7 +57,7 @@ static void string_init(struct xt_entry_match *m)
 	struct xt_string_info *i = (struct xt_string_info *) m->data;
 
 	if (i->to_offset == 0)
-		i->to_offset = (u_int16_t) ~0UL;
+		i->to_offset = UINT16_MAX;
 }
 
 static void
-- 
1.6.1.2

