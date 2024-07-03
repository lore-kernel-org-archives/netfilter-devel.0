Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB7A181D0A
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Jul 2024 16:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720025023; cv=none; b=n3zN+f5GFfvVXnCQ4NUjzlnqTLBDlBLFKxXFVvdUPnidM01IX54BD+79PR+hTkL0jgs/QQuW0bH1Neo+FytLnvINYq1rpUAQZ27S5jTjCbCf2Y9uldPsVpAgNpbhMZu+pKDeC02ePR5c4Y+xt0W84Ey3n/nCGIk/j91DB9+jDB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720025023; c=relaxed/simple;
	bh=J36mKbAMdZwtfmY5BUIkvBcd4M0MIgiYZwuYf6q+5/E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=SakMn6lnQ/Kem1fpWhAl3lrd+u9oZcUgXEafPoDGQk1aC3Ymq0VlheL1xBp05ysi+OcLBnDKFmp6Itk+rjgNNDvqYh7ARz5LKAyJjAIRXqOacfejkJE0urFP5wEh+6KmrXjwJAor9DSEC9u/nUFZbnZaC1Hdde6dR5nakT7kYKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=AVWDNqxy; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="AVWDNqxy"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9xxTIhIt9UVEv2tYR1QqDwThdMLYOpEpxW3cq+07SAE=; b=AVWDNqxyd1jIaQNu7YT3vON5BO
	rVtg1fw/0Dp8m9AF3r0ac4QU7RSTct76ZPsc1zy44iYBaOmvUZmKynLEDGzepdnUR8YLkx4rttPr/
	4K3vtQ59SgB8MqoQndFCgyTMNTNr/UmDgCBXLfx9oF4FdtvpXG04E5H1v92hUJMa9ImUeVdRR1ckW
	bRozVrgpxN6EN8UUIBjTriJHXblzThx+8dKSJcsGOIF1OU+oX6uXa9PXrqYGiCvx22CETeBt7bApI
	1aqunBoqUfYGc9BoB30I7l9xZB/qWN1BhaNadWNvXddeLkq2errmzSSo3IPe5Km3wQFgHSy1GYeSw
	adjZX0OA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=azazel.net)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1sP2Qp-0039Zx-0z;
	Wed, 03 Jul 2024 17:02:07 +0100
Date: Wed, 3 Jul 2024 17:02:04 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>,
	Michael Biebl <biebl@debian.org>
Subject: iptables: reverting 34f085b16073 ("Revert "xshared: Print protocol
 numbers if --numeric was given"")
Message-ID: <20240703160204.GA2296970@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="onxUNV1G/UK8/byD"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--onxUNV1G/UK8/byD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi, Phil.

At the beginning of the year you committed 34f085b16073 ("Revert
"xshared: Print protocol numbers if --numeric was given""), which
reverts da8ecc62dd76 ("xshared: Print protocol numbers if --numeric was
given").

In response to a Debian bug-report:

    https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1067733

I applied the change to the iptables package and uploaded it.  However,
this caused test failures in the Debian CI pipeline for firewalld
because its test-suite has been updated to expect the new numeric
protocol output.  Michael Biebl, the firewalld Debian maintainer, (cc'ed
so he can correct me if I misquote him) raised a point which I think has
some merit.  It is now eighteen months since 1.8.9 was released.  One
imagines that the majority of iptables users, who presumably are not
building iptables directly from git, must, therefore, have adjusted to
the new output.  Is it, then, worth it to revert this change and force
them to undo that work after what may have been a couple of years by the
time 1.8.11 comes out?

What do you think?

J.

--onxUNV1G/UK8/byD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmaFde0ACgkQKYasCr3x
BA08PRAAhNARH1ZTzUaecmNiKkgC/PQP/JPHl+wcm0WBll7xO1QePTV84UQjDC5R
GmhDsN5qTes/ys8KttyEQ5v+BxO5YQtXNaQjastgnP6pyWJ+BhSfceQ8uBP5WRtx
Wn0gofFgsdq8MyAbxpdWYvRUv/jkw1lmffK1bfTdC1m2R5oZncMJx0A1SKawpowp
de2Z5V9gjbagmVn9tyG3Sxaw0Qv6vZnR7Tm6aWkdW5+5TZJUEuIBg9oszgwH3m8h
6wtjoHSnLGEC49Q4w4kV7+S5gLsVM0ZbMjhzvprGy4L8Ys0RdrgWn71q9SsHC63w
f8vT1BUiShoUP2FUfkfIIVufQpyeFry8OG7daFOkgrN2w1UKuUsFTTB06DoHb+cE
7WnJ9beR1Jgj87de2kX1pZb/j4fzvxdD2H8ruTjc1QFNdCQSe0b4HvOQctT2VG3L
e4njuFn9dCdZSLnd0Qk6HiratA9ivktdyPzDJuWADhOhlr0/E4VWEUr38XnqK+Fo
yqV7g1RBeGE1eYDuvZ6rbzXwUzOJIvduXrozt+w16tW3z9bl3qlaTckPTo96bNBM
Sy9X2DLwFpT952B+NLeI9TjK5+zi7+RWyhV2cLcoLaOTVPk7v93k2aGu7MifA26J
EFgZl9aAcPV7C3eW5HVBzte5z4ccqBogfh2egusnThVIPtc34Cc=
=B9CD
-----END PGP SIGNATURE-----

--onxUNV1G/UK8/byD--
