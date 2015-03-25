From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] netfilter: nft_hash: restore struct nft_hash
Date: Wed, 25 Mar 2015 12:28:47 +0100
Message-ID: <20150325112847.GA27600@salvia>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
 <1426951158-18168-5-git-send-email-kaber@trash.net>
 <20150325111900.GA6526@salvia>
 <20150325112213.GZ26242@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54383 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278AbbCYLYu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 07:24:50 -0400
Content-Disposition: inline
In-Reply-To: <20150325112213.GZ26242@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 25, 2015 at 11:22:13AM +0000, Patrick McHardy wrote:
> On 25.03, Pablo Neira Ayuso wrote:
> > On Sat, Mar 21, 2015 at 03:19:17PM +0000, Patrick McHardy wrote:
> > > Following patches will add new private members, restore struct nft_hash
> > > as preparation.
> > 
> > [2/2] netfilter: nft_hash: convert to use rhashtable callbacks
> > [1/2] rhashtable: provide len to obj_hashfn
> > [5/5] netfilter: nft_hash: indent rhashtable parameters
> > [4/5] netfilter: nft_hash: restore struct nft_hash
> > 
> > These patches don't apply anymore because of yesterday changes from
> > Thomas Graf:
> > 
> > http://git.kernel.org/cgit/linux/kernel/git/davem/net-next.git/log/?qt=author&q=Thomas+Graf
> > 
> > :-(
> 
> Crap, they already sunk down in my tree :/
> 
> If you push out what you currently have, I'll rebase everything.

Just pushed out.
