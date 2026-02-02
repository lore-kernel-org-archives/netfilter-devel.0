Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43312D3A77
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770024542; cv=none; b=QN60nixHdjQvqecncDis6mqrSgkYvyQGY/gvNozUUbdE7QwV+lFZpK5YYKBZUxblr2GGCFsM88u+HSruLKdMEAY/QFv9B84ifdfRLNyGxPcJAjS8TQA2z9CfH5EdL5zEJXlpz3tBgKARrFD34+FrPN3MGjy2igNrWt++bSQj240=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770024542; c=relaxed/simple;
	bh=RSbpxgoCnRVPhrbcBazIz+iGTxVpsH6mZg1ka0wDZs8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G1+5fRYXgA42Fj2A0B9S0s8u6Fch+BcMuAzJGt1cs1XeOLVfXQ946JKB7+tZSpUVw9IAOaZI3z0et+2YC6kMxKGjQ6XwT/ZII35Yi0rcgxchXalnNAATuH5qHTfpkCGqryjUC8Ut9kY3+cG3b5ybWWm+k0zo09s07B3blCExrUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nCbq5pg8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nCbq5pg8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2851EC116C6;
	Mon,  2 Feb 2026 09:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770024541;
	bh=RSbpxgoCnRVPhrbcBazIz+iGTxVpsH6mZg1ka0wDZs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nCbq5pg8rfu/5qItSvTaF0LoIdnSmh7ycqCQfb3Z9Yt7NkFj8OOYeo++GOLylTyq4
	 1Bjg80XXut71DaWhQOWlQbD1fAXCb5aFAPkrH4bQX/zOIUr9cxXHjyHANDxidfBLRA
	 MKYzI4yHw+DsxwWFBwUBBuacvML3nYWGW8d8lkqwD8n0hOfjxtsfUn6Di+/7CGe8ch
	 uSOpMHndXBTrbPz5ABk/kv9ED6apAlE/XFxATCNDPngZfCcz/3f9ytRQGzrRzfUiTA
	 0rXQx+6VHs4wUNweiYMq3/aH3dNr8UNhhddLERx+HFRRGdke+GbGjKxtbKhjRYc0ra
	 +CurNdze7dl6w==
Date: Mon, 2 Feb 2026 10:28:59 +0100
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] selftests: netfilter: add IPV6_TUNNEL to config
Message-ID: <aYBuW3ygEmXen2X6@lore-desk>
References: <20260130182155.93253-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="8ZZgk1QPC54r2p6O"
Content-Disposition: inline
In-Reply-To: <20260130182155.93253-1-fw@strlen.de>


--8ZZgk1QPC54r2p6O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> The script now requires IPV6 tunnel support, enable this.
> This should have caught by CI, but as the config option is missing,
> the tunnel interface isn't added.  This results in an error cascade
> that ends with "route change default" failure.
>=20
> That in turn means the "ipv6 tunnel" test re-uses the previous
> test setup so the "ip6ip6" test passes and script returns 0.
>=20
> Make sure to catch such bugs, set ret=3D1 if device cannot be added
> and delete the old default route before installing the new one.
>=20
> After this change, IPV6_TUNNEL=3Dn kernel builds fail with the expected
>   FAIL: flow offload for ns1/ns2 with IP6IP6 tunnel
>=20
> ... while builds with IPV6_TUNNEL=3Dm pass as before.
>=20
> Fixes: 5e5180352193 ("selftests: netfilter: nft_flowtable.sh: Add IP6IP6 =
flowtable selftest")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>

> ---
>  tools/testing/selftests/net/netfilter/config  |  1 +
>  .../selftests/net/netfilter/nft_flowtable.sh  | 19 +++++++++++++------
>  2 files changed, 14 insertions(+), 6 deletions(-)
>=20
> diff --git a/tools/testing/selftests/net/netfilter/config b/tools/testing=
/selftests/net/netfilter/config
> index 12ce61fa15a8..979cff56e1f5 100644
> --- a/tools/testing/selftests/net/netfilter/config
> +++ b/tools/testing/selftests/net/netfilter/config
> @@ -29,6 +29,7 @@ CONFIG_IP_NF_RAW=3Dm
>  CONFIG_IP_SCTP=3Dm
>  CONFIG_IPV6=3Dy
>  CONFIG_IPV6_MULTIPLE_TABLES=3Dy
> +CONFIG_IPV6_TUNNEL=3Dm
>  CONFIG_IP_VS=3Dm
>  CONFIG_IP_VS_PROTO_TCP=3Dy
>  CONFIG_IP_VS_RR=3Dm
> diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/too=
ls/testing/selftests/net/netfilter/nft_flowtable.sh
> index 14d7f67715ed..7a34ef468975 100755
> --- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
> +++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
> @@ -601,14 +601,19 @@ ip -net "$nsr2" link set tun0 up
>  ip -net "$nsr2" addr add 192.168.100.2/24 dev tun0
>  ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0.forwarding=3D1 > /dev/nu=
ll
> =20
> -ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fe=
e1:2::1
> +ip -net "$nsr2" link add name tun6 type ip6tnl local fee1:2::2 remote fe=
e1:2::1 || ret=3D1
>  ip -net "$nsr2" link set tun6 up
>  ip -net "$nsr2" addr add fee1:3::2/64 dev tun6 nodad
> =20
>  ip -net "$nsr1" route change default via 192.168.100.2
>  ip -net "$nsr2" route change default via 192.168.100.1
> -ip -6 -net "$nsr1" route change default via fee1:3::2
> -ip -6 -net "$nsr2" route change default via fee1:3::1
> +
> +# do not use "route change" and delete old default so
> +# socat fails to connect in case new default can't be added.
> +ip -6 -net "$nsr1" route delete default
> +ip -6 -net "$nsr1" route add default via fee1:3::2
> +ip -6 -net "$nsr2" route delete default
> +ip -6 -net "$nsr2" route add default via fee1:3::1
>  ip -net "$ns2" route add default via 10.0.2.1
>  ip -6 -net "$ns2" route add default via dead:2::1
> =20
> @@ -649,7 +654,8 @@ ip netns exec "$nsr1" nft -a insert rule inet filter =
forward 'meta oif tun0.10 a
>  ip -net "$nsr1" link add name tun6.10 type ip6tnl local fee1:4::1 remote=
 fee1:4::2
>  ip -net "$nsr1" link set tun6.10 up
>  ip -net "$nsr1" addr add fee1:5::1/64 dev tun6.10 nodad
> -ip -6 -net "$nsr1" route change default via fee1:5::2
> +ip -6 -net "$nsr1" route delete default
> +ip -6 -net "$nsr1" route add default via fee1:5::2
>  ip netns exec "$nsr1" nft -a insert rule inet filter forward 'meta oif t=
un6.10 accept'
> =20
>  ip -net "$nsr2" link add link veth0 name veth0.10 type vlan id 10
> @@ -664,10 +670,11 @@ ip -net "$nsr2" addr add 192.168.200.2/24 dev tun0.=
10
>  ip -net "$nsr2" route change default via 192.168.200.1
>  ip netns exec "$nsr2" sysctl net.ipv4.conf.tun0/10.forwarding=3D1 > /dev=
/null
> =20
> -ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote=
 fee1:4::1
> +ip -net "$nsr2" link add name tun6.10 type ip6tnl local fee1:4::2 remote=
 fee1:4::1 || ret=3D1
>  ip -net "$nsr2" link set tun6.10 up
>  ip -net "$nsr2" addr add fee1:5::2/64 dev tun6.10 nodad
> -ip -6 -net "$nsr2" route change default via fee1:5::1
> +ip -6 -net "$nsr2" route delete default
> +ip -6 -net "$nsr2" route add default via fee1:5::1
> =20
>  if ! test_tcp_forwarding_nat "$ns1" "$ns2" 1 "IPIP tunnel over vlan"; th=
en
>  	echo "FAIL: flow offload for ns1/ns2 with IPIP tunnel over vlan" 1>&2
> --=20
> 2.52.0
>=20

--8ZZgk1QPC54r2p6O
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaYBuWwAKCRA6cBh0uS2t
rByzAQDvt1rkoZeH2LaNsrF950DHxfmknpisWS4t/MtXi9G16QEAmHcpku8QwhIG
5ZJ2LeNuR6L+CEVEgy0aOWxs2w5kvAI=
=k3Hr
-----END PGP SIGNATURE-----

--8ZZgk1QPC54r2p6O--
