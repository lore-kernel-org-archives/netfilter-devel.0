Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6521C1AD9
	for <netfilter-devel@vger.kernel.org>; Thu, 21 Nov 2024 10:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732185247; cv=none; b=b7+RyP3aJNNWsdPMVBiNj/8FEatZ4+MlXuiyCuqvM82PdoVGhoTADbGi54PDTrDSIh8pJ8PV4MeT+JbH2f/wJpMpzEgTOh9KXXucST7jpgHGtOoOEp6dCuzZdUltvh/O3FbE7v4j7IPiqyEp4Za+tJi9lmp4ANvYhpHOk5gNM04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732185247; c=relaxed/simple;
	bh=/jf6ZSE1rYhtZPxx2ifU/WVK4f0NzuTilT/pUI9JBes=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ca9CfvnzoeNu8cE4Sul61pt8//b8vQIEogNvEwBofV+EcQKjrdN8z/sU+EelaEeyMPPZs/2cafltT/odObNTNK0nmJYz1beAc4FGOnovLNTe+6yb6qPKHs2ZRmjUixSsXehzGS3kA70vzpNoM0zyslx1jgEMmnzELCkWM5guM4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=nwU2q31i; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="nwU2q31i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5QppQKUmRws2m4uzKzpSraKIG5c8SuhC4REK0oAzrrg=; b=nwU2q31id2mUJk6bJEJRMoqWLx
	h818L5qwcV2Y0w056AmKF0zUlSwsmhYbDek4j5NVg2II75oXMbhU0ygkXMy6PLBnQMubptobtrZ/W
	eMGQXjQJ+tG+nA+CKMwWEtWbppS7XxYHTH1n1AafBZm1f2yA+bq2bteAPxvFgQMN+uIC+U58ChmZd
	6d0qqm+Fvh8RqD4j8Vuc7zorDlw/gw4MhBMqOZRUOsj9RC1S2KtTQaTAiz5s3sSK7V92m5GHvmw3i
	g8982lIVtBFhD2u2xyt8fOS1aj2ZSf7deNbgMEsryy5VcS1bFlCprBZhAn43q8g+X6RwyZu8uvCzY
	XJweUSsA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1tE4VX-00Byrg-0U;
	Thu, 21 Nov 2024 10:33:55 +0000
Date: Thu, 21 Nov 2024 10:33:53 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: iptables & nftables secmark unit-tests
Message-ID: <20241121103353.GE3017153@celephais.dreamlands>
References: <20241119224608.GD3017153@celephais.dreamlands>
 <Zz3WJSUIW0ds-5W9@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ynfVOGmqyx+ifqyd"
Content-Disposition: inline
In-Reply-To: <Zz3WJSUIW0ds-5W9@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--ynfVOGmqyx+ifqyd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2024-11-20, at 13:29:25 +0100, Phil Sutter wrote:
> On Tue, Nov 19, 2024 at 10:46:08PM +0000, Jeremy Sowden wrote:
> > When running the test-suites for iptables and nftables, the secmark
> > tests usually fail 'cause I don't have selinux installed and configured,
> > and I ignore them.  However, I want to get the test-suites working with
> > Debian's CI, so any pointers for how I need to set up selinux would be
> > gratefully received.
>=20
> That's odd, my VM for testing doesn't run selinux and the testsuites
> still pass. The only thing I see is selinux support in the kernel
> config:
>=20
> CONFIG_SECURITY_SELINUX=3Dy
> CONFIG_SECURITY_SELINUX_DEVELOP=3Dy
> CONFIG_SECURITY_SELINUX_AVC_STATS=3Dy
> CONFIG_SECURITY_SELINUX_SIDTAB_HASH_BITS=3D9
> CONFIG_SECURITY_SELINUX_SID2STR_CACHE_SIZE=3D256
> CONFIG_DEFAULT_SECURITY_SELINUX=3Dy
> CONFIG_LSM=3D"yama,loadpin,safesetid,integrity,selinux,smack,tomoyo,appar=
mor"
>=20
> SELinux-ignorant as I am, I wasn't able to find a place which defines
> selinux contexts/policies, no idea how the kernel validates the
> 'system_u:object_r:firewalld_exec_t:s0' used for iptables SECMARK
> testing for instance. All I can tell is that we had to change this for
> testing on RHEL.

Thanks, Phil.  I'll keeping plugging away.  Probably about time I learnt
more about SELinux than just how to turn it off. :)

J.

--ynfVOGmqyx+ifqyd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmc/DH4ACgkQKYasCr3x
BA1SvRAAmOKur95ltLoOysB1aQ4H5+T5jW5KAdlWNGnDDsDdPAdMr/73cYw1Uw6Y
5yhCRTuA4xkpXAAXpA9zdoYt6MWRlyr8j55z7Rsfm5Sgx5g/BJE250gWFxAhjH1W
01hi26zjiT/PvJ90TZc0HrVDiVmO+3TyvBDqrb/L8ltLW9EC5OQ1lfCJaklnrjQq
dDIRzhU796UsSAlVe/uU6xBmtvZ7EJeC5BiL1iptqP7R/nqSKLRRzd2n2IK7W3cp
+D5fPR2ZZxWba4DUJ/vFf1gMFD2h3v2MHaSu/G2HiZWokCc5nNJjvJ86zp1GVCuQ
m+9X1XfjNRsUKRAs8tCoZPzTkshHfQ1mt0IxiQdQuzwJ5NwOWlxOjJTm82CjwHU/
W+Wjcs/bcdqcbVfHpxPlXuDSWwjdIPjaR/bbOjOo7FLXNNrAvNALxgHVJZXMvzXO
3UhqJuHnatqYmdY1F34octor9jWcNF3ktzo63RFUKLSCHUKEZ2i/aKpBfpabSvrw
qpg9APCQwFZWKlyL1km9sVYok6ewj7U7HP+c9yVCcPwRSe8Clj/tNKeDcYzuLdwT
mVBq7XVqRzHhkXPwgrDRpr1A5HSVrSmzatGKNCzbP2y01MgNRVg6aG8yIe4CE3Dd
J51XT+sO30Uy67aAcy4b+LRPagmZE/nhWl8mWKN9sjDHlNBJUeo=
=CsnI
-----END PGP SIGNATURE-----

--ynfVOGmqyx+ifqyd--
