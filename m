Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="En7uWEF9"
Received: from azazel.net (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34525120
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Dec 2023 07:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=2aphrgqCWqdSdPQeAh9LPUF6tjHc/lVZufQtI/PRPxM=; b=En7uWEF95wMfjjxPVwsuSVk3u3
	BkWqXSc43orYd3n6jImf559vDtAaT4/GYP3hRr4RC7MAK+g7du5jLM/KSXOvDhhqUPnzHmNHQ4Ttr
	27FMTbqlag/cdNBEz/6uuz7KuuBYMLoXpIWI1Csh78YKRhpP+CGqEVvc2qaRe2bbBw5Xvvg6USV/r
	+IrkS18ZkXO5K89uMf1P2Vy0WYG9as+nV65MM2Ib7Mn9Xgfut2kt5ZTHGZuTVaTB2BhHag7QwuMtV
	GcNh6tILvxQ4a8rphBJEAk2ecDU9CGXSWpnGJGALsaGW/kNH5+sjHtVBZm6wPxBmIAlQvAj4xSMbf
	R/5mmKFQ==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1rDnWk-00373Q-2W;
	Thu, 14 Dec 2023 15:21:30 +0000
Date: Thu, 14 Dec 2023 15:21:29 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables 7/7] build: suppress man-page listing in silent
 rules
Message-ID: <20231214152129.GM1120209@celephais.dreamlands>
References: <20231214125927.925993-1-jeremy@azazel.net>
 <20231214125927.925993-8-jeremy@azazel.net>
 <20oqpp22-0p61-rs3r-65rp-r8s595on98o2@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mvh3u00dN5EwTefT"
Content-Disposition: inline
In-Reply-To: <20oqpp22-0p61-rs3r-65rp-r8s595on98o2@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--mvh3u00dN5EwTefT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-12-14, at 15:32:26 +0100, Jan Engelhardt wrote:
> On Thursday 2023-12-14 13:59, Jeremy Sowden wrote:
> >Add an `AM_V_PRINTF` variable to control whether `printf` is called.
> >
> >Normally `AM_V_*` variables work by prepending
> >
> >  @echo blah;
> >
> >to a whole rule to replace the usual output with something briefer.
> >Since, in this case, the aim is to suppress `printf` commands _within_ a
> >rule, `AM_V_PRINTF` works be prepending `:` to the `printf` command.
>=20
> >@@ -228,19 +232,19 @@ man_run    =3D \
> > 	for ext in $(sort ${1}); do \
> > 		f=3D"${srcdir}/libxt_$$ext.man"; \
> > 		if [ -f "$$f" ]; then \
> >-			printf "\t+ $$f" >&2; \
> >+			${AM_V_PRINTF} printf "\t+ $$f" >&2; \
>=20
> I believe I was the author of this "for" block.

Indeed you were.

> The intent of V=3D0 is to hide long build commands and show only the
> output name. That works for most people most of the time. It did not
> for me in this very build step. ${1}, i.e. the sections, are
> dependent on configure options like --disable-ipv4/--disable-ipv6, so
> I felt it made sense not only to print the output name (as V=3D0 does)
> but also the source names=E2=80=94but still not the verbose build command.
>=20
> With that original goal in mind, silencing echo/printf inside this
> recipe, for the usecase of V=3D0, is incorrect.

Ah, I see.  Let's leave it as it is then.

J.

--mvh3u00dN5EwTefT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmV7HXkACgkQKYasCr3x
BA3+0xAAii4+0fNLF1Ti8I6KZFeLAd3FNTRwrcv4lV7lvSGnD1moT0d+Bq6S5uUA
PKQagSNVdeGLvmogT5/jp/HMrMiFMa7mDcDG0M9KzHOs6T5G8jwC8F55ts5Dm5d/
7zSWXli/QwGaWGfV5Af7PrI1lpX+5vLgWU87J3zX/KPCy5lGGfrXDYiroX5NoA9b
WTZcVc/X+XjXfnz9MNI3CThFePi2jBKtIJXQ6mqcDefDdE6I3Z9WbLPpOPYcPHrZ
EVLRzFEZSvvg3OTsXUMy2OyGf30cCqYbbf3m8NJRN6My6C+aJrhgNX9x90wr0uKp
iVftQu40iR8dTSIoYVh4bL+ctxBJIGdWKN8gbe9L2NFoL3btIgLfCdVo9ywZV+Dy
uyZIM1QmmtTuzSXAFPwdTyiYT0eEESxgvEPZzq7SPJO3FTaOfzFyyS4eoM3EdPND
koo/EuLPYxMHvt8T9MGxQ6MWECy7ofV6Xe5ZYv+MPOW4/wy3j4JbVhibhxkaLr6v
IiOqpphqxGbY5/BD2ZI/2WNEUVAx1w6go75ZE+zVMxbgXH1DTzxMzk9K4ZQC6JOT
TXlz8+XLCTIzJKtzx2Fj+8tHrYZ5Vn04DT8OyNYjfUJVUDrqrhBDhJv0PfkzZzlT
yfHO16vSJ5GNb03tNXT7VJDl9Rh2WuEFTtS1YtZM/Gfh05ESPTQ=
=jPlq
-----END PGP SIGNATURE-----

--mvh3u00dN5EwTefT--
