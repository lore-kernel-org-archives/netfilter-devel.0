From: Stephen Frost <sfrost@snowman.net>
Subject: Re: Talking about recent (was: Re: [PATCH] 2.4.x new amanda conntrack + NAT support)
Date: Mon, 7 Apr 2003 12:46:26 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030407164626.GS18434@ns.snowman.net>
References: <20030330200750.GZ7718@sunbeam.de.gnumonks.org> <20030331.070910.52982765.davem@redhat.com> <3E894C92.5010801@rtij.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T2qahi4UwJNXfvXD"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
Content-Disposition: inline
In-Reply-To: <3E894C92.5010801@rtij.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--T2qahi4UwJNXfvXD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Martijn Lievaart (m@rtij.nl) wrote:
> >Harald, what is the state of ipt_recent?  Will I see it soon?
>=20
> Talking about recent, I'm not completely happy with the way it is now.=20

I don't think you've looked at ipt_recent in quite a while...
tables->side was done away with a long time ago and the current version
does exactly what you describe.  I think it was changed in 0.2.6 or
0.2.7 (that was before it was all in my own CVS tree).  The initial
intent really had been to have it be specified on the command-line but I
wasn't entirely thinking straight when I added it. :)

> installations. I think I see a way of making this work without breaking=
=20
> any compatibility. I'll submit a patch once I have it working, based on=
=20
> the new recent module.

Personally I doubt existing installations will be broken but if you want
to develop a patch to make them work just in case please do so against
the ipt_recent CVS at
http://cvs.snowman.net/cgi-bin/viewcvs.cgi/ipt_recent/ to avoid making
alot of extra work for me to merge it.

> Why is this useful? F.i. track all outgoing connections and reject with=
=20
> tcp reset incomming idents that match the table. Otherwise fall through=
=20
> to the default drop. This would need a reversing of source and=20
> destination between the --set and the --rcheck. This would allow a real=
=20
> stealthy firewall that still handles idents in a sane way. I once looked=
=20
> at creating a helper for this, but that would need some major surgery on=
=20
> the iptables core I think. Using the recent match would be a rather=20
> clean solution at the cost of some additional memory used. Also, other=20
> dynamic protocols could be made a little safer by this as well, pending=
=20
> a real contrack helper.

I actually use ipt_recent for exactly this currently with both IRC/ident
and sendmail/ident.  Amusingly enough it doesn't actually work
everywhere because, for example, if you establish an outbound SMTP
connection to a mail server you may get an ident response back from a
different IP address because of a poorly set up NAT.  In general it
works quite well, just be aware of that situation when you're wondering
why these ident packets aren't going to the right place. :)

	Stephen

--T2qahi4UwJNXfvXD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+kathrzgMPqB3kigRApIQAJwLQb4cIfmA3C3BrpzewFOk7qlRAQCeOjg3
nUap0/nO/8dOeB2vwwxEF2g=
=Y6dq
-----END PGP SIGNATURE-----

--T2qahi4UwJNXfvXD--
