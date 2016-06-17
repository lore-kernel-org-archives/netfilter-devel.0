From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/1] extensions: NETMAP: fix iptables-save output
Date: Fri, 17 Jun 2016 14:33:37 +0200
Message-ID: <1466166817-31307-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:51166 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753126AbcFQMdU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 08:33:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

NETMAP_print is also used by its .save hook so this change
broke iptables-save output.

Revert the patch, rename NETMAP_print to __NETMAP_print and
use that as the workhorse for both xtables -L and xtables-save.

The addition of the 'to' prefix is done in the .print hook only.

Reported-by: Shivani Bhardwaj <shivanib134@gmail.com>
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Fixes: 90becf12bd5823b6d59d32d ("extensions: NETMAP: add ' to:' prefix when printing NETMAP target")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 extensions/libip6t_NETMAP.c | 15 +++++++++++----
 extensions/libipt_NETMAP.c  | 15 +++++++++++----
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/extensions/libip6t_NETMAP.c b/extensions/libip6t_NETMAP.c
index 8d2913f..579ed04 100644
--- a/extensions/libip6t_NETMAP.c
+++ b/extensions/libip6t_NETMAP.c
@@ -49,8 +49,8 @@ static void NETMAP_parse(struct xt_option_call *cb)
 	}
 }
 
-static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
-                         int numeric)
+static void __NETMAP_print(const void *ip, const struct xt_entry_target *target,
+                           int numeric)
 {
 	const struct nf_nat_range *r = (const void *)target->data;
 	struct in6_addr a;
@@ -58,7 +58,7 @@ static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
 	int bits;
 
 	a = r->min_addr.in6;
-	printf(" to:%s", xtables_ip6addr_to_numeric(&a));
+	printf("%s", xtables_ip6addr_to_numeric(&a));
 	for (i = 0; i < 4; i++)
 		a.s6_addr32[i] = ~(r->min_addr.ip6[i] ^ r->max_addr.ip6[i]);
 	bits = xtables_ip6mask_to_cidr(&a);
@@ -68,10 +68,17 @@ static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
 		printf("/%d", bits);
 }
 
+static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
+                           int numeric)
+{
+	printf(" to:");
+	__NETMAP_print(ip, target, numeric);
+}
+
 static void NETMAP_save(const void *ip, const struct xt_entry_target *target)
 {
 	printf(" --%s ", NETMAP_opts[0].name);
-	NETMAP_print(ip, target, 0);
+	__NETMAP_print(ip, target, 0);
 }
 
 static struct xtables_target netmap_tg_reg = {
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 4932c96..f30615a 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -62,8 +62,8 @@ static void NETMAP_parse(struct xt_option_call *cb)
 	range->max_ip = range->min_ip | ~cb->val.hmask.ip;
 }
 
-static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
-                         int numeric)
+static void __NETMAP_print(const void *ip, const struct xt_entry_target *target,
+			   int numeric)
 {
 	const struct nf_nat_ipv4_multi_range_compat *mr = (const void *)target->data;
 	const struct nf_nat_ipv4_range *r = &mr->range[0];
@@ -71,7 +71,7 @@ static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
 	int bits;
 
 	a.s_addr = r->min_ip;
-	printf(" to:%s", xtables_ipaddr_to_numeric(&a));
+	printf("%s", xtables_ipaddr_to_numeric(&a));
 	a.s_addr = ~(r->min_ip ^ r->max_ip);
 	bits = netmask2bits(a.s_addr);
 	if (bits < 0)
@@ -80,10 +80,17 @@ static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
 		printf("/%d", bits);
 }
 
+static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
+			 int numeric)
+{
+	printf(" to:");
+	__NETMAP_print(ip, target, numeric);
+}
+
 static void NETMAP_save(const void *ip, const struct xt_entry_target *target)
 {
 	printf(" --%s ", NETMAP_opts[0].name);
-	NETMAP_print(ip, target, 0);
+	__NETMAP_print(ip, target, 0);
 }
 
 static struct xtables_target netmap_tg_reg = {
-- 
2.7.3

