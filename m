From: Rennie deGraaf <degraaf@cpsc.ucalgary.ca>
Subject: Test suite for iptables
Date: Mon, 28 Aug 2006 17:57:18 -0600
Message-ID: <44F382DE.7030001@cpsc.ucalgary.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig51E620F4E5D521B078126D85"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig51E620F4E5D521B078126D85
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

I've been making some experimental modifications to the way that
userspace queuing is done in netfilter, and in particular, iptables.  As
part of this, I completely re-wrote ipt_do_table() in
net/ipv4/netfilter/ip_tables.c to make it easier to read and work with.
  I've also made other changes all over the place, including some as far
down as net/netfilter/core.c.  Actual functionality shouldn't have
changed with what I've done so far.  Right now, I want to make sure that
I haven't broken anything before continuing on with my modifications.

I tried using what I understand to be your test suite, nfsim-testsuite,
but it won't compile.  When it tries to compile ip_tables.c, I get the
following errors:

ip_tables.c: In function =91ipmq_queue_pkt=92:
ip_tables.c:194: warning: implicit declaration of function =91NLMSG_NEW=92=

ip_tables.c:194: error: =91NLMSG_MIN_TYPE=92 undeclared (first use in thi=
s
function)ip_tables.c:194: error: (Each undeclared identifier is reported
only once
ip_tables.c:194: error: for each function it appears in.)
ip_tables.c:194: warning: assignment makes pointer from integer without
a cast
ip_tables.c:196: warning: implicit declaration of function =91NLMSG_END=92=

ip_tables.c:204: error: =91MSG_DONTWAIT=92 undeclared (first use in this
function)
ip_tables.c:216: warning: label =91nlmsg_failure=92 defined but not used
ip_tables.c: In function =91ipmq_nl_recv=92:
ip_tables.c:236: warning: implicit declaration of function =91skb_dequeue=
=92
ip_tables.c:236: error: =91struct sock=92 has no member named =91sk_recei=
ve_queue=92
ip_tables.c:236: warning: assignment makes pointer from integer without
a cast
ip_tables.c: In function =91do_match=92:
ip_tables.c:379: warning: pointer targets in passing argument 7 of
=91m->u.kernel.match->match=92 differ in signedness
ip_tables.c: In function =91ipt_init_state=92:
ip_tables.c:413: warning: passing argument 1 of =91talloc_free=92 discard=
s
qualifiers from pointer target type
ip_tables.c: In function =91init=92:
ip_tables.c:1843: warning: implicit declaration of function =91kcalloc=92=

ip_tables.c:1843: warning: assignment makes pointer from integer without
a cast
ip_tables.c:1852: error: =91NETLINK_MQUEUE=92 undeclared (first use in th=
is
function)
ip_tables.c:1852: error: too many arguments to function
=91netlink_kernel_create=92
ip_tables.c:1872: warning: implicit declaration of function =91sock_relea=
se=92
make[2]: *** [ip_tables.so] Error 1

The file compiles without errors using the kernel build system.  Most of
the errors and warnings have to do with test code that I've added to
ip_tables.c; most of it will eventually be moved to another file
somewhere.  Much of the code in question isn't actually being used right
now, and this could be disabled for the time being (but if it won't
compile now in this file, it probably won't compile later in another
file).  Some of the symbols mentioned are from the standard kernel
headers (NLMSG_NEW, NLMSG_MIN_TYPE, skb_dequeue, struct sock, etc),
while others are from my modifications (ipmq_queue_pkt, NETLINK_MQUEUE,
etc).  However, some of the warnings refer to stuff that's central to my
modifications, such as the warnings for lines 379 (I changed the type of
the 7th parameter of match functions to unsigned int), 413 (the line
contains a call to kfree()) and 1843 (a call to kcalloc()).

Do you have any suggestions on how I might get this to compile and run,
or how I might otherwise verify that I haven't broken anything?

Thanks,
Rennie deGraaf


--------------enig51E620F4E5D521B078126D85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFE84LiIvU5mZP08HERAm1XAKCD+VedXKeyXRqdblci70rQfPoaYgCcDYzH
Kv4uEUqr0frrIMLT1zQpr9Y=
=is43
-----END PGP SIGNATURE-----

--------------enig51E620F4E5D521B078126D85--
