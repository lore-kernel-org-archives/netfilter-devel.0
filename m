Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B283D903E;
	Wed, 20 May 2026 15:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779291388; cv=none; b=ZIEEZ/n1VijTaS9ZXgGQntKYSBiruSNmvFhGBEtiEjzCTlO5OgkBd6Q9axaH8MnL/jHkzM1G8PT8b+na1v0JGUW3aVr8JmLPgVx4EYSIN1nmwEbcxW0NHo9EsUweGQyxUqONewj/P9KIF4bti5q7asUzrOaytpPYrovRrrHTmBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779291388; c=relaxed/simple;
	bh=MNY5MML6AuvZHU3oIRofKtZEGFa9zFjnoghjgfd7Ct8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RmpUOl43lwP0lJxQj5i5p2grAIUgvUzzuOnZCGuxzZ9K7c4h7hdV+OYUzl0DyNwe6GJQozi1wfJPAqPjfUY853x8zH9tJ5BQ8nxiAv8iLg38Llsjm+lLlhzBBezBo12y0lFiEDNwQZ3SeDfgxqVmzJQtyrrEx/of7gKzfM9nGGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HmxflIBq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HmxflIBq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2EE51F000E9;
	Wed, 20 May 2026 15:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779291387;
	bh=a2tRUQgRwBejUhg1cYn+oCvO34Dh5HeYuLe9vbd7LI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HmxflIBqTEPMrZ+FGAoQNKSPX0MdonqQ8oPlwrBuupAyWh8MEA/9OI5MpxCzJm1wM
	 QODUBzFOQ+Oqpwp9I0lQMxZvcd1zFDdeVNBxcgdL686H736PWU/zRbBoQb1Kl22FPi
	 i4qJixTzCo5BEpVWY2XJ73Zh6vOIVWL3qRqzPhkzxkuHhTEAvYwmBdyU0oOCZVfXwg
	 lMWx50jMpnZaXz6Uje8rPeHsmi74KdcPe4EgDvG5SIZSjwxWtLI6lA3RaiobMf5UoA
	 nnTsPH6T+Liog+P/nQw9U2klbHKMi4zQwsKkZzUXeBSYhx8sT6ROmC425Uu734bObH
	 b1VY5rjrZbHVg==
Date: Wed, 20 May 2026 17:36:24 +0200
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
Subject: Re: [PATCH nf-next v2 0/6] Add IPv4 over IPv6 and SIT flowtable SW
 acceleration
Message-ID: <ag3U-DmEWiwcH0uB@lore-desk>
References: <20260506-b4-flowtable-sw-accel-ip6ip-v2-0-439fd427726e@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="y1SQHS4FsUVyGc0Q"
Content-Disposition: inline
In-Reply-To: <20260506-b4-flowtable-sw-accel-ip6ip-v2-0-439fd427726e@kernel.org>


--y1SQHS4FsUVyGc0Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Similar to IPIP and IP6I6 tunnels, introduce sw acceleration for IPv4 over
> IPv6 and SIT tunnels in the netfilter flowtable infrastructure.
>=20
> ---
> Changes in v2:
> - Fix MTU check in nf_flow_offload_forward() and in
>   nf_flow_offload_ipv6_forward()
> - Add SIT sw acceleration support
> - Link to v1: https://lore.kernel.org/r/20260505-b4-flowtable-sw-accel-ip=
6ip-v1-0-9ac39ccc9ea9@kernel.org

Hi Pablo and Florian,

Any update about this series? Thanks in advance.

Regards,
Lorenzo

>=20
> ---
> Lorenzo Bianconi (6):
>       net: netfilter: Add ether_type to net_device_path_ctx
>       net: netfilter: Add encap_proto to flow_offload_tunnel
>       net: netfilter: Add IPv4 over IPv6 tunnel flowtable acceleration
>       selftests: netfilter: nft_flowtable.sh: Add IPv4 over IPv6 flowtabl=
e selftest
>       net: netfilter: Add SIT tunnel flowtable acceleration
>       selftests: netfilter: nft_flowtable.sh: Add SIT flowtable selftest
>=20
>  drivers/net/ethernet/airoha/airoha_ppe.c           |  14 +-
>  drivers/net/ethernet/mediatek/mtk_ppe_offload.c    |  13 +-
>  include/linux/netdevice.h                          |   5 +-
>  include/net/netfilter/nf_flow_table.h              |   1 +
>  net/core/dev.c                                     |   6 +-
>  net/ipv4/ipip.c                                    |   1 +
>  net/ipv6/ip6_tunnel.c                              |   6 +-
>  net/ipv6/sit.c                                     |  26 ++
>  net/netfilter/nf_flow_table_core.c                 |  14 +-
>  net/netfilter/nf_flow_table_ip.c                   | 386 +++++++++++++--=
------
>  net/netfilter/nf_flow_table_path.c                 |  16 +-
>  tools/testing/selftests/net/netfilter/config       |   1 +
>  .../selftests/net/netfilter/nft_flowtable.sh       |  78 ++++-
>  13 files changed, 402 insertions(+), 165 deletions(-)
> ---
> base-commit: c1e5127b577c6b88fa48e532616932ae978528d5
> change-id: 20260505-b4-flowtable-sw-accel-ip6ip-7101034cd147
>=20
> Best regards,
> --=20
> Lorenzo Bianconi <lorenzo@kernel.org>
>=20

--y1SQHS4FsUVyGc0Q
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCag3U+AAKCRA6cBh0uS2t
rPv9AQCAeVJ4LW3/ZIxsIiBE3XnXj6UlIBCD6SYxGD9HVjHqTAD9ETIzVKrKIpnn
TWQXuXJqNaEhL7TTPrv+698yNy3I2QA=
=eDma
-----END PGP SIGNATURE-----

--y1SQHS4FsUVyGc0Q--
