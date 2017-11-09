From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] libnftables: Unexport enum nftables_exit_codes
Date: Thu, 9 Nov 2017 20:27:12 +0100
Message-ID: <20171109192712.GX32305@orbyte.nwl.cc>
References: <20171024154800.GA11705@salvia>
 <20171109132526.1493-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:36280 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754002AbdKIT1N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2017 14:27:13 -0500
Content-Disposition: inline
In-Reply-To: <20171109132526.1493-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 09, 2017 at 02:25:26PM +0100, Phil Sutter wrote:
> Apart from SUCCESS/FAILURE, these codes were not used by library
> functions simply because NOMEM and NONL conditions lead to calling
> exit() instead of propagating the error condition back up the call
> stack.
> 
> Instead, make nft_run_cmd_from_*() return either 0 or -1 on error.
> Usually errno will then contain more details about what happened and/or
> there are messages in erec.
> 
> Calls to exit() in main() are adjusted to stay compatible.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Please disregard this patch, it accidentally breaks expected fail cases
in tests/shell because main() then returns -1 instead of 1.

I'll prepare a v2.

Sorry, Phil
