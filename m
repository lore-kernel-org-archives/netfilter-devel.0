From: Harald Welte <laforge@gnumonks.org>
Subject: Re: Comments about IPT_ALIGN
Date: Fri, 31 Jan 2003 12:51:07 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030131115107.GV9073@naboo.cybercafe42>
References: <3E335CB1.9070101@hipac.org> <20030126120159.A3045@linux.karinthy.hu> <3E33C665.9080106@fugmann.dhs.org> <3E33E96A.5080903@hipac.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZaW/dtY/7oMe/vLp"
Cc: Anders Fugmann <afu@fugmann.dhs.org>,
	Laszlo Valko <valko@linux.karinthy.hu>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Thomas Heinz <creatix@hipac.org>
Content-Disposition: inline
In-Reply-To: <3E33E96A.5080903@hipac.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ZaW/dtY/7oMe/vLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 26, 2003 at 02:58:02PM +0100, Thomas Heinz wrote:
=20
> Actually this is not true for some existing targets and matches, e.g.:
 [...]

> Since I assume that ULOG and MARK work perfectly on sparc64 I must
> be missing something that makes the internal memory layout of the
> structs (i.e. the member offsets) equal in user and kernel space
> (or my assumption is wrong ;-).

I'd rather think of your assumption as being wrong.  I have never tested
ULOG on sparc64 so far. But thanks for bringing up this issue.

> Regards,
> Thomas

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

--ZaW/dtY/7oMe/vLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+OmMrXaXGVTD0i/8RAuEaAKCz8EHEnc++7zHTJQ1fnOPUfD0cMgCfTRvW
A3d1wrbyWkgEx1pPV1oNu9w=
=ufci
-----END PGP SIGNATURE-----

--ZaW/dtY/7oMe/vLp--
