From: Harald Welte <laforge@netfilter.org>
Subject: Re: remaining libnetfilter_conntrack issues
Date: Sat, 29 Oct 2005 16:01:19 +0200
Message-ID: <20051029140119.GR4479@sunbeam.de.gnumonks.org>
References: <20051028205955.GA10568@rama.de.gnumonks.org>
	<43636EE7.20601@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TMJUm4hsTn/F+xXF"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43636EE7.20601@eurodev.net>
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


--TMJUm4hsTn/F+xXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pablo!

On Sat, Oct 29, 2005 at 02:45:27PM +0200, Pablo Neira wrote:
=20
> Harald Welte wrote:
> >I've started to write a new ulogd2 plugin against the new
> >libnetfilter_conntrack, and found a number of issues, mostly related to
> >header files:
> >1) why do we need 'asm/types.h'?  this is unacceptable
> >2) why do we need 'linux/if.h'?
>=20
> I just killed those.=20

thanks.

> I'm not aware of having added those by myself, my guess is that they are=
=20
> remains of the primitive libctnetlink.

yes, probably of the very old one.

> >3) libnetfilter_conntrack needs to be split into two parts:
> >	a) what is visible to application programs
> >	b) what is visible to extensions
> >4) if we do '3', we can get rid of the ugly "linux_list.h" include
>=20
> OK, now we have libnetfilter_conntrack.h and libnetfilter_conntrack_exten=
sions.h, have a look at=20
> the patch below. I'm going to commit it asap.

looks fine, thanks.

> >5) we'd ideally get rid of the ip_conntrack.h include, too
>=20
> I just did it, we just need the status bits. So I just took them from ip_=
conntrack.h

ok.  Ideally (even in future kernel releases), we should have this
information in a dedicated 'include file for userspace apps'.

> >6) we should ship a copy of both nfnetlink.h and nfnetlink_conntrack.h w=
ith the library
> >   this way userspace programs can be built without any
> >   nfnetlink-enabled kernel headers installed.
> >All copies should be performed during the 'distrib' stage, i.e. every
> >time we make a release we tell the automake/autoconf system where to
> >take a current copy of those headers from.  They would not be present in
> >svn.
>=20
> OK, so we could just do it in autogen.sh, that would be quite straight fo=
rward. fine with it?

yes, is fine, even though having it at 'make distrib' stage would be
more intuitive.

> >7) we put the definition of the 'nfct_handle' into a private header
> >   file. this is good practise for encapsulation, since it prevents the
> >   application from making any assumptions about its size and/or
> >   contents.
>=20
> Done

great.

> >8) IPv6 addresses are 128bit, not 64!
>=20
> Aiee, fixed as well.

;) I hope this saves us from having to break the library/applicaiton ABI wh=
en
nf_conntrack gets nfnetlink_conntrack support.

> I think we can release the first 1.0 version of conntrack this week, toge=
ther with the first=20
> release of libnetfilter_conntrack.=20

Yes, although I think it's fine if we still do some more review.
There's no reason to hurry with a 1.0 release as long as 2.6.14 has not
been released yet.  So I would still be happy if the 1.0 release happens
on the day of the 2.6.14 release ;)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--TMJUm4hsTn/F+xXF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDY4CvXaXGVTD0i/8RAhk5AJ46oZqYGZxcm9D2UJUDzD43e0gKtwCfS5VD
gI8GY+Ai1VYgb/FfIVjVuas=
=uxhs
-----END PGP SIGNATURE-----

--TMJUm4hsTn/F+xXF--
