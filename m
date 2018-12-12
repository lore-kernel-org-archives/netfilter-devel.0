From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/5] netfilter: fix missed NULL check in
 nf_conntrack_proto_pernet_init()
Date: Thu, 13 Dec 2018 00:26:48 +0100
Message-ID: <20181212232648.qsvyuc3g2jj5v2ej@salvia>
References: <1544014590-14429-1-git-send-email-laoar.shao@gmail.com>
 <1544014590-14429-4-git-send-email-laoar.shao@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        adobriyan@gmail.com, akpm@linux-foundation.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Yafang Shao <laoar.shao@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1544014590-14429-4-git-send-email-laoar.shao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Dec 05, 2018 at 08:56:29PM +0800, Yafang Shao wrote:
> nf_ct_l4proto_net() may return NULL.
> That may happens if some module forget to set both l4proto->get_net_proto
> and l4proto->net_id.
> We'd check the return value here, in case crash happens.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
>  net/netfilter/nf_conntrack_proto.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
> index 154e8c0..316fef3 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -946,6 +946,9 @@ int nf_conntrack_proto_pernet_init(struct net *net)
>  	struct nf_proto_net *pn = nf_ct_l4proto_net(net,
>  					&nf_conntrack_l4proto_generic);

There is another spot missing in this file that is missing the check
for NULL.

We can probably simplify all this is we place the gre conntracker in
the conntrack core, as it's been suggested already. It's the only one
remaining as a module and it now supports for IPv6, so it's probably
better follow that path.
