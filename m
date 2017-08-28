From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: fix a few (harmless) sparse warnings
Date: Mon, 28 Aug 2017 17:43:35 +0200
Message-ID: <20170828154335.GA5391@salvia>
References: <20170821141926.18670-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:37723 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751184AbdH1PoB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 11:44:01 -0400
Content-Disposition: inline
In-Reply-To: <20170821141926.18670-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 21, 2017 at 04:19:26PM +0200, Florian Westphal wrote:
> net/netfilter/nft_payload.c:187:18: warning: incorrect type in return expression (expected bool got restricted __sum16 [usertype] check)
> net/netfilter/nft_exthdr.c:222:14: warning: cast to restricted __be32
> net/netfilter/nft_rt.c:49:23: warning: incorrect type in assignment (different base types expected unsigned int got restricted __be32)
> net/netfilter/nft_rt.c:70:25: warning: symbol 'nft_rt_policy' was not declared. Should it be static?

Applied, thanks.
