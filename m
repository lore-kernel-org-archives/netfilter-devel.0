From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] Re: what's the lockingrules for ip_conntrack_expect_list?
Date: 11 Oct 2002 20:42:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034361771.25973.65.camel@tux>
References: <Pine.LNX.4.33.0210111559050.29766-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FWFu2LtxycM6gxp7dpBb"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0210111559050.29766-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-FWFu2LtxycM6gxp7dpBb
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2002-10-11 at 16:07, Jozsef Kadlecsik wrote:
> On 11 Oct 2002, Martin Josefsson wrote:
> 
> > But is it really neccessary to hold ip_conntrack_lock when we are only
> > going to change an expectation and not touch anything else?
> > If we enforce that we always hold a readlock or writelock on
> > ip_conntrack_expect_tuple_lock when we touch it we should be safe?
> 
> We wanted to avoid possible cross-locking bugs by keeping a strict
> hierarchy of the locks. Sometimes too complicated functions are called
> while a lock is held.

Ok.
Patch for ip_conntrack_change_expect is attached.

Harald, is this something you would accept and forward for inclusion?
And while we're at it, I still think we should change exp_for_packet to
use __find_proto instead of ip_ct_find_proto to avoid the ASSERT's that
people are complaining about. Sure they are harmless but users don't
know that and send reports. (this problem goes away with Rustys patches
for 2.5, exp_for_packet is completely removed)

> > I think Rusty has changed the lockingrules in his conntrack-optimization
> > patch to only require that we hold the ip_conntrack_expect_tuple_lock.
> 
> The other way around: he removed ip_conntrack_expect_tuple_lock
> completely. I think that is the proper way, but it implies that later
> the fine-grained locking is introduced in order to remove the dependency
> of everything on the single ip_conntrack_lock.

Yes I saw that when I read the patch. That change combined with the
speedup patch will be nice. I found two small locking-bugs in those
patches aswell, I'll send Rusty some patches in a short while.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-FWFu2LtxycM6gxp7dpBb
Content-Disposition: attachment; filename=ip_conntrack_change_expect-locking.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_conntrack_change_expect-locking.diff;
	charset=ISO-8859-15

--- linux-2.4.20-pre10.orig/net/ipv4/netfilter/ip_conntrack_core.c	2002-10-=
11 15:48:28.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_core.c	2002-10-11 20=
:04:42.000000000 +0200
@@ -695,10 +695,8 @@
=20
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* Need finding and deleting of expected ONLY if we win race */
-	READ_LOCK(&ip_conntrack_expect_tuple_lock);
 	expected =3D LIST_FIND(&ip_conntrack_expect_list, expect_cmp,
 			     struct ip_conntrack_expect *, tuple);
-	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
=20
 	/* Look up the conntrack helper for master connections only */
 	if (!expected)
@@ -1060,7 +1058,7 @@
 int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
 			       struct ip_conntrack_tuple *newtuple)
 {
-	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
+	int ret;
=20
 	DEBUGP("change_expect:\n");
 	DEBUGP("exp tuple: "); DUMP_TUPLE(&expect->tuple);
@@ -1069,30 +1067,32 @@
 	if (expect->ct_tuple.dst.protonum =3D=3D 0) {
 		/* Never seen before */
 		DEBUGP("change expect: never seen before\n");
+		READ_LOCK(&ip_conntrack_lock);
+		WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
 		if (!ip_ct_tuple_equal(&expect->tuple, newtuple)=20
 		    && LIST_FIND(&ip_conntrack_expect_list, expect_clash,
 			         struct ip_conntrack_expect *, newtuple, &expect->mask)) {
 			/* Force NAT to find an unused tuple */
-			return -1;
+			ret =3D -1;
 		} else {
-			WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
 			memcpy(&expect->ct_tuple, &expect->tuple, sizeof(expect->tuple));
 			memcpy(&expect->tuple, newtuple, sizeof(expect->tuple));
-			WRITE_UNLOCK(&ip_conntrack_expect_tuple_lock);
-			return 0;
+			ret =3D 0;
 		}
+		WRITE_UNLOCK(&ip_conntrack_expect_tuple_lock);
+		READ_UNLOCK(&ip_conntrack_lock);
 	} else {
 		/* Resent packet */
 		DEBUGP("change expect: resent packet\n");
 		if (ip_ct_tuple_equal(&expect->tuple, newtuple)) {
-			return 0;
+			ret =3D 0;
 		} else {
 			/* Force NAT to choose again the same port */
-			return -1;
+			ret =3D -1;
 		}
 	}
 =09
-	return -1;
+	return ret;
 }
=20
 /* Alter reply tuple (maybe alter helper).  If it's already taken,

--=-FWFu2LtxycM6gxp7dpBb--
