From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH-2.4-POM] sessions stuck in CLOSE_WAIT state
Date: Wed, 8 Oct 2003 11:44:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031008094447.GL25743@sunbeam.de.gnumonks.org>
References: <20031007221817.GA487@alpha.home.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Rex5+51txc1ort/q"
Cc: kadlec@blackhole.kfki.hu, netfilter@lists.netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
Content-Disposition: inline
In-Reply-To: <20031007221817.GA487@alpha.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Rex5+51txc1ort/q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2003 at 12:18:17AM +0200, Willy Tarreau wrote:
> Fortunately, tcpdump showed to me that all stuck sessions had in common t=
he
> fact that the server aborted them with an RST after the first FIN+ACK, so
> in CLOSE_WAIT. Others which were aborted with an RST just before or just =
after
> were destroyed without any problem.

Ok, this sounds like a pretty clear case than.  This bug has not been
found because replying with RST afer FIN+ACK seems a quite unusual
pattern.
=20
> /*rst*/ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sLA, sLI },
>=20
> But the tcp_window_tracking patch changes this behaviour, I think because=
 of
> a typo, since I see no other reason not to terminate a session upon RST :
>=20
> /*          sNO, sSS, sSR, sES, sFW, sCW, sLA, sTW, sCL, sLI   */
> /*rst*/   { sIV, sCL, sCL, sCL, sCL, sIV, sCL, sCL, sCL, sIV },

yes, I totally agree with you.  I'll apply your proposed patch to
patch-o-matic.  If Jozsef disagrees, he can revert that change.

> BTW, is it normal that an RST received in TIME_WAIT state terminates the
> session ? I would have thought that we should keep it in TIME_WAIT anyway.

again agreed.  Jozsef, what do you think?

> BTW, I noticed that the tcp_conntracks[] array takes some memory because =
every
> entry takes one full int. This is 480 bytes on x86. Wouldn't it be more c=
ache-
> friendly to use compact structures with bit fields instead ?

yes, it was more cache line friendly.  But then, wouldn't we get lots of
unaligned accesses?  oh you made a u32 aligned version...

> For example, either something like this (byte-aligned) :
>   u8 tcp_conntracks[6][10] =3D { (REPLY_STATE)<<4 | (ORIGINAL_STATE), ...=
 }
>    -> read it from (tcp_conntrack[flag][old_state] >> dir?4:0) & 0xF
>=20
> or (u32 aligned) 80 bytes :
>   int tcp_conntracks[2][10] =3D { /* original */
>                                 { /* old sNO */
>                                   sSS << SYN | sTW << FIN | sES << ACK ...
>   -> read id from (tcp_conntrack[dir][old_state] >> flag*4) & 0xF.

this makes the code really hard to read.  If you can come up with some
easy-to-read macros, I'd be willing to give it a try.

> Same could be done on unclean(). If someone's interested, I can try to lo=
ok
> at what seems possible, and propose something.

yes, I'm interested - providing the code is not crippled by bit-shifts
and multiplications everywhere.

> Regards,
> Willy

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Rex5+51txc1ort/q
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/g9yPXaXGVTD0i/8RAgs3AKCisCpBNWilr4+Pj07h1aThnzB+RgCgoa/Z
hrUgY5q8J8Xm52A4aQKM1e0=
=L/O8
-----END PGP SIGNATURE-----

--Rex5+51txc1ort/q--
