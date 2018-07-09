From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/6] Netfilter fixes for net
Date: Mon, 09 Jul 2018 14:24:26 -0700 (PDT)
Message-ID: <20180709.142426.53525987750075262.davem@davemloft.net>
References: <20180709171904.2460-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180709171904.2460-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon,  9 Jul 2018 19:18:58 +0200

> The following patchset contains Netfilter fixes for your net tree:
> 
> 1) Missing module autoloadfor icmp and icmpv6 x_tables matches,
>    from Florian Westphal.
> 
> 2) Possible non-linear access to TCP header from tproxy, from
>    Mate Eckl.
> 
> 3) Do not allow rbtree to be used for single elements, this patch
>    moves all set backend into one single module since such thing
>    can only happen if hashtable module is explicitly blacklisted,
>    which should not ever be done.
> 
> 4) Reject error and standard targets from nft_compat for sanity
>    reasons, they are never used from there.
> 
> 5) Don't crash on double hashsize module parameter, from Andrey
>    Ryabinin.
> 
> 6) Drop dst on skb before placing it in the fragmentation
>    reassembly queue, from Florian Westphal.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
