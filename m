From: Eric Leblond <eric@inl.fr>
Subject: Re: nfq_set_verdict_mark
Date: Thu, 12 Oct 2006 08:35:39 +0200
Message-ID: <1160634939.24065.8.camel@localhost>
References: <986D9B66-68B6-4A02-9762-40224E145496@cadvium.net>
	<4521284C.2070000@netfilter.org> <452B2D9A.7080702@trash.net>
	<452C33FE.6060902@netfilter.org> <452CB33D.8060908@trash.net>
	<452D6676.8090700@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-C1pr0u/IbZdumjlf19E6"
Cc: Robert Scott <rbscott@cadvium.net>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <452D6676.8090700@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-C1pr0u/IbZdumjlf19E6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Le mercredi 11 octobre 2006 =E0 23:47 +0200, Pablo Neira Ayuso a =E9crit :

> We can warn about incompatibilities in the announce of new releases for
> this kind of minor issues that we need to fix up and that result in
> breakages, some kind of "heads up" section.

Why not to add a API release number in the code.

As developper of NuFW, I've got no problem to change my code but, I need
a way to have my users not bored when they use my software. In fact I
can not control which version of libnetfilter_queue.

Something like "#define NFQUEUE_API_VERSION NNN" in libnetfilter_queue.h
could really be used easily in application code to detect which flavour
of the API they need to use.

BR,
--
Regit


>=20
> For the rest of the API, I remember that in one of my discussions with
> Harald we conclude that is better to introduce new API than breaking
> current just not to annoy users. We can strongly recommend the use of
> the new API and mark old one as deprecated (with the gcc attribute) to
> warn users that such obsolete function will vanish soon. That would
> stagger changes.
>=20
> >> The current release process is too slow, I have the impression that
> >> nobody is using the lastest official releases. For conntrackd, I'm
> >> currently doing unnofficial releases of libnetfilter_conntrack because
> >> the official release is broken with NAT handlings, well apart from the
> >> fact that I also introduce some patches with new features that I need.
> >=20
> > You're probably right (about people not using official releases) and
> > definitely right about releasing too seldom.
> >=20
> >> Just tell you that I don't mind about spending some time on
> >> administration tasks like releases and any other stuff related with th=
e
> >> website if that can help to speed up the release process. I worked on
> >> some scripts to automate the release process time ago after the worksh=
op
> >> that I can recover.
> >=20
> > That would be great. Let me know if you need anything (I think I recall
> > your keys expired?).
>=20
> I need to renew my key in order to tag new releases in SVN, I also need
> to generate some kind of "release master GPG key" or something in other
> to sign new releases.
>=20
--=20
Eric Leblond <eric@inl.fr>
INL

--=-C1pr0u/IbZdumjlf19E6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iD8DBQBFLeI7nxA7CdMWjzIRAu8jAJ0Z9cmLc9/2uOsfMUA6nA7NEpelNgCfcph0
s719Wp6rO9iBOhAvYzRzn/g=
=jwly
-----END PGP SIGNATURE-----

--=-C1pr0u/IbZdumjlf19E6--
