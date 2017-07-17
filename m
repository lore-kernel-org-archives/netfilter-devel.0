From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] monitor: Rewrite SETELEM callback
Date: Mon, 17 Jul 2017 19:16:29 +0200
Message-ID: <20170717171629.GA2221@salvia>
References: <20170717150606.32097-1-phil@nwl.cc>
 <20170717150606.32097-2-phil@nwl.cc>
 <20170717163018.GA1244@salvia>
 <20170717164114.GR16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39424 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdGQRQh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 13:16:37 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 919BD24712
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 19:16:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 80C0EDA840
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 19:16:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 592A9D1D96
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 19:16:22 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170717164114.GR16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 17, 2017 at 06:41:14PM +0200, Phil Sutter wrote:
> On Mon, Jul 17, 2017 at 06:30:18PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Jul 17, 2017 at 05:06:05PM +0200, Phil Sutter wrote:
> > [...]
> > > +static int netlink_events_setelem_newgen_cb(const struct nlmsghdr *nlh,
> > > +					    int type,
> > > +					    struct netlink_mon_handler *monh)
> > > +{
> > > +	setelem_cache_print_default(monh);
> > > +
> > > +	return MNL_CB_OK;
> > >  }
> > 
> > I would really like we don't rely on newgen for this. If there is no
> > way to catch a case with the existing way we represent this, then we
> > probably need to fix things from the kernel.
> > 
> > Before we follow that patch, I would like to understand what corner
> > case is pushing us to use the newgen event.
> 
> It is required for half-open ranges occurring at the end of the
> transaction: For those, we only get a single element without
> EXPR_F_INTERVAL_END flag set. Since this could also be the first part of
> a regular range, monitor has to wait for what's next - which is in doubt
> only the NEWGEN message.
> 
> Maybe we could introduce a new flag to mark these?

Right, I think we need the new flag indeed, only for userspace.

Would you propose one and the specific semantics for it?
