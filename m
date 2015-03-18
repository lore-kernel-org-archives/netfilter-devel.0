From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] rule: delete extra space in rule indentation
Date: Wed, 18 Mar 2015 11:10:27 +0100
Message-ID: <20150318101027.GA18800@salvia>
References: <20150317212327.20080.81689.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41989 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbbCRKGf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 06:06:35 -0400
Content-Disposition: inline
In-Reply-To: <20150317212327.20080.81689.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 17, 2015 at 10:23:27PM +0100, Arturo Borrero Gonzalez wrote:
> Annoying extra space in rule indentation.

What "extra space" are you refering to?

Could you include a small proof of it in the description? Thanks.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  src/rule.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 8d76fd0..9403c1e 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -237,11 +237,11 @@ void rule_print(const struct rule *rule)
>  	const struct stmt *stmt;
>  
>  	list_for_each_entry(stmt, &rule->stmts, list) {
> -		printf(" ");
>  		stmt->ops->print(stmt);
> +		printf(" ");
>  	}
>  	if (handle_output > 0)
> -		printf(" # handle %" PRIu64, rule->handle.handle);
> +		printf("# handle %" PRIu64, rule->handle.handle);
>  }
>  
>  struct scope *scope_init(struct scope *scope, const struct scope *parent)
> 
