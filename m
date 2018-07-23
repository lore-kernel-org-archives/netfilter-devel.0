From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf] netfilter: nf_tables: move dumper state alloation
 into ->start
Date: Mon, 23 Jul 2018 09:47:34 -0700 (PDT)
Message-ID: <20180723.094734.1171302416140052925.davem@davemloft.net>
References: <20180723104714.24008-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        cscnull@gmail.com
To: fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180723104714.24008-1-fw@strlen.de>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Mon, 23 Jul 2018 12:47:14 +0200

> Shaochun Chen points out we leak dumper filter state allocations
> stored in dump_control->data in case there is an error before netlink sets
> cb_running (after which ->done will be called at some point).
> 
> In order to fix this, add .start functions and do the allocations
> there.
> 
> ->done is going to clean up, and in case error occurs before
> ->start invocation no cleanups need to be done anymore.
> 
> Reported-by: shaochun chen <cscnull@gmail.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: David S. Miller <davem@davemloft.net>
