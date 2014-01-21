From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables add vs replace
Date: Tue, 21 Jan 2014 15:10:40 +0000
Message-ID: <20140121151038.GA6718@macbook.localnet>
References: <20140121112700.GA21772@localhost>
 <CAOkSjBiKGk66N5Ecg8EM27osWVB1Zbn6r-rPu=o8DczjUjpKiA@mail.gmail.com>
 <52DE5E10.5000403@linux.intel.com>
 <20140121114955.GA27718@macbook.localnet>
 <52DE6331.4030902@linux.intel.com>
 <20140121121147.GB30577@macbook.localnet>
 <52DE655B.9020105@linux.intel.com>
 <20140121122532.GA30955@macbook.localnet>
 <52DE6CE5.3000702@linux.intel.com>
 <CAOkSjBhiPh9D7Rj2J5gwJK7njwFLjBUUuDQC6U+VHitjaOhPYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40204 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754931AbaAUPKp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 10:10:45 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhiPh9D7Rj2J5gwJK7njwFLjBUUuDQC6U+VHitjaOhPYw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 21, 2014 at 03:05:36PM +0100, Arturo Borrero Gonzalez wrote:
> On 21 January 2014 13:49, Tomasz Bursztyka
> <tomasz.bursztyka@linux.intel.com> wrote:
> >
> > I messed up on how this replace command could be used, never mind then.
> >
> 
> Well, I was working on these ops:
> 
> % nft export <xml|json>
> % nft import <xml|json>
> 
> The `export' patch is in shape (i'm sending it right now for you to review).

Yep, looks pretty good, please see my comments in my reply.

> The problem comes in the `import' operation.
> I think that importing the ruleset means that any previous ruleset is
> wiped, and I'm working in that way.

Yes, that seems reasonable.

> In my import code, I flush rules (with a batch), then query sets,
> delete each one, query chains, delete each and query tables, delete.
> (then add the ruleset)
> 
> I surprisingly discovered that when deleting tables, I get EBUSY:
> 
> if (!list_empty(&table->chains) || !list_empty(&table->sets))
>    return -EBUSY;
> 
> because the set list is not empty.
> But if I add in my code a sleep(1); between deleting sets and deleting
> tables, then all go fine.
> 
> Is this the race condition you were referring to, Patrick? I can send
> the `import' patch if you want.

Hmm that seems very odd, we're not using RCU for freeing sets or something
(even in that case it would be a bug, but at least explainable).

Please send your patch, I'll have a look.

Regarding the race condition, I'm referring to the time between the time
where you start dumping and removing things and the time where the new
ruleset is fully active. We consequetively have less and less of the old
ruleset and then incrementally more and more of the new ruleset until we
have fully switched. Any packets processed during that time will have
unpredictable rules applied to them.

We really need to make this switch atomic to be useful.
