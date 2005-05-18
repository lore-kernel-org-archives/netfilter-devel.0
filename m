From: Tom Eastep <teastep@shorewall.net>
Subject: [PATCH] Another save/restore buglet
Date: Wed, 18 May 2005 16:10:38 -0700
Message-ID: <428BCB6E.1020709@shorewall.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040001030407070201020704"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------040001030407070201020704
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This time, it's the CONNMARK extention that is producing saved output
that won't restore.

gateway:/etc/test# iptables-save > save
gateway:/etc/test# iptables-restore < save
iptables-restore v1.3.1: Bad MASK value `ff'
Error occurred at line: 24
Try `iptables-restore -h' or 'iptables-restore --help' for more information.
gateway:/etc/test#

Patch attached.

-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key

--------------040001030407070201020704
Content-Type: text/x-patch;
 name="CONNMARK.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="CONNMARK.diff"

--- libipt_CONNMARK.c~	2005-05-04 13:44:08.000000000 -0700
+++ libipt_CONNMARK.c	2005-05-18 16:01:07.000000000 -0700
@@ -165,7 +165,7 @@
 print_mask(const char *text, unsigned long mask)
 {
 	if (mask != ~0UL)
-		printf("%s%lx", text, mask);
+		printf("%s0x%lx", text, mask);
 }
 #endif
 

--------------040001030407070201020704--
