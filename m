From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] fix conntrack bug introduced by list_del change
Date: Wed, 26 Feb 2003 19:41:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030226184110.GA15681@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
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


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

This is a fix for a serious conntrack bug in 2.4.20.

The bug was introduced by a semantic change of the list_del() macro of
the core kernel, resulting in otherwise timeouted conntrack entries
aving rediculously long timeouts associated (and in the end filling up
the conntrack table).

See also: https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=
=3D56

The bugfix would normally be a four-liner, but we rather chose to not
rely on this particular old list_del() behaviour any more (i.e. not make
the conntrack state depend on whether a list header pointer is NULLed or
not).

Credits go to Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Please apply,


diff -urN --exclude-from=3Ddiff.exclude linux-2.4.20-base/include/linux/net=
filter_ipv4/ip_conntrack.h linux-2.4.20-del/include/linux/netfilter_ipv4/ip=
_conntrack.h
--- linux-2.4.20-base/include/linux/netfilter_ipv4/ip_conntrack.h	Fri Nov 2=
9 00:53:15 2002
+++ linux-2.4.20-del/include/linux/netfilter_ipv4/ip_conntrack.h	Fri Feb 21=
 17:01:38 2003
@@ -6,6 +6,7 @@
=20
 #include <linux/config.h>
 #include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
+#include <linux/bitops.h>
 #include <asm/atomic.h>
=20
 enum ip_conntrack_info
@@ -41,6 +42,10 @@
 	/* Conntrack should never be early-expired. */
 	IPS_ASSURED_BIT =3D 2,
 	IPS_ASSURED =3D (1 << IPS_ASSURED_BIT),
+
+	/* Connection is confirmed: originating packet has left box */
+	IPS_CONFIRMED_BIT =3D 3,
+	IPS_CONFIRMED =3D (1 << IPS_CONFIRMED_BIT),
 };
=20
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
@@ -159,7 +164,7 @@
 	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
=20
 	/* Have we seen traffic both ways yet? (bitset) */
-	volatile unsigned long status;
+	unsigned long status;
=20
 	/* Timer function; drops refcnt when it goes off. */
 	struct timer_list timeout;
@@ -254,7 +259,7 @@
 /* It's confirmed if it is, or has been in the hash table. */
 static inline int is_confirmed(struct ip_conntrack *ct)
 {
-	return ct->tuplehash[IP_CT_DIR_ORIGINAL].list.next !=3D NULL;
+	return test_bit(IPS_CONFIRMED_BIT, &ct->status);
 }
=20
 extern unsigned int ip_conntrack_htable_size;
diff -urN --exclude-from=3Ddiff.exclude linux-2.4.20-base/net/ipv4/netfilte=
r/ip_conntrack_core.c linux-2.4.20-del/net/ipv4/netfilter/ip_conntrack_core=
.c
--- linux-2.4.20-base/net/ipv4/netfilter/ip_conntrack_core.c	Tue Feb 18 17:=
08:21 2003
+++ linux-2.4.20-del/net/ipv4/netfilter/ip_conntrack_core.c	Fri Feb 21 17:0=
1:39 2003
@@ -292,9 +292,6 @@
 {
 	DEBUGP("clean_from_lists(%p)\n", ct);
 	MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);
-	/* Remove from both hash lists: must not NULL out next ptrs,
-           otherwise we'll look unconfirmed.  Fortunately, LIST_DELETE
-           doesn't do this. --RR */
 	LIST_DELETE(&ip_conntrack_hash
 		    [hash_conntrack(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple)],
 		    &ct->tuplehash[IP_CT_DIR_ORIGINAL]);
@@ -467,6 +464,7 @@
 		ct->timeout.expires +=3D jiffies;
 		add_timer(&ct->timeout);
 		atomic_inc(&ct->ct_general.use);
+		set_bit(IPS_CONFIRMED_BIT, &ct->status);
 		WRITE_UNLOCK(&ip_conntrack_lock);
 		return NF_ACCEPT;
 	}
@@ -585,7 +583,7 @@
    connection.  Too bad: we're in trouble anyway. */
 static inline int unreplied(const struct ip_conntrack_tuple_hash *i)
 {
-	return !(i->ctrack->status & IPS_ASSURED);
+	return !(test_bit(IPS_ASSURED_BIT, &i->ctrack->status));
 }
=20
 static int early_drop(struct list_head *chain)
@@ -720,7 +718,7 @@
 			conntrack, expected);
 		/* Welcome, Mr. Bond.  We've been expecting you... */
 		IP_NF_ASSERT(master_ct(conntrack));
-		conntrack->status =3D IPS_EXPECTED;
+		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
 		conntrack->master =3D expected;
 		expected->sibling =3D conntrack;
 		LIST_DELETE(&ip_conntrack_expect_list, expected);
@@ -768,11 +766,11 @@
 		*set_reply =3D 1;
 	} else {
 		/* Once we've had two way comms, always ESTABLISHED. */
-		if (h->ctrack->status & IPS_SEEN_REPLY) {
+		if (test_bit(IPS_SEEN_REPLY_BIT, &h->ctrack->status)) {
 			DEBUGP("ip_conntrack_in: normal packet for %p\n",
 			       h->ctrack);
 		        *ctinfo =3D IP_CT_ESTABLISHED;
-		} else if (h->ctrack->status & IPS_EXPECTED) {
+		} else if (test_bit(IPS_EXPECTED_BIT, &h->ctrack->status)) {
 			DEBUGP("ip_conntrack_in: related packet for %p\n",
 			       h->ctrack);
 			*ctinfo =3D IP_CT_RELATED;
diff -urN --exclude-from=3Ddiff.exclude linux-2.4.20-base/net/ipv4/netfilte=
r/ip_conntrack_proto_tcp.c linux-2.4.20-del/net/ipv4/netfilter/ip_conntrack=
_proto_tcp.c
--- linux-2.4.20-base/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Tue Feb 1=
8 17:07:26 2003
+++ linux-2.4.20-del/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Fri Feb 21=
 17:03:35 2003
@@ -192,7 +192,7 @@
 	   have an established connection: this is a fairly common
 	   problem case, so we can delete the conntrack
 	   immediately.  --RR */
-	if (!(conntrack->status & IPS_SEEN_REPLY) && tcph->rst) {
+	if (!test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status) && tcph->rst) {
 		WRITE_UNLOCK(&tcp_lock);
 		if (del_timer(&conntrack->timeout))
 			conntrack->timeout.function((unsigned long)conntrack);
diff -urN --exclude-from=3Ddiff.exclude linux-2.4.20-base/net/ipv4/netfilte=
r/ip_conntrack_proto_udp.c linux-2.4.20-del/net/ipv4/netfilter/ip_conntrack=
_proto_udp.c
--- linux-2.4.20-base/net/ipv4/netfilter/ip_conntrack_proto_udp.c	Fri Nov 2=
9 00:53:15 2002
+++ linux-2.4.20-del/net/ipv4/netfilter/ip_conntrack_proto_udp.c	Fri Feb 21=
 17:01:39 2003
@@ -51,7 +51,7 @@
 {
 	/* If we've seen traffic both ways, this is some kind of UDP
 	   stream.  Extend timeout. */
-	if (conntrack->status & IPS_SEEN_REPLY) {
+	if (test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)) {
 		ip_ct_refresh(conntrack, UDP_STREAM_TIMEOUT);
 		/* Also, more likely to be important, and not a probe */
 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
diff -urN --exclude-from=3Ddiff.exclude linux-2.4.20-base/net/ipv4/netfilte=
r/ip_conntrack_standalone.c linux-2.4.20-del/net/ipv4/netfilter/ip_conntrac=
k_standalone.c
--- linux-2.4.20-base/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Nov =
29 00:53:15 2002
+++ linux-2.4.20-del/net/ipv4/netfilter/ip_conntrack_standalone.c	Fri Feb 2=
1 21:10:37 2003
@@ -77,7 +77,7 @@
 }
=20
 static unsigned int
-print_conntrack(char *buffer, const struct ip_conntrack *conntrack)
+print_conntrack(char *buffer, struct ip_conntrack *conntrack)
 {
 	unsigned int len;
 	struct ip_conntrack_protocol *proto
@@ -95,12 +95,12 @@
 	len +=3D print_tuple(buffer + len,
 			   &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
 			   proto);
-	if (!(conntrack->status & IPS_SEEN_REPLY))
+	if (!(test_bit(IPS_SEEN_REPLY_BIT, &conntrack->status)))
 		len +=3D sprintf(buffer + len, "[UNREPLIED] ");
 	len +=3D print_tuple(buffer + len,
 			   &conntrack->tuplehash[IP_CT_DIR_REPLY].tuple,
 			   proto);
-	if (conntrack->status & IPS_ASSURED)
+	if (test_bit(IPS_ASSURED_BIT, &conntrack->status))
 		len +=3D sprintf(buffer + len, "[ASSURED] ");
 	len +=3D sprintf(buffer + len, "use=3D%u ",
 		       atomic_read(&conntrack->ct_general.use));


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+XQpGXaXGVTD0i/8RAteiAJ0VLURDuSAL8YYczi2ly9JUzXLM4gCeLJzu
lfe5W7QC1YJ+XsQ7vuXh+s4=
=JC0Z
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
