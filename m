From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Possible problem with tcp-window-tracking
Date: Tue, 22 Jun 2004 07:30:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087882253.10514.14.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0406212105040.1107-100000@blackhole.kfki.hu>
	 <1087848492.10514.10.camel@tux.rsn.bth.se>
	 <20040622044606.GB21406@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xmWGq2t29OSJ9BT/JZoL"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20040622044606.GB21406@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-xmWGq2t29OSJ9BT/JZoL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2004-06-22 at 06:46, Willy Tarreau wrote:
> Hi Martin,

Hi Willy,

> If disk space becomes a problem, you can compress on the fly (I always
> do this now for long captures and it helps) :
>=20
> # tcpdump -w - | gzip -c9 > capture.gz
>=20
> and to stop it and flush the output buffer through gzip :
>=20
> # killall -INT tcpdump
>=20
> I've already done this to get several gigabytes of traffic.

Thanks for the tip but I don't have that much irc traffic :)
Only dumping that since it's the only traffic I've seen it happen to.

--=20
/Martin

--=-xmWGq2t29OSJ9BT/JZoL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBA18QNWm2vlfa207ERAs9TAJ4oIhLCOhsSyKoHqaH0do5tyNbsTQCgqBTs
AvfN9ujEpXmhL+HvOXmAKfE=
=oD+H
-----END PGP SIGNATURE-----

--=-xmWGq2t29OSJ9BT/JZoL--
