From: Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net] netfilter: ipt_rpfilter: remove the nh_scope test in rpfilter_lookup_reverse
Date: Tue,  6 Oct 2015 21:03:07 +0800
Message-ID: <e4382c194620c20c80991d4a32618266da4c71df.1444136587.git.lucien.xin@gmail.com>
Cc: fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:35153 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbbJFNDM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Oct 2015 09:03:12 -0400
Received: by pacfv12 with SMTP id fv12so214485559pac.2
        for <netfilter-devel@vger.kernel.org>; Tue, 06 Oct 2015 06:03:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--accept-local  option works for res.type == RTN_LOCAL, which should be from
the local table, but there, the fib_info's nh->nh_scope = RT_SCOPE_NOWHERE
( > RT_SCOPE_HOST). in fib_create_info().

	if (cfg->fc_scope == RT_SCOPE_HOST) {
		struct fib_nh *nh = fi->fib_nh;

		/* Local address is added. */
		if (nhs != 1 || nh->nh_gw)
			goto err_inval;
		nh->nh_scope = RT_SCOPE_NOWHERE;   <===
		nh->nh_dev = dev_get_by_index(net, fi->fib_nh->nh_oif);
		err = -ENODEV;
		if (!nh->nh_dev)
			goto failure;

but in our rpfilter_lookup_reverse():

	if (dev_match || flags & XT_RPFILTER_LOOSE)
		return FIB_RES_NH(res).nh_scope <= RT_SCOPE_HOST;

if nh->nh_scope > RT_SCOPE_HOST, it will fail. --accept-local option will never
be passed.

it seems the test is bogus and can be removed to fix this issue.

	if (dev_match || flags & XT_RPFILTER_LOOSE)
		return FIB_RES_NH(res).nh_scope <= RT_SCOPE_HOST;

ipv6 does not have this issue.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/netfilter/ipt_rpfilter.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_rpfilter.c b/net/ipv4/netfilter/ipt_rpfilter.c
index 8618fd1..c4ffc9d 100644
--- a/net/ipv4/netfilter/ipt_rpfilter.c
+++ b/net/ipv4/netfilter/ipt_rpfilter.c
@@ -61,9 +61,7 @@ static bool rpfilter_lookup_reverse(struct flowi4 *fl4,
 	if (FIB_RES_DEV(res) == dev)
 		dev_match = true;
 #endif
-	if (dev_match || flags & XT_RPFILTER_LOOSE)
-		return FIB_RES_NH(res).nh_scope <= RT_SCOPE_HOST;
-	return dev_match;
+	return dev_match || flags & XT_RPFILTER_LOOSE;
 }
 
 static bool rpfilter_is_local(const struct sk_buff *skb)
-- 
2.1.0

