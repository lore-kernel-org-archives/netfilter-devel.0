From: Matthew Wilcox <willy@infradead.org>
Subject: Re: linux-next: build failure after merge of the ida tree
Date: Wed, 18 Jul 2018 06:31:26 -0700
Message-ID: <20180718133126.GD4949@bombadil.infradead.org>
References: <20180718165406.6f262266@canb.auug.org.au>
 <20180718092426.mxdti3jes5jsssta@salvia>
 <20180718131446.GC4949@bombadil.infradead.org>
 <20180718132746.txspsjvw3xxlqtey@salvia>
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
In-Reply-To: <20180718132746.txspsjvw3xxlqtey@salvia>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 18, 2018 at 03:27:46PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Jul 18, 2018 at 06:14:46AM -0700, Matthew Wilcox wrote:
> > So Varsha, if you would like to take a look at transforming table->sets
> > from a LIST_HEAD to an IDR, I think that would be a great use of your
> > time.
> 
> Please, don't do so, we don't need a radix tree datastructure, it's
> just more complexity.

It's no more complex to use than the list_* macros.

> We just wanted to have a simple way to allocate IDs using a bitmap
> structure in the background without reinventing the wheel.
