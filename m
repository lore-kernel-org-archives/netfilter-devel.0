From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/7] netfilter: nf_tables: deconstify table and chain in
 context structure
Date: Fri, 28 Mar 2014 13:57:41 +0100
Message-ID: <20140328125741.GA13685@localhost>
References: <1395957197-4899-1-git-send-email-pablo@netfilter.org>
 <1395957197-4899-2-git-send-email-pablo@netfilter.org>
 <20140328124229.GB7895@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47413 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaC1NPc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:15:32 -0400
Content-Disposition: inline
In-Reply-To: <20140328124229.GB7895@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 12:42:29PM +0000, Patrick McHardy wrote:
> On Thu, Mar 27, 2014 at 10:53:11PM +0100, Pablo Neira Ayuso wrote:
> > The new transaction infrastructure updates the family, table and chain
> > objects in the context structure, so let's deconstify them. While at it,
> > move the context structure initialization routine to the top of the
> > source file as it will be also used from the table and chain routines.
> 
> I would prefer to keep the consts for the context, but I'm fine with it
> if we don't find a clean other way. Basically I'd suggest to use your
> patch if we have functions that are called from both the transaction
> code and non-transaction code, IOW need the nft_ctx structure.
> Otherwise, if this stuff is only used by the transaction code, we could
> add the individual members to the transaction as non-consts.

This is being used from both transaction and non-transaction code. I
initially casted this to non-const as a workaround to calm down gcc,
but at some point I needed the list handling to add and to remove
elements from the lists which was quite ugly. I liked those compile
time checkings that we were getting before this.

Another possibility is to add some nft_ctx_trans which would look very
similar to nft_ctx, but in some cases we would need to define both
nft_ctx and nft_ctx_trans, which doesn't look very nice either. So I
don't see a better way to make this at this moment.
