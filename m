Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F4B1C1F36
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732055659; cv=none; b=hsey9xXnQ3qfSGSuIfqbutPA6W9nXnTw02tOFZpzJiAvl3J5Geut5zQ0RMn5xqT9GOW2mMhNzLU7Wv2O+PwhWJBB9emPCAXChq2KDo9/l2KjNDEpo8ls9vQHdXMsYqiWiyxIFZp1KcPKQvifQb5X3S1c8cO8c2XmMeRL4TV3vUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732055659; c=relaxed/simple;
	bh=TbNYHSfuTu70M4Ii8OdtJLF3j9h/u6d4jXWoFTVe3j4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaT/CDRI2+o8iDlUWnenbapzQNEmsBdsegYrjtVE/T0ncpRRG/9rIEN/LX9IP+cJBeU01pjOC6fagp79pjoVMyJgZ+wOLsu2218FdjzJeCPCNZiTjIPeS4k2R+6AcapJCTPFGiIOlvMlCwr6Fpb/8dcupyT9fel2ymFJyjz7Kes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=RXUr46T/; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="RXUr46T/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KkYX5T1v5xLI4IFT5sD44aStCnNZ3LfQ13fMrU0VIUI=; b=RXUr46T/miFyAPS7CX3ELBZrwl
	3OfqIbVTosYKBsEkQ/DJVVw/Ccdm5wtyu9wM7pkS+OyOPt5We7nfI+qfBcT9TyotwaM6Cl62+0/dR
	lIyeZ3rcgjYibY5dPOGNFVS2UwoW8jlJk/RIUMp5bQ+j3uGFggEoa1TZdgxuzxPV2PIvPCnj4hbmR
	63TdY+ubFTAsXvM4T3hJfUNQdjLXEo7boPwFMarn4MJ2QtPfVS+IVWL0oDxkaS08g4B7jG4+YhjLX
	GNr0I/q+oZJXmVhFPM5ebsUxH13aXt/TJwFV86W0H7Fh5vtqlw0hV7NQHjbfZKv+506ycIPqFYZfH
	UoO59u/w==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tDWnT-009wT2-22;
	Tue, 19 Nov 2024 22:34:11 +0000
Date: Tue, 19 Nov 2024 22:34:10 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 1/2] nft: fix interface comparisons in `-C`
 commands
Message-ID: <20241119223410.GB3017153@celephais.dreamlands>
References: <20241119220325.30700-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TbMgf9xl6r2YGB80"
Content-Disposition: inline
In-Reply-To: <20241119220325.30700-1-phil@nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--TbMgf9xl6r2YGB80
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-11-19, at 23:03:24 +0100, Phil Sutter wrote:
> From: Jeremy Sowden <jeremy@azazel.net>
>=20
> Commit 9ccae6397475 ("nft: Leave interface masks alone when parsing from
> kernel") removed code which explicitly set interface masks to all ones.  =
The
> result of this is that they are zero.  However, they are used to mask int=
erfaces
> in `is_same_interfaces`.  Consequently, the masked values are alway zero,=
 the
> comparisons are always true, and check commands which ought to fail succe=
ed:
>=20
>   # iptables -N test
>   # iptables -A test -i lo \! -o lo -j REJECT
>   # iptables -v -L test
>   Chain test (0 references)
>    pkts bytes target     prot opt in     out     source               des=
tination
>       0     0 REJECT     all  --  lo     !lo     anywhere             any=
where             reject-with icmp-port-unreachable
>   # iptables -v -C test -i abcdefgh \! -o abcdefgh -j REJECT
>   REJECT  all opt -- in lo out !lo  0.0.0.0/0  -> 0.0.0.0/0   reject-with=
 icmp-port-unreachable
>=20
> Remove the mask parameters from `is_same_interfaces`.  Add a test-case.
>=20
> Fixes: 9ccae6397475 ("nft: Leave interface masks alone when parsing from =
kernel")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
> Changes since v1:
> - Replace the loop by strncmp() calls.

LGTM.

J.

> ---
>  iptables/nft-arp.c                            | 10 ++----
>  iptables/nft-ipv4.c                           |  4 +--
>  iptables/nft-ipv6.c                           |  6 +---
>  iptables/nft-shared.c                         | 36 +++++--------------
>  iptables/nft-shared.h                         |  6 +---
>  .../nft-only/0020-compare-interfaces_0        |  9 +++++
>  6 files changed, 22 insertions(+), 49 deletions(-)
>  create mode 100755 iptables/tests/shell/testcases/nft-only/0020-compare-=
interfaces_0
>=20
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index 264864c3fb2b2..c11d64c368638 100644
> --- a/iptables/nft-arp.c
> +++ b/iptables/nft-arp.c
> @@ -385,14 +385,8 @@ static bool nft_arp_is_same(const struct iptables_co=
mmand_state *cs_a,
>  		return false;
>  	}
> =20
> -	return is_same_interfaces(a->arp.iniface,
> -				  a->arp.outiface,
> -				  (unsigned char *)a->arp.iniface_mask,
> -				  (unsigned char *)a->arp.outiface_mask,
> -				  b->arp.iniface,
> -				  b->arp.outiface,
> -				  (unsigned char *)b->arp.iniface_mask,
> -				  (unsigned char *)b->arp.outiface_mask);
> +	return is_same_interfaces(a->arp.iniface, a->arp.outiface,
> +				  b->arp.iniface, b->arp.outiface);
>  }
> =20
>  static void nft_arp_save_chain(const struct nftnl_chain *c, const char *=
policy)
> diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
> index 740928757b7e2..0c8bd2911d105 100644
> --- a/iptables/nft-ipv4.c
> +++ b/iptables/nft-ipv4.c
> @@ -113,9 +113,7 @@ static bool nft_ipv4_is_same(const struct iptables_co=
mmand_state *a,
>  	}
> =20
>  	return is_same_interfaces(a->fw.ip.iniface, a->fw.ip.outiface,
> -				  a->fw.ip.iniface_mask, a->fw.ip.outiface_mask,
> -				  b->fw.ip.iniface, b->fw.ip.outiface,
> -				  b->fw.ip.iniface_mask, b->fw.ip.outiface_mask);
> +				  b->fw.ip.iniface, b->fw.ip.outiface);
>  }
> =20
>  static void nft_ipv4_set_goto_flag(struct iptables_command_state *cs)
> diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
> index b184f8af3e6ed..4dbb2af206054 100644
> --- a/iptables/nft-ipv6.c
> +++ b/iptables/nft-ipv6.c
> @@ -99,11 +99,7 @@ static bool nft_ipv6_is_same(const struct iptables_com=
mand_state *a,
>  	}
> =20
>  	return is_same_interfaces(a->fw6.ipv6.iniface, a->fw6.ipv6.outiface,
> -				  a->fw6.ipv6.iniface_mask,
> -				  a->fw6.ipv6.outiface_mask,
> -				  b->fw6.ipv6.iniface, b->fw6.ipv6.outiface,
> -				  b->fw6.ipv6.iniface_mask,
> -				  b->fw6.ipv6.outiface_mask);
> +				  b->fw6.ipv6.iniface, b->fw6.ipv6.outiface);
>  }
> =20
>  static void nft_ipv6_set_goto_flag(struct iptables_command_state *cs)
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index 6775578b1e36b..2c29e68f551df 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -220,36 +220,16 @@ void add_l4proto(struct nft_handle *h, struct nftnl=
_rule *r,
>  }
> =20
>  bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
> -			unsigned const char *a_iniface_mask,
> -			unsigned const char *a_outiface_mask,
> -			const char *b_iniface, const char *b_outiface,
> -			unsigned const char *b_iniface_mask,
> -			unsigned const char *b_outiface_mask)
> +			const char *b_iniface, const char *b_outiface)
>  {
> -	int i;
> -
> -	for (i =3D 0; i < IFNAMSIZ; i++) {
> -		if (a_iniface_mask[i] !=3D b_iniface_mask[i]) {
> -			DEBUGP("different iniface mask %x, %x (%d)\n",
> -			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
> -			return false;
> -		}
> -		if ((a_iniface[i] & a_iniface_mask[i])
> -		    !=3D (b_iniface[i] & b_iniface_mask[i])) {
> -			DEBUGP("different iniface\n");
> -			return false;
> -		}
> -		if (a_outiface_mask[i] !=3D b_outiface_mask[i]) {
> -			DEBUGP("different outiface mask\n");
> -			return false;
> -		}
> -		if ((a_outiface[i] & a_outiface_mask[i])
> -		    !=3D (b_outiface[i] & b_outiface_mask[i])) {
> -			DEBUGP("different outiface\n");
> -			return false;
> -		}
> +	if (strncmp(a_iniface, b_iniface, IFNAMSIZ)) {
> +		DEBUGP("different iniface\n");
> +		return false;
> +	}
> +	if (strncmp(a_outiface, b_outiface, IFNAMSIZ)) {
> +		DEBUGP("different outiface\n");
> +		return false;
>  	}
> -
>  	return true;
>  }
> =20
> diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
> index 51d1e4609a3b6..b57aee1f84a87 100644
> --- a/iptables/nft-shared.h
> +++ b/iptables/nft-shared.h
> @@ -105,11 +105,7 @@ void add_l4proto(struct nft_handle *h, struct nftnl_=
rule *r, uint8_t proto, uint
>  void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv);
> =20
>  bool is_same_interfaces(const char *a_iniface, const char *a_outiface,
> -			unsigned const char *a_iniface_mask,
> -			unsigned const char *a_outiface_mask,
> -			const char *b_iniface, const char *b_outiface,
> -			unsigned const char *b_iniface_mask,
> -			unsigned const char *b_outiface_mask);
> +			const char *b_iniface, const char *b_outiface);
> =20
>  void __get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, uint8=
_t *op);
>  void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *i=
nv);
> diff --git a/iptables/tests/shell/testcases/nft-only/0020-compare-interfa=
ces_0 b/iptables/tests/shell/testcases/nft-only/0020-compare-interfaces_0
> new file mode 100755
> index 0000000000000..278cd648ebb78
> --- /dev/null
> +++ b/iptables/tests/shell/testcases/nft-only/0020-compare-interfaces_0
> @@ -0,0 +1,9 @@
> +#!/bin/bash
> +
> +[[ $XT_MULTI =3D=3D *xtables-nft-multi ]] || { echo "skip $XT_MULTI"; ex=
it 0; }
> +
> +$XT_MULTI iptables -N test
> +$XT_MULTI iptables -A test -i lo \! -o lo -j REJECT
> +$XT_MULTI iptables -C test -i abcdefgh \! -o abcdefgh -j REJECT 2>/dev/n=
ull && exit 1
> +
> +exit 0
> --=20
> 2.47.0
>=20

--TbMgf9xl6r2YGB80
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmc9EjYACgkQKYasCr3x
BA0cmxAAm0P7iJDGlKj1f5KHZQj9gtrnfipk2zoJL4WwOz2bF0XVzkr0F+/1d0Ag
bPQ72piJNKk/oQg0J0vEzTadGnChnlpPsgdGcLme9yVxQ1GohejbhzC77N1a1Rva
37Cv+c0WFH2IbPMO4cOuVHOgSvsj23jjBxnrj4LGp+8MlwAAHpr1txcjD/h3Dydp
IrE9o858Jb0nrN92+rOedOto1AnTEK4fxo/RllRpt7OaPNX2Is/PJfa4Yv2v6OAz
dXRjvCSaE2T416WbBq5jo9+7SUM28SISLobkbPswpz4E1g3UtJk9wUTFndX3v0TD
I/ikH5geD3jPTU8TPlMYLQ2dpWAO+XDnB/WzPj1SWfU2gRFTx8HmnJMUptAYhLhG
RZF2xIt2jk1Bqkck1lxIO6qFpWHl56biv+GfzHt3VRVBxLZ/Dd8u8GYeIyq4T8K0
3VHlUrVqNbbGoLdvGNrncXxCm4kg0BZXV7M7DfaRJa45etflAJ1eDy04rwDTn/LJ
ItuslMl/99i43oTR+jJI7A1WRqVyTHGT18IQcXUzeeUASr/agLeZ51yQp5ZVTyRH
IZ0awGxzyCQmDe+zO/8ry/V6F6fMXptSk5OJNQ5AdDY4qB3bHV50IRvoNFL0mYqW
kdd5jZ/l3N2FOwpHKJGiRAjwXTCgPaePLy28zAC9y3b+moWey1I=
=X6R+
-----END PGP SIGNATURE-----

--TbMgf9xl6r2YGB80--
