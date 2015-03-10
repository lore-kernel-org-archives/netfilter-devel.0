From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] netfilter: fix sparse warnings in reject handling
Date: Tue, 10 Mar 2015 15:00:21 +0100
Message-ID: <20150310140021.GA15712@salvia>
References: <1425938655-9549-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40489 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbbCJN4k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Mar 2015 09:56:40 -0400
Content-Disposition: inline
In-Reply-To: <1425938655-9549-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 09, 2015 at 11:04:15PM +0100, Florian Westphal wrote:
> make C=1 CF=-D__CHECK_ENDIAN__ shows following:
> 
> net/bridge/netfilter/nft_reject_bridge.c:65:50: warning: incorrect type in argument 3 (different base types)
> net/bridge/netfilter/nft_reject_bridge.c:65:50:    expected restricted __be16 [usertype] protocol [..]
> net/bridge/netfilter/nft_reject_bridge.c:102:37: warning: cast from restricted __be16
> net/bridge/netfilter/nft_reject_bridge.c:102:37: warning: incorrect type in argument 1 (different base types) [..]
> net/bridge/netfilter/nft_reject_bridge.c:121:50: warning: incorrect type in argument 3 (different base types) [..]
> net/bridge/netfilter/nft_reject_bridge.c:168:52: warning: incorrect type in argument 3 (different base types) [..]
> net/bridge/netfilter/nft_reject_bridge.c:233:52: warning: incorrect type in argument 3 (different base types) [..]
> 
> Caused by two (harmless) errors:
> 1. htons() instead of ntohs()
> 2. __be16 for protocol in nf_reject_ipXhdr_put API, use u8 instead.

Applied, thanks. I'll pass to David a small pull request to focus on
resolving the existing issues first.
