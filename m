From: Josh Samuelson <josamue1@wsc.edu>
Subject: Re: [PATCH] new match extension `flow'
Date: Thu, 28 Oct 2004 15:15:25 -0500
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041028201525.GA30087@wsc.edu>
References: <20041028020550.GA10097@wsc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="h31gzZEtNLTqOjlF"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20041028020550.GA10097@wsc.edu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

After thinking about it for a bit, this match could be used in more tables
then just the filter table.  These patches make it so the prior patch
works in all tables but raw.

-Josh

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="linux-2.6.9-flow-20041028-noraw.diff"

diff -Pru linux-2.6.9-flow-20041027/net/ipv4/netfilter/ipt_flow.c linux-2.6.9-flow-20041028/net/ipv4/netfilter/ipt_flow.c
--- linux-2.6.9-flow-20041027/net/ipv4/netfilter/ipt_flow.c	2004-10-28 13:49:20.430784272 -0500
+++ linux-2.6.9-flow-20041028/net/ipv4/netfilter/ipt_flow.c	2004-10-28 13:49:54.800559272 -0500
@@ -77,8 +77,8 @@
 	if (matchsize != IPT_ALIGN(sizeof(struct ipt_flow_info)))
 		return 0;
 
-	if (strcmp(tablename, "filter") != 0) {
-		printk(KERN_WARNING "flow: can only be used in \"filter\" table, not \"%s\"\n", tablename);
+	if (strcmp(tablename, "raw") == 0) {
+		printk(KERN_WARNING "flow: can not by used in the \"raw\" table\n");
 		return(0);
 	}
 

--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="iptables-1.2.11-flow-20041028-noraw.diff"

diff -Pru iptables-1.2.11-flow-20041027/extensions/libipt_flow.man iptables-1.2.11-flow-20041028/extensions/libipt_flow.man
--- iptables-1.2.11-flow-20041027/extensions/libipt_flow.man	2004-10-28 14:56:07.752578760 -0500
+++ iptables-1.2.11-flow-20041028/extensions/libipt_flow.man	2004-10-28 14:54:42.386556368 -0500
@@ -1,6 +1,6 @@
 This module, when combined with connection tracking, allows access to
 IP, ICMP, TCP and UDP flow counts per source IP address (IP_CT_DIR_ORIGINAL
-state from ip_conntrack)  This match module can only be used in the filter
+state from ip_conntrack)  This match module can not be used in the raw
 table.
 .TP
 .BI "--maxip "   "n"

--h31gzZEtNLTqOjlF--
