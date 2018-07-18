From: Matthew Wilcox <willy@infradead.org>
Subject: Re: linux-next: build failure after merge of the ida tree
Date: Wed, 18 Jul 2018 04:59:19 -0700
Message-ID: <20180718115919.GB4949@bombadil.infradead.org>
References: <20180718165406.6f262266@canb.auug.org.au>
 <20180718092426.mxdti3jes5jsssta@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718092426.mxdti3jes5jsssta@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 18, 2018 at 11:24:26AM +0200, Pablo Neira Ayuso wrote:
> I see, we have no more lockless API for IDA anymore :-(. In our case,
> we were already protected by the the nfnl_lock mutex, which it was
> sufficient to ensure non-concurrent access to IDA structures.

You're actually the first user for whom this is true.  For every other
user, the requirement to manage their own spinlock was a pain.

> Unless I'm missing anything, the new API forces use to the spinlock
> call with disabled irq for each time we update something from the
> netfilter netlink interface, so that's a no-go for us.

I can't believe that's a serious problem for you, though.  You're calling
sscanf(), this can't possibly be a performance path.
