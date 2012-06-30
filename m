From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/3] nfnetlink: Check callbacks before using those in
 nfnetlink_rcv_msg
Date: Sat, 30 Jun 2012 10:54:25 +0200
Message-ID: <20120630085425.GE13074@breakpoint.cc>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1340888269-4926-2-git-send-email-tomasz.bursztyka@linux.intel.com>
 <20120629111505.GC15598@1984>
 <alpine.LNX.2.01.1206292100210.20094@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41919 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab2F3Iy2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jun 2012 04:54:28 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1206292100210.20094@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@inai.de> wrote:
> On Friday 2012-06-29 13:15, Pablo Neira Ayuso wrote:
> >On Thu, Jun 28, 2012 at 03:57:47PM +0300, Tomasz Bursztyka wrote:
> >> ---
> >> @@ -184,9 +184,11 @@ replay:
> >>  					lockdep_is_held(&nfnl_mutex)) != ss ||
> >>  			    nfnetlink_find_client(type, ss) != nc)
> >>  				err = -EAGAIN;
> >> -			else
> >> +			else if (nc->call)
> >>  				err = nc->call(net->nfnl, skb, nlh,
> >>  						   (const struct nlattr **)cda);
> >> +			else
> >> +				err = -EINVAL;
> >
> >Hm, I think this is redundant. We got the ipset problem fixed with
> >2/3. I think we can add some BUG_ON instead as all nc->call needs to
> >be defined. Otherwise, spot a bug message so it is fixed.
> 
> Seriously, we have run into NULL dereferences at this place so often
> that it should not be discarded as a PEBKAC issue. Yes, it is the
> programmer's responsibility to fill in .call, but error handling is
> anytime better than driving one's machine into the pit stop due to a
> NULL deref or BUG_ON.

Agreed.  I think this should be WARN_ON_ONCE + ret EINVAL.
We also do this with various places that e.g. fill netlink
messages so that adding new attributes without bumping allocation
sizes is reported without crashes.  Since we've started to move
the performance-critical nfnetlink stuff over to ->call_rcu
the extra NULL test should not harm fastpath either.
