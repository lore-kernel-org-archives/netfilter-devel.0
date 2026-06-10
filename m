Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F321A27FD4B
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jun 2026 15:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781104607; cv=none; b=Sefdd2uqLREb3kd/oqzLwykbaPyvRxh30fV8u4gtvK3izNaLaPR/n/88AysmvrtkKX9Q0B/BmybTlg/7qHZlBAeFNK/9kZlCx7YEJcj3f+9ybMGY1GyfVLvWiHPoYjQ3QAzdZj+/oULSuWf29FfrzP+1qw3HoMrh8EvXOZXGBVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781104607; c=relaxed/simple;
	bh=E0d7JZJoGWWn1Bfkn994sp3PQhvUIEXMIywsb91H+IY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoaOl+cCcHVAFduhOjEk26vDLdZtVN7ZRBvbYfuBNwFK7yyUUFvMSML6x/XEeBnaWuSHexD+sXtZ9/xuaAgM11Ju9T/oqVtXr/rU7stC7J5WySU//t2Be4nJ1jqRU90jPNcoOpcdwMovbIlhUqtnbvQ3NiY5JHUi4tZLoZj8+Iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CgIJ6SiM; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CgIJ6SiM"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id AC4716017E;
	Wed, 10 Jun 2026 17:16:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1781104601;
	bh=WxJ6YyW1/dx6lkxuhZYC/R0OCPFfNM0vhYM25rqK1kM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CgIJ6SiMcHpjbzR/fo0E6c9+av2CPYGMvRDj4RDYYrj2TkpgHGHyjOQHGeLh59DSs
	 TJn2qyldIMXuOexamct6MRbxuSqrV3KRzYXEm4abAyVfhsX+l2cy0IMHdzGZAiXPkx
	 7/Ra+QRAgCdJrWQML2KyBsvrxlIujwqxkSZyiip1UtV7QCGKcBolQ3fRqcacbINDPa
	 643b92sV3/dcOdFj/q0aWGRko1yLPSzez14D/XLDyukjiiewIyvmBiZNgBwEdUs6cX
	 uiZSRIUlXr6edjmUbYavfAD4iD0agIOHq8y7X6z/4YDORSfzpAST6J/XNIHplkD8YW
	 2dcgiCq2K6PUQ==
Date: Wed, 10 Jun 2026 17:16:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
	Jan =?utf-8?Q?Ko=C5=84czak?= <jan.konczak@cs.put.poznan.pl>
Subject: Re: [nft PATCH] parser_bison: Fix for bison < 3.6
Message-ID: <ail_1zfc4s__gnNI@chamomile>
References: <20260610115709.3982133-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260610115709.3982133-1-phil@nwl.cc>

Hi Phil,

On Wed, Jun 10, 2026 at 01:57:09PM +0200, Phil Sutter wrote:
> Support for 'custom' parse.error value was added in bison-3.6. Fall back
> to previous value for earlier versions.
> 
> This is harder to get right than it seems: On one hand, preprocessor
> macros can't be used in parser_bison.y's declaration section and
> automake forbids conditional changes to AM_YFLAGS on the other.
> 
> Suggested-by: Jan Kończak <jan.konczak@cs.put.poznan.pl>
> Fixes: 67b822f2b2624 ("parser_bison: on syntax errors, output expected tokens")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  Makefile.am        |  6 ++++++
>  configure.ac       | 12 ++++++++++++
>  src/parser_bison.y |  4 ++--
>  3 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile.am b/Makefile.am
> index fa71e06eefee5..ddf145a87c810 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -164,6 +164,12 @@ AM_CFLAGS = \
>  	$(NULL)
>  
>  AM_YFLAGS = -d -Wno-yacc
> +if BISON_CUSTOM_ERROR
> +YACC += -D parse.error=custom -D parse.lac=full
> +AM_CFLAGS += -DBISON_CUSTOM_ERROR
> +else
> +YACC += -D parse.error=verbose
> +endif
>  
>  if BUILD_PROFILING
>  AM_CFLAGS += --coverage
> diff --git a/configure.ac b/configure.ac
> index 0d3ee2ac89f69..b6cad3117a51b 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -45,6 +45,18 @@ then
>          exit 1
>  fi
>  
> +AC_ARG_ENABLE([extended_parser_errors],
> +	      AS_HELP_STRING([--disable-extended-parser-errors],
> +			     [Disable use of parse.error=custom and LAC in Bison]),
> +	      [], [
> +			enable_extended_parser_errors=no
> +			AC_SUBST([BISON], [$ac_cv_prog_YACC])
> +			AX_PROG_BISON_VERSION([3.6],
> +					      [enable_extended_parser_errors=yes])
> +	      ])
> +AM_CONDITIONAL([BISON_CUSTOM_ERROR],
> +	       [test "x$enable_extended_parser_errors" != xno])

Can this be made transparent? ie. if bison >= 3.6, then enable it
always. Otherwise, disable it.

Then, include this information here in configure.ac:

echo "
nft configuration:
  cli support:                  ${with_cli}
  enable debugging symbols:     ${enable_debug}
  use mini-gmp:                 ${with_mini_gmp}
  enable man page:              ${enable_man_doc}
  libxtables support:           ${with_xtables}
  json output support:          ${with_json}
  collect profiling data:       ${enable_profiling}"

and here with -V:

# nft -V
nftables v1.1.6 (Commodore Bullmoose #7)
  cli:          editline
  json:         yes
  minigmp:      no
  libxtables:   yes

Maybe add:

  bison >= 3.6: yes

or similar?

Thanks

>  AM_PROG_AR
>  LT_INIT([disable-static])
>  AC_EXEEXT
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 5a334bf0c4997..fc95597d898c0 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -221,8 +221,6 @@ int nft_lex(void *, void *, void *);
>  %parse-param		{ void *scanner }
>  %parse-param		{ struct parser_state *state }
>  %lex-param		{ scanner }
> -%define parse.error custom
> -%define parse.lac full
>  %locations
>  
>  %initial-action {
> @@ -6537,6 +6535,7 @@ exthdr_key		:	HBH	close_scope_hbh	{ $$ = IPPROTO_HOPOPTS; }
>  
>  %%
>  
> +#ifdef BISON_CUSTOM_ERROR
>  static int
>  yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
>                        void *scanner, struct parser_state *state)
> @@ -6592,3 +6591,4 @@ yyreport_syntax_error(const yypcontext_t *yyctx, struct nft_ctx *nft,
>  	free(msg);
>  	return 0;
>  }
> +#endif /* BISON_CUSTOM_ERROR */
> -- 
> 2.54.0
> 
