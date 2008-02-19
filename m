From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 02/34] [Resend] Do not propagate one conntrack event
	via  2 messages
Date: Tue, 19 Feb 2008 15:05:06 +0100
Message-ID: <20080219140506.GO22767@khasse.inl.fr>
References: <1201987469575-git-send-email-eric@inl.fr> <1201987469368-git-send-email-eric@inl.fr> <12019874692227-git-send-email-eric@inl.fr> <877ihmmluc.fsf@kruemel.eitzenberger.org> <20080203115309.GB25411@bayen.regit.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l3ej7W/Jb2pB3qL2"
To: Holger Eitzenberger <holger@eitzenberger.org>,
	netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52278 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbYBSOFL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 09:05:11 -0500
Content-Disposition: inline
In-Reply-To: <20080203115309.GB25411@bayen.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--l3ej7W/Jb2pB3qL2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On Sunday, 2008 February  3 at 12:53:09 +0100, Eric Leblond wrote:
> Hello,
>=20
> On Sunday, 2008 February  3 at 10:27:07 +0100, Holger Eitzenberger wrote:
> > Eric Leblond <eric@inl.fr> writes:
> >=20
> > > Ulogd2 was propagating through a stack 2 message for one single connt=
rack event.
> > > This patch provides a fall back to on message per event. It also uses=
 an enum to improve
> > > code readability instead of direct access to array via numerical inde=
x.
> >=20
> >  [ULOGD 15/15] NFCT: rework and let it scale
> >=20
> > from my last patchset?  I'll happily change that code to keep the
> > output key compatibility.
>=20
> As long as you maintain output key compatibility, I'm fine with it.

We're still without decision on this problem and we thus don't have a
working ulogd2 NFCT input plugin.

On one side we've got Holger work which is quiet important but adds some ke=
rnel dependancies
and in the other side my small work which will be at term compatible
with Holger's work. Maybe someone form the team could apply the patch and
let code be updated when Holger's kernel side code reach mainstream ?

By the way, it could be interesting to plan an ulogd2 beta release in a
not too far future.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--l3ej7W/Jb2pB3qL2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHuuISnxA7CdMWjzIRAhlSAJ0WO5YWcuh8xgJpNYL8eF2wSuNZtQCfQtUE
M5vtPgIBY3Gh8CK5EdTcQUo=
=XlLb
-----END PGP SIGNATURE-----

--l3ej7W/Jb2pB3qL2--
