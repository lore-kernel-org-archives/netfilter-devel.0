From: Harald Welte <laforge@netfilter.org>
Subject: Re: [RFC] [NETFILTER] nf_conntrack: more efficient helper lookup
Date: Mon, 13 Feb 2006 12:33:17 +0100
Message-ID: <20060213113317.GV4601@sunbeam.de.gnumonks.org>
References: <20060212181648.GH4601@sunbeam.de.gnumonks.org>
	<43EFA7E6.7040909@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Yg8W10oK6rlW0RR"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
Content-Disposition: inline
In-Reply-To: <43EFA7E6.7040909@eurodev.net>
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


--+Yg8W10oK6rlW0RR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 12, 2006 at 10:25:58PM +0100, Pablo Neira Ayuso wrote:

> Just a remark if this patch goes forward. The bits to make
> nf_conntrack_netlink work with this new layout are still missing :(.
> Anyway this is not the point now ;)

yes, thanks for the reminder.

> > +/* normally the number of helpers is small, so we try to save some cac=
he */
> > +#define NFCT_HELPER_BUCKETS 	8
> > +#define NFCT_HELPER_INITVAL	0x23424223
> > +static struct hlist_head *helpers;
>=20
> Since the number of helpers is really small, I'm not sure about the
> benefits of this patch. The hash calculation adds a constant to the
> algorithm complexity that could result in a similar execution time for
> this and the current approach. A benchmark could throw some light on this.

Yes.  Some thoughts:

First, I tried with some easy modulo hashing in order to save some
overhed, but the distribution of the existing helper port numbers was
not very good in such a hash :(

The number of registered helpers is expected to grow quite a lot in the
near future, when userspace helpers will exist.

> What about just killing the tuple and mask fields and keep the current
> approach of the helper list?

Even if we only have three or four helpers loaded, for every new
connection we iterate over all four helpers just to know that we have no
helper for this connection.  Since every helper is in a separate kernel
module, that's four more cache misses for every new connection.

A hash table [with a good distribution and reasonable size] should get
that down to an average of 1 for every new connection.  Maybe the bucket
heads are already in cache, and for the most common case (no helper) we
get the lookup almost for free.

So I still think it's worth the effort, even though jenkins hash might
be overkill.

If anybody wants to do benchmarks on this, I'm very eager to see the
results.



What is a way bigger problem is the expectation matching (all expecteds
are one linked list).  In a loaded real world system, chances are high
that the number of expectations is way bigger than the number of
helpers.  Also, a system can easily be forced into a high number of
expectations (by creating dozens of masters with one unconfirmed expect
each).

Patrick and I had some thoughs on this, but the problem is reasonably
non-trivial.  We cannot fully avoid the tuple/mask matching, which
precludes something like an easy hash table.

The intermediate conclusion was to dynamically keep track of which masks
helpers use to register their expectations, and then create one hash
table per mask.  So in the end we would have N lookups into N different
hash tables when we have N different masks.

Maybe we can even just use different hash functions and hash into one
table, that's not fully thought through yet.

Also, it helps to cut back on the number of possible choices.  A helper
is unlikely to use anything else but 0 or 0xffff for a port number, so
we can reduce the port numbers to 2 bits (1 source, 1 dest).

As for IP addresses, all but the netbios helper use only 0 or
0xffffffff, so they could be restricted to 1 bit, too.  This would only
mean 5 bit of different masks, a total of 32 lookups in the very=20
unrealistic worst case.

As for the netbios helper, we probably need to keep the linear list
around as a fallback.

This sounds a bit complicated, but it's the best we've been able to come
up with so far.  There's definitely the need to optimize the expect
lookup. though.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--+Yg8W10oK6rlW0RR
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFD8G59XaXGVTD0i/8RApscAKCv7AD8d7Wmqpcy/Dfv9egArpjZGwCgjLMe
PaebowP9br3EKc650D1pRXI=
=Qa9t
-----END PGP SIGNATURE-----

--+Yg8W10oK6rlW0RR--
