From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Introduce xtables_set_revision() and make
	iptables and ip6tables use it.
Date: Thu, 12 Feb 2009 09:43:34 -0500
Message-ID: <1234449814.3271.6.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35512 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614AbZBLOpb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 09:45:31 -0500
Received: by ewy14 with SMTP id 14so617377ewy.13
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Feb 2009 06:45:29 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 8805707deba432b3c07de57923f1b638be7db314
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Thu Feb 12 09:33:59 2009 -0500

    Introduce xtables_set_revision() and make iptables and ip6tables use
it.
    
     Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index da7ee6b..b0606ee 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -205,6 +205,7 @@ extern void *xtables_malloc(size_t);
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
+extern void xtables_set_revision(char *name, u_int8_t revision);
 void xtables_free_opts(int reset_offset, struct option *original_opts);
 
 extern struct xtables_match *xtables_find_match(const char *name,
diff --git a/ip6tables.c b/ip6tables.c
index 541c1a9..b06cf84 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1325,14 +1325,6 @@ static void clear_rule_matches(struct
ip6tables_rule_match **matches)
 	*matches = NULL;
 }
 
-static void set_revision(char *name, u_int8_t revision)
-{
-	/* Old kernel sources don't have ".revision" field,
-	   but we stole a byte from name. */
-	name[IP6T_FUNCTION_MAXNAMELEN - 2] = '\0';
-	name[IP6T_FUNCTION_MAXNAMELEN - 1] = revision;
-}
-
 int do_command6(int argc, char *argv[], char **table, struct
ip6tc_handle **handle)
 {
 	struct ip6t_entry fw, *e = NULL;
@@ -1597,7 +1589,7 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
 				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				set_revision(target->t->u.user.name,
+				xtables_set_revision(target->t->u.user.name,
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
@@ -1650,7 +1642,7 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
 			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			set_revision(m->m->u.user.name, m->revision);
+			xtables_set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
 				m->init(m->m);
 			if (m != m->next)
@@ -1797,7 +1789,7 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
 					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					set_revision(m->m->u.user.name,
+					xtables_set_revision(m->m->u.user.name,
 						     m->revision);
 					if (m->init != NULL)
 						m->init(m->m);
diff --git a/iptables.c b/iptables.c
index f8ccad7..e30ebea 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1335,14 +1335,6 @@ static void clear_rule_matches(struct
iptables_rule_match **matches)
 	*matches = NULL;
 }
 
-static void set_revision(char *name, u_int8_t revision)
-{
-	/* Old kernel sources don't have ".revision" field,
-	   but we stole a byte from name. */
-	name[IPT_FUNCTION_MAXNAMELEN - 2] = '\0';
-	name[IPT_FUNCTION_MAXNAMELEN - 1] = revision;
-}
-
 void
 get_kernel_version(void) {
 	static struct utsname uts;
@@ -1613,7 +1605,7 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
 				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				set_revision(target->t->u.user.name,
+				xtables_set_revision(target->t->u.user.name,
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
@@ -1672,7 +1664,7 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
 			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			set_revision(m->m->u.user.name, m->revision);
+			xtables_set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
 				m->init(m->m);
 			if (m != m->next) {
@@ -1826,7 +1818,7 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
 					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					set_revision(m->m->u.user.name,
+					xtables_set_revision(m->m->u.user.name,
 						     m->revision);
 					if (m->init != NULL)
 						m->init(m->m);
@@ -1987,7 +1979,7 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
 			if (!iptc_is_chain(jumpto, *handle))
-				set_revision(target->t->u.user.name,
+				xtables_set_revision(target->t->u.user.name,
 					     target->revision);
 			if (target->init != NULL)
 				target->init(target->t);
diff --git a/xtables.c b/xtables.c
index 114a393..fe3d3f9 100644
--- a/xtables.c
+++ b/xtables.c
@@ -99,6 +99,14 @@ void xtables_free_opts(int reset_offset, struct
option *original_opts)
 	}
 }
 
+void xtables_set_revision(char *name, u_int8_t revision)
+{
+	/* Old kernel sources don't have ".revision" field,
+	*            but we stole a byte from name. */
+	name[XT_FUNCTION_MAXNAMELEN - 2] = '\0';
+	name[XT_FUNCTION_MAXNAMELEN - 1] = revision;
+}
+
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")


