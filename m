From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] netfilter: xt_TEE:  IPv4 Don't Fragmet options
Date: Thu, 14 Jun 2012 22:07:30 +0200
Message-ID: <20120614200730.GA22939@breakpoint.cc>
References: <rvd97lb.cb16bfe930b2100854041c0a3d714500@obelix.schillstrom.com>
 <20120614175223.GA10633@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hans Schillstrom <hans@schillstrom.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41678 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755620Ab2FNUHg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 16:07:36 -0400
Content-Disposition: inline
In-Reply-To: <20120614175223.GA10633@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jun 14, 2012 at 08:17:35AM +0200, Hans Schillstrom wrote:
> > I  think it is wrong to always force the DF bit in IPv4, it's better
> > to have an option If an application don't set the DF bit, usually it
> > doesn't expect to get an icmp back either.  The result is that the
> > packet will be dropped...
> > 
> > To retain backwards compatibility I suggest adding a new option like
> > 
> > --ipv4-df-copy  Do not force "Don't Fragment" on the copied packet
> > just copy the bit.
> > 
> > In IPv6 we don't have that option, so nothing has to be done there.
> > --- a/net/netfilter/xt_TEE.c
> > +++ b/net/netfilter/xt_TEE.c
> > @@ -117,7 +117,8 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
> >          * decreased MTU on the clone route. IPv6 does this too.
> >          */
> >         iph = ip_hdr(skb);
> > -       iph->frag_off |= htons(IP_DF);
> > +       if (!info->df_copy)
> > +               iph->frag_off |= htons(IP_DF);

Wouldn't it make more sense to just remove the
iph->frag_off |= htons(IP_DF);
line?  I don't think forcing DF is a good idea.

Or are you dealing with some application that sets DF, but
then fails to handle the icmp error?
