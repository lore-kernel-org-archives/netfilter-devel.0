From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 3/3] src: add nft_ctx_netlink_init()
Date: Fri, 1 Sep 2017 12:50:49 +0200
Message-ID: <20170901105049.GN20614@orbyte.nwl.cc>
References: <1504260847-5408-1-git-send-email-pablo@netfilter.org>
 <1504260847-5408-3-git-send-email-pablo@netfilter.org>
 <20170901101733.GA5539@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:41129 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751725AbdIAKuu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2017 06:50:50 -0400
Content-Disposition: inline
In-Reply-To: <20170901101733.GA5539@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Fri, Sep 01, 2017 at 12:17:33PM +0200, Pablo Neira Ayuso wrote:
> On Fri, Sep 01, 2017 at 12:14:07PM +0200, Pablo Neira Ayuso wrote:
> > Add these two new functions to set up netlink sockets in the global
> > context structure.
> 
> We can alternatively call this nft_ctx_netlink_auto() if prefer.
> 
> I'm just trying to skip the type/flag field for nft_ctx_alloc().
> 
> Does this look acceptable to you to have this extra API to request
> libnftables to deal with IO details too?

I think we could do it in a simpler way:

| /* create an mnl netlink socket object */
| struct mnl_socket *netlink_open_sock(void);
| 
| /* create nft context, optionally passing mnl socket object returned
|  * from netlink_open_sock()
|  * Calling nft_ctx_new(NULL) is equivalent to calling
|  * nft_ctx_new(netlink_open_sock())
|  */
| static struct nft_ctx *nft_ctx_new(struct mnl_socket *nf_sock);

This way we allow the application to control mnl_socket object, provide
a simple API for applications which don't need that and at the same time
always have ctx->nf_sock point to the socket so we can further simplify
things.

What do you think?

Cheers, Phil
