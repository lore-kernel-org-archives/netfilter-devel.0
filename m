From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/9] Netfilter/IPVS fixes for net
Date: Mon, 28 May 2018 22:39:29 -0400 (EDT)
Message-ID: <20180528.223929.1635327139685432602.davem@davemloft.net>
References: <20180528234221.31254-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528234221.31254-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 29 May 2018 01:42:12 +0200

> The following patchset contains Netfilter/IPVS fixes for your net tree:
> 
> 1) Null pointer dereference when dumping conntrack helper configuration,
>    from Taehee Yoo.
> 
> 2) Missing sanitization in ebtables extension name through compat,
>    from Paolo Abeni.
> 
> 3) Broken fetch of tracing value, from Taehee Yoo.
> 
> 4) Incorrect arithmetics in packet ratelimiting.
> 
> 5) Buffer overflow in IPVS sync daemon, from Julian Anastasov.
> 
> 6) Wrong argument to nla_strlcpy() in nfnetlink_{acct,cthelper},
>    from Eric Dumazet.
> 
> 7) Fix splat in nft_update_chain_stats().
> 
> 8) Null pointer dereference from object netlink dump path, from
>    Taehee Yoo.
> 
> 9) Missing static_branch_inc() when enabling counters in existing
>    chain, from Taehee Yoo.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
