From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
	infrastrure for netfilter]
Date: Mon, 10 Jan 2005 22:28:07 +0100
Message-ID: <20050110212807.GZ18568@sunbeam.de.gnumonks.org>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nKvJs6ze6az+4fwY"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <41E2E631.3060102@trash.net>
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


--nKvJs6ze6az+4fwY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 10, 2005 at 09:31:45PM +0100, Patrick McHardy wrote:
> >Actually, what is the opinion that nf_conntrack uses the union of IPv4 a=
nd
> >IPv6 addresses in the tuples?
> >
> In my opinion that's something that could also be improved later.

Agreed.

> >The infrastructure is there in the patch to support IPv4/IPv6 conntrack
> >separatedly in spite of the common code and not to waste so many bytes at
> >every IPv4 connections for the sake of supporting IPv6.
>
> You mean the get_features stuff and seperate caches ? I'm don't like this
> part very much, I thing Rusty's "structure extension stuff" (ct_extend)
> is a nicer way to do this, although its probably not useable for the tupl=
es.

Unfortunately I have to disagree.  I think I pointed it out in an
earlier email, but I'm not sure whether it was on IRC or whether you've
been on the list of recipients.

the nf_conntrack approach of having multiple slab caches of differently
sized conntrack structures is better from a performance point of view.

If you look at the typical applications, people will usually

a) either use NAT on most/all of their connections
b) or not use NAT on any of their connections

Now why don't they (the 'b' users) recompile their kernel? Because they
use vendor-kernels, and they compile with everything enabled.

So what we end up if we use rusty's scheme for nat private data, is that
we have at least one additional allocation, and two disjunct seperate
pieces of memory (which will probably also introduce yet another cache
miss).   This is acceptable for rare exceptional cases, not for 99.9% of
your connections.

So even if Rusty's architecture and API is cleaner, I'm very much in
favour of the nf_conntrack design and Yasuyuki's current
implementation.

Now you can argue about conntrack/nat helper private data.  Here my
argument is weaker, since normally you have something like < 1% of your
connections with a helper.  For this I would be willing to accept the
additional allocation and whatever.

But, then think of a firewall in front of an FTP (IRC/...) Server, and
your traffic pattern immediately looks like 50% of your connections (not
talking about traffic) have helper private data... and my argument
becomes stronger again.

> I think we should put ip_conntrack in maintenance mode, than we can
> resync nf_conntrack and make changes like this before we submit it.

At last, we again agree :)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--nKvJs6ze6az+4fwY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB4vNnXaXGVTD0i/8RAo21AJ9pVXfsUtIOjJnd6m5ukHzsdoJGOACgkIUE
0hJbxjraD9vjngtpfKCTEzA=
=oc7W
-----END PGP SIGNATURE-----

--nKvJs6ze6az+4fwY--
