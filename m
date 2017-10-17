From: Phil Sutter <phil@nwl.cc>
Subject: Re: [libnftnl PATCH v2] expr: Introduce nftnl_expr_fprintf()
Date: Tue, 17 Oct 2017 13:54:20 +0200
Message-ID: <20171017115420.GV32305@orbyte.nwl.cc>
References: <20171017110507.GA16060@salvia>
 <20171017112218.14539-1-phil@nwl.cc>
 <20171017113150.GA8818@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39504 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933044AbdJQLyW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 07:54:22 -0400
Content-Disposition: inline
In-Reply-To: <20171017113150.GA8818@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Oct 17, 2017 at 01:31:50PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Oct 17, 2017 at 01:22:18PM +0200, Phil Sutter wrote:
> > Implement expression printing into a FILE pointer analogous to
> > nftnl_rule_fprintf().
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> > Changes since v1:
> > - Update src/libnftnl.map
> 
> Thanks Phil.
> 
> I think we need to collapse this change to your patch.

Ah, so that is because LIBNFTNL_5 is already released in 1.0.8, right?

Do I have to adjust the respective nftables patch for backwards
compatibility? If so, in which way?

Thanks, Phil

PS: V3 follows in a few seconds.
