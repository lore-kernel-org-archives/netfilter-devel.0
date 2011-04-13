From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 06/26] libxtables: linked-list name<->id map
Date: Wed, 13 Apr 2011 18:13:27 +0200
Message-ID: <1302711228-15947-7-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42510 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932944Ab1DMQN4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:13:56 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This consolidates the maps from libxt_devgroup and libxt_realm.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/xtables.h.in |   15 ++++++++
 xtoptions.c          |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+), 0 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index c361bdb..30d9e73 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -134,6 +134,16 @@ struct xt_fcheck_call {
 	unsigned int xflags;
 };
 
+/**
+ * A "linear"/linked-list based name<->id map, for files similar to
+ * /etc/iproute2/.
+ */
+struct xtables_lmap {
+	char *name;
+	int id;
+	struct xtables_lmap *next;
+};
+
 /* Include file for additions: new matches and targets. */
 struct xtables_match
 {
@@ -418,6 +428,11 @@ extern void xtables_option_mfcall(struct xtables_match *);
 extern void xtables_options_fcheck(const char *, unsigned int,
 				   const struct xt_option_entry *);
 
+extern struct xtables_lmap *xtables_lmap_init(const char *);
+extern void xtables_lmap_free(struct xtables_lmap *);
+extern int xtables_lmap_name2id(const struct xtables_lmap *, const char *);
+extern const char *xtables_lmap_id2name(const struct xtables_lmap *, int);
+
 #ifdef XTABLES_INTERNAL
 
 /* Shipped modules rely on this... */
diff --git a/xtoptions.c b/xtoptions.c
index 4206314..f48c011 100644
--- a/xtoptions.c
+++ b/xtoptions.c
@@ -7,6 +7,7 @@
  *	published by the Free Software Foundation; either version 2 of
  *	the License, or (at your option) any later version.
  */
+#include <ctype.h>
 #include <errno.h>
 #include <getopt.h>
 #include <limits.h>
@@ -487,3 +488,101 @@ void xtables_option_mfcall(struct xtables_match *m)
 	if (m->x6_options != NULL)
 		xtables_options_fcheck(m->name, m->mflags, m->x6_options);
 }
+
+struct xtables_lmap *xtables_lmap_init(const char *file)
+{
+	struct xtables_lmap *lmap_head = NULL, *lmap_prev = NULL, *lmap_this;
+	char buf[512];
+	FILE *fp;
+	char *cur, *nxt;
+	int id;
+
+	fp = fopen(file, "re");
+	if (fp == NULL)
+		return NULL;
+
+	while (fgets(buf, sizeof(buf), fp) != NULL) {
+		cur = buf;
+		while (isspace(*cur))
+			++cur;
+		if (*cur == '#' || *cur == '\n' || *cur == '\0')
+			continue;
+
+		/* iproute2 allows hex and dec format */
+		errno = 0;
+		id = strtoul(cur, &nxt, strncmp(cur, "0x", 2) == 0 ? 16 : 10);
+		if (nxt == cur || errno != 0)
+			continue;
+
+		/* same boundaries as in iproute2 */
+		if (id < 0 || id > 255)
+			continue;
+		cur = nxt;
+
+		if (!isspace(*cur))
+			continue;
+		while (isspace(*cur))
+			++cur;
+		if (*cur == '#' || *cur == '\n' || *cur == '\0')
+			continue;
+		nxt = cur;
+		while (*nxt != '\0' && !isspace(*nxt))
+			++nxt;
+		if (nxt == cur)
+			continue;
+		*nxt = '\0';
+
+		/* found valid data */
+		lmap_this = malloc(sizeof(*lmap_this));
+		if (lmap_this == NULL) {
+			perror("malloc");
+			goto out;
+		}
+		lmap_this->id   = id;
+		lmap_this->name = strdup(cur);
+		if (lmap_this->name == NULL) {
+			free(lmap_this);
+			goto out;
+		}
+		lmap_this->next = NULL;
+
+		if (lmap_prev != NULL)
+			lmap_prev->next = lmap_this;
+		else
+			lmap_head = lmap_this;
+		lmap_prev = lmap_this;
+	}
+
+	fclose(fp);
+	return lmap_head;
+ out:
+	xtables_lmap_free(lmap_head);
+	return NULL;
+}
+
+void xtables_lmap_free(struct xtables_lmap *head)
+{
+	struct xtables_lmap *next;
+
+	for (; head != NULL; head = next) {
+		next = head->next;
+		free(head->name);
+		free(head);
+	}
+}
+
+int xtables_lmap_name2id(const struct xtables_lmap *head, const char *name)
+{
+	for (; head != NULL; head = head->next)
+		if (strcmp(head->name, name) == 0)
+			return head->id;
+	return -1;
+}
+
+const char *xtables_lmap_id2name(const struct xtables_lmap *head, int id)
+{
+	for (; head != NULL; head = head->next)
+		if (head->id == id)
+			return head->name;
+	return NULL;
+}
-- 
1.7.1

