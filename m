From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] Remove use of 'mangle' from DNAT/SNAT
Date: Mon, 29 Nov 2004 17:51:53 -0800
Message-ID: <20041130015153.GA3703@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="RnlQjJ0d97Da+TV1"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

At least one user (via bugzilla) was confused by the use of the word
mangle in the man entries for DNAT and SNAT.  Might as well clarify 
it...trivial patch below.

This closes bugzilla #261.

Phil



--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-clarifymangle

diff -ru ipt-orig/extensions/libipt_DNAT.man ipt-new/extensions/libipt_DNAT.man
--- ipt-orig/extensions/libipt_DNAT.man	2004-01-22 07:04:24.000000000 -0800
+++ ipt-new/extensions/libipt_DNAT.man	2004-11-29 17:43:24.793557534 -0800
@@ -5,9 +5,9 @@
 and
 .B OUTPUT
 chains, and user-defined chains which are only called from those
-chains.  It specifies that the destination address of the packet
-should be modified (and all future packets in this connection will
-also be mangled), and rules should cease being examined.  It takes one
+chains.  It specifies that the destination address of this packet
+(and any future packets associated with this connection) should be
+modified, and rules should cease being examined.  It takes one
 type of option:
 .TP
 .BR "--to-destination " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"
diff -ru ipt-orig/extensions/libipt_SNAT.man ipt-new/extensions/libipt_SNAT.man
--- ipt-orig/extensions/libipt_SNAT.man	2004-01-22 07:04:24.000000000 -0800
+++ ipt-new/extensions/libipt_SNAT.man	2004-11-29 17:47:58.291064181 -0800
@@ -2,9 +2,9 @@
 .B nat
 table, in the
 .B POSTROUTING
-chain.  It specifies that the source address of the packet should be
-modified (and all future packets in this connection will also be
-mangled), and rules should cease being examined.  It takes one type
+chain.  It specifies that the source address of this packet (and any
+future packets associated with this connection) should be modified,
+and rules should cease being examined.  It takes one type
 of option:
 .TP
 .BR "--to-source  " "\fIipaddr\fP[-\fIipaddr\fP][:\fIport\fP-\fIport\fP]"

--RnlQjJ0d97Da+TV1--
