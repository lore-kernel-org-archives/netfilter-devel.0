From: Florian Westphal <fw@strlen.de>
Subject: Re: netfilter: conntrack: refine gc worker heuristics, redux
Date: Wed, 1 Mar 2017 16:58:41 +0100
Message-ID: <20170301155841.GC24798@breakpoint.cc>
References: <20170301153732.GA7680@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:40110 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751979AbdCAQCF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 11:02:05 -0500
Content-Disposition: inline
In-Reply-To: <20170301153732.GA7680@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Greg,
> 
> Please cherry-pick this into 4.9.
> 
> commit e5072053b09642b8ff417d47da05b84720aea3ee
> Author: Florian Westphal <fw@strlen.de>
> Date:   Wed Jan 18 02:01:22 2017 +0100
> 
>     netfilter: conntrack: refine gc worker heuristics, redux

Note: This applies cleanly if you also pick

commit 524b698db06b9b6da7192e749f637904e2f62d7b
Author: Florian Westphal <fw@strlen.de>
Date:   Mon Jan 16 18:24:56 2017 +0100

    netfilter: conntrack: remove GC_MAX_EVICTS break

before this one.
