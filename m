Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2033839B1;
	Thu, 14 May 2026 12:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778760401; cv=none; b=eRsa6YnPC02TTKHv/+t3RatYZ+6F3kvUPf6+pLvtkkakyd9JeQEbkANFKqkfGIr/VLBomzkIhieCA4NSTIC7BYTxypCekBNmCCPEKIOWn8ai2n+85fx/aCLf6xObCkXcBQFjeOgUiYhRX+7lE0Hmaggw+sc/AhVDR2bTP8DkFAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778760401; c=relaxed/simple;
	bh=9vB1EWSq/DVwRSEhtoNt5TL9Kv2T883/7jdIP1gMqXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=srbfiyd3hCcfVHpxZVr4fvyoaH5O4BJwzzWjwrxY0jbX+rt952AOFX7sEqB7Dm/Lm6ulyl889VDzeNag9SWYliZ6OJxerDs4ewxX9L+68Ji41KuhKkT7l9uYNOdW+5pZiSGYpoiOGehIcTrhylMnCPiSZql3eeWigvKutmfY6MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLZxK2iU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLZxK2iU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F164BC2BCB3;
	Thu, 14 May 2026 12:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778760401;
	bh=9vB1EWSq/DVwRSEhtoNt5TL9Kv2T883/7jdIP1gMqXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GLZxK2iU7Vkx1TAHXjczcKSmH4ndxAU5okZT8u7BbiyJDvfc5RW9dQXyU9WH8AcAQ
	 Qrdg0MyKsZyJu6gf1zLPNexfDWLMJKxYC5XvVZO5VgtJe91D9Q2+ueygbsx4O6/2xD
	 W1LdMHKK4YUA7+nCrpsN8GA/ZTe+u4MQRMtI5uj2Io1/Iq6CeIavCoSuMaxCD2/7DP
	 ATUzzFlyYjk0QsV/xBev2oahtBnKVU1EzZczRIQoIZWr4YvwWyt8H8fWDp0sX8tpUF
	 o9pGsyCyCojIPDc4wmYWwnjwd67+c7hoI/7gXVt3Q6n1LfCJ/XXXdpHqObYY9UJ/fs
	 tLEuvufhR1DfQ==
Date: Thu, 14 May 2026 14:06:38 +0200
From: Lorenzo Bianconi <lorenzo@kernel.org>
To: Ido Schimmel <idosch@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	bridge@lists.linux.dev
Subject: Re: [PATCH net v3] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <agW6zjwDHB3dTiZC@lore-desk>
References: <20260513-nf-neigh_hh_bridge-fix-v3-1-8ec9353c0909@kernel.org>
 <20260514081403.GA482081@shredder>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BHhHzX+r3sha0mOx"
Content-Disposition: inline
In-Reply-To: <20260514081403.GA482081@shredder>


--BHhHzX+r3sha0mOx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Wed, May 13, 2026 at 06:40:28PM +0200, Lorenzo Bianconi wrote:
> > neigh_hh_bridge() assumes the skb always has sufficient headroom to copy
> > the aligned  L2 header. This assumption can trigger the crash reported
> > below using the following netfilter setup:
> >=20
> > $modprobe br_netfilter
> > $sysctl -w net.bridge.bridge-nf-call-iptables=3D1
> >=20
> > $root@OpenWrt:~# nft list ruleset
> > table ip nat {
> >         chain prerouting {
> >                 type nat hook prerouting priority dstnat; policy accept;
> >                 ip daddr 192.168.83.123 dnat to 192.168.83.120
> >         }
> > }
> >=20
> > - iperf3 client (192.168.83.119) --> bridge (192.168.83.118) --> iperf3=
 server (192.168.83.120)
> >=20
> > the iperf3 client is sending packet for 192.168.83.123 to the bridge de=
vice.
>=20
> [...]
>=20
> >=20
> > Fix the issue reallocating the skb headroom if necessary in neigh_hh_br=
idge routine.
> >=20
> > Fixes: e179e6322ac33 ("netfilter: bridge-netfilter: Fix MAC header hand=
ling with IP DNAT")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>=20
> [...]
>=20
> > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_=
hooks.c
> > index 0ab1c94db4b9..cea2352900e9 100644
> > --- a/net/bridge/br_netfilter_hooks.c
> > +++ b/net/bridge/br_netfilter_hooks.c
> > @@ -297,7 +297,13 @@ int br_nf_pre_routing_finish_bridge(struct net *ne=
t, struct sock *sk, struct sk_
> >  				goto free_skb;
> >  			}
> > =20
> > -			neigh_hh_bridge(&neigh->hh, skb);
> > +			ret =3D neigh_hh_bridge(&neigh->hh, skb);
> > +			if (ret) {
> > +				neigh_release(neigh);
> > +				kfree_skb(skb);
> > +				return ret;
>=20
> Personally I would use 'goto free_skb' after releasing the neighbour, to
> be consistent with the other paths that free the packet.

ack, I do not have a strong opinion about it, but in this case we would nee=
d to
even move "ret" since the current codebase always returns 0. What do you pr=
efer?

Regards,
Lorenzo

>=20
> > +			}
> > +
> >  			skb->dev =3D br_indev;
> > =20
> >  			ret =3D br_handle_frame_finish(net, sk, skb);

--BHhHzX+r3sha0mOx
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCagW6zgAKCRA6cBh0uS2t
rFA2AQD0wzqiD75x2qPH5KnF1ABzFFEOhi/1YZYL+UtNdNbjZgEAxsBjOOq0CFTD
YlqSl2AmSZ0c1L9CP8Tx71oJE4MYTgQ=
=iTia
-----END PGP SIGNATURE-----

--BHhHzX+r3sha0mOx--
