Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273347;
	b=owVJtUEtVdG/FD76jA9TRbk2dTbskYvQ0+Q+TIr4bGcblnHHgHXM9D02X+i/18rv09iy
	 QgO97e0Qye4zAfkL8NXiSjXMOSvjJmINUiKLbO32eS9vvlBYFaIt4y1+KddTSLc6K92zo
	 eG/LEuCokRH8Bxq41rLBv9avPRNdj1j9GHzncHNq8Vz9vpc0GXhnpJrafHvLSwumKuMjk
	 R8aKXtZDpb+umDqW+U6BiZNInqX2jlRl7kz2ZDVz4Yg66qrXRe2mAGpov6JSM2zGNW2ko
	 dbIYDcSbsn2Aey5StDEfRTWNfkrDL2Ip7RE7z8BkRgyHZPVyYpLPFonnolnI5JBXt4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273347;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=w//5KaxJ9mfcglq+NoDwzptbD+KUoK1wyq78feWrfkU=;
	b=cibo2LpFn59KjEKhesergwgMNYewrl2fZ5TQweYAShl5MsIjWPoKFRJz5KUZEo+YYmWM
	 AmpBrFfMfl+BRO8UXcDtf6Tt0YatV3vpgr8Lotoaa/awcfhFg3h+gP1UIHZ/OIHJdSbNI
	 8WCxSl4dChFvLCvWnz4sLEvX6nI73QS/GdIRstvQyUx+oGZ3DF9reYkpX81UrnyyWemF9
	 5GNKWTLR4A3OjG9h5psaO1NCU1NOXwD/eDlwU3/VSHoe1OuZT2R0cwDBm3Vw4nEMkCHXa
	 XhWhcpdkCLeM3IA+Y6AW3tYr3p6cF+/nK/UVCvI+oT/mqECZVk+B4V+XcE8IZj4NpdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DD1O4iZk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE603606A31A
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DD1O4iZk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011DA1F01825;
	Thu, 29 Oct 2026 11:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793273346;
	bh=w//5KaxJ9mfcglq+NoDwzptbD+KUoK1wyq78feWrfkU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DD1O4iZk7+W1WpDSoX1DwAUSIP6A/wI9vLkHYCmMwqOPxTA6zEP90z5RD4yk3A31i
	 0Zj9bC5emwWawIiBm3ChaYhilfGSo2+aX2WXj+NfpMLcTTk7ooUqmcv8CCzLXm/GaQ
	 v29XVUxOHbWNsleXxD4+DvqjNGekkWlhAHKhN6TdSmP2xCCYLOM5UwCSMKjZRolQk5
	 QxQ/swqMhXIj0+w2oAOYCz341KLgD6HxX1NwE0Kb016GHYB0GfnF5P9/1qzFJK5SCC
	 fqU6l52zgd9H4MR34FelVRCNI8b2vv8Q3X6Z0eheXF0SgbsbynO1VUHmSNpmMKcAb9
	 wJWHI6tV1G2yQ==
Date: Thu, 29 Oct 2026 12:29:04 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next 2/2] net: ethernet: mtk_ppe: update stats on flow
 deletion
Message-ID: <auMuANNbWDrhUNnQ@lore-desk>
References: <20261029111431.179813-1-pablo@netfilter.org>
 <20261029111431.179813-2-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WWDsNwlFm7aLrlwh"
Content-Disposition: inline
In-Reply-To: <20261029111431.179813-2-pablo@netfilter.org>

--WWDsNwlFm7aLrlwh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Update this driver to use the new approach to fetch stats on flow
> deletion, introduced by ("netfilter: flowtable: retrieve stats on flow
> deletion").
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  .../net/ethernet/mediatek/mtk_ppe_offload.c   | 32 ++++++++++++-------
>  1 file changed, 21 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/ne=
t/ethernet/mediatek/mtk_ppe_offload.c
> index 99b28aaa7cc4..8ca694bb5e1b 100644
> --- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> +++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
> @@ -526,6 +526,24 @@ mtk_flow_offload_replace(struct mtk_eth *eth, struct=
 flow_cls_offload *f,
>  	return err;
>  }
> =20
> +static void
> +mtk_flow_offload_update_stats(struct mtk_eth *eth, struct flow_cls_offlo=
ad *f,
> +			      struct mtk_flow_entry *entry)
> +{
> +	struct mtk_foe_accounting diff;
> +	u32 idle;
> +
> +	idle =3D mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
> +	f->stats.lastused =3D jiffies - idle * HZ;
> +
> +	if (entry->hash !=3D 0xFFFF &&
> +	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
> +				  &diff)) {
> +		f->stats.pkts +=3D diff.packets;
> +		f->stats.bytes +=3D diff.bytes;
> +	}
> +}
> +
>  static int
>  mtk_flow_offload_destroy(struct mtk_eth *eth, struct flow_cls_offload *f)
>  {
> @@ -536,6 +554,8 @@ mtk_flow_offload_destroy(struct mtk_eth *eth, struct =
flow_cls_offload *f)
>  	if (!entry)
>  		return -ENOENT;
> =20
> +	mtk_flow_offload_update_stats(eth, f, entry);
> +
>  	mtk_foe_entry_clear(eth->ppe[entry->ppe_index], entry);
>  	rhashtable_remove_fast(&eth->flow_table, &entry->node,
>  			       mtk_flow_ht_params);
> @@ -550,23 +570,13 @@ static int
>  mtk_flow_offload_stats(struct mtk_eth *eth, struct flow_cls_offload *f)
>  {
>  	struct mtk_flow_entry *entry;
> -	struct mtk_foe_accounting diff;
> -	u32 idle;
> =20
>  	entry =3D rhashtable_lookup(&eth->flow_table, &f->cookie,
>  				  mtk_flow_ht_params);
>  	if (!entry)
>  		return -ENOENT;
> =20
> -	idle =3D mtk_foe_entry_idle_time(eth->ppe[entry->ppe_index], entry);
> -	f->stats.lastused =3D jiffies - idle * HZ;
> -
> -	if (entry->hash !=3D 0xFFFF &&
> -	    mtk_foe_entry_get_mib(eth->ppe[entry->ppe_index], entry->hash,
> -				  &diff)) {
> -		f->stats.pkts +=3D diff.packets;
> -		f->stats.bytes +=3D diff.bytes;
> -	}
> +	mtk_flow_offload_update_stats(eth, f, entry);
> =20
>  	return 0;
>  }
> --=20
> 2.47.3
>=20

--WWDsNwlFm7aLrlwh
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCauMuAAAKCRA6cBh0uS2t
rMB7AP9VQXpYk4k9r07DePu1eGd8g0vf0Jl8iugmukMxPXecNwEA3/p8zflxFacw
Nz9mAGDsnsu/CPPGw4+47HXzPeav3wA=
=mQq/
-----END PGP SIGNATURE-----

--WWDsNwlFm7aLrlwh--
