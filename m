From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Possible problem with tcp-window-tracking
Date: Mon, 21 Jun 2004 22:08:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087848492.10514.10.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0406212105040.1107-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-N1TNBXzAOXTuyjgjtIVH"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0406212105040.1107-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-N1TNBXzAOXTuyjgjtIVH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2004-06-21 at 21:12, Jozsef Kadlecsik wrote:
> Hi Martin,

Hi Jozsef

> There has been a lot of traffic pumped trough the code but there can be
> dark corners. Therefore we need active testers in wide variety of
> environments.

Yup, that's why I'm using it :)

> > Now I've started a tcpdump to see what really happens when it complains=
.
> > Hopefully I'll have something more substantial that this report soon.
>=20
> Yes, that is required to track down who's faulty where: log from the
> kernel and a full tcpdump of the traffic. There is no need to capture
> whole packets if diskspace is critical, full IP/TCP headers are
> sufficient.

Yup, only logging the first 96 bytes per packet (default tcpdump
snaplength it seems).
No problems so far, we'll see tomorrow if anything is caught.

--=20
/Martin

--=-N1TNBXzAOXTuyjgjtIVH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA10AsWm2vlfa207ERAlqrAJ9BvuLEACmFKrU00GXm4ErKbAkNtACgll7v
wmQDZctPVJT55LjhWaFoiS8=
=rA7n
-----END PGP SIGNATURE-----

--=-N1TNBXzAOXTuyjgjtIVH--
