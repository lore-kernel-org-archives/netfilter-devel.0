Return-Path: <SRS0=okMr=EL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 229D9C4741F
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 15:23:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59DF220759
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 Nov 2020 15:23:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="IqVZXDSD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731204AbgKEPXC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 Nov 2020 10:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730660AbgKEPXB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Nov 2020 10:23:01 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157A4C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu,  5 Nov 2020 07:23:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4J+kjjUdlnsleRFinmIzyebkJWX73Z7f9io5vyaCgJY=; b=IqVZXDSDpiRB1xKMV2h0vh7w9C
        V3m4yntLqJvZK2EU/SU7H0q/zKUDX0xc92WCtA/kOZxK9EaXutZMMEwsnwIeQqQ6xv1VuBxvLrPw0
        8NJOOOWoVSltlyDb17WI3DsSf6cU5xqGbzps/RK0+E+ohF4lemN43j219J5PQUYYBxvPjvKX38RYX
        uji5luCK4CGYmCWVPy4Da0qiuz7xnR8suHMoNGLsJ8DbMvS/SqKUOv2oPLuoBFkQ+54elj4QJu/SG
        H+MFm7WmEY+Cxe2kxNtO9CTwj6ukkrkBadSoSAgbK/d5RBxPSbGyT0t/hoOJi6bax5LvP2/i8Fz1e
        k0mBQFog==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1kah6H-0006Fy-7x; Thu, 05 Nov 2020 15:22:57 +0000
Date:   Thu, 5 Nov 2020 15:22:56 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/7] parser: merge sack-perm/sack-permitted and
 maxseg/mss
Message-ID: <20201105152256.GA3399@azazel.net>
References: <20201105141144.31430-1-fw@strlen.de>
 <20201105141144.31430-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20201105141144.31430-2-fw@strlen.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:5ec5:d4ff:fe95:cee6
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-11-05, at 15:11:38 +0100, Florian Westphal wrote:
> One was added by the tcp option parsing ocde, the other by synproxy.
>
> So we have:
> synproxy ... sack-perm
> synproxy ... mss
>
> and
>
> tcp option maxseg
> tcp option sack-permitted
>
> This kills the extra tokens on the scanner/parser side,
> so sack-perm and sack-permitted can both be used.
>
> Likewise, 'synproxy maxseg' and 'tcp option mss size 42' will
> work too.  On the output side, the shorter form is now preferred,
> i.e. sack-perm and mss.
>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  doc/payload-expression.txt    |  8 ++++----
>  src/parser_bison.y            | 13 ++++++-------
>  src/scanner.l                 |  8 ++++----
>  src/tcpopt.c                  |  2 +-
>  tests/py/any/tcpopt.t         |  4 ++--
>  tests/py/any/tcpopt.t.json    |  8 ++++----
>  tests/py/any/tcpopt.t.payload | 12 ++++++------
>  7 files changed, 27 insertions(+), 28 deletions(-)
>
> diff --git a/doc/payload-expression.txt b/doc/payload-expression.txt
> index 93d4d22f59f5..9df20a18ae8a 100644
> --- a/doc/payload-expression.txt
> +++ b/doc/payload-expression.txt
> @@ -525,13 +525,13 @@ nftables currently supports matching (finding) a given ipv6 extension header, TC
>  *dst* {*nexthdr* | *hdrlength*}
>  *mh* {*nexthdr* | *hdrlength* | *checksum* | *type*}
>  *srh* {*flags* | *tag* | *sid* | *seg-left*}
> -*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
> +*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*} 'tcp_option_field'
>  *ip option* { lsrr | ra | rr | ssrr } 'ip_option_field'
>
>  The following syntaxes are valid only in a relational expression with boolean type on right-hand side for checking header existence only:
>  [verse]
>  *exthdr* {*hbh* | *frag* | *rt* | *dst* | *mh*}
> -*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-permitted* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
> +*tcp option* {*eol* | *noop* | *maxseg* | *window* | *sack-perm* | *sack* | *sack0* | *sack1* | *sack2* | *sack3* | *timestamp*}
>  *ip option* { lsrr | ra | rr | ssrr }
>
>  .IPv6 extension headers
> @@ -568,7 +568,7 @@ kind, length, size
>  |window|
>  TCP Window Scaling |
>  kind, length, count
> -|sack-permitted|
> +|sack-perm |
>  TCP SACK permitted |
>  kind, length
>  |sack|
> @@ -611,7 +611,7 @@ type, length, ptr, addr
>
>  .finding TCP options
>  --------------------
> -filter input tcp option sack-permitted kind 1 counter
> +filter input tcp option sack-perm kind 1 counter
>  --------------------
>
>  .matching IPv6 exthdr
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 9bf4f71f1f66..8c37f895167e 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -233,7 +233,6 @@ int nft_lex(void *, void *, void *);
>  %token SYNPROXY			"synproxy"
>  %token MSS			"mss"
>  %token WSCALE			"wscale"
> -%token SACKPERM			"sack-perm"
>
>  %token TYPEOF			"typeof"
>
> @@ -400,14 +399,13 @@ int nft_lex(void *, void *, void *);
>  %token OPTION			"option"
>  %token ECHO			"echo"
>  %token EOL			"eol"
> -%token MAXSEG			"maxseg"
>  %token NOOP			"noop"
>  %token SACK			"sack"
>  %token SACK0			"sack0"
>  %token SACK1			"sack1"
>  %token SACK2			"sack2"
>  %token SACK3			"sack3"
> -%token SACK_PERMITTED		"sack-permitted"
> +%token SACK_PERM		"sack-permitted"
>  %token TIMESTAMP		"timestamp"
>  %token KIND			"kind"
>  %token COUNT			"count"
> @@ -3279,7 +3277,7 @@ synproxy_arg		:	MSS	NUM
>  			{
>  				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_TIMESTAMP;
>  			}
> -			|	SACKPERM
> +			|	SACK_PERM
>  			{
>  				$<stmt>0->synproxy.flags |= NF_SYNPROXY_OPT_SACK_PERM;
>  			}
> @@ -3334,7 +3332,7 @@ synproxy_ts		:	/* empty */	{ $$ = 0; }
>  			;
>
>  synproxy_sack		:	/* empty */	{ $$ = 0; }
> -			|	SACKPERM
> +			|	SACK_PERM
>  			{
>  				$$ = NF_SYNPROXY_OPT_SACK_PERM;
>  			}
> @@ -5216,9 +5214,10 @@ tcp_hdr_field		:	SPORT		{ $$ = TCPHDR_SPORT; }
>
>  tcp_hdr_option_type	:	EOL		{ $$ = TCPOPTHDR_EOL; }
>  			|	NOOP		{ $$ = TCPOPTHDR_NOOP; }
> -			|	MAXSEG		{ $$ = TCPOPTHDR_MAXSEG; }
> +			|	MSS  	  	{ $$ = TCPOPTHDR_MAXSEG; }
> +			|	SACK_PERM	{ $$ = TCPOPTHDR_SACK_PERMITTED; }
>  			|	WINDOW		{ $$ = TCPOPTHDR_WINDOW; }
> -			|	SACK_PERMITTED	{ $$ = TCPOPTHDR_SACK_PERMITTED; }
> +			|	WSCALE		{ $$ = TCPOPTHDR_WINDOW; }

Did you mean to add this here?

>  			|	SACK		{ $$ = TCPOPTHDR_SACK0; }
>  			|	SACK0		{ $$ = TCPOPTHDR_SACK0; }
>  			|	SACK1		{ $$ = TCPOPTHDR_SACK1; }
> diff --git a/src/scanner.l b/src/scanner.l
> index 7afd9bfb8893..516c648f1c1f 100644
> --- a/src/scanner.l
> +++ b/src/scanner.l
> @@ -421,14 +421,16 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>
>  "echo"			{ return ECHO; }
>  "eol"			{ return EOL; }
> -"maxseg"		{ return MAXSEG; }
> +"maxseg"		{ return MSS; }
> +"mss"			{ return MSS; }
>  "noop"			{ return NOOP; }
>  "sack"			{ return SACK; }
>  "sack0"			{ return SACK0; }
>  "sack1"			{ return SACK1; }
>  "sack2"			{ return SACK2; }
>  "sack3"			{ return SACK3; }
> -"sack-permitted"	{ return SACK_PERMITTED; }
> +"sack-permitted"	{ return SACK_PERM; }
> +"sack-perm"		{ return SACK_PERM; }
>  "timestamp"		{ return TIMESTAMP; }
>  "time"			{ return TIME; }
>
> @@ -565,9 +567,7 @@ addrstring	({macaddr}|{ip4addr}|{ip6addr})
>  "osf"			{ return OSF; }
>
>  "synproxy"		{ return SYNPROXY; }
> -"mss"			{ return MSS; }
>  "wscale"		{ return WSCALE; }
> -"sack-perm"		{ return SACKPERM; }
>
>  "notrack"		{ return NOTRACK; }
>
> diff --git a/src/tcpopt.c b/src/tcpopt.c
> index ec305d9466d5..6dbaa9e6dd17 100644
> --- a/src/tcpopt.c
> +++ b/src/tcpopt.c
> @@ -55,7 +55,7 @@ static const struct exthdr_desc tcpopt_window = {
>  };
>
>  static const struct exthdr_desc tcpopt_sack_permitted = {
> -	.name		= "sack-permitted",
> +	.name		= "sack-perm",
>  	.type		= TCPOPT_SACK_PERMITTED,
>  	.templates	= {
>  		[TCPOPTHDR_FIELD_KIND]		= PHT("kind",   0, 8),
> diff --git a/tests/py/any/tcpopt.t b/tests/py/any/tcpopt.t
> index 08b1dcb3c489..5f21d4989fea 100644
> --- a/tests/py/any/tcpopt.t
> +++ b/tests/py/any/tcpopt.t
> @@ -12,8 +12,8 @@ tcp option maxseg size 1;ok
>  tcp option window kind 1;ok
>  tcp option window length 1;ok
>  tcp option window count 1;ok
> -tcp option sack-permitted kind 1;ok
> -tcp option sack-permitted length 1;ok
> +tcp option sack-perm kind 1;ok
> +tcp option sack-perm length 1;ok
>  tcp option sack kind 1;ok
>  tcp option sack length 1;ok
>  tcp option sack left 1;ok
> diff --git a/tests/py/any/tcpopt.t.json b/tests/py/any/tcpopt.t.json
> index 48eb339cee35..2c6236a1a152 100644
> --- a/tests/py/any/tcpopt.t.json
> +++ b/tests/py/any/tcpopt.t.json
> @@ -126,14 +126,14 @@
>      }
>  ]
>
> -# tcp option sack-permitted kind 1
> +# tcp option sack-perm kind 1
>  [
>      {
>          "match": {
>              "left": {
>                  "tcp option": {
>                      "field": "kind",
> -                    "name": "sack-permitted"
> +                    "name": "sack-perm"
>                  }
>              },
>              "op": "==",
> @@ -142,14 +142,14 @@
>      }
>  ]
>
> -# tcp option sack-permitted length 1
> +# tcp option sack-perm length 1
>  [
>      {
>          "match": {
>              "left": {
>                  "tcp option": {
>                      "field": "length",
> -                    "name": "sack-permitted"
> +                    "name": "sack-perm"
>                  }
>              },
>              "op": "==",
> diff --git a/tests/py/any/tcpopt.t.payload b/tests/py/any/tcpopt.t.payload
> index 63751cf26e75..f63076ae497e 100644
> --- a/tests/py/any/tcpopt.t.payload
> +++ b/tests/py/any/tcpopt.t.payload
> @@ -166,42 +166,42 @@ inet
>    [ exthdr load tcpopt 1b @ 3 + 2 => reg 1 ]
>    [ cmp eq reg 1 0x00000001 ]
>
> -# tcp option sack-permitted kind 1
> +# tcp option sack-perm kind 1
>  ip
>    [ meta load l4proto => reg 1 ]
>    [ cmp eq reg 1 0x00000006 ]
>    [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
>    [ cmp eq reg 1 0x00000001 ]
>
> -# tcp option sack-permitted kind 1
> +# tcp option sack-perm kind 1
>  ip6
>    [ meta load l4proto => reg 1 ]
>    [ cmp eq reg 1 0x00000006 ]
>    [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
>    [ cmp eq reg 1 0x00000001 ]
>
> -# tcp option sack-permitted kind 1
> +# tcp option sack-perm kind 1
>  inet
>    [ meta load l4proto => reg 1 ]
>    [ cmp eq reg 1 0x00000006 ]
>    [ exthdr load tcpopt 1b @ 4 + 0 => reg 1 ]
>    [ cmp eq reg 1 0x00000001 ]
>
> -# tcp option sack-permitted length 1
> +# tcp option sack-perm length 1
>  ip
>    [ meta load l4proto => reg 1 ]
>    [ cmp eq reg 1 0x00000006 ]
>    [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
>    [ cmp eq reg 1 0x00000001 ]
>
> -# tcp option sack-permitted length 1
> +# tcp option sack-perm length 1
>  ip6
>    [ meta load l4proto => reg 1 ]
>    [ cmp eq reg 1 0x00000006 ]
>    [ exthdr load tcpopt 1b @ 4 + 1 => reg 1 ]
>    [ cmp eq reg 1 0x00000001 ]
>
> -# tcp option sack-permitted length 1
> +# tcp option sack-perm length 1
>  inet
>    [ meta load l4proto => reg 1 ]
>    [ cmp eq reg 1 0x00000006 ]
> --
> 2.26.2
>
>

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl+kGMYACgkQonv1GCHZ
79dHcQv/Xw2aGnosf+lRI5aX0dyM22BONddUp3fb4PQzW9XqHg2p5fp7NhBwuXYk
S0TbW18NptQz0+YXRCGf3BR9iF1Mb06PJbRQhRsKvl1pKNAPzHlZVGjG/NRhJEZF
9A8/kDThb9ls2GFLIIzD7hh5pIHT3TiZqhIzdm4JKLtKyJRm4PMzw9tdqc1ab6zm
NbiZPe5p9FZnmYd0iVX/lE+2KSvOSLtkvQeckDjUPsjlRXOm90UZYq58d86wFMiO
AtKavG8oJQj3cxNe1iaX+zXtBFHI2M/ZqaWuSiL2vQ2ankn96DAyOqklpyv8Waqk
C3qjxEzT7EqLVaxGejwueR0Sv/xxa0FxicA1Qvjo6h/SsnWajbe8QWNOTUrOUZAF
JTrOGrM+qCOgviZdZ1pAG41d+X2/ttEHtMV2a6xTIwtdnXqN206lDJjygqw/tScy
4tZ6jA/vtmU9Sm/bxARuQmf7/F1rDT4iwTe5fnTaajpa63oZRtGhRkUs4VhGbbsh
xKTtlwP9
=sq0d
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
