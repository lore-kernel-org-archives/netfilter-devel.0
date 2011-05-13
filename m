From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/12] src: replace old IP*T_ALIGN macros
Date: Fri, 13 May 2011 02:47:25 +0200
Message-ID: <1305247657-29158-2-git-send-email-jengelh@medozas.de>
References: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35624 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758367Ab1EMAtO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 May 2011 20:49:14 -0400
In-Reply-To: <1305247657-29158-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libiptc/libip6tc.h |    5 -----
 include/libiptc/libiptc.h  |    9 ---------
 ip6tables.c                |   16 ++++++++--------
 iptables.c                 |   16 ++++++++--------
 libiptc/libip4tc.c         |    4 ++--
 libiptc/libip6tc.c         |    4 ++--
 6 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 9796574..4f2d1f8 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -11,11 +11,6 @@
 #endif
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
-#ifndef IP6T_MIN_ALIGN
-#define IP6T_MIN_ALIGN (__alignof__(struct ip6t_entry))
-#endif
-#define IP6T_ALIGN(s) (((s) + (IP6T_MIN_ALIGN-1)) & ~(IP6T_MIN_ALIGN-1))
-
 struct ip6tc_handle;
 
 typedef char ip6t_chainlabel[32];
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 4355ac9..3497d6a 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -15,15 +15,6 @@
 extern "C" {
 #endif
 
-#ifndef IPT_MIN_ALIGN
-/* ipt_entry has pointers and u_int64_t's in it, so if you align to
-   it, you'll also align to any crazy matches and targets someone
-   might write */
-#define IPT_MIN_ALIGN (__alignof__(struct ipt_entry))
-#endif
-
-#define IPT_ALIGN(s) (((s) + ((IPT_MIN_ALIGN)-1)) & ~((IPT_MIN_ALIGN)-1))
-
 struct iptc_handle;
 
 typedef char ipt_chainlabel[32];
diff --git a/ip6tables.c b/ip6tables.c
index 967a5f8..58c7e2d 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -768,10 +768,10 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	size = sizeof(struct ip6t_entry);
 	for (matchp = matches; matchp; matchp = matchp->next)
-		size += IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
+		size += XT_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
 
 	mask = xtables_calloc(1, size
-			 + IP6T_ALIGN(sizeof(struct ip6t_entry_target))
+			 + XT_ALIGN(sizeof(struct ip6t_entry_target))
 			 + target->size);
 
 	memset(mask, 0xFF, sizeof(struct ip6t_entry));
@@ -779,13 +779,13 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	for (matchp = matches; matchp; matchp = matchp->next) {
 		memset(mptr, 0xFF,
-		       IP6T_ALIGN(sizeof(struct ip6t_entry_match))
+		       XT_ALIGN(sizeof(struct ip6t_entry_match))
 		       + matchp->match->userspacesize);
-		mptr += IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
+		mptr += XT_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
 	}
 
 	memset(mptr, 0xFF,
-	       IP6T_ALIGN(sizeof(struct ip6t_entry_target))
+	       XT_ALIGN(sizeof(struct ip6t_entry_target))
 	       + target->userspacesize);
 
 	return mask;
@@ -1306,7 +1306,7 @@ static void command_default(struct iptables_command_state *cs)
 
 		cs->proto_used = 1;
 
-		size = IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
+		size = XT_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
 
 		m->m = xtables_calloc(1, size);
 		m->m->u.match_size = size;
@@ -1351,7 +1351,7 @@ static void command_jump(struct iptables_command_state *cs)
 	if (cs->target == NULL)
 		return;
 
-	size = IP6T_ALIGN(sizeof(struct ip6t_entry_target)) + cs->target->size;
+	size = XT_ALIGN(sizeof(struct ip6t_entry_target)) + cs->target->size;
 
 	cs->target->t = xtables_calloc(1, size);
 	cs->target->t->u.target_size = size;
@@ -1381,7 +1381,7 @@ static void command_match(struct iptables_command_state *cs)
 			   "unexpected ! flag before --match");
 
 	m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED, &cs->matches);
-	size = IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
+	size = XT_ALIGN(sizeof(struct ip6t_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
 	strcpy(m->m->u.user.name, m->name);
diff --git a/iptables.c b/iptables.c
index cc7525a..d01e828 100644
--- a/iptables.c
+++ b/iptables.c
@@ -771,10 +771,10 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	size = sizeof(struct ipt_entry);
 	for (matchp = matches; matchp; matchp = matchp->next)
-		size += IPT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
+		size += XT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
 
 	mask = xtables_calloc(1, size
-			 + IPT_ALIGN(sizeof(struct ipt_entry_target))
+			 + XT_ALIGN(sizeof(struct ipt_entry_target))
 			 + target->size);
 
 	memset(mask, 0xFF, sizeof(struct ipt_entry));
@@ -782,13 +782,13 @@ make_delete_mask(const struct xtables_rule_match *matches,
 
 	for (matchp = matches; matchp; matchp = matchp->next) {
 		memset(mptr, 0xFF,
-		       IPT_ALIGN(sizeof(struct ipt_entry_match))
+		       XT_ALIGN(sizeof(struct ipt_entry_match))
 		       + matchp->match->userspacesize);
-		mptr += IPT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
+		mptr += XT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
 	}
 
 	memset(mptr, 0xFF,
-	       IPT_ALIGN(sizeof(struct ipt_entry_target))
+	       XT_ALIGN(sizeof(struct ipt_entry_target))
 	       + target->userspacesize);
 
 	return mask;
@@ -1330,7 +1330,7 @@ static void command_default(struct iptables_command_state *cs)
 
 		cs->proto_used = 1;
 
-		size = IPT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
+		size = XT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
 
 		m->m = xtables_calloc(1, size);
 		m->m->u.match_size = size;
@@ -1376,7 +1376,7 @@ static void command_jump(struct iptables_command_state *cs)
 	if (cs->target == NULL)
 		return;
 
-	size = IPT_ALIGN(sizeof(struct ipt_entry_target))
+	size = XT_ALIGN(sizeof(struct ipt_entry_target))
 		+ cs->target->size;
 
 	cs->target->t = xtables_calloc(1, size);
@@ -1407,7 +1407,7 @@ static void command_match(struct iptables_command_state *cs)
 			   "unexpected ! flag before --match");
 
 	m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED, &cs->matches);
-	size = IPT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
+	size = XT_ALIGN(sizeof(struct ipt_entry_match)) + m->size;
 	m->m = xtables_calloc(1, size);
 	m->m->u.match_size = size;
 	strcpy(m->m->u.user.name, m->name);
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index e2d2a5e..cf66709 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -112,7 +112,7 @@ typedef unsigned int socklen_t;
 #define LABEL_DROP		IPTC_LABEL_DROP
 #define LABEL_QUEUE		IPTC_LABEL_QUEUE
 
-#define ALIGN			IPT_ALIGN
+#define ALIGN			XT_ALIGN
 #define RETURN			IPT_RETURN
 
 #include "libiptc.c"
@@ -209,7 +209,7 @@ is_same(const STRUCT_ENTRY *a, const STRUCT_ENTRY *b, unsigned char *matchmask)
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IPT_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
-	mptr += IPT_ALIGN(sizeof(struct ipt_entry_target));
+	mptr += XT_ALIGN(sizeof(struct ipt_entry_target));
 
 	return mptr;
 }
diff --git a/libiptc/libip6tc.c b/libiptc/libip6tc.c
index c1508cd..0f8a889 100644
--- a/libiptc/libip6tc.c
+++ b/libiptc/libip6tc.c
@@ -107,7 +107,7 @@ typedef unsigned int socklen_t;
 #define LABEL_DROP		IP6TC_LABEL_DROP
 #define LABEL_QUEUE		IP6TC_LABEL_QUEUE
 
-#define ALIGN			IP6T_ALIGN
+#define ALIGN			XT_ALIGN
 #define RETURN			IP6T_RETURN
 
 #include "libiptc.c"
@@ -241,7 +241,7 @@ is_same(const STRUCT_ENTRY *a, const STRUCT_ENTRY *b,
 	mptr = matchmask + sizeof(STRUCT_ENTRY);
 	if (IP6T_MATCH_ITERATE(a, match_different, a->elems, b->elems, &mptr))
 		return NULL;
-	mptr += IP6T_ALIGN(sizeof(struct ip6t_entry_target));
+	mptr += XT_ALIGN(sizeof(struct ip6t_entry_target));
 
 	return mptr;
 }
-- 
1.7.1

