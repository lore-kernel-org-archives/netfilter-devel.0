From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 1/2] monitor: Rewrite SETELEM callback
Date: Tue, 18 Jul 2017 11:05:16 +0200
Message-ID: <20170718090516.GU16375@orbyte.nwl.cc>
References: <20170717150606.32097-1-phil@nwl.cc>
 <20170717150606.32097-2-phil@nwl.cc>
 <20170717163018.GA1244@salvia>
 <20170717164114.GR16375@orbyte.nwl.cc>
 <20170717171629.GA2221@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35685 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751334AbdGRJFR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2017 05:05:17 -0400
Content-Disposition: inline
In-Reply-To: <20170717171629.GA2221@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 17, 2017 at 07:16:29PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Jul 17, 2017 at 06:41:14PM +0200, Phil Sutter wrote:
> > On Mon, Jul 17, 2017 at 06:30:18PM +0200, Pablo Neira Ayuso wrote:
> > > On Mon, Jul 17, 2017 at 05:06:05PM +0200, Phil Sutter wrote:
> > > [...]
> > > > +static int netlink_events_setelem_newgen_cb(const struct nlmsghdr *nlh,
> > > > +					    int type,
> > > > +					    struct netlink_mon_handler *monh)
> > > > +{
> > > > +	setelem_cache_print_default(monh);
> > > > +
> > > > +	return MNL_CB_OK;
> > > >  }
> > > 
> > > I would really like we don't rely on newgen for this. If there is no
> > > way to catch a case with the existing way we represent this, then we
> > > probably need to fix things from the kernel.
> > > 
> > > Before we follow that patch, I would like to understand what corner
> > > case is pushing us to use the newgen event.
> > 
> > It is required for half-open ranges occurring at the end of the
> > transaction: For those, we only get a single element without
> > EXPR_F_INTERVAL_END flag set. Since this could also be the first part of
> > a regular range, monitor has to wait for what's next - which is in doubt
> > only the NEWGEN message.
> > 
> > Maybe we could introduce a new flag to mark these?
> 
> Right, I think we need the new flag indeed, only for userspace.
> 
> Would you propose one and the specific semantics for it?

My current PoC passes the additional flag as userdata attribute so the
kernel won't reject the element due to unknown flag. Is that fine with
you? I'm trying to avoid changing the kernel so the solution is
backwards compatible.

Cheers, Phil
