From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] small optimization in __ip_conntrack_find()
Date: 08 Jun 2002 01:00:59 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023490707.19838.14.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-5dK3oTvNUcaaAdgNpqgW"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-5dK3oTvNUcaaAdgNpqgW
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

Attached is a small optimization for __ip_conntrack_find().
The way I read the use of the LIST_FIND macro it seems that we are
calling hash_conntrack() for each iteration with the same inparameters.

My change calls it once before looping.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-5dK3oTvNUcaaAdgNpqgW
Content-Disposition: attachment; filename=ip_conntrack_core.c-find-diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_conntrack_core.c-find-diff; charset=ISO-8859-15

--- linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_core.c.orig	Sat Jun =
 8 00:48:59 2002
+++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_core.c	Sat Jun  8 00=
:49:56 2002
@@ -292,9 +292,10 @@
 		    const struct ip_conntrack *ignored_conntrack)
 {
 	struct ip_conntrack_tuple_hash *h;
+	size_t hash =3D hash_conntrack(tuple);
=20
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
-	h =3D LIST_FIND(&ip_conntrack_hash[hash_conntrack(tuple)],
+	h =3D LIST_FIND(&ip_conntrack_hash[hash],
 		      conntrack_tuple_cmp,
 		      struct ip_conntrack_tuple_hash *,
 		      tuple, ignored_conntrack);

--=-5dK3oTvNUcaaAdgNpqgW--
