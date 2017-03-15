From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: nft_ct: do cleanup work when
 NFTA_CT_DIRECTION is invalid
Date: Wed, 15 Mar 2017 15:52:31 +0100
Message-ID: <20170315145231.GF24366@breakpoint.cc>
References: <1489587728-28318-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de,
        Liping Zhang <zlpnobody@gmail.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:46406 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753779AbdCOOw4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 10:52:56 -0400
Content-Disposition: inline
In-Reply-To: <1489587728-28318-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@163.com> wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> We should jump to invoke __nft_ct_set_destroy() instead of just
> return error.
> 
> Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>

Indeed, good catch, thanks!

Acked-by: Florian Westphal <fw@strlen.de>
