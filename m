From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/5] meta: use if_nametoindex and if_indextoname
Date: Fri, 21 Jun 2013 16:42:17 +0200
Message-ID: <1371825739-3669-3-git-send-email-pablo@netfilter.org>
References: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, eric@regit.org, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41717 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161506Ab3FUOm3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 21 Jun 2013 10:42:29 -0400
In-Reply-To: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Instead of having a cache of ifindex based on libnl. Those functions
basically use rtnetlink as well to perform the translation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/meta.c |   48 ++++--------------------------------------------
 1 file changed, 4 insertions(+), 44 deletions(-)

diff --git a/src/meta.c b/src/meta.c
index 54d4d64..c5719b9 100644
--- a/src/meta.c
+++ b/src/meta.c
@@ -14,6 +14,7 @@
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdint.h>
+#include <net/if.h>
 #include <net/if_arp.h>
 #include <pwd.h>
 #include <grp.h>
@@ -96,43 +97,13 @@ static const struct datatype tchandle_type = {
 	.parse		= tchandle_type_parse,
 };
 
-static struct nl_cache *link_cache;
-
-static int link_cache_init(void)
-{
-	struct nl_sock *rt_sock;
-	int err;
-
-	rt_sock = nl_socket_alloc();
-	if (rt_sock == NULL)
-		memory_allocation_error();
-
-	err = nl_connect(rt_sock, NETLINK_ROUTE);
-	if (err < 0)
-		goto err;
-	err = rtnl_link_alloc_cache(rt_sock, &link_cache);
-	if (err < 0)
-		goto err;
-	nl_cache_mngt_provide(link_cache);
-	nl_socket_free(rt_sock);
-	return 0;
-
-err:
-	nl_socket_free(rt_sock);
-	return err;
-}
-
 static void ifindex_type_print(const struct expr *expr)
 {
 	char name[IFNAMSIZ];
 	int ifindex;
 
-	if (link_cache == NULL)
-		link_cache_init();
-
 	ifindex = mpz_get_uint32(expr->value);
-	if (link_cache != NULL &&
-	    rtnl_link_i2name(link_cache, ifindex, name, sizeof(name)))
+	if (if_indextoname(ifindex, name))
 		printf("%s", name);
 	else
 		printf("%d", ifindex);
@@ -141,15 +112,9 @@ static void ifindex_type_print(const struct expr *expr)
 static struct error_record *ifindex_type_parse(const struct expr *sym,
 					       struct expr **res)
 {
-	int ifindex, err;
-
-	if (link_cache == NULL &&
-	    (err = link_cache_init()) < 0)
-		return error(&sym->location,
-			     "Could not initialize link cache: %s",
-			     nl_geterror(err));
+	int ifindex;
 
-	ifindex = rtnl_link_name2i(link_cache, sym->identifier);
+	ifindex = if_nametoindex(sym->identifier);
 	if (ifindex == 0)
 		return error(&sym->location, "Interface does not exist");
 
@@ -159,11 +124,6 @@ static struct error_record *ifindex_type_parse(const struct expr *sym,
 	return NULL;
 }
 
-static void __exit ifindex_table_free(void)
-{
-	nl_cache_free(link_cache);
-}
-
 static const struct datatype ifindex_type = {
 	.type		= TYPE_IFINDEX,
 	.name		= "ifindex",
-- 
1.7.10.4

