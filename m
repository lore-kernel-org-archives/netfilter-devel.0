From: Florian Westphal <fw@strlen.de>
Subject: Re: linux-next: build warning after merge of the netfilter-next tree
Date: Tue, 8 May 2018 09:17:56 +0200
Message-ID: <20180508071756.grie5wln2lpo52un@breakpoint.cc>
References: <20180507105519.1d34f19e@canb.auug.org.au>
 <20180508102101.768d5c52@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180508102101.768d5c52@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> On Mon, 7 May 2018 10:55:19 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > After merging the netfilter-next tree, today's linux-next build (x86_64
> > allmodconfig) produced this warning:
> > 
> > ./usr/include/linux/netfilter/nf_osf.h:25: found __[us]{8,16,32,64} type without #include <linux/types.h>
>
> > Introduced by commit
> > 
> >   bfb15f2a95cb ("netfilter: extract Passive OS fingerprint infrastructure from xt_osf")

I'll send a fix for this, thanks for reporting.
