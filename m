From: Harald Welte <laforge@netfilter.org>
Subject: nf_conntrack resync with 2.6.11-rc4
Date: Tue, 15 Feb 2005 13:47:51 +0100
Message-ID: <20050215124751.GZ3829@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e9fMjeYs+GPci+mg"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
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


--e9fMjeYs+GPci+mg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yasuyuki!

Since lots of changes went into ip_conntrack over the last months, I
went through the pain of re-synchronizing nf_conntrack with
ip_conntrack, hopefully this was the last time.

The code that is now in svn (Version 3689) compiles fine with a
2.6.11-rc4 kernel here.  I didn't yet do runtime testing.  Yasuyuki,
could you please look into that?

I will really oppose any fundamental changes to ip_conntrack at this
point, unless the respectiva author submits patches for both
ip_conntrack and nf_conntrack.

It's still my position that we should merge it upstream ASAP (2.6.12),
even though some minor isues (like ct_extend vs. features) have not yet
been sorted out completely.  We don't have an experimental kernel
series, so we have to put it as EXPERIMENTAL into current 2.6.x.  This
gives us more exposure, and will make syncing with ip_conntrack changes
a more obvious duty :)

To give it even more testing, I'm now starting the work on implementing
IPv4 NAT on top of it - lots of users (including me) won't be able to run
it on their production routers without that feature :(

Cheers,
	Harald
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--e9fMjeYs+GPci+mg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCEe93XaXGVTD0i/8RAvhVAJ4yvCiQ19fvH/Rhm/Nm+2rdZE7j/gCeK3d7
JQ+Hp/FCSy+eYE/mM4cPEdM=
=wG5c
-----END PGP SIGNATURE-----

--e9fMjeYs+GPci+mg--
