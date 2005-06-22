From: Harald Welte <laforge@netfilter.org>
Subject: Re: Linux 2.6.12/iptables 1.3.1+CLUSTERIP issues
Date: Wed, 22 Jun 2005 21:17:42 +0200
Message-ID: <20050622191742.GN4551@obroa-skai.de.gnumonks.org>
References: <876ef97a0506201904a05582a@mail.gmail.com>
	<20050622121509.GG4551@obroa-skai.de.gnumonks.org>
	<876ef97a050622060750b078bd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kK1uqZGE6pgsGNyR"
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>
Content-Disposition: inline
In-Reply-To: <876ef97a050622060750b078bd@mail.gmail.com>
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


--kK1uqZGE6pgsGNyR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 22, 2005 at 09:07:02AM -0400, Tobias DiPasquale wrote:
> On 6/22/05, Harald Welte <laforge@netfilter.org> wrote:=20
> > this should never happen.  iptables always prefers
> > $KERNEL_DIR/include/linux/netfilter_ipv4 above its local copy.  Are you
> > sure KERNEL_DIR was set correctly while compiling iptables?

Ok, I now found what your problem was.  Instead of copying the
kernel-ipt_CLUSTERIP.h to iptables, you should have done it the other
way around (copy itpables-header to the kernel and recompile both).

The reason is that somehow one of the bugfixes for ipt_CLUSTERIP that I
sent DaveM some 7 weeks ago did not make it into 2.6.12 for unknown
reasons :(
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--kK1uqZGE6pgsGNyR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFCublWXaXGVTD0i/8RAj8UAJ9R/6T14QMw6rcTMurSsjrwQz9rDwCfdP8i
6xUvwzqilAr2oHMuE9+w4k0=
=NZX2
-----END PGP SIGNATURE-----

--kK1uqZGE6pgsGNyR--
