From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/2] netfilter: cleanup printk messages
Date: Wed, 12 May 2010 18:52:02 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005121851370.14663@obet.zrqbmnf.qr>
References: <20100512162954.316178344@vyatta.com> <20100512163030.114488325@vyatta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45348 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756652Ab0ELQwF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 May 2010 12:52:05 -0400
In-Reply-To: <20100512163030.114488325@vyatta.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-05-12 18:29, Stephen Hemminger wrote:

>Make sure all printk messages have a severity level.
>
>--- a/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:26.447006714 -0700
>+++ b/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:44.287371327 -0700
>@@ -108,7 +108,7 @@ static int amanda_help(struct sk_buff *s
> 	dataoff = protoff + sizeof(struct udphdr);
> 	if (dataoff >= skb->len) {
> 		if (net_ratelimit())
>-			printk("amanda_help: skblen = %u\n", skb->len);
>+			printk(KERN_ERR "amanda_help: skblen = %u\n", skb->len);

A good idea, but perhaps we should just use pr_{err,andsoon} while at it.
