From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 0/2] First attempt at synopsis fixup
Date: Thu, 17 Aug 2017 19:37:25 +0200
Message-ID: <20170817173725.GE10864@orbyte.nwl.cc>
References: <20170817133900.21946-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51405 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752664AbdHQRh0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Aug 2017 13:37:26 -0400
Content-Disposition: inline
In-Reply-To: <20170817133900.21946-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 17, 2017 at 03:38:58PM +0200, Phil Sutter wrote:
> The first patch is to be considered a fix and optimization, the second
> one is rather experimental and I would like to hear your thoughts about
> it (some details as to why I'm not happy with it can be found below it's
> commit message).

Since I assume nobody likes to apply the patches individually and
compile the sources just to see the difference in man page output, here
are two screen shots:

After first patch (only font style fix):
http://nwl.cc/~n0-1/nft.8_style_fix.png
(No idea how one could add hints for better spots to break long lines.)

After the second one (with added indirections):
http://nwl.cc/~n0-1/nft.8_indirection.png

Cheers, Phil
