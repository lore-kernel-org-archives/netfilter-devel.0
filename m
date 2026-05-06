Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A8930595B;
	Wed,  6 May 2026 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778088436; cv=none; b=H9ZuIZjmvSx/0Ne0K0wDwZapW7RLE5j0Ombfx5v2Qn5cjy+65g3pLV4cKeIER7w0QTYjEwaGbOOi9iHGOmeetAS7EJE9JS1nZk3WRdDb8Q3WuKdy68Qkdr97Fh83NmzNCkt3OYXwx0Gzj0SzCWG8bOfkQXeEOvBOyxLgUTYRPsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778088436; c=relaxed/simple;
	bh=HmDSB8RGwVj0i6+IcLEKJKC3r5SqoF2IF/ST6ULFU5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qzE50hlTUwwHiiUHA1BaopqHBIZpq5++QqnJfzadlsUgUJPe12Ax08v8zx+wDPkYxbJZT/VRVDA/nGzUjKJdXcVxEH4DBHsQzRkuuRwo+7Jn/nlunfWKxeIoxLEsnhyra+NrNklPyyW3IQXg+O+oJXcVnF2bso8NRql4GkDXTnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LsoZapBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LsoZapBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 476CBC2BCB0;
	Wed,  6 May 2026 17:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778088435;
	bh=HmDSB8RGwVj0i6+IcLEKJKC3r5SqoF2IF/ST6ULFU5k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LsoZapBs6yowkuRKg3FX+deiQgEzzTuVpKSya3Hw5fH4WGu+0t8FG7x973zAJvwLF
	 uW96m0AIo55ILZk0w0aZzRmUvKVPJtzU0EIuooGlelpMH8pJiJgpC1MNmnE3x3nIB3
	 Hy02Z9T1nV3l6yxG2pmg30zRB4PymXqWVkakE0uvj0APBkKmoDfExIDpbJ5/hn3Ndg
	 9VLTh7QGvc07UgZglJOPiuVzr57E4UFs19x1zGmp/Ly3TUmii020ROS9/BWTCQT3iE
	 xagDUUYZj3GXds47tcDWufFyuz8Zq/hibafbcyBswon8WIA3wk+NTPmINtJzRCpyG7
	 sRX2DVPbukHgQ==
Date: Wed, 6 May 2026 19:27:13 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Felix Fietkau <nbd@nbd.name>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Simon Horman <horms@kernel.org>, David Ahern <dsahern@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH nf-next 0/4] Add IPv4 over IPv6 flowtable SW acceleration
Message-ID: <aft58U5Y0iQGi2JS@lore-desk>
References: <20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dBWX7q7eS4V4GZda"
Content-Disposition: inline
In-Reply-To: <20260505-b4-flowtable-sw-accel-ip6ip-v1-0-9ac39ccc9ea9@kernel.org>


--dBWX7q7eS4V4GZda
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Similar to IPIP and IP6I6 tunnels, introduce sw acceleration for IPv4 over
> IPv6 tunnels in the netfilter flowtable infrastructure.

Please drop this revision, I spotted a bug in MTU configuration in
nf_flow_offload_forward(). I will post v2 fixing the issue and adding
SIT support.

Regards,
Lorenzo

>=20
> ---
> Lorenzo Bianconi (4):
>       net: netfilter: Add ether_type to net_device_path_ctx
>       net: netfilter: Add encap_proto to flow_offload_tunnel
>       net: netfilter: Add IPv4 over IPv6 tunnel flowtable acceleration
>       selftests: netfilter: nft_flowtable.sh: Add IPv4 over IPv6 flowtabl=
e selftest
>=20
>  drivers/net/ethernet/airoha/airoha_ppe.c           |  14 ++-
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  13 ++-
>  include/linux/netdevice.h                          |   5 +-
>  include/net/netfilter/nf_flow_table.h              |   1 +
>  net/core/dev.c                                     |   6 +-
>  net/ipv4/ipip.c                                    |   1 +
>  net/ipv6/ip6_tunnel.c                              |   6 +-
>  net/netfilter/nf_flow_table_core.c                 |  14 ++-
>  net/netfilter/nf_flow_table_ip.c                   | 129 +++++++++++++++=
+-----
>  net/netfilter/nf_flow_table_path.c                 |  16 +--
>  .../selftests/net/netfilter/nft_flowtable.sh       |  26 +++++
>  11 files changed, 174 insertions(+), 57 deletions(-)
> ---
> base-commit: c1e5127b577c6b88fa48e532616932ae978528d5
> change-id: 20260505-b4-flowtable-sw-accel-ip6ip-7101034cd147
>=20
> Best regards,
> --=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>=20

--dBWX7q7eS4V4GZda
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaft58QAKCRA6cBh0uS2t
rLWvAP99BJDDX3b8y2+zfNm18ZUstMl46XX8mPMDwCOvVThzcgD+N51Qsadb2Qk5
NtKNQbi/t3ChjT3OgvGfw//o+PK0rwg=
=93pw
-----END PGP SIGNATURE-----

--dBWX7q7eS4V4GZda--
