From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/7] libxt_devgroup: consolidate devgroup specification parsing
Date: Sat, 28 Jul 2012 19:21:06 +0200
Message-ID: <1343496069-5442-5-git-send-email-jengelh@inai.de>
References: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:34349 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985Ab2G1RVR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jul 2012 13:21:17 -0400
In-Reply-To: <1343496069-5442-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a small cleanup, reducing the two copies of X/Y parsing to
one.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_devgroup.c |   70 ++++++++++++++++++------------------------
 1 files changed, 30 insertions(+), 40 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 4487c83..69ae279 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -42,58 +42,48 @@ static void devgroup_init(struct xt_entry_match *match)
 		fprintf(stderr, "Warning: %s: %s\n", file, strerror(errno));
 }
 
+static void devgroup_parse_groupspec(const char *arg, unsigned int *group,
+				     unsigned int *mask)
+{
+	char *end;
+
+	*group = strtoul(arg, &end, 0);
+	if (end != arg && (*end == '/' || *end == '\0')) {
+		if (*end == '/')
+			*mask = strtoul(end + 1, &end, 0);
+		else
+			*mask = ~0U;
+		if (*end != '\0' || end == arg)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Bad group value \"%s\"", arg);
+	} else {
+		*group = xtables_lmap_name2id(devgroups, arg);
+		if (*group == -1)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Device group \"%s\" not found", arg);
+		*mask = ~0U;
+	}
+}
+
 static void devgroup_parse(struct xt_option_call *cb)
 {
 	struct xt_devgroup_info *info = cb->data;
-	unsigned int id;
-	char *end;
+	unsigned int id, mask;
 
 	xtables_option_parse(cb);
 	switch (cb->entry->id) {
 	case O_SRC_GROUP:
-		info->src_group = strtoul(cb->arg, &end, 0);
-		if (end != cb->arg && (*end == '/' || *end == '\0')) {
-			if (*end == '/')
-				info->src_mask = strtoul(end+1, &end, 0);
-			else
-				info->src_mask = 0xffffffff;
-			if (*end != '\0' || end == cb->arg)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Bad src-group value `%s'",
-					      cb->arg);
-		} else {
-			id = xtables_lmap_name2id(devgroups, cb->arg);
-			if (id == -1)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Device group `%s' not found",
-					      cb->arg);
-			info->src_group = id;
-			info->src_mask  = 0xffffffff;
-		}
+		devgroup_parse_groupspec(cb->arg, &id, &mask);
+		info->src_group = id;
+		info->src_mask  = mask;
 		info->flags |= XT_DEVGROUP_MATCH_SRC;
 		if (cb->invert)
 			info->flags |= XT_DEVGROUP_INVERT_SRC;
 		break;
 	case O_DST_GROUP:
-		info->dst_group = strtoul(cb->arg, &end, 0);
-		if (end != cb->arg && (*end == '/' || *end == '\0')) {
-			if (*end == '/')
-				info->dst_mask = strtoul(end+1, &end, 0);
-			else
-				info->dst_mask = 0xffffffff;
-			if (*end != '\0' || end == cb->arg)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Bad dst-group value `%s'",
-					      cb->arg);
-		} else {
-			id = xtables_lmap_name2id(devgroups, cb->arg);
-			if (id == -1)
-				xtables_error(PARAMETER_PROBLEM,
-					      "Device group `%s' not found",
-					      cb->arg);
-			info->dst_group = id;
-			info->dst_mask  = 0xffffffff;
-		}
+		devgroup_parse_groupspec(cb->arg, &id, &mask);
+		info->dst_group = id;
+		info->dst_mask  = mask;
 		info->flags |= XT_DEVGROUP_MATCH_DST;
 		if (cb->invert)
 			info->flags |= XT_DEVGROUP_INVERT_DST;
-- 
1.7.7

