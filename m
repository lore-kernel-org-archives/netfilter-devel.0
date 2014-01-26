From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Sun, 26 Jan 2014 09:54:46 +0100
Message-ID: <20140126085446.GA4130@localhost>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
 <20140125135552.GA31554@macbook.localnet>
 <20140125163533.GA14235@macbook.localnet>
 <20140125171451.GA11373@macbook.localnet>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Qxx1br4bt0+wmkIi"
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752546AbaAZIzy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Jan 2014 03:55:54 -0500
Content-Disposition: inline
In-Reply-To: <20140125171451.GA11373@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 25, 2014 at 05:14:51PM +0000, Patrick McHardy wrote:
> On Sat, Jan 25, 2014 at 04:35:33PM +0000, Patrick McHardy wrote:
> > On Sat, Jan 25, 2014 at 01:55:52PM +0000, Patrick McHardy wrote:
> > > On Sat, Jan 25, 2014 at 02:03:51PM +0100, Pablo Neira Ayuso wrote:
> > > > We still have a bug somewhere else. When creating 10000 rules like:
> > > > tcp dport { 22, 23 }, I can see more than 10000 sets.
> > > > 
> > > > # ./nft-set-get ip | wc -l
> > > > 10016
> > > > 
> > > > It seems set 511 is not being used. See below:
> > > > 
> > > > # ./nft-rule-get
> > > > ip filter output 513 512
> > > >   [ payload load 1b @ network header + 9 => reg 1 ]
> > > >   [ cmp eq reg 1 0x00000006 ]
> > > >   [ payload load 2b @ transport header + 2 => reg 1 ]
> > > >   [ lookup reg 1 set set510 ]
> > > >   [ counter pkts 0 bytes 0 ]
> > > > 
> > > > ip filter output 514 513
> > > >   [ payload load 1b @ network header + 9 => reg 1 ]
> > > >   [ cmp eq reg 1 0x00000006 ]
> > > >   [ payload load 2b @ transport header + 2 => reg 1 ]
> > > >   [ lookup reg 1 set set512 ]
> > > >   [ counter pkts 0 bytes 0 ]
> > > > 
> > > > It seems to happen every 512 sets are added. Still investigating, so
> > > > this needs a second follow up patch to resolve what Arturo is reporting.
> > > 
> > > Yeah, we seem to have a couple of bugs in nf_tables_set_alloc_name().
> > > I'll fix them up and will then have a look at this patch.
> > 
> > I can't reproduce the gaps in the name space, but we have an obvious
> > overflow since we're using BITS_PER_LONG * PAGE_SIZE instead of BITS_PER_BYTE.
> > 
> > This shouldn't have affected your test case though since the overflow only
> > happens for more than 32768 sets.
> > 
> 
> As a start, please try this patch. It fixes the overflow, might also
> fix your problem.
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 9ce3053..e8c7437 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -1989,13 +1992,13 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
>  
>  			if (!sscanf(i->name, name, &tmp))
>  				continue;
> -			if (tmp < 0 || tmp > BITS_PER_LONG * PAGE_SIZE)
> +			if (tmp < 0 || tmp >= BITS_PER_BYTE * PAGE_SIZE)
>  				continue;
>  
>  			set_bit(tmp, inuse);
>  		}
>  
> -		n = find_first_zero_bit(inuse, BITS_PER_LONG * PAGE_SIZE);
> +		n = find_first_zero_bit(inuse, BITS_PER_BYTE * PAGE_SIZE);
>  		free_page((unsigned long)inuse);
>  	}
>  

Tested this patch, it works fine here, I hit -EMFILE with 32768 sets
with no crashes.

The problem I was reporting was different though, I found a bug in the
batching code of libmnl. The mnl_nlmsg_batch_next function was not
accounting the last message not fitting in the batch.

With my patch + libmnl patch I can perform:

nft -f pablo-lots-test; nft flush table filter; nft delete chain filter output; nft delete table filter

without seeing unused anonymous sets left attached to the table and
-EBUSY problems in that table.

> Another thing is that our name allocation algorithm really sucks. It
> was copied from dev_alloc_name(), but network device allocation doesn't
> happen on the same scale as we might have. I'm considering switching to
> something taking O(1). Basically, the name allocation is only useful for
> anonymous sets anyway since in all other cases you need to manually populate
> them. So if we switch to a prefix string that can't clash with user defined
> names, we can simply use an incrementing 64 bit counter. So my
> proposal would be to just use names starting with \0. Alternatively use a
> handle instead of a name for anonymous sets.
>
> The second upside is that its not possible anymore for the user to run
> into unexpected EEXIST when using setN or mapN as name.
>
> Thoughts?

I like the u64 handle for anonymous sets, it's similar to what we do
with other objects, we get O(1) handle allocation.

I think we can allow both u64 and set%d, map%d.  The kernel can check
if the handle is available first, if not check if the name looks like
set%d, map%d (so the the maximum number of sets limitation only
applies to that case). Userspace only needs to send both set%d and the
u64 handle.

Would you be OK with that?

--Qxx1br4bt0+wmkIi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="libmnl.patch"

diff --git a/src/nlmsg.c b/src/nlmsg.c
index fdb7af8..0a414a7 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -484,14 +484,15 @@ EXPORT_SYMBOL(mnl_nlmsg_batch_stop);
 bool mnl_nlmsg_batch_next(struct mnl_nlmsg_batch *b)
 {
 	struct nlmsghdr *nlh = b->cur;
+	bool ret = true;
 
 	if (b->buflen + nlh->nlmsg_len > b->limit) {
 		b->overflow = true;
-		return false;
+		ret = false;
 	}
 	b->cur = b->buf + b->buflen + nlh->nlmsg_len;
 	b->buflen += nlh->nlmsg_len;
-	return true;
+	return ret;
 }
 EXPORT_SYMBOL(mnl_nlmsg_batch_next);
 

--Qxx1br4bt0+wmkIi--
