From: Harald Welte <laforge@netfilter.org>
Subject: Re: TARPIT on linux-2.6
Date: Wed, 15 Oct 2003 15:32:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031015133223.GB14807@obroa-skai.de.gnumonks.org>
References: <0e2701c392ee$3e198f00$d800a8c0@edumazet>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dada1 <dada1@cosmosbay.com>
Content-Disposition: inline
In-Reply-To: <0e2701c392ee$3e198f00$d800a8c0@edumazet>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2003 at 09:30:42AM +0200, dada1 wrote:
> It seems linux-2.6 made some changes on ip_route_output() stuff, that I d=
ont
> understand at all to try my own patches... :)

yes, patch-o-matic is currently only for 2.4.x kernels, sorry.

I'm in the process of re-implementing the 'runme' script in perl, in
order to allow for 2.6.x compatible patches.  After this system has been
put in place, all new development will _really_ be based on 2.6.x
only... and patch-o-matic for 2.4.x will mostly stay like it is today.

security patches and bugfixes will move out of patch-o-matic and be
distributed as standard patches against every kernel release.

> Thanks
> Eric Dumazet

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/jUxnXaXGVTD0i/8RAgafAKCk8f/3Blxs+nTc605CoV9aNadZVQCgklF+
r94FlpSagApld2URI96Pkt8=
=n7TK
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
