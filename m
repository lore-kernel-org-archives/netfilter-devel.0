From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: faster way to read conntrack state than /proc ?
Date: Sat, 18 Oct 2003 11:09:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1066468148.12167.82.camel@tux.rsn.bth.se>
References: <20031018074256.GA29942@alpha.home.local>
	 <1066467318.12167.80.camel@tux.rsn.bth.se>
	 <20031018090420.GA1150@pcw.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IOlM+uROiYn3AN1YlTRD"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20031018090420.GA1150@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-IOlM+uROiYn3AN1YlTRD
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2003-10-18 at 11:04, Willy TARREAU wrote:
> On Sat, Oct 18, 2003 at 10:55:19AM +0200, Martin Josefsson wrote:
> =20
> > We have something called nfnetlink and ctnetlink. ctnetlink has the
> > ability to dump all connections via netlink (unless someone, possibly
> > me, broke it).
>=20
> Thank you very much Martin for all these details. I will take a look at a=
ll
> this soon. Don't worry, I won't complain about the bugs (though I may rep=
ort
> them)

With patches? :)

> , and I understand that this is not production-ready. My first goal was t=
o
> be able to report statistics about number of established, syn_recv, close=
_wait
> and time_wait connections without killing the machine.

Yes, that would kill throughput using /p/n/ip_conntrack.

--=20
/Martin

--=-IOlM+uROiYn3AN1YlTRD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/kQM0Wm2vlfa207ERApHyAKCQklJLyZCtGxfO/DtL8K5gY6NBhgCeO4Gy
d70WQOMKLNVdfqgHXgbD8bs=
=Bujg
-----END PGP SIGNATURE-----

--=-IOlM+uROiYn3AN1YlTRD--
