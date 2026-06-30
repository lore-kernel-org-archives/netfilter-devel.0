Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66223EDE70
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 10:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782814745; cv=none; b=dU5o2+DYIJnHtI3mNgX6GWm59m2IdX177TC9D7Mq7OZqGigLBi/axnoxDdKUeIGb/JGkV1J2DX7pDGyBGqW5HqrllvCn78P3APHD9nw6EtTf4QodiirU56y+XMVNdvFB2NzAu55AWTXvIxuo8fWTV20+G5kG7TP674p8hgd5vc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782814745; c=relaxed/simple;
	bh=KDQaU5rl6Kadf5dazoG9VrhcUkaV0YP8jH1ax6rKfFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RnmKFK2Cu3kFtJ0fPP6qs/6YdLS1wYnjrlbflhVwqxXsLb9q9h3xn89YkJ7QU3ezRr9Z7SzADZDHIxqZaAjsWkKHfSyH2susB21MRKh5VYQlTIFpnilm6soYNdx0AQRb7bYZgPX0kvZ3xynAzd+eop8GOzktzTEN5wXlr+LYkwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zr3FjCVh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zr3FjCVh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A43A1F00A3A;
	Tue, 30 Jun 2026 10:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782814742;
	bh=2tGJ13SZmxrpiBURlTqbFz2gOvfH8+mt3F1/3BF7KoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zr3FjCVhi7jUKp2AQCkkYqoAlJUVGdSR2uWX/qBaIaGOCFVvs4Q3rf/Liw9kkycJ5
	 2drEWSWgx8siL1QxUYNbcbW5t5ENw0Mu2s0pO6jvewSUfRRYst5nJF0wXPisknjBLh
	 77O9J44Ej/cXvsOcQPqxAQc09XPeOJFpvvbRV2S0z2Wdj7eoSM7utafgma1d8SSfM2
	 DwvHQFQLxkzPlbx3HUQlNy5BOU/mdrNDwYLQZkYfTShEJ2LQgO+DLVagYVxsM5JczC
	 6GBgmQDucA+UDOjBFeAEwr7eAhWwYBYXiZAJunREjNn0c8KTsXJKQlSZFyEcHnFzNU
	 10cwgHSRTKmKg==
Date: Tue, 30 Jun 2026 12:18:59 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, chzhengyang2023@lzu.edu.cn
Subject: Re: [PATCH nf,v2 2/3] netfilter: flowtable: IPIP tunnel hardware
 offload is not yet support
Message-ID: <akOYE6jxy3_GwbwD@lore-desk>
References: <20260630094056.97038-1-pablo@netfilter.org>
 <20260630094056.97038-2-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RERRa+PiD9yySdx2"
Content-Disposition: inline
In-Reply-To: <20260630094056.97038-2-pablo@netfilter.org>


--RERRa+PiD9yySdx2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> No driver supports for IPIP tunnels yet, give up early on setting up the
> hardware offload for this scenario.
>=20
> This patch adds a stub that can be enhanced to add more configuration
> that are currently not supported. As of now, the offload work is
> enqueued to the worker, then ignored if the hardware offload
> configuration is not supported.
>=20
> Check the NF_FLOW_HW flag to know if this entry was already tried once
> to be offloaded so this is not retried on refresh when unsupported. Move
> NF_FLOW_HW flag check to nf_flow_offload_add(). If this NF_FLOW_HW flag
> is unset the _del and _stats variants are never called.
>=20
> This can be updated later on to skip hardware offload work to be queued
> in case hardware offload does not support it.
>=20
> Fixes: d98103575dcd ("netfilter: flowtable: Add IP6IP6 rx sw acceleration=
")
> Fixes: ab427db17885 ("netfilter: flowtable: Add IPIP rx sw acceleration")
> Reported-by: Yuan Tan <yuantan098@gmail.com>
> Reported-by: Xin Liu <bird@lzu.edu.cn>
> Reported-by: Zhengyang Chen <chzhengyang2023@lzu.edu.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
> v2: - set NF_FLOW_HW flag from nf_flow_offload_add(), after checking if i=
t is supported.
>     - call nf_flow_offload_refresh() only if NF_FLOW_HW is set on.
>=20
>  include/net/netfilter/nf_flow_table.h |  2 ++
>  net/netfilter/nf_flow_table_core.c    |  7 +++----
>  net/netfilter/nf_flow_table_offload.c | 22 ++++++++++++++++++++--
>  3 files changed, 25 insertions(+), 6 deletions(-)
>=20
> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilte=
r/nf_flow_table.h
> index 7b23b245a5a8..dc5c9b48e65a 100644
> --- a/include/net/netfilter/nf_flow_table.h
> +++ b/include/net/netfilter/nf_flow_table.h
> @@ -357,6 +357,8 @@ static inline int nf_flow_register_bpf(void)
> =20
>  void nf_flow_offload_add(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow);
> +void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
> +			     struct flow_offload *flow);
>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow);
>  void nf_flow_offload_stats(struct nf_flowtable *flowtable,
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_t=
able_core.c
> index 99c5b9d671a0..d06ce0848b68 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -345,10 +345,8 @@ int flow_offload_add(struct nf_flowtable *flow_table=
, struct flow_offload *flow)
> =20
>  	nf_ct_refresh(flow->ct, NF_CT_DAY);
> =20
> -	if (nf_flowtable_hw_offload(flow_table)) {
> -		__set_bit(NF_FLOW_HW, &flow->flags);
> +	if (nf_flowtable_hw_offload(flow_table))
>  		nf_flow_offload_add(flow_table, flow);
> -	}
> =20
>  	return 0;
>  }
> @@ -369,7 +367,8 @@ void flow_offload_refresh(struct nf_flowtable *flow_t=
able,
>  	    test_bit(NF_FLOW_CLOSING, &flow->flags))
>  		return;
> =20
> -	nf_flow_offload_add(flow_table, flow);
> +	if (test_bit(NF_FLOW_HW, &flow->flags))
> +		nf_flow_offload_refresh(flow_table, flow);
>  }
>  EXPORT_SYMBOL_GPL(flow_offload_refresh);
> =20
> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flo=
w_table_offload.c
> index 002ec15d988b..d26874f1b15f 100644
> --- a/net/netfilter/nf_flow_table_offload.c
> +++ b/net/netfilter/nf_flow_table_offload.c
> @@ -1101,9 +1101,17 @@ nf_flow_offload_work_alloc(struct nf_flowtable *fl=
owtable,
>  	return offload;
>  }
> =20
> +static bool nf_flow_offload_unsupported(struct flow_offload *flow)
> +{
> +	if (flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.tun_num ||
> +	    flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.tun_num)
> +		return true;
> =20
> -void nf_flow_offload_add(struct nf_flowtable *flowtable,
> -			 struct flow_offload *flow)
> +	return false;
> +}
> +
> +void nf_flow_offload_refresh(struct nf_flowtable *flowtable,
> +			     struct flow_offload *flow)
>  {
>  	struct flow_offload_work *offload;
> =20
> @@ -1114,6 +1122,16 @@ void nf_flow_offload_add(struct nf_flowtable *flow=
table,
>  	flow_offload_queue_work(offload);
>  }
> =20
> +void nf_flow_offload_add(struct nf_flowtable *flowtable,
> +			 struct flow_offload *flow)
> +{
> +	if (nf_flow_offload_unsupported(flow))
> +		return;
> +
> +	__set_bit(NF_FLOW_HW, &flow->flags);
> +	nf_flow_offload_refresh(flowtable, flow);
> +}
> +
>  void nf_flow_offload_del(struct nf_flowtable *flowtable,
>  			 struct flow_offload *flow)
>  {
> --=20
> 2.47.3
>=20

--RERRa+PiD9yySdx2
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCakOYEwAKCRA6cBh0uS2t
rP/oAQD5KmyUbK+20IsHS4k09MTcKOnA2AyBZ3omCSqUzF37YQEA1HBX9mhFiaAZ
4WJVwwaqUQeezWmZiNHmPe0wbpPazAs=
=8c7B
-----END PGP SIGNATURE-----

--RERRa+PiD9yySdx2--
