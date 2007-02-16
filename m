From: Sebastien Tricaud <sebastien.tricaud@wengo.com>
Subject: Re: Change Packet Payload
Date: Fri, 16 Feb 2007 14:11:19 +0100
Message-ID: <45D5AD77.3080709@wengo.com>
References: <1171012218.4162.27.camel@LinuxCampo>	<1171013512.18531.5.camel@localhost>	<45D23748.2090609@netfilter.org>	<45D2DA9E.4010005@wengo.com>	<45D2DBFB.7040702@trash.net>	<45D2DCA9.1050100@wengo.com>	<45D2DEDA.7020204@wengo.com>	<45D2DFE8.8080301@trash.net>
	<45D3AB00.7080505@netfilter.org> <45D47214.8000508@wengo.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000309000409070409030604"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D47214.8000508@wengo.com>
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

This is a multi-part message in MIME format.
--------------000309000409070409030604
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi folks,

this is patch adds the checksum computation feature in netfilter_queue.


Thanks,
Sebastien.


--------------000309000409070409030604
Content-Type: text/x-patch;
 name="nfq-compute_cksum.2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfq-compute_cksum.2.patch"

Index: include/libnetfilter_queue/Makefile.am
===================================================================
--- include/libnetfilter_queue/Makefile.am	(revision 6757)
+++ include/libnetfilter_queue/Makefile.am	(working copy)
@@ -1,3 +1,3 @@
 
-pkginclude_HEADERS = libnetfilter_queue.h libipq.h linux_nfnetlink_queue.h
+pkginclude_HEADERS = libnetfilter_queue.h libipq.h linux_nfnetlink_queue.h protocol_any_helper.h
 
Index: include/libnetfilter_queue/libnetfilter_queue.h
===================================================================
--- include/libnetfilter_queue/libnetfilter_queue.h	(revision 6757)
+++ include/libnetfilter_queue/libnetfilter_queue.h	(working copy)
@@ -14,9 +14,8 @@
 #define __LIBCTNETLINK_H
 
 #include <libnfnetlink/libnfnetlink.h>
-// #include <libnfnetlink/liunx_nfnetlink.h>
-
 #include <libnetfilter_queue/linux_nfnetlink_queue.h>
+#include <libnetfilter_queue/protocol_any_helper.h>
 
 struct nfq_handle;
 struct nfq_q_handle;
@@ -79,8 +78,7 @@
 extern u_int32_t nfq_get_physindev(struct nfq_data *nfad);
 extern u_int32_t nfq_get_outdev(struct nfq_data *nfad);
 extern u_int32_t nfq_get_physoutdev(struct nfq_data *nfad);
-
-extern int nfq_get_indev_name(struct nlif_handle *nlif_handle,
+extern int nfq_get_indev_name(struct nlif_handle *nlif_handle, 
 			      struct nfq_data *nfad, char *name);
 extern int nfq_get_physindev_name(struct nlif_handle *nlif_handle,
 			          struct nfq_data *nfad, char *name);
Index: include/libnetfilter_queue/protocol_any_helper.h
===================================================================
--- include/libnetfilter_queue/protocol_any_helper.h	(revision 0)
+++ include/libnetfilter_queue/protocol_any_helper.h	(revision 0)
@@ -0,0 +1,17 @@
+/* 
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+extern unsigned short nfq_compute_cksum(unsigned short *addr, int count);
+
Index: configure.in
===================================================================
--- configure.in	(revision 6757)
+++ configure.in	(working copy)
@@ -23,7 +23,7 @@
 PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
 	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
  
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
+CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS -Wpadded"
 LIBNFQUEUE_LIBS="$LIBNFNETLINK_LIBS"
  
 AC_SUBST(LIBNFQUEUE_LIBS)
Index: src/protocol_any_helper.c
===================================================================
--- src/protocol_any_helper.c	(revision 0)
+++ src/protocol_any_helper.c	(revision 0)
@@ -0,0 +1,53 @@
+/* 
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 
+ *  as published by the Free Software Foundation
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ */
+
+#include <libnetfilter_queue/protocol_any_helper.h>
+
+/** 
+ * nfq_compute_cksum - returns the checksum computed 
+ * @addr: Address of stored data pointer
+ * @count: packet lenght (header+payload)
+ *
+ * Helper function to compute packet checkum.
+ */
+/* Copyright (C) The Internet Society 1988. This version of this code
+ * is part of RFC 1071; see the RFC itself for full legal notices.
+ *
+ * The original code has been slightly changed
+ */
+unsigned short nfq_compute_cksum(unsigned short *addr, int count)
+{
+
+	/* Compute Internet Checksum for "count" bytes
+	 *         beginning at location "addr".
+	 */
+	unsigned short sum = 0;
+
+        while( count > 1 ) {
+		/*  This is the inner loop */
+		sum += (unsigned short *) addr++;
+		count -= 2;
+	}
+
+	/*  Add left-over byte, if any */
+	if( count > 0 )
+		sum += * (unsigned char *) addr;
+
+	/*  Fold 32-bit sum to 16 bits */
+	while (sum>>16)
+		sum = (sum & 0xffff) + (sum >> 16);
+
+	return ~sum;
+}
Index: src/Makefile.am
===================================================================
--- src/Makefile.am	(revision 6757)
+++ src/Makefile.am	(working copy)
@@ -10,7 +10,7 @@
 
 libnetfilter_queue_la_LDFLAGS = -Wc,-nostartfiles -lnfnetlink \
 				-version-info $(LIBVERSION)
-libnetfilter_queue_la_SOURCES = libnetfilter_queue.c 
+libnetfilter_queue_la_SOURCES = libnetfilter_queue.c protocol_any_helper.c
 
 libnetfilter_queue_libipq_la_LDFLAGS = -Wc,-nostartfiles \
 				-version-info 1:0:0

--------------000309000409070409030604--
