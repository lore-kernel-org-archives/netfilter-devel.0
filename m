From: Florian Westphal <fw@strlen.de>
Subject: Re: [Patch net v2] xt_RATEEST: acquire xt_rateest_mutex for hash
 insert
Date: Mon, 5 Feb 2018 23:55:05 +0100
Message-ID: <20180205225505.GA15427@breakpoint.cc>
References: <20180205224145.9420-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60926 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750724AbeBEW6I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Feb 2018 17:58:08 -0500
Content-Disposition: inline
In-Reply-To: <20180205224145.9420-1-xiyou.wangcong@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> rateest_hash is supposed to be protected by xt_rateest_mutex,
> and, as suggested by Eric, lookup and insert should be atomic,
> so we should acquire the xt_rateest_mutex once for both.
> 
> So introduce a non-locking helper for internal use and keep the
> locking one for external.

Looks good, thanks Cong.

Reviewed-by: Florian Westphal <fw@strlen.de>
