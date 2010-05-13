From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2] netfilter: cleanup printk messages
Date: Thu, 13 May 2010 15:03:13 +0200
Message-ID: <4BEBF891.8080307@trash.net>
References: <20100512162954.316178344@vyatta.com>	<20100512163030.114488325@vyatta.com>	<alpine.LSU.2.01.1005121851370.14663@obet.zrqbmnf.qr> <20100512095429.18b10af7@nehalam>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <shemminger@vyatta.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54993 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527Ab0EMNDO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 May 2010 09:03:14 -0400
In-Reply-To: <20100512095429.18b10af7@nehalam>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Hemminger wrote:
> On Wed, 12 May 2010 18:52:02 +0200 (CEST)
> Jan Engelhardt <jengelh@medozas.de> wrote:
> 
>> On Wednesday 2010-05-12 18:29, Stephen Hemminger wrote:
>>
>>> Make sure all printk messages have a severity level.
>>>
>>> --- a/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:26.447006714 -0700
>>> +++ b/net/netfilter/nf_conntrack_amanda.c	2010-05-12 09:28:44.287371327 -0700
>>> @@ -108,7 +108,7 @@ static int amanda_help(struct sk_buff *s
>>> 	dataoff = protoff + sizeof(struct udphdr);
>>> 	if (dataoff >= skb->len) {
>>> 		if (net_ratelimit())
>>> -			printk("amanda_help: skblen = %u\n", skb->len);
>>> +			printk(KERN_ERR "amanda_help: skblen = %u\n", skb->len);
>> A good idea, but perhaps we should just use pr_{err,andsoon} while at it.
> 
> I did some places, but code that was already using printk(KERN_XXX form,
> I just duplicated existing style in that file.

We can clean this up in follow-up patches. Applied.
