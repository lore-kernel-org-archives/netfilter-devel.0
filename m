From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 5/7] netfilter: connlimit: use keyed locks
Date: Sun, 9 Mar 2014 18:13:11 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1403091809110.10040@nerf08.vanv.qr>
References: <1394199435-14395-1-git-send-email-fw@strlen.de> <1394199435-14395-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:41807 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751207AbaCIRNN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:13:13 -0400
In-Reply-To: <1394199435-14395-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2014-03-07 14:37, Florian Westphal wrote:
> 
>+#define CONNLIMIT_SLOTS	256 /* power-of-two */
>+#define CONNLIMIT_LOCK_SLOTS	32 /* power-of-two */

It's clear that 256 and 32 are powers of two. Or did you intend to
write "these should be a power of two"? Which would then raise the
question if they really need to be a power of two.

Given

> static inline unsigned int connlimit_iphash(__be32 addr)
> {
>-	return jhash_1word((__force __u32)addr, connlimit_rnd) & 0xFF;
>+	return jhash_1word((__force __u32)addr,
>+			    connlimit_rnd) % CONNLIMIT_SLOTS;
> }
> 
>@@ -183,7 +188,7 @@ static int count_them(struct net *net,
> 
> 	hhead = &data->iphash[hash];
> 
>-	spin_lock_bh(&data->lock);
>+	spin_lock_bh(&data->locks[hash % CONNLIMIT_LOCK_SLOTS]);
> 	count = count_hlist(net, hhead, tuple, addr, mask, family, &addit);
> 	if (addit) {
> 		if (add_hlist(hhead, tuple, addr))

it would seem that it is sufficient to have CONNLIMIT_SLOTS be
a multiple of CONNLIMIT_LOCK_SLOTS and

> {
> 	int ret;
>+
>+	BUILD_BUG_ON(CONNLIMIT_LOCK_SLOTS > CONNLIMIT_SLOTS);
>+

be followed by

	BUILD_BUG_ON(CONNLIMIT_SLOTS % CONNLIMIT_LOCK_SLOTS != 0);
