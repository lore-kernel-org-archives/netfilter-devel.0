From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Strange thing with iptables
Date: Thu, 09 Sep 2004 16:38:00 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1094740680.8900.10.camel@localhost.localdomain>
References: <opsd15s018le1n2s@mail.tlt.hu>
	<1094732295.8900.7.camel@localhost.localdomain>
	<Pine.NEB.4.60.0409091430510.3683@ukato.freeshell.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-1hX/yzUeZcsS/CVqhe1b"
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexey Toptygin <alexeyt@freeshell.org>
In-Reply-To: <Pine.NEB.4.60.0409091430510.3683@ukato.freeshell.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-1hX/yzUeZcsS/CVqhe1b
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-09-09 at 16:33, Alexey Toptygin wrote:

> > It's a feature :)
> > It doesn't make the current code any more complicated.
> > And ther are actually people using it to do weird stuff...
>=20
> Do you mean that one can use arbitrary bitmasks wherever netfilter wants =
a=20
> netmask value?
> So, one might select all IPs with the LSB set with 0.0.0.1/0.0.0.1?

Yes you can.
Although this might change in the (distant) future when diffrent
algorithms are used for rule-lookup.

--=20
/Martin

--=-1hX/yzUeZcsS/CVqhe1b
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBQGrIWm2vlfa207ERAhsCAKCj3yATyVXEpHXzVrHcb4ins0i0IQCgliwo
944V/7sWNZqj3bm8f6QADGk=
=tLqG
-----END PGP SIGNATURE-----

--=-1hX/yzUeZcsS/CVqhe1b--
