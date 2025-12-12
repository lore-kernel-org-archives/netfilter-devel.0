Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09FBE26CE33
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Dec 2025 14:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765551489; cv=none; b=pe3PdfX9Wzqk8bUvB3bU0t/jnGMsYzCpEvFNff4cD4y2hm4+xoySKme59JKXUnXOi8FiMQKdMwQ9z7810dJ4wax0Vhz0nJRKL+cff8rUpDOBMzYaXRRoXtSJwNocUCE/gTxH8zYS6qXa+v4+I0oD0NLSFUNFf+cN07EpsuYZWWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765551489; c=relaxed/simple;
	bh=GYBH3XNVIUVK1W13mC/6iDHcrC7ddrwaKICtOVtTgWc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TOXhhDIFauhJ9Ti7Mx4wCx4gayNObZyP0g7kEz9dVVVKPjUdpbW8IImr9UqVsezoT1TK7i44LhS+WlqLdGzeAUl7ELD+8C1PRdw20G9sqk0KnbHGAjS82HQmyqPCJ7wkZTNiBkdsmaIE7Ag/KsTQTXl9ursdRWiyap/uU6CKna0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=Iy5cVVwT; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Iy5cVVwT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hBgZGq7uZM1A/KRVooly1JwN0sdu1PvdDxd3QpWHOV4=; b=Iy5cVVwT56Vx74mxTqA5+rdjzd
	3KrIQ+MnIqotCQlR+ccQ8dr9IewD1sBOpE/Jb2I7g9HMxfx1ok2so3TGFLcMT7SkTK50yBvJkv7GM
	OYD0eu4G4iuMfTb/jVYRw5kW78hSPojg6AT1GSu7p6uji9lDw4Ncj4vmANWlXAw2aj058NtESpxqK
	h6v7TPUwBqEUz/AsrT7OnWhj59tkeTZIgvXJKFUeKvY3hR7F8byrUM/7eYcQfjmcWUb8Gb7HSrksM
	L6CvO02T/k2wFJdTu6gsevxK0r6CtlEhvpGEs2gAcBN9pQmUUHJbfnbNZntHWn99z/YiAYDL963kX
	/4nWE+5A==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vU4ah-00000000dLl-2GuM
	for netfilter-devel@vger.kernel.org;
	Fri, 12 Dec 2025 14:57:55 +0000
Date: Fri, 12 Dec 2025 14:57:54 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: New conntrack-tools release?
Message-ID: <20251212145754.GA2993022@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Qq7OGspHSiTmdvi/"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--Qq7OGspHSiTmdvi/
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

It's been a couple of years since conntrack-tools 1.4.8 and there have
been twenty-odd commits since.  Time for 1.4.9?

J.

--Qq7OGspHSiTmdvi/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpPC1gCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmeAz9AMJhY3/4T/pPNWbESu+YN2y4+BPH6JicUsqV72
WhYhBGwdtFNj70A3vVbVFymGrAq98QQNAACIWw//aF6Q8qcJPucvu7fRS17CiXCN
s/VpWPR0ZNzZzzZG14+UcF9zLd3X6lsN95b4FHDZegonf0IjYCqte+kmG3RpE9D8
yK2iRv/38cfu4S83W6LxYJyawGXUaK+q7KUtILYva4i1dYnlm0thhPdt4L0zL9GI
MTm4SuqJ/Bekg07MronbxCvljsDqp5yOomSBr08xLflV53mKSJg7Iz+Uag8h88YQ
6PBedBrp93k127ygfFiISC5FmXOuT+oBbzmzvmeLeEg0pwhjJxfqd1qcp3+QxGH3
DmY1ZmuzqpSmnYNv+uwqhF2T42d+/SAmjoIrKVTE3YjdoABCpGNlUe8cv/kgk1qo
Vbr1vbKowEpJrW2h0PuWRsKIAnsYV/Kz5FYEFBUV6S5uqov35b7jnP/HyvQZu53j
FNoRUGCaIVKbmm/nLpcu1S1G4Fk8b5UxRTNE9HuCzcy3KVDQwf/jUCQWuLBbBB5i
oZmt4JEvPkqqvdr4ZydINEncSrHSQipvNzwiiWvCIUSRRB3lBhYH8ej+bEUPPmxa
8tXGHb9PIqMXigyVF0sBaffpopClftY3ofNkFph8HqPgU6uMJj9ycQaQ3fnVunIK
rVeAJMg/EjAQSP1ZeLWX+84z+h5e4sDkg2mwpIxDv0trQZLbxLluaQ93sTyZLmvm
R2b3eswX/QFMcy24xnE=
=9hOJ
-----END PGP SIGNATURE-----

--Qq7OGspHSiTmdvi/--
