From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.4] ipt_limit sync with 2.6.x
Date: Wed, 4 Feb 2004 10:06:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040204090652.GV25175@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zqjkMoGlbUJ91oFe"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--zqjkMoGlbUJ91oFe
Content-Type: multipart/mixed; boundary="ISKrrfpKsPiF35CV"
Content-Disposition: inline


--ISKrrfpKsPiF35CV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

could you please apply the patch from rusty's mail in the attachment?

It went in 2.6.x, but not 2.4.x.

It is not strictly needed on 2.4.x (at least not x86), but it's always
better to keep the code in sync.

The patch applies cleanly to 2.4.24 ipt_limit.c, I tested it a couple of
minutes ago.

Thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ISKrrfpKsPiF35CV
Content-Type: message/rfc822
Content-Disposition: inline

Return-Path: X-Sieve: cmu-sieve 2.0
Return-path: <netfilter-core-admin@lists.netfilter.org>
Received: from netfilter-sponsored-by.noris.net ([62.128.28.62] helo=kashyyyk.netfilter.org)
	by coruscant.gnumonks.org with esmtp (TLSv1:DES-CBC3-SHA:168)
	(Exim 4.22)
	id 1A8JHA-00017E-Ed
	for laforge@gnumonks.org; Sat, 11 Oct 2003 14:55:16 +0200
Received: from localhost ([127.0.0.1] helo=netfilter-sponsored-by.noris.net)
	by kashyyyk.netfilter.org with esmtp (Exim 4.22 #1 (Debian))
	id 1A8JH9-0001Zj-6j
	for <laforge@gnumonks.org>; Sat, 11 Oct 2003 14:55:15 +0200
Received: from dp.samba.org ([66.70.73.150] helo=lists.samba.org)
	by kashyyyk.netfilter.org with esmtp (Exim 4.22 #1 (Debian))
	id 1A7WW3-0000kn-LL
	for <coreteam@netfilter.org>; Thu, 09 Oct 2003 10:51:23 +0200
Received: by lists.samba.org (Postfix, from userid 590)
	id E97F62C143; Thu,  9 Oct 2003 08:51:14 +0000 (GMT)
From: Rusty Russell <rusty@rustcorp.com.au>
To: torvalds@transmeta.com
Cc: davem@redhat.com, coreteam@netfilter.org
Message-Id: <20031009085114.E97F62C143@lists.samba.org>
X-Spam-Score: -2.6 (--)
Subject: [netfilter-core] [PATCH] ipt_limit fix for HZ=1000
Sender: netfilter-core-admin@lists.netfilter.org
Errors-To: netfilter-core-admin@lists.netfilter.org
X-BeenThere: netfilter-core@lists.netfilter.org
X-Mailman-Version: 2.0.11
Precedence: bulk
List-Help: <mailto:netfilter-core-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-core@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-core>,
	<mailto:netfilter-core-request@lists.netfilter.org?subject=subscribe>
List-Id: List for core team members of the netfilter project <netfilter-core.lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-core>,
	<mailto:netfilter-core-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/mailman/private/netfilter-core/>
Date: Thu, 09 Oct 2003 18:47:32 +1000
X-Spam-Score: -0.9 (/)

The range that the iptables limit extension can specify depends on HZ.
This means that rules which worked i386 2.4 (100 HZ) won't work on
2.6.

The solution is to adjust the precision based on the HZ value (keeping
the range of possible values the same).  For extra geek cred, this is
done by calculating a power-of-two constant below the maximum
multiplication factor, which gcc then turns into a simple shift.

---
Linus, please apply.

Name: ip_limit HZ Fix
Author: Rusty Russell
Status: Booted on 2.6.0-test4-bk6

D: The CREDITS_PER_JIFFY value should be set to the largest power of 2
D: which still allows a limit of 1 packet per day, without overflowing
D: 32-bits.  A value of 128 is NOT sufficient for that criterion with
D: HZ=1000.
D:
D:  https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=127

diff -urpN --exclude TAGS -X /home/rusty/devel/kernel/kernel-patches/current-dontdiff --minimal linux-2.6.0-test4-bk6/net/ipv4/netfilter/ipt_limit.c working-2.6.0-test4-bk6-tmp/net/ipv4/netfilter/ipt_limit.c
--- linux-2.6.0-test4-bk6/net/ipv4/netfilter/ipt_limit.c	2003-09-05 09:16:39.000000000 +1000
+++ working-2.6.0-test4-bk6-tmp/net/ipv4/netfilter/ipt_limit.c	2003-09-05 16:30:42.000000000 +1000
@@ -38,12 +38,23 @@ static spinlock_t limit_lock = SPIN_LOCK
 
    See Alexey's formal explanation in net/sched/sch_tbf.c.
 
-   To avoid underflow, we multiply by 128 (ie. you get 128 credits per
-   jiffy).  Hence a cost of 2^32-1, means one pass per 32768 seconds
-   at 1024HZ (or one every 9 hours).  A cost of 1 means 12800 passes
-   per second at 100HZ.  */
+   To get the maxmum range, we multiply by this factor (ie. you get N
+   credits per jiffy).  We want to allow a rate as low as 1 per day
+   (slowest userspace tool allows), which means
+   CREDITS_PER_JIFFY*HZ*60*60*24 < 2^32. ie. */
+#define MAX_CPJ (0xFFFFFFFF / (HZ*60*60*24))
 
-#define CREDITS_PER_JIFFY 128
+/* Repeated shift and or gives us all 1s, final shift and add 1 gives
+ * us the power of 2 below the theoretical max, so GCC simply does a
+ * shift. */
+#define _POW2_BELOW2(x) ((x)|((x)>>1))
+#define _POW2_BELOW4(x) (_POW2_BELOW2(x)|_POW2_BELOW2((x)>>2))
+#define _POW2_BELOW8(x) (_POW2_BELOW4(x)|_POW2_BELOW4((x)>>4))
+#define _POW2_BELOW16(x) (_POW2_BELOW8(x)|_POW2_BELOW8((x)>>8))
+#define _POW2_BELOW32(x) (_POW2_BELOW16(x)|_POW2_BELOW16((x)>>16))
+#define POW2_BELOW32(x) ((_POW2_BELOW32(x)>>1) + 1)
+
+#define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
 static int
 ipt_limit_match(const struct sk_buff *skb,
@@ -99,7 +110,7 @@ ipt_limit_checkentry(const char *tablena
 	/* Check for overflow. */
 	if (r->burst == 0
 	    || user2credits(r->avg * r->burst) < user2credits(r->avg)) {
-		printk("Call rusty: overflow in ipt_limit: %u/%u\n",
+		printk("Overflow in ipt_limit, try lower: %u/%u\n",
 		       r->avg, r->burst);
 		return 0;
 	}


 
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.


--ISKrrfpKsPiF35CV--

--zqjkMoGlbUJ91oFe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAILYsXaXGVTD0i/8RAtGbAJ92mTqz0gkdELQVVCd4pAKymLySuACfSWOu
vTXqM+gPPTQ8Oq+DDfskLA0=
=blaI
-----END PGP SIGNATURE-----

--zqjkMoGlbUJ91oFe--
