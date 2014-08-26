From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nft option to flush out the existing ruleset [was Re: [libnftnl
 PATCH] examples: add nft-ruleset-replace]
Date: Tue, 26 Aug 2014 15:47:06 +0200
Message-ID: <20140826134706.GA5913@salvia>
References: <20140826095716.3463.89684.stgit@nfdev.cica.es>
 <20140826110954.GA5648@salvia>
 <20140826121420.GA22955@acer.localdomain>
 <CAOkSjBhHGygRWjY04M-H3JUp8uy5DzOFB7oL219jsHrOQYUsxw@mail.gmail.com>
 <6dbe283a-500c-4897-9ece-68d940ef9ced@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50318 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755163AbaHZNqb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:46:31 -0400
Content-Disposition: inline
In-Reply-To: <6dbe283a-500c-4897-9ece-68d940ef9ced@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 26, 2014 at 02:30:30PM +0100, Patrick McHardy wrote:
> On 26. August 2014 14:12:57 GMT+01:00, Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> >On 26 August 2014 14:14, Patrick McHardy <kaber@trash.net> wrote:
> >> On Tue, Aug 26, 2014 at 01:09:54PM +0200, Pablo Neira Ayuso wrote:
> >>> Renaming the subject to make it to start a new discussion on
> >something
> >>> related. Cc'ing Patrick too, perhaps he can pull some better idea
> >out
> >>> of his hat.
> >>>
> >>> On Tue, Aug 26, 2014 at 11:57:16AM +0200, Arturo Borrero Gonzalez
> >wrote:
> >>> > This code examples uses the new NFT_MSG_DELTABLE functionality to
> >replace
> >>> > an entire ruleset in a single transaction/batch.
> >>>
> >>> Thanks for the example but we already have quite a lot of them, and
> >>> this is yet another almost copy and paste that would need to be
> >>> maintained.
> >>>
> >>> Please, implement this in nft. I think we can probably have an -x
> >>> option, eg.
> >>
> >> Agreed. The naive aproach seems to be something like this:
> >>
> >> - add a generation ID to the ruleset
> >> - dump the entire ruleset
> >> - generate delete commands for each existing rule/chain/set...
> >> - generate add commands for each new rule/chain/set...
> >> - send the entire thing to the kernel, including the generation ID
> >> - if the generation ID doesn't match, meaning the ruleset has changed
> >>   since the last dump, return an error to userspace, retry
> >
> >The approach in my patchset is different:
> >
> >- generate a delete command that will flush all the previous ruleset
> >- generate add commands for each new rule/chain/set/tables
> >- send the batch to the kernel
> >
> >In this approach, we don't care about what is in the kernel previous
> >to the delete command.
> 
> Sure, but as Pablo pointed out, it adds more code that needs to be maintained that isn't strictly neccessary.

Oh, I probably didn't explain well myself. I'd like to see Arturo's
shortcut using _DELTABLE unless you have any concern with them :-).

We still need that generation ID indeed to catch interferences between
two object dumps, I'll send you a patch proposal for this soon.
