From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCH] rename death_by_timeout to ip_ct_death_by_timeout (1/4)
Date: 06 Jun 2002 14:24:03 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023365301.734.15.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-jYGejhnAHQIUwlsavGtZ"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-jYGejhnAHQIUwlsavGtZ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I changed the timer-update code in ip_ct_refresh() and then I found out
that the pptp helper abuses it to kill a conntrack which won't work with
my changes, the solution: change the pptp helper to do it correctly.

This first patch renames death_by_timeout to ip_ct_death_by_timeout and
exports it in the core conntrack files. The pptp change will be included
in the next patch.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-jYGejhnAHQIUwlsavGtZ
Content-Disposition: attachment; filename=ip_conntrack-death-diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_conntrack-death-diff; charset=ISO-8859-15

--- linux-2.4.19-pre9/include/linux/netfilter_ipv4/ip_conntrack.h.orig	Mon =
Jun  3 21:46:59 2002
+++ linux-2.4.19-pre9/include/linux/netfilter_ipv4/ip_conntrack.h	Mon Jun  =
3 21:46:37 2002
@@ -226,6 +226,9 @@
 extern void ip_ct_refresh(struct ip_conntrack *ct,
 			  unsigned long extra_jiffies);
=20
+/* Kill conntrack */
+extern void ip_ct_death_by_timeout(unsigned long ul_conntrack);
+
 /* These are for NAT.  Icky. */
 /* Call me when a conntrack is destroyed. */
 extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
--- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c.orig	Mon Jun  =
3 20:32:28 2002
+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c	Tue Jun  4 20:=
56:18 2002
@@ -267,7 +267,7 @@
 	atomic_dec(&ip_conntrack_count);
 }
=20
-static void death_by_timeout(unsigned long ul_conntrack)
+void ip_ct_death_by_timeout(unsigned long ul_conntrack)
 {
 	struct ip_conntrack *ct =3D (void *)ul_conntrack;
=20
@@ -527,7 +527,7 @@
 		return dropped;
=20
 	if (del_timer(&h->ctrack->timeout)) {
-		death_by_timeout((unsigned long)h->ctrack);
+		ip_ct_death_by_timeout((unsigned long)h->ctrack);
 		dropped =3D 1;
 	}
 	ip_conntrack_put(h->ctrack);
@@ -617,7 +617,7 @@
 	/* Don't set timer yet: wait for confirmation */
 	init_timer(&conntrack->timeout);
 	conntrack->timeout.data =3D (unsigned long)conntrack;
-	conntrack->timeout.function =3D death_by_timeout;
+	conntrack->timeout.function =3D ip_ct_death_by_timeout;
=20
 	INIT_LIST_HEAD(&conntrack->sibling_list);
=20
@@ -1198,7 +1189,7 @@
 	while ((h =3D get_next_corpse(kill, data)) !=3D NULL) {
 		/* Time to push up daises... */
 		if (del_timer(&h->ctrack->timeout))
-			death_by_timeout((unsigned long)h->ctrack);
+			ip_ct_death_by_timeout((unsigned long)h->ctrack);
 		/* ... else the timer will get him soon. */
=20
 		ip_conntrack_put(h->ctrack);
--- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_standalone.c.orig	Mon=
 Jun  3 21:43:04 2002
+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_standalone.c	Mon Jun =
 3 21:47:43 2002
@@ -362,6 +362,7 @@
 EXPORT_SYMBOL(ip_conntrack_helper_unregister);
 EXPORT_SYMBOL(ip_ct_selective_cleanup);
 EXPORT_SYMBOL(ip_ct_refresh);
+EXPORT_SYMBOL(ip_ct_death_by_timeout);
 EXPORT_SYMBOL(ip_ct_find_proto);
 EXPORT_SYMBOL(ip_ct_find_helper);
 EXPORT_SYMBOL(ip_conntrack_expect_related);

--=-jYGejhnAHQIUwlsavGtZ--
