From: Tom Marshall <tommy@home.tig-grr.com>
Subject: Re: [Debian Bug#218837] limit match not working on sparc64
Date: Thu, 6 Nov 2003 17:44:25 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107014425.GB10258@home.tig-grr.com>
References: <20031106160055.GA25555@absolom.libra.net> <20031107000324.GC5741@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20031107000324.GC5741@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2003 at 01:03:24AM +0100, Harald Welte wrote:
> On Thu, Nov 06, 2003 at 11:00:56AM -0500, Laurence J. Lane wrote:
> > I received a bug report [0] regarding the limit match not working
> > on sparc64 with kernel 2.4.22. It references an earlier report [1]
> > of the problem on this list. Harald Welete commented on it [2] and
> > asked for additional information, but there is no clear resolution.
> >=20
> > Anyone?
>=20
> this is most likely never going to get fixed.   the problem is that the
> limit match does an ugly hack: it stores a pointer in it's struct
> matchinfo.  That pointer is 64bits in the kernel, but userspace is
> 32bits, and thus the compilar only allocates 32bit for the pointer in
> the structure: boom.

Just a random thought -- is an intptr_t the same between kernel and userland
on all architectures?

--=20
Absurdity, n.: A statement or belief manifestly inconsistent with one's own
opinion.
        -- Ambrose Bierce, "The Devil's Dictionary"

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iEYEARECAAYFAj+q+PkACgkQFMm9uvwPXW71WQCfeZeuyJpykYWkCLg6rt5g/cfN
ORcAn0zAyWVqQL+Hd227lcy+DVHnon2U
=kOhO
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
