From: YueHaibing <yuehaibing@huawei.com>
Subject: Re: [PATCH] netfilter: nat: Update comment of get_unique_tuple
Date: Thu, 24 Jan 2019 10:18:07 +0800
Message-ID: <fa26810d-4b22-f1a3-8d0d-bbbde4cc14f5@huawei.com>
References: <20190110130618.25344-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>
To: <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190110130618.25344-1-yuehaibing@huawei.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

ping...

On 2019/1/10 21:06, YueHaibing wrote:
> Replace outdated __ip_conntrack_confirm in comment.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  net/netfilter/nf_nat_core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> index d159e9e..f54a8db 100644
> --- a/net/netfilter/nf_nat_core.c
> +++ b/net/netfilter/nf_nat_core.c
> @@ -460,7 +460,8 @@ static void nf_nat_l4proto_unique_tuple(struct nf_conntrack_tuple *tuple,
>   * and NF_INET_LOCAL_OUT, we change the destination to map into the
>   * range. It might not be possible to get a unique tuple, but we try.
>   * At worst (or if we race), we will end up with a final duplicate in
> - * __ip_conntrack_confirm and drop the packet. */
> + * __nf_conntrack_confirm and drop the packet.
> + */
>  static void
>  get_unique_tuple(struct nf_conntrack_tuple *tuple,
>  		 const struct nf_conntrack_tuple *orig_tuple,
> 
