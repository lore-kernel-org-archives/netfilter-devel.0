From: Vineet Mehta <extreme@zayanionline.com>
Subject: possible ipt_MASQUERADE.c bug
Date: Tue, 17 Feb 2004 16:19:35 +0300 (AST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402171613120.26321-100000@sillypoint.zayanionline.com>
References: <Pine.LNX.4.44.0402171156460.29541-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0402171156460.29541-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

while working on Fedora kernel version 2.4.22-1.2115.nptl code i found out 
that one of the DEBUGP(...) statement had problem with variable name.

DEBUGP("masquerade_check: bad table `%s'.\n", table);

instead of

DEBUGP("masquerade_check: bad table `'%s'.\n", tablename);

i also checked on vanilla kernel 2.4.22 also and it had the same problem.

i dont know if its already done but here is the patch atatched.

Regards,
extreme

***********

diff -Nur linux-2.4.22-1.2115.nptl/net/ipv4/netfilter/ipt_MASQUERADE.c new/net/ipv4/netfilter/ipt_MASQUERADE.c
--- linux-2.4.22-1.2115.nptl/net/ipv4/netfilter/ipt_MASQUERADE.c	2003-10-29 23:18:34.000000000 +0300
+++ new/net/ipv4/netfilter/ipt_MASQUERADE.c	2004-02-18 06:49:11.000000000 +0300
@@ -32,7 +32,7 @@
 	const struct ip_nat_multi_range *mr = targinfo;
 
 	if (strcmp(tablename, "nat") != 0) {
-		DEBUGP("masquerade_check: bad table `%s'.\n", table);
+		DEBUGP("masquerade_check: bad table `%s'.\n", tablename);
 		return 0;
 	}
 	if (targinfosize != IPT_ALIGN(sizeof(*mr))) {
 
