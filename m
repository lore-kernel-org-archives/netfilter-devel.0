From: Jakub Bogusz <qboosh@pld.org.pl>
Subject: [PATCH] endianess fix for ip_conntrack_amanda
Date: Tue, 5 Aug 2003 21:06:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030805190657.GA31073@satan.blackhosts>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello,

I've just noticed that I probably missed one place (in ip_conntrack_amanda)
when I was making fixes for big-endian archs in conntrack and nat modules
by using C99 initializers in May, and it remained unfixed (at least in
2.6.0-test2, where all other fixes are already merged; probably the same
in 2.4.22-pre).

So here is the missing element...


-- 
Jakub Bogusz    http://cyber.cs.net.pl/~qboosh/
PLD Linux       http://www.pld-linux.org/

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-netfilter-ip_conntrack_amanda-endian.patch"

This is one more fix for big-endian problems in conntrack and nat modules,
similar to those merged about two months ago (this one was missing).

	Jakub Bogusz <qboosh@pld.org.pl>

--- linux-2.6.0-test2/net/ipv4/netfilter/ip_conntrack_amanda.c.orig	2003-07-14 05:35:56.000000000 +0200
+++ linux-2.6.0-test2/net/ipv4/netfilter/ip_conntrack_amanda.c	2003-08-05 20:38:55.000000000 +0200
@@ -133,11 +133,11 @@
 				{ { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip,
 				    { 0 } },
 				  { ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip,
-				    { htons(exp_amanda_info->port) },
+				    { .tcp = { htons(exp_amanda_info->port) } },
 				    IPPROTO_TCP }});
 			expect.mask = ((struct ip_conntrack_tuple)
 				{ { 0, { 0 } },
-				  { 0xFFFFFFFF, { 0xFFFF }, 0xFFFF }});
+				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFFFF }});
 
 			expect.expectfn = NULL;
 

--k+w/mQv8wyuph6w0--
