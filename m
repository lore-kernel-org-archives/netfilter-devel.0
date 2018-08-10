From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/8] Netfilter updates for net-next
Date: Fri, 10 Aug 2018 10:43:57 -0700 (PDT)
Message-ID: <20180810.104357.2241609077307379991.davem@davemloft.net>
References: <20180810111622.3981-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180810111622.3981-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Fri, 10 Aug 2018 13:16:14 +0200

> The following batch contains netfilter updates for your net-next tree:
> 
> 1) Expose NFT_OSF_MAXGENRELEN maximum OS name length from the new OS
>    passive fingerprint matching extension, from Fernando Fernandez.
> 
> 2) Add extension to support for fine grain conntrack timeout policies
>    from nf_tables. As preparation works, this patchset moves
>    nf_ct_untimeout() to nf_conntrack_timeout and it also decouples the
>    timeout policy from the ctnl_timeout object, most work done by
>    Harsha Sharma.
> 
> 3) Enable connection tracking when conntrack helper is in place.
> 
> 4) Missing enumeration in uapi header when splitting original xt_osf
>    to nfnetlink_osf, also from Fernando.
> 
> 5) Fix a sparse warning due to incorrect typing in the nf_osf_find(),
>    from Wei Yongjun.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf-next.git

Pulled, thank you.
