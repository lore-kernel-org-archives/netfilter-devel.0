From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] netbios broadcast connection tracking module
Date: Tue, 26 Oct 2004 11:42:05 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041026094205.GM18934@sunbeam.de.gnumonks.org>
References: <1098175785.6562.60.camel@greebo.homeip.net>
	<1098206621.1108.105.camel@tux.rsn.bth.se>
	<1098214482.6562.125.camel@greebo.homeip.net>
	<20041022105504.GC3551@sunbeam.de.gnumonks.org>
	<1098782757.6562.310.camel@greebo.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="It12YA6C1mwhTBLD"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Larsson <alexl@redhat.com>
Content-Disposition: inline
In-Reply-To: <1098782757.6562.310.camel@greebo.homeip.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--It12YA6C1mwhTBLD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 26, 2004 at 11:25:57AM +0200, Alexander Larsson wrote:
> On Fri, 2004-10-22 at 12:55 +0200, Harald Welte wrote:
> > Hi!
> >=20
> > First of all, let me say that I am much in favour of a conntrack helper
> > than an ipt_recent-based solution.
> >=20
> > > Hmm. I though by setting max_expected to 0 would allow me to get
> > > multiple expected replies, but i could easily have misread the code. =
Is
> > > there no way to expect multiple packets in reply to a single udp
> > > package?
> >=20
> > you just need to re-issue the expectation as soon as it is confirmed by
> > the first packet (from the expectfn).  If I'm not mistaken, there are
> > already helpers doing that, although I forgot which ones.
>=20
> I've been experimenting a bit here. And it seems that it *does* accept
> several packages after calling ip_conntrack_expect_related(), before the
> timeout is passed (although expectfn is only called once). At least if
> the packages are from the same ip.
>=20
> I took a look at ip_conntrack_ftp.c, and it only calls
> ip_conntrack_expect_related() from "help". Does this mean it only
> accepts one related packet on the side-channel?. Actually, none of the
> in-tree conntrack helpers use expectfn.

expectations are on a connection level, not on a per-packet level.
However, broadcast packets don't have connections, since you send
packets to .255 and receive them back from inidividual ip addresses.
Since you don't know how many clients in the broadcast domain will
reply, you need to re-create the expectation every time it is confirmed
(via expectfn).

And yes, I didn't talk about the helpers in the official kernel, more
about stuff from patch-o-matic-ng

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--It12YA6C1mwhTBLD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBfhvtXaXGVTD0i/8RAutXAJ9a8tHZd1Q0KxDkJhWLo8cq9whRTACbBkaS
bjDHcGWiMV4PPfK/fexkhDs=
=rJSB
-----END PGP SIGNATURE-----

--It12YA6C1mwhTBLD--
