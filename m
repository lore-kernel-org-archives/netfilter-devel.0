Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793702654;
	b=Qzcfx9QD7zeSSua9N9acMD4GhQ7t9QJfIRPJoEErgRJjZMC19scWmbaj1tSS7cF7Ue3k
	 IWsiQ6Et9UT7BQxDVMJda8Ve73T06UlDIpuvIr+tLe02PgoVDhYBsHYBiEUMHUxkMvkoX
	 jiPbyIOfzlrZVXwyNpEyY6kGsKdBZ/Z727FWMuuB4/q0/06SE/QKlpEGk9EAVvS/5ZFdB
	 excJHkn6g1+kyEZS9MDLVlNHAnLKnxV1Qk2peAnaHE51EJd8VCjCbNA9uqVRxtEMPfmoK
	 i4ehMCga4A6S3Dk+zquMDWhaFXjSeDtJi0TlSFcVsDmbnP++yNq58gB7rjUbH87HlFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793702654;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WPFe0QUahkCUTQmjlSW+MwjxxDSm24+Ok/IZBPw4m9M=;
	b=hzDzkfEfp4UI8iCBZDxzMyDy9EFWsJu5pjsWYYAEt19dp71/ekMJervf8MH85XEwfcCk
	 BEPfdLw+r5nQM18NaIxWL+fj5jrYHCsjF6gwLekdlwPGMdhB3jN2G/BLXyJ/SLxebtQHS
	 AB9YvMPbiVhzl5aus9+2VTWdUBhEO1bgMn87KfySZhJeXdYDfNWsfFb92XCGmtlPwP3nT
	 3LfKnTvJNx/5vfWpG0Wk/jvPBCk8e5Zj0GKsRgUk1q7R0EwYVQjlVNI4yX1h9jF4oDjyU
	 AztW/xokhzN9tsnHVlUbi5/meiqU8Vf2KFO6/2hHVEbWgzG1wDoTHZltFYL5PfqzaHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrEzeKzD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A59606BF97
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Nov 2026 10:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JrEzeKzD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 469E51F000C1;
	Tue,  3 Nov 2026 10:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793702653;
	bh=WPFe0QUahkCUTQmjlSW+MwjxxDSm24+Ok/IZBPw4m9M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=JrEzeKzDRRpB/vO1gn1adAe2rwrSdMI4bxAptFZiXjoKFTcL46NnHWwT/03dSerIA
	 g6S6nVKOJU213dPhCCimjHet98QuJyulWwckF9+Q7Z25JOaH40CwIcWrXI2FqQanFc
	 sr9Cd6dYTnN1EqfGT3tKUR0zqgw+0JnSxc2wC0bJZpO/QWlJ4kyUYr5ObH9JBdpWLW
	 6c/sOOsEAFmtMxb/j3zFS0ahGZTp5CdYW+SAXwMdxDLVoXo3oYpJtnoaE7yK0fHS8P
	 NXRE0mE6wI38rVyQXRL4Am4ioEn2TmKERIAi26Ur3mzYBOxdNDysrWSz1UaUpP8zCe
	 UWHN12MJCO51A==
Date: Tue, 3 Nov 2026 11:44:11 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: do not scrub as crossing
 netns
Message-ID: <aum6-5SJ8vrdiPBo@lore-desk>
References: <20261103001103.564344-1-pablo@netfilter.org>
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
	protocol="application/pgp-signature"; boundary="fhdpKYb8zJNyP3cx"
Content-Disposition: inline
In-Reply-To: <20261103001103.564344-1-pablo@netfilter.org>

--fhdpKYb8zJNyP3cx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> IPIP tunneling support does not result in crossing a netns, therefore,
> adopt the more conservative variant of skb_scrub_packet() by specifying
> !xnet, keep the existing skb mark in place.
>=20
> Fixes: d30301ba4b07 ("netfilter: flowtable: Add IPIP tx sw acceleration")

I guess we should add: Fixes: 93cf357fa797 ("netfilter: flowtable: Add IP6I=
P6 tx sw acceleration")

> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
> @Lorenzo: Do you remember the reason why this is scrubbing as crossing ne=
tns?
> There is a LLM report that is flagging this as an issue when interacting =
with
> other subsystem, eg. packets was marked. At least in the tunnel driver I =
can
> see this is conditional.

I guess it is a leftover from original implementation

Regards,
Lorenzo

>=20
>  net/netfilter/nf_flow_table_ip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_tab=
le_ip.c
> index 19cafae748ab..78bba416dd5b 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -630,7 +630,7 @@ static int nf_flow_tunnel_ip_push(struct net *net, st=
ruct sk_buff *skb,
>  	if (err)
>  		return err;
> =20
> -	skb_scrub_packet(skb, true);
> +	skb_scrub_packet(skb, false);
>  	skb_clear_hash_if_not_l4(skb);
> =20
>  	/* Push down and install the IP header. */
> @@ -699,7 +699,7 @@ static int nf_flow_tunnel_ip6_push(struct net *net, s=
truct sk_buff *skb,
>  	if (err)
>  		return err;
> =20
> -	skb_scrub_packet(skb, true);
> +	skb_scrub_packet(skb, false);
>  	mtu =3D dst_mtu(dst) - sizeof(*ip6h);
>  	mtu =3D max(mtu, IPV6_MIN_MTU);
>  	skb_dst_update_pmtu_no_confirm(skb, mtu);
> --=20
> 2.47.3
>=20

--fhdpKYb8zJNyP3cx
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaum6+wAKCRA6cBh0uS2t
rHDuAQD7HOBmSiCIsrhUvZ0nLrFhcdd1pqntIII5wOnQkehZdAD/W1Mh6ro7Hdhd
RKe81e4LdQNrITmpDY2eYaco99rI8wA=
=QrUA
-----END PGP SIGNATURE-----

--fhdpKYb8zJNyP3cx--
