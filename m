From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/4] netfilter: minor cleanups and improvements
Date: Tue, 25 Feb 2014 17:44:26 +0100
Message-ID: <20140225164426.GA25597@localhost>
References: <1392746810-22456-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59590 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908AbaBYQob (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Feb 2014 11:44:31 -0500
Content-Disposition: inline
In-Reply-To: <1392746810-22456-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 18, 2014 at 06:06:46PM +0000, Patrick McHardy wrote:
> The following four patches have been sitting in my tree for a while, I
> need them as preconditions for following patches, but they also make
> sense on their own, so I'd like to get rid of them.
> 
> The second patch adds a nfnl_dereference() helper, which is a wrapper
> around rcu_dereference_protected() that checks that the nfnetlink
> subsys mutex is actually held. This is similar to rtnl_dereference()
> except that we need to check subsys-specific mutexes.
> 
> The first patch renamed a similar named ip_set function, the third patch
> introduces a nft_dereference() macro that is to be used in nftables.
> 
> The fourth patch is unrelated to this, it changes verdict validation in
> nftables to accept flags to NF_QUEUE or errno codes to NF_DROP.
> 
> Please apply.

Applied, thanks!
