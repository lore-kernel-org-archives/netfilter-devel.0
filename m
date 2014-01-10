From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 15:32:52 +0100
Message-ID: <20140110143252.GA3879@localhost>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
 <20140110131406.GA8088@macbook.localnet>
 <CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
 <20140110132703.GA8224@macbook.localnet>
 <CAKfDRXi5v27Tiazb78rA6v7YrAFqXz+kMEZgeE9jJb1whwnYvQ@mail.gmail.com>
 <20140110134342.GA8720@macbook.localnet>
 <20140110135435.GA18191@localhost>
 <20140110135800.GA8854@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kristian Evensen <kristian.evensen@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41040 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbaAJOc7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:32:59 -0500
Content-Disposition: inline
In-Reply-To: <20140110135800.GA8854@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 01:58:01PM +0000, Patrick McHardy wrote:
> On Fri, Jan 10, 2014 at 02:54:35PM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Jan 10, 2014 at 01:43:43PM +0000, Patrick McHardy wrote:
> > > On Fri, Jan 10, 2014 at 02:33:06PM +0100, Kristian Evensen wrote:
> > > > Hi,
> > > > 
> > > > On Fri, Jan 10, 2014 at 2:27 PM, Patrick McHardy <kaber@trash.net> wrote:
> > > > > No, I'm refering to the (ab)use of the expression. Anything not returning
> > > > > data is not an expression but a statement.
> > > > 
> > > > Ok, then I follow :) I followed the naming in meta, but I agree. What
> > > > would be a good naming convetion? I thought of something like
> > > > nft_expr_stmt_*. It is a bit clumsy, but it is at least clear that the
> > > > struct can be used to represent both an expression and a statement.
> > > 
> > > nft_ct_stmt? This is what we use in nftables f.i. in case of meta.
> > 
> > Perhaps nft_ct_instr? So we can identify this as the nftables
> > instruction-set.
> 
> Well, expressions also belong to the instruction set. A statement is
> is one (more specific) case of an instruction, as are expressions.
> Why introduce new terminology that isn't used anywhere else so far
> if statement is the exact description of what this is and is already
> used by nftables.

So are you proposing to add a new object for statements in
libnftables? That will require a new infrastructure which would be
very similar to what we have in the current expressions.

To that extend, that would also require a new infrastructure in the
kernel so we also have statements there. I think one of the good
things of the nf_tables kernel side is that we didn't make any
distinction between matches/targets (or call it
expressions/statements).
