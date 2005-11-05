From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 2/3] nfsim-testsuite: fix XFAIL for
	01iptables/01tcp-syn-new.sim
Date: Sat, 5 Nov 2005 12:35:39 +0100
Message-ID: <200511051235.39483@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_LkJbDiYDPFonlMq"
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

--Boundary-00=_LkJbDiYDPFonlMq
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  01tcp-syn-new.sim contains an XFAIL line indicating that it requitres 
at least iptables 1.3.1. Actually, the --syn tcp option related fix is 
present only in 1.3.2 (and up).

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_LkJbDiYDPFonlMq
Content-Type: text/x-diff; charset="us-ascii";
	name="02-nfsim-testsuite-tcp_syn_new_xfail_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="02-nfsim-testsuite-tcp_syn_new_xfail_fix.patch"

Actually, it was 1.3.2 which included !FIN in the --syn option.

Index: nfsim-testsuite/01iptables/01tcp-syn-new.sim
===================================================================
--- nfsim-testsuite/01iptables/01tcp-syn-new.sim	(revision 4444)
+++ nfsim-testsuite/01iptables/01tcp-syn-new.sim	(working copy)
@@ -1,5 +1,5 @@
-# Test --syn tcp option: iptables 1.3.1 changed this to include !FIN.
-# XFAIL:iptables:<1.3.1
+# Test --syn tcp option: iptables 1.3.2 changed this to include !FIN.
+# XFAIL:iptables:<1.3.2
 
 iptables -A FORWARD -p tcp --syn -j DROP
 expect gen_ip send:eth1 {IPv4 192.168.0.3 192.168.1.2 0 6 2 1 SYN/FIN}

--Boundary-00=_LkJbDiYDPFonlMq--
