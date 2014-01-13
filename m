From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft PATCH] syntax: replace '=>' with '=:'
Date: Mon, 13 Jan 2014 11:44:34 +0100
Message-ID: <20140113104434.GA4594@localhost>
References: <20140112194132.7369.3907.stgit@nfdev.cica.es>
 <20140112201742.GC13545@macbook.localnet>
 <CAOkSjBiSMubzv=eTou5O7W9mW_h=w77-iaMcCNCGMECLCQn2Hg@mail.gmail.com>
 <20140112212454.GA15677@macbook.localnet>
 <CAOkSjBghK7xhMpQHU48siS7GGzj+RhawK3dOLGLTxopZBv1=VA@mail.gmail.com>
 <20140112215511.GB15677@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33706 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751246AbaAMKot (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 05:44:49 -0500
Content-Disposition: inline
In-Reply-To: <20140112215511.GB15677@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 09:55:12PM +0000, Patrick McHardy wrote:
> > If you don't like '=:', what about:
> > '--'
> > '-:'
> > '---'
> > '--:'
> > or
> > ':--'
> 
> Neither of. Too long, and for a mapping ':' or '=>' seem a reasonable
> choice. ':=' is more like an assignment, which doesn't fit too well.
>
> I'd say go for ':', if the user doesn't insert spaces and can't read
> his own rules anymore, his fault.

I like ':' is used in python dictinaries too. Erlang uses ',' as
separator and ruby was using the '=>' that causes some troubles with
bash if not escaped. I think there is not chance for ambiguity, but
I'm going to make more tests and get back to you.
