From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next v16 4/8] netfilter: Add nf_ct_get_tuple_skb
 callback
Date: Mon, 28 May 2018 21:49:02 +0200
Message-ID: <20180528194902.kooqoao3agt32nls@salvia>
References: <152751762093.30935.15398977119837536494.stgit@alrua-kau>
 <152751766686.30935.14644567905547700823.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        netfilter-devel@vger.kernel.org
To: Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152751766686.30935.14644567905547700823.stgit@alrua-kau>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 28, 2018 at 04:27:46PM +0200, Toke Høiland-Jørgensen wrote:
[...]
> diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> index 0f6b8172fb9a..520565198f0e 100644
> --- a/net/netfilter/core.c
> +++ b/net/netfilter/core.c
> @@ -572,6 +572,27 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
>  }
>  EXPORT_SYMBOL(nf_conntrack_destroy);
>  
> +bool (*skb_ct_get_tuple)(struct nf_conntrack_tuple *,
> +			 const struct sk_buff *) __rcu __read_mostly;
> +EXPORT_SYMBOL(skb_ct_get_tuple);

Now we have struct nf_ct_hook in net-next, please add ->get_tuple to
that new object.

Thanks.
