From: Harald Welte <laforge@netfilter.org>
Subject: Re: nf_conntrack
Date: Wed, 25 Feb 2004 16:05:54 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040225150554.GC13386@sunbeam.de.gnumonks.org>
References: <200312240144.KAA15346@toshiba.co.jp> <20040224092137.GU13386@sunbeam.de.gnumonks.org> <200402251247.VAA25777@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6xASvDhwei36Ydys"
Cc: netfilter-devel@lists.netfilter.org, rusty@rustcorp.com.au,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Content-Disposition: inline
In-Reply-To: <200402251247.VAA25777@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--6xASvDhwei36Ydys
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 25, 2004 at 09:47:26PM +0900, Yasuyuki Kozakai wrote:
> When L3 protocol modules are registered, my implementation of
> "dynamic version" calculate the size of 2 tuple + nf_conntrack, and
> create caches. So

Oh sorry, I should have noticed that. =20

> 	$ cat /proc/slabinfo |grep nf_conntrack
>=20
> prints	"nf_conntrack:ipv4" and "nf_conntrack:ipv6".
>=20
> 1 chunk includes static part of nf_conntrack and 2 tuples.
> But memory spaces for helper, nat are statically allocated.
> Because I wanted to see the impact of dynamic allocating memory space
> for tuple, at first.

I think this is fine.  The 'extension structures' would be a further
optimization that are totally unrelated to ipv4/ipv6 generalization and
don't really fit this discussion then.

> But I think tuple of IPv{4,6} should be represented by one structure
> -- "struct nf_conntrack_tuple".

agreed.

> Your idea seems that ip_conntrack_tuple and ip6_conntrack_tuple are defin=
ed
> individually. Please see nf_conntrack_proto_tcp.c in my implementation.
> All functions can handle both tuples for IPv{4,6} . But if ip_conntrack_t=
uple
> and ip6_conntrack_tuple are defined individually, we have to define
> 2 version of each functions which do same thing and have just different
> type of argument "tuple".

I see, again agreed.

> This does't mean "Layer 3 independent".

;) well at least not for layer 4 protocol helpers.

> BTW, unfortunately, I can't spend time for this work this 2 months.

No problem, we're all busy with other stuff anyway.  But I think we
should finish the mising parts (I've read some FIXME's with regard to
helpers, are they still valid?) at about the time that 2.7.x forks off.=20

Could you write a small TODO list containing the Items that will yet

btw: I will put your current patch into patch-o-matic-ng. This means it
will probably get some more users.

> So I concluded it is desirable to be statically defined the structure
> of tuple.

Yes, indeed.

> It is efficient to keep the pointer to extension structure when allocating
> nf_conntrack instead of calculating offset every access to it.

Yes, that is an option.

> I think processing speed is more important for connection tracking than
> saving memory space. But you got a point that unused memory space should
> not be allocated.

The issue is mostly about wasting cache lines.  Memory is cheap, but
cache is very limited... ip_conntrack is currently 304 bytes of size.
If we could somehow get this down to 256 bytes, we would save a whole=20
cache line per connection, that's quite a lot.

Also, we have increasing demands for adding information to the conntrack
table.  Some people want to add counters in order to facilitate
connection based accounting.

> my opinions are
>=20
> 1. It is desirable to be statically defined the structure of tuple.

ok, you convinced me ;)

> 2. Your idea about extension structure (L3/helper/nat union) is acceptabl=
e.
>    I expect that this impact to performance is small.But I worry about
>    slowdown in the case of "nat helper union". When allocating conntrack,
>    it is difficult to figure out whether conntrack will be processed or n=
ot
>    by nat helper module. So I expect that it is needed to reallocate and =
copy
>    conntrack before nat helper module processes it.

it's actually not that difficult.  When we allocate a conntrack, we
already know the tuple.  And from the tuple, we already know if there is
a conntrack helper.  So let's just assume if iptable_nat is loaded and
we have a conntrack helper responsible for this tuple, we will later
need the nat helper union.  There are few protocols that only have a nat
helper but no conntrack helper.  In that case one would have to either
re-allocate, or force them to have a dummy conntrack helper.

We really should optimize for the non-nat non-helper case, since it is
by far the most common case.  It's just a pity that we're currently
wasting so much memory/cache for 90% of all connections that don't even

>    On the other hand, there is no problem about "nat union" (=3D ip_nat_i=
nfo).
>    Because if nat module is loaded, all conntrack certainly have
>    "null-binding" or "binding" which specified by user. So conntrack
>    core module always need to allocate memory space for "nat union" in
>    this case.

Yes, but what happens in cases where you alrady have entries in the
conntrack table at the time of loading iptable_nat ?  Then the old
conntracks don't have the nat union, ... - but I think these are minor
issues that could be resolved.

> Regards,

Thanks for your feedback.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--6xASvDhwei36Ydys
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAPLnSXaXGVTD0i/8RAgr6AKCa6hUteDyFw7TpZ3hxrbzbW8RozgCcDuaE
h+b0HvtgJqrHAfbaZUMMRMM=
=C+2Q
-----END PGP SIGNATURE-----

--6xASvDhwei36Ydys--
