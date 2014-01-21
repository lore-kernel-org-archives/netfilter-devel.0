From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 12:27:00 +0100
Message-ID: <20140121112700.GA21772@localhost>
References: <20140121110645.GC25197@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54843 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754023AbaAUL2I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 06:28:08 -0500
Content-Disposition: inline
In-Reply-To: <20140121110645.GC25197@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 11:06:46AM +0000, Patrick McHardy wrote:
> We currently only support "add table" and "add chain" with NLM_F_EXCL.
> This means we can't replace entire tables without a lot of extra effort,
> also its not possible to create tables/chains just in case they don't
> already exist.
> 
> To fix this, I'd propose to add two new commands, so we have the following:
> 
> - add: add without NLM_F_EXCL
> - create: add with NLM_F_EXCL
> - replace: replace the entire thing

I guess you have in mind to simplify current reloading via nft -f.
Currently, we have to manually flush and delete chain/tables at this
moment, which is a bit of PITA.

> This most likely will also require updates to the transaction handling
> so we don't only process rules, but table, chain and set updates in a
> transaction.
>
> Comments?

It would be indeed nice if we handle table/chain updates in the same
batch like the rules. I think we can find a way to keep the current
.call hook there so we allow both table/chain updates via batch and
via simple independent commands.
