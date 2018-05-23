From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/18] Netfilter updates for net-next
Date: Wed, 23 May 2018 16:37:51 -0400 (EDT)
Message-ID: <20180523.163751.177234858914755359.davem@davemloft.net>
References: <20180523184254.22599-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180523184254.22599-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 23 May 2018 20:42:36 +0200

> The following patchset contains Netfilter updates for your net-next
> tree, they are:
 ...
> This batch comes with is a conflict between 25fd386e0bc0 ("netfilter:
> core: add missing __rcu annotation") in your tree and 2c205dd3981f
> ("netfilter: add struct nf_nat_hook and use it") coming in this batch.
> This conflict can be solved by leaving the __rcu tag on
> __netfilter_net_init() - added by 25fd386e0bc0 - and remove all code
> related to nf_nat_decode_session_hook - which is gone after
> 2c205dd3981f, as described by:
> 
> diff --cc net/netfilter/core.c
> index e0ae4aae96f5,206fb2c4c319..168af54db975
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
 ...
> I can also merge your net-next tree into nf-next, solve the conflict and
> resend the pull request if you prefer so.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Thanks for the merge conflict resolution guide.

Pulled, thanks.
