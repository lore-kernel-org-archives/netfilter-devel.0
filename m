From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 4/6] chain: json: add function for parsing
 chain
Date: Thu, 25 Jul 2013 23:13:00 +0200
Message-ID: <20130725211300.GE7113@localhost>
References: <20130725205215.26223.77001.stgit@Ph0enix>
 <20130725205239.26223.9493.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, eric@regit.org
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43923 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756175Ab3GYVNJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Jul 2013 17:13:09 -0400
Content-Disposition: inline
In-Reply-To: <20130725205239.26223.9493.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 25, 2013 at 10:52:39PM +0200, Alvaro Neira wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Add function for parsing chains in format JSON
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  include/libnftables/chain.h |    1=20
>  src/chain.c                 |  138 +++++++++++++++++++++++++++++++++=
++++++++++
>  2 files changed, 139 insertions(+)
>=20
> diff --git a/include/libnftables/chain.h b/include/libnftables/chain.=
h
> index 382947f..53fd407 100644
> --- a/include/libnftables/chain.h
> +++ b/include/libnftables/chain.h
> @@ -52,6 +52,7 @@ enum {
>  enum nft_chain_parse_type {
>  	NFT_CHAIN_PARSE_NONE	=3D 0,
>  	NFT_CHAIN_PARSE_XML,
> +	NFT_CHAIN_PARSE_JSON,
>  	NFT_CHAIN_PARSE_MAX
>  };
> =20
> diff --git a/src/chain.c b/src/chain.c
> index 1e07044..d9d41ee 100644
> --- a/src/chain.c
> +++ b/src/chain.c
> @@ -468,6 +468,141 @@ int nft_chain_nlmsg_parse(const struct nlmsghdr=
 *nlh, struct nft_chain *c)
>  }
>  EXPORT_SYMBOL(nft_chain_nlmsg_parse);
> =20
> +static int str2policy(const char *policy)
> +{
> +	if (strcmp("accept", policy) =3D=3D 0) {
> +		return NF_ACCEPT;
> +	} else if (strcmp("drop", policy) =3D=3D 0) {
> +		return NF_DROP;
> +	} else {
> +		return -1;
> +	}
> +}

Arturo just added nft_str2verdict, please use it.

> +
> +static int nft_chain_json_parse(struct nft_chain *c, char *json)
> +{
> +#ifdef JSON_PARSING
> +	json_t *root;
> +	json_error_t error;
> +	uint64_t val64;
> +	uint32_t hooknum;
> +	int32_t prio;
> +	const char *valstr;
> +
> +	/* Load the tree */
> +	root =3D json_loadb (json, strlen(json), 0, &error);
                         ^
no need for space there.

> +	if (!root) {

if (root =3D=3D NULL)

for consistency with other code you sent.

> +		errno =3D EINVAL;
> +		return -1;
> +	}
> +
> +	root =3D json_object_get(root, "chain");
> +	if (root =3D=3D NULL) {
> +		errno =3D ERANGE;
> +		return -1;
> +	}
> +
> +	if (nft_jansson_value_parse_val(root, "version", NFT_TYPE_U64,
> +					 &val64) =3D=3D -1)
> +		goto err;
> +
> +	if (val64 !=3D NFT_CHAIN_JSON_VERSION)
> +		goto err;
> +
> +	valstr =3D nft_jansson_value_parse_str(root, "name");
> +	if (valstr =3D=3D NULL)
> +		goto err;

You have to change nft_jansson_value_parse_str to set errno
accordingly.

Then you return -1;

> +
> +	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_NAME, strdup(valstr));
> +
> +	if (nft_jansson_value_parse_val(root, "handle", NFT_TYPE_U64,
> +					 &val64) =3D=3D -1)
> +		goto err;
> +
> +	nft_chain_attr_set_u64(c,NFT_CHAIN_ATTR_HANDLE, val64);
> +
> +	if (nft_jansson_value_parse_val(root, "bytes", NFT_TYPE_U64,
> +					 &val64) =3D=3D -1)
> +		goto err;
> +
> +	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_BYTES, val64);
> +
> +	if (nft_jansson_value_parse_val(root, "packets", NFT_TYPE_U64,
> +					 &val64) =3D=3D -1)
> +		goto err;
> +
> +	if (val64 < 0)

val64 is uint64_t, so it cannot be negative.

> +		goto err;
> +
> +	nft_chain_attr_set_u64(c, NFT_CHAIN_ATTR_PACKETS, val64);
> +
> +	root =3D json_object_get(root, "properties");
> +
> +	valstr =3D nft_jansson_value_parse_str(root, "family");
> +
> +	if (valstr =3D=3D NULL)
> +		goto err;

                return -1;

instead. nft_jansson_value_parse_str should set errno accordingly.

> +
> +	if (nft_str2family(valstr) =3D=3D -1)
> +		goto err;

                return -1;

nft_str2family already sets errno.

> +
> +	nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_FAMILY, nft_str2family(val=
str));
> +
> +	valstr =3D nft_jansson_value_parse_str(root, "table");
> +
> +	if (valstr =3D=3D NULL)
> +		goto err;
> +
> +	nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TABLE, strdup(valstr));
> +
> +	if (nft_jansson_node_exist(root, "hooknum")) {
> +		valstr =3D nft_jansson_value_parse_str(root, "type");
> +
> +		if (valstr =3D=3D NULL)
> +			goto err;
> +
> +		nft_chain_attr_set_str(c, NFT_CHAIN_ATTR_TYPE, strdup(valstr));
> +
> +		if (nft_jansson_value_parse_val(root, "prio", NFT_TYPE_S32,
> +						 &prio) =3D=3D -1)
> +			goto err;
> +
> +		nft_chain_attr_set_s32(c, NFT_CHAIN_ATTR_PRIO, prio);
> +
> +		valstr =3D nft_jansson_value_parse_str(root, "hooknum");
> +		for (hooknum =3D 0; hooknum < NF_INET_NUMHOOKS; hooknum++) {
> +			if (strcmp(valstr, hooknum2str_array[hooknum]) =3D=3D 0) {
> +				nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_HOOKNUM,
> +						       hooknum);
> +				break;
> +			}
> +		}
> +
> +		valstr =3D nft_jansson_value_parse_str(root, "policy");
> +
> +		if (valstr =3D=3D NULL)
> +			goto err;
> +
> +		if (str2policy(valstr) =3D=3D -1)
> +			goto err;
> +
> +		nft_chain_attr_set_u32(c, NFT_CHAIN_ATTR_POLICY,
> +				       str2policy(valstr));
> +	}
> +
> +	free(root);
> +	return 0;
> +
> +err:
> +	free(root);
> +	errno =3D ERANGE;

this should return EINVAL.

> +	return -1;
> +#else
> +	errno =3D EOPNOTSUPP;
> +	return -1;
> +#endif
> +}
> +
>  static int nft_chain_xml_parse(struct nft_chain *c, char *xml)
>  {
>  #ifdef XML_PARSING
> @@ -661,6 +796,9 @@ int nft_chain_parse(struct nft_chain *c, enum nft=
_chain_parse_type type,
>  	case NFT_CHAIN_PARSE_XML:
>  		ret =3D nft_chain_xml_parse(c, data);
>  		break;
> +	case NFT_CHAIN_PARSE_JSON:
> +		ret =3D nft_chain_json_parse(c, data);
> +		break;
>  	default:
>  		ret =3D -1;
>  		errno =3D EOPNOTSUPP;
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
