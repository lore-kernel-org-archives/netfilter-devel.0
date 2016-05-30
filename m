From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] parser: Check commentaries length
Date: Mon, 30 May 2016 17:57:19 +0200
Message-ID: <20160530155719.GB24746@salvia>
References: <1464622860-31287-1-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47647 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161499AbcE3P5Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 11:57:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1D1D5178E8E
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 17:57:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0AEF21B3238
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 17:57:23 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C742F1B3238
	for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 17:57:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464622860-31287-1-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 30, 2016 at 05:41:00PM +0200, Carlos Falgueras Garc=EDa wro=
te:
> Checks the commentary maximum length and reports to user in case of e=
rror.
>=20
> The commentary rule of the parser was simplified in order to centrali=
ze the
> length checking.
>=20
> Signed-off-by: Carlos Falgueras Garc=EDa <carlosfg@riseup.net>
> ---
>  include/parser.h   |  6 ++++++
>  src/parser_bison.y | 31 ++++++++++++++++++++-----------
>  2 files changed, 26 insertions(+), 11 deletions(-)
>=20
> diff --git a/include/parser.h b/include/parser.h
> index 92beab2..f48fcfd 100644
> --- a/include/parser.h
> +++ b/include/parser.h
> @@ -13,6 +13,12 @@
> =20
>  #define SCOPE_NEST_MAX			3
> =20
> +/*
> + * This maximum is set to 32 bytes in order to keep the coherence wi=
th others
> + * string length in nft objects
> + */
> +#define MAX_COMM_LEN			32

Please, define this in rule.h together with the UDATA_* definitions.

This limitation has to do with the userdata area, so better if this
naming remember us why we have this restriction.

And bump it to 128 characters I'd suggest. This is half of what we
support in x_tables comment match, but better be conservative and wait
for users asking for longer descriptions.

>  struct parser_state {
>  	struct input_descriptor		*indesc;
>  	struct input_descriptor		indescs[MAX_INCLUDE_DEPTH];
> diff --git a/src/parser_bison.y b/src/parser_bison.y
> index 0452b8f..c159684 100644
> --- a/src/parser_bison.y
> +++ b/src/parser_bison.y
> @@ -440,7 +440,7 @@ static void location_update(struct location *loc,=
 struct location *rhs, int n)
>  %destructor { close_scope(state); table_free($$); }	table_block_allo=
c
>  %type <chain>			chain_block_alloc chain_block
>  %destructor { close_scope(state); chain_free($$); }	chain_block_allo=
c
> -%type <rule>			rule
> +%type <rule>			rule rule_alloc
>  %destructor { rule_free($$); }	rule
> =20
>  %type <val>			set_flag_list	set_flag
> @@ -1271,12 +1271,13 @@ ruleid_spec		:	chain_spec	handle_spec	positio=
n_spec
>  			}
>  			;
> =20
> -comment_spec		:	/* empty */
> -			{
> -				$$ =3D NULL;
> -			}
> -			|	COMMENT		string
> +comment_spec		:	COMMENT		string
>  			{
> +				if (strlen($2) > MAX_COMM_LEN) {
> +					erec_queue(error(&@2, "Comment too long.  %d character maximun =
allowed", MAX_COMM_LEN),
> +						   state->msgs);
> +					YYERROR;
> +				}
>  				$$ =3D $2;
>  			}
>  			;
> @@ -1293,18 +1294,26 @@ ruleset_spec		:	/* empty */
>  			}
>  			;
> =20
> -rule			:	stmt_list	comment_spec
> +rule			:	rule_alloc
> +			{
> +				$$->comment =3D NULL;
> +			}
> +			|	rule_alloc	comment_spec
> +			{
> +				$$->comment =3D $2;
> +			}
> +			;
> +

This should happpen in a separated patch.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
