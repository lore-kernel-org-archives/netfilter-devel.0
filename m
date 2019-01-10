From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] nft_flow_offload: Make flow offload work with vrf
 slave device correct
Date: Fri, 11 Jan 2019 00:36:58 +0100
Message-ID: <20190110233658.jdrpqjav6pghfn22@salvia>
References: <1547103095-8443-1-git-send-email-wenxu@ucloud.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: wenxu@ucloud.cn
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1547103095-8443-1-git-send-email-wenxu@ucloud.cn>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Jan 10, 2019 at 02:51:35PM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
>
> In the forward chain the iif is changed from slave device to master vrf
> device. It will lead the offload not match on lower slave device.
>
> This patch the  flow table iif and oif based on route cache dst->dev, not
> the skb->iif
>
> This patch make the flollowing example can work correct
>
> ip addr add dev eth0 1.1.1.1/24
> ip addr add dev eth1 10.0.0.1/24
> ip link add user1 type vrf table 1
> ip l set user1 up
> ip l set dev eth0 master user1
> ip l set dev eth1 master user1
>
> nft add table firewall
> nft add flowtable f fb1 { hook ingress priority 0 \; devices = { eth0, eth1 } \; }
> nft add chain f ftb-all {type filter hook forward priority 0 \; policy accept \; }
> nft add rule f ftb-all ct zone 1 ip protocol tcp flow offload @fb1
> nft add rule f ftb-all ct zone 1 ip protocol udp flow offload @fb1

v2 looks much better, thanks.

Let me revamp this patch title to:

        netfilter: nft_flow_offload: fix interaction with vrf slave device

before applying. Thanks.
