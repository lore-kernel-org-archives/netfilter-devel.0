From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom h323-conntrack-nat] set exp->master in h245_help()
Date: Mon, 11 Apr 2005 22:08:55 +0200
Message-ID: <20050411200855.GA24633@roonstrasse.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="gKMricLos+KVdGMg"
Cc: laforge@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

this small patch re-adds a line which had disappeared for an unknown
reason from my sources...

Max


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="h323-set_exp_master.patch"

Mon Apr 11 21:56:02 CEST 2005  max@duempel.org
  * bugfix: set exp->master in h245_help()
diff -rN -u old-h323-8/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c new-h323-8/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c
--- old-h323-8/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	2005-04-11 22:07:31.000000000 +0200
+++ new-h323-8/h323-conntrack-nat/linux-2.6.11/net/ipv4/netfilter/ip_conntrack_h323.c	2005-04-11 22:07:31.000000000 +0200
@@ -135,6 +135,7 @@
 				  { 0xFFFFFFFF, { .tcp = { 0xFFFF } }, 0xFF }});
 
 			exp->expectfn = NULL;
+			exp->master = ct;
 
 			if (ip_nat_h245_hook != NULL) {
 				ret = ip_nat_h245_hook(pskb, ctinfo, i,


--gKMricLos+KVdGMg--
