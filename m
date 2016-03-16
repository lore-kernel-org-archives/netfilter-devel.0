From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv2] extensions: libip6t_REJECT: Avoid to print the default
 reject with value in the translation
Date: Wed, 16 Mar 2016 23:17:52 +0100
Message-ID: <20160316221749.GA4613@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:34182 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934707AbcCPWSJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 18:18:09 -0400
Received: by mail-wm0-f53.google.com with SMTP id p65so1555543wmp.1
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 15:17:55 -0700 (PDT)
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
v2:
	- Remove default constant, as Pablo suggested.

 extensions/libip6t_REJECT.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index c30f292..5fa551e 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -149,7 +149,10 @@ static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
 	for (i = 0; i < ARRAY_SIZE(reject_table_xlate); ++i)
 		if (reject_table_xlate[i].with == reject->with)
 			break;
-	if (reject->with == IP6T_TCP_RESET)
+
+	if (reject->with == IP6T_ICMP6_PORT_UNREACH)
+		xt_xlate_add(xl, "reject");
+	else if (reject->with == IP6T_TCP_RESET)
 		xt_xlate_add(xl, "reject with %s", reject_table_xlate[i].name);
 	else
 		xt_xlate_add(xl, "reject with icmpv6 type %s",
-- 
2.7.0

