From: Harald Welte <laforge@netfilter.org>
Subject: Re: Why huge timeout btw ?
Date: Tue, 24 Jun 2003 22:27:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624202708.GE2645@sunbeam.de.gnumonks.org>
References: <5.2.1.1.0.20030623234428.00b14690@192.168.0.1> <5.2.1.1.0.20030623234428.00b14690@192.168.0.1> <5.2.1.1.0.20030624214109.00b147c8@192.168.0.1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/6pUCPTUcpTjDznW"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gael Mauleon <gmauleon@free.fr>
Content-Disposition: inline
In-Reply-To: <5.2.1.1.0.20030624214109.00b147c8@192.168.0.1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--/6pUCPTUcpTjDznW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 24, 2003 at 10:03:53PM +0200, Gael Mauleon wrote:

> >5 days is a trade-off between 'forever' and 'broken applications not
> >closing connection correctly'.
>=20
> Ah ok thanks... But well is there any applicative use or logical use of=
=20
> this ?
> I mean commonly session use some sort of keep alive packet or so on
> to keep tcp connections alive by themselves, so is there any application
> that open a connection without using it for 5 days and that is still need=
=20
> it ?

no. The applications started to use keepalive packets just because of
broken firewalls / nat devices with too short timeout.

> I agree the tcp connection must be closed volunterly by a RST or
> FIN (in normal case), but really does it make sense a 5 days tcp ghost=20
> connection,
> instead of a few hours one for exemple (default value) ??

because I want to have my SSH session still up and running even if I
don't type something for a couple of hours? The same goes for my VPN
tunnel.

> >> Gael.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--/6pUCPTUcpTjDznW
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++LQcXaXGVTD0i/8RAgr/AJ9mTb+scIgqV6sB0C2hSGVTOU8JSQCglOKO
fnRrU2iq6p+0403TPtL6epg=
=Nmxp
-----END PGP SIGNATURE-----

--/6pUCPTUcpTjDznW--
