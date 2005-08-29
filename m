From: Samir Bellabes <sbellabes@mandriva.com>
Subject: [NETFILTER] Kill lockhelp.h for connrate
Date: Mon, 29 Aug 2005 18:58:31 +0200
Message-ID: <m24q98wuh4.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
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

--=-=-=

Hi,
This patch fix the match 'connrate', after the kill_lockhelp.patch
Please apply at top of the svn tree.

regards,
Samir Bellabes


--=-=-=
Content-Type: text/x-patch; charset=iso-8859-15
Content-Disposition: attachment; filename=connrate_kill_lockhelp.patch
Content-Transfer-Encoding: quoted-printable

[NETFILTER] Kill lockhelp.h for connrate

---------------------------------------------------------------------------=
---

 ip_conntrack_rate.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

---------------------------------------------------------------------------=
---

Index: patchlets/connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- patchlets/connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c	(r=C3=
=A9vision 4244)
+++ patchlets/connrate/linux/net/ipv4/netfilter/ip_conntrack_rate.c	(copie =
de travail)
@@ -13,7 +13,6 @@
 #include <linux/skbuff.h>
 #include <linux/jiffies.h>
 #include <linux/netfilter_ipv4/ip_conntrack_rate.h>
-#include <linux/netfilter_ipv4/lockhelp.h>
=20
 /*
    I wanted to build a simpler and more robust rate estimator than the
@@ -96,7 +95,7 @@
 #define MAX_TOKENS_IN_WINDOW (0xffffffff - MAX_PACKET_IN_TOKENS)
=20
 /* Synchronizes all accesses to ip_conntrack_rate structures. */
-static DECLARE_RWLOCK(rate_lock);
+static rwlock_t rate_lock =3D RW_LOCK_UNLOCKED;
=20
 void
 ip_conntrack_rate_count(struct ip_conntrack_rate *ctr, unsigned int len)
@@ -104,7 +103,7 @@
 	u_int32_t new_bytes;
 	unsigned long now =3D jiffies;
=20
-	WRITE_LOCK(&rate_lock);
+	write_lock_bh(&rate_lock);
 	new_bytes =3D (ctr->avgrate * IP_CONNTRACK_RATE_INTERVAL +
 	             len * IP_CONNTRACK_RATE_SCALE);
 	if(new_bytes > MAX_TOKENS_IN_WINDOW)
@@ -113,7 +112,7 @@
 		ctr->avgrate =3D new_bytes / (now - ctr->prev +
 	                                    IP_CONNTRACK_RATE_INTERVAL);
 	ctr->prev =3D now;
-	WRITE_UNLOCK(&rate_lock);
+	write_unlock_bh(&rate_lock);
 }
=20
 u_int32_t
@@ -121,12 +120,12 @@
 {
 	u_int32_t rate;
=20
-	READ_LOCK(&rate_lock);
+	read_lock_bh(&rate_lock);
 	/* Rate can not overflow here if IP_CONNTRACK_RATE_INTERVAL is
 	   atleast HZ. If it is not, we could change the order of
 	   calculations at the possible cost of precision. */
 	rate =3D ctr->avgrate * HZ / IP_CONNTRACK_RATE_SCALE;
-	READ_UNLOCK(&rate_lock);
+	read_unlock_bh(&rate_lock);
 	return rate;
 }
=20

--=-=-=--
