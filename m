From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables-kernel PATCH v2] netfilter: nftables: Fix sparse
 endianness issue on nft_nat.c
Date: Mon, 28 Oct 2013 17:46:16 +0100
Message-ID: <20131028164616.GA13962@localhost>
References: <1382955585-21113-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38578 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab3J1QqW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:46:22 -0400
Content-Disposition: inline
In-Reply-To: <1382955585-21113-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 28, 2013 at 12:19:45PM +0200, Tomasz Bursztyka wrote:
> Fixes this:
> 
> CHECK   net/netfilter/nft_nat.c
> net/netfilter/nft_nat.c:50:43: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:50:43:    expected restricted __be32 [addressable] [usertype] ip
> net/netfilter/nft_nat.c:50:43:    got unsigned int [unsigned] [usertype] <noident>
> net/netfilter/nft_nat.c:51:43: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:51:43:    expected restricted __be32 [addressable] [usertype] ip
> net/netfilter/nft_nat.c:51:43:    got unsigned int [unsigned] [usertype] <noident>
> net/netfilter/nft_nat.c:65:37: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:65:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
> net/netfilter/nft_nat.c:65:37:    got unsigned int [unsigned] <noident>
> net/netfilter/nft_nat.c:66:37: warning: incorrect type in assignment (different base types)
> net/netfilter/nft_nat.c:66:37:    expected restricted __be16 [addressable] [assigned] [usertype] all
> net/netfilter/nft_nat.c:66:37:    got unsigned int [unsigned] <noident>

Applied, thanks.
