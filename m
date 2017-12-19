From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf] netfilter: nf_tables: fix chain filter in
 nf_tables_dump_rules()
Date: Tue, 19 Dec 2017 12:21:51 +0100
Message-ID: <20171219112151.GR32305@orbyte.nwl.cc>
References: <20171219110443.3286-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43712 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936130AbdLSLVw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 06:21:52 -0500
Content-Disposition: inline
In-Reply-To: <20171219110443.3286-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 19, 2017 at 12:04:43PM +0100, Pablo Neira Ayuso wrote:
> ctx->chain may be null now that we have very large object names,
> so we cannot check for ctx->chain[0] here.
> 
> Fixes: e46abbcc05aa ("netfilter: nf_tables: Allow table names of up to 255 chars")

This really fixes:

b7263e071aba7 ("netfilter: nf_tables: Allow chain name of up to 255 chars")

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Apart from that:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
