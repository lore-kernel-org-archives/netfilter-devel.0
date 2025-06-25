Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394D9288CB7;
	Wed, 25 Jun 2025 10:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750847470; cv=none; b=ZnPStjbAurasZTgr9MkorxeL229OxhyBBRaTVVeESIZ1nLqH0IrpL5NZ/hjYBtDMqx910iDPWHPlC9PaDxh6Cfm5pPHMS7Ex4xPYPZwWTxpAxL6fTw5mSQ60lwxNR8PzpJ0ZguYNw85XrZzgZ8ON1hB9MlhBcCDYmL743Ilh6fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750847470; c=relaxed/simple;
	bh=sLAFf8mT4zR2vOebSi3Nwqi90zImbsSiLRjN8NT+0+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gfu7G92EgQrwG8pJyh1Ic6XqwhUDGWnf+0i8BDGlyjPpX+mXF+/Jj65LKBJ7h6nWix3xM7fzTOllfDUdHM2J39tLpdW6K2glOrDWEKal2HUmU7YZ8MxGZJNR7/OtLzqhCO2aa5I+iHIaXukO2VGavc+xnaKfZ9VImMW+5iZzfjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rMHv4YCi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rMHv4YCi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423D6C4CEEA;
	Wed, 25 Jun 2025 10:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750847469;
	bh=sLAFf8mT4zR2vOebSi3Nwqi90zImbsSiLRjN8NT+0+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rMHv4YCiyZ7ozKjQ6yvvxKARm6kSfVsYOcKWu7/VScu05+NlyyZ1tv3gYoghdxCoS
	 9Ie5ndyrJ3dMZG3NFQucRq1PgmnqqfEkTqv2RREUHwCn+QeHW8AnuzrRPTc/3g6XK8
	 dhdiNBHRmCo5MkMsmCjWm1A7jDgTxCJJNFO2Uh22oM7DKFTqaQgOluRN5FQb5H3qRA
	 rNVWxWxnETUkOyahhzJCW88PZuVuh2JLszLHwGN5ntlGsfu7DqC0G3FL7ESHaAGR9q
	 9RamEx6KJUDYN7WbpMZyNLDntXGW3Rz1Mh4fp05x8V8Em9QVfJbXBVxTMeQurFuX/+
	 U73SV2vpTAtnQ==
Date: Wed, 25 Jun 2025 12:31:06 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH net-next] net: netfilter: Add IPIP flowtable SW
 acceleration
Message-ID: <aFvP6jthcX6Lbq4C@lore-desk>
References: <20250623-nf-flowtable-ipip-v1-1-2853596e3941@kernel.org>
 <20250624172213.67768427@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oeDl1dMHbyy1Fudd"
Content-Disposition: inline
In-Reply-To: <20250624172213.67768427@kernel.org>


--oeDl1dMHbyy1Fudd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, 23 Jun 2025 15:15:51 +0200 Lorenzo Bianconi wrote:
> > Introduce SW acceleration for IPIP tunnels in the netfilter flowtable
> > infrastructure.
>=20
> From a look at this patch and the code in nf_flow_table_ip.c
> I'm a little unclear on whether the header push/pop happens
> if we "offload" the forwarding.
>=20
> > IPIP SW acceleration can be tested...
>=20
> I think it's time we start to ask for selftest that can both run in SW
> mode and be offload if appropriate devices are pass in via env.

ack, I will add a selftest to nft_flowtable.sh

Regards,
Lorenzo

> --=20
> pw-bot: cr

--oeDl1dMHbyy1Fudd
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCaFvP6gAKCRA6cBh0uS2t
rNC4AP9o9U9m3NQ/tILbGh+n4QcSvIaluSjuE9Jb7ZAFzwK6lgD/YlPmLZEdLht8
G0sKhihBeYahh9p4stD4kDTE8X8g/gA=
=OdNd
-----END PGP SIGNATURE-----

--oeDl1dMHbyy1Fudd--
