From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH 2/2] netfilter: cleanup printk messages
Date: Wed, 12 May 2010 09:54:29 -0700
Message-ID: <20100512095429.18b10af7@nehalam>
References: <20100512162954.316178344@vyatta.com>
	<20100512163030.114488325@vyatta.com>
	<alpine.LSU.2.01.1005121851370.14663@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.vyatta.com ([76.74.103.46]:59267 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab0ELQyb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 May 2010 12:54:31 -0400
In-Reply-To: <alpine.LSU.2.01.1005121851370.14663@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 12 May 2010 18:52:02 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

> 
> On Wednesday 2010-05-12 18:29, Stephen Hemminger wrote:
> 
> >Make sure all printk messages have a severity level.
> >
> >--- a/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:26.447006714 -0700
> >+++ b/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:44.287371327 -0700
> >@@ -108,7 +108,7 @@ static int amanda_help(struct sk_buff *s
> > 	dataoff = protoff + sizeof(struct udphdr);
> > 	if (dataoff >= skb->len) {
> > 		if (net_ratelimit())
> >-			printk("amanda_help: skblen = %u\n", skb->len);
> >+			printk(KERN_ERR "amanda_help: skblen = %u\n", skb->len);
> 
> A good idea, but perhaps we should just use pr_{err,andsoon} while at it.

I did some places, but code that was already using printk(KERN_XXX form,
I just duplicated existing style in that file.

-- 
