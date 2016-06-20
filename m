From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue] src: make nfq_open_nfnl thread-safe
Date: Mon, 20 Jun 2016 14:58:43 +0200
Message-ID: <20160620125843.GA16454@salvia>
References: <1466421592-9164-1-git-send-email-fw@strlen.de>
 <20160620124259.GA15177@salvia>
 <20160620124458.GA15243@salvia>
 <20160620125227.GC2250@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36105 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbcFTNG6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jun 2016 09:06:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 040E82B50E7
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 14:58:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E6B13AD73
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 14:58:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D735FA827A
	for <netfilter-devel@vger.kernel.org>; Mon, 20 Jun 2016 14:58:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160620125227.GC2250@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 20, 2016 at 02:52:27PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jun 20, 2016 at 02:42:59PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Jun 20, 2016 at 01:19:52PM +0200, Florian Westphal wrote:
> > > > nfq_open_nfnl uses an intermediate static object, so when
> > > > it is invoked by distinct threads at the same time there is a small
> > > > chance that some threads end up with another threads nfq_handle pointer
> > > > stored in ->data.
> > > > 
> > > > Tested-by: Michal Tesar <mtesar@redhat.com>
> > > > Signed-off-by: Florian Westphal <fw@strlen.de>
> > > 
> > > Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Wait wait...
> 
> Sorry, already pushed it after seeing the Ack...
> 
> > This is allocated in this stack?
> > 
> >  struct nfq_handle *nfq_open_nfnl(struct nfnl_handle *nfnlh)
> >  {
> > +       struct nfnl_callback pkt_cb = {
> > +               .call           = __nfq_rcv_pkt,
> > +               .attr_count     = NFQA_MAX,
> > +       };
> > 
> > Then accessed out of it?
> > 
> > I mean, this is passed by reference to the callback registration.
> 
> AFAICS nfnl_callback_register() memcpy's the thing into nfnl_handle,
> which is malloc'd in nfq_open_nfnl.

Right, sorry for the noise.
