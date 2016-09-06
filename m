From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2 2/4] netlink_delinearize: Avoid potential null
 pointer deref
Date: Tue, 6 Sep 2016 16:17:30 +0200
Message-ID: <20160906141730.GI29816@orbyte.nwl.cc>
References: <1472578792-2991-1-git-send-email-phil@nwl.cc>
 <1472578792-2991-3-git-send-email-phil@nwl.cc>
 <20160905165243.GA17099@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:56397 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755878AbcIFORc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Sep 2016 10:17:32 -0400
Content-Disposition: inline
In-Reply-To: <20160905165243.GA17099@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Sep 05, 2016 at 06:52:43PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 30, 2016 at 07:39:50PM +0200, Phil Sutter wrote:
> > As netlink_get_register() may return NULL, we must not pass the returned
> > data unchecked to expr_set_type() as that will dereference it. Since the
> > parser has failed at that point anyway, by returning early we can skip
> > the useless statement allocation that follows in
> > netlink_parse_ct_stmt().
> 
> I found a couple more spots, such as the payload stmt that was not
> covered by this patch.

OK. The reason I left those out was that they don't call expr_set_type()
and therefore the potential NULL pointer dereference doesn't happen
there.

> Attaching a new one based on this, looks good to you?

Acked-by: Phil Sutter <phil@nwl.cc>

> Anyway, this is very unlikely to happen: Only if we ever get more
> registers in the kernel, given that expl_clone() relies on the
> xzalloc() function that just stops execution under OOM.

Yes. The thing with Covscan is it will find very theoretical issues and
practical relevance is usually questionable (as they would likely have
been found already).

> Actually this brings an interesting issue that is that we need to
> provide a way to describe the vm capabilities so we can extend things
> in the future without breaking userspace.

Not my cup of tea luckily. :)

Thanks, Phil
