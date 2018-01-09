From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/52] Netfilter/IPVS updates for net-next
Date: Mon, 08 Jan 2018 20:55:58 -0500 (EST)
Message-ID: <20180108.205558.1708801479944961795.davem@davemloft.net>
References: <20180108202000.12989-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180108202000.12989-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon,  8 Jan 2018 21:19:08 +0100

> The following patchset contains Netfilter/IPVS updates for your
> net-next tree:
 ...
> 4) Add generic flow table offload infrastructure for nf_tables, this
>    includes the netlink control plane and support for IPv4, IPv6 and
>    mixed IPv4/IPv6 dataplanes. This comes with NAT support too. This
>    patchset adds the IPS_OFFLOAD conntrack status bit to indicate that
>    this flow has been offloaded.

Have driver maintainers signed off on your offload design and driver
interfaces?

I've pulled, but the above is really important to indicate when a new
offload feature is added.

Thanks.
