From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] xtables: remove xtables_set_revision function
Date: Thu, 24 Jun 2010 10:14:04 +0200
Message-ID: <1277367245-14961-4-git-send-email-jengelh@medozas.de>
References: <1277367245-14961-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37890 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab0FXIOM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jun 2010 04:14:12 -0400
In-Reply-To: <1277367245-14961-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Since iptables uses its own copies of the header files anyway where the
revision field is exposed, there is no reach to access name[] beyond its
size.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac         |    2 +-
 include/xtables.h.in |    1 -
 ip6tables.c          |    8 +++-----
 iptables.c           |   11 ++++-------
 xtables.c            |    8 --------
 5 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/configure.ac b/configure.ac
index ba723bf..dd74a89 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@
 AC_INIT([iptables], [1.4.8])
 
 # See libtool.info "Libtool's versioning system"
-libxtables_vcurrent=4
+libxtables_vcurrent=5
 libxtables_vage=0
 
 AC_CONFIG_HEADERS([config.h])
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 788ad7d..2d7df32 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -216,7 +216,6 @@ extern void *xtables_realloc(void *, size_t);
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
-extern void xtables_set_revision(char *name, u_int8_t revision);
 extern void xtables_free_opts(int reset_offset);
 extern struct option *xtables_merge_options(struct option *oldopts,
 	const struct option *newopts, unsigned int *option_offset);
diff --git a/ip6tables.c b/ip6tables.c
index 2fff21b..6c5d124 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1558,8 +1558,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				xtables_set_revision(target->t->u.user.name,
-					     target->revision);
+				target->t->u.user.revision = target->revision;
 				if (target->init != NULL)
 					target->init(target->t);
 				opts = xtables_merge_options(opts,
@@ -1611,7 +1610,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			xtables_set_revision(m->m->u.user.name, m->revision);
+			m->m->u.user.revision = m->revision;
 			if (m->init != NULL)
 				m->init(m->m);
 			if (m != m->next)
@@ -1759,8 +1758,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					xtables_set_revision(m->m->u.user.name,
-						     m->revision);
+					m->m->u.user.revision = m->revision;
 					if (m->init != NULL)
 						m->init(m->m);
 
diff --git a/iptables.c b/iptables.c
index efe993e..19f6d4f 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1573,8 +1573,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				xtables_set_revision(target->t->u.user.name,
-					     target->revision);
+				target->t->u.user.revision = target->revision;
 				if (target->init != NULL)
 					target->init(target->t);
 				opts = xtables_merge_options(opts,
@@ -1632,7 +1631,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			xtables_set_revision(m->m->u.user.name, m->revision);
+			m->m->u.user.revision = m->revision;
 			if (m->init != NULL)
 				m->init(m->m);
 			if (m != m->next) {
@@ -1787,8 +1786,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					xtables_set_revision(m->m->u.user.name,
-						     m->revision);
+					m->m->u.user.revision = m->revision;
 					if (m->init != NULL)
 						m->init(m->m);
 
@@ -1947,8 +1945,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
 			if (!iptc_is_chain(jumpto, *handle))
-				xtables_set_revision(target->t->u.user.name,
-					     target->revision);
+				target->t->u.user.revision = target->revision;
 			if (target->init != NULL)
 				target->init(target->t);
 		}
diff --git a/xtables.c b/xtables.c
index b4c4f6b..ed082f3 100644
--- a/xtables.c
+++ b/xtables.c
@@ -114,14 +114,6 @@ struct option *xtables_merge_options(struct option *oldopts,
 	return merge;
 }
 
-void xtables_set_revision(char *name, u_int8_t revision)
-{
-	/* Old kernel sources don't have ".revision" field,
-	*            but we stole a byte from name. */
-	name[XT_FUNCTION_MAXNAMELEN - 2] = '\0';
-	name[XT_FUNCTION_MAXNAMELEN - 1] = revision;
-}
-
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")
-- 
1.7.1

