From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 08/26] libipt_realm: use guided option parser
Date: Wed, 13 Apr 2011 18:13:29 +0200
Message-ID: <1302711228-15947-9-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42448 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933057Ab1DMQN7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:59 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_realm.c |  202 +++++++++------------------------------------
 1 files changed, 39 insertions(+), 163 deletions(-)

diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 17b1754..b60c57e 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -1,12 +1,7 @@
-/* Shared library add-on to iptables to add realm matching support. */
-#include <stdbool.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
 #include <stdlib.h>
 #include <errno.h>
-#include <ctype.h>
-#include <getopt.h>
 #if defined(__GLIBC__) && __GLIBC__ == 2
 #include <net/ethernet.h>
 #else
@@ -15,6 +10,10 @@
 #include <xtables.h>
 #include <linux/netfilter_ipv4/ipt_realm.h>
 
+enum {
+	O_REALM = 0,
+};
+
 static void realm_help(void)
 {
 	printf(
@@ -23,165 +22,49 @@ static void realm_help(void)
 "				Match realm\n");
 }
 
-static const struct option realm_opts[] = {
-	{.name = "realm", .has_arg = true, .val = '1'},
-	XT_GETOPT_TABLEEND,
-};
-
-struct realmname { 
-	int	id;
-	char*	name;
-	int	len;
-	struct realmname* next;
+static const struct xt_option_entry realm_opts[] = {
+	{.name = "realm", .id = O_REALM, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND | XTOPT_INVERT},
+	XTOPT_TABLEEND,
 };
 
 /* array of realms from /etc/iproute2/rt_realms */
-static struct realmname *realms;
-/* 1 if loading failed */
-static int rdberr;
+static struct xtables_lmap *realms;
 
-static void load_realms(void)
+static void realm_init(struct xt_entry_match *m)
 {
-	const char* rfnm = "/etc/iproute2/rt_realms";
-	char buf[512];
-	FILE *fil;
-	char *cur, *nxt;
-	int id;
-	struct realmname *oldnm = NULL, *newnm = NULL;
-
-	fil = fopen(rfnm, "re");
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
-		newnm = malloc(sizeof(struct realmname));
-		if (newnm == NULL) {
-			perror("libipt_realm: malloc failed");
-			exit(1);
-		}
-		newnm->id = id;
-		newnm->len = nxt - cur;
-		newnm->name = malloc(newnm->len + 1);
-		if (newnm->name == NULL) {
-			perror("libipt_realm: malloc failed");
-			exit(1);
-		}
-		strncpy(newnm->name, cur, newnm->len);
-		newnm->name[newnm->len] = 0;
-		newnm->next = NULL;
-
-		if (oldnm)
-			oldnm->next = newnm;
-		else
-			realms = newnm;
-		oldnm = newnm;
-	}
-
-	fclose(fil);
+	const char file[] = "/etc/iproute2/rt_realms";
+	realms = xtables_lmap_init(file);
+	if (realms == NULL && errno != ENOENT)
+		fprintf(stderr, "Warning: %s: %s\n", file, strerror(errno));
 }
 
-/* get realm id for name, -1 if error/not found */
-static int realm_name2id(const char* name)
+static void realm_parse(struct xt_option_call *cb)
 {
-	struct realmname* cur;
-
-	if ((realms == NULL) && (rdberr == 0))
-		load_realms();
-	cur = realms;
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
-/* get realm name for id, NULL if error/not found */
-static const char *realm_id2name(int id)
-{
-	struct realmname* cur;
-
-	if ((realms == NULL) && (rdberr == 0))
-		load_realms();
-	cur = realms;
-	if (cur == NULL)
-		return NULL;
-	while (cur) {
-		if (id == cur->id)
-			return cur->name;
-		cur = cur->next;
-	}
-	return NULL;
-}
-
-static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
-                       const void *entry, struct xt_entry_match **match)
-{
-	struct ipt_realm_info *realminfo = (struct ipt_realm_info *)(*match)->data;
+	struct ipt_realm_info *realminfo = cb->data;
 	int id;
+	char *end;
 
-	switch (c) {
-		char *end;
-	case '1':
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-		end = optarg = optarg;
-		realminfo->id = strtoul(optarg, &end, 0);
-		if (end != optarg && (*end == '/' || *end == '\0')) {
-			if (*end == '/')
-				realminfo->mask = strtoul(end+1, &end, 0);
-			else
-				realminfo->mask = 0xffffffff;
-			if (*end != '\0' || end == optarg)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Bad realm value `%s'", optarg);
-		} else {
-			id = realm_name2id(optarg);
-			if (id == -1)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Realm `%s' not found", optarg);
-			realminfo->id = id;
+	xtables_option_parse(cb);
+	realminfo->id = strtoul(cb->arg, &end, 0);
+	if (end != cb->arg && (*end == '/' || *end == '\0')) {
+		if (*end == '/')
+			realminfo->mask = strtoul(end+1, &end, 0);
+		else
 			realminfo->mask = 0xffffffff;
-		}
-		if (invert)
-			realminfo->invert = 1;
-		*flags = 1;
-		break;
+		if (*end != '\0' || end == cb->arg)
+			xtables_error(PARAMETER_PROBLEM,
+				   "Bad realm value \"%s\"", cb->arg);
+	} else {
+		id = xtables_lmap_name2id(realms, cb->arg);
+		if (id == -1)
+			xtables_error(PARAMETER_PROBLEM,
+				   "Realm \"%s\" not found", cb->arg);
+		realminfo->id = id;
+		realminfo->mask = 0xffffffff;
 	}
-	return 1;
+	if (cb->invert)
+		realminfo->invert = 1;
 }
 
 static void
@@ -193,7 +76,7 @@ print_realm(unsigned long id, unsigned long mask, int numeric)
 		printf(" 0x%lx/0x%lx", id, mask);
 	else {
 		if (numeric == 0)
-			name = realm_id2name(id);
+			name = xtables_lmap_id2name(realms, id);
 		if (name)
 			printf(" %s", name);
 		else
@@ -224,13 +107,6 @@ static void realm_save(const void *ip, const struct xt_entry_match *match)
 	print_realm(ri->id, ri->mask, 0);
 }
 
-static void realm_check(unsigned int flags)
-{
-	if (!flags)
-		xtables_error(PARAMETER_PROBLEM,
-			   "realm match: You must specify `--realm'");
-}
-
 static struct xtables_match realm_mt_reg = {
 	.name		= "realm",
 	.version	= XTABLES_VERSION,
@@ -238,11 +114,11 @@ static struct xtables_match realm_mt_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_realm_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_realm_info)),
 	.help		= realm_help,
-	.parse		= realm_parse,
-	.final_check	= realm_check,
+	.init		= realm_init,
 	.print		= realm_print,
 	.save		= realm_save,
-	.extra_opts	= realm_opts,
+	.x6_parse	= realm_parse,
+	.x6_options	= realm_opts,
 };
 
 void _init(void)
-- 
1.7.1

