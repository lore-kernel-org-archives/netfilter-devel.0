From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH 2] Re: what's the lockingrules for ip_conntrack_expect_list?
Date: 12 Oct 2002 15:29:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034429352.7595.48.camel@tux>
References: <1034286048.25146.40.camel@tux>
	<Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
	<20021012141737.X13233@sunbeam.de.gnumonks.org>
	<1034428150.7595.36.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-V1nrwxfSCSxTfzrE2mMA"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <1034428150.7595.36.camel@tux>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-V1nrwxfSCSxTfzrE2mMA
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2002-10-12 at 15:09, Martin Josefsson wrote:
> On Sat, 2002-10-12 at 14:17, Harald Welte wrote:

> > > > ip_conntrack_change_expect
> > > > 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
> > > > 	LIST_FIND
> > > >
> > > > 	FAILS!! called from nat-helpers which only hold their own locks
> > > > 	if any at all.
> > 
> > No.  The helper's help functions are called from do_bindings, which grab
> > a readlock on ip_conntrack_lock before traversing the list of expectations
> > matching this packet.  See also my comment above.
> 
> Ahh I missed this, the helper is called after exp_for_packet which has
> already screwed up the lock-debug.
> 
> But we'll need to hold at least a read-lock on the tuple_lock during
> that LIST_FIND since we only have a read-lock on ip_conntrack_lock.
> and we modify tupe/mask inside this read-locked ip_conntrack_lock but
> within a write-lock'd tuple_lock. And since we'll probably need to take
> that write-lock anyway we might just as well take it from the beginning.

Attached patch changes the write-locked tuple_lock to cover the entire
function.
Is this ok with you?

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-V1nrwxfSCSxTfzrE2mMA
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

--=-V1nrwxfSCSxTfzrE2mMA--
