From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2,1/2] netfilter: nft_exthdr: Add support for
 existence check
Date: Tue, 7 Feb 2017 23:47:05 +0100
Message-ID: <20170207224705.GL22796@orbyte.nwl.cc>
References: <1486498828-17936-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, mm@skelett.io
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:33459 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752868AbdBGWyk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Feb 2017 17:54:40 -0500
Content-Disposition: inline
In-Reply-To: <1486498828-17936-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, Feb 07, 2017 at 09:20:27PM +0100, Pablo Neira Ayuso wrote:
> From: Phil Sutter <phil@nwl.cc>
> 
> If NFT_EXTHDR_F_PRESENT is set, exthdr will not copy any header field
> data into *dest, but instead set it to 1 if the header is found and 0
> otherwise.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Phil: I have enhanced your patch shrink flags to u8, also check for
>        unexisting flags. As well as the sparse warning. Please review
>        if this looks good to you. Thanks.

Yes, looks good to me!

Thanks, Phil
