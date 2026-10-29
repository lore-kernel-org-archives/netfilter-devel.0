Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793273124;
	b=fbeE5hx0d8j9f9vNQYFNdkHu8U+nX9kPUUhsZJSWvGN7/Wc1I4FlSfKfDlDOXPqesoKe
	 wPSisCg6v/692d3n81vwc1fzAlYNOyhe3Rc+S6vDZJ7J0GNbfiuocoYgjwygvwFLec3CG
	 qZJXycV4gAw5TCCYiH/xOvhNlefsrzliQQdAeJz1xs0ygMWENkgXZWN0En6rF+5QQvv5B
	 BuEzX+2pErd/39Sd7BOzCsd1CXZ/yDZsSd9KuylbcKSz51TAIwRvFQfk3YgAfnDjkimbg
	 5ctQcyBGnXUEW7IFKE61noKiAlAkWWb8TGMlsoCCCBRbsuyiRYe7rf16KRJ2kny7nxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793273124;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=3baaLxirMRy2Nw10Buf6OLwHQ/xCsTYP4rlzeoYGLNc=;
	b=B00HiGdtyqIY4VUPt2EjZoqfoLzHzn+/aztdiFnKOzGYv95HJcLqcclYnxKaWm/FcyQu
	 GyFP2p94JbkNGXs1mmzr+/mr5mU+w2GHUCSNOkipQETHd+9ZRPNQWnzZxB4CkGxNp2qED
	 gxi/yTpGML+q5Pe9iCYvaks2y31iMsnzRd6pC74aWHq7cOXkvOouAdcqz8YjnDWlM2pOE
	 baYInpC3NTIq88BQqWM9zT9scrifaoSbKolJaDBiwLPriDSulTqLnUdo2SLve6zHeLhiz
	 NNlBXqGlI3hE+cpdtdu/D/3XcTs9+153RAb6GAmyohkkyphtasguFFWxoqwfiGvTMHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LEF2kK6P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631E1606A320
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LEF2kK6P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662D71F01825;
	Thu, 29 Oct 2026 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793273123;
	bh=3baaLxirMRy2Nw10Buf6OLwHQ/xCsTYP4rlzeoYGLNc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LEF2kK6P3LXi3rTxvOIJGYdkweIRaqzmVCViV29Dh4q2W5KWiVBUdMbyg3jFXLfxG
	 4y88t++mYvNGs5E1E+vifBFp/8qx2Yd+u3UHLbY7oBEfn0qW6PnzhgH1foHy3phwqq
	 qDiYgSt/PGgzzshZnPMTjl4w7QhIkN+HeY0TG9z5LcBlW+UrDDN39G8IYyBkhI6nnw
	 04K1QrZVZJP+CFtMdBlMzmgbJyDRIpQmzVP8Ytty7ok0S5d5nFM+gE/+bAHyCzjN7J
	 D6sWDvsoKtjoKoeCb7cEusNjzUPNTID0vrOWL10mDBti2fDTP0tHylzyWeU0ilZZCS
	 F6jlZse92ARCg==
Date: Thu, 29 Oct 2026 12:25:21 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next 1/2] netfilter: flowtable: retrieve stats on flow
 deletion
Message-ID: <auMtIQQMWdjm4Bsp@lore-desk>
References: <20261029111431.179813-1-pablo@netfilter.org>
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
	protocol="application/pgp-signature"; boundary="HqptTbztlr+sKxEG"
Content-Disposition: inline
In-Reply-To: <20261029111431.179813-1-pablo@netfilter.org>

--HqptTbztlr+sKxEG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Retrieve stats too when deleting a flow from hardware. Apparently, the
> existing approach is missing last stats sync with the conntrack entry.
> Pass the stats object to the driver so it has a chance to populate it
> at deletion time. Drivers need to be updated to use this new approach.
>=20
> Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  net/netfilter/nf_flow_table_offload.c | 43 ++++++++++++++++-----------
>  1 file changed, 26 insertions(+), 17 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index 4365859220e6..53182323f73c 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -934,6 +934,27 @@ static int nf_flow_offload_tuple(struct nf_flowtable=
 *flowtable,
>  	return i;
>  }
> =20
> +static void flow_offload_update_stats(struct flow_offload_work *offload,
> +				      struct flow_stats *stats)
> +{
> +	u64 lastused;
> +
> +	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> +	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> +				       lastused + flow_offload_get_timeout(offload->flow));
> +
> +	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> +		if (stats[0].pkts)
> +			nf_ct_acct_add(offload->flow->ct,
> +				       FLOW_OFFLOAD_DIR_ORIGINAL,
> +				       stats[0].pkts, stats[0].bytes);
> +		if (stats[1].pkts)
> +			nf_ct_acct_add(offload->flow->ct,
> +				       FLOW_OFFLOAD_DIR_REPLY,
> +				       stats[1].pkts, stats[1].bytes);
> +	}
> +}
> +
>  static int flow_offload_tuple_add(struct flow_offload_work *offload,
>  				  struct nf_flow_rule *flow_rule,
>  				  enum flow_offload_tuple_dir dir)
> @@ -948,10 +969,13 @@ static int flow_offload_tuple_add(struct flow_offlo=
ad_work *offload,
>  static void flow_offload_tuple_del(struct flow_offload_work *offload,
>  				   enum flow_offload_tuple_dir dir)
>  {
> +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> +
>  	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
>  			      offload->flowtable->priority,
> -			      FLOW_CLS_DESTROY, NULL,
> +			      FLOW_CLS_DESTROY, stats,
>  			      &offload->flowtable->flow_block.cb_list);

according to my understanding nf_flow_offload_tuple() copies the stats just=
 if
cmd is set to FLOW_CLS_STATS, right? Should we just check if stats is not N=
ULL
in nf_flow_offload_tuple() instead?

Regards,
Lorenzo

> +	flow_offload_update_stats(offload, stats);
>  }
> =20
>  static int flow_offload_rule_add(struct flow_offload_work *offload,
> @@ -1011,27 +1035,12 @@ static void flow_offload_tuple_stats(struct flow_=
offload_work *offload,
>  static void flow_offload_work_stats(struct flow_offload_work *offload)
>  {
>  	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> -	u64 lastused;
> =20
>  	flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
>  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
>  		flow_offload_tuple_stats(offload, FLOW_OFFLOAD_DIR_REPLY,
>  					 &stats[1]);
> -
> -	lastused =3D max_t(u64, stats[0].lastused, stats[1].lastused);
> -	offload->flow->timeout =3D max_t(u64, offload->flow->timeout,
> -				       lastused + flow_offload_get_timeout(offload->flow));
> -
> -	if (offload->flowtable->flags & NF_FLOWTABLE_COUNTER) {
> -		if (stats[0].pkts)
> -			nf_ct_acct_add(offload->flow->ct,
> -				       FLOW_OFFLOAD_DIR_ORIGINAL,
> -				       stats[0].pkts, stats[0].bytes);
> -		if (stats[1].pkts)
> -			nf_ct_acct_add(offload->flow->ct,
> -				       FLOW_OFFLOAD_DIR_REPLY,
> -				       stats[1].pkts, stats[1].bytes);
> -	}
> +	flow_offload_update_stats(offload, stats);
>  }
> =20
>  static void flow_offload_work_handler(struct work_struct *work)
> --=20
> 2.47.3
>=20

--HqptTbztlr+sKxEG
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCauMtIQAKCRA6cBh0uS2t
rPL0AQD/8nwAhda+9dGf8b7fMtd7ZHAvdsG//RVRARPc3p2cLwEAshfXLrYG3PmC
tUw8UlF/yGZb8eX/hnQHmp7H9pJZZAc=
=c84p
-----END PGP SIGNATURE-----

--HqptTbztlr+sKxEG--
