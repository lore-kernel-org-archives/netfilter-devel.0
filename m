From: "Gatis Peisenieks" <gatis@mt.lv>
Subject: [PATCH] problem with 'raw' patch and REJECT target
Date: Thu, 8 Jan 2004 19:25:02 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000d01c3d60c$596b1f10$3200000a@gatis>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-4"
Content-Transfer-Encoding: 7bit
Cc: <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello all,

here is a patch that fixes (?) a bug in 'raw' table. The bug can be
replicated by using raw table with one NOTRACK rule that matches everything
and a filter rule (in my case in INPUT chain) that has  REJECT target. First
ICMP/TCP packet that matches the REJECT rule make the kernel crash with NULL
pointer dereference.

Investigation showed that the cause of a crash is REJECTs generated ICMP
error and TCP RST packets that used uninitialised entries in
ip_conntrack_untracked ip_conntrack.

Not sure about right solution of the problem, but the following patch made
the crash go away.
diff was generated on net/ipv4/netfilter/ip_conntrack_core.c with raw.patch
applied.

RCS file: /kernel/linux4/net/ipv4/netfilter/ip_conntrack_core.c,v
retrieving revision 1.12
diff -u -r1.12 ip_conntrack_core.c
--- ip_conntrack_core.c 2 Dec 2003 11:50:36 -0000       1.12
+++ ip_conntrack_core.c 8 Jan 2004 16:58:05 -0000
@@ -1473,7 +1473,8 @@
        set_bit(IPS_CONFIRMED_BIT, &ip_conntrack_untracked.status);
        /*  - and prepare the ctinfo field for NAT. */
        ip_conntrack_untracked.infos[IP_CT_NEW].master =
&ip_conntrack_untracked.ct_general;
-
+       ip_conntrack_untracked.infos[IP_CT_RELATED].master =
&ip_conntrack_untracked.ct_general;
+       ip_conntrack_untracked.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master
= &ip_conntrack_untracked.ct_general;
        return ret;

 err_free_hash:


Gatis
