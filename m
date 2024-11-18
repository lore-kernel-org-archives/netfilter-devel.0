Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D2613D251
	for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2024 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731940862; cv=none; b=SwIV0fjUMv6Wdcm65eqNpKd1au2Nbt+AgVx+eJp8PWRIuEiH7rPw23YLYcWMtPLPBmPfWJk6H4/qxdNpAvzDcw4FvmxqutOC0K3KkwHD5a5i4id95HXLrBfJ495WChhvVvoC50GXn8wTxYBq4wdGbmR4blzB7SmROTEo9I4Q55E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731940862; c=relaxed/simple;
	bh=fo3riHvnchiU1WQE6+GO3SX00k96hsHmaYfAL+E3s88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TpIhIVBgwNyea97p/Nra7+TIgAW3TpJPEuijdVdOhTW2nJP/PnEf7xFre9o4TWHlyGPBHZ6thrNK+IrfU1zF/QKGrTNQqN9p6FyKF9KRR/ZAzQyz9W5QBlxCA8V8dcp2mXSpWsJL/Ft7EJMnmri3yAKGBsWVo6SgYGM2EAq0wOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=qLv75zYe; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="qLv75zYe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0FSfrE8YKHkCPTyHVDRKTYm0VFj1nnvYejBn5z0roUg=; b=qLv75zYeh0LA/Ujq09hn9DPboF
	yYojkDQ1rt1Jt/6hswb7Pal0Xvl+e9/XtoDjWCYpK9xALRZhPeEcC0QjnnerZCJVndtiAsr8DRrwU
	BSXY7xapjOo/ANJR8tza8Av4GTKCWoYCJ7C0S8OCdhYZAQHv9Mc5lWz16NcTcXBx87W17aXYwE3Sn
	Iwo9ysOwd0pWyau+9qRLj+UQXWS48Br6ThhaVvTol4Ny2QsHU3NEbyO9XXmxVG8Sd3Bd8xLaAnih0
	o28uq+U4m/SDoZSESQwVEdAM5SXjn4HsnNII1W0OGjhS/JjiHGmW1MNFHugzMhBU7loRQr/TmzPuw
	2C1q6ZkQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tD2vu-008Wb6-2S;
	Mon, 18 Nov 2024 14:40:54 +0000
Date: Mon, 18 Nov 2024 14:40:53 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] nft: fix interface comparisons in `-C` commands
Message-ID: <20241118144053.GF1547978@celephais.dreamlands>
References: <20241118135650.510715-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nKuK0hiSNElTA97N"
Content-Disposition: inline
In-Reply-To: <20241118135650.510715-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--nKuK0hiSNElTA97N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-11-18, at 13:56:50 +0000, Jeremy Sowden wrote:
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

Forgot to include a link to the Debian bug report:

Link: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1087210
> Fixes: 9ccae6397475 ("nft: Leave interface masks alone when parsing from =
kernel")
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  iptables/nft-arp.c                            | 10 ++-------
>  iptables/nft-ipv4.c                           |  4 +---
>  iptables/nft-ipv6.c                           |  6 +-----
>  iptables/nft-shared.c                         | 21 +++----------------
>  iptables/nft-shared.h                         |  6 +-----
>  .../nft-only/0020-compare-interfaces_0        |  9 ++++++++
>  6 files changed, 17 insertions(+), 39 deletions(-)
>  create mode 100755 iptables/tests/shell/testcases/nft-only/0020-compare-=
interfaces_0
>=20
> diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
> index 264864c3fb2b..c11d64c36863 100644
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
> index 740928757b7e..0c8bd2911d10 100644
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
> index b184f8af3e6e..4dbb2af20605 100644
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
> index 6775578b1e36..fab77b011963 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -220,31 +220,16 @@ void add_l4proto(struct nft_handle *h, struct nftnl=
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
>  	int i;
> =20
>  	for (i =3D 0; i < IFNAMSIZ; i++) {
> -		if (a_iniface_mask[i] !=3D b_iniface_mask[i]) {
> -			DEBUGP("different iniface mask %x, %x (%d)\n",
> -			a_iniface_mask[i] & 0xff, b_iniface_mask[i] & 0xff, i);
> -			return false;
> -		}
> -		if ((a_iniface[i] & a_iniface_mask[i])
> -		    !=3D (b_iniface[i] & b_iniface_mask[i])) {
> +		if (a_iniface[i] !=3D b_iniface[i]) {
>  			DEBUGP("different iniface\n");
>  			return false;
>  		}
> -		if (a_outiface_mask[i] !=3D b_outiface_mask[i]) {
> -			DEBUGP("different outiface mask\n");
> -			return false;
> -		}
> -		if ((a_outiface[i] & a_outiface_mask[i])
> -		    !=3D (b_outiface[i] & b_outiface_mask[i])) {
> +		if (a_outiface[i] !=3D b_outiface[i]) {
>  			DEBUGP("different outiface\n");
>  			return false;
>  		}
> diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
> index 51d1e4609a3b..b57aee1f84a8 100644
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
> index 000000000000..278cd648ebb7
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
> 2.45.2
>=20
>=20

--nKuK0hiSNElTA97N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmc7UeMACgkQKYasCr3x
BA3TdQ//dnOFURlTu+q/eRC5l7J+aONAKn1LNG/fA4F0e1Xr+X5KkWUKcknkM//o
DppoA2Hxex7RcLWSPcP08+yVu7zI9EtL5tiF7CK2gyjZNN+EBHZs7aCLbuvKLggZ
aNkNVelD6E/H39xcOIWgaO0yQv+woM3+QOPqj7mg+vHhIFT3aCHjFzZZv5tI2/9a
5EOjmDkIJMPOmA9up4T5vdTPF5jfU/UIuZCtRHWyQ+9tLE29qgYV5eEB3yPBBTrE
/loPLFQQT7iXMfQRf/GPT9Pt8JNERsvRvlbyMlivAOGztts4ZucsrjVmT24YO412
dO3cspFYQHd9pCQK6II8MjPMZK2ZpM3+VUttLQpeGmWAVtpVApE2F6QJE7rS1YAD
9K9Y91dxkwt7CMwmfUOWivXGL59ybgnwAF/SB+/MKHwNb69MJNdTXpvRWJ1mNEkw
4Q45kDZIHEMqCmEazWTd1DzuKum10TWxzzBecMbU6tNy7HE7PAj9K2T7dbfLUGZn
bTf/hmRqJeUr8YhBb2OoTxAlvAUQqDEo5iCfns/8/sGNOqxY3hlH8cRqFvxY1ll9
8l8qmPEmUmwki0apOF/cNuVLzrdtbaMlbqsqUUw2s17HbeW4QQUwcurawULytux1
sRkbumH0wH2fQogXsL1F3eclI+e55HVy1R6mCO/oNF0WSCSH9mo=
=jg/l
-----END PGP SIGNATURE-----

--nKuK0hiSNElTA97N--
