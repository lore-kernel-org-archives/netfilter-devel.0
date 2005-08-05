From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Fix bad size of ctnl_exp_cb array
Date: Fri, 05 Aug 2005 02:36:17 +0200
Message-ID: <42F2B481.8020202@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090500060101030700090503"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------090500060101030700090503
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

This fixes the size of the ctnl_exp_cb array that is IPCTNL_MSG_EXP_MAX 
instead of IPCTNL_MSG_MAX. Simple typo.

Signed-off-by: Pablo Neira Ayuso <pablo@eurodev.net>

--------------090500060101030700090503
Content-Type: text/x-patch;
 name="01max.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01max.patch"

Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-05 00:08:04.000000000 +0200
+++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-08-05 00:08:33.000000000 +0200
@@ -1490,7 +1490,7 @@
 					    .cap_required = CAP_NET_ADMIN },
 };
 
-static struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_MAX] = {
+static struct nfnl_callback ctnl_exp_cb[IPCTNL_MSG_EXP_MAX] = {
 	[IPCTNL_MSG_EXP_GET]		= { .call = ctnetlink_get_expect,
 					    .attr_count = CTA_EXPECT_MAX,
 					    .cap_required = CAP_NET_ADMIN },

--------------090500060101030700090503--
