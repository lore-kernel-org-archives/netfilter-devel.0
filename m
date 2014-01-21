From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 11:45:25 +0000
Message-ID: <20140121114524.GA27552@macbook.localnet>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38606 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754023AbaAULpc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:45:32 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 12:37:52PM +0100, Arturo Borrero Gonzalez wrote:
> On 21 January 2014 12:27, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Jan 21, 2014 at 11:06:46AM +0000, Patrick McHardy wrote:
> >> We currently only support "add table" and "add chain" with NLM_F_EXCL.
> >> This means we can't replace entire tables without a lot of extra effort,
> >> also its not possible to create tables/chains just in case they don't
> >> already exist.
> >>
> >> To fix this, I'd propose to add two new commands, so we have the following:
> >>
> >> - add: add without NLM_F_EXCL
> >> - create: add with NLM_F_EXCL
> >> - replace: replace the entire thing
> >
> > I guess you have in mind to simplify current reloading via nft -f.
> > Currently, we have to manually flush and delete chain/tables at this
> > moment, which is a bit of PITA.
> >
> 
> I have some old patches to allow operate over the entire ruleset:
>  list ruleset
>  flush ruleset
>  delete ruleset
>  wipe ruleset
> 
> I think they are handy for these situations.
> 
> Think about a 'ruleset.nft' file starting like this:
> ==== 8< ====
> wipe ruleset
> table ip filter {
> [...]
> }
> table ip6 filter {
> [...]
> }
> ==== 8< ====
> 
> Then, the load via `nft -f' could be straightforward.
> Let me know if you want me to reboot them and resend.

That only helps for the case of loading an entire new ruleset. There are
also many cases where you simply want to create an object iff it doesn't
already exist, but not flush it otherwise. The predefined tables are an
example of this. The second issue is that it would be non-atomic, so
between flush and creating the new ruleset, we'd not have any active rules.

I think the semantics of "flush table" should be changed though. It should
kill *every* object in the table. Perhaps not the base chains, but at least
all rules, non base chain and also sets.
