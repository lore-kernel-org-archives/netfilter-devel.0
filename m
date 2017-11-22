From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 2/4] netfilter: add BUILD_BUG_ON asserts for hook
 array sizes
Date: Wed, 22 Nov 2017 13:44:10 +0100
Message-ID: <20171122124410.GI24866@breakpoint.cc>
References: <20171113164107.11259-1-fw@strlen.de>
 <20171113164107.11259-3-fw@strlen.de>
 <20171122122025.GA29456@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:54922 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751207AbdKVMpK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 07:45:10 -0500
Content-Disposition: inline
In-Reply-To: <20171122122025.GA29456@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Mon, Nov 13, 2017 at 05:41:05PM +0100, Florian Westphal wrote:
> > Check that the array hooks are not accessed out-of-bounds.
> > Next patch will then reduce their sizes to reflect the number
> > of hooks implemented for each family.
> 
> I'm hitting this here.
> 
> In file included from ./include/linux/kernel.h:10:0,
>                  from ./include/linux/uio.h:12,
>                  from ./include/linux/socket.h:8,
>                  from net/decnet/dn_route.c:60:
> In function ‘nf_hook.constprop’,
>     inlined from ‘NF_HOOK.constprop’ at
> ./include/linux/netfilter.h:279:6:
> ./include/linux/compiler.h:319:38: error: call to
> ‘__compiletime_assert_221’ declared with attribute error: BUILD_BUG_ON
> failed: hook >= ARRAY_SIZE(net->nf.hooks_decnet)
>   _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

Thanks for the report, I guess gcc doesn't follow inline trail
or argument isn't known at compile time.

I'll add a contant_p() test as well in v2.
