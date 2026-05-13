Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12CA8481FCE;
	Wed, 13 May 2026 16:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778689019; cv=none; b=NhoiDTu1JqrDBsdrd2g8n1U8+iaq2Xt7/BRs+IDmzpll0lD/EAh6GwFPVOLzSDRVJ9Ls+LFmcho8mPqZJqNsSHK6XdnwK7slYzyHWNt9NcFHmwcMnePAQvHhw6bfk9HY700mWyyTYnGkInAmebpACYhcBRewl8ScTp6T7f7+0E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778689019; c=relaxed/simple;
	bh=txg5IRqMAAQxWXryox/D3NDnLrbEYJ7UtJmDgU0gCg0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EmDwVhbMxIs3SnTgk9uf4WOS8XsCVsxE3C4lDsM0FE9CXoUy9ydddIgh4XbfKEb+rmXGALD5U/s2+XqK/GpH1242TqWsmgG4w7DD3p+vz81tGGpc8YNrgiXLSpp7IiQB5qChYoRjPhRXLJ0PJvDu2lPAJdUNU+NteUeJUFshrWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uikC00p7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uikC00p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF1BC2BCB7;
	Wed, 13 May 2026 16:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778689018;
	bh=txg5IRqMAAQxWXryox/D3NDnLrbEYJ7UtJmDgU0gCg0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uikC00p7ZtAX+bOuhK4vYUguK9vKsM4MVaa/nY8qgRcKjJ4bcc1J/zj8Qk1n0j4Hp
	 C+4J/Ae/PA3FIhpMvXWeA4bXCWuQUDW5NV+YzRbqlnFGEjDgTpaftAMRVZXzctZbmv
	 57UE6w7vvvhiSPWIAMCD+TE1FKZNu5AjQ8huumuEDsbcunmm9imAkJnndqW2PpxK4Y
	 nWl27V+sgXeW7n9ZKSGi6DRWBhR7bZo7Fk82M9Y/0oZqdu22YhYpPhAfwAaK/dJXqM
	 kKQIn8mkj4vBOLTEvrPksgm+rNWKUeVZ/kVRy9x4yNr05TBgo0vOIDrddw62Y+L8vq
	 di1apMzbvmTpQ==
Date: Wed, 13 May 2026 18:16:56 +0200
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
Subject: Re: [PATCH net v2] net: neigh: Reallocate headroom if necessary in
 neigh_hh_bridge()
Message-ID: <agSj-N2cbp0FaC0n@lore-desk>
References: <20260511-nf-neigh_hh_bridge-fix-v2-1-c4964c7a7b8f@kernel.org>
 <20260513154855.GA425676@shredder>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="lBwmQDFD7+fOeJfh"
Content-Disposition: inline
In-Reply-To: <20260513154855.GA425676@shredder>


--lBwmQDFD7+fOeJfh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Mon, May 11, 2026 at 05:57:39PM +0200, Lorenzo Bianconi wrote:
> > diff --git a/include/net/neighbour.h b/include/net/neighbour.h
> > index 2dfee6d4258a..c2b6196705ef 100644
> > --- a/include/net/neighbour.h
> > +++ b/include/net/neighbour.h
> > @@ -487,16 +487,24 @@ static inline int neigh_event_send(struct neighbo=
ur *neigh, struct sk_buff *skb)
> >  }
> > =20
> >  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> > -static inline int neigh_hh_bridge(struct hh_cache *hh, struct sk_buff =
*skb)
> > +static inline struct sk_buff *
> > +neigh_hh_bridge(struct hh_cache *hh, struct sk_buff *skb)
> >  {
> > -	unsigned int seq, hh_alen;
> > +	unsigned int seq, hh_alen =3D HH_DATA_ALIGN(ETH_HLEN);
> > +
> > +	if (unlikely(skb_headroom(skb) < hh_alen ||
> > +		     skb_header_cloned(skb) || skb_shared(skb))) {
> > +		skb =3D skb_expand_head(skb, hh_alen);
>=20
> I don't think this is correct... The comment above skb_expand_head()
> says that it will generate a warning if there is sufficient headroom in
> the packet.
>=20
> I assumed that you would just call skb_cow_head() like the AI review
> suggested. There's skb_share_check() in br_handle_frame(), so no need to
> worry about the skb being shared.

Right, I was reviewing it. I will fix it in v3.

Regards,
Lorenzo

>=20
> > +		if (!skb)
> > +			return NULL;
> > +	}
> > =20
> >  	do {
> >  		seq =3D read_seqbegin(&hh->hh_lock);
> > -		hh_alen =3D HH_DATA_ALIGN(ETH_HLEN);
> >  		memcpy(skb->data - hh_alen, hh->hh_data, ETH_ALEN + hh_alen - ETH_HL=
EN);
> >  	} while (read_seqretry(&hh->hh_lock, seq));
> > -	return 0;
> > +
> > +	return skb;
> >  }
> >  #endif
> > =20
> > diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_=
hooks.c
> > index 0ab1c94db4b9..8d21c88c2116 100644
> > --- a/net/bridge/br_netfilter_hooks.c
> > +++ b/net/bridge/br_netfilter_hooks.c
> > @@ -297,7 +297,12 @@ int br_nf_pre_routing_finish_bridge(struct net *ne=
t, struct sock *sk, struct sk_
> >  				goto free_skb;
> >  			}
> > =20
> > -			neigh_hh_bridge(&neigh->hh, skb);
> > +			skb =3D neigh_hh_bridge(&neigh->hh, skb);
> > +			if (!skb) {
> > +				neigh_release(neigh);
> > +				return -ENOMEM;
> > +			}
>=20
> This part looks correct.
>=20
> > +
> >  			skb->dev =3D br_indev;
> > =20
> >  			ret =3D br_handle_frame_finish(net, sk, skb);
> >=20
> > ---
> > base-commit: a450063ef86b9967234ca1f896c0d77400c74f11
> > change-id: 20260508-nf-neigh_hh_bridge-fix-9ab775ee23c6
> >=20
> > Best regards,
> > --=20
> > Lorenzo Bianconi <lorenzo@kernel.org>
> >=20

--lBwmQDFD7+fOeJfh
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCagSj+AAKCRA6cBh0uS2t
rFO+AQC5RDeCneY5yiDoOKX2B+6hOZijkD4Kdhteuz9EdsId9QD+Om9iHXvB9ltL
hUI0UrJnl7gtRuh3A2FT177P0rjkzQo=
=6UIE
-----END PGP SIGNATURE-----

--lBwmQDFD7+fOeJfh--
