From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH -next] netfilter: bridge: optionally set indev to vlan
Date: Thu, 5 Apr 2012 21:40:48 +0200
Message-ID: <20120405194048.GA28425@Chamillionaire.breakpoint.cc>
References: <20120404195729.GC23461@Chamillionaire.breakpoint.cc>
 <4F7DD464.4020405@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:50880 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab2DETkt convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:40:49 -0400
Content-Disposition: inline
In-Reply-To: <4F7DD464.4020405@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer <bdschuym@pandora.be> wrote:
> > +static int brnf_pass_vlan_indev __read_mostly = 0;
> >   static int brnf_filter_pppoe_tagged __read_mostly = 0;
> >   #else
> >   #define brnf_call_iptables 1
> > @@ -503,6 +504,19 @@ bridged_dnat:
> >   	return 0;
> >   }
> 
> You should also provide a macro in case the proc file system isn't 
> enabled: currently it won't compile with your patch.

You're right, of course.
Thanks for spotting this, I'll fix it.

> >   	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
> > -	struct net_device *realoutdev = bridge_parent(skb->dev);
> > +	struct net_device *realoutdev = brnf_get_logical_dev(skb, out);
> I think it's best to keep the bridge_parent as output device in the 
> FOWARD and POSTROUTING chain: only change the input device. Do you have 
> a reason for changing the output device?

Consistency.  (locally generated packet is '-o br0.X, forwarded br0).
OTOH, we could call it a feature ;-)

I have no special requirements for the outdev; we can keep it as-is.

Regards,
Florian
