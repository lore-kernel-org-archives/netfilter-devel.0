From: Sven Schuster <schuster.sven@gmx.de>
Subject: [PATCH] reconverted old pom to pom-ng
Date: Thu, 19 Feb 2004 20:06:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040219190646.GA886@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable



Hello Harald,

here is the diff from re-converting the old pom to pom-ng after the
fix to convert2pomng.sh. The following patches have been affected:

base/raw.patch
extra/CONNMARK.patch
extra/cuseeme-nat.patch
extra/h323-conntrack-nat.patch
extra/mms-conntrack-nat.patch
extra/nfnetlink-ctnetlink-0.13.patch
extra/pptp-conntrack-nat.patch
extra/quake3-conntrack.patch
extra/rsh.patch
extra/rtsp-conntrack.patch
extra/talk-conntrack-nat.patch


I did one extra check on it, should be fine. I worked on an up-to-date
version of pom and pom-ng. BTW what I noticed after updating my local
CVS tree, some of the linux.patch files are gone, e.g. the one in=20
nfnetlink-ctnetlink-0.13!? I didn't include them in this patch, just
the files affected by yesterday's fix.


Regards

Sven




diff -Nru patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Config.in=
=2Eladd patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd
--- patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd	=
2003-12-18 19:47:53.000000000 +0100
+++ patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd	2004-=
02-19 19:26:04.767319827 +0100
@@ -1,4 +1,2 @@
-    dep_tristate '  Connection state match support' CONFIG_IP_NF_MATCH_STA=
TE $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES=20
-    if [ "$CONFIG_IP_NF_CONNTRACK_MARK" !=3D "n" ]; then
-      dep_tristate '  Connection mark match support' CONFIG_IP_NF_MATCH_CO=
NNMARK $CONFIG_IP_NF_IPTABLES
-    fi
+  dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
+  bool '  Connection mark tracking support' CONFIG_IP_NF_CONNTRACK_MARK
diff -Nru patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Config.in=
=2Eladd_2 patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd=
_2
--- patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd_=
2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd_2	200=
4-02-19 19:26:04.775314055 +0100
@@ -0,0 +1,4 @@
+  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_N=
F_IPTABLES
+  if [ "$CONFIG_IP_NF_CONNTRACK_MARK" !=3D "n" ]; then
+    dep_tristate '  CONNMARK target support' CONFIG_IP_NF_TARGET_CONNMARK =
$CONFIG_IP_NF_IPTABLES
+  fi
diff -Nru patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Config.in=
=2Eladd_3 patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd=
_3
--- patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd_=
3	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Config.in.ladd_3	200=
4-02-19 19:26:04.783308283 +0100
@@ -0,0 +1,4 @@
+    dep_tristate '  Connection state match support' CONFIG_IP_NF_MATCH_STA=
TE $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES=20
+    if [ "$CONFIG_IP_NF_CONNTRACK_MARK" !=3D "n" ]; then
+      dep_tristate '  Connection mark match support' CONFIG_IP_NF_MATCH_CO=
NNMARK $CONFIG_IP_NF_IPTABLES
+    fi
diff -Nru patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Makefile.=
ladd patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Makefile.ladd
--- patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Makefile.ladd	2=
003-12-18 19:47:53.000000000 +0100
+++ patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Makefile.ladd	2004-0=
2-19 19:26:04.448549976 +0100
@@ -1,2 +1,2 @@
-obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o
-obj-$(CONFIG_IP_NF_TARGET_CONNMARK) +=3D ipt_CONNMARK.o
+obj-$(CONFIG_IP_NF_MATCH_STATE) +=3D ipt_state.o
+obj-$(CONFIG_IP_NF_MATCH_CONNMARK) +=3D ipt_connmark.o
diff -Nru patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Makefile.=
ladd_2 patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Makefile.ladd_2
--- patch-o-matic-ng-orig/CONNMARK/linux/net/ipv4/netfilter/Makefile.ladd_2=
	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/CONNMARK/linux/net/ipv4/netfilter/Makefile.ladd_2	2004=
-02-19 19:26:04.759325598 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o
+obj-$(CONFIG_IP_NF_TARGET_CONNMARK) +=3D ipt_CONNMARK.o
diff -Nru patch-o-matic-ng-orig/cuseeme-nat/linux/net/ipv4/netfilter/Config=
=2Ein.ladd patch-o-matic-ng/cuseeme-nat/linux/net/ipv4/netfilter/Config.in.=
ladd
--- patch-o-matic-ng-orig/cuseeme-nat/linux/net/ipv4/netfilter/Config.in.la=
dd	2003-12-18 19:47:57.000000000 +0100
+++ patch-o-matic-ng/cuseeme-nat/linux/net/ipv4/netfilter/Config.in.ladd	20=
04-02-19 19:26:06.301212512 +0100
@@ -1,8 +1,2 @@
-          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
-        fi
-      fi
-      if [ "$CONFIG_IP_NF_CUSEEME" =3D "m" ]; then
-        define_tristate CONFIG_IP_NF_NAT_CUSEEME m
-      else
-        if [ "$CONFIG_IP_NF_CUSEEME" =3D "y" ]; then
-         define_tristate CONFIG_IP_NF_NAT_CUSEEME $CONFIG_IP_NF_NAT
+  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  CuSeeMe protocol support' CONFIG_IP_NF_CUSEEME $CONFIG_I=
P_NF_CONNTRACK
diff -Nru patch-o-matic-ng-orig/cuseeme-nat/linux/net/ipv4/netfilter/Config=
=2Ein.ladd_2 patch-o-matic-ng/cuseeme-nat/linux/net/ipv4/netfilter/Config.i=
n.ladd_2
--- patch-o-matic-ng-orig/cuseeme-nat/linux/net/ipv4/netfilter/Config.in.la=
dd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/cuseeme-nat/linux/net/ipv4/netfilter/Config.in.ladd_2	=
2004-02-19 19:26:06.308207463 +0100
@@ -0,0 +1,8 @@
+          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
+        fi
+      fi
+      if [ "$CONFIG_IP_NF_CUSEEME" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_CUSEEME m
+      else
+        if [ "$CONFIG_IP_NF_CUSEEME" =3D "y" ]; then
+         define_tristate CONFIG_IP_NF_NAT_CUSEEME $CONFIG_IP_NF_NAT
diff -Nru patch-o-matic-ng-orig/h323-conntrack-nat/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd patch-o-matic-ng/h323-conntrack-nat/linux/in=
clude/linux/netfilter_ipv4/ip_conntrack.h.ladd
--- patch-o-matic-ng-orig/h323-conntrack-nat/linux/include/linux/netfilter_=
ipv4/ip_conntrack.h.ladd	2003-12-18 19:47:58.000000000 +0100
+++ patch-o-matic-ng/h323-conntrack-nat/linux/include/linux/netfilter_ipv4/=
ip_conntrack.h.ladd	2004-02-19 19:26:07.010700395 +0100
@@ -1,2 +1,3 @@
-	/* insert conntrack helper private data (master) here */
-	struct ip_ct_h225_master ct_h225_info;
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+
diff -Nru patch-o-matic-ng-orig/h323-conntrack-nat/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_2 patch-o-matic-ng/h323-conntrack-nat/linux/=
include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2
--- patch-o-matic-ng-orig/h323-conntrack-nat/linux/include/linux/netfilter_=
ipv4/ip_conntrack.h.ladd_2	2004-01-21 15:34:03.000000000 +0100
+++ patch-o-matic-ng/h323-conntrack-nat/linux/include/linux/netfilter_ipv4/=
ip_conntrack.h.ladd_2	2004-02-19 19:26:07.017695346 +0100
@@ -1,2 +1,2 @@
-/* Add protocol helper include file here */
-#include <linux/netfilter_ipv4/ip_conntrack_h323.h>
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_h225_expect exp_h225_info;
diff -Nru patch-o-matic-ng-orig/h323-conntrack-nat/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_3 patch-o-matic-ng/h323-conntrack-nat/linux/=
include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3
--- patch-o-matic-ng-orig/h323-conntrack-nat/linux/include/linux/netfilter_=
ipv4/ip_conntrack.h.ladd_3	2004-01-21 15:34:03.000000000 +0100
+++ patch-o-matic-ng/h323-conntrack-nat/linux/include/linux/netfilter_ipv4/=
ip_conntrack.h.ladd_3	2004-02-19 19:26:07.025689577 +0100
@@ -1,2 +1,2 @@
-	/* insert conntrack helper private data (expect) here */
-	struct ip_ct_h225_expect exp_h225_info;
+	/* insert conntrack helper private data (master) here */
+	struct ip_ct_h225_master ct_h225_info;
diff -Nru patch-o-matic-ng-orig/h323-conntrack-nat/linux/net/ipv4/netfilter=
/Config.in.ladd patch-o-matic-ng/h323-conntrack-nat/linux/net/ipv4/netfilte=
r/Config.in.ladd
--- patch-o-matic-ng-orig/h323-conntrack-nat/linux/net/ipv4/netfilter/Confi=
g.in.ladd	2003-12-18 19:47:58.000000000 +0100
+++ patch-o-matic-ng/h323-conntrack-nat/linux/net/ipv4/netfilter/Config.in.=
ladd	2004-02-19 19:26:06.994711935 +0100
@@ -1,8 +1,2 @@
-      dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIR=
ECT $CONFIG_IP_NF_NAT
-      if [ "$CONFIG_IP_NF_H323" =3D "m" ]; then
-       define_tristate CONFIG_IP_NF_NAT_H323 m
-      else
-        if [ "$CONFIG_IP_NF_H323" =3D "y" ]; then
-          define_tristate CONFIG_IP_NF_NAT_H323 $CONFIG_IP_NF_NAT
-        fi
-      fi
+  dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  H.323 (netmeeting) support' CONFIG_IP_NF_H323 $CONFIG_IP=
_NF_CONNTRACK
diff -Nru patch-o-matic-ng-orig/h323-conntrack-nat/linux/net/ipv4/netfilter=
/Config.in.ladd_2 patch-o-matic-ng/h323-conntrack-nat/linux/net/ipv4/netfil=
ter/Config.in.ladd_2
--- patch-o-matic-ng-orig/h323-conntrack-nat/linux/net/ipv4/netfilter/Confi=
g.in.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/h323-conntrack-nat/linux/net/ipv4/netfilter/Config.in.=
ladd_2	2004-02-19 19:26:07.001706886 +0100
@@ -0,0 +1,8 @@
+      dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIR=
ECT $CONFIG_IP_NF_NAT
+      if [ "$CONFIG_IP_NF_H323" =3D "m" ]; then
+       define_tristate CONFIG_IP_NF_NAT_H323 m
+      else
+        if [ "$CONFIG_IP_NF_H323" =3D "y" ]; then
+          define_tristate CONFIG_IP_NF_NAT_H323 $CONFIG_IP_NF_NAT
+        fi
+      fi
diff -Nru patch-o-matic-ng-orig/mms-conntrack-nat/linux/include/linux/netfi=
lter_ipv4/ip_conntrack.h.ladd patch-o-matic-ng/mms-conntrack-nat/linux/incl=
ude/linux/netfilter_ipv4/ip_conntrack.h.ladd
--- patch-o-matic-ng-orig/mms-conntrack-nat/linux/include/linux/netfilter_i=
pv4/ip_conntrack.h.ladd	2003-12-18 19:47:59.000000000 +0100
+++ patch-o-matic-ng/mms-conntrack-nat/linux/include/linux/netfilter_ipv4/i=
p_conntrack.h.ladd	2004-02-19 19:26:09.485914146 +0100
@@ -1,2 +1,2 @@
-	/* insert conntrack helper private data (master) here */
-	struct ip_ct_mms_master ct_mms_info;
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_mms.h>
diff -Nru patch-o-matic-ng-orig/mms-conntrack-nat/linux/include/linux/netfi=
lter_ipv4/ip_conntrack.h.ladd_2 patch-o-matic-ng/mms-conntrack-nat/linux/in=
clude/linux/netfilter_ipv4/ip_conntrack.h.ladd_2
--- patch-o-matic-ng-orig/mms-conntrack-nat/linux/include/linux/netfilter_i=
pv4/ip_conntrack.h.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/mms-conntrack-nat/linux/include/linux/netfilter_ipv4/i=
p_conntrack.h.ladd_2	2004-02-19 19:26:09.493908377 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_mms_expect exp_mms_info;
diff -Nru patch-o-matic-ng-orig/mms-conntrack-nat/linux/include/linux/netfi=
lter_ipv4/ip_conntrack.h.ladd_3 patch-o-matic-ng/mms-conntrack-nat/linux/in=
clude/linux/netfilter_ipv4/ip_conntrack.h.ladd_3
--- patch-o-matic-ng-orig/mms-conntrack-nat/linux/include/linux/netfilter_i=
pv4/ip_conntrack.h.ladd_3	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/mms-conntrack-nat/linux/include/linux/netfilter_ipv4/i=
p_conntrack.h.ladd_3	2004-02-19 19:26:09.501902609 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (master) here */
+	struct ip_ct_mms_master ct_mms_info;
diff -Nru patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/=
Config.in.ladd patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilter/=
Config.in.ladd
--- patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/Config=
=2Ein.ladd	2003-12-18 19:47:59.000000000 +0100
+++ patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilter/Config.in.l=
add	2004-02-19 19:26:09.469925682 +0100
@@ -1,8 +1,2 @@
-          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
-        fi
-      fi
-      if [ "$CONFIG_IP_NF_MMS" =3D "m" ]; then
-        define_tristate CONFIG_IP_NF_NAT_MMS m
-      else
-        if [ "$CONFIG_IP_NF_MMS" =3D "y" ]; then
-          define_tristate CONFIG_IP_NF_NAT_MMS $CONFIG_IP_NF_NAT
+  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  MMS protocol support' CONFIG_IP_NF_MMS $CONFIG_IP_NF_CON=
NTRACK
diff -Nru patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/=
Config.in.ladd_2 patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilte=
r/Config.in.ladd_2
--- patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/Config=
=2Ein.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilter/Config.in.l=
add_2	2004-02-19 19:26:09.477919914 +0100
@@ -0,0 +1,8 @@
+          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
+        fi
+      fi
+      if [ "$CONFIG_IP_NF_MMS" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_MMS m
+      else
+        if [ "$CONFIG_IP_NF_MMS" =3D "y" ]; then
+          define_tristate CONFIG_IP_NF_NAT_MMS $CONFIG_IP_NF_NAT
diff -Nru patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/=
Makefile.ladd patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilter/M=
akefile.ladd
--- patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/Makefi=
le.ladd	2003-12-18 19:47:59.000000000 +0100
+++ patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilter/Makefile.la=
dd	2004-02-19 19:26:09.183132617 +0100
@@ -1,2 +1,5 @@
-obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
-obj-$(CONFIG_IP_NF_NAT_MMS) +=3D ip_nat_mms.o
+# connection tracking helpers
+obj-$(CONFIG_IP_NF_MMS) +=3D ip_conntrack_mms.o
+ifdef CONFIG_IP_NF_MMS
+	export-objs +=3D ip_conntrack_mms.o
+endif
diff -Nru patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/=
Makefile.ladd_2 patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilter=
/Makefile.ladd_2
--- patch-o-matic-ng-orig/mms-conntrack-nat/linux/net/ipv4/netfilter/Makefi=
le.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/mms-conntrack-nat/linux/net/ipv4/netfilter/Makefile.la=
dd_2	2004-02-19 19:26:09.461931450 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_MMS) +=3D ip_nat_mms.o
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd patch-o-matic-ng/nfnetlink-ctnetlink-0=
=2E13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd	2003-12-18 19:47:59.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd	2004-02-19 19:26:10.390261650 +0100
@@ -1,64 +1,5 @@
-extern unsigned int ip_conntrack_htable_size;
-
-enum ip_conntrack_events
-{
-	IPCT_NEW,
-	IPCT_DESTROY,
-	IPCT_STATUS,
-	IPCT_REFRESH,
-	IPCT_PROTOINFO,
-	IPCT_HELPINFO,
-	IPCT_NATINFO,
-};
-
-#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
-#include <linux/notifier.h>
-
-extern struct notifier_block *ip_conntrack_chain;
-extern unsigned long ip_conntrack_event_cache[NR_CPUS];
-
-/* register notifier for conntrack events */
-static inline int ip_conntrack_notify_register(struct notifier_block *nb)
-{
-	return notifier_chain_register(&ip_conntrack_chain, nb);
-}
-
-static inline int ip_conntrack_notify_unregister(struct notifier_block *nb)
-{
-	return notifier_chain_unregister(&ip_conntrack_chain, nb);
-}
-
-static inline void ip_conntrack_event(enum ip_conntrack_events event,
-				      struct ip_conntrack *ct)
-{
-	if (is_confirmed(ct) && !is_destroyed(ct))
-		notifier_call_chain(&ip_conntrack_chain, 1 << event, ct);
-}
-
-static inline void ip_conntrack_event_cache_init(void)
-{
-	ip_conntrack_event_cache[smp_processor_id()] =3D 0UL;
-}
-
-static inline void ip_conntrack_cache_event(enum ip_conntrack_events event)
-{
-	ip_conntrack_event_cache[smp_processor_id()] |=3D 1 << event;
-}
-
-static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct)
-{
-	unsigned long events =3D ip_conntrack_event_cache[smp_processor_id()];
-
-	if (is_confirmed(ct) && !is_destroyed(ct) && events)
-		notifier_call_chain(&ip_conntrack_chain, events, ct);
-}
-#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
-static inline int ip_conntrack_notify_register(void *nb) { return 0; }
-static inline int ip_conntrack_notify_unregister(void *nb) { return 0; }
-static inline void ip_conntrack_event(enum ip_conntrack_events event,
-				      struct ip_conntrack *ct) {}
-static inline void ip_conntrack_event_cache_init(void) {}
-static inline void ip_conntrack_cache_event(enum ip_conntrack_events event=
) {}
-static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct) =
{}
-#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+	IPS_CONFIRMED =3D (1 << IPS_CONFIRMED_BIT),
=20
+	/* Connection is destroyed (removed from lists), can not be unset. */
+	IPS_DESTROYED_BIT =3D 4,
+	IPS_DESTROYED =3D (1 << IPS_DESTROYED_BIT),
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd_2 patch-o-matic-ng/nfnetlink-ctnetlink=
-0.13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd_2	2004-02-19 19:26:10.398255882 +0100
@@ -0,0 +1,5 @@
+	atomic_t use;
+=20
+	/* unique increasing id */
+	unsigned int id;
+
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd_3 patch-o-matic-ng/nfnetlink-ctnetlink=
-0.13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_3	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd_3	2004-02-19 19:26:10.406250115 +0100
@@ -0,0 +1,9 @@
+	struct ip_conntrack_tuple_hash tuplehash[IP_CT_DIR_MAX];
+=20
+	/* ordered list member - for table dumping over netlink */
+	struct list_head olist;
+
+	/* unique id (assigned when placing in hashtables) - for table dumping
+	 * over netlink */
+	unsigned int id;
+
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd_4 patch-o-matic-ng/nfnetlink-ctnetlink=
-0.13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_4
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_4	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd_4	2004-02-19 19:26:10.414244347 +0100
@@ -0,0 +1,6 @@
+void ip_conntrack_expect_put(struct ip_conntrack_expect *exp);
+=20
+/* remove all unconfirmed expectations */
+extern void ip_conntrack_remove_expectations(struct ip_conntrack *ct,=20
+					     int drop_refcount);
+
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd_5 patch-o-matic-ng/nfnetlink-ctnetlink=
-0.13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_5
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_5	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd_5	2004-02-19 19:26:10.422238580 +0100
@@ -0,0 +1,7 @@
+extern struct module *ip_conntrack_module;
+=20
+struct ip_conntrack_protocol;
+extern int invert_tuple(struct ip_conntrack_tuple *inverse,
+			const struct ip_conntrack_tuple *orig,
+			const struct ip_conntrack_protocol *protocol);
+
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd_6 patch-o-matic-ng/nfnetlink-ctnetlink=
-0.13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_6
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_6	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd_6	2004-02-19 19:26:11.356564532 +0100
@@ -0,0 +1,13 @@
+			void *data);
+=20
+/* returns new ip_conntrack struct or NULL */
+extern struct ip_conntrack *
+ip_conntrack_alloc(const struct ip_conntrack_tuple *,
+		   const struct ip_conntrack_tuple *);
+
+/* free conntrack structure */
+extern void ip_conntrack_free(struct ip_conntrack *);
+
+/* place conntrack in hash and ordered list */
+extern void ip_conntrack_place_in_lists(struct ip_conntrack *);
+
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd_7 patch-o-matic-ng/nfnetlink-ctnetlink=
-0.13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_7
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_7	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd_7	2004-02-19 19:26:11.654349718 +0100
@@ -0,0 +1,8 @@
+}
+=20
+/* It is destroyed after it has been removed from hash table. */
+static inline int is_destroyed(struct ip_conntrack *ct)
+{
+	return test_bit(IPS_DESTROYED_BIT, &ct->status);
+}
+
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linu=
x/netfilter_ipv4/ip_conntrack.h.ladd_8 patch-o-matic-ng/nfnetlink-ctnetlink=
-0.13/linux/include/linux/netfilter_ipv4/ip_conntrack.h.ladd_8
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_8	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/include/linux/netfilter=
_ipv4/ip_conntrack.h.ladd_8	2004-02-19 19:26:12.259912904 +0100
@@ -0,0 +1,64 @@
+extern unsigned int ip_conntrack_htable_size;
+
+enum ip_conntrack_events
+{
+	IPCT_NEW,
+	IPCT_DESTROY,
+	IPCT_STATUS,
+	IPCT_REFRESH,
+	IPCT_PROTOINFO,
+	IPCT_HELPINFO,
+	IPCT_NATINFO,
+};
+
+#ifdef CONFIG_IP_NF_CONNTRACK_EVENTS
+#include <linux/notifier.h>
+
+extern struct notifier_block *ip_conntrack_chain;
+extern unsigned long ip_conntrack_event_cache[NR_CPUS];
+
+/* register notifier for conntrack events */
+static inline int ip_conntrack_notify_register(struct notifier_block *nb)
+{
+	return notifier_chain_register(&ip_conntrack_chain, nb);
+}
+
+static inline int ip_conntrack_notify_unregister(struct notifier_block *nb)
+{
+	return notifier_chain_unregister(&ip_conntrack_chain, nb);
+}
+
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+				      struct ip_conntrack *ct)
+{
+	if (is_confirmed(ct) && !is_destroyed(ct))
+		notifier_call_chain(&ip_conntrack_chain, 1 << event, ct);
+}
+
+static inline void ip_conntrack_event_cache_init(void)
+{
+	ip_conntrack_event_cache[smp_processor_id()] =3D 0UL;
+}
+
+static inline void ip_conntrack_cache_event(enum ip_conntrack_events event)
+{
+	ip_conntrack_event_cache[smp_processor_id()] |=3D 1 << event;
+}
+
+static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct)
+{
+	unsigned long events =3D ip_conntrack_event_cache[smp_processor_id()];
+
+	if (is_confirmed(ct) && !is_destroyed(ct) && events)
+		notifier_call_chain(&ip_conntrack_chain, events, ct);
+}
+#else /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+static inline int ip_conntrack_notify_register(void *nb) { return 0; }
+static inline int ip_conntrack_notify_unregister(void *nb) { return 0; }
+static inline void ip_conntrack_event(enum ip_conntrack_events event,
+				      struct ip_conntrack *ct) {}
+static inline void ip_conntrack_event_cache_init(void) {}
+static inline void ip_conntrack_cache_event(enum ip_conntrack_events event=
) {}
+static inline void ip_conntrack_do_cached_events(struct ip_conntrack *ct) =
{}
+#endif /* CONFIG_IP_NF_CONNTRACK_EVENTS */
+
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/net/ipv4/net=
filter/Config.in.ladd patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/net/i=
pv4/netfilter/Config.in.ladd
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/net/ipv4/netfilter=
/Config.in.ladd	2003-12-18 19:48:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/net/ipv4/netfilter/Conf=
ig.in.ladd	2004-02-19 19:26:10.374273185 +0100
@@ -1,7 +1,3 @@
-if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
-  bool 'Connection tracking event notifications' CONFIG_IP_NF_CONNTRACK_EV=
ENTS
-  if [ "$CONFIG_IP_NF_CONNTRACK" =3D "y" ]; then
-    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_NE=
TLINK_CONNTRACK $CONFIG_IP_NF_NETLINK
-  else
-    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_NE=
TLINK_CONNTRACK $CONFIG_IP_NF_CONNTRACK
-  fi
+comment '  IP: Netfilter Configuration'
+
+tristate 'Netfilter netlink interface' CONFIG_IP_NF_NETLINK
diff -Nru patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/net/ipv4/net=
filter/Config.in.ladd_2 patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/net=
/ipv4/netfilter/Config.in.ladd_2
--- patch-o-matic-ng-orig/nfnetlink-ctnetlink-0.13/linux/net/ipv4/netfilter=
/Config.in.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/nfnetlink-ctnetlink-0.13/linux/net/ipv4/netfilter/Conf=
ig.in.ladd_2	2004-02-19 19:26:10.382267417 +0100
@@ -0,0 +1,7 @@
+if [ "$CONFIG_IP_NF_CONNTRACK" !=3D "n" ]; then
+  bool 'Connection tracking event notifications' CONFIG_IP_NF_CONNTRACK_EV=
ENTS
+  if [ "$CONFIG_IP_NF_CONNTRACK" =3D "y" ]; then
+    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_NE=
TLINK_CONNTRACK $CONFIG_IP_NF_NETLINK
+  else
+    dep_tristate '  Connection tracking netlink interface' CONFIG_IP_NF_NE=
TLINK_CONNTRACK $CONFIG_IP_NF_CONNTRACK
+  fi
diff -Nru patch-o-matic-ng-orig/pptp-conntrack-nat/linux/net/ipv4/netfilter=
/Config.in.ladd patch-o-matic-ng/pptp-conntrack-nat/linux/net/ipv4/netfilte=
r/Config.in.ladd
--- patch-o-matic-ng-orig/pptp-conntrack-nat/linux/net/ipv4/netfilter/Confi=
g.in.ladd	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.=
ladd	2004-02-19 19:26:12.954411972 +0100
@@ -0,0 +1,3 @@
+  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  GRE protocol support' CONFIG_IP_NF_CT_PROTO_GRE $CONFIG_=
IP_NF_CONNTRACK
+  dep_tristate '   PPTP protocol support' CONFIG_IP_NF_PPTP $CONFIG_IP_NF_=
CT_PROTO_GRE
diff -Nru patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilt=
er/Config.in.ladd patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/netf=
ilter/Config.in.ladd
--- patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilter/Con=
fig.in.ladd	2003-12-18 19:49:15.000000000 +0100
+++ patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/netfilter/Config.i=
n.ladd	2004-02-19 19:26:16.418913751 +0100
@@ -1,8 +1,2 @@
-          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
-        fi
-      fi
-      if [ "$CONFIG_IP_NF_QUAKE3" =3D "m" ]; then
-        define_tristate CONFIG_IP_NF_NAT_QUAKE3 m
-      else
-        if [ "$CONFIG_IP_NF_QUAKE3" =3D "y" ]; then
-         define_tristate CONFIG_IP_NF_NAT_QUAKE3 $CONFIG_IP_NF_NAT
+  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  Quake III protocol support' CONFIG_IP_NF_QUAKE3 $CONFIG_=
IP_NF_CONNTRACK
diff -Nru patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilt=
er/Config.in.ladd_2 patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/ne=
tfilter/Config.in.ladd_2
--- patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilter/Con=
fig.in.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/netfilter/Config.i=
n.ladd_2	2004-02-19 19:26:16.425908708 +0100
@@ -0,0 +1,8 @@
+          define_tristate CONFIG_IP_NF_NAT_IRC $CONFIG_IP_NF_NAT
+        fi
+      fi
+      if [ "$CONFIG_IP_NF_QUAKE3" =3D "m" ]; then
+        define_tristate CONFIG_IP_NF_NAT_QUAKE3 m
+      else
+        if [ "$CONFIG_IP_NF_QUAKE3" =3D "y" ]; then
+         define_tristate CONFIG_IP_NF_NAT_QUAKE3 $CONFIG_IP_NF_NAT
diff -Nru patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilt=
er/Makefile.ladd patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/netfi=
lter/Makefile.ladd
--- patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilter/Mak=
efile.ladd	2003-12-18 19:49:15.000000000 +0100
+++ patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/netfilter/Makefile=
=2Eladd	2004-02-19 19:26:16.111135640 +0100
@@ -1,2 +1,5 @@
-obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
-obj-$(CONFIG_IP_NF_NAT_QUAKE3) +=3D ip_nat_quake3.o
+# connection tracking helpers
+obj-$(CONFIG_IP_NF_QUAKE3) +=3D ip_conntrack_quake3.o
+ifdef CONFIG_IP_NF_NAT_QUAKE3
+	export-objs +=3D ip_conntrack_quake3.o
+endif
diff -Nru patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilt=
er/Makefile.ladd_2 patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/net=
filter/Makefile.ladd_2
--- patch-o-matic-ng-orig/quake3-conntrack-nat/linux/net/ipv4/netfilter/Mak=
efile.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/quake3-conntrack-nat/linux/net/ipv4/netfilter/Makefile=
=2Eladd_2	2004-02-19 19:26:16.410919515 +0100
@@ -0,0 +1,2 @@
+obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
+obj-$(CONFIG_IP_NF_NAT_QUAKE3) +=3D ip_nat_quake3.o
diff -Nru patch-o-matic-ng-orig/rsh/linux/include/linux/netfilter_ipv4/ip_c=
onntrack.h.ladd patch-o-matic-ng/rsh/linux/include/linux/netfilter_ipv4/ip_=
conntrack.h.ladd
--- patch-o-matic-ng-orig/rsh/linux/include/linux/netfilter_ipv4/ip_conntra=
ck.h.ladd	2003-12-18 19:48:01.000000000 +0100
+++ patch-o-matic-ng/rsh/linux/include/linux/netfilter_ipv4/ip_conntrack.h.=
ladd	2004-02-19 19:26:17.776934773 +0100
@@ -1,2 +1,2 @@
-	/* insert conntrack helper private data (master) here */
-	struct ip_ct_rsh_master ct_rsh_info;
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_rsh.h>
diff -Nru patch-o-matic-ng-orig/rsh/linux/include/linux/netfilter_ipv4/ip_c=
onntrack.h.ladd_2 patch-o-matic-ng/rsh/linux/include/linux/netfilter_ipv4/i=
p_conntrack.h.ladd_2
--- patch-o-matic-ng-orig/rsh/linux/include/linux/netfilter_ipv4/ip_conntra=
ck.h.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/rsh/linux/include/linux/netfilter_ipv4/ip_conntrack.h.=
ladd_2	2004-02-19 19:26:17.783929731 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_rsh_expect exp_rsh_info;
diff -Nru patch-o-matic-ng-orig/rsh/linux/include/linux/netfilter_ipv4/ip_c=
onntrack.h.ladd_3 patch-o-matic-ng/rsh/linux/include/linux/netfilter_ipv4/i=
p_conntrack.h.ladd_3
--- patch-o-matic-ng-orig/rsh/linux/include/linux/netfilter_ipv4/ip_conntra=
ck.h.ladd_3	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/rsh/linux/include/linux/netfilter_ipv4/ip_conntrack.h.=
ladd_3	2004-02-19 19:26:17.791923968 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (master) here */
+	struct ip_ct_rsh_master ct_rsh_info;
diff -Nru patch-o-matic-ng-orig/rtsp-conntrack/linux/include/linux/netfilte=
r_ipv4/ip_conntrack.h.ladd patch-o-matic-ng/rtsp-conntrack/linux/include/li=
nux/netfilter_ipv4/ip_conntrack.h.ladd
--- patch-o-matic-ng-orig/rtsp-conntrack/linux/include/linux/netfilter_ipv4=
/ip_conntrack.h.ladd	2003-12-18 19:48:01.000000000 +0100
+++ patch-o-matic-ng/rtsp-conntrack/linux/include/linux/netfilter_ipv4/ip_c=
onntrack.h.ladd	2004-02-19 19:26:18.513403935 +0100
@@ -1,2 +1,2 @@
-	/* insert conntrack helper private data (expect) here */
-	struct ip_ct_rtsp_master ct_rtsp_info;
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_rtsp.h>
diff -Nru patch-o-matic-ng-orig/rtsp-conntrack/linux/include/linux/netfilte=
r_ipv4/ip_conntrack.h.ladd_2 patch-o-matic-ng/rtsp-conntrack/linux/include/=
linux/netfilter_ipv4/ip_conntrack.h.ladd_2
--- patch-o-matic-ng-orig/rtsp-conntrack/linux/include/linux/netfilter_ipv4=
/ip_conntrack.h.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/rtsp-conntrack/linux/include/linux/netfilter_ipv4/ip_c=
onntrack.h.ladd_2	2004-02-19 19:26:18.521398173 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_rtsp_expect exp_rtsp_info;
diff -Nru patch-o-matic-ng-orig/rtsp-conntrack/linux/include/linux/netfilte=
r_ipv4/ip_conntrack.h.ladd_3 patch-o-matic-ng/rtsp-conntrack/linux/include/=
linux/netfilter_ipv4/ip_conntrack.h.ladd_3
--- patch-o-matic-ng-orig/rtsp-conntrack/linux/include/linux/netfilter_ipv4=
/ip_conntrack.h.ladd_3	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/rtsp-conntrack/linux/include/linux/netfilter_ipv4/ip_c=
onntrack.h.ladd_3	2004-02-19 19:26:19.218895462 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_rtsp_master ct_rtsp_info;
diff -Nru patch-o-matic-ng-orig/rtsp-conntrack/linux/net/ipv4/netfilter/Con=
fig.in.ladd patch-o-matic-ng/rtsp-conntrack/linux/net/ipv4/netfilter/Config=
=2Ein.ladd
--- patch-o-matic-ng-orig/rtsp-conntrack/linux/net/ipv4/netfilter/Config.in=
=2Eladd	2003-12-18 19:48:02.000000000 +0100
+++ patch-o-matic-ng/rtsp-conntrack/linux/net/ipv4/netfilter/Config.in.ladd=
	2004-02-19 19:26:18.497415459 +0100
@@ -1,8 +1,2 @@
-        dep_tristate '    Basic SNMP-ALG support (EXPERIMENTAL)' CONFIG_IP=
_NF_NAT_SNMP_BASIC $CONFIG_IP_NF_NAT
-        if [ "$CONFIG_IP_NF_RTSP" =3D "m" ]; then
-          define_tristate CONFIG_IP_NF_NAT_RTSP m
-        else
-          if [ "$CONFIG_IP_NF_RTSP" =3D "y" ]; then
-            define_tristate CONFIG_IP_NF_NAT_RTSP $CONFIG_IP_NF_NAT
-          fi
-        fi
+  dep_tristate '  IRC protocol support' CONFIG_IP_NF_IRC $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  RTSP protocol support' CONFIG_IP_NF_RTSP $CONFIG_IP_NF_C=
ONNTRACK
diff -Nru patch-o-matic-ng-orig/rtsp-conntrack/linux/net/ipv4/netfilter/Con=
fig.in.ladd_2 patch-o-matic-ng/rtsp-conntrack/linux/net/ipv4/netfilter/Conf=
ig.in.ladd_2
--- patch-o-matic-ng-orig/rtsp-conntrack/linux/net/ipv4/netfilter/Config.in=
=2Eladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/rtsp-conntrack/linux/net/ipv4/netfilter/Config.in.ladd=
_2	2004-02-19 19:26:18.505409697 +0100
@@ -0,0 +1,8 @@
+        dep_tristate '    Basic SNMP-ALG support (EXPERIMENTAL)' CONFIG_IP=
_NF_NAT_SNMP_BASIC $CONFIG_IP_NF_NAT
+        if [ "$CONFIG_IP_NF_RTSP" =3D "m" ]; then
+          define_tristate CONFIG_IP_NF_NAT_RTSP m
+        else
+          if [ "$CONFIG_IP_NF_RTSP" =3D "y" ]; then
+            define_tristate CONFIG_IP_NF_NAT_RTSP $CONFIG_IP_NF_NAT
+          fi
+        fi
diff -Nru patch-o-matic-ng-orig/talk-conntrack-nat/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd patch-o-matic-ng/talk-conntrack-nat/linux/in=
clude/linux/netfilter_ipv4/ip_conntrack.h.ladd
--- patch-o-matic-ng-orig/talk-conntrack-nat/linux/include/linux/netfilter_=
ipv4/ip_conntrack.h.ladd	2003-12-18 19:48:02.000000000 +0100
+++ patch-o-matic-ng/talk-conntrack-nat/linux/include/linux/netfilter_ipv4/=
ip_conntrack.h.ladd	2004-02-19 19:26:20.874702239 +0100
@@ -1,2 +1,2 @@
-	/* insert conntrack helper private data (master) here */
-	struct ip_ct_talk_master ct_talk_info;
+/* Add protocol helper include file here */
+#include <linux/netfilter_ipv4/ip_conntrack_talk.h>
diff -Nru patch-o-matic-ng-orig/talk-conntrack-nat/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_2 patch-o-matic-ng/talk-conntrack-nat/linux/=
include/linux/netfilter_ipv4/ip_conntrack.h.ladd_2
--- patch-o-matic-ng-orig/talk-conntrack-nat/linux/include/linux/netfilter_=
ipv4/ip_conntrack.h.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/talk-conntrack-nat/linux/include/linux/netfilter_ipv4/=
ip_conntrack.h.ladd_2	2004-02-19 19:26:20.881697199 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (expect) here */
+	struct ip_ct_talk_expect exp_talk_info;
diff -Nru patch-o-matic-ng-orig/talk-conntrack-nat/linux/include/linux/netf=
ilter_ipv4/ip_conntrack.h.ladd_3 patch-o-matic-ng/talk-conntrack-nat/linux/=
include/linux/netfilter_ipv4/ip_conntrack.h.ladd_3
--- patch-o-matic-ng-orig/talk-conntrack-nat/linux/include/linux/netfilter_=
ipv4/ip_conntrack.h.ladd_3	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/talk-conntrack-nat/linux/include/linux/netfilter_ipv4/=
ip_conntrack.h.ladd_3	2004-02-19 19:26:20.889691438 +0100
@@ -0,0 +1,2 @@
+	/* insert conntrack helper private data (master) here */
+	struct ip_ct_talk_master ct_talk_info;
diff -Nru patch-o-matic-ng-orig/talk-conntrack-nat/linux/net/ipv4/netfilter=
/Config.in.ladd patch-o-matic-ng/talk-conntrack-nat/linux/net/ipv4/netfilte=
r/Config.in.ladd
--- patch-o-matic-ng-orig/talk-conntrack-nat/linux/net/ipv4/netfilter/Confi=
g.in.ladd	2003-12-18 19:48:02.000000000 +0100
+++ patch-o-matic-ng/talk-conntrack-nat/linux/net/ipv4/netfilter/Config.in.=
ladd	2004-02-19 19:26:20.858713760 +0100
@@ -1,10 +1,2 @@
-      dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIR=
ECT $CONFIG_IP_NF_NAT
-      # If they want talk, set to $CONFIG_IP_NF_NAT (m or y),=20
-      # or $CONFIG_IP_NF_TALK (m or y), whichever is weaker.  Argh.
-      if [ "$CONFIG_IP_NF_TALK" =3D "m" ]; then
-	define_tristate CONFIG_IP_NF_NAT_TALK m
-      else
-        if [ "$CONFIG_IP_NF_TALK" =3D "y" ]; then
-          define_tristate CONFIG_IP_NF_NAT_TALK $CONFIG_IP_NF_NAT
-        fi
-      fi
+  dep_tristate '  FTP protocol support' CONFIG_IP_NF_FTP $CONFIG_IP_NF_CON=
NTRACK
+  dep_tristate '  talk protocol support' CONFIG_IP_NF_TALK $CONFIG_IP_NF_C=
ONNTRACK
diff -Nru patch-o-matic-ng-orig/talk-conntrack-nat/linux/net/ipv4/netfilter=
/Config.in.ladd_2 patch-o-matic-ng/talk-conntrack-nat/linux/net/ipv4/netfil=
ter/Config.in.ladd_2
--- patch-o-matic-ng-orig/talk-conntrack-nat/linux/net/ipv4/netfilter/Confi=
g.in.ladd_2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng/talk-conntrack-nat/linux/net/ipv4/netfilter/Config.in.=
ladd_2	2004-02-19 19:26:20.865708720 +0100
@@ -0,0 +1,10 @@
+      dep_tristate '    REDIRECT target support' CONFIG_IP_NF_TARGET_REDIR=
ECT $CONFIG_IP_NF_NAT
+      # If they want talk, set to $CONFIG_IP_NF_NAT (m or y),=20
+      # or $CONFIG_IP_NF_TALK (m or y), whichever is weaker.  Argh.
+      if [ "$CONFIG_IP_NF_TALK" =3D "m" ]; then
+	define_tristate CONFIG_IP_NF_NAT_TALK m
+      else
+        if [ "$CONFIG_IP_NF_TALK" =3D "y" ]; then
+          define_tristate CONFIG_IP_NF_NAT_TALK $CONFIG_IP_NF_NAT
+        fi
+      fi

--=20
Linux zion 2.6.3-rc2 #2 Fri Feb 13 00:07:44 CET 2004 i686 athlon i386 GNU/L=
inux
 19:59:43  up 2 days, 19:32,  3 users,  load average: 0.00, 0.01, 0.50

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFANQlGo4FAdB2PneQRAhBnAJ9OKCGzsOb+ytSFa/i9LevRr3LoSgCeKQjD
XDlH+onEfjHZJinKQzoSQDM=
=y6Pa
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
