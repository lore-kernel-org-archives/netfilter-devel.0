From: Chris Green <cmg@dok.org>
Subject: Re: Logging NAT translations?
Date: Mon, 02 Aug 2004 11:16:43 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87r7qpzi1w.fsf@ion.xlipstream.com>
References: <87isc7on6q.fsf@ion.xlipstream.com>
	<20040801170153.GC14539@sunbeam2>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040801170153.GC14539@sunbeam2> (Harald Welte's message of
	"Sun, 1 Aug 2004 19:01:53 +0200")
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--=-=-=

Harald Welte <laforge@netfilter.org> writes:

> then someone needs to do some porting/merging work... patches
> appreciated ;)

Ok... I'm happy to work on it if I can get some pointers on where/how
development should happen.

I'm guessing HEAD iptables, HEAD patch-o-matic-ng, linux-2.6.7?

The requirements hierarchy is a pain for me to figure out. Shouldn't
be too bad to generate a graphviz digraph for it though.

For POM-NG, should I be doing:

./runme pending
./runme nfnetlink-ctnetlink-0.13

or should I walk through the deps in nfnetlink-ctnetlink-0.13/info,
apply/fix all of those patches recursively.

For fixing a single patch, what should the .orig tree be? The tree
with all dependencies applied?

Any guidance on tree mangagement would be appreciated.

Thanks,
Chris
-- 
Chris Green <cmg@dok.org>
Chicken's thinkin'

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBDlricTuckgiWJ4oRAuSpAJ950p3h6opmAZh73BtUGKkUqBE0agCgiovb
ZuC8Xm/qIv+WgAXo+PlLhkM=
=3gQo
-----END PGP SIGNATURE-----
--=-=-=--
