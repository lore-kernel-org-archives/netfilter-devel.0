From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] Netfilter/IPVS updates for stable 3.0 onwards
Date: Sun, 14 Oct 2012 10:43:33 +0100
Message-ID: <1350207813.4832.75.camel@deadeye.wl.decadent.org.uk>
References: <1349950539-12491-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AQYu5YUKEc+fokTsMIqj"
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44006 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751843Ab2JNJnr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Oct 2012 05:43:47 -0400
In-Reply-To: <1349950539-12491-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-AQYu5YUKEc+fokTsMIqj
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-11 at 12:15 +0200, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> Hi!
>=20
> The following patchset aims to reduce the Netfilter debt with stable 3.0 =
and
> onwards.
>=20
> The selected six patches are:
>=20
> 07153c6 netfilter: nf_ct_ipv4: packets with wrong ihl are invalid
> 3f509c6 netfilter: nf_nat_sip: fix incorrect handling of EBUSY for RTCP e=
xpectation
> f22eb25 netfilter: nf_nat_sip: fix via header translation with multiple p=
arameters
> 2614f86 netfilter: nf_ct_expect: fix possible access to uninitialized tim=
er
> 9e33ce4 ipvs: fix oops on NAT reply in br_nf context
> 82e6bfe netfilter: xt_limit: have r->cost !=3D 0 case work [REQUIRES 7a90=
9ac netfilter: limit, hashlimit: avoid duplicated inline]
>=20
> I have read stable_rules.txt and I consider they match the requirements.
>=20
> Please, cherry-pick them. Thanks!

All queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-AQYu5YUKEc+fokTsMIqj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUHqJRee/yOyVhhEJAQr0zw//dHgSowrV8ZIMPrv7OXmod7BqWr0CwBbU
dCfEL2cd3gJvhzVheiYFX9syf3gW8KmkzaZ7O2+UJiEdVNam4iGCU3pekGO5qYSO
iOHkrnSC/DOKARxzAV/q5cee9/alzavjFMz70/CoiRtEstvZilVmmUj7TsNcUHV1
/FvOjNphqF5Bci1SCqIesGZlYa4z3uIaHTz7BIeYLxcVYDmvmhbmXbsItaq/xrCU
xozDdXqj2HdSLQ/DR4bgWNBTSRocs9NJRZzhF49MYKuYN2GBShkQrGK0ytoTO54X
d0m3RQ3xGucPujdHXAuOgkG605f/Bwm64X2S0WSLCr6AwhgxDiePVli3Ek/fTWk2
w3s8utUk1fAGJgKpqfxWVUSjZCnuZuDOmKWXdDT9HXNX3hCVsebpOjPvWU3pkEQw
PlCGs9c1XeKby4IgpaP3Sh70oq3ZfyI421O/vTfmOOtWakHI43VaE5MqZeWT+hkS
o0nUlFIy7Ydkc52wDmmBarJ5q4bgIiVHL3gE2P+m7vpcZET53+tX07U0JTSkKJ1I
j3ltrAMBYEcQpFYt7swAj5EgjcsRP2xH3wh+sJMpD7L2TEviCUYPX2uvuhNvdcWQ
EQ1EiASRJDghZkwwPPPXiGMUH8W82WYz63qJ5vMjKSchXJQu0MSX4NrxqlMI9uiC
+aKm1ahX/xE=
=vDtc
-----END PGP SIGNATURE-----

--=-AQYu5YUKEc+fokTsMIqj--
