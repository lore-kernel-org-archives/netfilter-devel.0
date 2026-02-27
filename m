Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FDF334683;
	Fri, 27 Feb 2026 13:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=72.84.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772197981; cv=fail; b=SbgvThvZu7GIebk/d2mqcG2tB+Difvga3I3z0/YYVJZK74VlLPEMUZEU0PKFvplxy+MowS7SAxux2a3qvQuLivFjaNpMaYvNqEhFn+ajzwXlmxEwamlOt/6mgAgN1UfZ5m1h53ME06+6e4lDK8Jiof6Z248u9UaKfLQEtHfUUIk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772197981; c=relaxed/simple;
	bh=66brhFRBz338PGN0olefuSynj+xI4prDr13fFivWvS4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=rekNQAtsAbJGa4Bf/8H9tagYuuzSRRK1SUWWjT/WgX8mMqVxsuqGbNDrp6rDo4gfJMpHnpq92eJGMIa17dU4XMh5cH5XNANhiQxZJD2+KsJliTdACrcaJHWAFirD5970YJ6XQ2o7yZnXnIh41njksECfj7FxhtH1pXYyk3+uuIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com; spf=pass smtp.mailfrom=sapience.com; dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b=4fZanwKf; dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b=U9Oi9Qxl; arc=fail smtp.client-ip=72.84.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sapience.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b="4fZanwKf";
	dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b="U9Oi9Qxl"
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from smtp.sapience.com (srv8.prv.sapience.com [10.164.28.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by s1.sapience.com (Postfix) with ESMTPS id BB8D0480AF2;
	Fri, 27 Feb 2026 08:12:59 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1772197979;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=tNy7bNq5Bi8ob3Qjmrq03i+Ph2cnpnZSAkwXqBQ6qdQ=;
 b=4fZanwKfMi2TbnjyXAFVU/C8Ryv+5F7bELYg/98QvjgBrT4fVGvhijX6xXqqb7ynZUld5
 wI7K2n9dlKEkbUnDg==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1772197979;
	cv=none; b=IIWchx0m3JS+JTFJkLxiH0H+qVQVcM417Y03wXEOGuQM8VUOTcbDMa3qXAP9ZMjnF+M1PeTX0NDyo9JoPknWAC7f2C9p1YaUESh0g/CDcApE5LdVVP7ZnltLIwcTucTPZaVUEYTCGjnO9nZsTSTwk75IC+TCtRPlpEBOX1HJvhd1abKXodz0QzlvForXGj2m93ooVg8xsZ30ddRsMbXDfHjnzcze1tAor6NldhTg5Hs0sArTiDEXFpxSUK2jkDex7Sn+tyvtkrwHP1fDMk2/NeHBINl3D6l196R8Zf74tGb5cpWCtvwoXtyI4c6cPosy4KDVYJxo0w4uLU8BTJo97Q==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
	t=1772197979; c=relaxed/simple;
	bh=66brhFRBz338PGN0olefuSynj+xI4prDr13fFivWvS4=;
	h=DKIM-Signature:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:User-Agent:
	 MIME-Version; b=SBJHNbT3m2i+0+FWjW+WeKJCnyxLcejo8MSa2klJt20y9PWSwGAkVp+hXFegGHeCPCSwzRyhngkLLupdY03lZbJgxz7qgk9ADwHmZtYKkDZvXZ42SXQ+kg3GHHPXjpD5I8OHRpxZX68Qsd62wvSEFdJonSb/KfQDQjWR47M1WWEEYNPpcyrhBYE+b2HSLYt3tZxSPeFPU5iG9hO3/TWoZEMYKzRNxomIkMD7UL5BeRjUxJoR8ubmmcm79v7AF8/AS/5SFlKQ2peZap3H9RQficRefnBjB6/JO+H64zPFsFfF0tl/v+wW6kVNaBWH0pxnf9zo/kMOiZ36tMaXfc4XnQ==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1772197979;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=tNy7bNq5Bi8ob3Qjmrq03i+Ph2cnpnZSAkwXqBQ6qdQ=;
 b=U9Oi9QxleUn+27c0fI2aTm07VFQD/NBOJaCluaPfak4wi28Lf4r6BkqK1TVEUHreqDUIN
 6E3wVdjeoH0LZfwHlHMepgQesC1S3DqM5juDxxJRh06f8hQr9nMvV+oLjxXmnRmsFb7uZtq
 Q7oKtg/6BiWUoTeiTkp4VOPnpyxK+ur18d0qteeguOzLqNknYmNTfE897fDbYlMmU/3tOsb
 DDVh27hMB3RrhDNjNLVt7NNa9TCADFM5R0Q/gkdJcGb+QZMax3LovHiRlXIDZBJoeB2UU1l
 vr3Adi68th7e8Q7KwFv5hr9+4P6l4M8DMHwdO3JspjvBOY5BmRGPqEHJU0ig==
Received: by smtp.sapience.com (Postfix) id 8D823280010;
	Fri, 27 Feb 2026 08:12:59 -0500 (EST)
Message-ID: <10537f2b74da2b8a5cb8dc939f723291db39ff84.camel@sapience.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables [resolved]
From: Genes Lists <lists@sapience.com>
To: Thorsten Leemhuis <regressions@leemhuis.info>, 
	linux-kernel@vger.kernel.org, coreteam@netfilter.org, 
	netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, regressions@lists.linux.dev, "Kris Karas (Bug
 Reporting)" <bugs-a21@moonlit-rail.com>
Date: Fri, 27 Feb 2026 08:12:59 -0500
In-Reply-To: <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
		 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
	 <143e1a402ad78dd7076516a6ceb637f378310b16.camel@sapience.com>
Autocrypt: addr=lists@sapience.com; prefer-encrypt=mutual;
 keydata=mDMEXSY9GRYJKwYBBAHaRw8BAQdAwzFfmp+m0ldl2vgmbtPC/XN7/k5vscpADq3BmRy5R
 7y0LU1haWwgTGlzdHMgKEwwIDIwMTkwNzEwKSA8bGlzdHNAc2FwaWVuY2UuY29tPoiWBBMWCAA+Ah
 sBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEE5YMoUxcbEgQOvOMKc+dlCv6PxQAFAmPJfooFCRl
 vRHEACgkQc+dlCv6PxQAc/wEA/Dbmg91DOGXll0OW1GKaZQGQDl7fHibMOKRGC6X/emoA+wQR5FIz
 BnV/PrXbao8LS/h0tSkeXgPsYxrzvfZInIAC
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-nKNztZjYbaV7lLx9h1x4"
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-nKNztZjYbaV7lLx9h1x4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-02-27 at 07:23 -0500, Genes Lists wrote:
> On Fri, 2026-02-27 at 09:00 +0100, Thorsten Leemhuis wrote:
> > Lo!
> >=20
>=20
> Repeating the nft error message here for simplicity:
>=20
> =C2=A0Linux version 7.0.0-rc1-custom-1-00124-g3f4a08e64442 ...
> =C2=A0 ...
> =C2=A0 In file included from /etc/nftables.conf:134:2-44:
> =C2=A0 ./etc/nftables.d/set_filter.conf:1746:7-21: Error:
> =C2=A0 Could not process rule: File exists
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 xx.xxx.xxx.x/23,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 ^^^^^^^^^^^^^^^
>=20

Resolved by updating userspace.

I can reproduce this error on non-production machine and found this
error is resolved by re-bulding updated nftables, libmnl and libnftnl:

With these versions nft rules now load without error:

=C2=A0- nftables commit de904e22faa2e450d0d4802e1d9bc22013044f93
 - libmnl   commit 54dea548d796653534645c6e3c8577eaf7d77411
=C2=A0- libnftnl commit 5c5a8385dc974ea7887119963022ae988e2a16cc

All were compiled on machine running 6.19.4.



--=-nKNztZjYbaV7lLx9h1x4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQRByXNdQO2KDRJ2iXo5BdB0L6Ze2wUCaaGYWwAKCRA5BdB0L6Ze
2128AP45F4qYOvqxCKPBvV1mtaAFEuQ4d9oMwNl3H2wsPiR4rAD8Cwu6uyLQP7ZG
o6UaDhz9s6lVYna3ObRxYBk1ifJYgAs=
=XoXk
-----END PGP SIGNATURE-----

--=-nKNztZjYbaV7lLx9h1x4--
