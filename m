From: Harald Welte <laforge@netfilter.org>
Subject: Re: Target ipt_ACCOUNT
Date: Mon, 19 May 2003 15:07:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030519130728.GL2073@sunbeam.de.gnumonks.org>
References: <200305162018.h4GKIvu02359@moonlight.crew-kg.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g3RkK9jYN81zD2N+"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rolf Wuerdemann <rowue@crew-kg.de>
Content-Disposition: inline
In-Reply-To: <200305162018.h4GKIvu02359@moonlight.crew-kg.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--g3RkK9jYN81zD2N+
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2003 at 10:18:54PM +0200, Rolf Wuerdemann wrote:
> Hi Harald ...
>=20
> long time not heared ...

indeed.

> if you remember I wrote an target for iptables/netfilter last year
> wo packet-based accounting - besides some "cosmetic" changes
> (> 80 chars/line, c-- style comments) you've metioned that you
> dislike the use of netfilter-sockets to get the data from kernel- to
> user-space ...

Yes, I remember.

> besides the cosmetic changes (which where done very fast) I've
> changed to data-transfer to the use of "/dev/accounting" via "normal"
> kernel file i/o (no proc fs or so) (this takes some "spare time" which
> I've gotten now)

I see.

> Although I've used "dynamic-major-number-relocation" I've also heared
> that someone should ask for a "real" major number if he wants to publish
> code...
>
> May you give me a hint where to ask?

The 'Linux Assigned Names and Numbers Authority' at http://www.lanana.org/

> 	Rolf W=FCrdemann
> 	Wieske's Crew KG

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--g3RkK9jYN81zD2N+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+yNcQXaXGVTD0i/8RAlVEAJ0ZJXKVwrOL2LtA0g0lmKL3QoCl1ACglnCY
W5Qpk6X7zT6BG4ZsiJVAjCk=
=LpSa
-----END PGP SIGNATURE-----

--g3RkK9jYN81zD2N+--
