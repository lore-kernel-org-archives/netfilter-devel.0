From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH 2] Re: what's the lockingrules for
	ip_conntrack_expect_list?
Date: 14 Oct 2002 15:26:55 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034602015.16873.148.camel@tux>
References: <1034286048.25146.40.camel@tux>
	<Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
	<20021012141737.X13233@sunbeam.de.gnumonks.org>
	<1034428150.7595.36.camel@tux> <1034429352.7595.48.camel@tux>
	<20021012163620.C13233@sunbeam.de.gnumonks.org>
	<1034436775.7595.96.camel@tux>
	<20021014133346.Q13233@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-YGwzQQp/PakUBqUr1uCG"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021014133346.Q13233@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-YGwzQQp/PakUBqUr1uCG
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, 2002-10-14 at 13:33, Harald Welte wrote:

> > Making find_proto() an inline adds two exported symbols, protocol_list
> > and ip_conntrack_generic_protocol.
> 
> I didn't think about this, sorry.  So I think we now go for the previous
> solution... export an __ function :(

You can't think of everything :)

I saw that you submitted the __ patch, I havn't had time to test the
ip_conntrack_change_expect patch but it looks correct to me, and it
compiles. If you feel dangerous you can submit it.

I've attached it again. (it applies cleanly to 2.4.20-pre10)
 
-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-YGwzQQp/PakUBqUr1uCG
Content-Disposition: attachment; filename=ip_conntrack_change_expect-lockfix.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_conntrack_change_expect-lockfix.diff;
	charset=ISO-8859-15

--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_core.c.mjufs	2002-10=
-12 15:23:22.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_core.c	2002-10-12 15=
:23:00.000000000 +0200
@@ -1060,7 +1060,10 @@
 int ip_conntrack_change_expect(struct ip_conntrack_expect *expect,
 			       struct ip_conntrack_tuple *newtuple)
 {
+	int ret;
+
 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
+	WRITE_LOCK(&ip_conntrack_expect_tuple_lock);
=20
 	DEBUGP("change_expect:\n");
 	DEBUGP("exp tuple: "); DUMP_TUPLE(&expect->tuple);
@@ -1073,26 +1076,25 @@
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
+	WRITE_UNLOCK(&ip_conntrack_expect_tuple_lock);
 =09
-	return -1;
+	return ret;
 }
=20
 /* Alter reply tuple (maybe alter helper).  If it's already taken,

--=-YGwzQQp/PakUBqUr1uCG--
