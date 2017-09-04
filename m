From: Eric Leblond <eric@regit.org>
Subject: Re: [nft PATCH 1/2] src: add flags fo nft_ctx_new
Date: Mon, 04 Sep 2017 09:21:27 +0200
Message-ID: <1504509687.15611.16.camel@regit.org>
References: <20170903220356.20178-1-eric@regit.org>
         <20170903220356.20178-2-eric@regit.org> <20170903223309.GA12383@salvia>
         <20170903224544.GA13487@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:44988 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdIDHVa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 03:21:30 -0400
In-Reply-To: <20170903224544.GA13487@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 2017-09-04 at 00:45 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 04, 2017 at 12:33:09AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 04, 2017 at 12:03:55AM +0200, Eric Leblond wrote:
> > > By adding flags to nft_ctx_new, we will have a minimum
> > > capabilities
> > > of changing the way the nft_ctx is created.
> > > 
> > > For now, this patch uses a simple value that allow the user to
> > > specify
> > > that he will handle netlink by himself.
> > > 
> > > Signed-off-by: Eric Leblond <eric@regit.org>
> > > ---
> > >  include/nftables.h |  4 ++++
> > >  src/main.c         | 20 +++++++++++---------
> > >  2 files changed, 15 insertions(+), 9 deletions(-)
> > > 
> > > diff --git a/include/nftables.h b/include/nftables.h
> > > index 5035567..7c4e93f 100644
> > > --- a/include/nftables.h
> > > +++ b/include/nftables.h
> > > @@ -49,8 +49,12 @@ struct nft_ctx {
> > >  	struct output_ctx	output;
> > >  	bool			check;
> > >  	struct nft_cache	cache;
> > > +	uint32_t		flags;
> > >  };
> > >  
> > > +#define NFT_CTX_CUSTOM_NETLINK	(1<<0)
> > > +#define NFT_CTX_DEFAULT		0
> > 
> > Better than flag, let's make this a type, ie. NFT_CTX_NETLINK is
> > just 1.
> > 
> > OK?
> 
> Actually, we keep this back, I mean, we just have NFT_CTX_DEFAULT, so
> we don't introduce NFT_CTX_NETLINK until we have the advanced API in
> place.

Yes, make sense, it was a bit artificial. I will cook updated patch
today.

BR,
-- 
Eric Leblond <eric@regit.org>
