From: Harald Welte <laforge@netfilter.org>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Tue, 13 Jan 2004 12:54:28 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040113115428.GO20206@sunbeam.de.gnumonks.org>
References: <4001F33A.9000802@trash.net> <20040112234710.1B13C2C0C4@lists.samba.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JfVplkuTfB13Rsg5"
Cc: Patrick McHardy <kaber@trash.net>, kuznet@ms2.inr.ac.ru, fenio@o2.pl,
	davem@redhat.com, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	boris@boris.ca, email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Content-Disposition: inline
In-Reply-To: <20040112234710.1B13C2C0C4@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JfVplkuTfB13Rsg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2004 at 03:30:14PM +1100, Rusty Russell wrote:
> In message <4001F33A.9000802@trash.net> you write:
> > Julian Anastasov wrote:
> >=20
> > >- provide oif learned from the input route (as before the discussed
> > >change). May be in 99% of the setups it selects the right route.
> > >I think, we should use this, at least for 2.4.
> > >
> > > =20
> > >
> > Why should we do a route lookup at all ? MASQUERADE doesn't need the
> > dst_entry but only the interface address. Using ifa_list->ifa_local
> > of the outgoing in_device seems like the simplest solution to me.
>=20
> You take all the fun out.
>=20
> Yes, this is the best.  It always does *something*, and is
> predictable.  People with really complex routing shouldn't really use
> MASQUERADE, since it's designed for a specific, simple case.

No, I really disagree with that.  I still don't understand what the
problem was with the old solution.  We haven't received any complaints,
at least not that I can remember.

And as long as we don't provide a more sophisticated MASQUERADE
replacement target, we shouldn't change the behaviour at all.

You cannot use SNAT for the dynamic IP address case, because it doesn't
flush the tables.

And there are lots of users that have multiple DSL-dynip links these
days, trying to statically or dynamically balance web requests between
them, etc.

> Cheers,
> Rusty.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JfVplkuTfB13Rsg5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAA9x0XaXGVTD0i/8RAjpkAKCHm7gH3bde/0loYgHRYja3rOV9eACfV1I7
2QXf+5Ra7qBgBYO7p1KzTEw=
=x89B
-----END PGP SIGNATURE-----

--JfVplkuTfB13Rsg5--
