From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] netfilter cosmetic changes
Date: Tue, 24 Jun 2003 16:13:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030624141326.GH2645@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
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


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

I decided to merge the cosmetic changes into one big patch.  They are
meant to be incremental to the 7 fixes I've sent you already.


- The 04_newnat-udp-helper patch submitted to 2.4.20 introduced an
  unused variable.  This patch gets rid of it.
- Removes dead code in case CONFIG_SYSCTL is not defined
- Change order of NFC_ defines in netfilter.h to be more logical.  Add
  comment that <=3D 0x2000 are already used
- Removes some old outdated comments
- Removes an obslete check (master_ct() checks for ct->master, no
  need for the caller to do it before).
- Remove some unneeded initializiations / memsets
- Clean up some ip_conntrack_core code (use some common macro instead of
  reimplementing list iteration again).


--- linux-2.4.21-unconfirmed_expect/include/linux/netfilter.h	2003-06-24 16=
:00:38.000000000 +0200
+++ linux-2.4.21-cosmetic/include/linux/netfilter.h	2003-06-24 16:15:36.000=
000000 +0200
@@ -19,9 +19,10 @@
 #define NF_REPEAT 4
 #define NF_MAX_VERDICT NF_REPEAT
=20
-/* Generic cache responses from hook functions. */
-#define NFC_ALTERED 0x8000
+/* Generic cache responses from hook functions.
+   <=3D 0x2000 is used for protocol-flags. */
 #define NFC_UNKNOWN 0x4000
+#define NFC_ALTERED 0x8000
=20
 #ifdef __KERNEL__
 #include <linux/config.h>
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
unconfirmed_expect/net/ipv4/netfilter/ip_conntrack_core.c linux-2.4.21-cosm=
etic/net/ipv4/netfilter/ip_conntrack_core.c
--- linux-2.4.21-unconfirmed_expect/net/ipv4/netfilter/ip_conntrack_core.c	=
2003-06-24 15:58:40.000000000 +0200
+++ linux-2.4.21-cosmetic/net/ipv4/netfilter/ip_conntrack_core.c	2003-06-24=
 16:15:36.000000000 +0200
@@ -264,9 +264,7 @@
=20
 	DEBUGP("remove_expectations(%p)\n", ct);
=20
-	for (exp_entry =3D ct->sibling_list.next;
-	     exp_entry !=3D &ct->sibling_list; exp_entry =3D next) {
-		next =3D exp_entry->next;
+	list_for_each_safe(exp_entry, next, &ct->sibling_list) {
 		exp =3D list_entry(exp_entry, struct ip_conntrack_expect,
 				 expected_list);
=20
@@ -313,7 +311,7 @@
 	IP_NF_ASSERT(atomic_read(&nfct->use) =3D=3D 0);
 	IP_NF_ASSERT(!timer_pending(&ct->timeout));
=20
-	if (ct->master && master_ct(ct))
+	if (master_ct(ct))
 		ip_conntrack_put(master_ct(ct));
=20
 	/* To make sure we don't get any weird locking issues here:
@@ -695,9 +693,6 @@
=20
 	INIT_LIST_HEAD(&conntrack->sibling_list);
=20
-	/* Mark clearly that it's not in the hash table. */
-	conntrack->tuplehash[IP_CT_DIR_ORIGINAL].list.next =3D NULL;
-
 	WRITE_LOCK(&ip_conntrack_lock);
 	/* Need finding and deleting of expected ONLY if we win race */
 	READ_LOCK(&ip_conntrack_expect_tuple_lock);
@@ -1036,18 +1031,11 @@
 		return -ENOMEM;
 	}
 =09
-	/* Zero out the new structure, then fill out it with the data */
 	DEBUGP("new expectation %p of conntrack %p\n", new, related_to);
-	memset(new, 0, sizeof(*expect));
-	INIT_LIST_HEAD(&new->list);
-	INIT_LIST_HEAD(&new->expected_list);
 	memcpy(new, expect, sizeof(*expect));
 	new->expectant =3D related_to;
 	new->sibling =3D NULL;
-	/* increase usage count. This sucks. The memset above overwrites
-	 * old usage count [if still present] and we increase to one.  Only
-	 * works because everything is done under ip_conntrack_lock() */
-	atomic_inc(&new->use);
+	atomic_set(&new->use, 1);
 =09
 	/* add to expected list for this connection */=09
 	list_add(&new->expected_list, &related_to->sibling_list);
@@ -1486,8 +1474,10 @@
 	ip_ct_attach =3D ip_conntrack_attach;
 	return ret;
=20
+#ifdef CONFIG_SYSCTL
 err_free_ct_cachep:
 	kmem_cache_destroy(ip_conntrack_cachep);
+#endif /*CONFIG_SYSCTL*/
 err_free_hash:
 	vfree(ip_conntrack_hash);
 err_unreg_sockopt:
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
unconfirmed_expect/net/ipv4/netfilter/ip_conntrack_ftp.c linux-2.4.21-cosme=
tic/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.4.21-unconfirmed_expect/net/ipv4/netfilter/ip_conntrack_ftp.c	2=
003-06-24 15:56:23.000000000 +0200
+++ linux-2.4.21-cosmetic/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-06-24 =
16:15:36.000000000 +0200
@@ -405,7 +405,6 @@
 		ports[0] =3D FTP_PORT;
=20
 	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
-		memset(&ftp[i], 0, sizeof(struct ip_conntrack_helper));
 		ftp[i].tuple.src.u.tcp.port =3D htons(ports[i]);
 		ftp[i].tuple.dst.protonum =3D IPPROTO_TCP;
 		ftp[i].mask.src.u.tcp.port =3D 0xFFFF;
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
unconfirmed_expect/net/ipv4/netfilter/ip_conntrack_irc.c linux-2.4.21-cosme=
tic/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.4.21-unconfirmed_expect/net/ipv4/netfilter/ip_conntrack_irc.c	2=
003-06-24 15:56:23.000000000 +0200
+++ linux-2.4.21-cosmetic/net/ipv4/netfilter/ip_conntrack_irc.c	2003-06-24 =
16:15:36.000000000 +0200
@@ -259,8 +259,6 @@
=20
 	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
 		hlpr =3D &irc_helpers[i];
-		memset(hlpr, 0,
-		       sizeof(struct ip_conntrack_helper));
 		hlpr->tuple.src.u.tcp.port =3D htons(ports[i]);
 		hlpr->tuple.dst.protonum =3D IPPROTO_TCP;
 		hlpr->mask.src.u.tcp.port =3D 0xFFFF;
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
unconfirmed_expect/net/ipv4/netfilter/ip_nat_ftp.c linux-2.4.21-cosmetic/ne=
t/ipv4/netfilter/ip_nat_ftp.c
--- linux-2.4.21-unconfirmed_expect/net/ipv4/netfilter/ip_nat_ftp.c	2003-06=
-24 15:58:01.000000000 +0200
+++ linux-2.4.21-cosmetic/net/ipv4/netfilter/ip_nat_ftp.c	2003-06-24 16:15:=
36.000000000 +0200
@@ -306,9 +306,6 @@
 		ports[0] =3D FTP_PORT;
=20
 	for (i =3D 0; (i < MAX_PORTS) && ports[i]; i++) {
-
-		memset(&ftp[i], 0, sizeof(struct ip_nat_helper));
-
 		ftp[i].tuple.dst.protonum =3D IPPROTO_TCP;
 		ftp[i].tuple.src.u.tcp.port =3D htons(ports[i]);
 		ftp[i].mask.dst.protonum =3D 0xFFFF;
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
unconfirmed_expect/net/ipv4/netfilter/ip_nat_helper.c linux-2.4.21-cosmetic=
/net/ipv4/netfilter/ip_nat_helper.c
--- linux-2.4.21-unconfirmed_expect/net/ipv4/netfilter/ip_nat_helper.c	2003=
-06-13 16:51:39.000000000 +0200
+++ linux-2.4.21-cosmetic/net/ipv4/netfilter/ip_nat_helper.c	2003-06-24 16:=
15:36.000000000 +0200
@@ -84,7 +84,6 @@
 	iph =3D (*skb)->nh.iph;
 	if (iph->protocol =3D=3D IPPROTO_TCP) {
 		struct tcphdr *tcph =3D (void *)iph + iph->ihl*4;
-		void *data =3D (void *)tcph + tcph->doff*4;
=20
 		DEBUGP("ip_nat_resize_packet: Seq_offset before: ");
 		DUMP_OFFSET(this_way);
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
unconfirmed_expect/net/ipv4/netfilter/ip_nat_irc.c linux-2.4.21-cosmetic/ne=
t/ipv4/netfilter/ip_nat_irc.c
--- linux-2.4.21-unconfirmed_expect/net/ipv4/netfilter/ip_nat_irc.c	2002-11=
-29 00:53:15.000000000 +0100
+++ linux-2.4.21-cosmetic/net/ipv4/netfilter/ip_nat_irc.c	2003-06-24 16:15:=
36.000000000 +0200
@@ -243,9 +243,6 @@
=20
 	for (i =3D 0; (i < MAX_PORTS) && ports[i] !=3D 0; i++) {
 		hlpr =3D &ip_nat_irc_helpers[i];
-		memset(hlpr, 0,
-		       sizeof(struct ip_nat_helper));
-
 		hlpr->tuple.dst.protonum =3D IPPROTO_TCP;
 		hlpr->tuple.src.u.tcp.port =3D htons(ports[i]);
 		hlpr->mask.src.u.tcp.port =3D 0xFFFF;
diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*=
=2Eflags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.21-=
unconfirmed_expect/net/ipv4/netfilter/ipt_ULOG.c linux-2.4.21-cosmetic/net/=
ipv4/netfilter/ipt_ULOG.c
--- linux-2.4.21-unconfirmed_expect/net/ipv4/netfilter/ipt_ULOG.c	2003-06-1=
3 16:51:39.000000000 +0200
+++ linux-2.4.21-cosmetic/net/ipv4/netfilter/ipt_ULOG.c	2003-06-24 16:15:36=
=2E000000000 +0200
@@ -322,7 +322,6 @@
=20
 	/* initialize ulog_buffers */
 	for (i =3D 0; i < ULOG_MAXNLGROUPS; i++) {
-		memset(&ulog_buffers[i], 0, sizeof(ulog_buff_t));
 		init_timer(&ulog_buffers[i].timer);
 		ulog_buffers[i].timer.function =3D ulog_timer;
 		ulog_buffers[i].timer.data =3D i;

Please apply, thanks.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE++FyGXaXGVTD0i/8RAn6hAJ4+R6HIh9X1NWriWn+9SSdHmL8XuQCgsUzo
CWKgXUi3cZbhH7ke5VM0T3g=
=bzlp
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
