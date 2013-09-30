From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH net-next 1/1] sip: introduce nf_nat_sip_hooks
Date: Mon, 30 Sep 2013 16:13:33 +0100
Message-ID: <20130930151332.GA10721@macbook.localnet>
References: <20130930135150.440707982@eitzenberger.org>
 <20130930135559.077109518@eitzenberger.org>
 <20130930140309.GA28301@macbook.localnet>
 <20130930144951.GA13405@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39127 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245Ab3I3PNi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:13:38 -0400
Content-Disposition: inline
In-Reply-To: <20130930144951.GA13405@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 04:49:51PM +0200, Holger Eitzenberger wrote:
> 
> > Thanks Holger, I wanted to do the same for a long time now. It actually
> > also fixes a minor race condition, when the NAT helper is loaded or
> > unloaded while a packet is processed the hooks may be invoked only
> > partially.
> > 
> > Just one request:
> > 
> > > +struct nf_nat_sip_hooks {
> > > +	unsigned int (* nsh_msg)(struct sk_buff *skb,
> > > +				 unsigned int protoff,
> > > +				 unsigned int dataoff,
> > > +				 const char **dptr,
> > > +				 unsigned int *datalen);
> > 
> > I really hate unpronouncable abbrevations, it hurts my eyes and IMO makes
> > it harder to read the code. Please use something nicer or get rid of the
> > prefix entirely.
> 
> Ok, I'll remove the prefix then.
> 
> However, personally I think they help grep'ing a lot, like e. g. the
> ndo_ prefix with netdevice ops (still usefull even as a 'cscope'
> user).
> 
> Also the function names are *shorter* with the patch, as I was able
> to remove the nf_nat_ prefix.

Sure, its really just the unpronouncable thing, it makes it harder to
follow the code in your head. If you really want to keep the prefixes,
why not just use nat_sip_?

Cheers,
Patrick
