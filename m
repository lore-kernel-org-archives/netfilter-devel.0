From: =?ISO-8859-15?Q?Kadlecsik_J=F3zsef?=
        <kadlecsik.jozsef@wigner.mta.hu>
Subject: Re: [PATCH] [v2] netfilter: ipset: fix a missing check of
 nla_parse
Date: Tue, 8 Jan 2019 21:01:41 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1901082101100.21270@localhost>
References: <20190105153150.2600-1-pakki001@umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: kjlu@umn.edu, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Aditya Pakki <pakki001@umn.edu>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190105153150.2600-1-pakki001@umn.edu>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Sat, 5 Jan 2019, Aditya Pakki wrote:

> When nla_parse fails, we should not use the results (the first
> argument). The fix checks if it fails, and if so, returns its error code
> upstream.

Patch is applied in the ipset git tree, thanks!

Best regards,
Jozsef

> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>  net/netfilter/ipset/ip_set_core.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> index 45a257695bef..3ee0fda05a3b 100644
> --- a/net/netfilter/ipset/ip_set_core.c
> +++ b/net/netfilter/ipset/ip_set_core.c
> @@ -1546,8 +1546,13 @@ call_ad(struct sock *ctnl, struct sk_buff *skb, struct ip_set *set,
>  		memcpy(&errmsg->msg, nlh, nlh->nlmsg_len);
>  		cmdattr = (void *)&errmsg->msg + min_len;
>  
> -		nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
> -			  nlh->nlmsg_len - min_len, ip_set_adt_policy, NULL);
> +		ret = nla_parse(cda, IPSET_ATTR_CMD_MAX, cmdattr,
> +				nlh->nlmsg_len - min_len, ip_set_adt_policy,
> +				NULL);
> +		if (ret) {
> +			nlmsg_free(skb2);
> +			return ret;
> +		}
>  
>  		errline = nla_data(cda[IPSET_ATTR_LINENO]);
>  
> -- 
> 2.17.1
> 
> 
