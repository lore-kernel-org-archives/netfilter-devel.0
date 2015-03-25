From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 4/5] netfilter: nft_hash: restore struct nft_hash
Date: Wed, 25 Mar 2015 11:50:47 +0000
Message-ID: <20150325115047.GA25732@casper.infradead.org>
References: <1426951158-18168-1-git-send-email-kaber@trash.net>
 <1426951158-18168-5-git-send-email-kaber@trash.net>
 <20150325111900.GA6526@salvia>
 <20150325112213.GZ26242@acer.localdomain>
 <20150325112847.GA27600@salvia>
 <20150325113025.GA26242@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, davem@davemloft.net
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:42099 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072AbbCYLut (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 07:50:49 -0400
Content-Disposition: inline
In-Reply-To: <20150325113025.GA26242@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/25/15 at 11:30am, Patrick McHardy wrote:
> I'm getting really annoyed that people keep sending patches touching
> this stuff without CCing either netfilter-devel or me personally.
> 
> This is just causing unnecessary work. The code in nft_hash is going
> to get replaced anyways, so now I can rebase 30 patches for no gain
> at all.
> 
> If you touch netfilter, CC the relevant lists and people please.
> Thanks!

Sorry about that Patrick. Not copying you on the nft_hash change
was a mistake. I apologize. I was only aware of your following
patchset which seemed compatible with my changes.

"[PATCH 0/2] netfilter: preparatory patches for set extensions"

If your larger patchset resolves the RCU lockdep splash in nft_hash
then we can also just revert 6b6f302ce ("rhashtable: Add
rhashtable_free_and_destroy()") or I can rebase it on top of your
series.
