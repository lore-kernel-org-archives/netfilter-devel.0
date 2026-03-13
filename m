Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C1A15530C
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 07:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773388683; cv=none; b=seNVvq6ArXVW8oMM7SHxQAZllEMe+6P8JPzSM+zOctuQptmxcKrGdkyDFdV7HaHTxoGnI6p27WsylAgH+TMhySRsMDN8RvcPxGdJrb6P2D2CQm9FS4JIkC+axugsR4o3bYKCd+pO7oPMSozAqOsiEHevjOLwTeBpaVOTLe7bV0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773388683; c=relaxed/simple;
	bh=X49tt/XGRCyecjCAWPEdeu/GHb2A4ZuvWeTOV31NJxk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dAz5E5Z7nfK4CAB4g7x1jNZk4dJeBT5XnBc3Umt5QrM3L06dBpDO4Vnq32hcba3ESFEN/JeLTqWZpSU4CKGb3VQusZpXJYCSHNSpamhkfEl79X/uiLRyiHm6oXb7WMP/reG8sldvPjCeup5rYvRjZxwlxony5/2Iez1g/7/QDj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=Q1kKDzKH; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="Q1kKDzKH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MAmADBW38BkzIhvKFR/3yFdVtj77KyGLg+sF76+iozE=; b=Q1kKDzKHQ+giMNZUEZ/wuSCNiz
	yNwgNJ/djShwoQ20YLgJBROlUm25ROaHMMaFAApDr6I1CsNSLVmYPPKT4wW081ELV+0Vj3VtRUfMi
	fQsvvVjjQjjT7S4YmMmjHgpJsfs1G+tiC6TZN4/STyWlpgImlzyel/g7Mszvi+wrCaLf74YKyjCwe
	6yM5PPQEjWDYQyCaHFQObDaDBfDiMtzCy7NR7Lav48bwl/+G+cXNG3G0vqk6V4YVA9AzBum36inhd
	VDBb/OXUhfGTBo4FL1PanHVqIJr+f0P1qI7ClukcDs+RvIj+ZXF+Z2Q5cnw5FyKYCWho8ArxjjHi6
	UebeL2TA==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1w0xPE-0000000FkzK-0iLu;
	Fri, 13 Mar 2026 07:58:00 +0000
Date: Fri, 13 Mar 2026 07:57:57 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: use `os.unshare` Python function
Message-ID: <20260313075757.GB6145@celephais.dreamlands>
References: <20260305175358.806280-1-jeremy@azazel.net>
 <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
 <20260306183553.GA5468@celephais.dreamlands>
 <abCki9aBa8wVBvQi@orbyte.nwl.cc>
 <abM6vF13kX78q2Rh@strlen.de>
 <abM8Glu2VHmYQdaM@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="izRf0yNOHRxhv37c"
Content-Disposition: inline
In-Reply-To: <abM8Glu2VHmYQdaM@chamomile>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--izRf0yNOHRxhv37c
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2026-03-12, at 23:20:10 +0100, Pablo Neira Ayuso wrote:
> On Thu, Mar 12, 2026 at 11:14:20PM +0100, Florian Westphal wrote:
> > Phil Sutter <phil@nwl.cc> wrote:
> > > > which suggests it's time-zone related.  Didn't see anything about that
> > > > in the doc's.  Will take a closer look.  Apologies.
> > >
> > > Yes, it's odd. Neither unshare module nor 'unshare -n' behave like this,
> > > even though os.unshare is described as doing the same as unshare command
> > > does. It also doesn't mangle os.environ['TZ'] value, no idea why it
> > > messes with this.
> >
> > Is there anyone working on a fix?
> >
> > This breaks my CI pipeline (i.e. I disabled meta.t tests).
>
> I suggest to revert by now, as it seems os.unshare is not equivalent
> to 'unshare -n'.

Agreed.

J.


--izRf0yNOHRxhv37c
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJps8OECRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmfKQKzxUg6+rUQHqPBhccRTTWm+LSnctkC2UGW37LGn
7BYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAfvQ//T8YdsiGZiohmOJ2wrkQkJDRS
IQzatztozANrLGz4uCLWDtsGK6KSm2LwkmUvG4IMoMr1jbGUI2iVXbavfoMCKV3j
qP38eLZKMec0g6yiYjXBTf7ZB0dKBt5Xs9R2gnWa1VnPTDvC4UnHPRSJOMuL3R2J
BQT5NULm4BrgrWVRXAIfW4QE4nS0blFB6ywEzd8tXWg/G4+eGemSY7qLmfqrxwek
znwkSZ8BgmKW7KvMJA4Bigzq5uhddBl/lcWAzWMp2M+kQjKQ/KbsfyIlWpboxDrJ
oW5FwqGkUGLkbsd2JAfnrxi/C8n+S1jHmJzNgxPCCM8KKhZzz8Yi4mkcOq1sirwr
ccoyj4V0qFNEz39ezHJO9vPcWsXIxbgpGvq2655iVEfZVYCQVA4dCnimobAlTDZb
pknbCm17E30PpdlZLONWk6BXm5R5G00k9OzL/WXRjhrET449RwFiW66EcrjoJd+9
kzFYu/KBbQQIf7pgm5/mm3TY7qMWmbCvk1WBvaDQbn1J2emUFabfG6yV/0uqVvgi
YT9wgiMTstdfTpcs9dAmH/jv4mETnZoe/qgcUbiLKbwUxA+OxulN53tQcRCfuIyd
Q9bFjRRskDtdTumDpeTzSkN3u+RiH3Y6RvNbI4I+NJi1wIEkweMEICV7mC0tk0QS
6AhIYfdxgkUdFyKuC1o=
=JxR4
-----END PGP SIGNATURE-----

--izRf0yNOHRxhv37c--
