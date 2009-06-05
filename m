From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] extensions: remove redundant casts
Date: Fri,  5 Jun 2009 21:25:55 +0200
Message-ID: <1244229955-27642-4-git-send-email-jengelh@medozas.de>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35722 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbZFETZ5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2009 15:25:57 -0400
In-Reply-To: <1244229955-27642-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_realm.c    |    4 ++--
 extensions/libxt_multiport.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 0580610..c9e1760 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -86,14 +86,14 @@ static void load_realms(void)
 			continue;
 
 		/* found valid data */
-		newnm = (struct realmname*)malloc(sizeof(struct realmname));
+		newnm = malloc(sizeof(struct realmname));
 		if (newnm == NULL) {
 			perror("libipt_realm: malloc failed");
 			exit(1);
 		}
 		newnm->id = id;
 		newnm->len = nxt - cur;
-		newnm->name = (char*)malloc(newnm->len + 1);
+		newnm->name = malloc(newnm->len + 1);
 		if (newnm->name == NULL) {
 			perror("libipt_realm: malloc failed");
 			exit(1);
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index c3c8bb9..9959a20 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -215,7 +215,7 @@ static int
 multiport_parse6(int c, char **argv, int invert, unsigned int *flags,
                  const void *e, struct xt_entry_match **match)
 {
-	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
+	const struct ip6t_entry *entry = e;
 	return __multiport_parse(c, argv, invert, flags, match,
 	       entry->ipv6.proto, entry->ipv6.invflags);
 }
@@ -278,7 +278,7 @@ static int
 multiport_parse6_v1(int c, char **argv, int invert, unsigned int *flags,
                     const void *e, struct xt_entry_match **match)
 {
-	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
+	const struct ip6t_entry *entry = e;
 	return __multiport_parse_v1(c, argv, invert, flags, match,
 	       entry->ipv6.proto, entry->ipv6.invflags);
 }
@@ -358,7 +358,7 @@ static void multiport_print(const void *ip_void,
 static void multiport_print6(const void *ip_void,
                              const struct xt_entry_match *match, int numeric)
 {
-	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	const struct ip6t_ip6 *ip = ip_void;
 	__multiport_print(match, numeric, ip->proto);
 }
 
@@ -413,7 +413,7 @@ static void multiport_print_v1(const void *ip_void,
 static void multiport_print6_v1(const void *ip_void,
                                 const struct xt_entry_match *match, int numeric)
 {
-	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	const struct ip6t_ip6 *ip = ip_void;
 	__multiport_print_v1(match, numeric, ip->proto);
 }
 
@@ -456,7 +456,7 @@ static void multiport_save(const void *ip_void,
 static void multiport_save6(const void *ip_void,
                             const struct xt_entry_match *match)
 {
-	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	const struct ip6t_ip6 *ip = ip_void;
 	__multiport_save(match, ip->proto);
 }
 
@@ -505,7 +505,7 @@ static void multiport_save_v1(const void *ip_void,
 static void multiport_save6_v1(const void *ip_void,
                                const struct xt_entry_match *match)
 {
-	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	const struct ip6t_ip6 *ip = ip_void;
 	__multiport_save_v1(match, ip->proto);
 }
 
-- 
1.6.3.1

