From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [nf] netfilter: nf_ct_dccp/sctp: fix memory leak after netns
 cleanup
Date: Wed, 28 Jun 2017 11:24:09 -0700
Message-ID: <20170628182408.GA13678@outlook.office365.com>
References: <1496575054-17168-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <zlpnobody@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>
To: Liping Zhang <zlpnobody@163.com>, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-eopbgr00121.outbound.protection.outlook.com ([40.107.0.121]:51328
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751650AbdF1SYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jun 2017 14:24:21 -0400
Content-Disposition: inline
In-Reply-To: <1496575054-17168-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

We met the same issue in 4.12-rc7. Is there any chanse to push this
patch to Linus' tree before the v4.12?

Thanks,
Andrei

On Sun, Jun 04, 2017 at 07:17:34PM +0800, Liping Zhang wrote:
> From: Liping Zhang <zlpnobody@gmail.com>
> 
> After running the following commands for a while, kmemleak reported that
> "1879 new suspected memory leaks" happened:
>   # while : ; do
>   ip netns add test
>   ip netns delete test
>   done
> 
>   unreferenced object 0xffff88006342fa38 (size 1024):
>   comm "ip", pid 15477, jiffies 4295982857 (age 957.836s)
>   hex dump (first 32 bytes):
>     b8 b0 4d a0 ff ff ff ff c0 34 c3 59 00 88 ff ff  ..M......4.Y....
>     04 00 00 00 a4 01 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8190510a>] kmemleak_alloc+0x4a/0xa0
>     [<ffffffff81284130>] __kmalloc_track_caller+0x150/0x300
>     [<ffffffff812302d0>] kmemdup+0x20/0x50
>     [<ffffffffa04d598a>] dccp_init_net+0x8a/0x160 [nf_conntrack]
>     [<ffffffffa04cf9f5>] nf_ct_l4proto_pernet_register_one+0x25/0x90
>   ...
>   unreferenced object 0xffff88006342da58 (size 1024):
>   comm "ip", pid 15477, jiffies 4295982857 (age 957.836s)
>   hex dump (first 32 bytes):
>     10 b3 4d a0 ff ff ff ff 04 35 c3 59 00 88 ff ff  ..M......5.Y....
>     04 00 00 00 a4 01 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<ffffffff8190510a>] kmemleak_alloc+0x4a/0xa0
>     [<ffffffff81284130>] __kmalloc_track_caller+0x150/0x300
>     [<ffffffff812302d0>] kmemdup+0x20/0x50
>     [<ffffffffa04d6a9d>] sctp_init_net+0x5d/0x130 [nf_conntrack]
>     [<ffffffffa04cf9f5>] nf_ct_l4proto_pernet_register_one+0x25/0x90
>   ...
> 
> This is because we forgot to implement the get_net_proto for sctp and
> dccp, so we won't invoke the nf_ct_unregister_sysctl to free the
> ctl_table when do netns cleanup. Also note, we will fail to register
> the sysctl for dccp/sctp either due to the lack of get_net_proto.
> 
> Fixes: c51d39010a1b ("netfilter: conntrack: built-in support for DCCP")
> Fixes: a85406afeb3e ("netfilter: conntrack: built-in support for SCTP")
> Cc: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
> Acked-by: Davide Caratti <dcaratti@redhat.com>
> Acked-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_proto_dccp.c | 7 +++++++
>  net/netfilter/nf_conntrack_proto_sctp.c | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto_dccp.c b/net/netfilter/nf_conntrack_proto_dccp.c
> index b553fdd..4707d99 100644
> --- a/net/netfilter/nf_conntrack_proto_dccp.c
> +++ b/net/netfilter/nf_conntrack_proto_dccp.c
> @@ -872,6 +872,11 @@ static int dccp_init_net(struct net *net, u_int16_t proto)
>  	return dccp_kmemdup_sysctl_table(net, pn, dn);
>  }
>  
> +static struct nf_proto_net *dccp_get_net_proto(struct net *net)
> +{
> +	return &net->ct.nf_ct_proto.dccp.pn;
> +}
> +
>  struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 __read_mostly = {
>  	.l3proto		= AF_INET,
>  	.l4proto		= IPPROTO_DCCP,
> @@ -904,6 +909,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp4 __read_mostly = {
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		= dccp_init_net,
> +	.get_net_proto		= dccp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_dccp4);
>  
> @@ -939,5 +945,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_dccp6 __read_mostly = {
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		= dccp_init_net,
> +	.get_net_proto		= dccp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_dccp6);
> diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> index 1c5b14a..4ed976f 100644
> --- a/net/netfilter/nf_conntrack_proto_sctp.c
> +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> @@ -786,6 +786,11 @@ static int sctp_init_net(struct net *net, u_int16_t proto)
>  	return sctp_kmemdup_sysctl_table(pn, sn);
>  }
>  
> +static struct nf_proto_net *sctp_get_net_proto(struct net *net)
> +{
> +	return &net->ct.nf_ct_proto.sctp.pn;
> +}
> +
>  struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
>  	.l3proto		= PF_INET,
>  	.l4proto 		= IPPROTO_SCTP,
> @@ -819,6 +824,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp4 __read_mostly = {
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		= sctp_init_net,
> +	.get_net_proto		= sctp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_sctp4);
>  
> @@ -855,5 +861,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_sctp6 __read_mostly = {
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  #endif
>  	.init_net		= sctp_init_net,
> +	.get_net_proto		= sctp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_sctp6);
