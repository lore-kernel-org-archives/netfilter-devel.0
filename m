From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] message parsing functions for nfqueue
Date: Fri, 12 Aug 2005 14:04:22 +0200
Message-ID: <20050812120422.GE16325@rama.de.gnumonks.org>
References: <1123794106.4980.11.camel@porky> <42FBFBAD.8020807@netfilter.org>
	<11702.195.25.48.253.1123836176.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dFWYt1i2NyOo1oI9"
Cc: netfilter-devel@lists.netfilter.org, Vincent Deffontaines <vincent@inl.fr>,
	Pablo Neira <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <11702.195.25.48.253.1123836176.squirrel@mail.inl.fr>
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


--dFWYt1i2NyOo1oI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 12, 2005 at 10:42:56AM +0200, Eric Leblond wrote:
> > Eric Leblond wrote:
> >> This is a patch against libnfnetlink_queue.
> >>
> >> It adds "high" level functions to access to the data contained in a
> >> nfqueue message. These are mostly encapsulation of NFA macros.
>=20
> > Instead of adding a function to access every attribute like above, why
> > don't we add something more generic in libnfnetlink? Like the following
> > macros:
> >
> > Maybe too generic ?
>=20
> In a way, yes, you will only access to things one at a time, and when you
> want the payload you also want to know its size.
> But I think such functions are needed to be able to have an evolving API.
> I will try to work on it.

I like the generic macros proposed by Pablo, but making nfnetlink_queue
users directly use them is somewhat of a layering violation.

The application shouldn't have to understand anything about netlink,
nfattrs, the nfnetlink wire format or anything else.  It's the job of
the API to hide all those details.  Ideally we don't even export any of
that information to the application, by putting it in private header
files.

Only this way we can make sure that if we'd ever have to change the
underlying mechanism [again], the applications wouldn't be affected -
they'd just link against a different libnfnetlink_queue.  This is not
too unlikely.  There were discussions about netlink2 as well as having
mmap() capability of netlink sockets.  Obviously nfnetlink_queue would
want to take advantage of that...

> > OTOH, if we add such high level functions we'll have to do the same in
> > other libnfnetlink_* libraries to keep homogeneity of the API.
>=20
> yes ...

I'm not actually too worried about homogenous API between all the
different libnfnetlink_* variants.  It's just _queue and _log which are
similar enough in functionality so that the API's would look very
similar.  But think about management of conntrack tables or even
pkt_tables at some point... they serve a totally different purpose, and
the API will look different.

One thing that somebody could look into (if there are any volunteers) is
thread-safety of libnfnetlink{,_queue,_log}.  There will be users who
want to use multithreaded programs, once this takes off.

I've personally never believed in multithreading anyway (I'm more a
select/poll kind of guy), so I'm certainly not the best person to get
those libs threadsafe...

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--dFWYt1i2NyOo1oI9
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC/JBGXaXGVTD0i/8RAnr9AKCDODZvBbTBzpFOkIOIc64Bo4DrsACdEx8c
ZvyjDOsaswrK7MOftNUdepU=
=qjTz
-----END PGP SIGNATURE-----

--dFWYt1i2NyOo1oI9--
