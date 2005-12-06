From: Harald Welte <laforge@netfilter.org>
Subject: Re: Another target to log packet
Date: Tue, 6 Dec 2005 20:43:12 +0530
Message-ID: <20051206151311.GI4038@rama.exocore.com>
References: <1133450457.438f14d924ba8@imp1-g19.free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWOmaDnDlrCGjNh4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ced.clerget@free.fr
Content-Disposition: inline
In-Reply-To: <1133450457.438f14d924ba8@imp1-g19.free.fr>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--pWOmaDnDlrCGjNh4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 01, 2005 at 04:20:57PM +0100, ced.clerget@free.fr wrote:
> An another target is available on https://sourceforge.net/projects/nflog =
to log
> packet via a virtual device (take the idea of pflog under OpenBSD).

Thanks for letting us know.=20

Unfortunately the names "nf_log" and "NFLOG" are already used in 2.6.15+
kernels, so we have a name overlap here. I strognly recommend that you
rename your code, since both kernel and iptables userspace side use
exactly that name for something different :(

Also, it is not the right way to implement this as an iptables target.
Instead, I suggest reimplementing it as a nf_log backend (i.e. something
that registers as nf_logger at  'nf_log_register().

This way all you need is the virtual interface code - and it is not
related to iptables at all.  In fact, even ipv6/bridge/arptables/...
logged packets can end up at that interface.

btw: we give out people.netfilter.org accounts, just in case you're
interested (I'm a sourceforge-hater, but that's just a personal thing).

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--pWOmaDnDlrCGjNh4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDlaqHXaXGVTD0i/8RAthXAJ9JJ38ug04bvoz2K7f4NmFCe7APOwCeMS57
hzkhZby2DXiTUigIjdGoE8o=
=eKZJ
-----END PGP SIGNATURE-----

--pWOmaDnDlrCGjNh4--
