From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2 nft RFC] expression: default to print binary
 operations using nominal representation
Date: Wed, 15 Jan 2014 11:36:14 +0000
Message-ID: <20140115113614.GA18801@macbook.localnet>
References: <1389784167-10198-1-git-send-email-pablo@netfilter.org>
 <20140115111803.GA17728@macbook.localnet>
 <CAOkSjBg+on2TzybwdyaL+foReRgHZ4vA981JLZs4E0k9Dfe3aA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43892 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaAOLgS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:36:18 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBg+on2TzybwdyaL+foReRgHZ4vA981JLZs4E0k9Dfe3aA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 15, 2014 at 12:32:36PM +0100, Arturo Borrero Gonzalez wrote:
> On 15 January 2014 12:18, Patrick McHardy <kaber@trash.net> wrote:
> > On Wed, Jan 15, 2014 at 12:09:26PM +0100, Pablo Neira Ayuso wrote:
> >> Since b59e65c ("scanner: add aliases to symbols for easier
> >> interaction with most shells") we have nominal aliases, default to
> >> these for the output representation.
> >
> > I was thinking about this before, but didn't mention it since you
> > hadn't included it in your first patch. I'd prefer to stick to the
> > IMO more readable existing form. Since we don't support deleting
> > rules by rule specification, there should be no reason to copy and
> > paste the output to the command line again.
> 
> What about a file to be loaded with `nft -f'?
> In fact, I think most of users will end with a config file to load
> with `nft -f'.

Indeed, and those users don't need the long syntax since the shell is
not involved.

> It may be annoying getting the output different to what you wrote.

That may happen for other reasons anyways, especially with binops we
optimize away redundant expressions and calculate constants in userspace.

> I think this patch means that the symbol-free syntax is the default,
> and I personally like that.

I don't, its longer and harder to read. It has its justification for
parsing on the command line, but as you say, most users won't use it
that way.
