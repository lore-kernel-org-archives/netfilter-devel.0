From: Harald Welte <laforge@netfilter.org>
Subject: Re: RAM and conntrack performance
Date: Mon, 3 Nov 2003 09:12:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031103081240.GQ1536@sunbeam.de.gnumonks.org>
References: <20031028151032.GD726@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z0tYVNFvMKkk7KbZ"
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20031028151032.GD726@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Z0tYVNFvMKkk7KbZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2003 at 04:10:32PM +0100, Herve Eychenne wrote:
>  Hi everyone,

Hi Herve!

>=20
> Can someone post a state of the art summary for netfilter conntrack
> (and maybe NAT) performance tweaking?
> The only things I'm currently aware of are:
> - modprobe ip_conntrack hashsize=3D$HASHSIZE
> - echo $CONNTRACK_MAX > /proc/sys/net/ipv4/ip_conntrack_max

you shouldn't need to tweak anything else.  Recent kernels have the
jenkins2b hash instead of our old one, and hash distribution should thus
be more optimal.

> I think it would be good to end up with a small document which would
> give every detail about how to choose optimal values for HASHSIZE and
> CONNTRACK_MAX, and every other mean to get the best out of the
> conntracking/NAT system...

I guess there hasn't been any performance testing.  Ideally you'd have
as many buckets as you have conntrack entries in the system.  However,
every bucket will=20
>=20
> Here are things I've collected so far, that it would be good to have
> in this little document. I have questions, also:
> - CONNTRACK_MAX and HASHSIZE get default values at boot time.
>   By default, CONNTRACK_MAX =3D n * 64, where n is the RAM size in MB,
>   am I right?

well, it's true on i386.  See the algorithm below.

>   What about HASHSIZE default value? How to read it at runtime?
>   What is the exact link between these 2 values?

	/* Idea from tcp.c: use 1/16384 of memory.  On i386: 32MB
	 * machine has 256 buckets.  >=3D 1GB machines have 8192 buckets. */
 	if (hashsize) {
 		ip_conntrack_htable_size =3D hashsize;
 	} else {
		ip_conntrack_htable_size
			=3D (((num_physpages << PAGE_SHIFT) / 16384)
			   / sizeof(struct list_head));
		if (num_physpages > (1024 * 1024 * 1024 / PAGE_SIZE))
			ip_conntrack_htable_size =3D 8192;
		if (ip_conntrack_htable_size < 16)
			ip_conntrack_htable_size =3D 16;
	}
	ip_conntrack_max =3D 8 * ip_conntrack_htable_size;

I guess it's hard to describe the algorithm any better in written
language.

> - HASHSIZE should be an odd number, and even better: a prime number.
>   What happens when you set it to an even number, or a non-prime number?

hash distribution will be less optimal.

>   Why enable people to set even and non-prime numbers at all?

because we're lazy (and it doesn't cause a malfunction)

> - Default values are "reasonnable" for a typical host, but we may
>   increase them on high-loaded firewalling-only systems, right?

yes.

>   Which values are the "best"? I.e., can someone give a formula with
>   this potential parameters (if pertinent):
>   - total RAM size
>   - size of the memory that should be left for non-conntrack data in
>     the kernel and userspace in general (what is a reasonnable value for
>     a firewall doing only firewalling with very few applications
>     running, and how to measure that at runtime?)
>   - number of rules, connections rate, etc.

This is not a fixed formula. If it was, we could just do it
automatically that way.  In the ideal case, you have a machine _just_
doing packet filtering (i.e. almost no userspace running, at least none
that would have a growing memory consumption like proxies, ...).  Then
you put a decent amount of memory into that box, and use all but 64MB
(or 128MB) for conntrack (which can easily be half a gig of ram
considering todays memory prices).

size_of_mem_available_for_ct =3D=20
	ip_conntrack_max*sizeof(struct ip_conntrack) +
	hashsize*sizeof(struct list_head)

struct ip_conntrack is about 300 bytes (depending on your compile-time
configuration, see the printout at module load time).  struct list_head
is 2 times the size of a pointer on the respective arch.  on i386 it's 8
bytes total.

> - CONNTRACK_MAX can be modified at run time with /proc. What does it
>   do exactly (when shinked, when extended)?
>   When you modify CONNTRACK_MAX, should you also modify HASHSIZE
>   accordingly? Why? How?

it increases the counter of maximum allowed conntrack entries.
yes, you should also modify the hash size, since now the average number
of conntrack entries per hash bucket is increasing
(ip_conntrack_max/hashsize in the optimal case) and thus we need to
iterate over more list entries per conntrack lookup.  Having a large
hashsize is not bad at all - it will just occupy=20
hashzize*sizeof(struct list_head) bytes of non-swappable kernel memory,
whether you have any connections or not.=20

> - Is it possible to modify HASHSIZE at runtime when ip_conntrack is
>   not compiled as a module? If not, shouldn't we enable this with
>   /proc, like CONNTRACK_MAX?

no.  It is non-trivial to change the hash size after we have conntrack
entries in the table.  It would mean we'd need to re-hash all alrady
existing connections. =20

With 2.6.x you should be able to set hashsize at boottime using the new
module parameter stuff (which I haven't yet looked into, sorry).

> - Does any of these operations currently (or possibly, if soon
>   implemented) lead to some rehashing at runtime?

no.  the hash is just initialized with some random values at the time we
receive the first packet.  This is to make the hash function not
guessable from the outside (and thus less likely to be attacked).

>   I suppose it would be quite slow... How long does/would it take?

no idea.

>   How to proceed to keep current conntrack entries at runtime as much
>   as possible? (I suppose unloading ip_conntrack module and
>   reinserting it with another hashsize value clears the table...)

yes.  You just don't do that.  You configure your firewall, and put it
in place.  You should know your network traffic beforehand and configure
it correctly.

>  Herve

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--Z0tYVNFvMKkk7KbZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/pg34XaXGVTD0i/8RAkjkAKChgrgsJsIobyCj9SL3Od3/XoIbVQCggA+l
wzKnX9Fsh6SyAIcoWRUYEFo=
=bJv8
-----END PGP SIGNATURE-----

--Z0tYVNFvMKkk7KbZ--
