From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables PATCH] src: error if listing nonexistent table
Date: Fri, 11 Oct 2013 10:24:16 +0200
Message-ID: <20131011082416.GA3630@localhost>
References: <20131010222129.14092.99057.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40481 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3JKIYV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Oct 2013 04:24:21 -0400
Content-Disposition: inline
In-Reply-To: <20131010222129.14092.99057.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Fri, Oct 11, 2013 at 12:21:30AM +0200, Arturo Borrero Gonzalez wrote:
> Here examples (foo table doesn't exist).
> 
> Before this patch:
> 
> # nft list table foo
> table ip foo {
> }

I cannot reproduce this here:

<cmdline>:1:1-14: Error: Could not receive sets from kernel: No such
file or directory
list table foo
^^^^^^^^^^^^^^
 
> After:
> 
> # nft list table foo
> <cmdline>:1:1-14: Error: Could not receive table from kernel: No such file or directory
> list table foo
> ^^^^^^^^^^^^^^
>
> BTW, netlink_get_table() seemed unused.

Yes, the original nftables code included it already, I guess expecting
some usage at some point.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/mnl.c  |    2 ++
>  src/rule.c |    2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/src/mnl.c b/src/mnl.c
> index 27b181a..4490411 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -563,6 +563,8 @@ int mnl_nft_table_get(struct mnl_socket *nf_sock, struct nft_table *nlt,
>  	nlh = nft_table_nlmsg_build_hdr(buf, NFT_MSG_GETTABLE,
>  					nft_table_attr_get_u32(nlt, NFT_TABLE_ATTR_FAMILY),
>  					NLM_F_ACK, seq);
> +	nft_table_nlmsg_build_payload(nlh, nlt);
> +
>  	return mnl_talk(nf_sock, nlh, nlh->nlmsg_len, table_get_cb, nlt);
>  }
>  
> diff --git a/src/rule.c b/src/rule.c
> index 39a66d7..ff1193a 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -610,6 +610,8 @@ static int do_command_list(struct netlink_ctx *ctx, struct cmd *cmd)
>  			return 0;
>  		}
>  		/* List content of this table */
> +		if (netlink_get_table(ctx, &cmd->handle, &cmd->location) < 0)
> +			return -1;
>  		if (do_list_sets(ctx, &cmd->location, table) < 0)
>  			return -1;
>  		if (netlink_list_chains(ctx, &cmd->handle, &cmd->location) < 0)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
