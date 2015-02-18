From: Eric B Munson <emunson@akamai.com>
Subject: [PATCH RESEND] Add element count to hash headers
Date: Wed, 18 Feb 2015 14:53:28 -0500
Message-ID: <1424289208-6164-1-git-send-email-emunson@akamai.com>
Cc: Eric B Munson <emunson@akamai.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Josh Hunt <johunt@akamai.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay02.akamai.com ([72.246.2.14]:38501 "EHLO
	prod-mail-xrelay02.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055AbbBRTxc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 14:53:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It would be useful for userspace to query the size of an ipset hash,
however, this data is not exposed to userspace outside of counting the
number of member entries.  This patch uses the attribute
IPSET_ATTR_ELEMENTS to indicate the size in the the header that is
exported to userspace.  This field is then printed by the userspace
tool for hashes.

Because it is only meaningful for hashes to report their size, the
output is conditional on the set type.  To do this checking the
MATCH_TYPENAME macro was moved to utils.h.

Signed-off-by: Eric B Munson <emunson@akamai.com>
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Josh Hunt <johunt@akamai.com>
---
 include/libipset/utils.h                     |  3 +++
 kernel/net/netfilter/ipset/ip_set_hash_gen.h |  3 ++-
 lib/errcode.c                                |  2 --
 lib/session.c                                | 14 ++++++++++++--
 4 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/include/libipset/utils.h b/include/libipset/utils.h
index 3cd29da..ceedd45 100644
--- a/include/libipset/utils.h
+++ b/include/libipset/utils.h
@@ -19,6 +19,9 @@
 #define STRCASEQ(a, b)		(strcasecmp(a, b) == 0)
 #define STRNCASEQ(a, b, n)	(strncasecmp(a, b, n) == 0)
 
+/* Match set type names */
+#define MATCH_TYPENAME(a, b)    STRNEQ(a, b, strlen(b))
+
 /* Stringify tokens */
 #define _STR(c)			#c
 #define STR(c)			_STR(c)
diff --git a/kernel/net/netfilter/ipset/ip_set_hash_gen.h b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
index 885105b..2000a20 100644
--- a/kernel/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/kernel/net/netfilter/ipset/ip_set_hash_gen.h
@@ -1040,7 +1040,8 @@ mtype_head(struct ip_set *set, struct sk_buff *skb)
 		goto nla_put_failure;
 #endif
 	if (nla_put_net32(skb, IPSET_ATTR_REFERENCES, htonl(set->ref - 1)) ||
-	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)))
+	    nla_put_net32(skb, IPSET_ATTR_MEMSIZE, htonl(memsize)) ||
+	    nla_put_net32(skb, IPSET_ATTR_ELEMENTS, htonl(h->elements)))
 		goto nla_put_failure;
 	if (unlikely(ip_set_put_flags(skb, set)))
 		goto nla_put_failure;
diff --git a/lib/errcode.c b/lib/errcode.c
index 8eb275b..3881121 100644
--- a/lib/errcode.c
+++ b/lib/errcode.c
@@ -148,8 +148,6 @@ static const struct ipset_errcode_table list_errcode_table[] = {
 	{ },
 };
 
-#define MATCH_TYPENAME(a, b)	STRNEQ(a, b, strlen(b))
-
 /**
  * ipset_errcode - interpret a kernel error code
  * @session: session structure
diff --git a/lib/session.c b/lib/session.c
index 013d9d8..07f3396 100644
--- a/lib/session.c
+++ b/lib/session.c
@@ -931,6 +931,10 @@ list_create(struct ipset_session *session, struct nlattr *nla[])
 		safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE);
 		safe_snprintf(session, "\nReferences: ");
 		safe_dprintf(session, ipset_print_number, IPSET_OPT_REFERENCES);
+		if (MATCH_TYPENAME(type->name , "hash:")) {
+			safe_snprintf(session, "\nNum Entries: ");
+			safe_dprintf(session, ipset_print_number, IPSET_OPT_ELEMENTS);
+		}
 		safe_snprintf(session,
 			session->envopts & IPSET_ENV_LIST_HEADER ?
 			"\n" : "\nMembers:\n");
@@ -940,10 +944,16 @@ list_create(struct ipset_session *session, struct nlattr *nla[])
 		safe_dprintf(session, ipset_print_number, IPSET_OPT_MEMSIZE);
 		safe_snprintf(session, "</memsize>\n<references>");
 		safe_dprintf(session, ipset_print_number, IPSET_OPT_REFERENCES);
+		safe_snprintf(session, "</references>\n");
+		if (MATCH_TYPENAME(type->name , "hash:")) {
+			safe_snprintf(session, "<numentries>");
+			safe_dprintf(session, ipset_print_number, IPSET_OPT_ELEMENTS);
+			safe_snprintf(session, "</numentries>\n");
+		}
 		safe_snprintf(session,
 			session->envopts & IPSET_ENV_LIST_HEADER ?
-			"</references>\n</header>\n" :
-			"</references>\n</header>\n<members>\n");
+			"</header>\n" :
+			"</header>\n<members>\n");
 		break;
 	default:
 		break;
-- 
1.9.1

