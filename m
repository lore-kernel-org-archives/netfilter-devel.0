From: pablo@netfilter.org
Subject: [PATCH 1/2] libxtables: add xtables_ip[6]mask_to_cidr
Date: Wed, 11 Jul 2012 01:17:26 +0200
Message-ID: <1341962247-16217-2-git-send-email-pablo@netfilter.org>
References: <1341962247-16217-1-git-send-email-pablo@netfilter.org>
Cc: Hans Schillstrom <hans@schillstrom.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51048 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931Ab2GJXS0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:18:26 -0400
In-Reply-To: <1341962247-16217-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds generic functions to return the mask in CIDR
notation whenever is possible.

This patch also simplifies xtables_ip[6]mask_to_numeric, that
now use these new two functions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/xtables.h.in |    2 ++
 libxtables/xtables.c |   33 ++++++++++++++++++++++++---------
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/include/xtables.h.in b/include/xtables.h.in
index 28e2933..db69c03 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -442,6 +442,7 @@ extern const char *xtables_ipaddr_to_anyname(const struct in_addr *);
 extern const char *xtables_ipmask_to_numeric(const struct in_addr *);
 extern struct in_addr *xtables_numeric_to_ipaddr(const char *);
 extern struct in_addr *xtables_numeric_to_ipmask(const char *);
+extern int xtables_ipmask_to_cidr(const struct in_addr *);
 extern void xtables_ipparse_any(const char *, struct in_addr **,
 	struct in_addr *, unsigned int *);
 extern void xtables_ipparse_multiple(const char *, struct in_addr **,
@@ -451,6 +452,7 @@ extern struct in6_addr *xtables_numeric_to_ip6addr(const char *);
 extern const char *xtables_ip6addr_to_numeric(const struct in6_addr *);
 extern const char *xtables_ip6addr_to_anyname(const struct in6_addr *);
 extern const char *xtables_ip6mask_to_numeric(const struct in6_addr *);
+extern int xtables_ip6mask_to_cidr(const struct in6_addr *);
 extern void xtables_ip6parse_any(const char *, struct in6_addr **,
 	struct in6_addr *, unsigned int *);
 extern void xtables_ip6parse_multiple(const char *, struct in6_addr **,
diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index 014e115..d818579 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -1133,28 +1133,43 @@ const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
 	return xtables_ipaddr_to_numeric(addr);
 }
 
-const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
+int xtables_ipmask_to_cidr(const struct in_addr *mask)
 {
-	static char buf[20];
 	uint32_t maskaddr, bits;
 	int i;
 
 	maskaddr = ntohl(mask->s_addr);
-
+	/* shortcut for /32 networks */
 	if (maskaddr == 0xFFFFFFFFL)
-		/* we don't want to see "/32" */
-		return "";
+		return 32;
 
 	i = 32;
 	bits = 0xFFFFFFFEL;
 	while (--i >= 0 && maskaddr != bits)
 		bits <<= 1;
 	if (i >= 0)
-		sprintf(buf, "/%d", i);
-	else
+		return i;
+
+	/* this mask cannot be converted to CIDR notation */
+	return -1;
+}
+
+const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
+{
+	static char buf[20];
+	uint32_t cidr;
+
+	cidr = xtables_ipmask_to_cidr(mask);
+	if (cidr < 0) {
 		/* mask was not a decent combination of 1's and 0's */
 		sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
+		return buf;
+	} else if (cidr == 32) {
+		/* we don't want to see "/32" */
+		return "";
+	}
 
+	sprintf(buf, "/%d", cidr);
 	return buf;
 }
 
@@ -1465,7 +1480,7 @@ const char *xtables_ip6addr_to_anyname(const struct in6_addr *addr)
 	return xtables_ip6addr_to_numeric(addr);
 }
 
-static int ip6addr_prefix_length(const struct in6_addr *k)
+int xtables_ip6mask_to_cidr(const struct in6_addr *k)
 {
 	unsigned int bits = 0;
 	uint32_t a, b, c, d;
@@ -1492,7 +1507,7 @@ static int ip6addr_prefix_length(const struct in6_addr *k)
 const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
 {
 	static char buf[50+2];
-	int l = ip6addr_prefix_length(addrp);
+	int l = xtables_ip6mask_to_cidr(addrp);
 
 	if (l == -1) {
 		strcpy(buf, "/");
-- 
1.7.10

