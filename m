From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libip6t_REJECT: Avoid to print the default
 reject with value in the translation
Date: Sat, 12 Mar 2016 18:31:31 +0100
Message-ID: <20160312173128.GA16044@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36428 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbcCLRbf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 12:31:35 -0500
Received: by mail-wm0-f41.google.com with SMTP id n186so56777700wmn.1
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 09:31:35 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid to print the reject with value in the translation when the value
is the default.

Before this patch:

$ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
nft add rule ip6 filter FORWARD tcp dport 22 counter reject with icmpv6 type port-unreachable

After this patch:

$ sudo ip6tables-translate -A FORWARD -p TCP --dport 22 -j REJECT
nft add rule ip6 filter FORWARD tcp dport 22 counter reject

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libip6t_REJECT.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index c30f292..d54c3b2 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -10,6 +10,8 @@
 #include <xtables.h>
 #include <linux/netfilter_ipv6/ip6t_REJECT.h>
 
+#define DEFAULT_REJECT_WITH	IP6T_ICMP6_PORT_UNREACH
+
 struct reject_names {
 	const char *name;
 	const char *alias;
@@ -81,7 +83,7 @@ static void REJECT_init(struct xt_entry_target *t)
 	struct ip6t_reject_info *reject = (struct ip6t_reject_info *)t->data;
 
 	/* default */
-	reject->with = IP6T_ICMP6_PORT_UNREACH;
+	reject->with = DEFAULT_REJECT_WITH;
 
 }
 
@@ -149,7 +151,10 @@ static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
 	for (i = 0; i < ARRAY_SIZE(reject_table_xlate); ++i)
 		if (reject_table_xlate[i].with == reject->with)
 			break;
-	if (reject->with == IP6T_TCP_RESET)
+
+	if (reject->with == DEFAULT_REJECT_WITH)
+		xt_xlate_add(xl, "reject");
+	else if (reject->with == IP6T_TCP_RESET)
 		xt_xlate_add(xl, "reject with %s", reject_table_xlate[i].name);
 	else
 		xt_xlate_add(xl, "reject with icmpv6 type %s",
-- 
2.7.0

