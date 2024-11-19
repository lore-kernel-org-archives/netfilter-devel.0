Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D2E188704
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 22:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732056376; cv=none; b=rJGXeRExAIuvSJeoG6X8tgNXsroJqNxOSv32yzTJPym93hhZlH90SJA9cVve9YJGkwbMMvat6ndp5mMbQrcigQwki5jMAqOoIEuGax4mlKbrDT1WvMi+ZOTKy/zKKRFX9dgPkKO+y/uafh9ef7DHsNnKpwlQaqzQVrN69vVWpuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732056376; c=relaxed/simple;
	bh=tNar5LYQtromdAJvD1b1VSfXf+hXgFpUtV2TLMU76+k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=pimBODRDaYpDJnj/5Ul6y3CI6GWjHXQ1QQBUHleCVaqiLJsjUxH0jB4cHGotYM77CS4JcHYa6Fb52wIdSroYqi4a3ff8oJo6HHZhJG3VG7gJyiWYOYFVeaAVBkorl43rReKeNEgzZ5Q5bBTvn1Jm+vzHzaMAHBVGOBazhS7FPSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=cOtt1XbG; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="cOtt1XbG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=W2GhLSLYzL1sJbiDeq+C5M4IuxumwqrrbmhqGYYdQ4Y=; b=cOtt1XbG128ew/3+0PE/28ocQT
	7WLyRGLffGaJWfTfeNCruro+3LHFxNpkQS0/DvSXUlep9shM/cHBU9eX5krIZimnQcoBrXxUp8bBN
	wwKokrVx7L7AuN0QdNTHVx2ptBAwrDBo/UYSCjyQW46tg/JMsAQQxSL0loJswNHtuEl9rR6Y+nvts
	x3ruqGOScVSu42Z9k69eLGhVO+q5WzLZEMOrozWwGGSqUa3aUSoIxQbcPkXoqQhQdto00Tbt5lZSt
	CMSbWhsr3V0OO6J5SexORap9qxvA4SgWOcf6fMHLcXAS2O8XibH1o8r3IOASeq5gYfXU1nZNGiSoc
	wpIsg5yw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tDWz4-009wcy-0H
	for netfilter-devel@vger.kernel.org;
	Tue, 19 Nov 2024 22:46:10 +0000
Date: Tue, 19 Nov 2024 22:46:08 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: iptables & nftables secmark unit-tests
Message-ID: <20241119224608.GD3017153@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+1ZUuNAvw12uT9Rs"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--+1ZUuNAvw12uT9Rs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When running the test-suites for iptables and nftables, the secmark
tests usually fail 'cause I don't have selinux installed and configured,
and I ignore them.  However, I want to get the test-suites working with
Debian's CI, so any pointers for how I need to set up selinux would be
gratefully received.

J.

--+1ZUuNAvw12uT9Rs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmc9FTAACgkQKYasCr3x
BA2a0Q//VS6RyI1x5yv6t+9TabP7Ui6nj4F+SoQX0w6qHDAFhxyp2cCED+0j1e2A
iIeAYwLilFzzNo8vKCg5AcHDguHvw0sXk9RkGIYxbnd1AHBvvNUi2K6V1kphXrAN
c19YTEv3IV5PlcY6kWUySFWGMc4GK2UEcEOGt1Ct1vh/JDQBqVXh3sLrHEOdWRLU
zTJd5zn2vk2s5LEzehAlGFykPOXeoQkDZnkvUk4gQT1lMMj4DGt9m+uFh1J1GgQc
6TF4fa6FpGUDMoDddu+wCeFZbsu3mDdo52kmg6SdCirP9bFYIZFek5hJ1fyri6kH
hCgQQKqqLgXUMDXUVl/as9HyvCeKbVbTXNTwotOdX4clEk7FcOWAbofqwCKv+qtD
1We5z4OPQlt6znFT3fXYI9AvPmx2ST9+o4nTN4SrWf37/xEiIg6OK7eSxjHH4o3V
g7FgqEwo5y+r/97cPxNZFLQFCVl7wF7ASggNZJzLtrbMEW/eMTdFDAPqBXpU75B7
GCgTgktFoj9a/v+YSIOspVF9czo0hE2e1q27Q18w/z+wH5ajp4uMuIpGjNL8ylAe
IanvTGkFeckHdqsMECj5UNK0uHmiTpO5qDohSHn9qs12C9p9F+MEk4T5QUewjXtk
C6MgHJ0a3VvHuwKozBDLb3cYECz7+ERZF7wsuIxnUnpZSr1hKiI=
=d5Kw
-----END PGP SIGNATURE-----

--+1ZUuNAvw12uT9Rs--
