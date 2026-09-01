Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75E3B46C838;
	Tue,  1 Sep 2026 10:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788256971; cv=none; b=eahxtkPFdlpFgER/byMG5xcbz4MJOnKstHcS0o9k9zpdpSw7aZlenal/yeckAYuIDyi56hnkLT66pgUR5DBle/Scjddgmprn4WVXE1BCTaaxV7WT2wBvcHhuTb+ElnboO23Woq8LoBjpO3M3EfhTmQ0lhw11DZc6c2qRrGTfD70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788256971; c=relaxed/simple;
	bh=HbSdLjTjJUdTky2bws03qOZikJSboGBn0O25V/oljsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tPKhJYG5g7zTQne2oHdZxFBFRFT0ldzYmrJm/pfwHQYjCL3WdT1i3hrA+4hbt423+Kt2+4GZRTRV3yEijwQ5je8ZRKc51TJADtxoENGdgd+ED8ZfFgbrzsYiXDW+i/0xOuEYnlWA6nwIty3JzGs3RfxnsV9xWnhGbeoJvPyNwVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVDlZDxz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVDlZDxz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FC91F000E9;
	Tue,  1 Sep 2026 10:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788256970;
	bh=qTNTRFksulITxbCKCrKekyh27ztnjvfQBlMPOzze/R0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KVDlZDxz3IgiyyMurz47BqcV+W3bJGh5q+Zb23WWjqxabE5OjQGssBjofNL1ag2XZ
	 HEbYkah4jzDFsPKhduQsWzNpHzISPguk7bJUwSsoT6Hzbq2w7MMSYgpW6HitwbzcPc
	 8WpL3Pua8GTmPHdFGV6TYAaqk05B0oTpvHS7SFkmJ74vzvT2c7/ZAbxWM5yAiuRJrp
	 hzIBDB/8+2i8YZGgU8UF+oZnqXokJj5czfGJoQulh+W5QgvNF9L+xi9gtA5c/q6kXS
	 yVKqBgw9lwSj5QzbjpJN8KFXgJfc7i3bplQpWN9YxoEpNkOztXf5sDXpBYAlL7M3ib
	 cTeozus6m0WyA==
Date: Tue, 1 Sep 2026 12:02:47 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: carry a priority into the
 offload
Message-ID: <apaix8MjIkRPjHVq@lore-desk>
References: <20260901092632.369248-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/qSlxrVubm3pHBHu"
Content-Disposition: inline
In-Reply-To: <20260901092632.369248-1-julius@bairaktaris.de>

--/qSlxrVubm3pHBHu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> A flow rule handed to a driver describes NAT, encapsulation and the
> output device, but not how the flow should be treated on the way out,
> so hardware with priority queues can only fall back on the DSCP the
> packet carries.
>=20
> Carry skb->priority of the packet that created the flow and emit it as
> FLOW_ACTION_PRIORITY, the action act_skbedit already emits on the tc
> path. "meta priority set" before "flow add" then reaches the hardware.
> A flow without a priority emits no action; mtk and airoha, the two
> in-tree consumers of these rules, ignore the new one as they do
> FLOW_ACTION_CSUM.
>=20
> The flowtable holds one flow for both directions and the expression
> runs once, so the priority applies to both; per-direction
> classification is not carried.
>=20
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>

Hi Julius,

we have already discussed about this kind of approach to offload skb priori=
ty
into drivers that support flowtable hw offload. The main blocking point is =
we
need the same feature in the flowtable sw path in order to not introduce any
missing capability in the kernel tx path.

Regards,
Lorenzo

> ---
> The consumer of the emitted action is a DSA driver for the IPQ8074 PPE,
> maintained in OpenWrt; measured there, "meta priority set" ahead of
> "flow add" places offloaded flows in the port's hardware priority
> queues. The mtk and airoha hunks are compile-tested only. The new field
> grows struct flow_offload by eight bytes on 64-bit; the entry allocates
> from its own kmem_cache, so no allocation-class change.
>=20
>  drivers/net/ethernet/airoha/airoha_ppe.c        |  1 +
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c |  1 +
>  include/net/netfilter/nf_flow_table.h           |  1 +
>  net/netfilter/nf_flow_table_offload.c           | 11 +++++++++++
>  net/netfilter/nft_flow_offload.c                |  7 +++++++
>  5 files changed, 21 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ether=
net/airoha/airoha_ppe.c
> index 92611802801e..2afce76ad131 100644
> --- a/drivers/net/ethernet/airoha/airoha_ppe.c
> +++ b/drivers/net/ethernet/airoha/airoha_ppe.c
> @@ -1161,6 +1161,7 @@ static int airoha_ppe_flow_offload_replace(struct a=
iroha_eth *eth,
>  		case FLOW_ACTION_REDIRECT:
>  			odev =3D act->dev;
>  			break;
> +		case FLOW_ACTION_PRIORITY:
>  		case FLOW_ACTION_CSUM:
>  			break;
>  		case FLOW_ACTION_VLAN_PUSH:
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/ne=
t/ethernet/mediatek/mtk_ppe_offload.c
> index 99b28aaa7cc4..4ee99e8e4a34 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -378,6 +378,7 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct =
flow_cls_offload *f,
>  		case FLOW_ACTION_REDIRECT:
>  			odev =3D act->dev;
>  			break;
> +		case FLOW_ACTION_PRIORITY:
>  		case FLOW_ACTION_CSUM:
>  			break;
>  		case FLOW_ACTION_VLAN_PUSH:
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilte=
r/nf_flow_table.h
> index f2e2771f188f..23218c8cbc3d 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -202,6 +202,7 @@ struct flow_offload {
>  	unsigned long				flags;
>  	u16					type;
>  	u32					timeout;
> +	u32					priority;
>  	struct rcu_head				rcu_head;
>  };
> =20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index 801a3dd9ceea..caaadffc2563 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -696,6 +696,17 @@ nf_flow_rule_route_common(struct net *net, const str=
uct flow_offload *flow,
>  	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
>  		return -1;
> =20
> +	if (flow->priority) {
> +		struct flow_action_entry *entry;
> +
> +		entry =3D flow_action_entry_next(flow_rule);
> +		if (!entry)
> +			return -1;
> +
> +		entry->id =3D FLOW_ACTION_PRIORITY;
> +		entry->priority =3D flow->priority;
> +	}
> +
>  	tuple =3D &flow->tuplehash[dir].tuple;
> =20
>  	for (i =3D 0; i < tuple->encap_num; i++) {
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_of=
fload.c
> index 32b4281038dd..dd3ac2b9c963 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -117,6 +117,13 @@ static void nft_flow_offload_eval(const struct nft_e=
xpr *expr,
>  	if (tcph)
>  		flow_offload_ct_tcp(ct);
> =20
> +	/* Whatever classified this packet before it reached the flowtable also
> +	 * describes every packet the hardware will forward in its place, so
> +	 * carry it into the offload rather than losing it with the software
> +	 * path.
> +	 */
> +	flow->priority =3D pkt->skb->priority;
> +
>  	__set_bit(NF_FLOW_HW_BIDIRECTIONAL, &flow->flags);
>  	ret =3D flow_offload_add(flowtable, flow);
>  	if (ret < 0)
>=20
> base-commit: 91ec2035134982b98fab0609a9fd8480e8217dc1
> --=20
> 2.53.0
>=20

--/qSlxrVubm3pHBHu
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCapaixwAKCRA6cBh0uS2t
rO6BAQDATMMj9psNMDyU5heE/YH01LAOWYjr6ZhqoY+od26axgEAmapqfjkDrUmq
l70nCQ9+MTNflnFu+hLQGuQ4HGwL3AI=
=wTb6
-----END PGP SIGNATURE-----

--/qSlxrVubm3pHBHu--
