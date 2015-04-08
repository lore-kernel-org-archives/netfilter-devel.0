From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] libxtables: extensions find based also on family
Date: Wed, 08 Apr 2015 19:42:19 +0200
Message-ID: <20150408174219.25244.24487.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:38338 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753475AbbDHRm1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Apr 2015 13:42:27 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

When using libxtables with an external program (nft) which switches family
contexts (using xtables_set_nfproto()), the extensions finding proccess
needs to be smarter and also know about the family.

We want to avoid this situation:

 1) user first sets context to IPv6
 2) xtables_find_target() finds & load ip6t_REJECT and uses it
 3) context switch to IPv4
 4) user then tries to use ipt_REJECT
 5) xtables_find_target() will find ip6t_REJECT instead (same target name)
 6) using ip6t_REJECT as ipt_REJECT can cause a lot of troubles

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 libxtables/xtables.c |   22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 9df12ce..c56d7dd 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -603,6 +603,17 @@ static void *load_extension(const char *search_path, const char *af_prefix,
 }
 #endif
 
+static bool extension_cmp(const char *name1, const char *name2,
+			  uint32_t family)
+{
+	if ((strcmp(name1, name2) == 0) &&
+	    ((family == afinfo->family) ||
+	     (family == NFPROTO_UNSPEC)))
+		return true;
+
+	return false;
+}
+
 struct xtables_match *
 xtables_find_match(const char *name, enum xtables_tryload tryload,
 		   struct xtables_rule_match **matches)
@@ -625,7 +636,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 
 	/* Trigger delayed initialization */
 	for (dptr = &xtables_pending_matches; *dptr; ) {
-		if (strcmp(name, (*dptr)->name) == 0) {
+		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
 			ptr->next = NULL;
@@ -636,7 +647,7 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 	}
 
 	for (ptr = xtables_matches; ptr; ptr = ptr->next) {
-		if (strcmp(name, ptr->name) == 0) {
+		if (extension_cmp(name, ptr->name, ptr->family)) {
 			struct xtables_match *clone;
 
 			/* First match of this type: */
@@ -686,7 +697,8 @@ xtables_find_match(const char *name, enum xtables_tryload tryload,
 		newentry = xtables_malloc(sizeof(struct xtables_rule_match));
 
 		for (i = matches; *i; i = &(*i)->next) {
-			if (strcmp(name, (*i)->match->name) == 0)
+			if (extension_cmp(name, (*i)->match->name,
+					  (*i)->match->family))
 				(*i)->completed = true;
 		}
 		newentry->match = ptr;
@@ -714,7 +726,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 
 	/* Trigger delayed initialization */
 	for (dptr = &xtables_pending_targets; *dptr; ) {
-		if (strcmp(name, (*dptr)->name) == 0) {
+		if (extension_cmp(name, (*dptr)->name, (*dptr)->family)) {
 			ptr = *dptr;
 			*dptr = (*dptr)->next;
 			ptr->next = NULL;
@@ -725,7 +737,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 	}
 
 	for (ptr = xtables_targets; ptr; ptr = ptr->next) {
-		if (strcmp(name, ptr->name) == 0)
+		if (extension_cmp(name, ptr->name, ptr->family))
 			break;
 	}
 

