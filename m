Received: from s1.sapience.com (s1.sapience.com [72.84.236.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92573A7F5F;
	Fri, 27 Feb 2026 18:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=72.84.236.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772218735; cv=fail; b=XU458Gcgk8F3exRSUmiXb6iUAV/ma0aKCLDfcsu/H3S+78hhQLQorzO39MWZ1mT1z0Xzf41aD16ESmedn21TB7PzvhutMzNroCx03XvliiUMS9xEfeZOXBVzSrulHehEj8IEIqUDSzW6/HJIRJ9hkZUIUEwJ70cogZib3RhpgMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772218735; c=relaxed/simple;
	bh=tIYP4+utRzFc1yoc4fWT3Uoem9MLQquNeA6VEEGNMUM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=mXNGSSdqoHrP77hMUwFZM12wQeupGRCFTXiqnOntkKgHgP6/WbbVboXN+cZlzzbdISHCHI2fYCtOIICfuhFfyK7f0RmEJ7Z6QLmgKBvrqCgd1+mBJt+jq4CLl90QbRwv6judtCNql/YOeDPTzpBsfeyXslAa39bWZ6MuS30K/b8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com; spf=pass smtp.mailfrom=sapience.com; dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b=j5dI/umw; dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b=KPOXrE//; arc=fail smtp.client-ip=72.84.236.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sapience.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sapience.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=permerror (0-bit key) header.d=sapience.com header.i=@sapience.com header.b="j5dI/umw";
	dkim=pass (2048-bit key) header.d=sapience.com header.i=@sapience.com header.b="KPOXrE//"
Authentication-Results: dkim-srvy7; dkim=pass (Good ed25519-sha256 
   signature) header.d=sapience.com header.i=@sapience.com 
   header.a=ed25519-sha256; dkim=pass (Good 2048 bit rsa-sha256 signature) 
   header.d=sapience.com header.i=@sapience.com header.a=rsa-sha256
Received: from smtp.sapience.com (srv8.prv.sapience.com [10.164.28.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature ECDSA (secp384r1) server-digest SHA384)
	(No client certificate requested)
	by s1.sapience.com (Postfix) with ESMTPS id 1312E480A33;
	Fri, 27 Feb 2026 13:58:53 -0500 (EST)
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-ed25519-220413; t=1772218732;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=NGbsjSbPcFusC9feVYLBdka34A/NbvkjNOFFBprU3tU=;
 b=j5dI/umwJRvE/i2mYEz84baWVP6gw0s5oHBIUOhXlig3aqdZ2X7/kiw/1DZBlwK1+bOOx
 sj+mOz7V99VR45KDw==
ARC-Seal: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412; t=1772218732;
	cv=none; b=Vmkmt28ffuHrgdL9tYLz4Yu0tOMyJTZvondOy/6FeNOrw3WBB53Kwgx/x0bsTqVU6q9u+VVj3hmbErkbit3yayQERKJrmaUu3rD9Oj7GQBo+cV3+CYBXCwukyG9RigJiSKQ8GUABDQJT7XC0e5dYB8iOrN5z60/9ud1fZp+cImyB/EPpP21PRDkhdfxQHTz0H6T0tzScNRimJ2pNJJdHu/X3Eez8sSEq9nL+oIoFoUAbHQB0Qtcoia/XRyd2mP2faWvDF2LYIcW251wqnv4ySTnlH1BjuVEEqhpcfVXs7s3u3J0aalbcFxag1WUAmHXiu7NAMSMGooDMZRFeMIzz8A==
ARC-Message-Signature: i=1; a=rsa-sha256; d=sapience.com; s=arc6-rsa-220412;
	t=1772218732; c=relaxed/simple;
	bh=tIYP4+utRzFc1yoc4fWT3Uoem9MLQquNeA6VEEGNMUM=;
	h=DKIM-Signature:DKIM-Signature:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Autocrypt:Content-Type:User-Agent:
	 MIME-Version; b=ygquy55Fq+J944SZOgtDzTyNawOcZ93hTXBTqKm+36JlR4Je2Tgz3yrZQDo8grci/3/QYnJpMySB7CohblfGn8BZh/AtpiDpI/BeH+KDuB+ji0KkCr4wQDctSvt6fV497f/gSl8BEAuefW2XSvSwpJZhKDw+qD+UPcXLjv9BVShRrwjY95SjZIJI4SobZ/H2NeOaTvC4H3FE4xHKk+U7wiuCcc+RxBNl4r0gelWohtWgLyIpbKks8GMvFJyRUPc3X2fk3GAeZZLE4ZrBCw7iuHKxW7hgCnyh1LdINfiLAJkMIavGdJ2BRGd9KHXQ6OBU9oM58sQTjbjEohOg4zUewg==
ARC-Authentication-Results: i=1; arc-srv8.sapience.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sapience.com;
 i=@sapience.com; q=dns/txt; s=dk-rsa-220413; t=1772218732;
 h=message-id : subject : from : to : cc : date : in-reply-to :
 references : content-type : mime-version : from;
 bh=NGbsjSbPcFusC9feVYLBdka34A/NbvkjNOFFBprU3tU=;
 b=KPOXrE//6ChLnK3NHal3But3XdsHu5laGeEPVR2qNIgbxVQ572v4KAky3UBG3HKimDgAr
 U8RN30oS3puLkDE5YoDqWM7/jn0bkfgVL84jE+F9KI92NyhBcC59gIpHF3Uh4g36oDvSVKB
 gga6lPDNkwio+xX4DSUjFN+BNUbkvxasoGWKTKTRrHdHoXzsE9IUYEPqu3lliy+Dvgfqktk
 IqJOvS5DqUmufZmhJWyD0L7JtPyJTclsZl4K+Bu2ANNGAyeGAvKTDhAEKeCZk3CJ0eBTp9E
 G3vDQaQh35PT7YlJh2tGHOM/urt8E3MqpQxcT1Ksd4e5iqLOGy6P5QmHcWhw==
Received: by smtp.sapience.com (Postfix) id D5FE8280010;
	Fri, 27 Feb 2026 13:58:52 -0500 (EST)
Message-ID: <06b6a53bff1a5db07a29dec6441995d97b20cfa5.camel@sapience.com>
Subject: Re: [REGRESSION] 6.19.4 stable netfilter / nftables -> resolved
From: Genes Lists <lists@sapience.com>
To: Florian Westphal <fw@strlen.de>, Thorsten Leemhuis
	 <regressions@leemhuis.info>
Cc: linux-kernel@vger.kernel.org, coreteam@netfilter.org, 
	netfilter-devel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
 Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 regressions@lists.linux.dev, "Kris Karas (Bug Reporting)"
 <bugs-a21@moonlit-rail.com>
Date: Fri, 27 Feb 2026 13:58:52 -0500
In-Reply-To: <aaFSOkhkjowYB2YJ@strlen.de>
References: <a529a6a9a2755d45765f20b58c5c11e2f790eacb.camel@sapience.com>
	 <45f03b0b-fe8f-4942-bad1-3fbde03d4be1@leemhuis.info>
	 <aaFSOkhkjowYB2YJ@strlen.de>
Autocrypt: addr=lists@sapience.com; prefer-encrypt=mutual;
 keydata=mDMEXSY9GRYJKwYBBAHaRw8BAQdAwzFfmp+m0ldl2vgmbtPC/XN7/k5vscpADq3BmRy5R
 7y0LU1haWwgTGlzdHMgKEwwIDIwMTkwNzEwKSA8bGlzdHNAc2FwaWVuY2UuY29tPoiWBBMWCAA+Ah
 sBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEE5YMoUxcbEgQOvOMKc+dlCv6PxQAFAmPJfooFCRl
 vRHEACgkQc+dlCv6PxQAc/wEA/Dbmg91DOGXll0OW1GKaZQGQDl7fHibMOKRGC6X/emoA+wQR5FIz
 BnV/PrXbao8LS/h0tSkeXgPsYxrzvfZInIAC
Content-Type: multipart/signed; micalg="pgp-sha384";
	protocol="application/pgp-signature"; boundary="=-zm2RUZeaEdy7KEcSo7EL"
User-Agent: Evolution 3.58.3 
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0


--=-zm2RUZeaEdy7KEcSo7EL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2026-02-27 at 09:13 +0100, Florian Westphal wrote:
> Thorsten Leemhuis <regressions@leemhuis.info> wrote:
> > On 2/27/26 04:46, Genes Lists wrote:
> > > I have a problem with nftables not working on 6.19.4=20
> >=20
> > Thx for the report. A problem that from a brief look seems to be
> > similar
> > ist already discussed and was bisected in this thread:
> >=20
> > https://lore.kernel.org/all/bb9ab61c-3bed-4c3d-baf0-
> > 0bce4e142292@moonlit-rail.com/
>=20
> Thanks for this pointer.
>=20
> Can someone check if 'git cherry-pick
> f175b46d9134f708358b5404730c6dfa200fbf3c'
> makes things work again post 6.19.4?
>=20
> Its a missing indirect dependency.

Summary now that all is resolved.

There were, coincidently, 2 separate issues.
Pure serendipity they happened together.

 a) kernel 6.19.4 netfilter oops [1]
    which is fixed by  =20
	f175b46d9134f708358b5404730c6dfa200fbf3c
=20
 b) nftables with large sets=C2=A0
    nft reports spurious error:
    rule could not be loaded: File exists
    After which no rules are loaded.

    Fixed in nftables git repo by commit:
    ---
    commit e83e32c8d1cd228d751fb92b756306c6eb6c0759
    Author: Pablo Neira Ayuso <pablo@netfilter.org>
    Date:   Mon Jan 12 12:59:26 2026 +0100

    mnl: restore create element command with large batches
   =20
    The rework to reduce memory consumption has introduced a
    bug that result in spurious EEXIST with large batches.
    ---

    This happens with kernels=C2=A0:
    - 6.19.4 + netfilter commit f175b46d9134f7
    - 7.0-rc1
    - linux-next
=20
    It does not seem to happen with older kernels (assuming I=C2=A0
    did not mess up the testing!)

    I confirmed this 2nd issue is resolved in both=C2=A0
    - nftables git head and
    - v1.1.6 plus
      git cherry-pick=C2=A0\
       a9ead6a808dbe637ae7b9f54598f0dff9582d34d \
       e83e32c8d1cd228d751fb92b756306c6eb6c0759


thanks all.

gene


[1]=C2=A0
https://lore.kernel.org/all/bb9ab61c-3bed-4c3d-baf0-0bce4e142292@moonlit-ra=
il.com/

--=-zm2RUZeaEdy7KEcSo7EL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYJAB0WIQRByXNdQO2KDRJ2iXo5BdB0L6Ze2wUCaaHpbAAKCRA5BdB0L6Ze
20UJAQCk+p3hTfdJNSn2aE7ZTsJe1KU8cUDrmutpcGCcWC7SoQEA6+w8h6gWCcE6
ZzC1UcYaLqPQ++pib/Q1sm74p0eQGgs=
=mKho
-----END PGP SIGNATURE-----

--=-zm2RUZeaEdy7KEcSo7EL--
