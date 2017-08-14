From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v4 0/3] Implement --echo option
Date: Mon, 14 Aug 2017 13:54:39 +0200
Message-ID: <20170814115439.GA7387@orbyte.nwl.cc>
References: <20170809111643.18906-1-phil@nwl.cc>
 <20170814092651.GA7437@salvia>
 <20170814113644.GS16375@orbyte.nwl.cc>
 <20170814114322.GA24030@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:48045 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752902AbdHNLyk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 07:54:40 -0400
Content-Disposition: inline
In-Reply-To: <20170814114322.GA24030@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 14, 2017 at 01:43:22PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Aug 14, 2017 at 01:36:44PM +0200, Phil Sutter wrote:
> > On Mon, Aug 14, 2017 at 11:26:51AM +0200, Pablo Neira Ayuso wrote:
> > > On Wed, Aug 09, 2017 at 01:16:40PM +0200, Phil Sutter wrote:
> > > > Long description of what it is and how it works in patch 3. Patch 1 is a
> > > > dependency to patch 2, Patch 3 adds a simple test suite which was
> > > > helpful during development.
> > > 
> > > Applied, but please follow up asap to address a couple of issues:
> > > 
> > > mnl.c: In function ‘nft_mnl_talk_cb’:
> > > mnl.c:82:5: warning: ‘rc’ may be used uninitialized in this function
> > > [-Wmaybe-uninitialized]
> > >   if (rc)
> > >      ^
> > 
> > Hmm, that's weird - the warning is correct, but gcc on my system doesn't
> > complain. Even after explicitly setting -Wmaybe-uninitialized.
> 
> May be your gcc version.

It's 6.3.0, but checking for uninitialized access is far from new so no
idea what is going on here.

> Anyway, the warning is clearly right.
> 
> > [...]
> > > Apart from this, this struct nft_mnl_talk_cb_data looks... a bit
> > > convoluted ;)
> > > 
> > >         static int
> > >         nft_mnl_talk(struct mnl_socket *nf_sock, const void *data, unsigned int len,
> > >                      int (*cb)(const struct nlmsghdr *nlh, void *data), void *cb_data)
> > >         {
> > >                 uint32_t portid = mnl_socket_get_portid(nf_sock);
> > >                 struct nft_mnl_talk_cb_data tcb_data = {
> > >                         .cb = cb,
> > >                         .data = cb_data,
> > >                 };
> > > 
> > >         #ifdef DEBUG
> > >                 if (debug_level & DEBUG_MNL)
> > >                         mnl_nlmsg_fprintf(stdout, data, len, sizeof(struct nfgenmsg));
> > >         #endif
> > > 
> > >                 if (mnl_socket_sendto(nf_sock, data, len) < 0)
> > >                         return -1;
> > > 
> > >                 return nft_mnl_recv(nf_sock, seq, portid, &nft_mnl_talk_cb, &tcb_data);
> > >         }
> > > 
> > > Why don't you simply pass the callback that you need to nft_mnl_recv()
> > > instead of adding this extra unnecesary abstraction...
> > 
> > It is not unnecessary: There are several callers passing a callback to
> > nft_mnl_talk().
> 
> Then, you pass the callback that you need to nft_mnl_talk() as parameter.
> 
> > I didn't want to mess with all of them but still insert
> > netlink_echo_callback(). Hence I introduced nft_mnl_talk_cb() which
> > takes care of the callback passed by callers and ultimately calls the
> > echo callback.
> 
> Why don't you just add context as cb_data so you know you have to do
> the netlink_echo_callback() handling?
> 
> There must be a better way to do this...

Please disregard - I just noticed that in the only cases where echo
callback is required no custom callback is passed yet, so I can just get
by without any wrappers. Also, that code even doesn't work like this -
netlink_echo_callback() expects netlink_ctx as second parameter, which
is not the case. I'll get this sorted as well and then make sure it's
actually tested by manually disabling batch support in code.

Thanks, Phil
