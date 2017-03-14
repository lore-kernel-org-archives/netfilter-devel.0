From: Phil Sutter <phil@nwl.cc>
Subject: Re: [iptables PATCH] extensions: libxt_statistic: Complete nft
 translator
Date: Tue, 14 Mar 2017 15:11:12 +0100
Message-ID: <20170314141112.GA17939@orbyte.nwl.cc>
References: <20170313160153.21120-1-phil@nwl.cc>
 <20170313165353.GA32057@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:44639 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750780AbdCNOLO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 10:11:14 -0400
Content-Disposition: inline
In-Reply-To: <20170313165353.GA32057@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 13, 2017 at 05:53:53PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Mar 13, 2017 at 05:01:53PM +0100, Phil Sutter wrote:
> [...]
> > The nftables numgen expression works differently:
> 
> Phil, if you think we need a 1:1 mapping so iptables users moving to
> nftables don't get confused, I'll be fine to take an update to
> nft_numgen so we accomodate a new NFT_NG_PROBABILISTIC mode or so.

Well, implementing the translator wasn't exactly trivial, but in general
I don't think numgen is particularly hard to use. Of course an explicit
probability mode might make things easier, but then I guess it wouldn't
fit into the LHS/RHS scheme anymore. So I personally don't care, but if
you see use in implementing it just let me know and I'll adjust the
converter to make use of it. :)

Cheers, Phil
