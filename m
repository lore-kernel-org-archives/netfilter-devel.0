From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [PATCH] ctnetlink updates
Date: Fri, 29 Apr 2005 10:02:42 +0200
Message-ID: <20050429080242.GJ9735@sunbeam.de.gnumonks.org>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4eRLI4hEmsdu6Npr"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
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


--4eRLI4hEmsdu6Npr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2005 at 09:14:16AM +0200, Jozsef Kadlecsik wrote:
> I don't like id either. Conntrack can uniquely identified by
>=20
> - src/dst tuples, globally, even in a cluster
> - the pointer of the conntrack entry, locally

Yes, but not over time, i.e. if your cycle of reading the table and
issuing a 'delete' is long enough, then you could remove a connection
that was using the same tuple but was established meanwhile (after the
old died).  However looking at current timeouts, that would be more than
one or two minutes delat between read and delete.

My point of view is that we don't need the ID.  If there is too much
delay, well then the user has a certain risk.   If we would call it
'deleting a flow' then we'd be safe, since a flow has no start and
beginning, and multiple successive connections can comprise one flow ;)

> Looking at the last changes, I think it'd be much more better to port
> ip_queue to nfnetlink than to reserve another netlink ID: the hooks in
> nfnetlink are already there. I know that'd create backward compatibility
> issues at the existing queue applications, though... :-(

We've discussed that with David Miller at netconf'04.  The result was
that we can get another NETLINK family,  as there is a number of
obsolete/outdated ones in the kernel at the moment.  Also, if we keep
ULOG and ip_queue for now, and later migrate them into nfnetlink, there
will be again more free numbers.

ip_queue needs to be renamed to pkt_queue or nf_queue and made layer3
independent.  Same goes for ULOG.  Also, ULOG should no longer have a
fixed header containing interface names, ... but rather have that
in TLV's that are added according to the rule specified by the admin.

I've alsos been thinking of experimenting with a mmap'ed ring buffer for
ulog... at least it would be worth investigating at some point.

> Best regards,
> Jozsef

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4eRLI4hEmsdu6Npr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.0 (GNU/Linux)

iD8DBQFCceoiXaXGVTD0i/8RAv8aAJ9AL5vdqVyIoqLqB4XOXRGlhKAEbQCZAToY
ajG0KMh5Eq9C1N/pWCZen8k=
=m4zy
-----END PGP SIGNATURE-----

--4eRLI4hEmsdu6Npr--
