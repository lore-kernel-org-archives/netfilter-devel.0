From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/26] libxt_devgroup: use guided option parser
Date: Wed, 13 Apr 2011 18:13:28 +0200
Message-ID: <1302711228-15947-8-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42445 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933046Ab1DMQN6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:58 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_devgroup.c |  201 +++++++++----------------------------------
 1 files changed, 41 insertions(+), 160 deletions(-)

diff --git a/extensions/libxt_devgroup.c b/extensions/libxt_devgroup.c
index 2624868..a925dd0 100644
--- a/extensions/libxt_devgroup.c
+++ b/extensions/libxt_devgroup.c
@@ -2,14 +2,10 @@
  *
  * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
  */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
 #include <errno.h>
-#include <ctype.h>
-#include <getopt.h>
 #include <xtables.h>
 #include <linux/netfilter/xt_devgroup.h>
 
@@ -23,200 +19,84 @@ static void devgroup_help(void)
 }
 
 enum {
-	XT_DEVGROUP_OPT_SRCGROUP = 1,
-	XT_DEVGROUP_OPT_DSTGROUP,
+	O_SRC_GROUP = 0,
+	O_DST_GROUP,
 };
 
-static const struct option devgroup_opts[] = {
-	{ .name = "src-group", .has_arg = true, .val = XT_DEVGROUP_OPT_SRCGROUP },
-	{ .name = "dst-group", .has_arg = true, .val = XT_DEVGROUP_OPT_DSTGROUP },
-	XT_GETOPT_TABLEEND,
-};
-
-struct devgroupname {
-	unsigned int		id;
-	char			*name;
-	int			len;
-	struct devgroupname	*next;
+static const struct xt_option_entry devgroup_opts[] = {
+	{.name = "src-group", .id = O_SRC_GROUP, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "dst-group", .id = O_DST_GROUP, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 /* array of devgroups from /etc/iproute2/group_map */
-static struct devgroupname *devgroups;
-/* 1 if loading failed */
-static int rdberr;
+static struct xtables_lmap *devgroups;
 
-static void load_devgroups(void)
+static void devgroup_init(struct xt_entry_match *match)
 {
-	const char* rfnm = "/etc/iproute2/group_map";
-	char buf[512];
-	FILE *fil;
-	char *cur, *nxt;
-	int id;
-	struct devgroupname *oldnm = NULL, *newnm = NULL;
-
-	fil = fopen(rfnm, "r");
-	if (!fil) {
-		rdberr = 1;
-		return;
-	}
-
-	while (fgets(buf, sizeof(buf), fil)) {
-		cur = buf;
-		while ((*cur == ' ') || (*cur == '\t'))
-			cur++;
-		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
-			continue;
-
-		/* iproute2 allows hex and dec format */
-		errno = 0;
-		id = strtoul(cur, &nxt, strncmp(cur, "0x", 2) ? 10 : 16);
-		if ((nxt == cur) || errno)
-			continue;
-
-		/* same boundaries as in iproute2 */
-		if (id < 0 || id > 255)
-			continue;
-		cur = nxt;
-
-		if (!isspace(*cur))
-			continue;
-		while ((*cur == ' ') || (*cur == '\t'))
-			cur++;
-		if ((*cur == '#') || (*cur == '\n') || (*cur == 0))
-			continue;
-		nxt = cur;
-		while ((*nxt != 0) && !isspace(*nxt))
-			nxt++;
-		if (nxt == cur)
-			continue;
-
-		/* found valid data */
-		newnm = malloc(sizeof(struct devgroupname));
-		if (newnm == NULL) {
-			perror("libxt_devgroup: malloc failed");
-			exit(1);
-		}
-		newnm->id = id;
-		newnm->len = nxt - cur;
-		newnm->name = malloc(newnm->len + 1);
-		if (newnm->name == NULL) {
-			perror("libxt_devgroup: malloc failed");
-			exit(1);
-		}
-		strncpy(newnm->name, cur, newnm->len);
-		newnm->name[newnm->len] = 0;
-		newnm->next = NULL;
-
-		if (oldnm)
-			oldnm->next = newnm;
-		else
-			devgroups = newnm;
-		oldnm = newnm;
-	}
-
-	fclose(fil);
-}
-
-/* get devgroup id for name, -1 if error/not found */
-static int devgroup_name2id(const char* name)
-{
-	struct devgroupname* cur;
-
-	if ((devgroups == NULL) && (rdberr == 0))
-		load_devgroups();
-	cur = devgroups;
-	if (cur == NULL)
-		return -1;
-	while (cur) {
-		if (!strncmp(name, cur->name, cur->len + 1))
-			return cur->id;
-		cur = cur->next;
-	}
-	return -1;
-}
-
-/* get devgroup name for id, NULL if error/not found */
-static const char *devgroup_id2name(int id)
-{
-	struct devgroupname* cur;
-
-	if ((devgroups == NULL) && (rdberr == 0))
-		load_devgroups();
-	cur = devgroups;
-	if (cur == NULL)
-		return NULL;
-	while (cur) {
-		if (id == cur->id)
-			return cur->name;
-		cur = cur->next;
-	}
-	return NULL;
+	const char file[] = "/etc/iproute2/group_map";
+	devgroups = xtables_lmap_init(file);
+	if (devgroups == NULL && errno != ENOENT)
+		fprintf(stderr, "Warning: %s: %s\n", file, strerror(errno));
 }
 
-static int devgroup_parse(int c, char **argv, int invert, unsigned int *flags,
-                       const void *entry, struct xt_entry_match **match)
+static void devgroup_parse(struct xt_option_call *cb)
 {
-	struct xt_devgroup_info *info = (struct xt_devgroup_info *)(*match)->data;
+	struct xt_devgroup_info *info = cb->data;
 	unsigned int id;
 	char *end;
 
-	switch (c) {
-	case XT_DEVGROUP_OPT_SRCGROUP:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		end = optarg;
-		info->src_group = strtoul(optarg, &end, 0);
-		if (end != optarg && (*end == '/' || *end == '\0')) {
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SRC_GROUP:
+		info->src_group = strtoul(cb->arg, &end, 0);
+		if (end != cb->arg && (*end == '/' || *end == '\0')) {
 			if (*end == '/')
 				info->src_mask = strtoul(end+1, &end, 0);
 			else
 				info->src_mask = 0xffffffff;
-			if (*end != '\0' || end == optarg)
+			if (*end != '\0' || end == cb->arg)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Bad src-group value `%s'",
-					      optarg);
+					      cb->arg);
 		} else {
-			id = devgroup_name2id(optarg);
+			id = xtables_lmap_name2id(devgroups, cb->arg);
 			if (id == -1)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Device group `%s' not found",
-					      optarg);
+					      cb->arg);
 			info->src_group = id;
 			info->src_mask  = 0xffffffff;
 		}
-		info->flags |= XT_DEVGROUP_MATCH_SRC;
-		if (invert)
+		if (cb->invert)
 			info->flags |= XT_DEVGROUP_INVERT_SRC;
-		*flags |= c;
 		break;
-	case XT_DEVGROUP_OPT_DSTGROUP:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		end = optarg;
-		info->dst_group = strtoul(optarg, &end, 0);
-		if (end != optarg && (*end == '/' || *end == '\0')) {
+	case O_DST_GROUP:
+		info->dst_group = strtoul(cb->arg, &end, 0);
+		if (end != cb->arg && (*end == '/' || *end == '\0')) {
 			if (*end == '/')
 				info->dst_mask = strtoul(end+1, &end, 0);
 			else
 				info->dst_mask = 0xffffffff;
-			if (*end != '\0' || end == optarg)
+			if (*end != '\0' || end == cb->arg)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Bad dst-group value `%s'",
-					      optarg);
+					      cb->arg);
 		} else {
-			id = devgroup_name2id(optarg);
+			id = xtables_lmap_name2id(devgroups, cb->arg);
 			if (id == -1)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Device group `%s' not found",
-					      optarg);
+					      cb->arg);
 			info->dst_group = id;
 			info->dst_mask  = 0xffffffff;
 		}
-		info->flags |= XT_DEVGROUP_MATCH_DST;
-		if (invert)
+		if (cb->invert)
 			info->flags |= XT_DEVGROUP_INVERT_DST;
-		*flags |= c;
 		break;
 	}
-	return 1;
 }
 
 static void
@@ -228,7 +108,7 @@ print_devgroup(unsigned int id, unsigned int mask, int numeric)
 		printf("0x%x/0x%x", id, mask);
 	else {
 		if (numeric == 0)
-			name = devgroup_id2name(id);
+			name = xtables_lmap_id2name(devgroups, id);
 		if (name)
 			printf("%s", name);
 		else
@@ -269,9 +149,9 @@ static void devgroup_save(const void *ip, const struct xt_entry_match *match)
 	devgroup_show("--", info, 0);
 }
 
-static void devgroup_check(unsigned int flags)
+static void devgroup_check(struct xt_fcheck_call *cb)
 {
-	if (!flags)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 			      "devgroup match: You must specify either "
 			      "'--src-group' or '--dst-group'");
@@ -283,12 +163,13 @@ static struct xtables_match devgroup_mt_reg = {
 	.family		= NFPROTO_UNSPEC,
 	.size		= XT_ALIGN(sizeof(struct xt_devgroup_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_devgroup_info)),
+	.init		= devgroup_init,
 	.help		= devgroup_help,
-	.parse		= devgroup_parse,
-	.final_check	= devgroup_check,
 	.print		= devgroup_print,
 	.save		= devgroup_save,
-	.extra_opts	= devgroup_opts,
+	.x6_parse	= devgroup_parse,
+	.x6_fcheck	= devgroup_check,
+	.x6_options	= devgroup_opts,
 };
 
 void _init(void)
-- 
1.7.1

