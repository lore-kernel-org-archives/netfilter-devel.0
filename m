From: Harald Welte <laforge@netfilter.org>
Subject: Re: [new filter] simple packet authentication
Date: Tue, 27 Jan 2004 11:43:03 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040127104303.GD11761@sunbeam.de.gnumonks.org>
References: <200401222204.04861.alexandre.becoulet@epita.fr> <0de101c3e147$648fa910$2601010a@bluereef.local> <200401230216.08607.alexandre.becoulet@epita.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexandre Becoulet <alexandre.becoulet@epita.fr>
Content-Disposition: inline
In-Reply-To: <200401230216.08607.alexandre.becoulet@epita.fr>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 23, 2004 at 02:16:08AM +0100, Alexandre Becoulet wrote:
> On Friday 23 January 2004 01:25, Andrew Hall wrote:
>=20
> > This is a neat idea although I'd probably be a bit wary to use the IP ID
> > field when considering it's use with fragments.
>=20
> Sure, using the IP ID field could be an issue. The module will not mangle=
=20
> fragmented packets (offset > 0 or MF flag set). That's why packets have t=
o be=20
> mangled before being routed. At least, it should work for locally-generat=
ed=20
> packets, and for packets reaching the first gateway. It should not be use=
full=20
> to mangle the packet later.

well, there is one problem... once you have IP_DF set, the Fragment ID
is believed to be ueseless.  Linux in fact is setting it to zero, at
least in some cases, for performance reasons (contention on the id
counter).  So I could  imagine some weird implementations that would
then discard the IPid at some later point in the forwarding path of your
packet.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAFkC3XaXGVTD0i/8RAhy7AKCQlOUESbbeAYKMCU7AxmNOSbEa2QCgpRWR
PlFXZAidhZhv6uA7OkJpbRM=
=INHo
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
