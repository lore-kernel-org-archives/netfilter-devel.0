From: Thomas Woerner <twoerner@redhat.com>
Subject: [PATCH] segmentation fault in free
Date: Thu, 26 Aug 2004 15:36:56 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <412DE778.2030202@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010900090307000607000008"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010900090307000607000008
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit


Hello,


I have found a bad bug in iptables. saddrs and daddrs are allocated with calloc in 
host_to_addr if a hostname resolves to more than one ip address, but each array 
element if getting freed in do_command. The first free will free the whole array and 
the others are returning that this is not a pointer or are segfaulting.

Fix for this is attached.


Thanks,
Thomas

-- 
Thomas Woerner
Software Engineer            Phone: +49-711-96437-310
Red Hat GmbH                 Fax  : +49-711-96437-111
Hauptstaetterstr. 58         Email: Thomas Woerner <twoerner@redhat.com>
D-70178 Stuttgart            Web  : http://www.redhat.de/

--------------010900090307000607000008
Content-Type: text/x-patch;
 name="iptables-1.2.11-free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-1.2.11-free.patch"

--- iptables-1.2.11/iptables.c.free	2004-08-25 19:15:29.000000000 +0200
+++ iptables-1.2.11/iptables.c	2004-08-26 15:34:28.490605182 +0200
@@ -2344,11 +2344,8 @@
 		e = NULL;
 	}
 
-	for (c = 0; c < nsaddrs; c++)
-		free(&saddrs[c]);
-
-	for (c = 0; c < ndaddrs; c++)
-		free(&daddrs[c]);
+	free(saddrs);
+	free(daddrs);
 
 	if (opts != original_opts) {
 		free(opts);

--------------010900090307000607000008--
