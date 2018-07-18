From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux-next: build failure after merge of the ida tree
Date: Wed, 18 Jul 2018 16:25:00 +0200
Message-ID: <20180718142500.5ltqff7ajwmwidhp@salvia>
References: <20180718165406.6f262266@canb.auug.org.au>
 <20180718092426.mxdti3jes5jsssta@salvia>
 <20180718131446.GC4949@bombadil.infradead.org>
 <20180718132746.txspsjvw3xxlqtey@salvia>
 <20180718133126.GD4949@bombadil.infradead.org>
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
In-Reply-To: <20180718133126.GD4949@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 18, 2018 at 06:31:26AM -0700, Matthew Wilcox wrote:
> On Wed, Jul 18, 2018 at 03:27:46PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jul 18, 2018 at 06:14:46AM -0700, Matthew Wilcox wrote:
> > > So Varsha, if you would like to take a look at transforming table->sets
> > > from a LIST_HEAD to an IDR, I think that would be a great use of your
> > > time.
> > 
> > Please, don't do so, we don't need a radix tree datastructure, it's
> > just more complexity.
> 
> It's no more complex to use than the list_* macros.

Problem is that some of the sets that we place in that list may have
no ID.

We basically have two type of sets:

* Sets with names, they have no IDs as the user provides a meaningful
  name from the control plane that can be used to add/delete elements,
  eg. IP addresses.

* Anonymous sets, these are built-in into rules, eg.

  ip saddr { 1.1.1.1, 2.2.2.2 }

  so we generate an ID that we can use to refer to the set.

For our usecase, I'm thinking, if we don't have a simple way to
allocate IDs through this API, we could just simplify our existing
codebase by using an u64 and use incremental id, we don't need to
recycle IDs, so that's one posibility I stop bothering you ;-)

BTW, the anti-pattern we have in our codebase is the same logic that we
have to allocate identifiers with netdevice name, see __dev_alloc_name()
in net/core/dev.c. *Someone* copied + pasted + mangled that original code
to make it fit into netfilter. I guess that code may benefit from a
simple way to allocate IDs without locking dependencies. Just an idea,
not that this is a priority.

Thanks!
