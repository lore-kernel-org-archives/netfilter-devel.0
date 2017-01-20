From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: nf_tables: Eliminate duplicated
 codes in nf_tables_table_enable
Date: Fri, 20 Jan 2017 15:42:24 +0800
Message-ID: <CA+6hz4pH1uoyZjJ2-cTv78u1_fLuwALA1SdoDZH90Ch6KtigQw@mail.gmail.com>
References: <1484824690-46965-1-git-send-email-fgao@ikuai8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Feng Gao <gfree.wind@gmail.com>, Feng <fgao@ikuai8.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f65.google.com ([209.85.213.65]:33572 "EHLO
        mail-vk0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751406AbdATHvK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2017 02:51:10 -0500
Received: by mail-vk0-f65.google.com with SMTP id t8so5546964vke.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 23:51:10 -0800 (PST)
In-Reply-To: <1484824690-46965-1-git-send-email-fgao@ikuai8.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 19, 2017 at 7:18 PM,  <fgao@ikuai8.com> wrote:
> From: Feng <fgao@ikuai8.com>
>
> When something failed in nf_tables_table_enable, it would unregister
> the chains. But the rollback codes are same as nf_tables_table_disable
> almostly, except there is one counter check.
> Now create one wrapper function to eliminate the duplicated codes.
>
> Signed-off-by: Feng <fgao@ikuai8.com>
> ---
>  v2: Use cnt "0" as unlimited rules counter, per Pablo;
>  v1: Initial version;
>
>  net/netfilter/nf_tables_api.c | 47 ++++++++++++++++++++++---------------------
>  1 file changed, 24 insertions(+), 23 deletions(-)
>
> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> index a019a87..c87f8d0 100644
> --- a/net/netfilter/nf_tables_api.c
> +++ b/net/netfilter/nf_tables_api.c
> @@ -576,6 +576,27 @@ static int nf_tables_gettable(struct net *net, struct sock *nlsk,
>         return err;
>  }
>
> +static void _nf_tables_table_disable(struct net *net,
> +                                    const struct nft_af_info *afi,
> +                                    struct nft_table *table,
> +                                    u32 cnt)
> +{
> +       struct nft_chain *chain;
> +
> +       list_for_each_entry(chain, &table->chains, list) {
> +               if (!nft_is_active_next(net, chain))
> +                       continue;
> +               if (!(chain->flags & NFT_BASE_CHAIN))
> +                       continue;
> +
> +               if (cnt && --cnt == 0)
> +                       break;
> +
> +               nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
> +                                       afi->nops);
> +       }
> +}
> +
>  static int nf_tables_table_enable(struct net *net,
>                                   const struct nft_af_info *afi,
>                                   struct nft_table *table)
> @@ -598,18 +619,8 @@ static int nf_tables_table_enable(struct net *net,
>         }
>         return 0;
>  err:
> -       list_for_each_entry(chain, &table->chains, list) {
> -               if (!nft_is_active_next(net, chain))
> -                       continue;
> -               if (!(chain->flags & NFT_BASE_CHAIN))
> -                       continue;
> -
> -               if (i-- <= 0)
> -                       break;
> -
> -               nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
> -                                       afi->nops);
> -       }
> +       if (i)
> +               _nf_tables_table_disable(net, afi, table, i);
>         return err;
>  }
>
> @@ -617,17 +628,7 @@ static void nf_tables_table_disable(struct net *net,
>                                     const struct nft_af_info *afi,
>                                     struct nft_table *table)
>  {
> -       struct nft_chain *chain;
> -
> -       list_for_each_entry(chain, &table->chains, list) {
> -               if (!nft_is_active_next(net, chain))
> -                       continue;
> -               if (!(chain->flags & NFT_BASE_CHAIN))
> -                       continue;
> -
> -               nf_unregister_net_hooks(net, nft_base_chain(chain)->ops,
> -                                       afi->nops);
> -       }
> +       _nf_tables_table_disable(net, afi, table, 0);
>  }
>
>  static int nf_tables_updtable(struct nft_ctx *ctx)
> --
> 1.9.1
>
>

Hi Pablo,

Please ignore this patch.
In v2 patch, I copied your recommend codes "if (cnt && --cnt == 0)".
Today I think it is not right to use "--cnt", it should use "cnt--".
Because when the cnt is 1, the "--cnt" would break directly.
So I send the v3 patch.

Regards
Feng
