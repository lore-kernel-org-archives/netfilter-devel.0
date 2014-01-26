From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_tables: fix racy rule deletion
Date: Sun, 26 Jan 2014 12:23:16 +0000
Message-ID: <20140126122316.GA22254@macbook.localnet>
References: <1390655031-4115-1-git-send-email-pablo@netfilter.org>
 <20140125135552.GA31554@macbook.localnet>
 <20140125163533.GA14235@macbook.localnet>
 <20140125171451.GA11373@macbook.localnet>
 <20140126085446.GA4130@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, arturo.borrero.glez@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56188 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaAZMXU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Jan 2014 07:23:20 -0500
Content-Disposition: inline
In-Reply-To: <20140126085446.GA4130@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 26, 2014 at 09:54:46AM +0100, Pablo Neira Ayuso wrote:
> On Sat, Jan 25, 2014 at 05:14:51PM +0000, Patrick McHardy wrote:
> > As a start, please try this patch. It fixes the overflow, might also
> > fix your problem.
> > ...
> 
> Tested this patch, it works fine here, I hit -EMFILE with 32768 sets
> with no crashes.

Thanks. I got another patch for this. Just RFC for now since I prefer
to get rid of this completely.

> The problem I was reporting was different though, I found a bug in the
> batching code of libmnl. The mnl_nlmsg_batch_next function was not
> accounting the last message not fitting in the batch.
> 
> With my patch + libmnl patch I can perform:
> 
> nft -f pablo-lots-test; nft flush table filter; nft delete chain filter output; nft delete table filter
> 
> without seeing unused anonymous sets left attached to the table and
> -EBUSY problems in that table.

Excellent.

> > Another thing is that our name allocation algorithm really sucks. It
> > was copied from dev_alloc_name(), but network device allocation doesn't
> > happen on the same scale as we might have. I'm considering switching to
> > something taking O(1). Basically, the name allocation is only useful for
> > anonymous sets anyway since in all other cases you need to manually populate
> > them. So if we switch to a prefix string that can't clash with user defined
> > names, we can simply use an incrementing 64 bit counter. So my
> > proposal would be to just use names starting with \0. Alternatively use a
> > handle instead of a name for anonymous sets.
> >
> > The second upside is that its not possible anymore for the user to run
> > into unexpected EEXIST when using setN or mapN as name.
> >
> > Thoughts?
> 
> I like the u64 handle for anonymous sets, it's similar to what we do
> with other objects, we get O(1) handle allocation.
> 
> I think we can allow both u64 and set%d, map%d.  The kernel can check
> if the handle is available first, if not check if the name looks like
> set%d, map%d (so the the maximum number of sets limitation only
> applies to that case). Userspace only needs to send both set%d and the
> u64 handle.
> 
> Would you be OK with that?

Yes, that was my thought as well. We can kill it off later if we want,
no need to keep compatibility with this very early version of nftables
for long.

I'll look into it once I've managed to tame my constantly growing TODO-list :)


commit 06d7a2f84bf1360a07768418f6c80b6476439d23
Author: Patrick McHardy <kaber@trash.net>
Date:   Sat Jan 25 18:24:17 2014 +0000

    netfilter: nf_tables: handle more than 8 * PAGE_SIZE set name allocations
    
    We currently have a limit of 8 * PAGE_SIZE anonymous sets. Lift that limit
    by continuing the scan if the entire page is exhausted.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e8c7437..f6b869b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1976,7 +1976,7 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_set *i;
 	const char *p;
 	unsigned long *inuse;
-	unsigned int n = 0;
+	unsigned int n = 0, min = 0;
 
 	p = strnchr(name, IFNAMSIZ, '%');
 	if (p != NULL) {
@@ -1986,23 +1986,28 @@ static int nf_tables_set_alloc_name(struct nft_ctx *ctx, struct nft_set *set,
 		inuse = (unsigned long *)get_zeroed_page(GFP_KERNEL);
 		if (inuse == NULL)
 			return -ENOMEM;
-
+cont:
 		list_for_each_entry(i, &ctx->table->sets, list) {
 			int tmp;
 
 			if (!sscanf(i->name, name, &tmp))
 				continue;
-			if (tmp < 0 || tmp >= BITS_PER_BYTE * PAGE_SIZE)
+			if (tmp < min || tmp >= min + BITS_PER_BYTE * PAGE_SIZE)
 				continue;
 
-			set_bit(tmp, inuse);
+			set_bit(tmp - min, inuse);
 		}
 
 		n = find_first_zero_bit(inuse, BITS_PER_BYTE * PAGE_SIZE);
+		if (n >= BITS_PER_BYTE * PAGE_SIZE) {
+			min += BITS_PER_BYTE * PAGE_SIZE;
+			memset(inuse, 0, PAGE_SIZE);
+			goto cont;
+		}
 		free_page((unsigned long)inuse);
 	}
 
-	snprintf(set->name, sizeof(set->name), name, n);
+	snprintf(set->name, sizeof(set->name), name, min + n);
 	list_for_each_entry(i, &ctx->table->sets, list) {
 		if (!strcmp(set->name, i->name))
 			return -ENFILE;
