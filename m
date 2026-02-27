Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CACE368947;
	Fri, 27 Feb 2026 13:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=72.84.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772199572; cv=fail; b=Kx1hOVb5ecFHQeBmycr9Rf/zQj6d8BQHg/Uli/gGnG9ZnqD7afbhXkZ7RP/kZ+PasKEIdU2lVnNorKQOP4mj4z2CVdLV5/NrExbddTJHY9atiMcrkGVU5Vn7BpyMKhY7RGYahcGZp5vTticlR9E83Xf+sSZfgLEASKYjZqS4d7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772199572; c=relaxed/simple;
	bh=f49N//pWtCnONo/B4uJjlMe4Hi5VI6GcPPAX2PZNy5k=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=PjDvaTLTU49ccBigdIQLO6JusOjm2X2WYpGQX86FVSfON20INGRv6UrbdvXwMJsE2MMb2uLIBPEayQ3e1I/51CzuBgbPczHDRi4ufG7XrCUMBjDAF2ErjWufG77XDtFS1TpqOOXIwS0LOziC6DWC3VIcmstl6NfpJtl1W5sknCc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com; spf=pass smtp.mailfrom=sapience.com; dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b=/hMv0fPa; dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b=o9EOdBpC; arc=fail smtp.client-ip=72.84.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sapience.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b="/hMv0fPa";
	dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b="o9EOdBpC"
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from smtp.sapience.com (srv8.prv.sapience.com [10.164.28.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by s1.sapience.com (Postfix) with ESMTPS id 4BA9C480AD5;
	Fri, 27 Feb 2026 08:39:30 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1772199570;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=Ly8OTzTPUc3bnUG3mkdT2a/hM6gsdrG2y1nv72Qsysg=;
 b=/hMv0fPaGG9uKlYVGjM/6CpAbAqhzo5VAIFr/6/UBSC2JXszPqp6Hy1WkJNIIPGHdZhD8
 F8ECuVbJnpjgpnvDA==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1772199570;
	cv=none; b=D3MoPFhAYGGs8BHRZDbFLW7ahsrKf1la2O3GPBdNfL+9u8+ZCQpI3EtQqrTiQfkbr9a9B73/HtZw66PoWrluyXSpwc7y25wyQPQ3qX3KZQy4QfS19AUVHa/74odxS1OEevM04x1PT/qu9IlLisQh6yGAtMBwBbTgRgpa0+2vPwmLfTFi4ULGiGLA9yHIzlwC6JThezrYjN874m8LjmHRm2QH6DxA7zAb+vR+GXMMmwzu5jv57FaNPa4+1F7OPBOHzB0vMVvyJhzHlt1qMYvuhsCPQhHM512v8RWf1JDSeUcp/STdkT9V3NOrwuCV/m31/imXaICt8gWWqKW45wb/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
	t=1772199570; c=relaxed/simple;
	bh=f49N//pWtCnONo/B4uJjlMe4Hi5VI6GcPPAX2PZNy5k=;
	h=DKIM-Signature:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:User-Agent:
	 MIME-Version; b=hbpjXugWFy3+3DoTBIiUlRO63V2px1yGNkeEmGeNj1RuxHZ4KQotr65lmErQyO/41nEW1ea3Ve/Yg3w3mfJmmolA9isAek1Moxzb7zZhfQV6os9Om8Go3tpeHh6CJic+G/P5xMiiW3bD5EQyyyextvVYJilZjbwrr5YNTgyUyJAoMsw91rOYmnUq9y16BSwRTLjqhQtCUtiJCaUyypl37xj6pmNB5oB/u2oac+wQm/MYOriPBAh9fn8bqw8uVHXO2PXGE1z94UY0BBeT6yZ0b0NnFgejD+/mH28+7RhOJi63Tij2by8iz5Sen4Lznn+IagYcz3AInoK+CHOdMOBZHw==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1772199570;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=Ly8OTzTPUc3bnUG3mkdT2a/hM6gsdrG2y1nv72Qsysg=;
 b=o9EOdBpCp1Mq0U44dJyxSL5MdCHirWyPGBfmbeAZiZSh56v8eeKXRtIk0g8UrERtWVBX8
 C9u+xcG2x7kEXDtKTMTBBAQ09mVRQfFOj3n2UiuwN0YyS8VernmNUAOjMy3wsC+3NfT3Fse
 jBXfoTRaCYw+ICOSuyfC/vEzyctdxN/WZAb8/N/B5l+T+OJ5DRePq9OiEOTesyF9EbHPdgG
 97Ot+uQn+UI4DyK6VbVB1sDnER2yGdIzkIlMbFosN0Lxd6er9Jiy6yHPSCfVW9g/Q+xkkMr
 +agHnI2Y94p8NZfXSXAlYAO5h9viGijsfaqOWvUJAjrV21PYHeIdnIVCVSSg==
Received: by smtp.sapience.com (Postfix) id 0AFF4280010;
	Fri, 27 Feb 2026 08:39:30 -0500 (EST)
Message-ID: <b231fcdb6c66a7b24dcef3ee5c35c5f612d5c1a7.camel@sapience.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables [resolved]
From: Genes Lists <lists@sapience.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Thorsten Leemhuis <regressions@leemhuis.info>, 
	linux-kernel@vger.kernel.org, coreteam@netfilter.org, 
	netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	stable@vger.kernel.org, regressions@lists.linux.dev, "Kris Karas (Bug
 Reporting)" <bugs-a21@moonlit-rail.com>
Date: Fri, 27 Feb 2026 08:39:29 -0500
In-Reply-To: <2026022755-quail-graveyard-93e8@gregkh>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
	 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
	 <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
	 <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>
	 <2026022755-quail-graveyard-93e8@gregkh>
Autocrypt: addr=lists@sapience.com; prefer-encrypt=mutual;
 keydata=mDMEXSY9GRYJKwYBBAHaRw8BAQdAwzFfmp+m0ldl2vgmbtPC/XN7/k5vscpADq3BmRy5R
 7y0LU1haWwgTGlzdHMgKEwwIDIwMTkwNzEwKSA8bGlzdHNAc2FwaWVuY2UuY29tPoiWBBMWCAA+Ah
 sBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEE5YMoUxcbEgQOvOMKc+dlCv6PxQAFAmPJfooFCRl
 vRHEACgkQc+dlCv6PxQAc/wEA/Dbmg91DOGXll0OW1GKaZQGQDl7fHibMOKRGC6X/emoA+wQR5FIz
 BnV/PrXbao8LS/h0tSkeXgPsYxrzvfZInIAC
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-CJH6K1VESEbpPGNJW4eb"
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-CJH6K1VESEbpPGNJW4eb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-02-27 at 05:17 -0800, Greg KH wrote:
> On Fri, Feb 27, 2026 at 08:12:59AM -0500, Genes Lists wrote:
> > On Fri, 2026-02-27 at 07:23 -0500, Genes Lists wrote:
> > > On Fri, 2026-02-27 at 09:00 +0100, Thorsten Leemhuis wrote:
> > > > Lo!
> > > >=20
> > >=20
> > > Repeating the nft error message here for simplicity:
> > >=20
> > > =C2=A0Linux version 7.0.0-rc1-custom-1-00124-g3f4a08e64442 ...
> > > =C2=A0 ...
> > > =C2=A0 In file included from /etc/nftables.conf:134:2-44:
> > > =C2=A0 ./etc/nftables.d/set_filter.conf:1746:7-21: Error:
> > > =C2=A0 Could not process rule: File exists
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 xx.xxx.xxx.x/23,
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 ^^^^^^^^^^^^^^^
> > >=20
> >=20
> > Resolved by updating userspace.
> >=20
> > I can reproduce this error on non-production machine and found this
> > error is resolved by re-bulding updated nftables, libmnl and
> > libnftnl:
> >=20
> > With these versions nft rules now load without error:
> >=20
> > =C2=A0- nftables commit de904e22faa2e450d0d4802e1d9bc22013044f93
> > =C2=A0- libmnl=C2=A0=C2=A0 commit 54dea548d796653534645c6e3c8577eaf7d77=
411
> > =C2=A0- libnftnl commit 5c5a8385dc974ea7887119963022ae988e2a16cc
> >=20
> > All were compiled on machine running 6.19.4.
>=20
> Odd, that shouldn't be an issue, as why would the kernel version you
> build this on matter?
>=20
> What about trying commit f175b46d9134 ("netfilter: nf_tables: add
> .abort_skip_removal flag for set types")?
>=20
> thanks,
>=20
> greg k-h

- all were rebuilt from git head=C2=A0
=C2=A0 Have not had time to explore what specific change(s)
  triggered the issue yet.

- commit f175b46d9134
=C2=A0 I can reproduce on non-production machine - will check this and
report back.

gene


--=-CJH6K1VESEbpPGNJW4eb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQRByXNdQO2KDRJ2iXo5BdB0L6Ze2wUCaaGekQAKCRA5BdB0L6Ze
28g4AQC6mRMo5uvyx2ArEysg5FMWDmgobsk9TV2gBQKlqLgNUAD+NcPrQtj63XFC
RWbNuHc6y1O6/bZgZ+RRZllc6fKA1wc=
=Bijr
-----END PGP SIGNATURE-----

--=-CJH6K1VESEbpPGNJW4eb--
