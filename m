From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 14:54:35 +0100
Message-ID: <20140110135435.GA18191@localhost>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
 <20140110131406.GA8088@macbook.localnet>
 <CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
 <20140110132703.GA8224@macbook.localnet>
 <CAKfDRXi5v27Tiazb78rA6v7YrAFqXz+kMEZgeE9jJb1whwnYvQ@mail.gmail.com>
 <20140110134342.GA8720@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kristian Evensen <kristian.evensen@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34131 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaAJNym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:54:42 -0500
Content-Disposition: inline
In-Reply-To: <20140110134342.GA8720@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 01:43:43PM +0000, Patrick McHardy wrote:
> On Fri, Jan 10, 2014 at 02:33:06PM +0100, Kristian Evensen wrote:
> > Hi,
> > 
> > On Fri, Jan 10, 2014 at 2:27 PM, Patrick McHardy <kaber@trash.net> wrote:
> > > No, I'm refering to the (ab)use of the expression. Anything not returning
> > > data is not an expression but a statement.
> > 
> > Ok, then I follow :) I followed the naming in meta, but I agree. What
> > would be a good naming convetion? I thought of something like
> > nft_expr_stmt_*. It is a bit clumsy, but it is at least clear that the
> > struct can be used to represent both an expression and a statement.
> 
> nft_ct_stmt? This is what we use in nftables f.i. in case of meta.

Perhaps nft_ct_instr? So we can identify this as the nftables
instruction-set.
