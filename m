From: Harald Welte <laforge@gnumonks.org>
Subject: Re: some question about libiptc
Date: Fri, 31 Jan 2003 12:22:36 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131112235.GP9073@naboo.cybercafe42>
References: <F97GAGoMLk4vQd5GQrW00006ede@hotmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S6vg04ofUPzW4qJg"
Cc: sumit@elitecore.com, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: PAUL FABRICIO VILLACRESES LEON <paulvillacreses@hotmail.com>
Content-Disposition: inline
In-Reply-To: <F97GAGoMLk4vQd5GQrW00006ede@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--S6vg04ofUPzW4qJg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2003 at 08:00:05PM +0000, PAUL FABRICIO VILLACRESES LEON wr=
ote:
>=20
>=20
> Hi
>=20
>=20
>=20
> I'm Paul Villacreses
> Student ESPOL ECUADOR
> TOPIC : Firewall content
>=20
> I had develop a program with libiptc.a and othes library libpcap, i had t=
he=20
> following

*sigh* Somebody else using libiptc as if it was intended as a public
interface.  I'm sorry that it still hasn't been replaced by something
more useful.

As of now, I feel unable to answer to any more support questions on
libiptc.=20
=20
> Please can anybody help me!!!! a response HOW i can put rules in table na=
t=20
> , and HOW TO put rules whith port TCP like 80(HTTP),53(DNS),23(TELNET) wi=
th=20
> programming NOT with scripts.

pipe your commands into 'iptables-restore --noflush'

> Thank you Developers
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M-=
=20
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)

--S6vg04ofUPzW4qJg
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+Olx7XaXGVTD0i/8RAskGAJ442KDBSZFe5xIQTT3UENkGXVY09wCeMHZM
KN6izt6XKWK96QXVI1Gs2ws=
=DLEv
-----END PGP SIGNATURE-----

--S6vg04ofUPzW4qJg--
