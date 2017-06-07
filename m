From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 2/2] src: rename ct eventmask to event
Date: Wed, 7 Jun 2017 17:31:12 +0200
Message-ID: <20170607153112.GB23661@strlen.de>
References: <20170607102410.21024-1-fw@strlen.de>
 <20170607102410.21024-2-fw@strlen.de>
 <20170607103820.GB9280@salvia>
 <20170607110751.GC18283@breakpoint.cc>
 <20170607112750.GA9759@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46452 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750831AbdFGPat (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 11:30:49 -0400
Content-Disposition: inline
In-Reply-To: <20170607112750.GA9759@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Jun 07, 2017 at 01:07:51PM +0200, Florian Westphal wrote:
> > I could of course stick a check for the key type into
> > netlink_delinerize.c but thats ugly.
> > 
> > Alterntively I could hook into ct_stmt_print and dissect there.
> > 
> > Any idea/preference?
> 
> I suggest you always use the comma separated one to print this.
 
I've pushed a revised version of this patch + the 'use comma' patch
to master, thanks!
