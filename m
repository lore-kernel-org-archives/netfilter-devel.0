From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 16:48:42 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020144842.GK4914@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com> <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HmK7y6O+lKZIGkr"
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--+HmK7y6O+lKZIGkr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2003 at 09:17:36AM +0200, Jozsef Kadlecsik wrote:
> Hi,
>=20
> On Mon, 20 Oct 2003, Henrik Nordstrom wrote:
>=20
> > a) Assign a globally unique ID to each conntrack, in such manner that I=
Ds
> > is not reused for a significant amount of time. This to provide a stable
> > point of reference to a connection with low risk of false collisions if
> > the original connection was destroyed while userspace still thought it =
was
> > there.
>=20
> I still don't see why can't we simply use the tuple as unique id, as
> Harald suggested. That's truly unique and does not require additional
> fields in the ip_conntrack structure.

I think you are mixing up two seperate issues:

1) uniquely representing ip_conntrack during state replication between
master and slave.  Here the tuple is sufficient, since all state changes
will be processed in-order.  Since the tuple is always unique in the
hashtable, there is no mistake of updating/deleting the wrong one.

2) uniquely identifying an ip_conntrcak from userspace.
When userspace first dumps and then deletes by tuple, the tuple might
already have been reused.  This is what most of the discussion was
about, where a 64bit counter or the generation counter+address had been
suggested as possible solutions.

> On the developer workshop I presented my per bucket locking patch, with
> some performance comparison graphs. It's time to sync the patch and
> release it...

yes... can we first have the final raw and tcp-window-tracking patch?
It's probably already too late to get them in 2.6.x anyway... but let's
try.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+HmK7y6O+lKZIGkr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/k/XKXaXGVTD0i/8RAmknAJ9YO5QJ6GRlFKeXEoY7+JuYrNrxfgCfffOf
0/njfNOx3+YHGJqf9GZck5M=
=HZbN
-----END PGP SIGNATURE-----

--+HmK7y6O+lKZIGkr--
