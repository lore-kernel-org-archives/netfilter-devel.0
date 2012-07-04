From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] nfnetlink: Check callbacks before using those in
 nfnetlink_rcv_msg
Date: Wed, 4 Jul 2012 22:54:03 +0200
Message-ID: <20120704205403.GA22228@1984>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1340888269-4926-2-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20120629111505.GC15598@1984>
 <alpine.LNX.2.01.1206292100210.20094@frira.zrqbmnf.qr>
 <20120630085425.GE13074@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753951Ab2GDUyI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 16:54:08 -0400
Content-Disposition: inline
In-Reply-To: <20120630085425.GE13074@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 30, 2012 at 10:54:25AM +0200, Florian Westphal wrote:
> Jan Engelhardt <jengelh@inai.de> wrote:
> > On Friday 2012-06-29 13:15, Pablo Neira Ayuso wrote:
> > >On Thu, Jun 28, 2012 at 03:57:47PM +0300, Tomasz Bursztyka wrote:
> > >> ---
> > >> @@ -184,9 +184,11 @@ replay:
> > >>  					lockdep_is_held(&nfnl_mutex)) != ss ||
> > >>  			    nfnetlink_find_client(type, ss) != nc)
> > >>  				err = -EAGAIN;
> > >> -			else
> > >> +			else if (nc->call)
> > >>  				err = nc->call(net->nfnl, skb, nlh,
> > >>  						   (const struct nlattr **)cda);
> > >> +			else
> > >> +				err = -EINVAL;
> > >
> > >Hm, I think this is redundant. We got the ipset problem fixed with
> > >2/3. I think we can add some BUG_ON instead as all nc->call needs to
> > >be defined. Otherwise, spot a bug message so it is fixed.
> > 
> > Seriously, we have run into NULL dereferences at this place so often
> > that it should not be discarded as a PEBKAC issue. Yes, it is the
> > programmer's responsibility to fill in .call, but error handling is
> > anytime better than driving one's machine into the pit stop due to a
> > NULL deref or BUG_ON.
> 
> Agreed.  I think this should be WARN_ON_ONCE + ret EINVAL.
> We also do this with various places that e.g. fill netlink
> messages so that adding new attributes without bumping allocation
> sizes is reported without crashes.  Since we've started to move
> the performance-critical nfnetlink stuff over to ->call_rcu
> the extra NULL test should not harm fastpath either.

OK, fair enough. I've enqueued this to nf-next.
