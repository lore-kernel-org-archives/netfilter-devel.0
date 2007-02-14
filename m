From: Sebastien Tricaud <sebastien.tricaud@wengo.com>
Subject: Re: Change Packet Payload
Date: Wed, 14 Feb 2007 10:47:10 +0100
Message-ID: <45D2DA9E.4010005@wengo.com>
References: <1171012218.4162.27.camel@LinuxCampo>	<1171013512.18531.5.camel@localhost>
	<45D23748.2090609@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010307000305010001000500"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D23748.2090609@netfilter.org>
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
--------------010307000305010001000500
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Pablo,

I wrote this simple patch.
Any comment on it, naming conventions, better approach, etc.. appreciated


Pablo Neira Ayuso wrote:
> I would accept a patch to introduce a function that computes the
> checksum. I think that the library should provide as much helper
> functions as possible. We can group such helper functions by protocols
> in different files inside the libnetfilter_queue tree. I have already
> seen several post in the mailing list on how to retrieve data from the
> header and such.
>
>   


--------------010307000305010001000500
Content-Type: text/x-patch;
 name="nfq-compute_cksum.1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nfq-compute_cksum.1.patch"

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
+extern unsigned short nfq_compute_cksum(struct nfq_data *nfad);
+
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
+/** 
+ * nfq_compute_cksum - returns the checksum computed 
+ * @data: packet payload
+ * @len: packet lenght (header+payload)
+ *
+ * Helper function to compute packet checkum.
+ */
+/* (c) Richard W. Stevens */
+unsigned short nfq_compute_cksum(unsigned short *data, int len)
+{
+        int nleft             = len;
+        int sum               = 0;
+        unsigned short *w     = data;
+        unsigned short answer = 0;
+
+        /*
+	 * Our algorithm is simple, using a 32 bits accumulator (sum), we add
+	 * sequential 16 bit words to it, and at the end, fold back all the
+	 * carry bits from the top 16 bits into the lower 16 bits.
+	 */
+        while ( nleft > 1 ) {
+                sum   += *w++;
+                nleft -= 2;
+        }
+
+        /* mop up an odd byte, if necessary */
+        if ( nleft == 1 ) {
+                *(unsigned char *) (&answer) = *(unsigned char *) w;
+                sum += answer;
+        }
+
+        /* add back carry outs from top 16 bits to low 16 bits */
+        sum    =  (sum >> 16) + (sum & 0xffff); /* add hi 16 to low 16 */
+        sum    += (sum >> 16);  /* and carry */
+        answer =  ~sum;         /* truncate to 16 bits */
+
+        return answer;
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

--------------010307000305010001000500--
