From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 1/2] parser_bison: dismiss anonymous meters
Date: Fri, 24 Nov 2017 14:56:49 +0100
Message-ID: <20171124135649.GA17459@breakpoint.cc>
References: <20171124132900.28301-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35356 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752619AbdKXN5w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Nov 2017 08:57:52 -0500
Content-Disposition: inline
In-Reply-To: <20171124132900.28301-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> The former 'flow table' syntax allows flow tables with no name:
> 
>  # nft add rule x y flow { ip saddr counter }
> 
> However, when listing, it leaks the name that it is autoallocating.
> 
>  # nft list ruleset
>  table ip x {
>         chain y {
>                 flow table __mt0 { ip saddr counter}
>         }
>  }
> 
> Which is odd since then restoring will use such a name.

Right.

> Remove anonymous flow table/meters, so everyone needs to specify a name.

Acked-by: Florian Westphal <fw@strlen.de>
