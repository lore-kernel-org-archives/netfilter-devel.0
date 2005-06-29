From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Wed, 29 Jun 2005 22:16:25 +0200
Message-ID: <20050629201625.GY25641@sunbeam.de.gnumonks.org>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="msgLTjjeumHWYklJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <42C2FC14.80609@trash.net>
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


--msgLTjjeumHWYklJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 29, 2005 at 09:52:52PM +0200, Patrick McHardy wrote:
> > So I think that we can group event, say:
> >=20
> > level 1 (weak):
> >     - IPCT_NEW
> >     - IPCT_DESTROY
> >=20
> > level 2 (normal):
> >     - IPCT_NEW
> >     - IPCT_UPDATE
> >     - IPCT_STATUS
> >     - ...
> >     - IPCT_DESTROY
> >=20
> > At reserve some groups to let the user define some level whenever he
> > wants. Although such level would be unique.
> >=20
> > OTOH, there are 10 events currently, why is that bad creating a group
> > per event?
>=20
> I don't think its bad, but I fear hitting the 32 group limit some day.
> Probably that fear is unfounded and we're never going to reach 32
> different types of events. Harald, what do you think?

I think it's not all that much of a problem.  I doubt that conntrack
will get 22 more events anytime soon.  The other problem is, don't we
overlap with other nfnetlink-based groups?

nfnetlink acts as a a multiplex between netlink and the higher layers,
so I guess we only have 32groups for nfnetlink as a whole... and there
is other stuff like ip_queue and ULOG that is to be ported on top of
nfnetlink...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--msgLTjjeumHWYklJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCwwGZXaXGVTD0i/8RAgGRAJwKbJ+huJ73AMl5RN6PIrBgdFWcswCffI+k
Yq/sLddwjEMTRUnJa3sZXpw=
=izyf
-----END PGP SIGNATURE-----

--msgLTjjeumHWYklJ--
