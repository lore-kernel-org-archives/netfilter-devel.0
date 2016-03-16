From: Laura Garcia Liebana <nevola@gmail.com>
Subject: [PATCHv2] extensions: libipt_REJECT: Avoid to print the default
 reject with value in the translation
Date: Wed, 16 Mar 2016 23:24:00 +0100
Message-ID: <20160316222358.GA5106@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: shivanib134@gmail.com, pablo@netfilter.org,
	outreachy-kernel@googlegroups.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:38547 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966519AbcCPWYF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 18:24:05 -0400
Received: by mail-wm0-f50.google.com with SMTP id l68so92428786wml.1
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 15:24:04 -0700 (PDT)
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
v2:
	- Fix default constant, as Pablo suggested.

 extensions/libipt_REJECT.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 4148776..c211da9 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -171,7 +171,9 @@ static int REJECT_xlate(const void *ip, const struct xt_entry_target *target,
 			break;
 	}
 
-	if (reject->with == IPT_TCP_RESET)
+	if (reject->with == IPT_ICMP_PORT_UNREACHABLE)
+		xt_xlate_add(xl, "reject");
+	else if (reject->with == IPT_TCP_RESET)
 		xt_xlate_add(xl, "reject with %s",
 			   reject_table_xlate[i].name);
 	else
-- 
2.7.0

