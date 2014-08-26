From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Tue, 26 Aug 2014 15:38:33 +0200
Message-ID: <20140826133833.GC5806@salvia>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es>
 <20140826110954.GA5648@salvia>
 <20140826121420.GA22955@acer.localdomain>
 <CAOkSjBhHGygRWjY04M-H3JUp8uy5DzOFB7oL219jsHrOQYUsxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49462 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754772AbaHZNiJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:38:09 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhHGygRWjY04M-H3JUp8uy5DzOFB7oL219jsHrOQYUsxw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 26, 2014 at 03:12:57PM +0200, Arturo Borrero Gonzalez wrote:
> On 26 August 2014 14:14, Patrick McHardy <kaber@trash.net> wrote:
> > On Tue, Aug 26, 2014 at 01:09:54PM +0200, Pablo Neira Ayuso wrote:
> >> Renaming the subject to make it to start a new discussion on something
> >> related. Cc'ing Patrick too, perhaps he can pull some better idea out
> >> of his hat.
> >>
> >> On Tue, Aug 26, 2014 at 11:57:16AM +0200, Arturo Borrero Gonzalez wrote:
> >> > This code examples uses the new NFT_MSG_DELTABLE functionality to replace
> >> > an entire ruleset in a single transaction/batch.
> >>
> >> Thanks for the example but we already have quite a lot of them, and
> >> this is yet another almost copy and paste that would need to be
> >> maintained.
> >>
> >> Please, implement this in nft. I think we can probably have an -x
> >> option, eg.
> >
> > Agreed. The naive aproach seems to be something like this:
> >
> > - add a generation ID to the ruleset
> > - dump the entire ruleset
> > - generate delete commands for each existing rule/chain/set...
> > - generate add commands for each new rule/chain/set...
> > - send the entire thing to the kernel, including the generation ID
> > - if the generation ID doesn't match, meaning the ruleset has changed
> >   since the last dump, return an error to userspace, retry
> 
> The approach in my patchset is different:
> 
> - generate a delete command that will flush all the previous ruleset
> - generate add commands for each new rule/chain/set/tables
> - send the batch to the kernel

We're still going to require the generation ID anyway to catch
interferences between rule updates and rule dumping. My plan is to
make a patch to include this in the nfgenmsg->res_id when dumping the
objects to userspace. The NLM_F_DUMP_INTR is partially solving the
problem for us, but we really need that generation ID to catch changes
between two object dumps.

Anyway I think both approaches are compatible. The one Arturo is
working should be faster if the kernel supports the flusing from the
nfnl mutex. I think nft should make it the way Patrick proposes if the
kernel doesn't support this command (ie. if it hits -EBUSY when trying
to flush a table).
