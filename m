From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Sat, 25 Jan 2014 16:35:33 +0000
Message-ID: <20140125163533.GA14235@macbook.localnet>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
 <20140125135552.GA31554@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48851 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaAYQfg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jan 2014 11:35:36 -0500
Content-Disposition: inline
In-Reply-To: <20140125135552.GA31554@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 25, 2014 at 01:55:52PM +0000, Patrick McHardy wrote:
> On Sat, Jan 25, 2014 at 02:03:51PM +0100, Pablo Neira Ayuso wrote:
> > We still have a bug somewhere else. When creating 10000 rules like:
> > tcp dport { 22, 23 }, I can see more than 10000 sets.
> > 
> > # ./nft-set-get ip | wc -l
> > 10016
> > 
> > It seems set 511 is not being used. See below:
> > 
> > # ./nft-rule-get
> > ip filter output 513 512
> >   [ payload load 1b @ network header + 9 => reg 1 ]
> >   [ cmp eq reg 1 0x00000006 ]
> >   [ payload load 2b @ transport header + 2 => reg 1 ]
> >   [ lookup reg 1 set set510 ]
> >   [ counter pkts 0 bytes 0 ]
> > 
> > ip filter output 514 513
> >   [ payload load 1b @ network header + 9 => reg 1 ]
> >   [ cmp eq reg 1 0x00000006 ]
> >   [ payload load 2b @ transport header + 2 => reg 1 ]
> >   [ lookup reg 1 set set512 ]
> >   [ counter pkts 0 bytes 0 ]
> > 
> > It seems to happen every 512 sets are added. Still investigating, so
> > this needs a second follow up patch to resolve what Arturo is reporting.
> 
> Yeah, we seem to have a couple of bugs in nf_tables_set_alloc_name().
> I'll fix them up and will then have a look at this patch.

I can't reproduce the gaps in the name space, but we have an obvious
overflow since we're using BITS_PER_LONG * PAGE_SIZE instead of BITS_PER_BYTE.

This shouldn't have affected your test case though since the overflow only
happens for more than 32768 sets.

Another thing is that our name allocation algorithm really sucks. It was
copied from dev_alloc_name(), but network device allocation doesn't happen
on the same scale as we might have. I'm considering switching to something
taking O(1). Basically, the name allocation is only useful for anonymous
sets anyway since in all other cases you need to manually populate them.
So if we switch to a prefix string that can't clash with user defined
names, we can simply use an incrementing 64 bit counter. So my proposal
would be to just use names starting with \0. Alternatively use a handle
instead of a name for anonymous sets.

The second upside is that its not possible anymore for the user to run
into unexpected EEXIST when using setN or mapN as name.

Thoughts?
