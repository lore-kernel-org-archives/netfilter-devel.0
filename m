From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Sat, 11 Dec 2004 14:34:14 +0100
Message-ID: <1102772053.12078.40.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
	<20041209085249.GA22714@oknodo.bof.de>
	<Pine.LNX.4.58.0412091108420.11649@blackhole.kfki.hu>
	<Pine.LNX.4.58.0412102315110.15772@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-Vo+fBHNFdUmWLAlh8hdL"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>,
	Grzegorz Piotr Jaskiewicz <gj@pointblue.com.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0412102315110.15772@blackhole.kfki.hu>
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


--=-Vo+fBHNFdUmWLAlh8hdL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2004-12-10 at 23:27, Jozsef Kadlecsik wrote:
> On Thu, 9 Dec 2004, Jozsef Kadlecsik wrote:
>=20
> > On Thu, 9 Dec 2004, Patrick Schaaf wrote:
> >
> > > This suggest, to me, that we keep unreplied connections on a new,
> > > additional list. They are put there at the HEAD upon creation,
> > > they are removed form the list when they make their transition
> > > to assured. And early_drop becomes a simple, O(1) operation:
> > > reap the connection which is at the TAIL of this new list.
> >
> > But I like it! Hmm, expect some new code soon...
>=20
> Attached (;-) is the new patch, which implements the list of unassured
> connections. (Reserving conntracks is dropped completely as unnecessary.)
> I tested it slighgtly and seems to work fine. What do you think about it?

I've been thinking about this as well, but mostly I've been thinking
about how to get it to scale when we go for more finegrained locking.
The locking is going to be nasty.

The patch looks pretty good, just a few things...

@@ -461,34 +467,36 @@
 	return h !=3D NULL;
 }
=20
-/* There's a small race here where we may free a just-assured
-   connection.  Too bad: we're in trouble anyway. */
-static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
+static int early_drop(void)
 {
-	return !(test_bit(IPS_ASSURED_BIT, &i->ctrack->status));
-}
-
-static int early_drop(struct list_head *chain)
-{
-	/* Traverse backwards: gives us oldest, which is roughly LRU */
-	struct ip_conntrack_tuple_hash *h;
+	struct ip_conntrack *ct =3D NULL;
+	struct list_head *entry;
 	int dropped =3D 0;
=20
+    	/* There's a small race here where we may free a just-assured
+	   connection.  Too bad: we're in trouble anyway. */
 	READ_LOCK(&ip_conntrack_lock);
-	h =3D LIST_FIND_B(chain, unreplied, struct ip_conntrack_tuple_hash *);
-	if (h)
-		atomic_inc(&h->ctrack->ct_general.use);
+	__list_for_each(entry, &unassured_list) {
+		ct =3D list_entry(entry,
+			        struct ip_conntrack, unassured);
+		atomic_inc(&ct->ct_general.use);
+		break;
+	}
 	READ_UNLOCK(&ip_conntrack_lock);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Why not loop and kill multiple entries each time? Saves some locking and
cache. But in order to do that in a good way wee need a counter of how
many entries we have in the unassured list. But we don't want to kill
too many each time, then almost no real connections will get through.

-	if (!h)
+	if (!ct)
 		return dropped;
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
I think we are pretty much guranteed to have a valid ct here, otherwise
we would oops above :)
=20
-	if (del_timer(&h->ctrack->timeout)) {
-		death_by_timeout((unsigned long)h->ctrack);
+	if (del_timer(&ct->timeout)) {
+		death_by_timeout((unsigned long)ct);
 		dropped =3D 1;
+		if (net_ratelimit())
+			printk(KERN_WARNING
+			       "ip_conntrack: table full, dropping"
+			       " unassured connection.\n");
 		CONNTRACK_STAT_INC(early_drop);
 	}
-	ip_conntrack_put(h->ctrack);
+	ip_conntrack_put(ct);
 	return dropped;
 }
=20
@@ -1091,7 +1100,8 @@
 void ip_ct_refresh_acct(struct ip_conntrack *ct,=20
 		        enum ip_conntrack_info ctinfo,
 			const struct sk_buff *skb,
-			unsigned long extra_jiffies)
+			unsigned long extra_jiffies,
+			int set_assured)
 {
 	IP_NF_ASSERT(ct->timeout.data =3D=3D (unsigned long)ct);
=20
@@ -1107,6 +1117,10 @@
 			add_timer(&ct->timeout);
 		}
 		ct_add_counters(ct, ctinfo, skb);
+		if (set_assured) {
+			set_bit(IPS_ASSURED_BIT, &ct->status);
+			list_del(&ct->unassured);
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Huh? No check to see if we already are assured or not?
Not needed for icmp, tcp or sctp but udp and the generic handler does.

--=20
/Martin

--=-Vo+fBHNFdUmWLAlh8hdL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQBBuvdVWm2vlfa207ERAuvCAJ9nTWHLBbHRDz6g2jZe9zolu6lEKACfQ1A/
2psMd+D3r3IlENvsQ+gOBZI=
=1RJM
-----END PGP SIGNATURE-----

--=-Vo+fBHNFdUmWLAlh8hdL--
