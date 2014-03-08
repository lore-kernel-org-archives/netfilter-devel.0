From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/3] example/nft-rule-insert: fixed and merged
 this example with nft-rule-add
Date: Sat, 8 Mar 2014 15:16:53 +0100
Message-ID: <20140308141653.GA7854@localhost>
References: <20140308140039.13220.89013.stgit@Ph0enix>
 <20140308140045.13220.19401.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44115 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbaCHORB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 09:17:01 -0500
Content-Disposition: inline
In-Reply-To: <20140308140045.13220.19401.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 08, 2014 at 03:00:45PM +0100, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <anayuso@sysmocom.de>
>=20
> Merged the example for inserting rules and fixed for using
> the correct header.
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> Signed-off-by: Alvaro Neira Ayuso <anayuso@sysmocom.de>
> ---
>  examples/nft-rule-add.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>=20
> diff --git a/examples/nft-rule-add.c b/examples/nft-rule-add.c
> index 21b3bf8..7407a78 100644
> --- a/examples/nft-rule-add.c
> +++ b/examples/nft-rule-add.c
> @@ -80,11 +80,12 @@ static void add_counter(struct nft_rule *r)
>  }
> =20
>  static struct nft_rule *setup_rule(uint8_t family, const char *table=
,
> -				   const char *chain)
> +				   const char *chain, const char *handle)
>  {
>  	struct nft_rule *r =3D NULL;
>  	uint8_t proto;
>  	uint16_t dport;
> +	uint64_t hand;

Oh, this variable name is horrible, better handle_num?

>  	r =3D nft_rule_alloc();
>  	if (r =3D=3D NULL) {
> @@ -96,6 +97,12 @@ static struct nft_rule *setup_rule(uint8_t family,=
 const char *table,
>  	nft_rule_attr_set(r, NFT_RULE_ATTR_CHAIN, chain);
>  	nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
> =20
> +	if (handle !=3D NULL) {
> +		printf("entra\n");
                ^----------------^

I think you have to remove that.

> +		hand =3D atoi(handle);

This is u64, atoi is just 32 bits. You can use atoll or strtoull.

> +		nft_rule_attr_set(r, NFT_RULE_ATTR_POSITION, &hand);

Use nft_rule_attr_set_u64, please.

> +	}
> +
>  	proto =3D IPPROTO_TCP;
>  	add_payload(r, NFT_PAYLOAD_NETWORK_HEADER, NFT_REG_1,
>  		    offsetof(struct iphdr, protocol), sizeof(uint8_t));
> @@ -138,7 +145,7 @@ int main(int argc, char *argv[])
>  	uint32_t seq =3D time(NULL);
>  	int ret;
> =20
> -	if (argc !=3D 4) {
> +	if (argc < 4 || argc > 5) {
>  		fprintf(stderr, "Usage: %s <family> <table> <chain>\n", argv[0]);
>  		exit(EXIT_FAILURE);
>  	}
> @@ -152,7 +159,10 @@ int main(int argc, char *argv[])
>  		exit(EXIT_FAILURE);
>  	}
> =20
> -	r =3D setup_rule(family, argv[2], argv[3]);
> +	if (argc !=3D 5)
> +		r =3D setup_rule(family, argv[2], argv[3], NULL);
> +	else
> +		r =3D setup_rule(family, argv[2], argv[3], argv[4]);
> =20
>  	nl =3D mnl_socket_open(NETLINK_NETFILTER);
>  	if (nl =3D=3D NULL) {
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
