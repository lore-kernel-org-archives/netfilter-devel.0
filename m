From: Patrick McHardy <kaber@trash.net>
Subject: Re: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Mon, 1 Sep 2014 16:17:32 +0100
Message-ID: <20140901151731.GA19729@acer.localdomain>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es>
 <20140826110954.GA5648@salvia>
 <CAOkSjBhJQGyJOJ=VwZmr-vhtPF5LRiCqD54XfOteHDo68X4dWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55220 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaIAPRh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:17:37 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhJQGyJOJ=VwZmr-vhtPF5LRiCqD54XfOteHDo68X4dWw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 01, 2014 at 05:07:23PM +0200, Arturo Borrero Gonzalez wrote:
> On 26 August 2014 13:09, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Please, implement this in nft. I think we can probably have an -x
> > option, eg.
> >
> > nft -f -x ruleset-file
> >
> > The '-x' indicates that you want to flush any previous existing
> > configuration before loading this 'ruleset-file'.
> >
> > -xx could also be used to remove any configuration regarding the
> > existing families in the ruleset-file, ie. if the ruleset-file only
> > contains a configuration for 'ip', all remaining families are left
> > untouched.
> >
> 
> Hi Pablo, Patrick.
> 
> I've looked into how to implement this '-x' option.
> 
> I wonder if it worth having better a "formal" command, like
>  % nft flush ruleset
>  % nft flush ruleset ip
>  % nft flush ruleset ip6
>  % nft flush ruleset arp
>  [...]
> 
> This way, a user loading a new ruleset with -f can just put a first
> line like this:
> 
> =========
> nft flush ruleset
> nft add table ip filter
> nft add chain ip filter input
> nft add rule ip filter input counter
> nft add table ip6 filter
> nft add chain ip6 filter input
> [...]
> =========
> 
> Or flush per family, as Pablo suggested:
> 
> =========
> nft flush ruleset inet
> nft add table inet filter
> [...]
> =========
> 
> Some benefits of this approach is that we have a concrete order to
> flush the ruleset, in the case the user wants no ruleset.
> The lack of this shortcut seem an actual concern of some users.

I agree, this sounds better than a command line option.
