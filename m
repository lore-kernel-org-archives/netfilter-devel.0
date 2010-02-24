From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH] nfnetlink_log: fix silly refcount leak
Date: Wed, 24 Feb 2010 21:18:47 +0200
Message-ID: <20100224191847.GA3390@core2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:57372 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757609Ab0BXTSy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:18:54 -0500
Received: by fg-out-1718.google.com with SMTP id e12so451817fga.1
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Feb 2010 11:18:53 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Quick fix for memory/module refcount leak.
Reference count of listener instance never reaches 0.

Start/stop of ulogd2 is enough to trigger this bug!

Now, refcounting there looks very fishy in particular this code:

 	if (!try_module_get(THIS_MODULE)) {
		...

and creation of listener instance with refcount 2,
so it may very well be ripped and redone. :-)

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/netfilter/nfnetlink_log.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -784,7 +784,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			}
 
 			instance_destroy(inst);
-			goto out;
+			goto out_put;
 		default:
 			ret = -ENOTSUPP;
 			break;
