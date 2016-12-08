From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH next] iptables: on revision mismatch, do not call print/save
Date: Thu,  8 Dec 2016 17:16:41 -0500
Message-ID: <1481235401-46043-1-git-send-email-willemdebruijn.kernel@gmail.com>
Cc: pablo@netfilter.org, Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35868 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750906AbcLHWQp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2016 17:16:45 -0500
Received: by mail-qt0-f196.google.com with SMTP id n34so50492808qtb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Dec 2016 14:16:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Willem de Bruijn <willemb@google.com>

Between revisions, the layout of xtables data may change completely.
Do not interpret the data in a revision M with a module of revision N.

Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 iptables/ip6tables.c | 18 ++++++++++++++----
 iptables/iptables.c  | 18 ++++++++++++++----
 2 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index c8d34e2..0d09181 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -76,6 +76,8 @@ static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 static const char optflags[]
 = { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c'};
 
+static const char unsupported_rev[] = " [unsupported revision]";
+
 static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
@@ -487,8 +489,10 @@ print_match(const struct xt_entry_match *m,
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		if (match->print)
+		if (match->print && m->u.user.revision == match->revision)
 			match->print(ip, m, numeric);
+		else if (match->print)
+			printf("%s%s ", match->name, unsupported_rev);
 		else
 			printf("%s ", match->name);
 	} else {
@@ -614,9 +618,11 @@ print_firewall(const struct ip6t_entry *fw,
 	IP6T_MATCH_ITERATE(fw, print_match, &fw->ipv6, format & FMT_NUMERIC);
 
 	if (target) {
-		if (target->print)
+		if (target->print && t->u.user.revision == target->revision)
 			/* Print the target information. */
 			target->print(&fw->ipv6, t, format & FMT_NUMERIC);
+		else if (target->print)
+			printf(" %s%s", target->name, unsupported_rev);
 	} else if (t->u.target_size != sizeof(*t))
 		printf("[%u bytes of unknown target data] ",
 		       (unsigned int)(t->u.target_size - sizeof(*t)));
@@ -1004,8 +1010,10 @@ static int print_match_save(const struct xt_entry_match *e,
 			match->alias ? match->alias(e) : e->u.user.name);
 
 		/* some matches don't provide a save function */
-		if (match->save)
+		if (match->save && e->u.user.revision == match->revision)
 			match->save(ip, e);
+		else if (match->save)
+			printf(unsupported_rev);
 	} else {
 		if (e->u.match_size) {
 			fprintf(stderr,
@@ -1104,8 +1112,10 @@ void print_rule6(const struct ip6t_entry *e,
 		}
 
 		printf(" -j %s", target->alias ? target->alias(t) : target_name);
-		if (target->save)
+		if (target->save && t->u.user.revision == target->revision)
 			target->save(&e->ipv6, t);
+		else if (target->save)
+			printf(unsupported_rev);
 		else {
 			/* If the target size is greater than xt_entry_target
 			 * there is something to be saved, we just don't know
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 79fa37b..1bdde27 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -73,6 +73,8 @@ static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
 static const char optflags[]
 = { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'f'};
 
+static const char unsupported_rev[] = " [unsupported revision]";
+
 static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
 	{.name = "delete",        .has_arg = 1, .val = 'D'},
@@ -472,8 +474,10 @@ print_match(const struct xt_entry_match *m,
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
-		if (match->print)
+		if (match->print && m->u.user.revision == match->revision)
 			match->print(ip, m, numeric);
+		else if (match->print)
+			printf("%s%s ", match->name, unsupported_rev);
 		else
 			printf("%s ", match->name);
 	} else {
@@ -599,9 +603,11 @@ print_firewall(const struct ipt_entry *fw,
 	IPT_MATCH_ITERATE(fw, print_match, &fw->ip, format & FMT_NUMERIC);
 
 	if (target) {
-		if (target->print)
+		if (target->print && t->u.user.revision == target->revision)
 			/* Print the target information. */
 			target->print(&fw->ip, t, format & FMT_NUMERIC);
+		else if (target->print)
+			printf(" %s%s", target->name, unsupported_rev);
 	} else if (t->u.target_size != sizeof(*t))
 		printf("[%u bytes of unknown target data] ",
 		       (unsigned int)(t->u.target_size - sizeof(*t)));
@@ -995,8 +1001,10 @@ static int print_match_save(const struct xt_entry_match *e,
 			match->alias ? match->alias(e) : e->u.user.name);
 
 		/* some matches don't provide a save function */
-		if (match->save)
+		if (match->save && e->u.user.revision == match->revision)
 			match->save(ip, e);
+		else if (match->save)
+			printf(unsupported_rev);
 	} else {
 		if (e->u.match_size) {
 			fprintf(stderr,
@@ -1095,8 +1103,10 @@ void print_rule4(const struct ipt_entry *e,
 		}
 
 		printf(" -j %s", target->alias ? target->alias(t) : target_name);
-		if (target->save)
+		if (target->save && t->u.user.revision == target->revision)
 			target->save(&e->ip, t);
+		else if (target->save)
+			printf(unsupported_rev);
 		else {
 			/* If the target size is greater than xt_entry_target
 			 * there is something to be saved, we just don't know
-- 
2.8.0.rc3.226.g39d4020

