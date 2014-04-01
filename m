From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: net-next is closed [was Re: no new feature patches please]
Date: Tue, 1 Apr 2014 10:32:08 +0200
Message-ID: <20140401083208.GA4473@localhost>
References: <20140331.151625.1813309792083064637.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60259 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbaDAIc2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Apr 2014 04:32:28 -0400
Content-Disposition: inline
In-Reply-To: <20140331.151625.1813309792083064637.davem@davemloft.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

As you probably noticed, the net-next merge window is already closed.

I had several patches in my queue though that I thought I could manage
to get them in together with some of them that were closed to be
ready, but this time I overestimate the amount of time that I had to
make it, sorry. To resolve the current situation, I'll rearrange the
current patchset in the following way:

* nf_tables patches, they will all fly to the nftables tree [1] to
  keep it simple for the nftables developers. I'll keep this tree open
  for new features meanwhile.

netfilter: nft_hash: use set global element counter instead of private one
netfilter: nf_tables: implement proper set selection
netfilter: nft_ct: split nft_ct_init() into two functions for get/set
netfilter: nft_meta: split nft_meta_init() into two functions for get/set
netfilter: nft_ct: add missing ifdef for NFT_MARK set

* Netfilter fixes:

netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len
netfilter: Add {ipt,ip6t}_osf aliases for xt_osf
netfilter: connlimit: move lock array out of struct connlimit_data
netfilter: x_tables: allow to use cgroup match for LOCAL_IN nf hooks
netfilter: connlimit: fix UP build

* For nf-next, I'll enqueue this cleanup:

netfilter: nfnetlink: simplify nfnetlink_bind

[1] http://git.kernel.org/cgit/linux/kernel/git/pablo/nftables.git

On Mon, Mar 31, 2014 at 03:16:25PM -0400, David Miller wrote:
> 
> We are enterring the merge window, please do not submit non-bugfix patches
> until the net-next tree opens back up.
> 
> I will be just silently marking as "deferred" any submission which
> violates this, because it is extremely time consuming responding to
> each and every posting which violates the submission rules.
> 
> Thanks in advance for your understanding.
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
