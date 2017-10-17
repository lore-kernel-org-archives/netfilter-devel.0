From: Phil Sutter <phil@nwl.cc>
Subject: Re: [libnftnl PATCH v2] expr: Introduce nftnl_expr_fprintf()
Date: Tue, 17 Oct 2017 14:02:22 +0200
Message-ID: <20171017120222.GW32305@orbyte.nwl.cc>
References: <20171017110507.GA16060@salvia>
 <20171017112218.14539-1-phil@nwl.cc>
 <20171017113150.GA8818@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:39632 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933308AbdJQMCX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 08:02:23 -0400
Content-Disposition: inline
In-Reply-To: <20171017113150.GA8818@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Actually, I don't quite get the suggested change:

On Tue, Oct 17, 2017 at 01:31:50PM +0200, Pablo Neira Ayuso wrote:
> @@ -308,3 +307,7 @@ global:
>  
>  local: *;
>  };
> +
> +LIBNFTNL_6 {
> +  nftnl_expr_fprintf;
> +} LIBMNL_5;

Why LIBMNL_5? Shouldn't this be LIBNFTNL_5?

Cheers, Phil
