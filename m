From: Harald Welte <laforge@netfilter.org>
Subject: Re: mutex or semaphore
Date: Sun, 30 Mar 2003 20:42:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030330184237.GO7718@sunbeam.de.gnumonks.org>
References: <200303281746.24624.zigie@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0kRkyLZR5zsR9u2P"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Christian Ziegler <zigie@gmx.de>
Content-Disposition: inline
In-Reply-To: <200303281746.24624.zigie@gmx.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--0kRkyLZR5zsR9u2P
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 28, 2003 at 05:46:24PM +0100, Christian Ziegler wrote:
> Hello,
>=20
> I hope I've choosed the right mailing list.
>=20
> Does iptables use a mechanism like mutex or semaphore?

it uses a mutex.

> Or should I use some lock-files in my scripts to avoid simultaneous acces=
s to=20
> the rules?

no, this is not necessarry. any iptables command will execute
atomically.

> Thank you
> Chris

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0kRkyLZR5zsR9u2P
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+hzqdXaXGVTD0i/8RAmlnAJ9zOy3n59tJIZuss0Tne7mgwqxdygCgkyaQ
GoYyiIO65Ayn71BPKuEqgHE=
=Oq80
-----END PGP SIGNATURE-----

--0kRkyLZR5zsR9u2P--
