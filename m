From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH iptables] extensions: libxt_limit: fix a wrong translation to nft rule
Date: Sat, 21 May 2016 18:07:16 +0800
Message-ID: <1463825236-33317-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>,
	Shivani Bhardwaj <shivanib134@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:52518 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbcEUKIP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 May 2016 06:08:15 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

The default burst value is 5 in iptables limit extension while it is 0 in
nft limit expression, if the burst value is default, it will not be
displayed when we dump the rules. But when we do translation from iptables
rules to nft rules, we should keep the limit burst value unchanged, even if
it is not displayed in iptables rules.

And now, if the limit-burst value in the iptables rule is 5 or 0, they are
all translated to nft rule without burst, this is wrong:

$ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 5
nft add rule ip filter INPUT limit rate 10/second counter
$ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 0
nft add rule ip filter INPUT limit rate 10/second burst 0 packets counter

Apply this patch, translation will become:

$ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 5
nft add rule ip filter INPUT limit rate 10/second burst 5 packets counter
$ sudo iptables-translate -A INPUT -m limit --limit 10/s --limit-burst 0
nft add rule ip filter INPUT limit rate 10/second counter

Fixes: a8dfbe3a3acb ("extensions: libxt_limit: Add translation to nft")
Cc: Shivani Bhardwaj <shivanib134@gmail.com>
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 extensions/libxt_limit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index c88d26b..6652849 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -184,7 +184,7 @@ static int limit_xlate(const void *ip, const struct xt_entry_match *match,
 
 	xt_xlate_add(xl, "limit rate");
 	print_rate_xlate(r->avg, xl);
-	if (r->burst != XT_LIMIT_BURST)
+	if (r->burst != 0)
 		xt_xlate_add(xl, "burst %u packets ", r->burst);
 
 	return 1;
-- 
2.5.5


