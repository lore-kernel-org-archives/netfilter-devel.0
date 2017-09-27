From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 3/3] bison: permit keywords in list_stmt_expressions
Date: Wed, 27 Sep 2017 19:57:13 +0200
Message-ID: <20170927175713.GC17665@salvia>
References: <20170927173807.29882-1-fw@strlen.de>
 <20170927173807.29882-4-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38289 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751554AbdI0R5R (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2017 13:57:17 -0400
Content-Disposition: inline
In-Reply-To: <20170927173807.29882-4-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 27, 2017 at 07:38:07PM +0200, Florian Westphal wrote:
> 'ct event set label' and 'ct event set new or label' work, but
> 'ct event set new, label' did not:
> 
>   nft add rule filter input ct event set new,label
>   Error: syntax error, unexpected label
> 
> This changes the definition to also contain keyword symbol expressions.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  src/parser_bison.y        | 11 +++++++----
>  tests/py/any/ct.t         |  1 +
>  tests/py/any/ct.t.payload |  5 +++++
>  3 files changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index ce6a77a89847..87ae4c30712a 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -609,8 +609,8 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  
>  %type <expr>			rhs_expr concat_rhs_expr basic_rhs_expr
>  %destructor { expr_free($$); }	rhs_expr concat_rhs_expr basic_rhs_expr
> -%type <expr>			primary_rhs_expr list_rhs_expr shift_rhs_expr
> -%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr shift_rhs_expr
> +%type <expr>			primary_rhs_expr list_rhs_expr shift_rhs_expr symbol_rhs_expr
> +%destructor { expr_free($$); }	primary_rhs_expr list_rhs_expr shift_rhs_expr symbol_rhs_expr
>  %type <expr>			and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
>  %destructor { expr_free($$); }	and_rhs_expr exclusive_or_rhs_expr inclusive_or_rhs_expr
>  
> @@ -3302,14 +3302,17 @@ ct_key_dir_optional	:	BYTES		{ $$ = NFT_CT_BYTES; }
>  			|	ZONE		{ $$ = NFT_CT_ZONE; }
>  			;
>  
> +symbol_rhs_expr		:	symbol_expr
> +			|	keyword_expr

Could you rename this to symbol_stmt_expr?

So it's clear this refers to the grammar tree that deals with
*stmt_expr. Apart from that nitpick.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
