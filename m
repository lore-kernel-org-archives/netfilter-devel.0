From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ipset: timeout fixing bug broke SET
 target special timeout value
Date: Tue, 16 Oct 2012 11:36:53 +0200
Message-ID: <20121016093653.GA18252@1984>
References: <1349950658-12548-1-git-send-email-pablo@netfilter.org>
 <1349950658-12548-4-git-send-email-pablo@netfilter.org>
 <20121015232225.GB2118@kroah.com>
 <20121015232750.GA32665@kroah.com>
 <20121015234022.GB667@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37164 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752410Ab2JPJhA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Oct 2012 05:37:00 -0400
Content-Disposition: inline
In-Reply-To: <20121015234022.GB667@kroah.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 15, 2012 at 04:40:22PM -0700, Greg KH wrote:
> On Mon, Oct 15, 2012 at 04:27:50PM -0700, Greg KH wrote:
> > On Mon, Oct 15, 2012 at 04:22:25PM -0700, Greg KH wrote:
> > > On Thu, Oct 11, 2012 at 12:17:38PM +0200, pablo@netfilter.org wrote:
> > > > From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > 
> > > > The patch "127f559 netfilter: ipset: fix timeout value overflow bug"
> > > > broke the SET target when no timeout was specified.
> > > > 
> > > > Reported-by: Jean-Philippe Menil <jean-philippe.menil@univ-nantes.fr>
> > > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > > 
> > > > This patch requires:
> > > > 
> > > > commit 127f559127f5175e4bec3dab725a34845d956591
> > > > Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > Date:   Mon May 7 02:35:44 2012 +0000
> > > > 
> > > >     netfilter: ipset: fix timeout value overflow bug
> > > >     
> > > >     Large timeout parameters could result wrong timeout values due to
> > > >     an overflow at msec to jiffies conversion (reported by Andreas Herz)
> > > 
> > > This patch doesn't apply to the 3.0.y series, care to provide a
> > > backport, and a backported version of the original patch above that
> > > needs it?
> > 
> > Oh wait, should I apply the 3.0.y specific patches first?  I'll go do
> > that and see if these two then apply here...
> 
> Nope, doesn't apply.  Care to backport both of these patches for 3.0.y
> and send them to us?

I can send you the backport for 3.2 but not for 3.0.

That fix is for one feature that was added in 3.1, so no way to make it
for 3.0 :-)

Let me know.
