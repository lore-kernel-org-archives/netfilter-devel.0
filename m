From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 4/7] add missing module_alias_subsys
Date: Sat, 5 Nov 2005 13:28:27 +0100
Message-ID: <20051105122827.GC16000@sunbeam.de.gnumonks.org>
References: <436BA1C1.8070806@netfilter.org> <436C5FBC.70804@trash.net>
	<20051105115337.GB16000@sunbeam.de.gnumonks.org>
	<436C9DD6.8090101@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oTHb8nViIGeoXxdp"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <436C9DD6.8090101@trash.net>
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


--oTHb8nViIGeoXxdp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 05, 2005 at 12:56:06PM +0100, Patrick McHardy wrote:

> > This unfortunately doesn't work with the current architecture, where
> > every nfnetlink subsystem can specifiy the required capabilities per
> > message.  That specification isn't available before loading the module,
> > though.
>=20
> Didn't we decide to remove the per-subsys capabilities and make all
> of them require CAP_NET_ADMIN?

We did?  I knew we were talking about it, but I must have forgotten the
result, sorry.

> That also a possiblity, but I can't think of a case where we wouldn't
> insist on CAP_NET_ADMIN, so just removing the whole per-subsys
> capabilities seems easier to me.

Mh, ok.  But you owe me a beer if we ever need to re-introduce it ;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--oTHb8nViIGeoXxdp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDbKVrXaXGVTD0i/8RAnE2AJ9vwjrbWu7/kCqelqKCEa5idqoEFgCeKCfd
wVbTG27/fu72vqTPCNnm9R4=
=3z7Q
-----END PGP SIGNATURE-----

--oTHb8nViIGeoXxdp--
