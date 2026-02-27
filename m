Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B64325726;
	Fri, 27 Feb 2026 12:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=72.84.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772194994; cv=fail; b=nWEn2Acy3k2XTbkvNh4ONmILIkl0GDIM0Usr8NyXOLwte/KylPH2nasgtzy5QnZjRYMejrn/tvOh+Z3F1CLsYqolsxIr7DEiM3Hg030WYIb1ZKWfgSY/NRzQtRdF69ay/hiXzVCGfc1AbMzkwrA4saQK2NRdCqdQ/8XWSeE/7Jo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772194994; c=relaxed/simple;
	bh=+P1EMyj+JPu0gC2LBs8N7qrwpJ+YjbU3W7NRoeSX15w=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=ryt4MAmQ2C1O6y4IfT8ToyE37vsCDU5MkHquZHdiXnzWUNQwR5T3GbC1vl6IWCCuwPMirWyLnpkFn/yOquUwYbhM1rzM9NdulbvnprUCjZgAmfqrR2kSFpY7nZFCv26OPuibzGF1Bdxsx4FTfZzrB1k7vL/xa08wG13EXahdKvM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com; spf=pass smtp.mailfrom=sapience.com; dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b=dyVvzyg8; dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b=i8wu8RXQ; arc=fail smtp.client-ip=72.84.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sapience.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b="dyVvzyg8";
	dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b="i8wu8RXQ"
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from smtp.sapience.com (srv8.prv.sapience.com [10.164.28.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by s1.sapience.com (Postfix) with ESMTPS id 0E824480AD5;
	Fri, 27 Feb 2026 07:23:13 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1772194992;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=wmf6STqfPI4qMxb00pQl4Lu518Dcv8a4OxRnitl8qqw=;
 b=dyVvzyg8slpMlQrMKmE6ZuwiIaZqkOfKQM34oJ7iJ3iwPNzgfA64NFVk3e3yrOke52gIs
 CEmBRbANpahItmWBQ==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1772194992;
	cv=none; b=SPgTQpQp58VnFjWeS+8Mz7pFR1a/sXgK2K4Dr1fLVSM+lJTGt7FkycGZvlczn3M6rcDHJdUAR2/tT/oBvpcHqZaOSO8sY2sQslWiAYLmwE/YyVGgIeLf0ynAY5HMwcN6RJn/N9R7rngAhmEk2fUsnzwsL+xchNAxCsMdKvZN3ek+/eta1PbRmD+25kbCZiNRKgkd0Lan3vHbNm6k6RKHwEbmwdYz0AViwBox+/tJUrUFoK4dx7KQP4KbXmToXwqKM5V3UnL4pG48c4i40NkZUxWoqI5Zdt6ujE6BUTyJQfNLfj3eNMGh/+YdIcjfjrwztXCab/Azz6sYb4ux+stJIA==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
	t=1772194992; c=relaxed/simple;
	bh=+P1EMyj+JPu0gC2LBs8N7qrwpJ+YjbU3W7NRoeSX15w=;
	h=DKIM-Signature:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:User-Agent:
	 MIME-Version; b=Rfj+I7oInDr4XPFwW4JXxsk9qJOzPL1cB/1pMr8YKLS8EcHKUrGydpUPMYUeqzU+XnwdMFKDXfUgiFLQQ9MVJ4qMwaJWTRpYuun3vkwuHfhbQrBltypE6y4TApo8TNasdsdwHbHNH6Wl+1etAv+UCYRLE3LLtG/aFsEknF9onCJ8Xa/yKM6MKHIoXafiIwhPtEr5Xsy/cxriUpCx/lxAO5x0oq6Rix3O4o50JKx1u8P5SQp+zjDB/9yTEe6a9fVQMdl17N/zNduPXnaJID5F2I+B1e8iwbV8Yqfx+vJ/0kyhC+Yx0jZ1jL1hplXj39J2a+XVatLDNvZTPxIQswvatw==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1772194992;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=wmf6STqfPI4qMxb00pQl4Lu518Dcv8a4OxRnitl8qqw=;
 b=i8wu8RXQj8we8iZiUbJ5zM1IluVfELY9gRHgCmqnpx54rdADyXNG5LoavDsOniWvUVn4B
 +6x6amwLILcgmU3Kd7g6ORgfPBMRV47Zs/CvTTFmeCa8i4GDfUMPrw3clHlq9Bh9ab7021w
 emhHy1tyYYN/CWKyT8A4/UC1md32yBTzsGWDEyEQH8tgbgqwkQOM9+280s/YtuLmSkEnNPO
 p1L0YQrYLv5vyJ3Wa9irTNAURbCf++NfTQr2TvXk/z9kqdoU06QO+qXe6vZAmXrhe0UAm93
 DO/i+vm/DlAAyCBDf3913nCjcoRH+xxsi4UmOg4CJsMkGFZCB9aX1eWVilgA==
Received: by smtp.sapience.com (Postfix) id D6BA9280010;
	Fri, 27 Feb 2026 07:23:12 -0500 (EST)
Message-ID: <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables
From: Genes Lists <lists@sapience.com>
To: Thorsten Leemhuis <regressions@leemhuis.info>, 
	linux-kernel@vger.kernel.org, coreteam@netfilter.org, 
	netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, "Kris Karas (Bug
 Reporting)" <bugs-a21@moonlit-rail.com>
Date: Fri, 27 Feb 2026 07:23:12 -0500
In-Reply-To: <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
	 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
Autocrypt: addr=lists@sapience.com; prefer-encrypt=mutual;
 keydata=mDMEXSY9GRYJKwYBBAHaRw8BAQdAwzFfmp+m0ldl2vgmbtPC/XN7/k5vscpADq3BmRy5R
 7y0LU1haWwgTGlzdHMgKEwwIDIwMTkwNzEwKSA8bGlzdHNAc2FwaWVuY2UuY29tPoiWBBMWCAA+Ah
 sBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEE5YMoUxcbEgQOvOMKc+dlCv6PxQAFAmPJfooFCRl
 vRHEACgkQc+dlCv6PxQAc/wEA/Dbmg91DOGXll0OW1GKaZQGQDl7fHibMOKRGC6X/emoA+wQR5FIz
 BnV/PrXbao8LS/h0tSkeXgPsYxrzvfZInIAC
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-ZcEBCWJ5ogTbMPi8SwTF"
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-ZcEBCWJ5ogTbMPi8SwTF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-02-27 at 09:00 +0100, Thorsten Leemhuis wrote:
> Lo!
>=20
> On 2/27/26 04:46, Genes Lists wrote:
> > I have a problem with nftables not working on 6.19.4=20
>=20
> Thx for the report. A problem that from a brief look seems to be
> similar
> ist already discussed and was bisected in this thread:
>=20
> https://lore.kernel.org/all/bb9ab61c-3bed-4c3d-baf0-
> 0bce4e142292@moonlit-rail.com/
>=20
> I assume Greg will handle this soon through a revert or by applying
> another patch.
>=20
> Ciao, Thorsten
>=20
Thank you Thorsten.

There are 2, possibly related or not, issues.=C2=A0

  - failure to boot with 6.19.4 (thread you linked above)
  - nft failing to load any rules (mainline) with error message.
=20
I responded to that thread since in my case 7.0 mainline boots fine but
nft does not load any rules.=C2=A06.19.3 loads the same rules just fine.

Repeating the nft error message here for simplicity:

 Linux version 7.0.0-rc1-custom-1-00124-g3f4a08e64442 ...
  ...
  In file included from /etc/nftables.conf:134:2-44:
  ./etc/nftables.d/set_filter.conf:1746:7-21: Error:
  Could not process rule: File exists
                 xx.xxx.xxx.x/23,
                 ^^^^^^^^^^^^^^^



--=-ZcEBCWJ5ogTbMPi8SwTF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQRByXNdQO2KDRJ2iXo5BdB0L6Ze2wUCaaGMsAAKCRA5BdB0L6Ze
2zlOAQCpLtOsmzJ3N4x1ZvGGTHmvhhLvyLF9sqs153EPHeIZ/gD/cAEM71T+BxKc
ScGtUYUcVZJ6ZB0sstKnAx+/1jEudwI=
=dqfE
-----END PGP SIGNATURE-----

--=-ZcEBCWJ5ogTbMPi8SwTF--
