From: Jeff Hall <hall@vdata.com>
Subject: PPTP connection tracking and NAT patches
Date: Thu, 20 Mar 2003 03:32:46 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.03.10303190516050.23211-100000@shemp.vdata.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Below are patches which correct problems I encountered while testing
the PPTP conntrack and NAT modules. These patches are to V1.7 of 
ip_conntrack_pptp.c and to the 2.4.20 patch level of ip_nat_core.c with
V1.12 of pptp-conntrack-nat.patch and the NAT ICMP patch (2003/02/26).

The ip_conntrack_pptp.c patch prevents a kernel crash caused by an attempt
to dereference a NULL value. The original code failed when the next link
pointed to the parent ip_conntrack rather than the next ip_conntrack_expect.

The ip_nat_core.c patch ensures that the PPTP helper function is called even
after the expected GRE connection is established. I have not evaluated any
other protocols with helper functions to see if this will cause problems.
Others with more experience in netfilter programming may know. I am sure that
the PPTP NAT helper function needs to be called otherwise both the TCP and
GRE connections fail to disappear when the VPN tunnel is closed.

I also noticed that since the helper function is called for each expectation
both inbound and outbound packets are sent to ip_nat_mangle_tcp_packet twice
until an expected GRE connection is established. However, since this does
not appear do cause any problems and I was not confident of the best way to
prevent the extra manipulation, I did not attempt any patch.

I was also having problems running a PoPToP server on the firewall server.
The reason turned out to be that I had not chosen CONFIG_IP_NF_NAT_LOCAL
thinking that I did not need to NAT my local connections since my local
machines IP was not the same as the IP I am using for NAT. It turns out that
even if a connection does not satisfy any NAT rule the helper function is
called in do_bindings. Without CONFIG_IP_NF_NAT_LOCAL set the helper function
was being called for DST manipulations but not for SRC manipulations. My
question to netfilter gurus is shouldn't the helper function be skipped if
the connection doesn't satisfy any NAT rule?

I did quite a bit of testing of these modules in an environment where we
are making connections using the Windows RAS client from behind a NAT'ing
firewall and also need to run PoPToP on the firewall server for employees
working from home. The modules with these patches never failed. I was even
able to make two connections from behind a NAT'ing wireless access point 
to the firewall PoPToP server (with a patch to PoPToP to generate non-
zero call IDs).




--- linux-2.4.20.prepatch/net/ipv4/netfilter/ip_conntrack_pptp.c	Thu Feb 27 04:02:44 2003
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_pptp.c	Sat Mar 15 22:25:01 2003
@@ -113,12 +113,17 @@
 	/* delete other expectation */
 	if (exp->expected_list.next != &exp->expected_list) {
 		struct ip_conntrack_expect *other_exp;
+		struct list_head *cur_item, *next;
 
-		other_exp = list_entry(exp->expected_list.next,
-				       struct ip_conntrack_expect,
-				       expected_list);
 		DEBUGP("unexpecting other direction\n");
-		ip_conntrack_unexpect_related(other_exp);
+
+		for (cur_item = master->sibling_list.next;
+		    cur_item != &master->sibling_list; cur_item = next) {
+			next = cur_item->next;
+			other_exp = list_entry(cur_item, struct ip_conntrack_expect,
+					 expected_list);
+			if ( other_exp != exp ) ip_conntrack_unexpect_related(other_exp);
+		}
 	}
 
 	return 0;
--- linux-2.4.20.prepatch/net/ipv4/netfilter/ip_nat_core.c	Sat Mar 15 21:42:37 2003
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_core.c	Sun Mar 16 05:08:49 2003
@@ -798,7 +798,7 @@
 	if (helper) {
 		struct ip_conntrack_expect *exp = NULL;
 		struct list_head *cur_item;
-		int ret = NF_ACCEPT;
+		int ret = NF_ACCEPT, helper_called = 0;
 
 		DEBUGP("do_bindings: helper existing for (%p)\n", ct);
 
@@ -826,10 +826,11 @@
 					READ_UNLOCK(&ip_conntrack_lock);
 					return ret;
 				}
+				helper_called = 1;
 			}
 		}
-		/* Helper might want to manip the packet even when there is no expectation */
-		if (!exp && helper->flags & IP_NAT_HELPER_F_ALWAYS) {
+		/* Helper might want to manip the packet even when there is no expectation - or if the expectations have been established */
+		if (!helper_called && helper->flags & IP_NAT_HELPER_F_ALWAYS) {
 			DEBUGP("calling nat helper for packet without expectation\n");
 			ret = helper->help(ct, NULL, info, ctinfo, 
 					   hooknum, pskb);
