From: Harald Welte <laforge@netfilter.org>
Subject: Re: RFC: NAT configuration over ctnetlink
Date: Wed, 10 May 2006 21:16:46 +0200
Message-ID: <20060510191646.GB29531@sunbeam.de.gnumonks.org>
References: <4451BA40.4050207@trash.net> <445388B9.2010308@netfilter.org>
	<4457677D.7060607@trash.net> <44578E0C.5070705@netfilter.org>
	<4457926D.5010209@trash.net> <4457EBF9.3080606@netfilter.org>
	<4458B2BB.8000407@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4458B2BB.8000407@trash.net>
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


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 03, 2006 at 03:40:11PM +0200, Patrick McHardy wrote:

> Another item I would like to bring up for discussion is whether we
> want to continue with (some) of these libraries at all. For a small
> pet-project of mine I've been working a bit on Thomas Graf's libnl,
> which provides a very nice netlink infrastructure, support for
> basically all kernel netlink interfaces, nice object representation
> of the individual items, cache management for replication of kernel
> databases, and quite a few things more. Besides lots of nice
> infrastructure, one main advantage of using libnl would be that
> there is a single library which can be used for communication with
> any kernel subsystem using netlink in a uniform way.

well, certainly that work is interesting.  However, I don't really see
how this fits into the picture.  First of all, nfnetlink is different in
that it has its peculiar byteorder.  Also, we specifically divided the
libraries into separate packages so they can be updated independently.
It is unlikely that conntrack bugfixes affect logging and vice versa.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFEYjweXaXGVTD0i/8RAgwpAJ9aRCLSPCqUgAWpxZu7J9rdcQ9D4wCfYyHk
I493S909zYQ0LpLcWLHTaVo=
=34yj
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
