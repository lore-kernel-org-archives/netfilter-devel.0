From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [PATCHES] Fix config-problem + missing export
Date: 14 Apr 2003 02:46:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1050281210.11156.211.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-moqZ/iCbFDiIv0lTbDyY"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-moqZ/iCbFDiIv0lTbDyY
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi Harald,

He's some fixes for a compilationproblem in 2.4 when conntrack-helpers
were selected as modules but no NAT support was configured.

The first patch, against 2.4-bk, adds a missing export for the amanda
conntrack-helper (not really needed for 2.4 but should be there) and
makes the exporting of symbols unconditional in the conntrack helpers
(ftp and irc).

The second patch is against p-o-m correcting the affected patches there.
(adds submitted/22_amanda-conntrack-nat.patch.makefile-2)

And the third patch is against 2.5.67-bk5, it adds the missing export
for the amanda conntrack-helper and makes the exports unconditional
there as well (they didn't cause any problems on 2.5 but it doesn't hurt
making it the same as in 2.4)

-- 
/Martin

--=-moqZ/iCbFDiIv0lTbDyY
Content-Disposition: attachment; filename=netfilter-ipv4-config-fix
Content-Type: text/x-patch; name=netfilter-ipv4-config-fix; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/Makefile linux-2.4.2=
1-pre7-bk/net/ipv4/netfilter/Makefile
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/Makefile	2003-04-14 02:42:=
11.000000000 +0200
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/Makefile	2003-04-14 02:42:44.00=
0000000 +0200
@@ -31,27 +31,25 @@
 # connection tracking
 obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
=20
-# Amanda protocol support
+# connection tracking helpers
 obj-$(CONFIG_IP_NF_AMANDA) +=3D ip_conntrack_amanda.o
-obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o
-ifdef CONFIG_IP_NF_NAT_AMANDA
+ifdef CONFIG_IP_NF_AMANDA
 	export-objs +=3D ip_conntrack_amanda.o
 endif
=20
-
-# connection tracking helpers
 obj-$(CONFIG_IP_NF_TFTP) +=3D ip_conntrack_tftp.o
 obj-$(CONFIG_IP_NF_FTP) +=3D ip_conntrack_ftp.o
-ifdef CONFIG_IP_NF_NAT_FTP
+ifdef CONFIG_IP_NF_FTP
 	export-objs +=3D ip_conntrack_ftp.o
 endif
=20
 obj-$(CONFIG_IP_NF_IRC) +=3D ip_conntrack_irc.o
-ifdef CONFIG_IP_NF_NAT_IRC
+ifdef CONFIG_IP_NF_IRC
 	export-objs +=3D ip_conntrack_irc.o
 endif
=20
 # NAT helpers=20
+obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o
 obj-$(CONFIG_IP_NF_NAT_TFTP) +=3D ip_nat_tftp.o
 obj-$(CONFIG_IP_NF_NAT_FTP) +=3D ip_nat_ftp.o
 obj-$(CONFIG_IP_NF_NAT_IRC) +=3D ip_nat_irc.o
diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_amanda.=
c linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2003=
-04-14 02:42:11.000000000 +0200
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-04-1=
4 02:42:44.000000000 +0200
@@ -229,5 +229,7 @@
 	return 0;
 }
=20
+EXPORT_SYMBOL(ip_amanda_lock);
+
 module_init(init);
 module_exit(fini);
diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_ftp.c l=
inux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04=
-14 02:42:02.000000000 +0200
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04-14 0=
2:42:44.000000000 +0200
@@ -436,9 +436,7 @@
 	return 0;
 }
=20
-#ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_ftp_lock);
-#endif
=20
 MODULE_LICENSE("GPL");
 module_init(init);
diff -urN linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_irc.c l=
inux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.4.21-pre7-bk.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2002-11=
-29 00:53:15.000000000 +0100
+++ linux-2.4.21-pre7-bk/net/ipv4/netfilter/ip_conntrack_irc.c	2003-04-14 0=
2:42:44.000000000 +0200
@@ -305,9 +305,7 @@
 	}
 }
=20
-#ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_irc_lock);
-#endif
=20
 module_init(init);
 module_exit(fini);

--=-moqZ/iCbFDiIv0lTbDyY
Content-Disposition: attachment; filename=p-o-m-config-fix
Content-Type: text/x-patch; name=p-o-m-config-fix; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

diff -urN ../../cvs/dev/netfilter/patch-o-matic/extra/h323-conntrack-nat.pa=
tch patch-o-matic/extra/h323-conntrack-nat.patch
--- ../../cvs/dev/netfilter/patch-o-matic/extra/h323-conntrack-nat.patch	20=
02-08-26 19:37:19.000000000 +0200
+++ patch-o-matic/extra/h323-conntrack-nat.patch	2003-04-14 01:36:28.000000=
000 +0200
@@ -35,7 +35,7 @@
 diff -uN /dev/null linux/net/ipv4/netfilter/ip_conntrack_h323.c
 --- /dev/null	Thu Apr 11 16:25:15 2002
 +++ linux/net/ipv4/netfilter/ip_conntrack_h323.c	Wed Aug 21 11:45:51 2002
-@@ -0,0 +1,310 @@
+@@ -0,0 +1,308 @@
 +/*=20
 + * H.323 'brute force' extension for H.323 connection tracking.=20
 + * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
@@ -340,9 +340,7 @@
 +	ip_conntrack_helper_unregister(&h225);
 +}
 +
-+#ifdef CONFIG_IP_NF_NAT_NEEDED
 +EXPORT_SYMBOL(ip_h323_lock);
-+#endif
 +
 +module_init(init);
 +module_exit(fini);
diff -urN ../../cvs/dev/netfilter/patch-o-matic/extra/h323-conntrack-nat.pa=
tch.makefile patch-o-matic/extra/h323-conntrack-nat.patch.makefile
--- ../../cvs/dev/netfilter/patch-o-matic/extra/h323-conntrack-nat.patch.ma=
kefile	2002-01-23 15:02:25.000000000 +0100
+++ patch-o-matic/extra/h323-conntrack-nat.patch.makefile	2003-04-14 01:37:=
23.000000000 +0200
@@ -2,8 +2,8 @@
 =20
 # H.323 support
 obj-$(CONFIG_IP_NF_H323) +=3D ip_conntrack_h323.o
-obj-$(CONFIG_IP_NF_NAT_H323) +=3D ip_nat_h323.o
-ifdef CONFIG_IP_NF_NAT_H323
+ifdef CONFIG_IP_NF_H323
 	export-objs +=3D ip_conntrack_h323.o
 endif
+obj-$(CONFIG_IP_NF_NAT_H323) +=3D ip_nat_h323.o
=20
diff -urN ../../cvs/dev/netfilter/patch-o-matic/extra/mms-conntrack-nat.pat=
ch patch-o-matic/extra/mms-conntrack-nat.patch
--- ../../cvs/dev/netfilter/patch-o-matic/extra/mms-conntrack-nat.patch	200=
2-10-10 16:43:26.000000000 +0200
+++ patch-o-matic/extra/mms-conntrack-nat.patch	2003-04-14 01:38:13.0000000=
00 +0200
@@ -36,7 +36,7 @@
 diff -urN -X dontdiff linux-2.4.20-pre7/net/ipv4/netfilter/ip_conntrack_mm=
s.c linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_conntrack_mms.c
 --- linux-2.4.20-pre7/net/ipv4/netfilter/ip_conntrack_mms.c	1970-01-01 01:=
00:00.000000000 +0100
 +++ linux-2.4.20-pre7-mms/net/ipv4/netfilter/ip_conntrack_mms.c	2002-09-17=
 01:29:20.000000000 +0200
-@@ -0,0 +1,310 @@
+@@ -0,0 +1,308 @@
 +/* MMS extension for IP connection tracking
 + * (C) 2002 by Filip Sneppe <filip.sneppe@cronos.be>
 + * based on ip_conntrack_ftp.c and ip_conntrack_irc.c
@@ -90,9 +90,7 @@
 +#define DEBUGP(format, args...)
 +#endif
 +
-+#ifdef CONFIG_IP_NF_NAT_NEEDED
 +EXPORT_SYMBOL(ip_mms_lock);
-+#endif
 +
 +MODULE_AUTHOR("Filip Sneppe <filip.sneppe@cronos.be>");
 +MODULE_DESCRIPTION("Microsoft Windows Media Services (MMS) connection tra=
cking module");
diff -urN ../../cvs/dev/netfilter/patch-o-matic/extra/mms-conntrack-nat.pat=
ch.makefile patch-o-matic/extra/mms-conntrack-nat.patch.makefile
--- ../../cvs/dev/netfilter/patch-o-matic/extra/mms-conntrack-nat.patch.mak=
efile	2002-09-24 13:49:09.000000000 +0200
+++ patch-o-matic/extra/mms-conntrack-nat.patch.makefile	2003-04-14 01:38:4=
1.000000000 +0200
@@ -1,5 +1,5 @@
 # connection tracking helpers
 obj-$(CONFIG_IP_NF_MMS) +=3D ip_conntrack_mms.o
-ifdef CONFIG_IP_NF_NAT_MMS
+ifdef CONFIG_IP_NF_MMS
 	export-objs +=3D ip_conntrack_mms.o
 endif
diff -urN ../../cvs/dev/netfilter/patch-o-matic/extra/talk-conntrack-nat.pa=
tch patch-o-matic/extra/talk-conntrack-nat.patch
--- ../../cvs/dev/netfilter/patch-o-matic/extra/talk-conntrack-nat.patch	20=
02-08-26 19:41:54.000000000 +0200
+++ patch-o-matic/extra/talk-conntrack-nat.patch	2003-04-14 01:36:55.000000=
000 +0200
@@ -155,7 +155,7 @@
 +#endif /* _IP_CONNTRACK_TALK_H */
 --- linux-2.4.18-newnat13/net/ipv4/netfilter/ip_conntrack_talk.c	Thu Jan  =
1 01:00:00 1970
 +++ linux-2.4.18-newnat13-talk/net/ipv4/netfilter/ip_conntrack_talk.c	Wed =
Mar 20 01:37:38 2002
-@@ -0,0 +1,362 @@
+@@ -0,0 +1,360 @@
 +/*=20
 + * talk extension for IP connection tracking.=20
 + * Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
@@ -512,9 +512,7 @@
 +		ip_conntrack_helper_unregister(&talk_helpers[1]);
 +}
 +
-+#ifdef CONFIG_IP_NF_NAT_NEEDED
 +EXPORT_SYMBOL(ip_talk_lock);
-+#endif
 +
 +module_init(init);
 +module_exit(fini);
diff -urN ../../cvs/dev/netfilter/patch-o-matic/extra/talk-conntrack-nat.pa=
tch.makefile patch-o-matic/extra/talk-conntrack-nat.patch.makefile
--- ../../cvs/dev/netfilter/patch-o-matic/extra/talk-conntrack-nat.patch.ma=
kefile	2002-01-23 15:03:46.000000000 +0100
+++ patch-o-matic/extra/talk-conntrack-nat.patch.makefile	2003-04-14 01:37:=
43.000000000 +0200
@@ -2,8 +2,8 @@
=20
 # talk protocol support
 obj-$(CONFIG_IP_NF_TALK) +=3D ip_conntrack_talk.o
-obj-$(CONFIG_IP_NF_NAT_TALK) +=3D ip_nat_talk.o
-ifdef CONFIG_IP_NF_NAT_TALK
+ifdef CONFIG_IP_NF_TALK
 	export-objs +=3D ip_conntrack_talk.o
 endif
+obj-$(CONFIG_IP_NF_NAT_TALK) +=3D ip_nat_talk.o
=20
diff -urN ../../cvs/dev/netfilter/patch-o-matic/submitted/22_amanda-conntra=
ck-nat.patch patch-o-matic/submitted/22_amanda-conntrack-nat.patch
--- ../../cvs/dev/netfilter/patch-o-matic/submitted/22_amanda-conntrack-nat=
.patch	2002-11-02 14:47:34.000000000 +0100
+++ patch-o-matic/submitted/22_amanda-conntrack-nat.patch	2003-04-14 02:11:=
40.000000000 +0200
@@ -34,7 +34,7 @@
 diff -uNr linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_aman=
da.c linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c
 --- linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_conntrack_amanda.c	1=
969-12-31 19:00:00.000000000 -0500
 +++ linux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_conntrack_amanda.c=
	2002-08-16 04:24:25.000000000 -0400
-@@ -0,0 +1,233 @@
+@@ -0,0 +1,235 @@
 +/* Amanda extension for IP connection tracking, Version 0.2
 + * (C) 2002 by Brian J. Murrell <netfilter@interlinx.bc.ca>
 + * based on HW's ip_conntrack_irc.c as well as other modules
@@ -266,6 +266,8 @@
 +	return 0;
 +}
 +
++EXPORT_SYMBOL(ip_amanda_lock);
++
 +module_init(init);
 +module_exit(fini);
 diff -uNr linux-2.4.18-6mdk-pom-clean/net/ipv4/netfilter/ip_nat_amanda.c l=
inux-2.4.18-6mdkuml-48um-pom/net/ipv4/netfilter/ip_nat_amanda.c
diff -urN ../../cvs/dev/netfilter/patch-o-matic/submitted/22_amanda-conntra=
ck-nat.patch.makefile patch-o-matic/submitted/22_amanda-conntrack-nat.patch=
.makefile
--- ../../cvs/dev/netfilter/patch-o-matic/submitted/22_amanda-conntrack-nat=
.patch.makefile	2002-09-15 13:37:15.000000000 +0200
+++ patch-o-matic/submitted/22_amanda-conntrack-nat.patch.makefile	2003-04-=
14 02:31:07.000000000 +0200
@@ -1,9 +1,6 @@
-obj-$(CONFIG_IP_NF_CONNTRACK) +=3D ip_conntrack.o
-
-# Amanda protocol support
+# connection tracking helpers
 obj-$(CONFIG_IP_NF_AMANDA) +=3D ip_conntrack_amanda.o
-obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o
-ifdef CONFIG_IP_NF_NAT_AMANDA
+ifdef CONFIG_IP_NF_AMANDA
 	export-objs +=3D ip_conntrack_amanda.o
 endif
=20
diff -urN ../../cvs/dev/netfilter/patch-o-matic/submitted/22_amanda-conntra=
ck-nat.patch.makefile-2 patch-o-matic/submitted/22_amanda-conntrack-nat.pat=
ch.makefile-2
--- ../../cvs/dev/netfilter/patch-o-matic/submitted/22_amanda-conntrack-nat=
.patch.makefile-2	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic/submitted/22_amanda-conntrack-nat.patch.makefile-2	2003-0=
4-14 02:34:25.000000000 +0200
@@ -0,0 +1,2 @@
+# NAT helpers=20
+obj-$(CONFIG_IP_NF_NAT_AMANDA) +=3D ip_nat_amanda.o

--=-moqZ/iCbFDiIv0lTbDyY
Content-Disposition: attachment; filename=netfilter-ipv4-config-fix-2.5
Content-Type: text/x-patch; name=netfilter-ipv4-config-fix-2.5; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

diff -urN linux-2.5.67-bk5.orig/net/ipv4/netfilter/ip_conntrack_amanda.c li=
nux-2.5.67-bk5/net/ipv4/netfilter/ip_conntrack_amanda.c
--- linux-2.5.67-bk5.orig/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-04-=
07 19:31:56.000000000 +0200
+++ linux-2.5.67-bk5/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-04-14 01=
:48:16.000000000 +0200
@@ -229,5 +229,7 @@
 	return 0;
 }
=20
+EXPORT_SYMBOL(ip_amanda_lock);
+
 module_init(init);
 module_exit(fini);
diff -urN linux-2.5.67-bk5.orig/net/ipv4/netfilter/ip_conntrack_ftp.c linux=
-2.5.67-bk5/net/ipv4/netfilter/ip_conntrack_ftp.c
--- linux-2.5.67-bk5.orig/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04-07 =
19:32:20.000000000 +0200
+++ linux-2.5.67-bk5/net/ipv4/netfilter/ip_conntrack_ftp.c	2003-04-14 01:46=
:35.000000000 +0200
@@ -436,9 +436,7 @@
 	return 0;
 }
=20
-#ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_ftp_lock);
-#endif
=20
 MODULE_LICENSE("GPL");
 module_init(init);
diff -urN linux-2.5.67-bk5.orig/net/ipv4/netfilter/ip_conntrack_irc.c linux=
-2.5.67-bk5/net/ipv4/netfilter/ip_conntrack_irc.c
--- linux-2.5.67-bk5.orig/net/ipv4/netfilter/ip_conntrack_irc.c	2003-04-07 =
19:32:18.000000000 +0200
+++ linux-2.5.67-bk5/net/ipv4/netfilter/ip_conntrack_irc.c	2003-04-14 01:46=
:42.000000000 +0200
@@ -305,9 +305,7 @@
 	}
 }
=20
-#ifdef CONFIG_IP_NF_NAT_NEEDED
 EXPORT_SYMBOL(ip_irc_lock);
-#endif
=20
 module_init(init);
 module_exit(fini);

--=-moqZ/iCbFDiIv0lTbDyY--
