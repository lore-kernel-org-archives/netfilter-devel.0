From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nf_conntrack: falling back to vmalloc.
Date: Thu, 23 Jul 2015 12:45:26 +0200
Message-ID: <20150723104526.GA13915@salvia>
References: <55A8C428.1000005@gmx.de>
 <20150717101009.GN25674@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="rwEMma7ioTxnRzrJ"
Content-Transfer-Encoding: 8bit
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
	netfilter-devel@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>, kaber@trash.net,
	Marcelo Leitner <mleitner@redhat.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39645 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728AbbGWKjl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2015 06:39:41 -0400
Content-Disposition: inline
In-Reply-To: <20150717101009.GN25674@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--rwEMma7ioTxnRzrJ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Jul 17, 2015 at 12:10:09PM +0200, Florian Westphal wrote:
> Toralf Förster <toralf.foerster@gmx.de> wrote:
> > I do run a server with a 64 bit hardened Gentoo Linux (kernel currently 4.0.8).
> > Around 12th of July it started to spew those messages into kern.log :
> > 
> > /var/log/kern.log:Jul 12 15:26:07 tor-relay kernel: [538360.650490] nf_conntrack: falling back to vmalloc.
> > /var/log/kern.log:Jul 12 15:26:07 tor-relay kernel: [538360.650615] nf_conntrack: falling back to vmalloc.
> > /var/log/kern.log:Jul 12 15:26:08 tor-relay kernel: [538361.673649] nf_conntrack: falling back to vmalloc.
> > /var/log/kern.log:Jul 12 15:26:08 tor-relay kernel: [538361.673786] nf_conntrack: falling back to vmalloc.
> > 
> > I read https://bugzilla.openvz.org/show_bug.cgi?id=3092 but a reboot did not help.
> > I got 1-2 thousends of those lines per day.
> 
> Most likely result of 88eab472ec21f01d3e36ff ("netfilter: conntrack:
> adjust nf_conntrack_buckets default value".

I think we can get rid of that warning, it will most likely shown
every time after that patch.

[...]
> Pablo, Patrick -- any idea on how to stop conntrack from becoming active
> in a newly created netns automatically without breaking anything?
>
> With upcoming per netns hooks, we might be able to delay registering
> conntrack, defrag etc.  until after a -m conntrack rule has been added.
> Dou you think that could work?
>
> For nft we could create an expression to configure conntrack explicitly
> (inverse NOTRACK).
> 
> [ obviously we can also add that for xtables but that would break
>   setups if we suddently move to "you must ask for conntrack via
>   ruleset" model. ]

With netns in place, I think it's now clear that we need that this is
configurable at ruleset level that we've been discussing for a while.
But users will have to request this new behaviour to avoid breaking
existing setups...

--rwEMma7ioTxnRzrJ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 13fad86..9b7dc11 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1522,10 +1522,8 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int nulls)
 	sz = nr_slots * sizeof(struct hlist_nulls_head);
 	hash = (void *)__get_free_pages(GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO,
 					get_order(sz));
-	if (!hash) {
-		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
+	if (!hash)
 		hash = vzalloc(sz);
-	}
 
 	if (hash && nulls)
 		for (i = 0; i < nr_slots; i++)

--rwEMma7ioTxnRzrJ--
