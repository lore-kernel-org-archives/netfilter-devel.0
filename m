From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Sat, 4 Apr 2015 13:55:50 +0200
Message-ID: <20150404115550.GA5832@salvia>
References: <551FC211.6000907@ahsoftware.de>
 <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>, kaber@trash.net
To: Alexander Holler <holler@ahsoftware.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33036 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbbDDLwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2015 07:52:12 -0400
Content-Disposition: inline
In-Reply-To: <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 04, 2015 at 01:13:06PM +0200, Alexander Holler wrote:
> Context sensitive handling of "param-problem" and "redirect" is necessary
> to allow usage of them as token or as string for icmp types.
[...]

I think we need some evaluation step at scanner level. This new
evaluation routine needs to understand the token semantics to set some
context information.

"redirect"		{ return scanner_evaluate(ctx, REDIRECT); }

We have to catch up more use cases such as sets and concatenations. I
started a patch here, a bit more generalized than this when you
reported this problem (we actually already knew about it).

@Patrick, any better idea?

> ---------------------
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  src/parser_bison.y |  8 +++++---
>  src/scanner.l      | 30 ++++++++++++++++++++++++------
>  2 files changed, 29 insertions(+), 9 deletions(-)
> 
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index b86381d..af40195 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -34,6 +34,8 @@
>  
>  #include "parser_bison.h"
>  
> +int icmp_flag;
> +
>  void parser_init(struct parser_state *state, struct list_head *msgs)
>  {
>  	memset(state, 0, sizeof(*state));
> @@ -445,7 +447,7 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %destructor { stmt_free($$); }	limit_stmt
>  %type <val>			time_unit
>  %type <stmt>			reject_stmt reject_stmt_alloc
> -%destructor { stmt_free($$); }	reject_stmt reject_stmt_alloc
> +%destructor { stmt_free($$); icmp_flag = 0; }	reject_stmt reject_stmt_alloc
>  %type <stmt>			nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
>  %destructor { stmt_free($$); }	nat_stmt nat_stmt_alloc masq_stmt masq_stmt_alloc redir_stmt redir_stmt_alloc
>  %type <val>			nf_nat_flags nf_nat_flag
> @@ -500,10 +502,10 @@ static void location_update(struct location *loc, struct location *rhs, int n)
>  %destructor { expr_free($$); }	arp_hdr_expr
>  %type <val>			arp_hdr_field
>  %type <expr>			ip_hdr_expr	icmp_hdr_expr
> -%destructor { expr_free($$); }	ip_hdr_expr	icmp_hdr_expr
> +%destructor { expr_free($$); icmp_flag = 0; }	ip_hdr_expr	icmp_hdr_expr
>  %type <val>			ip_hdr_field	icmp_hdr_field
>  %type <expr>			ip6_hdr_expr    icmp6_hdr_expr
> -%destructor { expr_free($$); }	ip6_hdr_expr	icmp6_hdr_expr
> +%destructor { expr_free($$); icmp_flag = 0; }	ip6_hdr_expr	icmp6_hdr_expr
>  %type <val>			ip6_hdr_field   icmp6_hdr_field
>  %type <expr>			auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
>  %destructor { expr_free($$); }	auth_hdr_expr	esp_hdr_expr		comp_hdr_expr
> diff --git a/src/scanner.l b/src/scanner.l
> index 73c4f8b..3a058ad 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -100,6 +100,7 @@ static void reset_pos(struct parser_state *state, struct location *loc)
>  /* avoid warnings with -Wmissing-prototypes */
>  extern int	yyget_column(yyscan_t);
>  extern void	yyset_column(int, yyscan_t);
> +extern int icmp_flag;
>  
>  %}
>  
> @@ -320,7 +321,14 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "snat"			{ return SNAT; }
>  "dnat"			{ return DNAT; }
>  "masquerade"		{ return MASQUERADE; }
> -"redirect"		{ return REDIRECT; }
> +"redirect"		{
> +				if (icmp_flag == 4) {
> +					yylval->string = xstrdup(yytext);
> +					return STRING;
> +				} else
> +					return REDIRECT;
> +			}
> +
>  "random"		{ return RANDOM; }
>  "fully-random"		{ return FULLY_RANDOM; }
>  "persistent"		{ return PERSISTENT; }
> @@ -334,8 +342,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "ether"			{ return ETHER; }
>  "saddr"			{ return SADDR; }
>  "daddr"			{ return DADDR; }
> -"type"			{ return TYPE; }
> -
> +"type"			{
> +				if (icmp_flag)
> +					++icmp_flag;
> +				return TYPE;
> +			}
>  "vlan"			{ return VLAN; }
>  "id"			{ return ID; }
>  "cfi"			{ return CFI; }
> @@ -358,7 +369,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "protocol"		{ return PROTOCOL; }
>  "checksum"		{ return CHECKSUM; }
>  
> -"icmp"			{ return ICMP; }
> +"icmp"			{ icmp_flag = 3; return ICMP; }
>  "code"			{ return CODE; }
>  "sequence"		{ return SEQUENCE; }
>  "gateway"		{ return GATEWAY; }
> @@ -369,9 +380,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "flowlabel"		{ return FLOWLABEL; }
>  "nexthdr"		{ return NEXTHDR; }
>  "hoplimit"		{ return HOPLIMIT; }
> +"icmpv6"		{ icmp_flag = 5; return ICMP6; }
> +"param-problem"		{
> +				if (icmp_flag == 6) {
> +					yylval->string = xstrdup(yytext);
> +					return STRING;
> +				} else
> +					return PPTR;
> +			}
> +
>  
> -"icmpv6"		{ return ICMP6; }
> -"param-problem"		{ return PPTR; }
>  "max-delay"		{ return MAXDELAY; }
>  
>  "ah"			{ return AH; }
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
