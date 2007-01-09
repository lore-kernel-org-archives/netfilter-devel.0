From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] libnfnetlink and iface conversion to string
Date: Tue, 9 Jan 2007 12:51:20 +0100
Message-ID: <20070109115120.GX7655@prithivi.gnumonks.org>
References: <1167257854.31765.21.camel@localhost>
	<45940145.3020003@netfilter.org>
	<1167349247.15420.13.camel@localhost>
	<20070107142607.GC13543@prithivi.gnumonks.org>
	<1168296086.12298.6.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Vincent Deffontaines <vincent@inl.fr>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <1168296086.12298.6.camel@localhost>
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


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 08, 2007 at 11:41:26PM +0100, Eric Leblond wrote:
> Hi,
> Le dimanche 07 janvier 2007 =E0 15:26 +0100, Harald Welte a =E9crit :
> > On Fri, Dec 29, 2006 at 12:40:47AM +0100, Eric Leblond wrote:
> > > It will add 4*IFNAMSIZ =3D 64 octets to each nfnetlink_queue message =
but
> > > this is not impressive as a part of the packet payload is usually sen=
t.
> >=20
> > No, please don't do that. =20
> > Also, I _really_ want to get rid of interface names throughout
> > netfilter/iptables at some point in the future.  all 'next generation'
> > subsystems (such as all nfnetlink based services) should just deal with
> > ifindexes.
> >=20
> > Please put some functions into libnfnetlink, even if it doesn't natively
> > belong there.   If there's more netlink unification, we can always make
> > those just wrappers for the 'real new unified' ifindex/name resolving
> > functions.
>=20
> I've thought at this solution before getting interessed by pablo's
> suggestion. But I've got a conception problem.
>=20
> It is not correct to do a dump (and send a netlink message) for each
> ifindex resolution. Thus, libnfnetlink needs to listen to netlink
> interfaces message. A permanent "task" is thus needed to have the job
> done : It can be a dedicated thread or a carefully hidden select.

the latter, a caerfully hidden select.  I actually have code for this,
which I am allowed to release under GPL (was written as part of a
non-gpl project)

I have committed that code to svn:
http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/libnfnetlink/src/
rtnl.c and iftable.c

However, I never found the time to integrate them intl libnfnetlink, so
they remained dead code for the last 16 months :(

> In fact, if we omit the thread approach which is somehow intrusive, I
> don't see a way to do this via a simple call to added functions.

It isn't all that difficult to keep a in-memory list of name-ifindex
mappings.  You once dump at startup, and then listen to events...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFo4G4XaXGVTD0i/8RApS/AJ91np+QQ8LU7Dh27lEBtWSV4LkQQACdFnis
zOb2LC5LsMfnjDQK6hTJJUc=
=H8Hn
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
