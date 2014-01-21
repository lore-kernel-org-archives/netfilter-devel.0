From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 11:32:32 +0000
Message-ID: <20140121113232.GA26403@macbook.localnet>
References: <20140121110645.GC25197@macbook.localnet>
 <20140121112700.GA21772@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38516 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353AbaAULcg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:32:36 -0500
Content-Disposition: inline
In-Reply-To: <20140121112700.GA21772@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 12:27:00PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 21, 2014 at 11:06:46AM +0000, Patrick McHardy wrote:
> > We currently only support "add table" and "add chain" with NLM_F_EXCL.
> > This means we can't replace entire tables without a lot of extra effort,
> > also its not possible to create tables/chains just in case they don't
> > already exist.
> > 
> > To fix this, I'd propose to add two new commands, so we have the following:
> > 
> > - add: add without NLM_F_EXCL
> > - create: add with NLM_F_EXCL
> > - replace: replace the entire thing
> 
> I guess you have in mind to simplify current reloading via nft -f.
> Currently, we have to manually flush and delete chain/tables at this
> moment, which is a bit of PITA.

Correct. It would also make creation of the predefined tables a lot less
error prone.

> > This most likely will also require updates to the transaction handling
> > so we don't only process rules, but table, chain and set updates in a
> > transaction.
> >
> > Comments?
> 
> It would be indeed nice if we handle table/chain updates in the same
> batch like the rules. I think we can find a way to keep the current
> .call hook there so we allow both table/chain updates via batch and
> via simple independent commands.

Yes, that should be possible. We'd also need it for sets. I guess the
semantics would be:

- NLM_F_REPLACE: apply the entire batch to the newly created objects, IOW
  ignore everything that already exists in the table

- !NLM_F_REPLACE: apply the batch to existing or new objects

