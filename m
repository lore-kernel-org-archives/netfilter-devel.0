From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/5] Netfilter fixes for net
Date: Wed, 12 Dec 2018 21:37:16 -0800 (PST)
Message-ID: <20181212.213716.1799330740342232493.davem@davemloft.net>
References: <20181213010631.9753-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181213010631.9753-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Thu, 13 Dec 2018 02:06:26 +0100

> The following patchset contains Netfilter fixes for net:
> 
> 1) Fix warnings suspicious rcu usage when handling base chain
>    statistics, from Taehee Yoo.
> 
> 2) Refetch pointer to tcp header from nf_ct_sack_adjust() since
>    skb_make_writable() may reallocate data area, reported by Google
>    folks patch from Florian.
> 
> 3) Incorrect netlink nest end after previous cancellation from error
>    path in ipset, from Pan Bian.
> 
> 4) Use dst_hold_safe() from nf_xfrm_me_harder(), from Florian.
> 
> 5) Use rb_link_node_rcu() for rcu-protected rbtree node in
>    nf_conncount, from Taehee Yoo.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks.
