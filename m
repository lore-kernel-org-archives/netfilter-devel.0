From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft] src: add nft_ prefix to everything exposed through
 include/nftables/nftables.h
Date: Tue, 24 Oct 2017 18:28:45 +0200
Message-ID: <20171024162845.GO32305@orbyte.nwl.cc>
References: <20171024152102.31990-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35564 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932236AbdJXQ2r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:28:47 -0400
Content-Disposition: inline
In-Reply-To: <20171024152102.31990-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 24, 2017 at 05:21:02PM +0200, Pablo Neira Ayuso wrote:
> Prepend nft_ prefix before these are exposed, reduce chances we hit
> symbol namespace pollution problems when mixing libnftables with other
> existing libraries.
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks for sorting this for me,

Phil
