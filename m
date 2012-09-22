From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Bug in limit_mt_check()
Date: Sat, 22 Sep 2012 10:13:58 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr>
References: <505CE985.7000907@infoblox.com> <alpine.LNX.2.01.1209220509060.31062@nerf07.vanv.qr> <alpine.LNX.2.01.1209220957510.3512@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Jim Robinson <jrobinson@infoblox.com>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:32848 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab2IVIN7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Sep 2012 04:13:59 -0400
In-Reply-To: <alpine.LNX.2.01.1209220957510.3512@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>On Saturday 2012-09-22 00:26, Jim Robinson wrote:
>>
>>The bug is that under reproducible conditions, it is possible for
>>limit_mt_check() to execute and kmalloc() a structure which does not
>>get initialized. Specifically, if 'r->cost' is non-zero, 'priv' is
>>kmalloc()ed but not initialized. The result of this is that
>>'priv->prev' and 'priv->credit' have bad values in them
>>
>>--8<-- (Jim's patch)
>Without this patch the allocated 'priv' structure could be used without initializing. This
>was causing premature rate-limit matches (i.e. limit_mt() returning 'true' when it shouldn't
>have). This patch is a best guess as to how to initialize 'priv', and seems to work.
>
>diff -Nur linux-2.6.32.8/net/netfilter/xt_limit.c.ORIG linux-2.6.32.8/net/netfilter/xt_limit.c
>--- linux-2.6.32.8/net/netfilter/xt_limit.c.ORIG	2012-09-12 17:14:19.758371942 -0700
>+++ linux-2.6.32.8/net/netfilter/xt_limit.c	2012-09-19 12:09:00.238416282 -0700
>@@ -114,6 +114,32 @@
> 	if (priv == NULL)
> 		return false;
> 
>+    // Start of Infoblox patch.
>+    // Zero out 'priv' for good measure.
>+    memset(priv, 0, sizeof(*priv));
>+    // This seems to fix the problem of priv not being initialized when
>+    // r->cost is non-zero.
>+    if (r->cost != 0) {
>+        // Note that non-zero r->cost seems to imply non-null
>+        // r->master, however, better safe than sorry, so check r->master.
>+        if (r->master != NULL) {

r->master does not have any sensical value when it's coming from userspace.

>+            spin_lock_bh(&limit_lock);
>+            priv->prev = r->master->prev;
>+            priv->credit = r->master->credit;
>+            spin_unlock_bh(&limit_lock);
>+        } else {
>+            // Not sure if this can ever happen. And definitely not sure
>+            // if this is the right thing to do, however, priv needs to be
>+            // initialized to something.
>+            printk("limit_mt_check: unexpected non-zero cost and null master\n");
>+            priv->prev = jiffies;
>+            priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
>+        }
>+        r->master = priv;
>+        return true;
>+    }
>+    // End of Infoblox patch.
>+
> 	/* For SMP, we only want to use one set of state. */
> 	r->master = priv;
> 	if (r->cost == 0) {

A patch I think is better comes as reply to this message.
