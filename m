From: Harald Welte <laforge@netfilter.org>
Subject: Re: maintaining per rule counters
Date: Sun, 13 Apr 2003 18:36:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030413163632.GY1922@sunbeam.de.gnumonks.org>
References: <3E958792.8040501@Linux.ie>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dXvu6+ixFx2ZffE8"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Padraig@Linux.ie
Content-Disposition: inline
In-Reply-To: <3E958792.8040501@Linux.ie>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dXvu6+ixFx2ZffE8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 10, 2003 at 04:02:42PM +0100, Padraig@Linux.ie wrote:
> Hi I'm afraid I can't subscribe to the mailing list at present?
>=20
> Anyway I have a fairly simple requirement to maintain per
> rule packet & byte counts that are timestamped and sent
> to userspace every 1ms (packet clocked).
>=20
> My question is where is the best place to store the 1ms of counters.
> Can I create a target module and put the data in the *targinfo
> I.E. is targinfo global to the target module or per rule.

it is per rule.  if you want something global, you need to dynamically
allocate some private memory at module load time (or rule load time).

> The ideal would be if it was dynamically allocated per rule and
> was just big enough for my counters+timestamp. What determines
> the size?

it is not dynamically allocated per rule, but once allocated per rule in
which it is used.

> cheers,
> P=E1draig.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dXvu6+ixFx2ZffE8
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+mZIQXaXGVTD0i/8RAoLXAJ0cwqNcVt2vfIR6SYzwmypBtp6MyACgp7tN
fagM6iF+9/qPsxsTXBNCVJk=
=pjaP
-----END PGP SIGNATURE-----

--dXvu6+ixFx2ZffE8--
