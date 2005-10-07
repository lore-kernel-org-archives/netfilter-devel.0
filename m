From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] use 32bit counters for connection-based accounting
Date: Fri, 7 Oct 2005 12:54:51 +0200
Message-ID: <20051007105451.GE4719@rama>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Cc: David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

I know this is too late for 2.6.14, so do you want me to hold back such
patches or do you already have a 2.6.15 queue?


[NETFILTER] Use only 32bit counters for CONNTRACK_ACCT

Initially we used 64bit counters for conntrack-based accounting, since we
had no event mechanism to tell userspace that our counters are about to
overflow.  With nfnetlink_conntrack, we now have such a event mechanism and
thus can save 16bytes per connection.

Signed-off-by: Harald Welte <laforge@netfilter.org>

---
commit d5b3f0a9fdcf7881d3b6efedd862aef6d561db03
tree ed8bfda8979a5004385bfe8dd313c57834c4f73e
parent 84446f9b12c7f160a4133cf6550514f6e5c02bfb
author Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 12:50:44 +0200
committer Harald Welte <laforge@netfilter.org> Fri, 07 Oct 2005 12:50:44 +0=
200

 include/linux/netfilter/nfnetlink_conntrack.h |    6 ++++--
 include/linux/netfilter_ipv4/ip_conntrack.h   |    8 ++++++--
 net/ipv4/netfilter/ip_conntrack_core.c        |   13 ++++++++-----
 net/ipv4/netfilter/ip_conntrack_netlink.c     |    8 ++++----
 4 files changed, 22 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_conntrack.h b/include/linux/=
netfilter/nfnetlink_conntrack.h
--- a/include/linux/netfilter/nfnetlink_conntrack.h
+++ b/include/linux/netfilter/nfnetlink_conntrack.h
@@ -77,8 +77,10 @@ enum ctattr_protoinfo {
=20
 enum ctattr_counters {
 	CTA_COUNTERS_UNSPEC,
-	CTA_COUNTERS_PACKETS,
-	CTA_COUNTERS_BYTES,
+	CTA_COUNTERS_PACKETS,		/* old 64bit counters */
+	CTA_COUNTERS_BYTES,		/* old 64bit counters */
+	CTA_COUNTERS32_PACKETS,
+	CTA_COUNTERS32_BYTES,
 	__CTA_COUNTERS_MAX
 };
 #define CTA_COUNTERS_MAX (__CTA_COUNTERS_MAX - 1)
diff --git a/include/linux/netfilter_ipv4/ip_conntrack.h b/include/linux/ne=
tfilter_ipv4/ip_conntrack.h
--- a/include/linux/netfilter_ipv4/ip_conntrack.h
+++ b/include/linux/netfilter_ipv4/ip_conntrack.h
@@ -117,6 +117,10 @@ enum ip_conntrack_events
 	/* NAT info */
 	IPCT_NATINFO_BIT =3D 10,
 	IPCT_NATINFO =3D (1 << IPCT_NATINFO_BIT),
+
+	/* Counter highest bit has been set */
+	IPCT_COUNTER_FILLING_BIT =3D 11,
+	IPCT_COUNTER_FILLING =3D (1 << IPCT_COUNTER_FILLING_BIT),
 };
=20
 enum ip_conntrack_expect_events {
@@ -192,8 +196,8 @@ do {									\
=20
 struct ip_conntrack_counter
 {
-	u_int64_t packets;
-	u_int64_t bytes;
+	u_int32_t packets;
+	u_int32_t bytes;
 };
=20
 struct ip_conntrack_helper;
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip=
_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -1119,7 +1119,7 @@ void __ip_ct_refresh_acct(struct ip_conn
 			unsigned long extra_jiffies,
 			int do_acct)
 {
-	int do_event =3D 0;
+	int event =3D 0;
=20
 	IP_NF_ASSERT(ct->timeout.data =3D=3D (unsigned long)ct);
 	IP_NF_ASSERT(skb);
@@ -1129,13 +1129,13 @@ void __ip_ct_refresh_acct(struct ip_conn
 	/* If not in hash table, timer will not be active yet */
 	if (!is_confirmed(ct)) {
 		ct->timeout.expires =3D extra_jiffies;
-		do_event =3D 1;
+		event =3D IPCT_REFRESH;
 	} else {
 		/* Need del_timer for race avoidance (may already be dying). */
 		if (del_timer(&ct->timeout)) {
 			ct->timeout.expires =3D jiffies + extra_jiffies;
 			add_timer(&ct->timeout);
-			do_event =3D 1;
+			event =3D IPCT_REFRESH;
 		}
 	}
=20
@@ -1144,14 +1144,17 @@ void __ip_ct_refresh_acct(struct ip_conn
 		ct->counters[CTINFO2DIR(ctinfo)].packets++;
 		ct->counters[CTINFO2DIR(ctinfo)].bytes +=3D=20
 						ntohs(skb->nh.iph->tot_len);
+		if ((ct->counters[CTINFO2DIR(ctinfo)].packets & 0x80000000)
+		    || (ct->counters[CTINFO2DIR(ctinfo)].bytes & 0x80000000))
+			event |=3D IPCT_COUNTER_FILLING;
 	}
 #endif
=20
 	write_unlock_bh(&ip_conntrack_lock);
=20
 	/* must be unlocked when calling event cache */
-	if (do_event)
-		ip_conntrack_event_cache(IPCT_REFRESH, skb);
+	if (event)
+		ip_conntrack_event_cache(event, skb);
 }
=20
 #if defined(CONFIG_IP_NF_CONNTRACK_NETLINK) || \
diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter=
/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -177,11 +177,11 @@ ctnetlink_dump_counters(struct sk_buff *
 	struct nfattr *nest_count =3D NFA_NEST(skb, type);
 	u_int64_t tmp;
=20
-	tmp =3D cpu_to_be64(ct->counters[dir].packets);
-	NFA_PUT(skb, CTA_COUNTERS_PACKETS, sizeof(u_int64_t), &tmp);
+	tmp =3D htonl(ct->counters[dir].packets);
+	NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);
=20
-	tmp =3D cpu_to_be64(ct->counters[dir].bytes);
-	NFA_PUT(skb, CTA_COUNTERS_BYTES, sizeof(u_int64_t), &tmp);
+	tmp =3D htonl(ct->counters[dir].bytes);
+	NFA_PUT(skb, CTA_COUNTERS32_BYTES, sizeof(u_int32_t), &tmp);
=20
 	NFA_NEST_END(skb, nest_count);
=20
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDRlP7XaXGVTD0i/8RAuilAKCYPupzrIR9HbTjY2tqU19BhjBuCQCgllay
IpF04E4OuAQrYdYQeO+5igM=
=UGXI
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
