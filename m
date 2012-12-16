From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: problem: [PATCH] iptable_REJECT doesn't constructs the tcp
 reset packet cleanly
Date: Sun, 16 Dec 2012 23:32:08 +0100
Message-ID: <20121216223208.GA1304@1984>
References: <CAAFTS2WV4PbnKREaNZNHMSezTPuG-QcUWONd_MnB54KQVks33w@mail.gmail.com>
 <20121211005802.GA14525@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu,
	kaber@trash.net, linux-kernel@vger.kernel.org
To: Mukund Jampala <jbmukund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49140 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab2LPWcO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:32:14 -0500
Content-Disposition: inline
In-Reply-To: <20121211005802.GA14525@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 11, 2012 at 01:58:02AM +0100, Pablo Neira Ayuso wrote:
[...]
> On Mon, Dec 10, 2012 at 12:48:49PM -0800, Mukund Jampala wrote:
> > problem description:
> > The problem occurs when iptables constructs the tcp reset packet.
> > It doesn't initialize the pointer to the tcp header within the skb.
> > When the skb is passed to the ixgbe driver for transmit, the ixgbe
> > driver attempts to access the tcp header and crashes.
> > Currently, other drivers (such as our 1G e1000e or igb drivers) don't
> > access the tcp header on transmit unless the TSO option is turned on.
[...]
> > Solution: set the skb->trasport_header to a valid data offset in ipt
> > reject module
> > 
> > diff -up net/ipv4/netfilter/ipt_REJECT.c{.orig,}
> > --- net/ipv4/netfilter/ipt_REJECT.c.orig	2012-12-10 12:08:37.000000000 -0800
> > +++ net/ipv4/netfilter/ipt_REJECT.c	2012-12-10 12:10:08.000000000 -0800
> > @@ -79,6 +79,8 @@ static void send_reset(struct sk_buff *o
> >  	niph->saddr	= oiph->daddr;
> >  	niph->daddr	= oiph->saddr;
> > 
> > +
> > +	skb_reset_transport_header(nskb);
> >  	tcph = (struct tcphdr *)skb_put(nskb, sizeof(struct tcphdr));
> >  	memset(tcph, 0, sizeof(*tcph));
> >  	tcph->source	= oth->dest;
> > 
> > Please let me know if you have any concerns with the patch.
> 
> This is a good and extensive diagnosing, thanks a lot.
> 
> Regarding your patch format, please, use git format-patch for your
> upcoming contributions and add the Signed-off-by tag to your patches.
> It makes
> 
> But for this time, I'll do the formatting myself and will take this
> into the nf tree.

I have also made the same change for ip6t_REJECT.

Applied, thanks Mukund.
