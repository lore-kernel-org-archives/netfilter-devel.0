From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: allocate table handle
Date: Tue, 26 Dec 2017 17:11:35 +0100
Message-ID: <20171226161135.vbdvxvsxd2vghvvi@salvia>
References: <20171223194420.5962-1-harshasharmaiitr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harsha Sharma <harshasharmaiitr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47842 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750800AbdLZQLl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Dec 2017 11:11:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 28F1226E0C
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2017 17:11:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 16477F730E
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Dec 2017 17:11:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171223194420.5962-1-harshasharmaiitr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Harsha,

On Sat, Dec 23, 2017 at 11:44:20AM -0800, Harsha Sharma wrote:
> This patch adds code to allocate 'handle' in tables, which allow us to
> uniquely identify a table.
> 
> Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
> ---
>  include/net/netfilter/nf_tables.h        |  2 ++
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c            | 12 +++++++++++-
>  3 files changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
> index 01570a8f2982..bbc7bfcc1a57 100644
> --- a/include/net/netfilter/nf_tables.h
> +++ b/include/net/netfilter/nf_tables.h
> @@ -949,6 +949,7 @@ unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
>   *	@sets: sets in the table
>   *	@objects: stateful objects in the table
>   *	@hgenerator: handle generator state
> + *	@handle: table handle
>   *	@use: number of chain references to this table
>   *	@flags: table flag (see enum nft_table_flags)
>   *	@genmask: generation mask
> @@ -960,6 +961,7 @@ struct nft_table {
>  	struct list_head		sets;
>  	struct list_head		objects;
>  	u64				hgenerator;
> +	u64 				handle:42;
>  	u32				use;
>  	u16				flags:14,
>  					genmask:2;
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> index a3ee277b17a1..a6ab9a962eae 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -168,6 +168,8 @@ enum nft_table_attributes {
>  	NFTA_TABLE_NAME,
>  	NFTA_TABLE_FLAGS,
>  	NFTA_TABLE_USE,
> +	NFTA_TABLE_HANDLE,
> +	NFTA_TABLE_PAD,
>  	__NFTA_TABLE_MAX
>  };
>  #define NFTA_TABLE_MAX		(__NFTA_TABLE_MAX - 1)
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index d8327b43e4dc..4a4e247e6028 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -22,6 +22,7 @@
>  #include <net/net_namespace.h>
>  #include <net/sock.h>
>  
> +static u64 table_handle;

You need to place this handle number in struct nft_table.

>  static LIST_HEAD(nf_tables_expressions);
>  static LIST_HEAD(nf_tables_objects);
>  
> @@ -430,6 +431,7 @@ static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
>  	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
>  				    .len = NFT_TABLE_MAXNAMELEN - 1 },
>  	[NFTA_TABLE_FLAGS]	= { .type = NLA_U32 },
> +	[NFTA_TABLE_HANDLE] = { .type = NLA_U64 },
                          ^^^
missing tab indent here.

>  };
>  
>  static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
> @@ -451,7 +453,9 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
>  
>  	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
>  	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
> -	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)))
> +	    nla_put_be32(skb, NFTA_TABLE_USE, htonl(table->use)) ||
> +	    nla_put_be64(skb, NFTA_TABLE_HANDLE, cpu_to_be64(table->handle),
> +			 NFTA_TABLE_PAD))
>  		goto nla_put_failure;
>  
>  	nlmsg_end(skb, nlh);
> @@ -734,6 +738,12 @@ static int nf_tables_newtable(struct net *net, struct sock *nlsk,
>  	INIT_LIST_HEAD(&table->sets);
>  	INIT_LIST_HEAD(&table->objects);
>  	table->flags = flags;
> +	if (nla[NFTA_TABLE_HANDLE]) {
> +		table->handle = be64_to_cpu(nla_get_be64(nla[NFTA_TABLE_HANDLE]));

We don't allow to restore the handle, please remove this line.

> +	} else {
> +		table_handle++;
> +		table->handle = table_handle;
> +	}
>  
>  	nft_ctx_init(&ctx, net, skb, nlh, afi, table, NULL, nla);
>  	err = nft_trans_table_add(&ctx, NFT_MSG_NEWTABLE);

We need to implement deletion via handle too in nf_tables_deltable(),
same thing for nf_table_gettable().

Thus, the unique handle becomes useful.

Thanks.
