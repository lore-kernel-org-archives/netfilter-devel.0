From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: Tue, 11 Jun 2002 09:59:22 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020611095922.G11177@sunbeam.de.gnumonks.org>
References: <1023365846.845.26.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fCcDWlUEdh43YKr8"
Cc: Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1023365846.845.26.camel@tux>; from gandalf@wlug.westbo.se on Thu, Jun 06, 2002 at 02:24:04PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--fCcDWlUEdh43YKr8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2002 at 02:24:04PM +0200, Martin Josefsson wrote:
> This patch adds a check to ip_ct_refresh() so it doesn't update the
> timer of a connection unless it's been >HZ ticks since the last update.
> both del_timer() and add_timer() disables interrupts while
> removing/inserting the timer, no reason to do this for each packet.

ok.  I'm postponing this stuff for after 2.4.20 time, since for 2.4.19
we already have enough netfilter [and core networking changes], and for 2.4=
.20
there will be the newnat merge.

> /Martin

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

--fCcDWlUEdh43YKr8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9Ba3ZXaXGVTD0i/8RAtXgAKCaO1q6xex8wOu2f5Zia0yQpb0s7gCffdy1
3qo8/q8Ap/54uFZB8dvXmrs=
=I+qn
-----END PGP SIGNATURE-----

--fCcDWlUEdh43YKr8--
