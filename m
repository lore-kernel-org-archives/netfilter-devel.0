From: Harald Welte <laforge@netfilter.org>
Subject: Re: Making ip_queue l3 independent
Date: Sun, 24 Aug 2003 11:01:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030824090106.GA10987@sunbeam.de.gnumonks.org>
References: <20030823210022.GA6750@sunbeam.de.gnumonks.org> <Mutt.LNX.4.44.0308241738460.20308-100000@excalibur.intercode.com.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Cc: coreteam@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Morris <jmorris@intercode.com.au>
Content-Disposition: inline
In-Reply-To: <Mutt.LNX.4.44.0308241738460.20308-100000@excalibur.intercode.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 24, 2003 at 05:51:27PM +1000, James Morris wrote:
> On Sat, 23 Aug 2003, Harald Welte wrote:
>=20
> > James, what is your take on this?  What do you think?  If you agree, do
> > you have the time to do the change, or would you be fine if I'd work out
> > a patch?
>=20
> Yes it's a good idea.  Most of the code is indeed protocol independent,
> and things like the mangle function could be registerable as part of e.g.=
 =20
> nf_queue_handler_ops.

that was what I've been thinking about.

> It is unlikely that I would have time to work on this before 2.6.0, due t=
o=20
> other projects and the fact that I'm moving to the US in a few weeks. =20

ok.  I think I can spend some time on implementing the change.

> Please feel free to hack on the code.  Another potentially useful
> improvement would be to allow for multiple packet messages and verdicts,
> which I don't think would be difficult to implement (using the same or
> similar technique in your ulogd code).

Well, I think this can be added later on, as it doesn't really change
anything.

> It would be nice to maintain binary compatibility with current libipq, if=
=20
> possible.

Are you talking about userspace API compatibility to libipq, or binary
compatiblity on the netlink socket?

> - James

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/SH7SXaXGVTD0i/8RAt3VAJ9t5WKWXZg06PuHgaafaW9sUGJgcQCfX9oi
46TLoe2lzFADPVnxnq1BKrY=
=xQ+q
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
