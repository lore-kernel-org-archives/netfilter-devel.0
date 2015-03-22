From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/5] netfilter: nf_tables: assorted patches
Date: Sun, 22 Mar 2015 20:17:44 +0100
Message-ID: <20150322191744.GA10457@salvia>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35711 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbbCVTN4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Mar 2015 15:13:56 -0400
Content-Disposition: inline
In-Reply-To: <1426951158-18168-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 21, 2015 at 03:19:13PM +0000, Patrick McHardy wrote:
> Hi Pablo,
> 
> following are five more or less assorted patches for nf_tables:
> 
> * fix for a minor locking issue in nft_rbtree
> * move the struct net pointer from the chain to the base chain
> * check for invalid NFT_SET_ELEM_INTERVAL_END centrally
> * restruct struct nft_hash as preparation for following patches
> * minor indentation cleanup for nft_hash

Applied 1/5 and 3/5.

2/5 needs possible_net_t which is not yet in nf-next. Also 4/5 and 5/5
need changes from net-next.

I'll apply these once I get that new type into nf-next. Will send a
nf-next pull request asap, sorry.

> I'm sending these patches seperately from the main set changes to ease
> review. Regarding the nft_rbtree fix, I'll provide a backport for
> nf.git seperately.

No problem, I'll pass the rbtree fix to -stable.

Thanks Patrick.
