Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793279489;
	b=O196yh9Lpyql2tirMenT2wFY3W910t3IZHLm28Jn7ZQzZ+uA6tt8ln4cTN7K9uG1FVNy
	 vojd+ufREW3m0zuaCArAGr47CbWykMJsWKPboiEfnG983k73jasBBkw314lcfb/qb4Z6g
	 tVFuZB+7T3SUW1qy/eGm7/9ilccVocqSBGadOHZ3ZUiX9oZ4L9ETSAwGxTPUrCWDKcBWk
	 5VkB34+RRbdI2V/nnKfOqTVhiBCryYb+HBTmW0VJwxx5pabG7jXwVhk3m2CHvP7c5IHC+
	 1yjGCkiw40XC0oCC02Mb5w8CtzkHtI7J5O1UnzX0wcDhWY7s4OvMB6dltweUnmsKrMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793279489;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Uv1A4QpRtib1fABTO2kFoUElESPzlOmLy+ucSeh+Hzw=;
	b=glkAW7Bop6nA3j9ozncQ2m5M0was4kJ+IQ/eMmCeIc2Gpn7IYKLwClrPHLg+wHxsbmHX
	 DePjIWBwsBmOT2JtaBcL9z4vyIOy3uvIZXMY3ANWyOfD9wDu7J5uhe5ccAQZCRRvomFlL
	 WYGvO1DE/bPuW+sjgTAtrSGcRzLgtBTGOLAUKhiM6ISRABQW9bORImKrj+s91IN+5Rhfk
	 Frvm5CxTFBSYJzc4FdmNBL8E7J+01fp6Qw8jVavz0SsbZ0bSWqPSELweaZ3HP75b92mAf
	 xgU+WP4mckks9dmKjb0fTIJacJHCv5zPPqEg1niiVYxOn8mpjhR0+Yqf0FW4b66Zyng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATJG7IJy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429C0606A330
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Oct 2026 13:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ATJG7IJy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6471F031E4;
	Thu, 29 Oct 2026 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793279488;
	bh=Uv1A4QpRtib1fABTO2kFoUElESPzlOmLy+ucSeh+Hzw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ATJG7IJyBmsVRFjD02w4OwNU8PWiu0dRNrs8JZbztv/7qfCcfXe6pFEfVi2KUD7gA
	 sruincpniJqC5L8IN3QRMgejEOMUZqoq37RtPAWvvQsr4EIDixvbmHkw7Dy0HP2os0
	 eX/zl951u5Zi0M70WLYBgEDwoWHSpJkihg5hWtDZlCn1IpXcYzyY0xG5pfL760HkQu
	 Hkfj6OGGOnyMBGNNfWSvGLP/iF99XlyLyvYs6lctO3lLYBnefx3wXaPVT60JYzQeU/
	 ujk+ZNjcFfiXQ9j8jiZfltFrbAM3r1VGLwIfkCNNGgtjTOksH2eG/rACvuGsegufvf
	 c4EChH1Z1EaiA==
Date: Thu, 29 Oct 2026 14:11:26 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, nbd@nbd.name
Subject: Re: [PATCH nf-next,v4 1/2] netfilter: flowtable: retrieve stats on
 flow deletion
Message-ID: <auNF_gOcM0k21zRE@lore-desk>
References: <20261029122749.196486-1-pablo@netfilter.org>
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
	protocol="application/pgp-signature"; boundary="5Dsd9cigmAIRAupw"
Content-Disposition: inline
In-Reply-To: <20261029122749.196486-1-pablo@netfilter.org>

--5Dsd9cigmAIRAupw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Retrieve stats too when deleting a flow from hardware. Apparently, the
> existing approach is missing last stats sync with the conntrack entry.
> Pass the stats object to the driver so it has a chance to populate it
> at deletion time. Drivers need to be updated to use this new approach.
>=20
> Closes: https://patch.msgid.link/netfilter-devel/20261021175030.4800-1-dr=
eyksmail@gmail.com/
> Reported-by: Valentin Berezhnoy <dreyksmail@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
> v4: pass stats[0] and stats[1] to flow_offload_tuple_del() to avoid overw=
rite
>=20
>  net/netfilter/nf_flow_table_offload.c | 54 ++++++++++++++++-----------
>  1 file changed, 33 insertions(+), 21 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index 4365859220e6..da2013ceeee2 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -928,12 +928,33 @@ static int nf_flow_offload_tuple(struct nf_flowtabl=
e *flowtable,
>  	}
>  	up_read(&flowtable->flow_block_lock);
> =20
> -	if (cmd =3D=3D FLOW_CLS_STATS)
> +	if (stats)
>  		memcpy(stats, &cls_flow.stats, sizeof(*stats));
> =20
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
> @@ -946,11 +967,12 @@ static int flow_offload_tuple_add(struct flow_offlo=
ad_work *offload,
>  }
> =20
>  static void flow_offload_tuple_del(struct flow_offload_work *offload,
> -				   enum flow_offload_tuple_dir dir)
> +				   enum flow_offload_tuple_dir dir,
> +				   struct flow_stats *stats)
>  {
>  	nf_flow_offload_tuple(offload->flowtable, offload->flow, NULL, dir,
>  			      offload->flowtable->priority,
> -			      FLOW_CLS_DESTROY, NULL,
> +			      FLOW_CLS_DESTROY, stats,
>  			      &offload->flowtable->flow_block.cb_list);
>  }
> =20
> @@ -991,10 +1013,15 @@ static void flow_offload_work_add(struct flow_offl=
oad_work *offload)
> =20
>  static void flow_offload_work_del(struct flow_offload_work *offload)
>  {
> +	struct flow_stats stats[FLOW_OFFLOAD_DIR_MAX] =3D {};
> +
>  	clear_bit(IPS_HW_OFFLOAD_BIT, &offload->flow->ct->status);
> -	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL);
> +	flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_ORIGINAL, &stats[0]);
>  	if (test_bit(NF_FLOW_HW_BIDIRECTIONAL, &offload->flow->flags))
> -		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY);
> +		flow_offload_tuple_del(offload, FLOW_OFFLOAD_DIR_REPLY, &stats[1]);
> +
> +	flow_offload_update_stats(offload, stats);
> +
>  	set_bit(NF_FLOW_HW_DEAD, &offload->flow->flags);
>  }
> =20
> @@ -1011,27 +1038,12 @@ static void flow_offload_tuple_stats(struct flow_=
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

--5Dsd9cigmAIRAupw
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCauNF/gAKCRA6cBh0uS2t
rLpSAQDd5YgLlJmo6JjS60+a5nGNKPvLRlklFE5R2NK3sMZ5owD+Kjombfa0CfcJ
gHC4d0ZIPGikIkc9q+9yhxHbkmz+iwg=
=VJWH
-----END PGP SIGNATURE-----

--5Dsd9cigmAIRAupw--
