From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 0/7] Netfilter fixes for net
Date: Tue, 15 Jan 2019 13:32:26 -0800 (PST)
Message-ID: <20190115.133226.27643735600937727.davem@davemloft.net>
References: <20190114212940.5704-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190114212940.5704-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 14 Jan 2019 22:29:33 +0100

> This is the first batch of Netfilter fixes for your net tree:
> 
> 1) Fix endless loop in nf_tables rules netlink dump, from Phil Sutter.
> 
> 2) Reference counter leak in object from the error path, from Taehee Yoo.
> 
> 3) Selective rule dump requires table and chain.
> 
> 4) Fix DNAT with nft_flow_offload reverse route lookup, from wenxu.
> 
> 5) Use GFP_KERNEL_ACCOUNT in vmalloc allocation from ebtables, from
>    Shakeel Butt.
> 
> 6) Set ifindex from route to fix interaction with VRF slave device,
>    also from wenxu.
> 
> 7) Use nfct_help() to check for conntrack helper, IPS_HELPER status
>    flag is only set from explicit helpers via -j CT, from Henry Yen.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
