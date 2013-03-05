From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/5] libxtables: centralize checking for a .save function
Date: Tue,  5 Mar 2013 02:08:11 +0100
Message-ID: <1362445695-15952-2-git-send-email-jengelh@inai.de>
References: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45713 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758935Ab3CEBIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 20:08:17 -0500
In-Reply-To: <1362445695-15952-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Both iptables.c and ip6tables.c check for target->save == NULL, which
can be consolidated. In fact, we should also check for match->save ==
NULL, which this patch addds to libxtables.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 extensions/libxt_standard.c |   14 ++++++++++++++
 iptables/ip6tables.c        |   12 ------------
 iptables/iptables.c         |   12 ------------
 libxtables/xtables.c        |   21 +++++++++++++++++++++
 4 files changed, 35 insertions(+), 24 deletions(-)

diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index c64ba29..601e709 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -9,12 +9,26 @@ static void standard_help(void)
 "(If target is DROP, ACCEPT, RETURN or nothing)\n");
 }
 
+static void standard_save(const void *ip, const struct xt_entry_target *t)
+{
+	/*
+	 * This function left blank intentionally - it only serves to make
+	 * iptables not exit with "target lacks a save function". The
+	 * "standard" target is special, since we do not emit -j standard, but
+	 * -j <verdict>. This is printed by iptables.c's function
+	 * print_rule4(), which ultimately calls TC_GET_TARGET in
+	 * libiptc/libiptc.c that will emit the verdict name based upon data in
+	 * the parameter block (@t->data in this "standard_save" function).
+	 */
+}
+
 static struct xtables_target standard_target = {
 	.family		= NFPROTO_UNSPEC,
 	.name		= "standard",
 	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
+	.save		= standard_save,
 	.help		= standard_help,
 };
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 4cfbea3..aeeb62a 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1106,18 +1106,6 @@ void print_rule6(const struct ip6t_entry *e,
 		printf(" -j %s", target->alias ? target->alias(t) : target_name);
 		if (target->save)
 			target->save(&e->ipv6, t);
-		else {
-			/* If the target size is greater than xt_entry_target
-			 * there is something to be saved, we just don't know
-			 * how to print it */
-			if (t->u.target_size !=
-			    sizeof(struct xt_entry_target)) {
-				fprintf(stderr, "Target `%s' is missing "
-						"save function\n",
-					t->u.user.name);
-				exit(1);
-			}
-		}
 	} else if (target_name && (*target_name != '\0'))
 #ifdef IP6T_F_GOTO
 		printf(" -%c %s", e->ipv6.flags & IP6T_F_GOTO ? 'g' : 'j', target_name);
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 085eea1..27bd5b4 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1097,18 +1097,6 @@ void print_rule4(const struct ipt_entry *e,
 		printf(" -j %s", target->alias ? target->alias(t) : target_name);
 		if (target->save)
 			target->save(&e->ip, t);
-		else {
-			/* If the target size is greater than xt_entry_target
-			 * there is something to be saved, we just don't know
-			 * how to print it */
-			if (t->u.target_size !=
-			    sizeof(struct xt_entry_target)) {
-				fprintf(stderr, "Target `%s' is missing "
-						"save function\n",
-					t->u.user.name);
-				exit(1);
-			}
-		}
 	} else if (target_name && (*target_name != '\0'))
 #ifdef IPT_F_GOTO
 		printf(" -%c %s", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 009ab91..b81013a 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -852,6 +852,16 @@ void xtables_register_match(struct xtables_match *me)
 		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts != NULL)
 		xtables_check_options(me->name, me->extra_opts);
+	if (me->userspacesize > 0 && me->save == NULL &&
+	    me->real_name == NULL) {
+		/*
+		 * Catch extensions that have data to be saved, but which
+		 * forgot to define a save method.
+		 */
+		fprintf(stderr, "Match \"%s\" is missing a save function\n",
+		        me->name);
+		exit(1);
+	}
 
 	/* ignore not interested match */
 	if (me->family != afinfo->family && me->family != AF_UNSPEC)
@@ -1010,6 +1020,17 @@ void xtables_register_target(struct xtables_target *me)
 		xtables_option_metavalidate(me->name, me->x6_options);
 	if (me->extra_opts != NULL)
 		xtables_check_options(me->name, me->extra_opts);
+	if (me->userspacesize > 0 && me->save == NULL &&
+	    me->real_name == NULL) {
+		/*
+		 * Catch extensions that have data to be saved, but which
+		 * forgot to define a save method. This only applies to true
+		 * modules (real_name==NULL), not aliases.
+		 */
+		fprintf(stderr, "Target \"%s\" is missing a save function\n",
+		        me->name);
+		exit(1);
+	}
 
 	/* ignore not interested target */
 	if (me->family != afinfo->family && me->family != AF_UNSPEC)
-- 
1.7.10.4

