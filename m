From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] MASQUERADE handling of device events
Date: Tue, 09 Nov 2004 12:04:47 +0100
Message-ID: <4190A44F.7010509@trash.net>
References: <20041107181825.GA3522@linuxace.com> <418F9952.5030004@trash.net>
	<20041108161511.GA6754@linuxace.com> <418F9DD4.20202@trash.net>
	<20041108163457.GB6754@linuxace.com>
	<20041108215525.GA8766@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000204030308050905050405"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20041108215525.GA8766@linuxace.com>
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
--------------000204030308050905050405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Phil Oester wrote:

>On Mon, Nov 08, 2004 at 08:34:57AM -0800, Phil Oester wrote:
>  
>
>>It's a great idea, and will reduce the size of struct ip_conntrack.
>>But I think it should be done in a separate cleanup patch - really would
>>like to get this one merged up to fix the masq issues.
>>    
>>
>
>Actually masq_index is still used in connect_unassure, and thus can't
>be removed completely.  In cases where the interface goes down permanently,
>clearing the assured bit makes sense, so guess this behaviour should be
>maintained.
>  
>
You're right. I have to admit, I'm not too happy about the unpredictable
behaviour we get with this patch and multiple ppp devices. So one last
attempt to convince people. The old behaviour was to kill conntracks once
the device goes down. I think killing conntracks when the IP is deleted
makes more sense. Since the IP has to be deleted manually, except when
the device goes away, people can simply not delete IP addresses for
devices that don't go away, than nothing will get removed. pppd can be
taught to keep the device alive. The attached patch adds a program
alloc-ppp to pre-allocate ppp-devices and teaches pppd to attach to them.
The device never goes away, if ppp doesn't delete the IP address the
conntracks won't be killed. It could easily be integrated in a more handy
way in pppd. So this could also be done entirely in userspace, without
the unpredictable behaviour.

Regards
Patrick


--------------000204030308050905050405
Content-Type: text/x-patch;
 name="ppp_attach.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ppp_attach.diff"

diff -urN a/pppd/alloc-ppp.c b/pppd/alloc-ppp.c
--- a/pppd/alloc-ppp.c	1970-01-01 01:00:00.000000000 +0100
+++ b/pppd/alloc-ppp.c	2004-11-04 17:09:35.804341216 +0100
@@ -0,0 +1,64 @@
+
+
+#include <unistd.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <errno.h>
+#include <fcntl.h>
+
+#include <sys/ioctl.h>
+
+#include <asm/types.h> 
+#include <net/if.h>
+#include <net/if_arp.h>
+#include <net/route.h>
+#include <netinet/if_ether.h>
+
+
+#include <linux/ppp_defs.h>
+#include <linux/if_ppp.h>
+
+
+
+int main( int argc, char ** argv ) {
+
+    int ndev = 0;
+    int n = 0;
+    int ppp_dev_fd = 0;
+
+    if( argc != 2 ) {
+        fprintf(stderr,"use \"%s <n>\" to allocate n ppp devices\n", argv[0]);
+	exit(1);
+    }
+
+    ndev = atoi(argv[1]);
+
+    if( ndev <= 0 ) {
+        fprintf(stderr,"argument must b a number > 0 not %s\n", argv[1]);
+	exit(1);
+    }
+
+    for( n = 0; n < ndev; n ++ ) {
+        int ifunit = n;
+        int res = 0;
+	
+        if( (ppp_dev_fd = open("/dev/ppp", O_RDWR )) < 0 ) {
+	    perror("can not open /dev/ppp :");
+	    exit(2);
+        }
+
+        res = ioctl(ppp_dev_fd, PPPIOCNEWUNIT, &ifunit);
+	if( res < 0 ) {
+	    fprintf(stderr, "can not allocate ppp device %d : %s \n",
+	    	n , strerror(errno) );
+	}
+    }
+
+    while( 1 == 1 ) {
+        sleep(3600);
+    }
+
+    exit(0);
+}
+
diff -urN a/pppd/Makefile.linux b/pppd/Makefile.linux
--- a/pppd/Makefile.linux	2003-11-27 22:55:19.000000000 +0100
+++ b/pppd/Makefile.linux	2004-11-04 17:09:35.804341216 +0100
@@ -8,7 +8,7 @@
 MANDIR = $(DESTDIR)/usr/man
 INCDIR = $(DESTDIR)/usr/include
 
-TARGETS = pppd
+TARGETS = pppd alloc-ppp
 
 PPPDSRCS = main.c magic.c fsm.c lcp.c ipcp.c upap.c chap-new.c md5.c ccp.c \
 	   ecp.c ipxcp.c auth.c options.c sys-linux.c md4.c chap_ms.c \
@@ -196,10 +196,11 @@
 
 all: $(TARGETS)
 
-install: pppd
+install: pppd alloc-ppp
 	mkdir -p $(BINDIR) $(MANDIR)
 	$(EXTRAINSTALL)
 	$(INSTALL) -s -c -m 555 pppd $(BINDIR)/pppd
+	$(INSTALL) -s -c -m 555 alloc-ppp $(BINDIR)/alloc-ppp
 	if chgrp pppusers $(BINDIR)/pppd 2>/dev/null; then \
 	  chmod o-rx,u+s $(BINDIR)/pppd; fi
 	$(INSTALL) -c -m 444 pppd.8 $(MANDIR)/man8
@@ -207,6 +208,9 @@
 pppd: $(PPPDOBJS)
 	$(CC) $(CFLAGS) $(LDFLAGS) -o pppd $(PPPDOBJS) $(LIBS)
 
+alloc-ppp: alloc-ppp.o
+	$(CC) $(CFLAGS) -o alloc-ppp alloc-ppp.o
+
 srp-entry:	srp-entry.c
 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ srp-entry.c $(LIBS)
 
@@ -216,6 +220,7 @@
 
 clean:
 	rm -f $(PPPDOBJS) $(EXTRACLEAN) $(TARGETS) *~ #* core
+	rm -f alloc-ppp.o alloc-ppp
 
 depend:
 	$(CPP) -M $(CFLAGS) $(PPPDSRCS) >.depend
diff -urN a/pppd/sys-linux.c b/pppd/sys-linux.c
--- a/pppd/sys-linux.c	2004-01-13 05:05:20.000000000 +0100
+++ b/pppd/sys-linux.c	2004-11-04 17:10:06.951606112 +0100
@@ -639,6 +639,21 @@
 		warn("Couldn't set /dev/ppp to nonblock: %m");
 
 	ifunit = req_unit;
+
+	/* 
+	 * try to attach to an alread existing ppp device. We should
+	 * get an EFAULT if the ppp interface is in use by another pppd.
+	 */
+	if (ifunit >= 0) {
+		x = ioctl(ppp_dev_fd, PPPIOCATTACH , &ifunit);
+		if (x < 0) {
+			/* warn and continue to create a new device */
+			warn("Couldn't attatch to unit %d as it does not exist", req_unit);
+		} else {
+			return x;
+		}
+	}
+
 	x = ioctl(ppp_dev_fd, PPPIOCNEWUNIT, &ifunit);
 	if (x < 0 && req_unit >= 0 && errno == EEXIST) {
 		warn("Couldn't allocate PPP unit %d as it is already in use", req_unit);

--------------000204030308050905050405--
