From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: build failure after merge of the ida tree
Date: Wed, 18 Jul 2018 11:24:26 +0200
Message-ID: <20180718092426.mxdti3jes5jsssta@salvia>
References: <20180718165406.6f262266@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Matthew Wilcox <willy@infradead.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varsha Rao <rvarsha016@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718165406.6f262266@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Matthew, Stephen,

On Wed, Jul 18, 2018 at 04:54:06PM +1000, Stephen Rothwell wrote:
> Hi Matthew,
> 
> After merging the ida tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> net/netfilter/nf_tables_api.c: In function 'nf_tables_set_alloc_name':
> net/netfilter/nf_tables_api.c:3014:8: error: implicit declaration of function 'ida_get_new_above'; did you mean 'idr_get_next_ul'? [-Werror=implicit-function-declaration]
>     n = ida_get_new_above(&inuse, tmp, &id);
>         ^~~~~~~~~~~~~~~~~
>         idr_get_next_ul
> 
> Caused by commit
> 
>   3f2668c1e101 ("ida: Remove old API")

I see, we have no more lockless API for IDA anymore :-(. In our case,
we were already protected by the the nfnl_lock mutex, which it was
sufficient to ensure non-concurrent access to IDA structures.

Unless I'm missing anything, the new API forces use to the spinlock
call with disabled irq for each time we update something from the
netfilter netlink interface, so that's a no-go for us.

> interacting with commit
> 
>   9679150a0bd5 ("netfilter: nf_tables: Use id allocation")
> 
> from the netfilter-next tree.

@Varsha, I'm very sorry, but I guess I have to toss your patch, I
would prefer avoid dependencies with the IDA API by now.
