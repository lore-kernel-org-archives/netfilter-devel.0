From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: build failure after merge of the ida tree
Date: Wed, 18 Jul 2018 15:27:46 +0200
Message-ID: <20180718132746.txspsjvw3xxlqtey@salvia>
References: <20180718165406.6f262266@canb.auug.org.au>
 <20180718092426.mxdti3jes5jsssta@salvia>
 <20180718131446.GC4949@bombadil.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Varsha Rao <rvarsha016@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180718131446.GC4949@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 18, 2018 at 06:14:46AM -0700, Matthew Wilcox wrote:
> On Wed, Jul 18, 2018 at 11:24:26AM +0200, Pablo Neira Ayuso wrote:
> > > interacting with commit
> > > 
> > >   9679150a0bd5 ("netfilter: nf_tables: Use id allocation")
> > > 
> > > from the netfilter-next tree.
> > 
> > @Varsha, I'm very sorry, but I guess I have to toss your patch, I
> > would prefer avoid dependencies with the IDA API by now.
> 
> I've had a chance to read this patch a bit more carefully.  It transforms
> one anti-pattern into another, so I can't say I'm a fan.
> 
> The first is specific to the networking code; having a list of things
> with IDs, and constructing a bitmap when we need to allocate a new ID.
> 
> The second is having both an IDA and a list of things.
> 
> The more effective way to do all of this is to use an IDR.  You can get
> rid of the linked list *and* the IDA, and it's faster to iterate over.
> The root of the IDR is the same size as the list_head, and then you need
> only store the 4-byte ID in each element instead of the 16-byte list_head.
> 
> So Varsha, if you would like to take a look at transforming table->sets
> from a LIST_HEAD to an IDR, I think that would be a great use of your
> time.

Please, don't do so, we don't need a radix tree datastructure, it's
just more complexity.

We just wanted to have a simple way to allocate IDs using a bitmap
structure in the background without reinventing the wheel.
