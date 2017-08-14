From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH v4 0/3] Implement --echo option
Date: Mon, 14 Aug 2017 14:02:26 +0200
Message-ID: <20170814120226.GA24373@salvia>
References: <20170809111643.18906-1-phil@nwl.cc>
 <20170814092651.GA7437@salvia>
 <20170814113644.GS16375@orbyte.nwl.cc>
 <20170814114322.GA24030@salvia>
 <20170814115439.GA7387@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:46714 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbdHNMCv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 08:02:51 -0400
Content-Disposition: inline
In-Reply-To: <20170814115439.GA7387@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 14, 2017 at 01:54:39PM +0200, Phil Sutter wrote:
> On Mon, Aug 14, 2017 at 01:43:22PM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Aug 14, 2017 at 01:36:44PM +0200, Phil Sutter wrote:
> > > On Mon, Aug 14, 2017 at 11:26:51AM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Aug 09, 2017 at 01:16:40PM +0200, Phil Sutter wrote:
> > > > > Long description of what it is and how it works in patch 3. Patch 1 is a
> > > > > dependency to patch 2, Patch 3 adds a simple test suite which was
> > > > > helpful during development.
> > > > 
> > > > Applied, but please follow up asap to address a couple of issues:
> > > > 
> > > > mnl.c: In function ‘nft_mnl_talk_cb’:
> > > > mnl.c:82:5: warning: ‘rc’ may be used uninitialized in this function
> > > > [-Wmaybe-uninitialized]
> > > >   if (rc)
> > > >      ^
> > > 
> > > Hmm, that's weird - the warning is correct, but gcc on my system doesn't
> > > complain. Even after explicitly setting -Wmaybe-uninitialized.
> > 
> > May be your gcc version.
> 
> It's 6.3.0, but checking for uninitialized access is far from new so no
> idea what is going on here.

Ok, no problem, let's just fix this.

[...]
> > > > Why don't you simply pass the callback that you need to nft_mnl_recv()
> > > > instead of adding this extra unnecesary abstraction...
> > > 
> > > It is not unnecessary: There are several callers passing a callback to
> > > nft_mnl_talk().
> > 
> > Then, you pass the callback that you need to nft_mnl_talk() as parameter.
> > 
> > > I didn't want to mess with all of them but still insert
> > > netlink_echo_callback(). Hence I introduced nft_mnl_talk_cb() which
> > > takes care of the callback passed by callers and ultimately calls the
> > > echo callback.
> > 
> > Why don't you just add context as cb_data so you know you have to do
> > the netlink_echo_callback() handling?
> > 
> > There must be a better way to do this...
> 
> Please disregard - I just noticed that in the only cases where echo
> callback is required no custom callback is passed yet, so I can just get
> by without any wrappers. Also, that code even doesn't work like this -
> netlink_echo_callback() expects netlink_ctx as second parameter, which
> is not the case. I'll get this sorted as well and then make sure it's
> actually tested by manually disabling batch support in code.

Great, wait for your patches, thanks Phil!
