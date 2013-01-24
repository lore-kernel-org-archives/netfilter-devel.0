From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 6/8] iptables: fall back to using save function when print is not defined
Date: Thu, 24 Jan 2013 20:37:56 +0100
Message-ID: <1359056278-27618-7-git-send-email-jengelh@inai.de>
References: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:40475 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab3AXTiK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:38:10 -0500
In-Reply-To: <1359056278-27618-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This way we can avoid having to provide two dumping function for new
plugins.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables.c |   12 ++++++++++--
 iptables/iptables.c  |   10 ++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 371d700..aa22e52 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -487,10 +487,14 @@ print_match(const struct xt_entry_match *m,
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		if (match->print)
+		if (match->print) {
 			match->print(ip, m, numeric);
-		else
+		} else if (match->save != NULL) {
+			printf("-m %s ", match->name);
+			match->save(ip, m);
+		} else {
 			printf("%s ", match->name);
+		}
 	} else {
 		if (m->u.user.name[0])
 			printf("UNKNOWN match `%s' ", m->u.user.name);
@@ -617,6 +621,10 @@ print_firewall(const struct ip6t_entry *fw,
 		if (target->print)
 			/* Print the target information. */
 			target->print(&fw->ipv6, t, format & FMT_NUMERIC);
+		else if (target->save != NULL) {
+			printf("hi world");
+			target->save(&fw->ipv6, t);
+			}
 	} else if (t->u.target_size != sizeof(*t))
 		printf("[%u bytes of unknown target data] ",
 		       (unsigned int)(t->u.target_size - sizeof(*t)));
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 6e5250e..5be5e78 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -472,10 +472,14 @@ print_match(const struct xt_entry_match *m,
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		if (match->print)
+		if (match->print) {
 			match->print(ip, m, numeric);
-		else
+		} else if (match->save != NULL) {
+			printf("-m %s ", match->name);
+			match->save(ip, m);
+		} else {
 			printf("%s ", match->name);
+		}
 	} else {
 		if (m->u.user.name[0])
 			printf("UNKNOWN match `%s' ", m->u.user.name);
@@ -602,6 +606,8 @@ print_firewall(const struct ipt_entry *fw,
 		if (target->print)
 			/* Print the target information. */
 			target->print(&fw->ip, t, format & FMT_NUMERIC);
+		else if (target->save != NULL)
+			target->save(&fw->ip, t);
 	} else if (t->u.target_size != sizeof(*t))
 		printf("[%u bytes of unknown target data] ",
 		       (unsigned int)(t->u.target_size - sizeof(*t)));
-- 
1.7.10.4

