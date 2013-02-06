From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/4] iptables: fall back to using save function when print is not defined
Date: Wed,  6 Feb 2013 01:47:05 +0100
Message-ID: <1360111625-1759-5-git-send-email-jengelh@inai.de>
References: <1360111625-1759-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:58918 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070Ab3BFArJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Feb 2013 19:47:09 -0500
In-Reply-To: <1360111625-1759-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This way we can avoid having to provide two dumping function for new
plugins.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 iptables/ip6tables.c |   10 ++++++++--
 iptables/iptables.c  |   10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index aeeb62a..6a85d83 100644
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
@@ -617,6 +621,8 @@ print_firewall(const struct ip6t_entry *fw,
 		if (target->print)
 			/* Print the target information. */
 			target->print(&fw->ipv6, t, format & FMT_NUMERIC);
+		else if (target->save != NULL)
+			target->save(&fw->ipv6, t);
 	} else if (t->u.target_size != sizeof(*t))
 		printf("[%u bytes of unknown target data] ",
 		       (unsigned int)(t->u.target_size - sizeof(*t)));
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 27bd5b4..757d9d3 100644
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

