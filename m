From: vecna@s0ftpj.org
Subject: possible target SBALANCE ?
Date: Mon, 28 Apr 2003 17:07:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030428150727.GA10325@dns2.italway.it>
References: <200304192142.h3JLg1S03466@fokkensr.vertis.nl> <20030428091332.GB29390@dns2.italway.it> <20030428134713.GA12364@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qDbXVdCdHGoSgWSk"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030428134713.GA12364@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--qDbXVdCdHGoSgWSk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(sorry for my bad english :)

On Mon, Apr 28, 2003 at 03:47:13PM +0200, Patrick Schaaf wrote:
> I use 'grep conntrack /proc/slabinfo' for this task (first number column
> is the number of conntracks currently allocated).
uu :) I ever listen about :) tnx :)

> Regarding your patch, it introduces another new place for cache line
> pingpong, happening with the same frequency as creation of new conntracks.
excuse me, what do you mean with pingpong ?

> That is not a good idea, it's not the way hashing is supposed to work.
> There is no need for ordering anywhere, so no need to sort anything,
> as a mergesort would do.
> If you have overly long hash chains, use more hash buckets, and, if
> neccessary, a better distributing hash function.
umh, I've always view as hard work the calling of __ip_conntrack_find,
that call LIST_FIND that one check at the wrong possibility all present
connection tracked ...

but, about the subject of the list, on the documentation of a switch=20
for compactPCI arch
(http://www.znyx.com/products/software/openarchitect/default.htm)
them explain our system for make a traffic division more or less similar
to a load balancer, them suppose that statistically all internet connection
should be (more or less) equally distributed if is applied a matematic=20
computation over session params (ip source, ip dest, source porc, dest port=
).

if we take a look at the last byte of ip addres and port, we could use
this number and associate them (with a simple LAST_BYTENUMBER % POSSIBLE_OU=
TPUT)
to one output interface, for make load balancing applied to session
without doing session tracking. (because on between direction
of sessions, ip source ip dest source port dest port, is alwayes the some,
also with inverted position).

I've some time to use for make a possible -j SBALANCE target for do
a forward on a list of output interface ... did you think that
should be nice ?=20

bye,
~c

--qDbXVdCdHGoSgWSk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+rUOvqso6AcJ1LUsRAqolAJ9OLhxkWweL0hR4R03XvtGO+5YAdgCeN4hz
uOJZ9Ud2tVnOE6zJX+nILo0=
=bIAN
-----END PGP SIGNATURE-----

--qDbXVdCdHGoSgWSk--
