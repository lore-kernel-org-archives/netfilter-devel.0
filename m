From: "Holger Eitzenberger" <holger@eitzenberger.org>
Subject: [patch 1/6] ipset: turn Set name[] into a const pointer
Date: Mon, 24 Jan 2011 22:36:32 +0100
Message-ID: <20110124214009.410600508@jonathan.eitzenberger.org>
References: <20110124213631.195499507@jonathan.eitzenberger.org>
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:64211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1AXVkN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Jan 2011 16:40:13 -0500
Content-Disposition: inline; filename=ipset-set_type-name-pointer.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also check for the name length.

Note that passing errno values back is not done consistently at
various place, as there are some functions which set errno manually,
others pass -errno back.  I use the -errno approach here, as it is
slightly shorter.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ipset/include/libipset/types.h
===================================================================
--- ipset.orig/include/libipset/types.h
+++ ipset/include/libipset/types.h
@@ -70,7 +70,7 @@ struct ipset_elem {
  * but for the readability the full list is supported.
   */
 struct ipset_type {
-	char name[IPSET_MAXNAMELEN];		/* type name */
+	const char *name;
 	uint8_t revision;			/* revision number */
 	uint8_t family;				/* supported family */
 	uint8_t dimension;			/* elem dimension */
Index: ipset/lib/types.c
===================================================================
--- ipset.orig/lib/types.c
+++ ipset/lib/types.c
@@ -441,13 +441,15 @@ ipset_type_add(struct ipset_type *type)
 
 	assert(type);
 
+	if (strlen(type->name) > IPSET_MAXNAMELEN - 1)
+		return -EINVAL;
+
 	/* Add to the list: higher revision numbers first */
 	for (t = typelist, prev = NULL; t != NULL; t = t->next) {
 		if (STREQ(t->name, type->name)) {
-			if (t->revision == type->revision) {
-				errno = EEXIST;
-				return -1;
-			} else if (t->revision < type->revision) {
+			if (t->revision == type->revision)
+				return -EEXIST;
+			else if (t->revision < type->revision) {
 				type->next = t;
 				if (prev)
 					prev->next = type;
@@ -457,10 +459,9 @@ ipset_type_add(struct ipset_type *type)
 			}
 		}
 		if (t->next != NULL && STREQ(t->next->name, type->name)) {
-			if (t->next->revision == type->revision) {
-				errno = EEXIST;
-				return -1;
-			} else if (t->next->revision < type->revision) {
+			if (t->next->revision == type->revision)
+				return -EEXIST;
+			else if (t->next->revision < type->revision) {
 				type->next = t->next;
 				t->next = type;
 				return 0;

