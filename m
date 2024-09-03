Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643801A4E8D
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 02:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725329928; cv=none; b=WPoxBwtmycJIeIIKAktWVZExx7Ngc/W8pmzRK/TQhBuFiRtAJ8GInRnDRbAfVpohLe7CkMtE2j4PC8h8klt1l2zOCfcEGMbPB5xMXLJAkCMxAmSkriioEOM0SmYq8FY3LDBf6f07sxr4vHBPh8CvNAbjJ+eYHpKWUG4m+gdsbgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725329928; c=relaxed/simple;
	bh=aoNGh791aMg0PIbrAI/k9psjsybJxaH48Ezm9agiSa8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=u+NA4cPq2QTVZ6Vg7kfdbQlo46idcCb5H1t/rlM2PeT8XvFv0L/MO//xAcyv/Ag3HzrnaBZm2y9A4rq7EFNK5ep1jtfjxPfMYoKH4nX1y/CLveg2hKby59hckNKyjvFO7nr9+qh6S//y6mAQsYtbFnwgIZNG4Lu6nLcWi23T50g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=G7Iw4UJw; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="G7Iw4UJw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202405; t=1725329781;
	bh=aoNGh791aMg0PIbrAI/k9psjsybJxaH48Ezm9agiSa8=;
	h=Date:From:To:Subject:From;
	b=G7Iw4UJwV8m6C8qzgCsHd8aI27LWf65tluO6U0rTSN8b+GrlqIrTXivPlTRdvNC+Z
	 xRQ/xyGITUe3QqN14qCmBUry7Asa6AJruiV64fYBChNZZRce+i3ORdZgW7FJLmDSts
	 xbXNeXJqz3gBdmyUxGq61Gp8bNzh+wv7/bHLgbQSk9Wl5Uty/G08tta63UFAyo6ylo
	 94O0dHKT4Auy4UsRaZuGEQSjnVw2yV7hgzvofCwZl2K1EGDug3jEjGtuDaAshmKtkH
	 1VXzMkphxdtH2+1zqDfmDL8rnpW6kpUMUWBDKTWZZ5VubjuETwD5E0lV2jS34dBk0m
	 688V8SoevZeIw==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 4AC838B0
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2024 04:16:21 +0200 (CEST)
Date: Tue, 3 Sep 2024 04:16:21 +0200
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="2bsltv6reoecljws"
Content-Disposition: inline
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--2bsltv6reoecljws
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

The manual says
   COMMANDS
       These options specify the particular operation to perform.
       Only one of them can be specified at any given time.

       -L --dump
              List connection tracking or expectation table

So, naturally, "conntrack -Lo extended" should work,
but it doesn't, it's equivalent to "conntrack -L",
and you need "conntrack -L -o extended".
This violates user expectations (borne of the Utility Syntax Guidelines)
and contradicts the manual.

optarg is unused, anyway. Unclear why any of these were :: at all?

Signed-off-by: Ahelenia Ziemia=C5=84ska <nabijaczleweli@nabijaczleweli.xyz>
---
 src/conntrack.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 0d71352..9fa4986 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -337,7 +337,7 @@ static struct option original_opts[] =3D {
 	{0, 0, 0, 0}
 };
=20
-static const char *getopt_str =3D ":L::I::U::D::G::E::F::A::hVs:d:r:q:"
+static const char *getopt_str =3D ":LIUDGEFAhVs:d:r:q:"
 				"p:t:u:e:a:z[:]:{:}:m:i:f:o:n::"
 				"g::c:b:C::Sj::w:l:<:>::(:):";
=20
--=20
2.39.2

--2bsltv6reoecljws
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmbWcXQACgkQvP0LAY0m
WPHOTRAArJG61c/cYNL86GPHjvEzH6RaTNYEK2A0qzBm82kB/q3PNdOEm1FgrBiJ
+B2Vd6hN2W7vNLBHcICn+u9uYhJNDlRcM/melT8WjfBlGE3yUe8lfILgJS7X8MBU
fj+I7hfymC/oznU0RjsF5Wl8Ti3151IQ1KBlQE8UPAty0ZvINa/Qg0VJx9zYMZAP
RpCDAGCAg7ydAJiZudYYBuD6X7Q0lSjYJaNeqSEpyryPNLp8tc8ywesb4tgMTxVI
ejFmqK3y7ZCQXGONRDK47NvVxQfiJmTCxfZP6vhglxEotOhGio3YPLOl1ScrD2YK
/M6mX0tntrn64sZgOMs1Lqm49mOiPm+W54GU+7MVjs2gAOyXL2xp22Rq0tbALFUe
6BBeoxqUN+tDWRH46ywB6G88e8DuRafKiMPn2GwYs3Qe74Mer8zmZskwSpef00q5
qWc1SGOi0SH/U8YzYCzqVVPDxuOQEFxcbHt5dz0K3mZiS+WMEjMAPFVgSWpGIwgt
y3q2ValigQ/haYdvXyMKuobwYM8EZcKpGrJP3lS1ppnbahsqxAaADeaRcpnWNem0
1c/5dkwUW7iRdkOywGVVDBbQTEKwtWoDDwexW1Y1i1mp7c/aZdymTBPbQ0Z8BaXd
XZgM8Y2RbdUWSlgjidk1lZ2ff9wJbND6fD2ajLj3Fobadrn/1l4=
=G8MS
-----END PGP SIGNATURE-----

--2bsltv6reoecljws--
