From: Harald Welte <laforge@gnumonks.org>
Subject: Re: what's the lockingrules for ip_conntrack_expect_list?
Date: Sat, 12 Oct 2002 14:17:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021012141737.X13233@sunbeam.de.gnumonks.org>
References: <1034286048.25146.40.camel@tux> <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cEOOY/qhMBY6Rcxu"
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>; from kadlec@blackhole.kfki.hu on Fri, Oct 11, 2002 at 03:06:59PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--cEOOY/qhMBY6Rcxu
Content-Type: multipart/mixed; boundary="UDq0p1ry40hcSP8u"
Content-Disposition: inline


--UDq0p1ry40hcSP8u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2002 at 03:06:59PM +0200, Jozsef Kadlecsik wrote:
> Hi Martin,
>=20
> On 10 Oct 2002, Martin Josefsson wrote:
>=20
> > What's the lockingrules for ip_conntrack_expect_list?
>=20
> As far as I remember, the guiding rules were the following:
> ip_conntrack_lock is always held when we do something with the
> expectations. If it's write-locked, then there is no need for additional
> locking. If it's read-locked, then we use the additional
> ip_conntrack_expect_tuple_lock to protect the expectation lists.

Unfortunately I (the inventor of this second lock) don't even remember=20
the exact purpose anymore.  Sometimes I feel really stupid.  so let's go
read the code and my personal notes again...

I think the idea of the expect_tuple_lock() was to protect the tuple/mask
inside a struct ip_conntrack_expect.  This way we can implement
ip_conntrack_change_expect() without the need to grab a writelock on
ip_conntrack_lock. This is not jut an optimization, but absolutely necessar=
ry
for the NAT helpers:

We grab a readlock on ip_conntrack_lock and traverse the list of siblings.
For every sibling we call the nat helper function, which in turn wants to
alter the expectation by calling ip_conntrack_change_expect().  Altering the
expectation needs some kind of locking.  If we only had one lock, we would
need a writelock on ip_conntrack_lock.  Since there is no primitive for
atomically upgrading a lock from readlock to writelock, we would need to
grab a writelock before traversing the sibling list.  And this sucks, since
nobody else can do anything inside connection tracking for a very long time.

> > I've gone through 2.4.20-pre8aa2 which was the kernel the bugreport was
> > from. And I've found some inconsistencies.
>=20
> > init_conntrack
> > 	first:
> > 		WRITE_LOCK(&ip_conntrack_lock);
> > 		READ_LOCK(&ip_conntrack_expect_tuple_lock);
> > 		LIST_FIND
>=20
> Read-locking ip_conntrack_expect_tuple_lock is unnecessary here then.

Well, this is correct. But it's an optimiziation based on the assumption
that there is only one place where we WRITE_LOCK(&expect_tuple_lock),
which is in turn protected by READ_LOCK(&ip_conntrack_lock).  While this
is true now, I'm not sure that this is a good idea in general.

> > 	later:
> > 		WRITE_LOCK(&ip_conntrack_lock);
> > 		LIST_DELETE

This is OK, since list_delete doesn't read the tuple/mask inside this expec=
t.

> > ip_conntrack_expect_related
> > 	WRITE_LOCK(&ip_conntrack_lock);
> > 	LIST_FIND
> > 	LIST_FIND
> > 	list_prepend

This is clearly a bug, but works according to the optimization described=20
above.  I think we should either grab the tuple_lock or at least make=20
a verbose comment in the code describing why we don't grab it.

> > ip_conntrack_change_expect
> > 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
> > 	LIST_FIND
> >
> > 	FAILS!! called from nat-helpers which only hold their own locks
> > 	if any at all.

No.  The helper's help functions are called from do_bindings, which grab
a readlock on ip_conntrack_lock before traversing the list of expectations
matching this packet.  See also my comment above.

Please correct me if I'm overlooking something.

> Regards,
> Jozsef

Just for your info, I'm describing a  textfiles about my initial
thoughs on newnat locking..
=20
--=20
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--UDq0p1ry40hcSP8u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=newnat-problems
Content-Transfer-Encoding: quoted-printable


Problems with locking and the current multirel/newnat code

The general problem is that somebody, either the nat core or the nat helper
have to traverse the sibling_list of ip_conntrack and possibly modify this
list while traversing it.

While this is not unsolvable, it is always ugly... maybe somebody has some=
=20
ideas.

Possible ways of implementation:

a) traverse sibling_list and do not alter it while traversal
- grab readlock before traversal
- ip_ct_unexpect_related() just 'notes' the to-be-deleted expectations
- release readlock
- grab writelock
- delete all 'noted' expectations

b) let the helper do it by itself
- call helper once for every packet (like current code)
- helper grabs writelock before traversal
- helper can alter his list exclusively while traversing
  (he has to know what he is doing, if for example deleting while traversin=
g)
- helper releases writelock after traversal


Either way we go, there is some locking involved.  'traditionally' we would
use the ip_conntrack_lock.  However, as described below, this has some prob=
lems
and using a seperate lock seems interesting.  In any case, it looks unclean.
Comments?


1. General locking problems if we would use a seperate sibling_lock:

  While iterating over the sibling list, the helper has to grab the
sibling_lock.  Then, while iterating, it calls expect_related/unexpect_rela=
ted
functions.  Those functions need to grab the sibling_lock as well, as they =
have
to add/ remove items from the list.  Of course they can not grab the lock, =
as
it is already grabbed.

  So what we could do, is provide non-locking variants of expect_related and
unexpect_related, which are to be called in this case.

  However, expect_related and unexpect_related have to grab the
ip_conntrack_lock in addition to the sibling_lock, because they have to=20
possibly modify the global expect_list.

destroy_expectations:
  Then there is destroy_expectations, which is called with an already locked
ip_conntrack_lock, and wishes to grab sibling_lock as well, because it also
has to delete expectations.  -> possibility of deadlock.

destroy_conntrack:
  Has to grab ip_conntrack_lock as well as sibling_lock, because it has
to remove itself from the sibling_list.


2. Using only one lock

  If we only use one lock, the already existing ip_conntrack_lock, it would
have to be grabbed for a long time.  And there is no functionality for=20
atomically changing a read lock into a write lock.  So we would have to grab
a write lock before we call the helper / traverse the list, and could relea=
se
this only after the whole job is done.

  The problem with expect_related / unexpect_related still persists, because
they still want to grab an already taken lock.  Solution like above, provide
non-locking-counterparts.

destroy_expectations and/or destroy_conntrack shouldn't raise any additional
problems in this setup..

Disadvantage: Most of the time, the nat helper will be called without having
some actual work to do.  Most of the time, the traffic will not raise any
expectations, but still we have to grab the write lock ind advance, thus=20
hurting SMP scalability :(


=3D=3D=3D sat oct 12, 2002:
Unfortunately I (the inventor of this second lock) don't even remember
the exact purpose anymore.  Sometimes I feel really stupid.  so let's go
read the code and my personal notes again...

I think the idea of the expect_tuple_lock() was to protect the tuple/mask
inside a struct ip_conntrack_expect.  This way we can implement
ip_conntrack_change_expect() without the need to grab a writelock on
ip_conntrack_lock. This is not jut an optimization, but absolutely necessar=
ry
for the NAT helpers:

We grab a readlock on ip_conntrack_lock and traverse the list of siblings.
For every sibling we call the nat helper function, which in turn wants to
alter the expectation by calling ip_conntrack_change_expect().Altering the
expectation needs some kind of locking.  If we only had one lock, we would
need a writelock on ip_conntrack_lock.  Since there is no primitive for
atomically upgrading a lock from readlock to writelock, we would need to
grab a writelock before traversing the sibling list.  And this sucks, since
nobody else can do anything inside connection tracking for a very long time.



--UDq0p1ry40hcSP8u--

--cEOOY/qhMBY6Rcxu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE9qBLhXaXGVTD0i/8RAgEmAJ4xDWF4OCy3xqyq8bSqqavOzcIMdQCbBSAM
i1ZGBybNGl3dsyc2NvYzAbQ=
=As7z
-----END PGP SIGNATURE-----

--cEOOY/qhMBY6Rcxu--
