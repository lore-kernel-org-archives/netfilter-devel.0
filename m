From: Harald Welte <laforge@netfilter.org>
Subject: Re: RPC & RSH modules
Date: Thu, 22 Sep 2005 12:24:42 +0200
Message-ID: <20050922102441.GS6516@sunbeam.de.gnumonks.org>
References: <432AFC8E.2020409@pandora.be>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ABYnUdqoGSokwVM+"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Stes <stes@pandora.be>
Content-Disposition: inline
In-Reply-To: <432AFC8E.2020409@pandora.be>
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


--ABYnUdqoGSokwVM+
Content-Type: multipart/mixed; boundary="4OpS+d6oOtUQaRm1"
Content-Disposition: inline


--4OpS+d6oOtUQaRm1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2005 at 07:10:38PM +0200, David Stes wrote:
>=20
> Hello,
>=20
> As explained before, I'd like to do maintenance of the RPC/RSH modules in=
 patch-o-matic-ng.
>=20
> You have asked me to send email to netfilter-devel mailing list, which I =
did.
>=20
> There's not much reaction there, except for
>=20
>     1) apparently the authors of RPC/RSH modules do not read the list
>     2) the only reaction I got was "we do not need rexec() or NFS modules"
>=20
> That is not helpful.   It is a shame that in Linux 2.4 one can use
> netfilter for NFS and rexec (rcmd), and this is broken in Linux 2.6.

Yes.  And it's a shame that my time is so limited that I wasn't able to
provide you any assistance/support so far.

I've now merged
- your linux-2.6.12.4 version of the rsh tracke
- your rsh/linux/ (2.4 port) legato additions.  They contained
  whitespace problems (8 spaces instead of tabs, ...). Please fix this
  yourself in the future.
- your 2.6.12.4 port of rpc
- your 2.4 updates to rpc

I did not (yet) merge
- your rsh/linux-2.6.11 modifications (linux-2.6.11.diff attached to
  this mail)
	I don't understand what their purpose is.  You re-introduce the
	lckhelp.h macros, but why?  They've always been optional, so th
	current code should work.  please clarify.
- your "Requires" change to rpc/info.  I don't think that our parser can
  parse the word "or" (the info files are parsed by "runme")

> In attach, already some work that I've sent many times.

For the future, please only submit unified diffs that apply with "-p1" from=
 the
"patch-o-matic-ng" directory.  No gzip, no tarballs, etc.

Also, submit each feature as a separate patch, like it can be observed
on many kernel related mailinglists (i.e.=20
	[PATCH 1/x] legato networker support for 2.4
	[PATCH 2/x] Port of rpc helper to 2.6.12.4
etc.

you can easily maintain such series of patches by the "quilt" tool.

> But as long as this is not under "revision control" it is really hard
> : I see that sometimes changes are made, and then the RPC/RSH is
> broken again of course.

sorry again.

> Is it please possible to apply the changes in attach - or alternatively e=
xplain me how to "svn=20
> commit" these changes :

it's applied.

We usually don't give svn write access to patch-o-matic to developers of
individual patchlets.  Please send patches like I've described above.
This will make it easier for us to review (and therefore hopefully make
us apply or reject it quickly).

If you again feel that development is overly delayed or hampered by our
lack of timely response, please send me (private) email and I'll
consider giving you svn access.

For the future, we'd like to see patch-o-matic go into something like an
"apt-get" approach:  Patches are always fetched online, from a list of
repositories (sources.list).

This way developers like you can operate their own patch-o-matic-ng
repository (anywhere, but including people.netfilter.org accounts which
we provide)...

> the goal is that I'd like to help to keep the NFS module working,
> because this was really useful netfilter functionality in the past.

I agree that NFS conntrack is a cool thing to have.  What's the status
on this ?  Which with NFS versions does it work?  Does it support nfs
over TCP, too (becomes more and more frequent)?

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--4OpS+d6oOtUQaRm1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.11.diff"
Content-Transfer-Encoding: quoted-printable

diff -Nru --exclude .svn ../../rsh/linux-2.6.11/include/linux/netfilter_ipv=
4/ip_conntrack_rsh.h linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack=
_rsh.h
--- ../../rsh/linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rsh.h	=
2005-09-19 15:18:51.000000000 +0200
+++ linux-2.6.11/include/linux/netfilter_ipv4/ip_conntrack_rsh.h	2005-08-03=
 12:50:32.000000000 +0200
@@ -12,6 +12,13 @@
 #ifndef _IP_CONNTRACK_RSH_H
 #define _IP_CONNTRACK_RSH_H
=20
+#ifdef __KERNEL__
+#include <linux/netfilter_ipv4/lockhelp.h>
+
+DECLARE_LOCK_EXTERN(ip_rsh_lock);
+#endif
+
+
 #define RSH_PORT	514
=20
 /* This structure is per expected connection */
diff -Nru --exclude .svn ../../rsh/linux-2.6.11/net/ipv4/netfilter/ip_connt=
rack_rsh.c linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rsh.c
--- ../../rsh/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rsh.c	2005-09-19=
 15:18:51.000000000 +0200
+++ linux-2.6.11/net/ipv4/netfilter/ip_conntrack_rsh.c	2005-08-03 12:50:32.=
000000000 +0200
@@ -103,6 +103,7 @@
 #include <net/checksum.h>
 #include <net/tcp.h>
=20
+#include <linux/netfilter_ipv4/lockhelp.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ip_conntrack_helper.h>
 #include <linux/netfilter_ipv4/ip_conntrack_rsh.h>
@@ -119,7 +120,7 @@
 MODULE_PARM_DESC(ports, "port numbers of RSH servers");
 #endif
=20
-static DEFINE_SPINLOCK(rsh_buffer_lock);
+static DECLARE_LOCK(rsh_buffer_lock);
 static char rsh_buffer[65535];
=20
 unsigned int (*ip_nat_rsh_hook)(struct sk_buff **pskb,
@@ -178,7 +179,7 @@
 	if (dataoff >=3D (*pskb)->len)
 		return NF_ACCEPT;
=20
-	spin_lock_bh(&rsh_buffer_lock);
+	LOCK_BH(&rsh_buffer_lock);
 	rb_ptr =3D skb_header_pointer(*pskb, dataoff,
 				    (*pskb)->len - dataoff, rsh_buffer);
 	BUG_ON(rb_ptr =3D=3D NULL);
@@ -255,7 +256,7 @@
 		ntohs(exp->mask.dst.u.tcp.port));
=20
 out:
-	spin_unlock_bh(&rsh_buffer_lock);
+	UNLOCK_BH(&rsh_buffer_lock);
=20
 	return ret;
 }

--4OpS+d6oOtUQaRm1--

--ABYnUdqoGSokwVM+
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMoZpXaXGVTD0i/8RAtaBAKCULLvMfFnBzQKZDvcdAPULQ/99MgCgtAiD
Bit6YuleZpuftkObyexo/Lw=
=WNQ+
-----END PGP SIGNATURE-----

--ABYnUdqoGSokwVM+--
