From: Harald Welte <laforge@gnumonks.org>
Subject: Re: ipt_iplimit bug fixed+questions
Date: Sun, 15 Sep 2002 13:54:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020915135443.R3810@sunbeam.de.gnumonks.org>
References: <B9QQOYXRWS74TSZXYU05OJYSFE08QL.3ce15cb3@hernyo>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JqtTuO3XTyKM6PLB"
Cc: netfilter-devel@lists.samba.org, Gerd Knorr <kraxel@bytesex.org>,
	"Wojciech Maj" <wojtektm@poczta.onet.pl>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Hermann <hernyo@c7.campus.utcluj.ro>
Content-Disposition: inline
In-Reply-To: <B9QQOYXRWS74TSZXYU05OJYSFE08QL.3ce15cb3@hernyo>; from hernyo@c7.campus.utcluj.ro on Tue, May 14, 2002 at 09:51:31PM +0300
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JqtTuO3XTyKM6PLB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2002 at 09:51:31PM +0300, Laszlo Hermann wrote:
>=20
> Dear Netfilter Team,
>=20
> I was testing the ipt_iplimit module (extension) while I encountered the
> following problem:
>=20
Sorry for following up this late.  I didn't read your code back in may, bec=
ause
it was a C file compressed in  a ZIP binary. =20

Proposed code changes are usually submitted as unified diff and
attached/included in the mail - so people can read it out of their mailbox.

Wojciech has encountered the same problem and pointed me at your original m=
ail.

The ipt_iplimit module is contributed by Gerd Knorr, so he is the author
and should make the decision whether he wants to include your changes or no=
t.

Gerd, could you please have a look and discuss the bug as well as the propo=
sed
fix with Laszlo and Wojciech?

Thanks.

--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M+=
=20
V-- PS++ PE-- Y++ PGP++ t+ 5-- !X !R tv-- b+++ !DI !D G+ e* h--- r++ y+(*)

--JqtTuO3XTyKM6PLB
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9hHUDXaXGVTD0i/8RAqtXAJ9WxNF4l01s+6sV7uWrbrhj3fD4pgCgoh9Q
wDU36J4jkYdUgu3lYdg49hw=
=fpZT
-----END PGP SIGNATURE-----

--JqtTuO3XTyKM6PLB--
