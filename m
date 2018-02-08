From: Florian Westphal <fw@strlen.de>
Subject: Re: [Patch net v2] ipt_CLUSTERIP: fix a refcount bug in
 clusterip_config_find_get()
Date: Thu, 8 Feb 2018 22:53:12 +0100
Message-ID: <20180208215312.GK14261@breakpoint.cc>
References: <20180208215352.8294-1-xiyou.wangcong@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pabeni@redhat.com, Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44230 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752222AbeBHV4T (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Feb 2018 16:56:19 -0500
Content-Disposition: inline
In-Reply-To: <20180208215352.8294-1-xiyou.wangcong@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> In clusterip_config_find_get() we hold RCU read lock so it could
> run concurrently with clusterip_config_entry_put(), as a result,
> the refcnt could go back to 1 from 0, which leads to a double
> list_del()... Just replace refcount_inc() with
> refcount_inc_not_zero(), as for c->refcount.

Reviewed-by: Florian Westphal <fw@strlen.de>
