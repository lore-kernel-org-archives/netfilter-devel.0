From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Resend: One bug in the xt_hashlimit.c
Date: Sun, 16 Dec 2012 18:39:56 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212161822470.27614@nerf07.vanv.qr>
References: <CA+6hz4oJ3g3z49z44nN02DJtkHDkF5tiNH-nDH3thdD3GYUg7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, laforge@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37004 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586Ab2LPRj7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Dec 2012 12:39:59 -0500
In-Reply-To: <CA+6hz4oJ3g3z49z44nN02DJtkHDkF5tiNH-nDH3thdD3GYUg7A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-12-16 16:19, Feng Gao wrote:
>
>Hi Harald & Jan,
>
>Because there is no any response for this issue,so I send the egmail again a
>s a reminder.

Sorry to not have responded. This sort of went under the radar since
netfilter-devel was initially not Cced. More answers to the patch
below.

>The following codes are from function "hashlimit_mt".
>dh = dsthash_find(hinfo, &dst);
>if (dh == NULL) {
>dh = dsthash_alloc_init(hinfo, &dst);
>
>When two or more threads invoke dsthash_find(hinfo, &dst) at the same time
>and fail to find the dh, then all of them will enter the dsthash_alloc_init
>to create one new node.
>As a result, it will casue that these multiple threads create multle nodes
>with same IP. It is not expected behavior.

>--- net/netfilter/xt_hashlimit.c.orig	2012-12-02 13:54:45.376382165 +0800
>+++ net/netfilter/xt_hashlimit.c	2012-12-02 13:59:32.083381142 +0800
>@@ -157,11 +157,20 @@ dsthash_find(const struct xt_hashlimit_h
> /* allocate dsthash_ent, initialize dst, put in htable and lock it */
> static struct dsthash_ent *
> dsthash_alloc_init(struct xt_hashlimit_htable *ht,
>-		   const struct dsthash_dst *dst)
>+		   const struct dsthash_dst *dst,
>+		   bool *new_node)
> {
> 	struct dsthash_ent *ent;
> 
> 	spin_lock(&ht->lock);
>+
>+	ent = dsthash_find(ht, dst);

Hm. In hashlimit_mt(), dsthash_find() has already been called once
(within a RCU_bh section), and now you are doing the lookup again
(within spin_lock section).

>+	if (ent) {        

You have trailing squatspaces (remove them). I suggest that you
use `mcedit` or `git log -1 -p`, as both these tools highlight
such unwanted trailing spaces.

>@@ -539,7 +555,7 @@ hashlimit_mt(const struct sk_buff *skb, 
> 		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
> 		rateinfo_recalc(dh, now);
> 	}
>-
>+	
> 	if (dh->rateinfo.credit >= dh->rateinfo.cost) {
> 		/* below the limit */
> 		dh->rateinfo.credit -= dh->rateinfo.cost;

Same spacing issue here.

====

What would you think of the following patch?

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 26a668a..0d17032 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -591,9 +591,11 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		goto hotdrop;
 
 	rcu_read_lock_bh();
+	spin_lock_bh();
 	dh = dsthash_find(hinfo, &dst);
 	if (dh == NULL) {
 		dh = dsthash_alloc_init(hinfo, &dst);
+		spin_unlock_bh();
 		if (dh == NULL) {
 			rcu_read_unlock_bh();
 			goto hotdrop;
@@ -601,6 +603,7 @@ hashlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 		dh->expires = jiffies + msecs_to_jiffies(hinfo->cfg.expire);
 		rateinfo_init(dh, hinfo);
 	} else {
+		spin_unlock_bh();
 		/* update expiration timeout */
 		dh->expires = now + msecs_to_jiffies(hinfo->cfg.expire);
 		rateinfo_recalc(dh, now, hinfo->cfg.mode);
