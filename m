From: Harald Welte <laforge@netfilter.org>
Subject: Re: "ip_conntrack_core: Frag of proto 17." error and memory leak?
Date: Sun, 21 Sep 2003 17:04:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030921150458.GE22223@sunbeam.de.gnumonks.org>
References: <3F65EC33.2060906@wp.pl> <1064059876.2500.54.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QXO0/MSS4VvK6f+D"
Cc: c0g <c0g@wp.pl>,
	jozsef Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1064059876.2500.54.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--QXO0/MSS4VvK6f+D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2003 at 02:11:16PM +0200, Martin Josefsson wrote:
> Are you using the NOTRACK target in raw/PREROUTING?
>=20
> This is the only source of this I can see and it is indeed a bug. This
> message shouldn't be printed for this case. It doesn't defrag packets
> and calls get_tuple() for all packets, even the fragments and
> get_tuple() barfs. This causes only the first fragment to be marked as
> untracked and leaves the rest of the fragments to conntrack which tries
> to defrag them but that won't succeed since conntrack will never see the
> first packet. And thus the kernel keeps lots of fragments in memory
> until they time out and are dropped.

Mh. So why does it call get_tuple() anyway?  To check if the tuple is
taken (i.e. the packet is part of an already tracked connection)?  I
think we can safely split this check, since

1) it tries to work around an obvious misconfiguration by the user
2) it adds significant runtime cost to the NOTRACK target (call
   get_tuple, which calls in turn the l4 protocol helper get_tuple, then
   tuple_taken(), which in turn locks the conntrack lock, ...)
3) it introduces the problem above.

Yes, we can still try to make it work, even with that check.  But I
think we can just skip it and make our life easier.

Jozsef?

btw: I wan to merge the 'raw' table userspace changes into iptables
before 1.2.9 is released... All we need to make it compile even on a
non-rawtable-kernel is:

#ifndef IPT_CONNTRACK_STATE_UNTRACKED
#define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_IS_REPLY+3))
#endif

in one of our (userspace) header files.

> /Martin

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--QXO0/MSS4VvK6f+D
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/bb4aXaXGVTD0i/8RAgr+AKCyqqJs59wwvwhGNMeNs+4ZWkz+0QCdEB19
FzBW9lTASDzoo+pWcyBf2iw=
=t2od
-----END PGP SIGNATURE-----

--QXO0/MSS4VvK6f+D--
