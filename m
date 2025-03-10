Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7391218FDAB
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 11:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741607089; cv=none; b=Mxn+aq9qtbT/iUCjmsdyElLjgk7CB/ixEFQqoXe+cbySFKqnPFXcXtfRm1j81+ZfQqPC/Q7UiLXgoGhgq4CvcqBRTCB9Gz69etwH17+uBphu/McwxzpECLncTqhKZbFVHuwPFCN04QD04p0y3lkzAUc85cclqDyb5dhfGNIHsg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741607089; c=relaxed/simple;
	bh=dLa6J+wKY3GtV3NqM/hAMtlbh7vDDcpwMIsoedltdcM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HxXKiQHklvUQydyeu/39q9voQoiWcZJUWD2hcBZ4K8Ip8EPOTBtF5qPBQlugxLPOAvPdkkeVKo4KBOOy+urhT60Cn61nQZn4ORwp5IpDiLkTCiRsmIVNUoloNd0QhavgX3A6E0IB2bNust/MDlRIBMN0A1ZBm/ANMMto1Bt3xfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=LNtNYjAD; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="LNtNYjAD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=RCprU64P0Ia6QOMGfJ7nuIYxr1qzn69vLtszVFU9ErQ=; b=LNtNYjADRSKwGr/6iW2VcP3nIm
	EEVGS6iMErTb6LoAggMIKziOy6uf2V1o7p3FAKdNpjBlq8ip6a4xPfiYQIWInQ/kJ3Abusyl3nF3c
	vw4+NRqE0xBz06QeWwgOPn0d5QczGuK3FpaCNCJc6ac5km4hRqzvpjRjQnn/DRd/YLpC9gEuyPUlX
	dh8+EnAgSucj6KlzsCGc5In7F2igCtbGsoc+oA6yLM38vQW7AIyMKtbLyers82Hsd1fjegwadbSU4
	wJGn2J4wndoVH4TVW71s8TLpGBEMbOFRCp+bkOk4Kjb9fCjGZeTzzzodS+k3rKo196HcCbR6NpKjj
	xPn6Sb7g==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <jeremy@azazel.net>)
	id 1trbYo-00H2DB-19;
	Mon, 10 Mar 2025 11:44:42 +0000
Date: Mon, 10 Mar 2025 11:44:41 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Jan Engelhardt <ej@inai.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH xtables-addons 0/2] A couple of build fixes
Message-ID: <20250310114441.GB1263845@celephais.dreamlands>
References: <20250309164131.1890225-1-jeremy@azazel.net>
 <s4922o5r-568s-ss65-14n2-7r9o60957s45@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="QuhhkWaU0Ndtxlbg"
Content-Disposition: inline
In-Reply-To: <s4922o5r-568s-ss65-14n2-7r9o60957s45@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--QuhhkWaU0Ndtxlbg
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2025-03-09, at 18:09:40 +0100, Jan Engelhardt wrote:
> On Sunday 2025-03-09 17:41, Jeremy Sowden wrote:
> > The first of these fixes the building of libxt_ACCOUNT.so and
> > libxt_pknock.so.  I sent this once before, at the beginning of
> > December
>
> Indeed you did, and I wanted to investigate why automake would not
> accept {} in that spot, but I guess I got distracted.
>
> Applied now.

Thanks!

J.

--QuhhkWaU0Ndtxlbg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJnztCbCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmeUKy4zgRGzxGCMkI8Ed5Rc1BjTEJgU9GgSsYGOBruF
FhYhBGwdtFNj70A3vVbVFymGrAq98QQNAACQxA/7B9DOlgT5P49JxNBV99ctkOTr
70Z9D9qU8G4E0ADeBysNQFQBU4MS81HIHwx//NtJrBlZdxIjPypmBEwWVK18fGCf
uD7o22PSWjRVCEfI/0YgcmEbs0mpUHu435UPzmh60DfevSzG8Gkp3/4KkXoW8x7X
UfQH2NRWsKGd6RDErsQZj45H/2LRZsT6NvZJ/dBpRWDYtYypGuvdt/5lFraZ/lai
FlDYUvWD9gDXevfUoS7xanR1bdKh6TfT6tQhfuaNycIHprpir+5wbYtjWoSAp8e1
0mbgGjPigDES63j+Q+JIVpMXgVLSlAYfzjZYFFFw3jQo7FDSpNuu0Tuh2vzLBqUu
nQSS++ZxBnP8+9ZjWEIRq9s+AK2XbJjpcqgQl2Y0As2ubqR3oe5df4j7AAYfkzc1
vuU/0vhG/DpjiTazSwm6NIWW/XL+0oEe/cfFyGQ1fs4FdkOmYPiEOojgzqmK1ZS5
KlPDaMyHIZ79eMIc/NgUkGXEy5wtqMsgXqxjcEXIayC4Xa4tErWd82ib4MH9RIGR
fpe1GHZI2lDAkolCy+S++o1f9MTJZ45fAjUiS7zpbm/lEDwjLOhIEioJ5CMWZeXE
BFTT4r2zKhL57ITtJsJ1gFipHmrb7pM062Ld5/KvsWJya2IuJsTicxxGVK7tq9lu
5fQPVJl69WnZhNnoR+w=
=LK+R
-----END PGP SIGNATURE-----

--QuhhkWaU0Ndtxlbg--
