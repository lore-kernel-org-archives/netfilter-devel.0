From: Harald Welte <laforge@netfilter.org>
Subject: Re: Why huge timeout btw ?
Date: Tue, 24 Jun 2003 17:39:04 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624153904.GP2645@sunbeam.de.gnumonks.org>
References: <5.2.1.1.0.20030623234428.00b14690@192.168.0.1>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWOY2/vB4uO4FuME"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Gael Mauleon <gmauleon@free.fr>
Content-Disposition: inline
In-Reply-To: <5.2.1.1.0.20030623234428.00b14690@192.168.0.1>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JWOY2/vB4uO4FuME
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 23, 2003 at 11:48:15PM +0200, Gael Mauleon wrote:
> I'm just wondering as i realise my conntrack entry regarding tcp had huge
> timeouts. I saw the patch regarding the tweak of those timeouts but
> why a 5 day one by default ??

because an ESTABLISHED TCP session that hasn't been closed down by
either RST or FIN can live _forever_ without any data.

5 days is a trade-off between 'forever' and 'broken applications not
closing connection correctly'.

> Sorry if it had been discuss on this list before but maybe you can refres=
h=20
> my mind :)

There is a list archive...

> Gael.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JWOY2/vB4uO4FuME
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++HCYXaXGVTD0i/8RAqJNAKCFimtxzBtRkFSEycDibHxUbnBWfACgncw5
6Md21m5SoXM9JpRJdfSCWqM=
=08ok
-----END PGP SIGNATURE-----

--JWOY2/vB4uO4FuME--
