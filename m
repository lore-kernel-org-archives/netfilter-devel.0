From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] test: xml: fix malformed ruleset testfile
Date: Mon, 28 Oct 2013 09:58:07 +0100
Message-ID: <20131028085807.GA3763@localhost>
References: <20131024150058.21634.49651.stgit@nfdev.cica.es>
 <20131027200107.GA6569@localhost>
 <CAOkSjBiwg6WOSMGBVr6QHoy3prt4UkeURiPmrWPG74Zfv9eoOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45703 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754908Ab3J1I6P (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 04:58:15 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBiwg6WOSMGBVr6QHoy3prt4UkeURiPmrWPG74Zfv9eoOw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 28, 2013 at 09:28:22AM +0100, Arturo Borrero Gonzalez wrote:
> On 27 October 2013 21:01, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Oct 24, 2013 at 05:00:58PM +0200, Arturo Borrero Gonzalez wrote:
> >> Give a new XML ruleset testfile. For some reason, the previous was truncated.
> >> This passed silently as nft-parsing-test is not reporting some errors properly.
> >>
> >> This new file provides:
> >>  * 2 tables
> >>  * 3 chains
> >>  * 2 sets, with and without maps
> >>  * 3 rules with mixed exprs
> >
> > Applied, thanks Arturo.
> 
> something went wrong again. The new testfile is also malformed...

Indeed, it's been truncated, I got your patch from patchwork. It seems
it does like too long lines, check:

http://patchwork.ozlabs.org/patch/285934/

Please, send me a new patch, I'll apply directly from your email.
