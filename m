From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Hashtrie testing2 (was: Re: [PATCH 4/4] first conntrack ID
	must be 1 not 2)
Date: Thu, 23 Mar 2006 22:07:37 +0100
Message-ID: <1143148057.3840.43.camel@localhost.localdomain>
References: <43EFF1F0.1090701@netfilter.org>
	<20060213112028.GU4601@sunbeam.de.gnumonks.org>
	<43F438F5.8070607@trash.net>
	<Pine.LNX.4.58.0602160943060.26770@blackhole.kfki.hu>
	<43F43FA9.4000906@trash.net>
	<Pine.LNX.4.58.0602161005450.26770@blackhole.kfki.hu>
	<43F4426D.9060807@trash.net>
	<Pine.LNX.4.58.0602161017590.26770@blackhole.kfki.hu>
	<43F4DBDF.9010008@trash.net>
	<Pine.LNX.4.58.0602170907001.29301@blackhole.kfki.hu>
	<Pine.LNX.4.58.0602170936160.1339@tux.rsn.bth.se>
	<Pine.LNX.4.58.0602170951070.29301@blackhole.kfki.hu>
	<1141503111.3881.61.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603051049470.28988@blackhole.kfki.hu>
	<1141580938.3881.129.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603061125280.29731@blackhole.kfki.hu>
	<1141756438.3881.158.camel@localhost.localdomain>
	<1142189345.3881.181.camel@localhost.localdomain>
	<Pine.LNX.4.58.0603231206090.28275@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Xm11ERJx6emc3mjPyp58"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0603231206090.28275@blackhole.kfki.hu>
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


--=-Xm11ERJx6emc3mjPyp58
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2006-03-23 at 12:27 +0100, Jozsef Kadlecsik wrote:
> Hi Martin,

Hi Jozsef

> I took your code and messed with it: added input parameters
> (hashsize/number of elements), HASHNUM-dependent variants of hashtrie,
> added Paul Hsiesh's superfasthash function and an implementation of the
> shared-node fast hash from a SIGCOMM article. Then ran the different
> methods with increasing number of elements (table is half, full, two and
> four times more entry than hashsize) and created some graphs by gnuplot.

Wonderful, finally someone playing with it :)

> The results are at http://people.netfilter.org/kadlec/hashtrie/

Wow, that's some nice work. Must have taken quite a bit of time to
rewrite my crappy code (started out as a single small .c file :) into
something useful for testing and then performing all those tests.

A lot of your changes should go into svn, you have full freedom to
change whatever you want.

I see that you have tested with HASHSHIFT 3, 4, 5, 6 and a 32byte
cachelinesize.
That gives:

HASHSHIFT =3D 3
	HASHNUM (buckets per child) =3D 8
	childsize =3D HASHNUM * bucketsize (cachelinesize) =3D 256 bytes

HASHSHIFT =3D 4
	HASHNUM (buckets per child) =3D 16
	childsize =3D HASHNUM * bucketsize (cachelinesize) =3D 512 bytes

HASHSHIFT =3D 5
	HASHNUM (buckets per child) =3D 32
	childsize =3D HASHNUM * bucketsize (cachelinesize) =3D 1024 bytes

HASHSHIFT =3D 6
	HASHNUM (buckets per child) =3D 64
	childsize =3D HASHNUM * bucketsize (cachelinesize) =3D 2048 bytes

The original idea was to allocate PAGE_SIZE (4096 on i386) bytes at a
time so it would be interesting to test HASHSHIFT =3D 7 (assuming a 32byte
cachelinesize)

Another idea is to have varible number of buckets (HASHNUM) in the
nodes, more buckets at the top of the trie and then decrease the number
of buckets as we descend deeper into the trie. I've tried this earlier
but with lowered performance, I don't remember anything about the change
in memory-usage, and I don't trust my memory so it should be tested
again.

HASHSHIFT=3D8 or 9 or even larger at depth 0 would be interesting to test.

Allocating more than PAGE_SIZE makes it an order-1 or larger allocation
in kernel which is slower and more likely to fail but the the root-node
it doesn't matter if it takes a little longer to allocate, and it's
usually performed just after bootup when memory isn't very fragmented so
it shouldn't fail.

> What I could conclude is that hashtable requires the least memory and the
> fastest at inserting elements. Hashtrie is better in looking up entries
> when there are more than two times entries in the hash than the hashsize
> of the hashtable.

Yes, this matches the results I've seen as well. I've also run it under
the cachegrind module of valgrind and among other things it keeps
statistics on the number of instructions executed, and hashtrie executes
a lot more instructions than the plain hashtable during lookup, yet
hashtrie gets better performance in some cases due to the fact that it
gets less cachemisses.

> Something is required to improve hashtrie, so that it'd require less
> memory. Without losing speed, but possibly gaining, at insertion.

Yes, something is needed, right now I don't really see any solution to
the memory-usage problem. The problem is less severe with larger
cachelinesizes than 32bytes. 64byte cachelines gives a lot lower memory
usage, 128bytes like the P4 has decreases the memoryusage even more (you
have to decrease HASHSHIFT in order to not allocate too much memory for
each node).

Now I'm going to think about the other hashtrie email I havn't responded
to yet :)

--=20
/Martin

--=-Xm11ERJx6emc3mjPyp58
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBEIw4ZWm2vlfa207ERAoSkAJ9NGHPfl9KNzz6J2qKT9P6xJ8oneQCfd+8F
6VlmIbAO+2QNgguKW7miNL8=
=B1YE
-----END PGP SIGNATURE-----

--=-Xm11ERJx6emc3mjPyp58--
