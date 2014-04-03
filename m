From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH] netfilter: nf_tables: add set_elem
 notifications
Date: Thu, 3 Apr 2014 12:07:30 +0200
Message-ID: <20140403100730.GA11139@localhost>
References: <20140401120606.4305.13228.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41822 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbaDCKHg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Apr 2014 06:07:36 -0400
Content-Disposition: inline
In-Reply-To: <20140401120606.4305.13228.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 01, 2014 at 02:06:07PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds set_elems notifications.
> 
> When a set_elem is added/deleted, all listening peers in userspace will
> receive the corresponding notification.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  net/netfilter/nf_tables_api.c |   82 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 82 insertions(+)
> 
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index 33045a5..9791c49 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -2723,6 +2723,85 @@ static int nf_tables_getsetelem(struct sock *nlsk, struct sk_buff *skb,
>  	return -EOPNOTSUPP;
>  }
>  
> +static int nf_tables_fill_setelem_info(const struct nft_ctx *ctx,
> +				       struct sk_buff *skb;
                                                          ^

Did you send me the final patch version?

> +				       const struct nft_set *set,
> +				       const struct nft_set_elem *elem,
> +				       int event, u16 flags)
> +{
> +	u32 seq = ctx->nlh->nlmsg_seq;
> +	struct nfgenmsg *nfmsg;
> +	struct nlmsghdr *nlh;
> +	struct nlattr *nest;
> +
> +	event |= NFNL_SUBSYS_NFTABLES << 8;
> +	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),

It also complains about unexisting portid variable and so on. This
doesn't compile :-(
