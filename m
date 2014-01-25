From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Sat, 25 Jan 2014 17:14:51 +0000
Message-ID: <20140125171451.GA11373@macbook.localnet>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
 <20140125135552.GA31554@macbook.localnet>
 <20140125163533.GA14235@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49083 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141AbaAYROy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Jan 2014 12:14:54 -0500
Content-Disposition: inline
In-Reply-To: <20140125163533.GA14235@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 25, 2014 at 04:35:33PM +0000, Patrick McHardy wrote:
> On Sat, Jan 25, 2014 at 01:55:52PM +0000, Patrick McHardy wrote:
> > On Sat, Jan 25, 2014 at 02:03:51PM +0100, Pablo Neira Ayuso wrote:
> > > We still have a bug somewhere else. When creating 10000 rules like:
> > > tcp dport { 22, 23 }, I can see more than 10000 sets.
> > > 
> > > # ./nft-set-get ip | wc -l
> > > 10016
> > > 
> > > It seems set 511 is not being used. See below:
> > > 
> > > # ./nft-rule-get
> > > ip filter output 513 512
> > >   [ payload load 1b @ network header + 9 => reg 1 ]
> > >   [ cmp eq reg 1 0x00000006 ]
> > >   [ payload load 2b @ transport header + 2 => reg 1 ]
> > >   [ lookup reg 1 set set510 ]
> > >   [ counter pkts 0 bytes 0 ]
> > > 
> > > ip filter output 514 513
> > >   [ payload load 1b @ network header + 9 => reg 1 ]
> > >   [ cmp eq reg 1 0x00000006 ]
> > >   [ payload load 2b @ transport header + 2 => reg 1 ]
> > >   [ lookup reg 1 set set512 ]
> > >   [ counter pkts 0 bytes 0 ]
> > > 
> > > It seems to happen every 512 sets are added. Still investigating, so
> > > this needs a second follow up patch to resolve what Arturo is reporting.
> > 
> > Yeah, we seem to have a couple of bugs in nf_tables_set_alloc_name().
> > I'll fix them up and will then have a look at this patch.
> 
> I can't reproduce the gaps in the name space, but we have an obvious
> overflow since we're using BITS_PER_LONG * PAGE_SIZE instead of BITS_PER_BYTE.
> 
> This shouldn't have affected your test case though since the overflow only
> happens for more than 32768 sets.
> 

As a start, please try this patch. It fixes the overflow, might also
fix your problem.

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9ce3053..e8c7437 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1989,13 +1992,13 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 
 			if (!sscanf(i->name, name, &tmp))
 				continue;
-			if (tmp < 0 || tmp > BITS_PER_LONG * PAGE_SIZE)
+			if (tmp < 0 || tmp >= BITS_PER_BYTE * PAGE_SIZE)
 				continue;
 
 			set_bit(tmp, inuse);
 		}
 
-		n = find_first_zero_bit(inuse, BITS_PER_LONG * PAGE_SIZE);
+		n = find_first_zero_bit(inuse, BITS_PER_BYTE * PAGE_SIZE);
 		free_page((unsigned long)inuse);
 	}
 
