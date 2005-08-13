From: solt@dns.toxicfilms.tv
Subject: [PATCH] Missing information in INCOMPATIBILITES file
Date: 13 Aug 2005 18:19:13 +0200
Message-ID: <20050813161913.23436.qmail@dns.toxicfilms.tv>
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

Hi,

I thought we could correct the missing information in the
INCOMPATIBILITIES file about which kernels do support --admin-prohib in
REJECT. I belive we left that to fill in when it is included in the kernel,
and forgot to do it :-)

Please, apply this trivial patch.

--
Regards,
Maciej Soltysiak

Index: iptables/iptables/INCOMPATIBILITIES
===================================================================
--- iptables/iptables/INCOMPATIBILITIES	(revision 4241)
+++ iptables/iptables/INCOMPATIBILITIES	(working copy)
@@ -4,6 +4,8 @@
   with kernels that do not support it, will result in a plain DROP instead
   of REJECT.  Use with caution.
   Kernels that do support it:
+	2.4 - since 2.4.22-pre9
+	2.6 - all
 
 - There are some issues related to upgrading from 1.2.x to 1.3.x on a system
   with dynamic ruleset changes during runtime. (Please see 
