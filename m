From: Harald Welte <laforge@netfilter.org>
Subject: Re: NAT for DirectConnect (NeoModus P2P protocol)
Date: Mon, 15 Sep 2003 12:00:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030915100037.GG777@obroa-skai.de.gnumonks.org>
References: <1062896689.3f5a8431e07a6@www2.inbox.lv> <20030912211801.GE4398@obroa-skai.de.gnumonks.org> <1063496496.3f63ab30b3e3a@www2.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TdkiTnkLhLQllcMS"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: jeeecha@inbox.lv
Content-Disposition: inline
In-Reply-To: <1063496496.3f63ab30b3e3a@www2.inbox.lv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--TdkiTnkLhLQllcMS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 14, 2003 at 02:41:36AM +0300, jeeecha@inbox.lv wrote:
> I have 2.4.21 kernel, but POM only has patches for 2.4.20.
>=20
> I looked at the POM for 2.4.20 and the API for most conntract
> function is different from what I have in my 2.4.21 source tree
> which I downloaded from ftp.kernel.org.

? The API of the code in netfilter CVS
(netfilter/patch-o-matic/{submitted,pending,base,extra}) is not any

> Should I revert to 2.4.20 kernel and apply POM on top of that
> before continuing my efforts to make the subj! kernel modules?

no.  Use a recent kernel (2.4.21 or 2.4.22) and apply patch-o-matic
'submitted' repository from CVS.

> Thanks in advance,
> Jekabs
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TdkiTnkLhLQllcMS
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/ZY3FXaXGVTD0i/8RAid0AJ9IP1UW/vUYRbEHPTeSyUUDijQQugCfWu/w
M1prRX6El/BisGMVpy6HfKk=
=4+gd
-----END PGP SIGNATURE-----

--TdkiTnkLhLQllcMS--
