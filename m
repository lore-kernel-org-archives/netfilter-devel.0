From: Harald Welte <laforge@netfilter.org>
Subject: Re: [nkukard@lbsd.net: Re: Experimental RTSP modules]
Date: Sat, 24 May 2003 14:11:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030524121126.GB3077@sunbeam.de.gnumonks.org>
References: <20030524074054.GB14062@lbsd.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UJXkkAiHhNbsaLO7"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nigel Kukard <nkukard@lbsd.net>
Content-Disposition: inline
In-Reply-To: <20030524074054.GB14062@lbsd.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--UJXkkAiHhNbsaLO7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, May 24, 2003 at 09:40:54AM +0200, Nigel Kukard wrote:
> > >  * IPv6 modules
> >=20
> > ipv6 is not supported by conntrack or NAT, so I guess that's going to be
> > hard to support :)  This is has been discussed quite a number of times
> > on the devel list.
> >=20
> > > Hints for implementing IPv6 conntrack and nat modules especially appr=
eciated
> > > (why are there no IRC or FTP modules for IPv6?)
> >=20
>=20
> hrmmm... what is missing in supporting IPv6? Ok, I've read most of the po=
sts
> about code duplication if you copied IPv4 and modified it to support IPv6,
> changing all the function names along the way. Maybe we should have a=20
> discussion about how to move forward? What needs to be done, planning ...=
=20
> etc to integrate the IPv4 and new IPv6 conntrack into 1 easy to use inter=
face.

Well, what is basically clear is that we don't want a simple 'port' to
IPv6.  The new conntrack should be layer 3 independent.  So abstracting
it on level higher (like we now have layer 4 modules like
ip_conntrack_proto_tcp.c, we should have something like
net_conntrack_l3proto_{ipv4,ipv6}.c).

This way the connection tracking code can be used for any other kind of
connection (think about LLC, ...) and also for connections with two ends
in different layer 3 protocols.  IPv4 <-> IPv6 transition NAT people
would definitely like that.

The biggest problem we introduce is:  Yet a bigger ip_conntrack, because
the tuples will grow. instead of two 32bit addresses  we now have two
128bit addresses.  This means 48 bytes more per conntrack entry,
independent if it is ipv6 (and really needs that space) or isn't (and
has empty space.

Solutions?  Well, we could have differently-sized conntrack structs,
depending on their l3 protocol(s).  This would mean we'd have to shift
l3 specific members to the end of the structure, and all generic
members to the front.  Then have one slab cache for every l3 protocol.

> I would be more than happy to lend a few of my developers to help with IP=
v6=20
> support. Most of our work revolves around networking under linux, and we
> are busy moving over to IPv6, so it will help every1.

This sounds extremely interesting :)

> Regards
> Nigel

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--UJXkkAiHhNbsaLO7
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+z2FuXaXGVTD0i/8RApCNAKCs9+x9qBbtpu19mHvhnOFeW1LjnACdG1Vb
WVn8+5eVmtUtB1ysMw3JHhE=
=hsNf
-----END PGP SIGNATURE-----

--UJXkkAiHhNbsaLO7--
