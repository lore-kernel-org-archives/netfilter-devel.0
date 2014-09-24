From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] rule: factorize chain and table listing code
Date: Wed, 24 Sep 2014 11:49:56 +0200
Message-ID: <20140924094956.GA4900@salvia>
References: <20140924091351.13585.92650.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42892 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbaIXJsy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:48:54 -0400
Content-Disposition: inline
In-Reply-To: <20140924091351.13585.92650.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 24, 2014 at 11:13:51AM +0200, Arturo Borrero Gonzalez wrote:
> Let's factorize common code. This is also useful in follow-up patches.
> 
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/rule.c |   67 +++++++++++++++++++++++++++++++-----------------------------
>  1 file changed, 35 insertions(+), 32 deletions(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 2fe2520..ac72f12 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -749,11 +749,42 @@ static void do_command_list_cleanup(struct table *table)
>  	}
>  }
>  
> +static int do_command_list_table_content(struct netlink_ctx *ctx,
> +					 struct cmd *cmd, struct table *table)

I prefer a slightly shorter name: do_list_table.

do_command_list_cleanup can probably be renamed to table_cleanup since
it has nothing to do with the commands.

