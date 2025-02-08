Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B772E33DB
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 21:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739050497; cv=none; b=s8zWIU8W1nhUOw++f7U0WIYxN2cSlnitGYshAeWMbF89MBeZa5Cl+8thEABS0DAog4a7pzyaMQUzK4Ex3+djOno5jhieun7vW9CKSMgjmMJJvRLivMloUD69qMygh5hcDzXKF9fEal/fsV56/BM5ZEpE5Mk9aHxDOdl3izdHxNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739050497; c=relaxed/simple;
	bh=b8ZzU/+PHT5rQXCwudP63FwD6oKV9OZCLWxb01wrQP8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBIrSTTUaQUaLAmuF5KVJA+9i9R0YynTfgsvUsLi/DGT/us/FiNn898hAPkmbG+Og3+cOTYYviexy224NPAT1+18/hJbZpErIykUFJd6FvSAyofdmvpACSijJGaWPfc5gwEg5FH4a++wlasozBrChq3k60ytYsmne/tOvjm1vIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=blus137m; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="blus137m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VIBOw6ct7G2BanMF/50VydxhlkJ0wObq95frmrVCHcw=; b=blus137mli8g8uT7GePkvrldUP
	HTRLZ5v6nmUz6zNUEJRN3ouRZqR1KgM+zMCQMQ+kehrkmOVsCgLJtyFmlc3dkZnrBl6qhChDHWuQw
	5kqXx2BTV8fl88nFer5jLdjPOLc+5MhKrnFi9f6wOT84kpkeFPc1Da5p0FIeTkvkknG8DgyXdHhM+
	k9u7CwVoNQxRBHECQCXyHgFEy6+7QrxuZhNSPVZjwwCJWhE00lBNDat+eWU6yyhKYJUqbqbShEQfr
	se6rn16JHL7AcEtInS6L8hGIWLGf5Cdiy4+NfT7SfPFbB5alaxQX/EyUHKTI52113O80go6a5QDfN
	Nt7Htw2Q==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tgsTL-00D02r-0I;
	Sat, 08 Feb 2025 21:34:43 +0000
Date: Sat, 8 Feb 2025 21:34:41 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: corubba <corubba@gmx.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ulogd2 2/3] gprint: fix comma after ip addresses
Message-ID: <20250208213441.GC2199200@celephais.dreamlands>
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
 <2e047e50-e689-4fbb-ae58-bc522a758e40@gmx.de>
 <Z6fKoE-JOtvbKHvY@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5tgtWsCF3wUTnKRL"
Content-Disposition: inline
In-Reply-To: <Z6fKoE-JOtvbKHvY@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--5tgtWsCF3wUTnKRL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2025-02-08, at 22:20:32 +0100, Pablo Neira Ayuso wrote:
> On Sat, Feb 08, 2025 at 02:49:49PM +0100, corubba wrote:
> > Gone missing in f04bf679.
>=20
> ulogd2$ git show f04bf679
> fatal: ambiguous argument 'f04bf679': unknown revision or path not in the=
 working tree.
>=20
> ???

f04bf6794d11 ("gprint, oprint: use inet_ntop to format ip addresses").
It includes this change:

-                       ret =3D snprintf(buf+size, rem, "%u.%u.%u.%u,",
-                               NIPQUAD(key->u.value.ui32));
-                       if (ret < 0)
+                       ipv4addr.s_addr =3D key->u.value.ui32;
+                       if (!inet_ntop(AF_INET, &ipv4addr, buf + size, rem))
                                break;
+                       ret =3D strlen(buf + size);
+

The snprintf appends a comma after the IP address.

> > Signed-off-by: Corubba Smith <corubba@gmx.de>
> > ---
> >  output/ulogd_output_GPRINT.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >=20
> > diff --git a/output/ulogd_output_GPRINT.c b/output/ulogd_output_GPRINT.c
> > index 37829fa..d95ca9d 100644
> > --- a/output/ulogd_output_GPRINT.c
> > +++ b/output/ulogd_output_GPRINT.c
> > @@ -179,9 +179,15 @@ static int gprint_interp(struct ulogd_pluginstance=
 *upi)
> >  			if (!inet_ntop(family, addr, buf + size, rem))
> >  				break;
> >  			ret =3D strlen(buf + size);
> > +			rem -=3D ret;
> > +			size +=3D ret;
> >=20
> > +			ret =3D snprintf(buf+size, rem, ",");
> > +			if (ret < 0)
> > +				break;
> >  			rem -=3D ret;
> >  			size +=3D ret;
> > +
> >  			break;
> >  		}
> >  		default:
> > --
> > 2.48.1
> >=20
> >=20
>=20

J.

--5tgtWsCF3wUTnKRL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJnp83mCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmeq45rTIOa+zulpKyXg6Xb9XaCjkQHvTyGd8VbxhcOv
MxYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAwQBAAwS73BBJRIwBJarXuHLlwb8UG
PzZeDj1k367MCc58f3m5fipQNHp1noFd8QS0jcM6l5/b3dx9hnVOZ5vlVGoWSx7n
g+2u4u6izUL2fd+n7JLVS7MnRRZ+VeJ9soE/rZ6qCv+8MehdexjPvrgnTvXh1emv
EirfSHosZguT2OD4L+gl/RhXaGvcvLx+tFxFCz8y0t1eMdvT3mfYxBAdCv3el0aU
EjVUYdBbQN2ldg+GG4rDbrVzUElmuZaihLtRkJlKj0Dbmp9O7eaKo+DsYw1Em/w+
K+kRmB5kLFcEq9mrK0UG+BD9iAdKeVYiXeQrWE3WAm5y5HDkCujAPmpE6mnT7py5
0dydZDMFJALymX8RLsppLGKMfWdxVBsfGl1bDthn0zN9jYgpnLp7W5gc82SkYDHe
R7nwDeL0whVnV32QlbA+Y9jUCsoTg+AvB/2xSmWiBbrDliI5wH+NPvWSt8venlfv
+FzBwGl3ko0KbRhBWH/3wi4CgZ7b8v+gOen5I5oq7a1iE4opY7oIcQPxbWTD7LPB
A6BXT3V8CeYEvAyi9lWxyfd7GD9PaLK0M1tSORZ9soZuM5mfqB+dSJYY+XQBEkSI
/rkO0Yl3teUc3dMlMeWWb2OqoiWk0WSEwj8dJMXSXwChUVzvgTqs7OcYrzAGteQ3
jBjzdncbl9ad7d/6O0o=
=m5+s
-----END PGP SIGNATURE-----

--5tgtWsCF3wUTnKRL--
