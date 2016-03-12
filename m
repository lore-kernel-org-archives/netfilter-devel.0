From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCH] extensions: libipt_REJECT: Avoid to print the default reject
 with value in the translation
Date: Sat, 12 Mar 2016 18:29:32 +0100
Message-ID: <20160312172929.GA15987@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37139 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883AbcCLR3h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 12:29:37 -0500
Received: by mail-wm0-f50.google.com with SMTP id p65so53903088wmp.0
        for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 09:29:36 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Avoid to print the reject with value in the translation when the value is the default.

Before this patch:

$ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
nft add rule ip filter FORWARD tcp dport 22 counter reject with icmp type port-unreachable

After this patch:

$ sudo iptables-translate -A FORWARD -p TCP --dport 22 -j REJECT
nft add rule ip filter FORWARD tcp dport 22 counter reject

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 extensions/libipt_REJECT.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 4148776..0e9b7d7 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -17,6 +17,8 @@
 #define IPT_ICMP_ADMIN_PROHIBITED	IPT_TCP_RESET + 1
 #endif
 
+#define DEFAULT_REJECT_WITH	IPT_ICMP_PORT_UNREACHABLE
+
 struct reject_names {
 	const char *name;
 	const char *alias;
@@ -92,7 +94,7 @@ static void REJECT_init(struct xt_entry_target *t)
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)t->data;
 
 	/* default */
-	reject->with = IPT_ICMP_PORT_UNREACHABLE;
+	reject->with = DEFAULT_REJECT_WITH;
 
 }
 
@@ -171,7 +173,9 @@ static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
 			break;
 	}
 
-	if (reject->with == IPT_TCP_RESET)
+	if (reject->with == DEFAULT_REJECT_WITH)
+		xt_xlate_add(xl, "reject");
+	else if (reject->with == IPT_TCP_RESET)
 		xt_xlate_add(xl, "reject with %s",
 			   reject_table_xlate[i].name);
 	else
-- 
2.7.0

