From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] patch-o-matic
Date: Wed, 30 Jul 2003 16:33:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030730143323.GE4553@sunbeam.de.gnumonks.org>
References: <3B4E2B56.6050109@earthlink.net> <3B4ECEDB.8FF5096C@marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
Cc: Brad Chapman <kakadu@earthlink.net>,
	=?iso-8859-1?Q?Ga=EBl?= Roualland <gael.roualland@dial.oleane.com>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <3B4ECEDB.8FF5096C@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 13, 2001 at 12:35:07PM +0200, Henrik Nordstrom wrote:

> Problem is that the common ip_conntrack structure includes helper and
> protocol specific data, and there is no way of registering new
> variants without patching include/linux/netfilter_ipv4/ip_conntrack.h
> and recompile everything dependent on conntrack.

yes.  I remember having a discussion with Rusty about this in 2001.  We
den decided to consider this as a feature.  If you could add any
conntrcak/nat helper without recompiling the kernel code, you make it
too easy for 3rd parties to ship binary-only conntrack/nat helpers.

> This could be solved by separating the helper and protocol data from the =
main
> conntrac structure (use opaqueue pointers instead of unions). Probably a =
good
> idea as it would lessen the memory usage for "plain" entries, but it adds=
 some
> extra memory and CPU overhead when there is helpers involved,=20

Yes, this is certainly an interesting idea.  But it would definitely
make the code more complex.  We would then have struct ip_conntrack,
struct ip_conntrack_expect - and again something else.

The helper could tell the core how many bytes it needs.  The core would
then create a slab cache for objects of this size. =20

Alternatively you could also glue the variable sized part to the end of
the structure and then have slab caches for 'plain conntrack' and
'conntrack+helper'.  This would get the number of allocations down to
one.  However, we would need some flag inside struct ip_conntrack to
know to which slab cache we return the object when calling
kmem_cache_free().

> plus it makes it slightly harder to write helpers (one have to
> typecast to get access to the helper data).

I wouldn't care about that.  You also need to do this in case of
writing iptables matches/targets (matchinfo).  And somebody diving into
the complexity of writing conntrack/nat helpers certainly has no problem
with adding a typecast to their code.

> Henrik Nordstrom
> MARA Systems AB
> Sweden

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/J9czXaXGVTD0i/8RAmFfAJ96nSl1/RVF2oHhFeV1PLqdolBVyQCgjwsL
3Rpuh1Ppf7WpL9cqF2LEjD8=
=bN9F
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
