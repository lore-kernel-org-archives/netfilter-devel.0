From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] fix locking in conntrack-speed-locking and
	conntrack_expect_lock_removal
Date: 11 Oct 2002 21:46:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034365604.25973.71.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-s8SE/03JfFSXAw1UMQQp"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-s8SE/03JfFSXAw1UMQQp
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Rusty,

I've attached two small fixes against your patches on kernel.org.

I think they're quite obvious so I won't describe them here.

I'll see if I can get the testmachine up and running to actually test
your patches and see how much diffrence they make on a 2-way SMP.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-s8SE/03JfFSXAw1UMQQp
Content-Disposition: attachment; filename=conntrack-speed-locking.lockfix.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=conntrack-speed-locking.lockfix.diff;
	charset=ISO-8859-15

--- conntrack-speed-locking.patch.orig	2002-10-11 20:54:01.000000000 +0200
+++ conntrack-speed-locking.patch	2002-10-11 21:13:32.000000000 +0200
@@ -81,7 +81,7 @@
 +								\
 +		hash_a =3D hash_conntrack(tuple_a);		\
 +		hash_b =3D hash_conntrack(tuple_b);		\
-+		if (hash_a < hash_b) {				\
++		if (hash_a > hash_b) {				\
 +			op(&ip_conntrack_hash[hash_a].lock);	\
 +			op(&ip_conntrack_hash[hash_b].lock);	\
 +		} else if (hash_a < hash_b) {			\

--=-s8SE/03JfFSXAw1UMQQp
Content-Disposition: attachment; filename=conntrack_expect_lock_removal.lockfix.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=conntrack_expect_lock_removal.lockfix.diff;
	charset=ISO-8859-15

--- conntrack_expect_lock_removal.patch.orig	2002-10-11 21:18:52.000000000 =
+0200
+++ conntrack_expect_lock_removal.patch	2002-10-11 21:21:23.000000000 +0200
@@ -125,7 +125,7 @@
  	}
 -=09
 -	return -1;
-+	WRITE_UNLOCK(&ip_conntrack_expect);
++	WRITE_UNLOCK(&ip_conntrack_lock);
 +	return ret;
  }
 =20

--=-s8SE/03JfFSXAw1UMQQp--
