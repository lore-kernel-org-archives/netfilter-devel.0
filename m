From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] libnftnl: set: Implement new buffer of TLV objects.
Date: Mon, 4 Jan 2016 12:06:26 +0000
Message-ID: <20160104120625.GA31140@macbook.localdomain>
References: <1451849900-18077-1-git-send-email-carlosfg@riseup.net>
 <1451849900-18077-3-git-send-email-carlosfg@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Carlos Falgueras =?iso-8859-1?Q?Garc=EDa?= <carlosfg@riseup.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44077 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbcADMQp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2016 07:16:45 -0500
Content-Disposition: inline
In-Reply-To: <1451849900-18077-3-git-send-email-carlosfg@riseup.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03.01, Carlos Falgueras Garc=EDa wrote:
> +/* TLV validation */
> +enum nftnl_attr_data_type {
> +	NFTNL_ATTR_TYPE_UNSPEC,
> +	NFTNL_ATTR_TYPE_U8,
> +	NFTNL_ATTR_TYPE_U16,
> +	NFTNL_ATTR_TYPE_U32,
> +	NFTNL_ATTR_TYPE_U64,
> +	NFTNL_ATTR_TYPE_STRING,
> +	NFTNL_ATTR_TYPE_FLAG,
> +	NFTNL_ATTR_TYPE_MSECS,
> +	NFTNL_ATTR_TYPE_NESTED,
> +	NFTNL_ATTR_TYPE_NESTED_COMPAT,
> +	NFTNL_ATTR_TYPE_NUL_STRING,
> +	NFTNL_ATTR_TYPE_BINARY,
> +	__NFTNL_ATTR_TYPE_MAX,

We don't need quite a few of these. Compat is obviously unnecessary. Sa=
me thing
goes for MSECS and NUL_STRING since the kernel doesn't do interpretatio=
n of
the user data. FLAG I would avoid since it uses a full u8, so better ha=
ve
userspace simply use that and do interpretation as a flag.

> +/*
> + * TLV structures:
> + * nftnl_attr
> + *  <-- sizeof(nftnl_attr) -->             <-- nftnl_attr->len -->
> + * +--------------------------+- - - - - -+- - - - -  -- - - - - -+-=
 - - - - +
> + * |          Header          |  Pading   |       Payload         | =
 Pading  |
> + * |         (4 bytes)        | (4 bytes) |                       | =
         |
> + * +--------------------------+- - - - - -+- - - - - - - - - - - -+-=
 - - - - +
> + *  <------------------------ nftnl_attr_get_size() ----------------=
-------->

We don't need a header I'd think. Just the raw attributes.

> + * nftnl_attr->type (16 bits)
> + * +---+---+-------------------------------+
> + * | N | O | Attribute Type                |
> + * +---+---+-------------------------------+
> + * N :=3D Carries nested attributes
> + * O :=3D Payload stored in network byte order
> + *
> + * Note: The N and O flag are mutually exclusive.
> + */
> +
> +struct nftnl_attr {
> +	uint16_t type;
> +	uint16_t len;

u16 is too large for both. Our maximum length is 256 anyways, without t=
he
header u8 is enough. For type I'd also say u8 should be enough, especia=
lly
when considering the very limited space.

> +#define NFTNLA_F_NESTED		(1 << 15)
> +#define NFTNLA_F_NET_BYTEORDER	(1 << 14)
> +#define NFTNLA_TYPE_MASK	~(NFTNLA_F_NESTED | NFTNLA_F_NET_BYTEORDER)

Also unnecessary since the kernel doesn't do interpretation.

> +#define NFTNL_ALIGNTO		8
> +#define NFTNL_ALIGN(len)	(((len)+NFTNL_ALIGNTO-1) & ~(NFTNL_ALIGNTO-=
1))

I'd at least consider whether we really want this or whether userspace =
should
do an unconditional copy to avoid unaligned accesses. We have very limi=
ted
space and should try to pack tightly.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
