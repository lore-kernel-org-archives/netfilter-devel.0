From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: use nf_ct_tmpl_free in
 CT/synproxy error paths
Date: Tue, 1 Sep 2015 12:40:03 +0200
Message-ID: <20150901104003.GA8107@salvia>
References: <9caca1293214eeacb76490fa79aa4c4364920139.1441039959.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bjackson0971@gmail.com, fw@strlen.de,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57135 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753957AbbIAKdf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Sep 2015 06:33:35 -0400
Content-Disposition: inline
In-Reply-To: <9caca1293214eeacb76490fa79aa4c4364920139.1441039959.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 31, 2015 at 07:11:02PM +0200, Daniel Borkmann wrote:
> Commit 0838aa7fcfcd ("netfilter: fix netns dependencies with conntrack
> templates") migrated templates to the new allocator api, but forgot to
> update error paths for them in CT and synproxy to use nf_ct_tmpl_free()
> instead of nf_conntrack_free().
> 
> Due to that, memory is being freed into the wrong kmemcache, but also
> we drop the per net reference count of ct objects causing an imbalance.
> 
> In Brad's case, this leads to a wrap-around of net->ct.count and thus
> lets __nf_conntrack_alloc() refuse to create a new ct object:
> 
>   [   10.340913] xt_addrtype: ipv6 does not support BROADCAST matching
>   [   10.810168] nf_conntrack: table full, dropping packet
>   [   11.917416] r8169 0000:07:00.0 eth0: link up
>   [   11.917438] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>   [   12.815902] nf_conntrack: table full, dropping packet
>   [   15.688561] nf_conntrack: table full, dropping packet
>   [   15.689365] nf_conntrack: table full, dropping packet
>   [   15.690169] nf_conntrack: table full, dropping packet
>   [   15.690967] nf_conntrack: table full, dropping packet
>   [...]
> 
> With slab debugging, it also reports the wrong kmemcache (kmalloc-512 vs.
> nf_conntrack_ffffffff81ce75c0) and reports poison overwrites, etc. Thus,
> to fix the problem, export and use nf_ct_tmpl_free() instead.

Applied, thanks Daniel.
