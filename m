From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] remove exessive timer updates (3/4)
Date: 12 Jun 2002 21:02:29 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <1023908549.19812.106.camel@tux>
References: <1023365846.845.26.camel@tux>
	<20020611095922.G11177@sunbeam.de.gnumonks.org>
	<200206120021.15472@henrik.marasystems.com>  <1023873045.19812.95.camel@tux>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-CdBHDPMQTpJUK9WSdcce"
Cc: Harald Welte <laforge@gnumonks.org>,
	Netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <1023873045.19812.95.camel@tux>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-CdBHDPMQTpJUK9WSdcce
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2002-06-12 at 11:10, Martin Josefsson wrote:
> On Wed, 2002-06-12 at 00:21, Henrik Nordstrom wrote:
>
> > Haven't looked at the patch, but one thing to look out for is to make 
> > sure timer transitions is not lost.
> > 
> > Unlike atime updates, conntrack timers vary in length depending on the 
> > state. It would not be fun if a TIME_WAIT state got a timeout of 
> > ESTABLISHED only because the transition was too quick to be noticed 
> > by the timer update filter..
> 
> Yes I thought about it yesterday and I'll send Harald a new patch which
> will allow us to force an update.

Here's that patch, it's against current cvs. (the patch is a little
messy because ip_ct_death_by_timeout isn't separated from ip_ct_refresh
in the patch anymore)

It adds a new parameter to ip_ct_refresh called force, if set to
non-zero a timer update will be forced.

I hope the tcp-change is correct, I havn't tested this patch yet but it
does compile :) I'm going to test it in a few minutes.

ip_ct_refresh(conntrack, tcp_timeouts[newconntrack], newconntrack !=
oldtcpstate);

so if the state changes we force a timer update, otherwise we only
update if there's been >HZ jiffies since the last update.

Harald, does the tcp change in the patch look like it could work?

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-CdBHDPMQTpJUK9WSdcce
Content-Disposition: attachment; filename=ip_ct_refresh_optimization.patch-diff-2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_ct_refresh_optimization.patch-diff-2;
	charset=ISO-8859-15

--- netfilter/userspace/patch-o-matic/optimizations/ip_ct_refresh_optimizat=
ion.patch.orig	Tue Jun 11 10:02:57 2002
+++ netfilter/userspace/patch-o-matic/optimizations/ip_ct_refresh_optimizat=
ion.patch	Wed Jun 12 20:45:29 2002
@@ -1,17 +1,20 @@
---- linux-2.4.19-pre9/include/linux/netfilter_ipv4/ip_conntrack.h.orig	Mon=
 Jun  3 21:46:59 2002
-+++ linux-2.4.19-pre9/include/linux/netfilter_ipv4/ip_conntrack.h	Mon Jun =
 3 21:46:37 2002
-@@ -226,6 +226,9 @@
- extern void ip_ct_refresh(struct ip_conntrack *ct,
- 			  unsigned long extra_jiffies);
+--- linux-2.4.19-pre10/include/linux/netfilter_ipv4/ip_conntrack.h.orig	We=
d Jun 12 20:25:54 2002
++++ linux-2.4.19-pre10/include/linux/netfilter_ipv4/ip_conntrack.h	Wed Jun=
 12 20:26:20 2002
+@@ -224,7 +224,10 @@
 =20
-+/* Kill conntrack */
-+extern void ip_ct_death_by_timeout(unsigned long ul_conntrack);
+ /* Refresh conntrack for this many jiffies */
+ extern void ip_ct_refresh(struct ip_conntrack *ct,
+-			  unsigned long extra_jiffies);
++			  unsigned long extra_jiffies, int force);
 +
++/* Kill conntrack */  =20
++extern void ip_ct_death_by_timeout(unsigned long ul_conntrack);
+=20
  /* These are for NAT.  Icky. */
  /* Call me when a conntrack is destroyed. */
- extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
---- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c.orig	Mon Jun =
 3 20:32:28 2002
-+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c	Tue Jun  4 20=
:56:18 2002
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_core.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_core.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_core.c	Wed Jun=
 12 20:22:08 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_core.c	Wed Jun 12 2=
0:36:23 2002
 @@ -267,7 +267,7 @@
  	atomic_dec(&ip_conntrack_count);
  }
@@ -21,7 +24,7 @@
  {
  	struct ip_conntrack *ct =3D (void *)ul_conntrack;
 =20
-@@ -527,7 +527,7 @@
+@@ -528,7 +528,7 @@
  		return dropped;
 =20
  	if (del_timer(&h->ctrack->timeout)) {
@@ -30,7 +33,7 @@
  		dropped =3D 1;
  	}
  	ip_conntrack_put(h->ctrack);
-@@ -617,7 +617,7 @@
+@@ -618,7 +618,7 @@
  	/* Don't set timer yet: wait for confirmation */
  	init_timer(&conntrack->timeout);
  	conntrack->timeout.data =3D (unsigned long)conntrack;
@@ -39,7 +42,29 @@
 =20
  	INIT_LIST_HEAD(&conntrack->sibling_list);
 =20
-@@ -1198,7 +1189,7 @@
+@@ -1072,7 +1072,7 @@
+ }
+=20
+ /* Refresh conntrack for this many jiffies. */
+-void ip_ct_refresh(struct ip_conntrack *ct, unsigned long extra_jiffies)
++void ip_ct_refresh(struct ip_conntrack *ct, unsigned long extra_jiffies, =
int force)
+ {
+ 	IP_NF_ASSERT(ct->timeout.data =3D=3D (unsigned long)ct);
+=20
+@@ -1081,8 +1081,10 @@
+ 	if (!is_confirmed(ct))
+ 		ct->timeout.expires =3D extra_jiffies;
+ 	else {
+-		/* Need del_timer for race avoidance (may already be dying). */
+-		if (del_timer(&ct->timeout)) {
++		/* Don't update timer for each packet, only if it's been >HZ
++		 * ticks since last update or we are forcing.
++		 * Need del_timer for race avoidance (may already be dying). */
++		if ((force || time_after(jiffies, ct->timeout.expires - extra_jiffies +=
 HZ)) && del_timer(&ct->timeout)) {
+ 			ct->timeout.expires =3D jiffies + extra_jiffies;
+ 			add_timer(&ct->timeout);
+ 		}
+@@ -1188,7 +1190,7 @@
  	while ((h =3D get_next_corpse(kill, data)) !=3D NULL) {
  		/* Time to push up daises... */
  		if (del_timer(&h->ctrack->timeout))
@@ -48,8 +73,9 @@
  		/* ... else the timer will get him soon. */
 =20
  		ip_conntrack_put(h->ctrack);
---- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_standalone.c.orig	Mo=
n Jun  3 21:43:04 2002
-+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_standalone.c	Mon Jun=
  3 21:47:43 2002
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_standalone.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_s=
tandalone.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_standalone.c	W=
ed Jun 12 20:22:08 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_standalone.c	Mon Ju=
n  3 21:47:43 2002
 @@ -362,6 +362,7 @@
  EXPORT_SYMBOL(ip_conntrack_helper_unregister);
  EXPORT_SYMBOL(ip_ct_selective_cleanup);
@@ -58,45 +84,92 @@
  EXPORT_SYMBOL(ip_ct_find_proto);
  EXPORT_SYMBOL(ip_ct_find_helper);
  EXPORT_SYMBOL(ip_conntrack_expect_related);
---- linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c.orig	Mon Jun =
 3 20:32:28 2002
-+++ linux-2.4.19-pre9/net/ipv4/netfilter/ip_conntrack_core.c	Mon Jun  3 20=
:48:13 2002
-@@ -1091,8 +1091,10 @@
- 	if (!is_confirmed(ct))
- 		ct->timeout.expires =3D extra_jiffies;
- 	else {
--		/* Need del_timer for race avoidance (may already be dying). */
--		if (del_timer(&ct->timeout)) {
-+		/* Don't update timer for each packet, only if it's been >HZ
-+		 * ticks since last update.
-+		 * Need del_timer for race avoidance (may already be dying). */
-+		if (time_after(jiffies, ct->timeout.expires - extra_jiffies + HZ) && de=
l_timer(&ct->timeout)) {
- 			ct->timeout.expires =3D jiffies + extra_jiffies;
- 			add_timer(&ct->timeout);
- 		}
---- netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch.orig	=
Thu Jun  6 14:03:35 2002
-+++ netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch	Thu J=
un  6 14:05:17 2002
-@@ -572,7 +572,7 @@
- diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '=
.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.18-=
newnat/net/ipv4/netfilter/ip_conntrack_pptp.c linux-2.4.18-pptp3.01//net/ip=
v4/netfilter/ip_conntrack_pptp.c
- --- linux-2.4.18-newnat/net/ipv4/netfilter/ip_conntrack_pptp.c	Thu Jan  1=
 01:00:00 1970
- +++ linux-2.4.18-pptp3.01//net/ipv4/netfilter/ip_conntrack_pptp.c	Mon Apr=
  8 16:40:37 2002
--@@ -0,0 +1,540 @@
-+@@ -0,0 +1,542 @@
- +/*
- + * ip_conntrack_pptp.c	- Version $Revision: 1.1 $
- + *
-@@ -682,11 +682,13 @@
- +		if (!exp->sibling)
- +			continue;
- +
--+		DEBUGP("setting timeout of conntrack %p to 0\n",
-++		DEBUGP("killing conntrack %p\n",
- +			exp->sibling);
- +		exp->sibling->proto.gre.timeout =3D 0;
- +		exp->sibling->proto.gre.stream_timeout =3D 0;
--+		ip_ct_refresh(exp->sibling, 0);
-++
-++		if (del_timer(&exp->sibling->timeout))
-++			ip_ct_death_by_timeout((unsigned long)exp->sibling);
- +	}
- +
- +	return 0;
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_pptp.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_pptp.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_pptp.c	Wed Jun=
 12 20:23:10 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_pptp.c	Mon Jun  3 2=
1:48:38 2002
+@@ -107,11 +107,13 @@
+ 		if (!exp->sibling)
+ 			continue;
+=20
+-		DEBUGP("setting timeout of conntrack %p to 0\n",
++		DEBUGP("killing conntrack %p\n",
+ 			exp->sibling);
+ 		exp->sibling->proto.gre.timeout =3D 0;
+ 		exp->sibling->proto.gre.stream_timeout =3D 0;
+-		ip_ct_refresh(exp->sibling, 0);
++
++		if (del_timer(&exp->sibling->timeout))
++			ip_ct_death_by_timeout((unsigned long)exp->sibling);
+ 	}
+=20
+ 	return 0;
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_proto_generic.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrac=
k_proto_generic.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_proto_generic.=
c	Sat Apr 13 19:08:16 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_proto_generic.c	Wed=
 Jun 12 20:32:55 2002
+@@ -43,7 +43,7 @@
+ 		       struct iphdr *iph, size_t len,
+ 		       enum ip_conntrack_info conntrackinfo)
+ {
+-	ip_ct_refresh(conntrack, GENERIC_TIMEOUT);
++	ip_ct_refresh(conntrack, GENERIC_TIMEOUT, 0);
+ 	return NF_ACCEPT;
+ }
+=20
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_proto_gre.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_pr=
oto_gre.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_proto_gre.c	Sa=
t May 18 23:14:38 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_proto_gre.c	Wed Jun=
 12 20:33:18 2002
+@@ -232,11 +232,11 @@
+ 	/* If we've seen traffic both ways, this is a GRE connection.
+ 	 * Extend timeout. */
+ 	if (ct->status & IPS_SEEN_REPLY) {
+-		ip_ct_refresh(ct, ct->proto.gre.stream_timeout);
++		ip_ct_refresh(ct, ct->proto.gre.stream_timeout, 0);
+ 		/* Also, more likely to be important, and not a probe. */
+ 		set_bit(IPS_ASSURED_BIT, &ct->status);
+ 	} else
+-		ip_ct_refresh(ct, ct->proto.gre.timeout);
++		ip_ct_refresh(ct, ct->proto.gre.timeout, 0);
+ =09
+ 	return NF_ACCEPT;
+ }
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_proto_icmp.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_p=
roto_icmp.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_proto_icmp.c	S=
at Apr 13 19:08:16 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_proto_icmp.c	Wed Ju=
n 12 20:33:34 2002
+@@ -82,7 +82,7 @@
+ 			ct->timeout.function((unsigned long)ct);
+ 	} else {
+ 		atomic_inc(&ct->proto.icmp.count);
+-		ip_ct_refresh(ct, ICMP_TIMEOUT);
++		ip_ct_refresh(ct, ICMP_TIMEOUT, 0);
+ 	}
+=20
+ 	return NF_ACCEPT;
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_proto_tcp.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_pr=
oto_tcp.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_proto_tcp.c	We=
d May 22 14:55:14 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	Wed Jun=
 12 20:32:39 2002
+@@ -229,7 +229,7 @@
+ 		    && tcph->ack_seq =3D=3D conntrack->proto.tcp.handshake_ack)
+ 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
+=20
+-		ip_ct_refresh(conntrack, tcp_timeouts[newconntrack]);
++		ip_ct_refresh(conntrack, tcp_timeouts[newconntrack], newconntrack !=3D =
oldtcpstate);
+ 	}
+=20
+ 	return NF_ACCEPT;
+diff --exclude=3D*.orig -ur linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_=
conntrack_proto_udp.c linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_pr=
oto_udp.c
+--- linux-2.4.19-pre10/net/ipv4/netfilter.orig/ip_conntrack_proto_udp.c	Sa=
t Apr 13 19:08:16 2002
++++ linux-2.4.19-pre10/net/ipv4/netfilter/ip_conntrack_proto_udp.c	Wed Jun=
 12 20:34:39 2002
+@@ -52,11 +52,11 @@
+ 	/* If we've seen traffic both ways, this is some kind of UDP
+ 	   stream.  Extend timeout. */
+ 	if (conntrack->status & IPS_SEEN_REPLY) {
+-		ip_ct_refresh(conntrack, UDP_STREAM_TIMEOUT);
++		ip_ct_refresh(conntrack, UDP_STREAM_TIMEOUT, 0);
+ 		/* Also, more likely to be important, and not a probe */
+ 		set_bit(IPS_ASSURED_BIT, &conntrack->status);
+ 	} else
+-		ip_ct_refresh(conntrack, UDP_TIMEOUT);
++		ip_ct_refresh(conntrack, UDP_TIMEOUT, 0);
+=20
+ 	return NF_ACCEPT;
+ }

--=-CdBHDPMQTpJUK9WSdcce--
