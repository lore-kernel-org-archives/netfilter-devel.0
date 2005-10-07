From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] don't use __be16 in files used by userspace
Date: Sat, 8 Oct 2005 00:15:00 +0200
Message-ID: <20051007221500.GK4450@rama.customers.eurospot.com>
References: <20051007103105.GF4719@rama>
	<20051007.132456.19624093.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FxlYARId5dseejUu"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
In-Reply-To: <20051007.132456.19624093.davem@davemloft.net>
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


--FxlYARId5dseejUu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 07, 2005 at 01:24:56PM -0700, David S. Miller wrote:
> From: Harald Welte <laforge@netfilter.org>
> Date: Fri, 7 Oct 2005 12:31:05 +0200
>=20
> > This (or a different solution such as=20
> > "#ifndef __KERNEL__ #define __be16 #endif" needs to go in before 2.6.14
> > is released, since otherwise we'd break userspace compilation :(
>=20
> I'm not applying this.

As I almost expected. But it was worth a try ;)

> The reverting of endianness annotations would be a serious
> regression.  If we need userland compatible defines we can
> either:
>=20
> 1) Do what iproute2 and friends do, which is ship sanitized
>    kernel headers in their userland source tree.

we're thinking about this, but concluded for ip_conntrack it's too late
now.  There is too much interdependency between dozens of files, so we'd
have to have a script that grep/sed's what we really need :(

For nf_conntrack (in my git tree, pending for 2.6.15), we have a
strict separation of all header files.  Only the absolute minimum that
is required by userspace goes into include/linux/netfilter/, and
everything else into include/net/netfilter.

This way we make sure we can make a clean copy of everything in
include/linux/netfilter/* and put that into userspace (i.e.
libnfnetlink_conntrack, ...)

> 2) As you suggest have a suitable __be* et al. define when
>    __KERNEL__ is not set.
>=20
> Actually... What's the problem anyways?  #2 seems to already
> be done.

include/linux/netfilter_ipv4/ip_conntrack_tuple.h doesn't include
<linux/types.h>, and the (existing, old) userspace code has no reason to
include it before ip_conntrack_tuple.h either.

So as I just confirmed, adding a #include seems to be fixing the
problem.

Please apply the patch below instead. Thanks!

[NETFILTER] Add missing include to ip_conntrack_tuple.h

Without this #include, __be16 is not defined and userspace programs
will break.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit 0b4f28e7d0a469b2877ac18619af9c9695972c09
tree ad8281918b1cee5678acca048ab502bc346364f5
parent f3c27d8351a2ad3aa586549680b83e19670d6815
author Harald Welte <laforge@netfilter.org> Sat, 08 Oct 2005 00:15:03 +0200
committer Harald Welte <laforge@netfilter.org> Sat, 08 Oct 2005 00:15:03 +0=
200

 include/linux/netfilter_ipv4/ip_conntrack_tuple.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h b/include/li=
nux/netfilter_ipv4/ip_conntrack_tuple.h
--- a/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack_tuple.h
@@ -1,6 +1,8 @@
 #ifndef _IP_CONNTRACK_TUPLE_H
 #define _IP_CONNTRACK_TUPLE_H
=20
+#include <linux/types.h>
+
 /* A `tuple' is a structure containing the information to uniquely
   identify a connection.  ie. if two packets have the same tuple, they
   are in the same connection; if not, they are not.
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--FxlYARId5dseejUu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRvNkXaXGVTD0i/8RAnFdAKCm16UtAOa3NS5NCOvAjKnNH5oYEwCcCQtA
iIZos7p8yXwOUqOqbvcNewI=
=4XnV
-----END PGP SIGNATURE-----

--FxlYARId5dseejUu--
