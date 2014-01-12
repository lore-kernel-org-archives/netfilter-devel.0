From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC nft PATCH] syntax: replace '=>' with '=:'
Date: Sun, 12 Jan 2014 21:55:12 +0000
Message-ID: <20140112215511.GB15677@macbook.localnet>
References: <20140112194132.7369.3907.stgit@nfdev.cica.es>
 <20140112201742.GC13545@macbook.localnet>
 <CAOkSjBiSMubzv=eTou5O7W9mW_h=w77-iaMcCNCGMECLCQn2Hg@mail.gmail.com>
 <20140112212454.GA15677@macbook.localnet>
 <CAOkSjBghK7xhMpQHU48siS7GGzj+RhawK3dOLGLTxopZBv1=VA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50610 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbaALVzQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:55:16 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBghK7xhMpQHU48siS7GGzj+RhawK3dOLGLTxopZBv1=VA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 10:47:01PM +0100, Arturo Borrero Gonzalez wrote:
> On 12 January 2014 22:24, Patrick McHardy <kaber@trash.net> wrote:
> >
> > IPv6 addresses are recognized by the parser, so it should be fine. I just
> > compile tested this patch, at least bison doesn't report any errors.
> >
> 
> '=:' works also as a visual separator.
> 
> If using ':', in the case of IPv6, we can end with:
> 2a00:9ac0:c1ca:27::150:123
> 
> Bison may detect it wisely, but I don't know where the address
> start/ends, don't you?
> 
> Or we can force/require a space in the syntax:
> 2a00:9ac0:c1ca:27::150 : 123
> 
> If we decide to use ':', this last case is better, IMHO.

We don't need to enforce this IMO. Any reasonable user will most likely
add the space himself. If not, no problem, as long as there is no ambiguity.

> If you don't like '=:', what about:
> '--'
> '-:'
> '---'
> '--:'
> or
> ':--'

Neither of. Too long, and for a mapping ':' or '=>' seem a reasonable
choice. ':=' is more like an assignment, which doesn't fit too well.

I'd say go for ':', if the user doesn't insert spaces and can't read
his own rules anymore, his fault.
