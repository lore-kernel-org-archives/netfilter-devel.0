From: Harald Welte <laforge@gnumonks.org>
Subject: Re: --reject-with admin-prohib - Suggested Solution.
Date: Thu, 28 Nov 2002 09:10:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021128081009.GJ7047@naboo.de.gnumonks.org>
References: <Pine.LNX.4.44.0211120952040.29168-100000@dns.toxicfilms.tv> <Pine.LNX.4.44.0211121712540.1461-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fmvA4kSBHQVZhkR6"
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Maciej Soltysiak <solt@dns.toxicfilms.tv>, g@naboo.gnumonks.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0211121712540.1461-100000@dns.toxicfilms.tv>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--fmvA4kSBHQVZhkR6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2002 at 05:16:47PM +0100, Maciej Soltysiak wrote:
> Let's say the patch below has been submitted to 2.5 kernel, at 2.5.48
> stage. It adds admin-prohib to the REJECT target.

ok.

> Now, if the 2.5.48 kernel has the admin-prohib support, the userspace will
> detect it, and will show the option in -j REJECT --help and will accept
> admin-prohib.

No.  You will make the libipt_REJECT.so dependent on the particular
source code installed on the machine where iptables was compiled.

> What do you think?

Sorry for being such a PITA :(

> Best Regards,
> Maciej Soltysiak

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

--fmvA4kSBHQVZhkR6
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE95c9hXaXGVTD0i/8RAqesAKCqB+CrtbJEtfFuMNnsC+oz1iQcTwCfQbij
QSo8ao+0aCCxEmHtAvpkoUk=
=Rhz4
-----END PGP SIGNATURE-----

--fmvA4kSBHQVZhkR6--
