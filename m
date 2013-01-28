From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 6/6] iptables: reword warning on using an alias
Date: Mon, 28 Jan 2013 14:59:46 +0100
Message-ID: <1359381586-11940-7-git-send-email-jengelh@inai.de>
References: <1359381586-11940-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37336 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756484Ab3A1N7t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Jan 2013 08:59:49 -0500
In-Reply-To: <1359381586-11940-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This by suggestion of Nick Edward.

References: http://marc.info/?l=netfilter&m=135829245822520&w=2
Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables.c |    9 +++++----
 iptables/iptables.c  |    9 +++++----
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index ec7818d..a8c71e2 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1223,8 +1223,8 @@ static void command_jump(struct iptables_command_state *cs)
 		strcpy(cs->target->t->u.user.name, cs->jumpto);
 	} else {
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-		fprintf(stderr, "WARNING: The %s target is obsolete. "
-		        "Use %s instead.\n",
+		fprintf(stderr, "WARNING: The %s target is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
 		        cs->jumpto, cs->target->real_name);
 	}
 	cs->target->t->u.user.revision = cs->target->revision;
@@ -1259,8 +1259,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		fprintf(stderr, "WARNING: The %s match is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
+		        m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 5be5e78..fc6fdf4 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1216,8 +1216,8 @@ static void command_jump(struct iptables_command_state *cs)
 	} else {
 		/* Alias support for userspace side */
 		strcpy(cs->target->t->u.user.name, cs->target->real_name);
-		fprintf(stderr, "WARNING: The %s target is obsolete. "
-		        "Use %s instead.\n",
+		fprintf(stderr, "WARNING: The %s target is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
 		        cs->jumpto, cs->target->real_name);
 	}
 	cs->target->t->u.user.revision = cs->target->revision;
@@ -1253,8 +1253,9 @@ static void command_match(struct iptables_command_state *cs)
 		strcpy(m->m->u.user.name, m->name);
 	} else {
 		strcpy(m->m->u.user.name, m->real_name);
-		fprintf(stderr, "WARNING: The %s match is obsolete. "
-		        "Use %s instead.\n", m->name, m->real_name);
+		fprintf(stderr, "WARNING: The %s match is obsolete and will "
+		        "eventually go away. Use %s instead.\n",
+		        m->name, m->real_name);
 	}
 	m->m->u.user.revision = m->revision;
 
-- 
1.7.10.4

