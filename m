From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/16] libxtables: prefix/order - param_act
Date: Mon,  9 Feb 2009 18:34:53 +0100
Message-ID: <1234200900-5964-10-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51469 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755526AbZBIRfG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:06 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Changes:
	exittype -> xtables_exittype
	P_* -> XTF_* flags

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_CONNMARK.c  |   30 +++++++++++-----------
 extensions/libxt_MARK.c      |   28 ++++++++++----------
 extensions/libxt_TOS.c       |   30 +++++++++++-----------
 extensions/libxt_TPROXY.c    |   22 ++++++++--------
 extensions/libxt_connmark.c  |    8 +++---
 extensions/libxt_conntrack.c |   18 ++++++------
 extensions/libxt_hashlimit.c |   58 +++++++++++++++++++++---------------------
 extensions/libxt_iprange.c   |   24 ++++++++--------
 extensions/libxt_mark.c      |    8 +++---
 extensions/libxt_owner.c     |   46 ++++++++++++++++----------------
 extensions/libxt_tos.c       |    8 +++---
 include/xtables.h.in         |   28 ++++++++++----------
 ip6tables.c                  |    2 +-
 iptables-xml.c               |    2 +-
 iptables.c                   |    2 +-
 xtables.c                    |   34 +++++++++++++++++++++---
 16 files changed, 186 insertions(+), 162 deletions(-)

diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index f979f28..e426e4f 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -158,14 +158,14 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 	switch (c) {
 	case '=': /* --set-xmark */
 	case '-': /* --set-mark */
-		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
 		if (!xtables_strtoui(optarg, &end, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
 		if (*end == '/')
 			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
+				xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
 		if (*end != '\0')
-			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = value;
 		info->ctmask = mask;
@@ -175,9 +175,9 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 		return true;
 
 	case '&': /* --and-mark */
-		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
 		if (!xtables_strtoui(optarg, NULL, &mask, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "CONNMARK", "--and-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--and-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = 0;
 		info->ctmask = ~mask;
@@ -185,9 +185,9 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 		return true;
 
 	case '|': /* --or-mark */
-		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "CONNMARK", "--or-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--or-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = value;
 		info->ctmask = value;
@@ -195,9 +195,9 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 		return true;
 
 	case '^': /* --xor-mark */
-		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "CONNMARK", "--xor-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--xor-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = value;
 		info->ctmask = 0;
@@ -205,13 +205,13 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 		return true;
 
 	case 'S': /* --save-mark */
-		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
 		info->mode = XT_CONNMARK_SAVE;
 		*flags |= F_MARK | F_SR_MARK;
 		return true;
 
 	case 'R': /* --restore-mark */
-		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
+		xtables_param_act(XTF_ONE_ACTION, "CONNMARK", *flags & F_MARK);
 		info->mode = XT_CONNMARK_RESTORE;
 		*flags |= F_MARK | F_SR_MARK;
 		return true;
@@ -222,7 +222,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			           "or --restore-mark is required for "
 			           "--nfmask");
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "CONNMARK", "--nfmask", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--nfmask", optarg);
 		info->nfmask = value;
 		return true;
 
@@ -232,7 +232,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			           "or --restore-mark is required for "
 			           "--ctmask");
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "CONNMARK", "--ctmask", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--ctmask", optarg);
 		info->ctmask = value;
 		return true;
 
@@ -242,7 +242,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			           "or --restore-mark is required for "
 			           "--mask");
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "CONNMARK", "--mask", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "CONNMARK", "--mask", optarg);
 		info->nfmask = info->ctmask = value;
 		return true;
 	}
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index fd28196..8f04e8e 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -134,15 +134,15 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'X': /* --set-xmark */
 	case '=': /* --set-mark */
-		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
-		param_act(P_NO_INVERT, "MARK", "--set-xmark/--set-mark", invert);
+		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
+		xtables_param_act(XTF_NO_INVERT, "MARK", "--set-xmark/--set-mark", invert);
 		if (!xtables_strtoui(optarg, &end, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
 		if (*end == '/')
 			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
+				xtables_param_act(XTF_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
 		if (*end != '\0')
-			param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
 		info->mark = value;
 		info->mask = mask;
 
@@ -151,28 +151,28 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '&': /* --and-mark */
-		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
-		param_act(P_NO_INVERT, "MARK", "--and-mark", invert);
+		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
+		xtables_param_act(XTF_NO_INVERT, "MARK", "--and-mark", invert);
 		if (!xtables_strtoui(optarg, NULL, &mask, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "MARK", "--and-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "MARK", "--and-mark", optarg);
 		info->mark = 0;
 		info->mask = ~mask;
 		break;
 
 	case '|': /* --or-mark */
-		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
-		param_act(P_NO_INVERT, "MARK", "--or-mark", invert);
+		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
+		xtables_param_act(XTF_NO_INVERT, "MARK", "--or-mark", invert);
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "MARK", "--or-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "MARK", "--or-mark", optarg);
 		info->mark = value;
 		info->mask = value;
 		break;
 
 	case '^': /* --xor-mark */
-		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
-		param_act(P_NO_INVERT, "MARK", "--xor-mark", invert);
+		xtables_param_act(XTF_ONE_ACTION, "MARK", *flags & F_MARK);
+		xtables_param_act(XTF_NO_INVERT, "MARK", "--xor-mark", invert);
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "MARK", "--xor-mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "MARK", "--xor-mark", optarg);
 		info->mark = value;
 		info->mask = 0;
 		break;
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 96eb420..7b1f7f8 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -82,10 +82,10 @@ static int tos_tg_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '=':
-		param_act(P_ONLY_ONCE, "TOS", "--set-tos", *flags & FLAG_TOS);
-		param_act(P_NO_INVERT, "TOS", "--set-tos", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--set-tos", *flags & FLAG_TOS);
+		xtables_param_act(XTF_NO_INVERT, "TOS", "--set-tos", invert);
 		if (!tos_parse_symbolic(optarg, &tvm, 0xFF))
-			param_act(P_BAD_VALUE, "TOS", "--set-tos", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "TOS", "--set-tos", optarg);
 		if (tvm.mask != 0xFF)
 			exit_error(PARAMETER_PROBLEM, "tos match: Your kernel "
 			           "is too old to support anything besides "
@@ -107,37 +107,37 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '=': /* --set-tos */
-		param_act(P_ONLY_ONCE, "TOS", "--set-tos", *flags & FLAG_TOS);
-		param_act(P_NO_INVERT, "TOS", "--set-tos", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--set-tos", *flags & FLAG_TOS);
+		xtables_param_act(XTF_NO_INVERT, "TOS", "--set-tos", invert);
 		if (!tos_parse_symbolic(optarg, &tvm, 0x3F))
-			param_act(P_BAD_VALUE, "TOS", "--set-tos", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "TOS", "--set-tos", optarg);
 		info->tos_value = tvm.value;
 		info->tos_mask  = tvm.mask;
 		break;
 
 	case '&': /* --and-tos */
-		param_act(P_ONLY_ONCE, "TOS", "--and-tos", *flags & FLAG_TOS);
-		param_act(P_NO_INVERT, "TOS", "--and-tos", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--and-tos", *flags & FLAG_TOS);
+		xtables_param_act(XTF_NO_INVERT, "TOS", "--and-tos", invert);
 		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
-			param_act(P_BAD_VALUE, "TOS", "--and-tos", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "TOS", "--and-tos", optarg);
 		info->tos_value = 0;
 		info->tos_mask  = ~bits;
 		break;
 
 	case '|': /* --or-tos */
-		param_act(P_ONLY_ONCE, "TOS", "--or-tos", *flags & FLAG_TOS);
-		param_act(P_NO_INVERT, "TOS", "--or-tos", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--or-tos", *flags & FLAG_TOS);
+		xtables_param_act(XTF_NO_INVERT, "TOS", "--or-tos", invert);
 		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
-			param_act(P_BAD_VALUE, "TOS", "--or-tos", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "TOS", "--or-tos", optarg);
 		info->tos_value = bits;
 		info->tos_mask  = bits;
 		break;
 
 	case '^': /* --xor-tos */
-		param_act(P_ONLY_ONCE, "TOS", "--xor-tos", *flags & FLAG_TOS);
-		param_act(P_NO_INVERT, "TOS", "--xor-tos", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TOS", "--xor-tos", *flags & FLAG_TOS);
+		xtables_param_act(XTF_NO_INVERT, "TOS", "--xor-tos", invert);
 		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
-			param_act(P_BAD_VALUE, "TOS", "--xor-tos", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "TOS", "--xor-tos", optarg);
 		info->tos_value = bits;
 		info->tos_mask  = 0;
 		break;
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 6c5c6b7..d0933ae 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -43,7 +43,7 @@ static void parse_tproxy_lport(const char *s, struct xt_tproxy_target_info *info
 	if (xtables_strtoui(s, NULL, &lport, 0, UINT16_MAX))
 		info->lport = htons(lport);
 	else
-		param_act(P_BAD_VALUE, "TPROXY", "--on-port", s);
+		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-port", s);
 }
 
 static void parse_tproxy_laddr(const char *s, struct xt_tproxy_target_info *info)
@@ -51,7 +51,7 @@ static void parse_tproxy_laddr(const char *s, struct xt_tproxy_target_info *info
 	struct in_addr *laddr;
 
 	if ((laddr = numeric_to_ipaddr(s)) == NULL)
-		param_act(P_BAD_VALUE, "TPROXY", "--on-ip", s);
+		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-ip", s);
 
 	info->laddr = laddr->s_addr;
 }
@@ -62,12 +62,12 @@ static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
 	char *end;
 
 	if (!xtables_strtoui(s, &end, &value, 0, UINT32_MAX))
-		param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
+		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
 	if (*end == '/')
 		if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
+			xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
 	if (*end != '\0')
-		param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
+		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
 
 	info->mark_mask = mask;
 	info->mark_value = value;
@@ -80,20 +80,20 @@ static int tproxy_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		param_act(P_ONLY_ONCE, "TPROXY", "--on-port", *flags & PARAM_ONPORT);
-		param_act(P_NO_INVERT, "TPROXY", "--on-port", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-port", *flags & PARAM_ONPORT);
+		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-port", invert);
 		parse_tproxy_lport(optarg, tproxyinfo);
 		*flags |= PARAM_ONPORT;
 		return 1;
 	case '2':
-		param_act(P_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
-		param_act(P_NO_INVERT, "TPROXY", "--on-ip", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
+		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-ip", invert);
 		parse_tproxy_laddr(optarg, tproxyinfo);
 		*flags |= PARAM_ONIP;
 		return 1;
 	case '3':
-		param_act(P_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
-		param_act(P_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
+		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
+		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
 		parse_tproxy_mark(optarg, tproxyinfo);
 		*flags |= PARAM_MARK;
 		return 1;
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index afa63e3..0f47a8f 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -54,14 +54,14 @@ connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1': /* --mark */
-		param_act(P_ONLY_ONCE, "connmark", "--mark", *flags & F_MARK);
+		xtables_param_act(XTF_ONLY_ONCE, "connmark", "--mark", *flags & F_MARK);
 		if (!xtables_strtoui(optarg, &end, &mark, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "connmark", "--mark", optarg);
 		if (*end == '/')
 			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+				xtables_param_act(XTF_BAD_VALUE, "connmark", "--mark", optarg);
 		if (*end != '\0')
-			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "connmark", "--mark", optarg);
 
 		if (invert)
 			info->invert = true;
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 2b98ab0..facd0fc 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -269,13 +269,13 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
 	char *end;
 
 	if (!xtables_strtoui(s, &end, &min, 0, UINT32_MAX))
-		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
+		xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
 	max = min;
 	if (*end == ':')
 		if (!xtables_strtoui(s, &end, &max, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "conntrack", "--expires", s);
+			xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
 	if (*end != '\0')
-		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
+		xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
 
 	if (min > max)
 		exit_error(PARAMETER_PROBLEM,
@@ -482,7 +482,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'a': /* --ctorigsrcport */
 		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			param_act(P_BAD_VALUE, "conntrack",
+			xtables_param_act(XTF_BAD_VALUE, "conntrack",
 			          "--ctorigsrcport", optarg);
 		info->match_flags |= XT_CONNTRACK_ORIGSRC_PORT;
 		info->origsrc_port = htons(port);
@@ -492,7 +492,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'b': /* --ctorigdstport */
 		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			param_act(P_BAD_VALUE, "conntrack",
+			xtables_param_act(XTF_BAD_VALUE, "conntrack",
 			          "--ctorigdstport", optarg);
 		info->match_flags |= XT_CONNTRACK_ORIGDST_PORT;
 		info->origdst_port = htons(port);
@@ -502,7 +502,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'c': /* --ctreplsrcport */
 		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			param_act(P_BAD_VALUE, "conntrack",
+			xtables_param_act(XTF_BAD_VALUE, "conntrack",
 			          "--ctreplsrcport", optarg);
 		info->match_flags |= XT_CONNTRACK_REPLSRC_PORT;
 		info->replsrc_port = htons(port);
@@ -512,7 +512,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'd': /* --ctrepldstport */
 		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
-			param_act(P_BAD_VALUE, "conntrack",
+			xtables_param_act(XTF_BAD_VALUE, "conntrack",
 			          "--ctrepldstport", optarg);
 		info->match_flags |= XT_CONNTRACK_REPLDST_PORT;
 		info->repldst_port = htons(port);
@@ -521,7 +521,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'e': /* --ctdir */
-		param_act(P_NO_INVERT, "conntrack", "--ctdir", invert);
+		xtables_param_act(XTF_NO_INVERT, "conntrack", "--ctdir", invert);
 		if (strcasecmp(optarg, "ORIGINAL") == 0) {
 			info->match_flags  |= XT_CONNTRACK_DIRECTION;
 			info->invert_flags &= ~XT_CONNTRACK_DIRECTION;
@@ -529,7 +529,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->match_flags  |= XT_CONNTRACK_DIRECTION;
 			info->invert_flags |= XT_CONNTRACK_DIRECTION;
 		} else {
-			param_act(P_BAD_VALUE, "conntrack", "--ctdir", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "conntrack", "--ctdir", optarg);
 		}
 		break;
 
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 06d026a..f63db64 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -217,7 +217,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch(c) {
 	case '%':
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit",
 		          *flags & PARAM_LIMIT);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->cfg.avg))
@@ -227,7 +227,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case '$':
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
 		          *flags & PARAM_BURST);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
@@ -237,7 +237,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= PARAM_BURST;
 		break;
 	case '&':
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
@@ -247,7 +247,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= PARAM_SIZE;
 		break;
 	case '*':
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
@@ -257,7 +257,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= PARAM_MAX;
 		break;
 	case '(':
-		param_act(P_ONLY_ONCE, "hashlimit",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
@@ -270,7 +270,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= PARAM_GCINTERVAL;
 		break;
 	case ')':
-		param_act(P_ONLY_ONCE, "hashlimit",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
@@ -281,7 +281,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= PARAM_EXPIRE;
 		break;
 	case '_':
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (parse_mode(&r->cfg.mode, optarg) < 0)
@@ -290,7 +290,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= PARAM_MODE;
 		break;
 	case '"':
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-name",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
 		          *flags & PARAM_NAME);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (strlen(optarg) == 0)
@@ -317,63 +317,63 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 
 	switch(c) {
 	case '%': /* --hashlimit / --hashlimit-below */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-upto",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-upto",
 		          *flags & PARAM_LIMIT);
 		if (invert)
 			info->cfg.mode |= XT_HASHLIMIT_INVERT;
 		if (!parse_rate(optarg, &info->cfg.avg))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-upto", optarg);
 		*flags |= PARAM_LIMIT;
 		return true;
 
 	case '^': /* --hashlimit-above == !--hashlimit-below */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-above",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-above",
 		          *flags & PARAM_LIMIT);
 		if (!invert)
 			info->cfg.mode |= XT_HASHLIMIT_INVERT;
 		if (!parse_rate(optarg, &info->cfg.avg))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-above", optarg);
 		*flags |= PARAM_LIMIT;
 		return true;
 
 	case '$': /* --hashlimit-burst */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
 		          *flags & PARAM_BURST);
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-burst", optarg);
 		info->cfg.burst = num;
 		*flags |= PARAM_BURST;
 		return true;
 
 	case '&': /* --hashlimit-htable-size */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-size", optarg);
 		info->cfg.size = num;
 		*flags |= PARAM_SIZE;
 		return true;
 
 	case '*': /* --hashlimit-htable-max */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-max", optarg);
 		info->cfg.max = num;
 		*flags |= PARAM_MAX;
 		return true;
 
 	case '(': /* --hashlimit-htable-gcinterval */
-		param_act(P_ONLY_ONCE, "hashlimit",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-gcinterval", optarg);
 		/* FIXME: not HZ dependent!! */
 		info->cfg.gc_interval = num;
@@ -381,10 +381,10 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 		return true;
 
 	case ')': /* --hashlimit-htable-expire */
-		param_act(P_ONLY_ONCE, "hashlimit",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-expire", optarg);
 		/* FIXME: not HZ dependent */
 		info->cfg.expire = num;
@@ -392,16 +392,16 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 		return true;
 
 	case '_':
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-mode",
 		          *flags & PARAM_MODE);
 		if (parse_mode(&info->cfg.mode, optarg) < 0)
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-mode", optarg);
 		*flags |= PARAM_MODE;
 		return true;
 
 	case '"': /* --hashlimit-name */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-name",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
 		          *flags & PARAM_NAME);
 		if (strlen(optarg) == 0)
 			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
@@ -411,20 +411,20 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 		return true;
 
 	case '<': /* --hashlimit-srcmask */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-srcmask",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-srcmask",
 		          *flags & PARAM_SRCMASK);
 		if (!xtables_strtoui(optarg, NULL, &num, 0, maxmask))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-srcmask", optarg);
 		info->cfg.srcmask = num;
 		*flags |= PARAM_SRCMASK;
 		return true;
 
 	case '>': /* --hashlimit-dstmask */
-		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-dstmask",
+		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-dstmask",
 		          *flags & PARAM_DSTMASK);
 		if (!xtables_strtoui(optarg, NULL, &num, 0, maxmask))
-			param_act(P_BAD_VALUE, "hashlimit",
+			xtables_param_act(XTF_BAD_VALUE, "hashlimit",
 			          "--hashlimit-dstmask", optarg);
 		info->cfg.dstmask = num;
 		*flags |= PARAM_DSTMASK;
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 09e9fb7..0fe2b4f 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -110,15 +110,15 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1': /* --src-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ipaddr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		memcpy(&info->src_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ipaddr(end+1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-range", end + 1);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", end + 1);
 		memcpy(&info->src_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_SRC;
 		if (invert)
@@ -129,15 +129,15 @@ iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '2': /* --dst-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ipaddr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		memcpy(&info->dst_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ipaddr(end + 1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-range", end + 1);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", end + 1);
 		memcpy(&info->dst_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_DST;
 		if (invert)
@@ -160,15 +160,15 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1': /* --src-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ip6addr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", optarg);
 		memcpy(&info->src_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ip6addr(end+1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--src-range", end + 1);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--src-range", end + 1);
 		memcpy(&info->src_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_SRC;
 		if (invert)
@@ -179,15 +179,15 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '2': /* --dst-range */
 		end = strchr(optarg, '-');
 		if (end == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		*end = '\0';
 		ia = numeric_to_ip6addr(optarg);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-range", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", optarg);
 		memcpy(&info->dst_min.in, ia, sizeof(*ia));
 		ia = numeric_to_ip6addr(end + 1);
 		if (ia == NULL)
-			param_act(P_BAD_VALUE, "iprange", "--dst-range", end + 1);
+			xtables_param_act(XTF_BAD_VALUE, "iprange", "--dst-range", end + 1);
 		memcpy(&info->dst_max.in, ia, sizeof(*ia));
 		info->flags |= IPRANGE_DST;
 		if (invert)
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 31957e7..08bc9d9 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -34,14 +34,14 @@ static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1': /* --mark */
-		param_act(P_ONLY_ONCE, "mark", "--mark", *flags & F_MARK);
+		xtables_param_act(XTF_ONLY_ONCE, "mark", "--mark", *flags & F_MARK);
 		if (!xtables_strtoui(optarg, &end, &mark, 0, UINT32_MAX))
-			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "mark", "--mark", optarg);
 		if (*end == '/')
 			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-				param_act(P_BAD_VALUE, "mark", "--mark", optarg);
+				xtables_param_act(XTF_BAD_VALUE, "mark", "--mark", optarg);
 		if (*end != '\0')
-			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "mark", "--mark", optarg);
 
 		if (invert)
 			info->invert = true;
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 54d841c..bf26f35 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -112,11 +112,11 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case 'u':
-		param_act(P_ONLY_ONCE, "owner", "--uid-owner", *flags & FLAG_UID_OWNER);
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--uid-owner", *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
 			id = pwd->pw_uid;
 		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--uid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_UID;
 		info->match |= IPT_OWNER_UID;
@@ -125,11 +125,11 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 'g':
-		param_act(P_ONLY_ONCE, "owner", "--gid-owner", *flags & FLAG_GID_OWNER);
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--gid-owner", *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
 			id = grp->gr_gid;
 		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--gid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_GID;
 		info->match |= IPT_OWNER_GID;
@@ -138,9 +138,9 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 'p':
-		param_act(P_ONLY_ONCE, "owner", "--pid-owner", *flags & FLAG_PID_OWNER);
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--pid-owner", *flags & FLAG_PID_OWNER);
 		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			param_act(P_BAD_VALUE, "owner", "--pid-owner", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--pid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_PID;
 		info->match |= IPT_OWNER_PID;
@@ -149,9 +149,9 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 's':
-		param_act(P_ONLY_ONCE, "owner", "--sid-owner", *flags & FLAG_SID_OWNER);
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--sid-owner", *flags & FLAG_SID_OWNER);
 		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			param_act(P_BAD_VALUE, "owner", "--sid-value", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--sid-value", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_SID;
 		info->match |= IPT_OWNER_SID;
@@ -161,7 +161,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 
 #ifdef IPT_OWNER_COMM
 	case 'c':
-		param_act(P_ONLY_ONCE, "owner", "--cmd-owner", *flags & FLAG_COMM);
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--cmd-owner", *flags & FLAG_COMM);
 		if (strlen(optarg) > sizeof(info->comm))
 			exit_error(PARAMETER_PROBLEM, "owner match: command "
 			           "\"%s\" too long, max. %zu characters",
@@ -191,12 +191,12 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case 'u':
-		param_act(P_ONLY_ONCE, "owner", "--uid-owner",
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--uid-owner",
 		          *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
 			id = pwd->pw_uid;
 		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--uid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_UID;
 		info->match |= IP6T_OWNER_UID;
@@ -205,12 +205,12 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 'g':
-		param_act(P_ONLY_ONCE, "owner", "--gid-owner",
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--gid-owner",
 		          *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
 			id = grp->gr_gid;
 		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
-			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--gid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_GID;
 		info->match |= IP6T_OWNER_GID;
@@ -219,10 +219,10 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 'p':
-		param_act(P_ONLY_ONCE, "owner", "--pid-owner",
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--pid-owner",
 		          *flags & FLAG_PID_OWNER);
 		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			param_act(P_BAD_VALUE, "owner", "--pid-owner", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--pid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_PID;
 		info->match |= IP6T_OWNER_PID;
@@ -231,10 +231,10 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 's':
-		param_act(P_ONLY_ONCE, "owner", "--sid-owner",
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--sid-owner",
 		          *flags & FLAG_SID_OWNER);
 		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
-			param_act(P_BAD_VALUE, "owner", "--sid-owner", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "owner", "--sid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_SID;
 		info->match |= IP6T_OWNER_SID;
@@ -252,13 +252,13 @@ static void owner_parse_range(const char *s, unsigned int *from,
 
 	/* -1 is reversed, so the max is one less than that. */
 	if (!xtables_strtoui(s, &end, from, 0, UINT32_MAX - 1))
-		param_act(P_BAD_VALUE, "owner", opt, s);
+		xtables_param_act(XTF_BAD_VALUE, "owner", opt, s);
 	*to = *from;
 	if (*end == '-' || *end == ':')
 		if (!xtables_strtoui(end + 1, &end, to, 0, UINT32_MAX - 1))
-			param_act(P_BAD_VALUE, "owner", opt, s);
+			xtables_param_act(XTF_BAD_VALUE, "owner", opt, s);
 	if (*end != '\0')
-		param_act(P_BAD_VALUE, "owner", opt, s);
+		xtables_param_act(XTF_BAD_VALUE, "owner", opt, s);
 }
 
 static int owner_mt_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -271,7 +271,7 @@ static int owner_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case 'u':
-		param_act(P_ONLY_ONCE, "owner", "--uid-owner",
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--uid-owner",
 		          *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
 			from = to = pwd->pw_uid;
@@ -286,7 +286,7 @@ static int owner_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 'g':
-		param_act(P_ONLY_ONCE, "owner", "--gid-owner",
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--gid-owner",
 		          *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
 			from = to = grp->gr_gid;
@@ -301,7 +301,7 @@ static int owner_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		return true;
 
 	case 'k':
-		param_act(P_ONLY_ONCE, "owner", "--socket-exists",
+		xtables_param_act(XTF_ONLY_ONCE, "owner", "--socket-exists",
 		          *flags & FLAG_SOCKET_EXISTS);
 		if (invert)
 			info->invert |= XT_OWNER_SOCKET;
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 9f8d6fa..a611840 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -50,9 +50,9 @@ static int tos_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case 't':
-		param_act(P_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
+		xtables_param_act(XTF_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
 		if (!tos_parse_symbolic(optarg, &tvm, 0xFF))
-			param_act(P_BAD_VALUE, "tos", "--tos", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "tos", "--tos", optarg);
 		if (tvm.mask != 0xFF)
 			exit_error(PARAMETER_PROBLEM, "tos: Your kernel is "
 			           "too old to support anything besides /0xFF "
@@ -74,9 +74,9 @@ static int tos_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case 't':
-		param_act(P_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
+		xtables_param_act(XTF_ONLY_ONCE, "tos", "--tos", *flags & FLAG_TOS);
 		if (!tos_parse_symbolic(optarg, &tvm, 0x3F))
-			param_act(P_BAD_VALUE, "tos", "--tos", optarg);
+			xtables_param_act(XTF_BAD_VALUE, "tos", "--tos", optarg);
 		info->tos_value = tvm.value;
 		info->tos_mask  = tvm.mask;
 		if (invert)
diff --git a/include/xtables.h.in b/include/xtables.h.in
index e1f9c92..e5737cb 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -158,6 +158,17 @@ enum xtables_tryload {
 	XTF_LOAD_MUST_SUCCEED,
 };
 
+enum xtables_exittype {
+	OTHER_PROBLEM = 1,
+	PARAMETER_PROBLEM,
+	VERSION_PROBLEM,
+	RESOURCE_PROBLEM,
+	XTF_ONLY_ONCE,
+	XTF_NO_INVERT,
+	XTF_BAD_VALUE,
+	XTF_ONE_ACTION,
+};
+
 extern const char *xtables_program_name;
 extern const char *xtables_modprobe_program;
 extern struct xtables_match *xtables_matches;
@@ -188,24 +199,13 @@ extern u_int16_t parse_port(const char *port, const char *proto);
 extern void
 parse_interface(const char *arg, char *vianame, unsigned char *mask);
 
-enum exittype {
-	OTHER_PROBLEM = 1,
-	PARAMETER_PROBLEM,
-	VERSION_PROBLEM,
-	RESOURCE_PROBLEM,
-	P_ONLY_ONCE,
-	P_NO_INVERT,
-	P_BAD_VALUE,
-	P_ONE_ACTION,
-};
-
 /* this is a special 64bit data type that is 8-byte aligned */
 #define aligned_u64 u_int64_t __attribute__((aligned(8)))
 
 int check_inverse(const char option[], int *invert, int *my_optind, int argc);
-void exit_error(enum exittype, const char *, ...)__attribute__((noreturn,
-							  format(printf,2,3)));
-extern void param_act(unsigned int, const char *, ...);
+void exit_error(enum xtables_exittype, const char *, ...)
+	__attribute__((noreturn, format(printf,2,3)));
+extern void xtables_param_act(unsigned int, const char *, ...);
 
 extern const char *ipaddr_to_numeric(const struct in_addr *);
 extern const char *ipaddr_to_anyname(const struct in_addr *);
diff --git a/ip6tables.c b/ip6tables.c
index 0464185..cbacd89 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -365,7 +365,7 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 }
 
 void
-exit_error(enum exittype status, const char *msg, ...)
+exit_error(enum xtables_exittype status, const char *msg, ...)
 {
 	va_list args;
 
diff --git a/iptables-xml.c b/iptables-xml.c
index a3f6987..307845c 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -30,7 +30,7 @@ const char *program_version;
 
 #ifndef IPTABLES_MULTI
 int line = 0;
-void exit_error(enum exittype status, const char *msg, ...)
+void exit_error(enum xtables_exittype status, const char *msg, ...)
 {
 	va_list args;
 
diff --git a/iptables.c b/iptables.c
index 15b5b6f..9adc209 100644
--- a/iptables.c
+++ b/iptables.c
@@ -367,7 +367,7 @@ exit_printhelp(struct iptables_rule_match *matches)
 }
 
 void
-exit_error(enum exittype status, const char *msg, ...)
+exit_error(enum xtables_exittype status, const char *msg, ...)
 {
 	va_list args;
 
diff --git a/xtables.c b/xtables.c
index 642c04b..3ffefa2 100644
--- a/xtables.c
+++ b/xtables.c
@@ -676,7 +676,31 @@ void xtables_register_target(struct xtables_target *me)
 	me->tflags = 0;
 }
 
-void param_act(unsigned int status, const char *p1, ...)
+/**
+ * xtables_param_act - act on condition
+ * @status:	a constant from enum xtables_exittype
+ *
+ * %XTF_ONLY_ONCE: print error message that option may only be used once.
+ * @p1:		module name (e.g. "mark")
+ * @p2(...):	option in conflict (e.g. "--mark")
+ * @p3(...):	condition to match on (see extensions/ for examples)
+ *
+ * %XTF_NO_INVERT: option does not support inversion
+ * @p1:		module name
+ * @p2:		option in conflict
+ * @p3:		condition to match on
+ *
+ * %XTF_BAD_VALUE: bad value for option
+ * @p1:		module name
+ * @p2:		option with which the problem occured (e.g. "--mark")
+ * @p3:		string the user passed in (e.g. "99999999999999")
+ *
+ * %XTF_ONE_ACTION: two mutually exclusive actions have been specified
+ * @p1:		module name
+ *
+ * Displays an error message and exits the program.
+ */
+void xtables_param_act(unsigned int status, const char *p1, ...)
 {
 	const char *p2, *p3;
 	va_list args;
@@ -685,7 +709,7 @@ void param_act(unsigned int status, const char *p1, ...)
 	va_start(args, p1);
 
 	switch (status) {
-	case P_ONLY_ONCE:
+	case XTF_ONLY_ONCE:
 		p2 = va_arg(args, const char *);
 		b  = va_arg(args, unsigned int);
 		if (!b)
@@ -694,7 +718,7 @@ void param_act(unsigned int status, const char *p1, ...)
 		           "%s: \"%s\" option may only be specified once",
 		           p1, p2);
 		break;
-	case P_NO_INVERT:
+	case XTF_NO_INVERT:
 		p2 = va_arg(args, const char *);
 		b  = va_arg(args, unsigned int);
 		if (!b)
@@ -702,14 +726,14 @@ void param_act(unsigned int status, const char *p1, ...)
 		exit_error(PARAMETER_PROBLEM,
 		           "%s: \"%s\" option cannot be inverted", p1, p2);
 		break;
-	case P_BAD_VALUE:
+	case XTF_BAD_VALUE:
 		p2 = va_arg(args, const char *);
 		p3 = va_arg(args, const char *);
 		exit_error(PARAMETER_PROBLEM,
 		           "%s: Bad value for \"%s\" option: \"%s\"",
 		           p1, p2, p3);
 		break;
-	case P_ONE_ACTION:
+	case XTF_ONE_ACTION:
 		b = va_arg(args, unsigned int);
 		if (!b)
 			return;
-- 
1.6.1.2

