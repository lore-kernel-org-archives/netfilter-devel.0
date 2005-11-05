From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 1/3] nfsim-testsuite: don't depend on NAT for name lookup
	checks
Date: Sat, 5 Nov 2005 12:35:31 +0100
Message-ID: <200511051235.31675@nienna>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_DkJbD3akbez8vRD"
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

--Boundary-00=_DkJbD3akbez8vRD
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


  Hi,

  The current test for iptables name lookups and the -n option depends 
on NAT. This is bad, as nf_conntrack does not support NAT.

-- 
 Regards,
  Krisztian Kovacs

--Boundary-00=_DkJbD3akbez8vRD
Content-Type: text/x-diff; charset="us-ascii";
	name="01-nfsim-testsuite-no_nat_for_namelookup_test.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="01-nfsim-testsuite-no_nat_for_namelookup_test.patch"

Don't depend on NAT to check whether NS lookup is working.

Index: nfsim-testsuite/01iptables/15namelookup.sim
===================================================================
--- nfsim-testsuite/01iptables/15namelookup.sim	(revision 4444)
+++ nfsim-testsuite/01iptables/15namelookup.sim	(working copy)
@@ -1,13 +1,13 @@
 # Test that name lookup works.
 
 # This succeeds.
-iptables -t nat -A POSTROUTING -s localhost -d localhost -p tcp -j SNAT --to-source 192.168.1.1
-iptables -t nat -D POSTROUTING -s 127.0.0.1 -d 127.0.0.1 -p tcp -j SNAT --to-source 192.168.1.1
+iptables -A INPUT -s localhost -d localhost -p tcp -j ACCEPT
+iptables -D INPUT -s 127.0.0.1 -d 127.0.0.1 -p tcp -j ACCEPT
 
 # These will fail.
 expect iptables iptables: command failed
-iptables -t nat -A POSTROUTING -n -s localhost -d 127.0.0.1 -p 6 -j SNAT --to-source 192.168.1.1
+iptables -A INPUT -n -s localhost -d 127.0.0.1 -p 6 -j ACCEPT
 expect iptables iptables: command failed
-iptables -t nat -A POSTROUTING -n -s 127.0.0.1 -d localhost -p 6 -j SNAT --to-source 192.168.1.1
+iptables -A INPUT -n -s 127.0.0.1 -d localhost -p 6 -j ACCEPT
 expect iptables iptables: command failed
-iptables -t nat -A POSTROUTING -n -s 127.0.0.1 -d 127.0.0.1 -p tcp -j SNAT --to-source 192.168.1.1 
+iptables -A INPUT -n -s 127.0.0.1 -d 127.0.0.1 -p tcp -j ACCEPT

--Boundary-00=_DkJbD3akbez8vRD--
