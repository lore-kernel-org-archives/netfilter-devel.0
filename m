From: Eric Leblond <eric@inl.fr>
Subject: [PATCH] iptables: fix ipt_MARK documentation
Date: Mon, 28 Aug 2006 23:58:15 +0200
Message-ID: <1156802295.15828.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ZqVa6oEMqwCt2/SwHSvl"
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


--=-ZqVa6oEMqwCt2/SwHSvl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

This patch documents --or-mask and --and-mask options of the MARK
target. Description is directly taken from the source code.

BR,
-- 
Eric Leblond <eric@inl.fr>

--=-ZqVa6oEMqwCt2/SwHSvl
Content-Disposition: attachment; filename=libipt_MARK.man.diff
Content-Type: text/x-patch; name=libipt_MARK.man.diff; charset=us-ascii
Content-Transfer-Encoding: 7bit

=== extensions/libipt_MARK.man
==================================================================
--- extensions/libipt_MARK.man	(revision 4255)
+++ extensions/libipt_MARK.man	(local)
@@ -3,4 +3,11 @@
 .B mangle
 table.  It can for example be used in conjunction with iproute2.
 .TP
-.BI "--set-mark " "mark"
+.BI "--set-mark " "value"
+Set nfmark value
+.TP
+.BI "--and-mark " "value"
+Binary AND the nfmark with value
+.TP
+.BI "--or-mark " "value"
+Binary OR  the nfmark with value

--=-ZqVa6oEMqwCt2/SwHSvl--
