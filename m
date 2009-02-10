From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Introduce xtables_set_revision() and make
	iptables and ip6tables use it
Date: Tue, 10 Feb 2009 16:37:49 -0500
Message-ID: <1234301869.20903.82.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-y02HFKnTxr2a9G0kHiG/"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:29302 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755629AbZBJVjp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 16:39:45 -0500
Received: by ey-out-2122.google.com with SMTP id 25so11043eya.37
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 13:39:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-y02HFKnTxr2a9G0kHiG/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Ok, with this change i am almost 100% happy. 
The only thing i fear that may break in the future from
an API perspective now is that apps now have to do:

------
        xtables_init();
        xtables_set_nfproto(NFPROTO_IPV4);
        xtables_set_params(&tcxt_globals);
-------

As i mentioned to Jan I would like to unify that into
a simple call:

-----------
        xtables_init_all(&tcxt_globals);
----------

Then I will be more confident that we we will have peace going
forward. Please let me know if this is acceptable and i will
prepare a patch.

cheers,
jamal

--=-y02HFKnTxr2a9G0kHiG/
Content-Disposition: attachment; filename=iptv2-8
Content-Type: text/plain; name=iptv2-8; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit 56dbd3ef3207cfb0cff26db34c69e9f31d9acf06
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Tue Feb 10 16:30:14 2009 -0500

    Introduce xtables_set_revision() and make iptables and ip6tables use it.
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 609e6a6..d49fea9 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -207,7 +207,9 @@ extern void *xtables_malloc(size_t);
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
 extern int xtables_set_params(struct xtables_globals *xtp);
-void xtables_free_opts(int reset_offset);
+extern void xtables_free_opts(int reset_offset);
+extern void xtables_set_revision(char *name, u_int8_t revision);
+
 
 extern struct option *xtables_merge_options(struct option *oldopts,
 		const struct option *newopts, unsigned int *option_offset);
diff --git a/ip6tables.c b/ip6tables.c
index b1de41b..3bc29bd 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1288,14 +1288,6 @@ static void clear_rule_matches(struct ip6tables_rule_match **matches)
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
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
 	struct ip6t_entry fw, *e = NULL;
@@ -1560,7 +1552,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				set_revision(target->t->u.user.name,
+				xtables_set_revision(target->t->u.user.name,
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
@@ -1613,7 +1605,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			set_revision(m->m->u.user.name, m->revision);
+			xtables_set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
 				m->init(m->m);
 			if (m != m->next)
@@ -1760,7 +1752,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					set_revision(m->m->u.user.name,
+					xtables_set_revision(m->m->u.user.name,
 						     m->revision);
 					if (m->init != NULL)
 						m->init(m->m);
diff --git a/iptables.c b/iptables.c
index dfc1937..c5b48c4 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1296,14 +1296,6 @@ static void clear_rule_matches(struct iptables_rule_match **matches)
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
@@ -1574,7 +1566,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				target->t = xtables_calloc(1, size);
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
-				set_revision(target->t->u.user.name,
+				xtables_set_revision(target->t->u.user.name,
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
@@ -1633,7 +1625,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			m->m = xtables_calloc(1, size);
 			m->m->u.match_size = size;
 			strcpy(m->m->u.user.name, m->name);
-			set_revision(m->m->u.user.name, m->revision);
+			xtables_set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
 				m->init(m->m);
 			if (m != m->next) {
@@ -1787,7 +1779,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					m->m = xtables_calloc(1, size);
 					m->m->u.match_size = size;
 					strcpy(m->m->u.user.name, m->name);
-					set_revision(m->m->u.user.name,
+					xtables_set_revision(m->m->u.user.name,
 						     m->revision);
 					if (m->init != NULL)
 						m->init(m->m);
@@ -1948,7 +1940,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
 			if (!iptc_is_chain(jumpto, *handle))
-				set_revision(target->t->u.user.name,
+				xtables_set_revision(target->t->u.user.name,
 					     target->revision);
 			if (target->init != NULL)
 				target->init(target->t);
diff --git a/xtables.c b/xtables.c
index 805b940..48b4104 100644
--- a/xtables.c
+++ b/xtables.c
@@ -99,6 +99,8 @@ void xtables_free_opts(int reset_offset)
 	}
 }
 
+void xtables_set_revision_ipv4(char *name, u_int8_t revision);
+void xtables_set_revision_ipv6(char *name, u_int8_t revision);
 
 struct option *
 xtables_merge_options(struct option *oldopts, const struct option *newopts,
@@ -130,6 +132,22 @@ xtables_merge_options(struct option *oldopts, const struct option *newopts,
 	return merge;
 }
 
+void xtables_set_revision_ipv4(char *name, u_int8_t revision)
+{
+	/* Old kernel sources don't have ".revision" field,
+	*            but we stole a byte from name. */
+	name[IPT_FUNCTION_MAXNAMELEN - 2] = '\0';
+	name[IPT_FUNCTION_MAXNAMELEN - 1] = revision;
+}
+
+void xtables_set_revision_ipv6(char *name, u_int8_t revision)
+{
+	/* Old kernel sources don't have ".revision" field,
+	*            but we stole a byte from name. */
+	name[IP6T_FUNCTION_MAXNAMELEN - 2] = '\0';
+	name[IP6T_FUNCTION_MAXNAMELEN - 1] = revision;
+}
+
 /**
  * xtables_afinfo - protocol family dependent information
  * @kmod:		kernel module basename (e.g. "ip_tables")
@@ -138,6 +156,7 @@ xtables_merge_options(struct option *oldopts, const struct option *newopts,
  * @ipproto:		used by setsockopt (e.g. IPPROTO_IP)
  * @so_rev_match:	optname to check revision support of match
  * @so_rev_target:	optname to check revision support of target
+ * @set_revision:	callback to set revision
  */
 struct xtables_afinfo {
 	const char *kmod;
@@ -146,6 +165,7 @@ struct xtables_afinfo {
 	uint8_t ipproto;
 	int so_rev_match;
 	int so_rev_target;
+	void (*set_revision)(char *name, u_int8_t revision);
 };
 
 static const struct xtables_afinfo afinfo_ipv4 = {
@@ -155,6 +175,7 @@ static const struct xtables_afinfo afinfo_ipv4 = {
 	.ipproto       = IPPROTO_IP,
 	.so_rev_match  = IPT_SO_GET_REVISION_MATCH,
 	.so_rev_target = IPT_SO_GET_REVISION_TARGET,
+	.set_revision = xtables_set_revision_ipv4,
 };
 
 static const struct xtables_afinfo afinfo_ipv6 = {
@@ -164,6 +185,7 @@ static const struct xtables_afinfo afinfo_ipv6 = {
 	.ipproto       = IPPROTO_IPV6,
 	.so_rev_match  = IP6T_SO_GET_REVISION_MATCH,
 	.so_rev_target = IP6T_SO_GET_REVISION_TARGET,
+	.set_revision = xtables_set_revision_ipv6,
 };
 
 static const struct xtables_afinfo *afinfo;
@@ -212,6 +234,11 @@ void xtables_set_nfproto(uint8_t nfproto)
 	}
 }
 
+void xtables_set_revision(char *name, u_int8_t revision)
+{
+	afinfo->set_revision(name, revision);
+}
+
 /**
  * xtables_*alloc - wrappers that exit on failure
  */

--=-y02HFKnTxr2a9G0kHiG/--

