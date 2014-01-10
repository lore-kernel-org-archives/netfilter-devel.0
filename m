From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 13:52:36 +0000
Message-ID: <20140110135235.GA8797@macbook.localnet>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
 <20140110131406.GA8088@macbook.localnet>
 <CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
 <20140110132703.GA8224@macbook.localnet>
 <CAKfDRXi5v27Tiazb78rA6v7YrAFqXz+kMEZgeE9jJb1whwnYvQ@mail.gmail.com>
 <20140110134342.GA8720@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59345 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaAJNwk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:52:40 -0500
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

Just to be clear, I'm not only talking about the naming, a statement
is something fundamentally different. Every expression has a value,
which a statement doesn't have. Therefore every expression has a
a value, destination register, byteorder, ..., all of which don't
apply to statements. This is why we have an entire separate class
for this in nftables, and this is what I'm also proposing for
libnftables.
