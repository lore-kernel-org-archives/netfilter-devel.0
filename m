From: Peter Zion <pzion@nit.ca>
Subject: [PATCH] PPTP connection tracking: fixed oops during PPTP connect
 when interface under heavy load
Date: Thu, 06 Jan 2005 13:50:37 -0500
Message-ID: <41DD887D.6080007@nit.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

Summary:

If PPTP connection tracking is running on a machine and certain PPTP
packets arrive out of order, or preceding packets never made
it to the machine, the PPTP connection tracking code will
dereference NULL pointers.  Reproduction steps are to attempt PPTP 
connections
to the machine on an interface under heavy load.

Reproduction:

1. Set up the vulnerable machine NATing a shared external connection to the
local network and with a PPTP daemon running that allows connections from
the external network.  It must have PPTP connection tracking enabled.

2. On a machine on the local network for which the vulnerable machine is
acting as a gateway to the external network, run hping2 about 8-15 times
simultaneously, until your ping response is around 500-800ms but with less
than 50% packet loss.  Use the following options: "hping2 -2 --destport 123
--keep -d 100 -i u1 <external address>", where <external address> is a 
machine
on the external network that won't mind being flooded for a few minutes.

3. On a machine on the external network, repeatedly make a PPTP
connection to the vulnerable machine.  In our experience the vulnerable
machine will oops about one in three PPTP connection attempts.

Patch:

--- linux.orig/net/ipv4/netfilter/ip_conntrack_proto_gre.c        Wed 
Nov 24 00:49:42 2004
+++ linux/net/ipv4/netfilter/ip_conntrack_proto_gre.c    Wed Nov 24 
00:46:15 2004
@@ -133,6 +133,13 @@ int ip_ct_gre_keymap_add(struct ip_connt
 void ip_ct_gre_keymap_change(struct ip_ct_gre_keymap *km,
                             struct ip_conntrack_tuple *t)
 {
+        if (!km)
+        {
+                printk(KERN_WARNING
+                        "NULL GRE conntrack keymap change requested\n");
+                return;
+        }
+
        DEBUGP("changing entry %p to: ", km);
        DUMP_TUPLE_GRE(t);
 
---
Peter Zion
Net Integration Technologies
