From: Pablo Neira <pablo@netfilter.org>
Subject: [PATCH 4/7] add missing module_alias_subsys
Date: Fri, 04 Nov 2005 19:00:33 +0100
Message-ID: <436BA1C1.8070806@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030806000802040607060608"
Cc: Harald Welte <laforge@netfilter.org>
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
--------------030806000802040607060608
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Add missing module alias. This is a must to load ctnetlink on demand.
For example, the conntrack tool will fail if the module isn't loaded.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------030806000802040607060608
Content-Type: text/plain;
 name="07-alias.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="07-alias.patch"

Add missing module alias. This is a must to load ctnetlink on demand. For 
example, the conntrack tool will fail if the module isn't loaded.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 17:55:24.000000000 +0100
+++ net-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-04 18:31:04.000000000 +0100
@@ -1538,6 +1538,8 @@ static struct nfnetlink_subsystem ctnl_e
 	.cb				= ctnl_exp_cb,
 };
 
+MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_CTNETLINK);
+
 static int __init ctnetlink_init(void)
 {
 	int ret;

--------------030806000802040607060608--
