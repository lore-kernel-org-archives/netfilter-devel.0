From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH libnetfilter_queue] src: make nfq_open_nfnl thread-safe
Date: Mon, 20 Jun 2016 14:52:27 +0200
Message-ID: <20160620125227.GC2250@breakpoint.cc>
References: <1466421592-9164-1-git-send-email-fw@strlen.de>
 <20160620124259.GA15177@salvia>
 <20160620124458.GA15243@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:55770 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbcFTMwe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 08:52:34 -0400
Content-Disposition: inline
In-Reply-To: <20160620124458.GA15243@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jun 20, 2016 at 02:42:59PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Jun 20, 2016 at 01:19:52PM +0200, Florian Westphal wrote:
> > > nfq_open_nfnl uses an intermediate static object, so when
> > > it is invoked by distinct threads at the same time there is a small
> > > chance that some threads end up with another threads nfq_handle pointer
> > > stored in ->data.
> > > 
> > > Tested-by: Michal Tesar <mtesar@redhat.com>
> > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > 
> > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Wait wait...

Sorry, already pushed it after seeing the Ack...

> This is allocated in this stack?
> 
>  struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
>  {
> +       struct nfnl_callback pkt_cb = {
> +               .call           = __nfq_rcv_pkt,
> +               .attr_count     = NFQA_MAX,
> +       };
> 
> Then accessed out of it?
> 
> I mean, this is passed by reference to the callback registration.

AFAICS nfnl_callback_register() memcpy's the thing into nfnl_handle,
which is malloc'd in nfq_open_nfnl.
