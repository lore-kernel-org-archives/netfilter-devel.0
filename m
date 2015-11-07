From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH -stable,4.3.y] netfilter: xt_TEE: fix NULL dereference
Date: Sat, 07 Nov 2015 16:04:02 +0000
Message-ID: <1446912242.6006.93.camel@decadent.org.uk>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
	 <1446813886-5632-2-git-send-email-pablo@netfilter.org>
	 <20151106170934.GC24185@kroah.com> <20151106172626.GB1357@salvia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-DVgn4TYvqTJ/yje9zCT1"
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	Eric Dumazet <edumazet@google.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>, Greg KH <greg@kroah.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53628 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753671AbbKGQEW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Nov 2015 11:04:22 -0500
In-Reply-To: <20151106172626.GB1357@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-DVgn4TYvqTJ/yje9zCT1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-11-06 at 18:26 +0100, Pablo Neira Ayuso wrote:
> On Fri, Nov 06, 2015 at 09:09:34AM -0800, Greg KH wrote:
> > On Fri, Nov 06, 2015 at 01:44:44PM +0100, Pablo Neira Ayuso wrote:
> > > From: Eric Dumazet <edumazet@google.com>
> > >=20
> > > [ upstream commit 45efccdbec3cd465c4776ed9ca1d7b1bba1b7e34 ]
> > >=20
> >=20
> > Not a valid commit id :(
>=20
> Same thing:
>=20
> http://git.kernel.org/cgit/linux/kernel/git/davem/net.git/commit/?id=3D
> 45efccdbec3cd465c4776ed9ca1d7b1bba1b7e34

But it's not in mainline yet. =C2=A0You should re-submit to stable once it
is.

Ben.

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-DVgn4TYvqTJ/yje9zCT1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAVj4g8ue/yOyVhhEJAQrtJhAAtRkSF/ikthGuNlBY9o1Ohg1x2fg1RRXJ
KZ0BiLRo+N7QELE0ITozntXXS6MHn/4+pW2dgMDAZoqOAaZwVAIk7iN8GPkUP3CT
b5FuMLuvEGRXpcsaSjTpoSfSfpRJDPT9TkPsTYVSCJ4egvQdViUCIUy8qr9cSskl
okk8Ev9HUFpFl0OatMhTuDHVCALu3DYDjoGH9fgOkwbBa+PILl9eaVbolyqcSVsE
u1QsANAiJwato+Ho6OxBJaiEtHD08AIbisdkQmPE9+4uEyhwHnGLUoePtwr7YVCw
GYNvBJbzaCRNForje1vqIamjCd4nuHMpZJYAUrfuJ00N5gwkmwLpW6QJ+xirnD0N
0lGY9CQgQShhS7R1b9SRaXaiCd3ocVS4lVVkoy1JB3Av5WfDTNTlX9lYXjUXMjCU
EBeqqwZQC3QYgV+32LlcumEN9te2sn0tKxppKc5Wwv2NX1LAWWFBOp6dMmwq0erA
jihehytKVHxjanslrYVyGlhc/r/vCq9ogairzKeoACbTH9Ob+GSI2uJUa5l4yvpe
KZYLx/8WxkVrMSDItcLg8NoJF9ooxuu7EuVmwMQ3NsJBg28kdg5RG155S3pX9NrJ
FAFqL/HzpV5PedK1uFy+qo3t2sSU1bh1aCejTM1yRLdTNVhmlqQ30kJA0k8N8QHa
4ZGRhaI6dl0=
=lVdi
-----END PGP SIGNATURE-----

--=-DVgn4TYvqTJ/yje9zCT1--
