From: Eric Leblond <eric@inl.fr>
Subject: Re: interface based conntrack entry
Date: Tue, 18 Mar 2008 06:50:09 +0100
Message-ID: <20080318055008.GA21458@bayen.regit.org>
References: <CAC6870A2B8FE846AD24D7E75B05F90A3F1960@moe.nextone.local> <1C6541574A2FC447B53A6B4522B678AF015A12C5@moe.nextone.local> <20080317232543.GB4003@bayen.regit.org> <47DF11A1.5020401@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52118 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766AbYCRFuT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:50:19 -0400
Content-Disposition: inline
In-Reply-To: <47DF11A1.5020401@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tuesday, 2008 March 18 at  1:49:37 +0100, Pascal Hambourg wrote:
> Hello,
>
> Eric Leblond a =E9crit :
>> On Monday, 2008 March 17 at 16:13:45 -0400, Sohan Shetty wrote:
>>>
>>> Here, our box is connected to two distinct networks 192.168.1/24 [...]
>> There is no such patch. A similar question was asked some time ago and
>> if I remember well, the conclusion was the setup was too weird from a=20
>> firewall point-of-view.
>
> s/weird/broken by design/
>
> The purpose of prefixes is to identify networks. If you use the same pref=
ix=20
> on distinct networks, expect trouble.

No, not really. If you use advanced routing capabability of linux this
setup can be easily achieved and except for filtering will be working
well (with one routing private table per network interface pair).

The correct explanation about the problem of conntrack relatively to
this setup is given by Jan Engelhardt in his mail.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH31gQnxA7CdMWjzIRAoC0AJ9T9tjb7RWvWO/+IzYBr4XJRd5WBwCdFMWP
AVSrEPYeayogvTqq9Z2IvtA=
=zEKy
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
