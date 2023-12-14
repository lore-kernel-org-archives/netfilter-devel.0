Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="SG/H8uCI"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550CF91
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 06:44:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Uz9QxRyLjcWdj2XW8UVguKw/Kyfhb461O67Ym2rI5h8=; b=SG/H8uCIwdomEhJx3WbKRpvjNU
	0wJm1oaZf/fa96R+BHIEvtR8rn/14qeDCyaKZCaLReOe0IxtGT99YGv00ONaoJcxi2h+YJKWZ5Cwo
	byR4ZVKEoTHc+C+xuzxpNae93khp+JKgsEaKOG/a+so19jNNykEbpa0gCdLsGPO+fgQmKYs/LIrXe
	r4OohoEPBbbUsXvnazlC/BGuLprX/NMDD9M4VAI3m8IlDnRI4VMsElxM7pmFJuvLzwZkOcBDVhQwd
	d2f+NzrnUwAHhAbeMn2jkwbg1f2sngOvuOUpzIIGm0TejwIPle2OVYwAhLe6MLU1n8Z8+75Lpyboi
	XKaIzxgg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDmxK-0035pJ-2p
	for netfilter-devel@vger.kernel.org;
	Thu, 14 Dec 2023 14:44:54 +0000
Date: Thu, 14 Dec 2023 14:44:53 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables 6/7] build: replace `echo -e` with `printf`
Message-ID: <20231214144453.GL1120209@celephais.dreamlands>
References: <20231214125927.925993-1-jeremy@azazel.net>
 <20231214125927.925993-7-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ZWpzfLVIJMjiiMQ/"
Content-Disposition: inline
In-Reply-To: <20231214125927.925993-7-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--ZWpzfLVIJMjiiMQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-12-14, at 12:59:21 +0000, Jeremy Sowden wrote:
> `echo -e` is not portable and we can end up with:
>=20
>       GEN      matches.man
>     -e      + ./libxt_addrtype.man
>     -e      + ./libip6t_ah.man
>     -e      + ./libipt_ah.man
>     -e      + ./libxt_bpf.man
>     -e      + ./libxt_cgroup.man
>     -e      + ./libxt_cluster.man
>     -e      + ./libxt_comment.man
>     -e      + ./libxt_connbytes.man
>     -e      + ./libxt_connlabel.man
>     -e      + ./libxt_connlimit.man
>     -e      + ./libxt_connmark.man
>     -e      + ./libxt_conntrack.man
>     [...]
>=20
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  extensions/GNUmakefile.in | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
> index dfa58c3b9e8b..f41af7c1420d 100644
> --- a/extensions/GNUmakefile.in
> +++ b/extensions/GNUmakefile.in
> @@ -228,19 +228,19 @@ man_run    =3D \
>  	for ext in $(sort ${1}); do \
>  		f=3D"${srcdir}/libxt_$$ext.man"; \
>  		if [ -f "$$f" ]; then \
> -			echo -e "\t+ $$f" >&2; \
> +			printf "\t+ $$f" >&2; \
>  			echo ".SS $$ext"; \
>  			cat "$$f" || exit $$?; \
>  		fi; \
>  		f=3D"${srcdir}/libip6t_$$ext.man"; \
>  		if [ -f "$$f" ]; then \
> -			echo -e "\t+ $$f" >&2; \
> +			printf "\t+ $$f" >&2; \
>  			echo ".SS $$ext (IPv6-specific)"; \
>  			cat "$$f" || exit $$?; \
>  		fi; \
>  		f=3D"${srcdir}/libipt_$$ext.man"; \
>  		if [ -f "$$f" ]; then \
> -			echo -e "\t+ $$f" >&2; \
> +			printf "\t+ $$f" >&2; \
>  			echo ".SS $$ext (IPv4-specific)"; \
>  			cat "$$f" || exit $$?; \
>  		fi; \
> --=20
> 2.43.0
>=20
>=20

Just noticed that there should be newlines in the printf commands.  Will
resend.

J.

--ZWpzfLVIJMjiiMQ/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmV7FNQACgkQKYasCr3x
BA1WfhAAxNNFLuVJv7gvKt/WHPplVODcEWg9mPZHt5QcZPxBvmJwbzdE/U1ILyqR
wrBdZQOJhSltVQVkG5nlj5jWm2O5e8sNdE6REOiqlmeBw0trrt9UlTnajPcNJ6uz
veAotkOsQllIRAro4P6vRZQ2MWOkO8h49E5c6XefR4Ly1dCAGdqdtGbOuEJlt6DB
mlcTSezOjPBhDZkdPiqhEOemr+pxLQujiVlknJlFsK/KXkk5uRmT6fcR/qGr5D3W
c4O/OeH1xHCNR4KZxfTPSAjMhc9+aqLmL5HE9RVjeqj2AfztjGq2v2ERxOdYTn23
BPVF75WywsUiEoQF6woLPxEyXxkPfsgLxq8/udIR9kLf3XrT1/pqUzX+6eJEVUFZ
LsOw4wSvH12uPeAituoy2+8Ng/cF9vccwmJOxKKjDEcWJ5DJQy9DsyLhQTyN6bZQ
bn1dQfbiEcnLdgnI7jb7UmfvWq8kPukT3vKgfsXhbluMXrN4ljBPP5AkrxLALv4i
9XOHHoHdz/ehR2DTmbePiBG+vgy3LuvW6PSk5EoF1jPk8gwcrD/tAJ3IEO4tB7nE
s3eyB6tm521BXa3x2G7PcgOBaAu4XBrFcbLM9YSUyNiqXfDoZPNJWti85lusM1+/
nLwdzdqFKFcbjnzsbgSwKmdsGSKYl/7qBkn4THMIADoklrKXGhQ=
=ABdE
-----END PGP SIGNATURE-----

--ZWpzfLVIJMjiiMQ/--
