From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 2.4/2.5]
Date: Mon, 30 Jun 2003 14:05:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030630120556.GI2645@sunbeam.de.gnumonks.org>
References: <1056913883.1068.70.camel@exile> <1056915465.9614.59.camel@pc> <1056918054.1068.96.camel@exile> <1056918710.23456.80.camel@pc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s3mRlGd9ha2FBBsw"
Cc: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Content-Disposition: inline
In-Reply-To: <1056918710.23456.80.camel@pc>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--s3mRlGd9ha2FBBsw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 29, 2003 at 04:31:50PM -0400, Brian J. Murrell wrote:
> On Sun, 2003-06-29 at 16:20, Filip Sneppe (Cronos) wrote:
> > Well not a lot of common scenarios, I will give you that, but
> > I just figured that in some situations, people run services=20
> > on different ports, not the standard ports the services are normally
> > associated with. Sometimes because those ports are blocked by
> > another firewall, sometimes to confuse portscanners.
>=20
> That is all fair enough I suppose.  I have no specific objection to it,
> just didn't do it myself because I could not see the need.  If Harald
> (and/or the core team) see fit, I have no objection to adding it.

I don't really see the need for such a patch unless the port numbers
used by amanda can be tuned somehow (by an amanda server/client config
file).   I'm not that familiar with the amanda suite, could somebody
please investicate this?

I mean, if we really need any helper to be working on any port, we
could even think of a more generic mechanism (like making helpers target
of a special table ('helper' with only one chain).... there you could do
stuff like=20
'iptables -t helper -j HELPER --helper-name ftp -p tcp --dport 21'

> Brian J. Murrell <netfilter@interlinx.bc.ca>

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--s3mRlGd9ha2FBBsw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE/ACekXaXGVTD0i/8RAkIyAKCXANrsJfNOr0CrIcKAiqAUfzTKRwCgodpf
ar+sO79hU20g3b4QVX/VcUw=
=6Uu9
-----END PGP SIGNATURE-----

--s3mRlGd9ha2FBBsw--
