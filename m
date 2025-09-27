Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80F828695
	for <netfilter-devel@vger.kernel.org>; Sat, 27 Sep 2025 15:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758985870; cv=none; b=sryj84PCg/wFOq3Tkmy+CHaQlcixfP0Opwq1bjhUnETdmN9NC21zp5/el1b+3MB/TtG/2fuXdBS0OHWCC5SUoJvq9hzkq00XXRc+WMjyreSnpyl7x6tJr73q+GDxFLH9cudWSYSL+3b14IO3sqT/cLrreJFVislQ+TaBSK1Ka1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758985870; c=relaxed/simple;
	bh=M2BEHGk8UzVcnwY0UR9BIcWIBYbBCTHwV1R8Chv5RTk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=Tdx0HkbGoK8/+9s85PoG+NOvXrMUeFo3z50w0QoRW4HhoYwAgCwoy0nxSKWw+kMoLFVtAe+EXJS9N5ibmTGTKku/AMyGgr2L4Yk8BN+YOw/dmQHJgA5eNGMZN9fK+wVjWN6Xx+xA5xtX2R/0RkDMZSRvNjceqIKrfyIiHC+QqXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=ee0cssS9; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ee0cssS9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=Content-Type:MIME-Version:Message-ID:Subject:To:From:Date:
	Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=M2BEHGk8UzVcnwY0UR9BIcWIBYbBCTHwV1R8Chv5RTk=; b=ee0cssS9Q1lfQP8898POV0ZtRt
	tXqGnm67hQ97rza1aN6GXN+KpVMATSNzhLJ5x5Swy+IJhmSBzcEoer9vv60eG/Hc6j2zc6+hYpC42
	9Emg/XFMgy/QBtN1KGNV0Amip2MnabMlBk7I7KiX3gEOYUEZy2ZgPH/giYTAomQjDRCBaT+i1/L8h
	MfMjL9cGcqVhzAYxDtv/zWokoPRic6Qt1IC+jxyXk1N1qPmbbdXCrnTprP00wAWTaAmkxi5wiZ4A1
	mo55x9N+ejDmcpFgEDcHcdcHurSHzh634KpgXrHemf7fxtWrJbujzVhqW0cC40he896QhD+Sanm0N
	ubjxRtlw==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1v2WZb-00000002p1a-3WFz
	for netfilter-devel@vger.kernel.org;
	Sat, 27 Sep 2025 16:10:55 +0100
Date: Sat, 27 Sep 2025 16:10:54 +0100
From: Jeremy Sowden <jeremy@azazel.net>
To: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Bugzilla down
Message-ID: <20250927151054.GA2784745@celephais.dreamlands>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="SsAYcT/ORVPtQLX+"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--SsAYcT/ORVPtQLX+
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Getting connection refused from bugzilla.n.o.

J.

--SsAYcT/ORVPtQLX+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJo1/5zCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmdPfSzvValJPBFeyUTvChH3C16SYr7eB5Bjamx9FQmc
oRYhBGwdtFNj70A3vVbVFymGrAq98QQNAABMXA//fI46mBX5s7opCcYsEUlWE+vX
+awCTMAdW53dprCiXkbULrMqh12vfb1bJ09NwhRFRJ4HuEqlcRyqW5LjXccW4Qlr
7K/pGIVsodUn96Y4YGhuOk/xB2R7C+G2/rMHk6oYoawpM2Giz5ZE7yc3kganZVK6
FnLS/gmllFjRH6u2jgr7ecHBsukOL13GB1pmxI0zN9D5katYsTFU1RscDVtTp9Pw
fqJPoiyWNkF0k+Lej8X8oBymMYJy7sd0iyUyLtW47+q6HTEsRJSJioEht43OYSTo
rjjPzq22QFylx31+xAupdH0kF2onbQDUYGyv5chLB6NNVknO4i/GrBDYrZ4awgyZ
x6O50ZxEh4+qu4GlRNmu4fdvMKorQ6UqKRu5R1z1pejqA37bFK285wa+oz1qd7WQ
UiPt2MeAr/2dC5Wkd834FpYC8b9bphUtL67zDBSNqQhxJQFuJnXP0K4juSCXHKFv
2F9Ap0DmbEV1LV0pCGUfJDIBGY9wSRu18jTv5y3ELqNNEvM95aWxM+Hx5XoAHHml
PMVih/tH+dMP8BWaZKzpeTB8OFgP+8CW9eQw31VlIRr+iF7qfUHXBJERO3MaysFa
PhYhT6DxVwLT9cOCSV+ekiisLuF5e+nD0MJ0pFiobLOamGdZhDT5Yf82t6LVtpsE
xUfotn3pRxRw1ZzESCU=
=PxmT
-----END PGP SIGNATURE-----

--SsAYcT/ORVPtQLX+--
