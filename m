From: Eric Leblond <eric@inl.fr>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 11:34:14 +0200
Message-ID: <20080515093413.GC3442@khasse.inl.fr>
References: <200805151421.23862.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uXxzq0nDebZQVNAZ"
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:59884 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbYEOJeR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 05:34:17 -0400
Content-Disposition: inline
In-Reply-To: <200805151421.23862.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--uXxzq0nDebZQVNAZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Thursday, 2008 May 15 at 14:21:23 +0500, Anton wrote:
> Regarding the performance of the lookup of the iptables=20
> rules for match inside the kernel, is there any plans to=20
> improve the behaviour or no plans in this area yet?

Nf hipac is an alternative: http://www.hipac.org/

> For example on the transit gateway I have ~500 rules which=20
> mark the packet, according to the client source IP - with=20
> unique mark per client IP - so I have 500 unique marks=20
> there, and so cannot use IPSET, and only IPTABLES - but=20
> it's known that iptables insert/lookup is very slow on huge=20
> rulesets (atleat with iptables 1.3.x) and slowness=20
> progresses approximatelly exponentially on growth of rules=20
> number.
>=20
> Do I miss anything?

If you plan to use mark for QOS or routing why not simply use native
classifier of tc or "ip rule" ?

One other thing to look at may be :
http://www.netfilter.org/projects/patch-o-matic/pom-external.html#pom-exter=
nal-IPMARK

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--uXxzq0nDebZQVNAZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFILAOVnxA7CdMWjzIRAmhMAJ9CCBNFd37dx7hq6+pRLDDpDRq7ZwCeORaN
ZDtrbXQCUaTk+nWJnbixOdk=
=bb9/
-----END PGP SIGNATURE-----

--uXxzq0nDebZQVNAZ--
