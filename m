From: Fabrice MARIE <fabrice@celestix.com>
Subject: [PATCH] pptp conntrack patch rediff
Date: Thu, 4 Jul 2002 18:30:00 +0800
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207041830.00762.fabrice@celestix.com>
Reply-To: fabrice@celestix.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_0UZPJUNHI0OHWRABIAL8"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_0UZPJUNHI0OHWRABIAL8
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8bit


Hello,

Attached patch should fix the pptp conntrack patch to
make it apply properly again. Let me know if I rediffed wrongly..

Have a nice day,

Fabrice.

diff -uNr cvs/netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch
--- cvs/netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch	2002-06-15 21:30:49.000000000 +0800
+++ netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch	2002-07-04 11:56:23.000000000 +0800
@@ -1,22 +1,23 @@
-diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack.h
---- linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack.h	Tue Apr  2 13:01:37 2002
-+++ linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack.h	Mon Apr  8 12:42:36 2002
-@@ -102,9 +105,15 @@
+diff -uNr original/linux/include/linux/netfilter_ipv4/ip_conntrack.h linux/include/linux/netfilter_ipv4/ip_conntrack.h
+--- original/linux/include/linux/netfilter_ipv4/ip_conntrack.h	2002-07-04 11:39:37.000000000 +0800
++++ linux/include/linux/netfilter_ipv4/ip_conntrack.h	2002-07-04 11:47:02.000000000 +0800
+@@ -104,9 +104,15 @@
  
  	/* At which sequence number did this expectation occur */
  	u_int32_t seq;
+-  
++    
++  	union {
++  		/* insert l4proto helper private data (expect) here */
++  		struct ip_ct_gre_expect gre;
++  	} proto;
 +
-+	union {
-+		/* insert l4proto helper private data (expect) herre */
-+		struct ip_ct_gre_expect gre;
-+	} proto;
-   
  	union {
  		/* insert conntrack helper private data (expect) here */
 +		struct ip_ct_pptp_expect exp_pptp_info;
+ 		struct ip_ct_h225_expect exp_h225_info;
  		struct ip_ct_ftp_expect exp_ftp_info;
  		struct ip_ct_irc_expect exp_irc_info;
-   
 diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack_pptp.h linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack_pptp.h
 --- linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack_pptp.h	Thu Jan  1 01:00:00 1970
 +++ linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack_pptp.h	Mon Apr  8 12:42:36 2002

http://fabnetwork.ifrance.com/
--
Fabrice MARIE
Senior R&D Engineer
Celestix Networks
http://www.celestix.com/

"Silly hacker, root is for administrators"
       -Unknown
--------------Boundary-00=_0UZPJUNHI0OHWRABIAL8
Content-Type: text/x-diff;
  charset="us-ascii";
  name="conntrack_pptp_patch_rediff.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="conntrack_pptp_patch_rediff.patch"

diff -uNr cvs/netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch
--- cvs/netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch	2002-06-15 21:30:49.000000000 +0800
+++ netfilter/userspace/patch-o-matic/extra/pptp-conntrack-nat.patch	2002-07-04 11:56:23.000000000 +0800
@@ -1,22 +1,23 @@
-diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack.h linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack.h
---- linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack.h	Tue Apr  2 13:01:37 2002
-+++ linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack.h	Mon Apr  8 12:42:36 2002
-@@ -102,9 +105,15 @@
+diff -uNr original/linux/include/linux/netfilter_ipv4/ip_conntrack.h linux/include/linux/netfilter_ipv4/ip_conntrack.h
+--- original/linux/include/linux/netfilter_ipv4/ip_conntrack.h	2002-07-04 11:39:37.000000000 +0800
++++ linux/include/linux/netfilter_ipv4/ip_conntrack.h	2002-07-04 11:47:02.000000000 +0800
+@@ -104,9 +104,15 @@
  
  	/* At which sequence number did this expectation occur */
  	u_int32_t seq;
+-  
++    
++  	union {
++  		/* insert l4proto helper private data (expect) here */
++  		struct ip_ct_gre_expect gre;
++  	} proto;
 +
-+	union {
-+		/* insert l4proto helper private data (expect) herre */
-+		struct ip_ct_gre_expect gre;
-+	} proto;
-   
  	union {
  		/* insert conntrack helper private data (expect) here */
 +		struct ip_ct_pptp_expect exp_pptp_info;
+ 		struct ip_ct_h225_expect exp_h225_info;
  		struct ip_ct_ftp_expect exp_ftp_info;
  		struct ip_ct_irc_expect exp_irc_info;
-   
 diff -Nru --exclude .depend --exclude '*.o' --exclude '*.ver' --exclude '.*.flags' --exclude '*.orig' --exclude '*.rej' --exclude '*~' linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack_pptp.h linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack_pptp.h
 --- linux-2.4.18-newnat/include/linux/netfilter_ipv4/ip_conntrack_pptp.h	Thu Jan  1 01:00:00 1970
 +++ linux-2.4.18-pptp3.01//include/linux/netfilter_ipv4/ip_conntrack_pptp.h	Mon Apr  8 12:42:36 2002

--------------Boundary-00=_0UZPJUNHI0OHWRABIAL8--
