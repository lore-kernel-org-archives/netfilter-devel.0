From: John Crispin <john@phrozen.org>
Subject: Re: [PATCH] netfilter: fix checking method of conntrack helper
Date: Mon, 14 Jan 2019 11:36:57 +0100
Message-ID: <ac699d64-cb0d-8cf2-99cb-54d6da52d6a8@phrozen.org>
References: <1547459983-15724-1-git-send-email-henry.yen@mediatek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ryder Lee <ryder.lee@mediatek.com>, netdev@vger.kernel.org,
        Sean Wang <sean.wang@kernel.org>,
        Weijie Gao <weijie.gao@mediatek.com>,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
To: Henry Yen <henry.yen@mediatek.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1547459983-15724-1-git-send-email-henry.yen@mediatek.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On 14/01/2019 10:59, Henry Yen wrote:
> This patch uses nfct_help() to detect whether an
> established connection needs conntrack helper instead of using
> test_bit(IPS_HELPER_BIT, &ct->status).
>
> The reason is that IPS_HELPER_BIT is only set when using explicit
> CT target.
>
> However, in the case that a device enables conntrack helper via
> command "echo 1 > /proc/sys/net/netfilter/nf_conntrack_helper",
> the status of IPS_HELPER_BIT will not present any change, and
> consequently it loses the checking ability in the context.
>
> Signed-off-by: Henry Yen <henry.yen@mediatek.com>
> Reviewed-by: Ryder Lee <ryder.lee@mediatek.com>
Tested-by: John Crispin <john@phrozen.org>
> ---
>   net/netfilter/nft_flow_offload.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 974525eb92df..de4684cc4633 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -12,6 +12,7 @@
>   #include <net/netfilter/nf_conntrack_core.h>
>   #include <linux/netfilter/nf_conntrack_common.h>
>   #include <net/netfilter/nf_flow_table.h>
> +#include <net/netfilter/nf_conntrack_helper.h>
>   
>   struct nft_flow_offload {
>   	struct nft_flowtable	*flowtable;
> @@ -71,6 +72,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>   	struct flow_offload *flow;
>   	enum ip_conntrack_dir dir;
>   	struct nf_conn *ct;
> +	const struct nf_conn_help *help;
>   	int ret;
>   
>   	if (nft_flow_offload_skip(pkt->skb))
> @@ -88,7 +90,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>   		goto out;
>   	}
>   
> -	if (test_bit(IPS_HELPER_BIT, &ct->status))
> +	help = nfct_help(ct);
> +	if (help)
>   		goto out;
>   
>   	if (ctinfo == IP_CT_NEW ||
