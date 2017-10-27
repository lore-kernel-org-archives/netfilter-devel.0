From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft 1/8] tests: adjust output to silence warnings
Date: Fri, 27 Oct 2017 20:03:19 +0200
Message-ID: <20171027180319.GP19457@breakpoint.cc>
References: <20171026230611.14269-1-fw@strlen.de>
 <20171026230611.14269-2-fw@strlen.de>
 <20171027102906.GA14147@salvia>
 <20171027125202.GO19457@breakpoint.cc>
 <20171027140719.GC25244@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35708 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751701AbdJ0SDi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Oct 2017 14:03:38 -0400
Content-Disposition: inline
In-Reply-To: <20171027140719.GC25244@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Oct 27, 2017 at 02:52:02PM +0200, Florian Westphal wrote:
> We probably need to make an initial pass of the entire rule, populate
> context, then kill these dependencies once we have a global view on
> what is being expressed there. Make sense to you?

Yes, unfortunately I won't have time to work on that anytime soon.
