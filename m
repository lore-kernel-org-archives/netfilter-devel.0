From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Mon, 12 Sep 2016 21:00:25 +0200
Message-ID: <20160912190025.GB11685@breakpoint.cc>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc>
 <20160912185228.GA10862@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:58978 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753128AbcILTA3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 15:00:29 -0400
Content-Disposition: inline
In-Reply-To: <20160912185228.GA10862@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>         fib lookup ip daddr . oif
> 
> As you are basically looking for the route based on IPv4 address and
> the output interface, so this boils down to:
> 
>         fib lookup $expr $flags

How would the kernel disentangle the register data?
(i.e., how do i know where in the sreg e.g. the daddr is
 that i need to stuff in the flowi struct?)
