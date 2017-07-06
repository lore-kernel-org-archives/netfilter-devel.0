From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] segtree: Fix expr_value_cmp()
Date: Thu, 6 Jul 2017 16:48:32 +0200
Message-ID: <20170706144832.GO16375@orbyte.nwl.cc>
References: <20170706142528.19715-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39515 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751853AbdGFOse (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jul 2017 10:48:34 -0400
Content-Disposition: inline
In-Reply-To: <20170706142528.19715-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 06, 2017 at 04:25:28PM +0200, Phil Sutter wrote:
> Instead of returning the result of mpz_cmp(), this function returned 1
> unless both elements were equal and the first one had
> EXPR_F_INTERVAL_END set.
> 

Fixes: 0e5f289df9080 ("segtree: handle adjacent interval nodes from expr_value_cmp()")

Sorry for the mess. :(

