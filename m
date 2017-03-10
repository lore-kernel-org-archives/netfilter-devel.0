From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: netfilter: conntrack: refine gc worker heuristics, redux
Date: Fri, 10 Mar 2017 09:36:56 +0100
Message-ID: <20170310083656.GB19350@kroah.com>
References: <20170301153732.GA7680@salvia>
 <20170301155841.GC24798@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170301155841.GC24798@breakpoint.cc>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Mar 01, 2017 at 04:58:41PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Hi Greg,
> > 
> > Please cherry-pick this into 4.9.
> > 
> > commit e5072053b09642b8ff417d47da05b84720aea3ee
> > Author: Florian Westphal <fw@strlen.de>
> > Date:   Wed Jan 18 02:01:22 2017 +0100
> > 
> >     netfilter: conntrack: refine gc worker heuristics, redux
> 
> Note: This applies cleanly if you also pick
> 
> commit 524b698db06b9b6da7192e749f637904e2f62d7b
> Author: Florian Westphal <fw@strlen.de>
> Date:   Mon Jan 16 18:24:56 2017 +0100
> 
>     netfilter: conntrack: remove GC_MAX_EVICTS break
> 
> before this one.

Thanks, both now queued up.

greg k-h
