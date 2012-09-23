From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: have r->cost != 0 case work
Date: Sun, 23 Sep 2012 14:43:56 +0200
Message-ID: <58f14b4c-67ab-48aa-bbaf-3ce244500b93@email.android.com>
References: <alpine.LNX.2.01.1209221003280.3512@nerf07.vanv.qr> <1348302412-2811-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: jrobinson@infoblox.com
To: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57264 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505Ab2IWMoM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Sep 2012 08:44:12 -0400
In-Reply-To: <1348302412-2811-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Jan Engelhardt <jengelh@inai.de> schrieb:

>Commit v2.6.19-rc1~1272^2~41 tells us that r->cost != 0 can happen when
>a running state is saved to userspace and then reinstated from there.
>
>Make sure that priv is initialized with some values when that happens.
>
>Signed-off-by: Jan Engelhardt <jengelh@inai.de>
>---
> net/netfilter/xt_limit.c |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>
>diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
>index 5c22ce8..a4c1e45 100644
>--- a/net/netfilter/xt_limit.c
>+++ b/net/netfilter/xt_limit.c
>@@ -117,11 +117,11 @@ static int limit_mt_check(const struct
>xt_mtchk_param *par)
> 
> 	/* For SMP, we only want to use one set of state. */
> 	r->master = priv;
>+	/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
>+	   128. */
>+	priv->prev = jiffies;
>+	priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
> 	if (r->cost == 0) {
>-		/* User avg in seconds * XT_LIMIT_SCALE: convert to jiffies *
>-		   128. */
>-		priv->prev = jiffies;
>-		priv->credit = user2credits(r->avg * r->burst); /* Credits full. */
> 		r->credit_cap = priv->credit; /* Credits full. */
> 		r->cost = user2credits(r->avg);
> 	}

I don't think we can do any better than this. We could reuse the old state from userspace, but that might have changed in the kernel as well.

Perhaps for the future we can find some way to optionally associate elements of the new ruleset with the old one and keep states when parameters haven't changed. Probably hard though since the new ruleset is constructed in the kernel while the old one is still active.

