From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2 0/4] libnftables preparations
Date: Tue, 24 Oct 2017 18:29:18 +0200
Message-ID: <20171024162918.GP32305@orbyte.nwl.cc>
References: <20171023153319.13415-1-phil@nwl.cc>
 <20171024152033.GA31888@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35572 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932109AbdJXQ3X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:29:23 -0400
Content-Disposition: inline
In-Reply-To: <20171024152033.GA31888@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 24, 2017 at 05:20:33PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 23, 2017 at 05:33:15PM +0200, Phil Sutter wrote:
> > The following series prepares libnftables libarary split-off by moving
> > API functions into src/libnftables.c, introducing
> > include/nftables/nftables.h and enhancing the code by a number of
> > getters and setters for applications to change configurable parts of
> > struct nft_ctx without knowledge of that struct's internals.
> > 
> > The 'nft' binary will become the first "demo" user of libnftables and
> > acts as a reference for library design and usability.
> 
> Series applied.

Cool, thanks!

> I have to merged this patch below to 1/4.

Oops. :)

Cheers, Phil
