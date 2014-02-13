From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Thu, 13 Feb 2014 11:51:12 +0000
Message-ID: <20140213115112.GA30397@macbook.localnet>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
 <1392291672-7885-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38938 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaBMLvQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:51:16 -0500
Content-Disposition: inline
In-Reply-To: <1392291672-7885-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 12:41:12PM +0100, Pablo Neira Ayuso wrote:
> hexstring:hexstring
> hexstring:
> :hexstring
> ---
> The spaces to separate the key and the action in dictionaries is very
> important, otherwise (with this patch) the scanner misinterprets this.
> 
>  # nft add filter input tcp dport vmap { 25:drop }
>  <cmdline>:1:41-43: Error: syntax error, unexpected string, expecting comma or '}'
>  add rule filter input tcp dport vmap { 25:drop }
>                                         ^^^
> I think we can just document this, I don't see any better solution for this
> at this moment.

Let me try if I can come up with something ...

> 
>  src/scanner.l |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/src/scanner.l b/src/scanner.l
> index e4cb398..ea61fa0 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -109,7 +109,7 @@ digit		[0-9]
>  hexdigit	[0-9a-fA-F]
>  decstring	{digit}+
>  hexstring	0[xX]{hexdigit}+
> -range		({decstring}?:{decstring}?)
> +priostring	{hexdigit}{0,4}:{hexdigit}{0,4}
>  letter		[a-zA-Z]
>  string		({letter})({letter}|{digit}|[/\-_\.])*
>  quotedstring	\"[^"]*\"
> @@ -447,6 +447,11 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  				return STRING;
>  			}
>  
> +{priostring}		{
> +				yylval->string = xstrdup(yytext);
> +				return STRING;
> +			}
> +
>  \\{newline}		{
>  				reset_pos(yyget_extra(yyscanner), yylloc);
>  			}
> -- 
> 1.7.10.4
