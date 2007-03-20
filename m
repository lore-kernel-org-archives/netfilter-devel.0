From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH]: fix NF_CT_NETLINK dependency
Date: Tue, 20 Mar 2007 15:34:08 +0900 (JST)
Message-ID: <200703200634.l2K6Y90S028953@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Hi, This is for 2.6.21 tree.

nf_conntrack_netlink has the NAT related staffs if NAT is enabled.
Then NF_CT_NETLINK=y requires NF_NAT=y or NF_NAT=n.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 253fce3..54698af 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -275,6 +275,7 @@ config NF_CT_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && NF_CONNTRACK && NETFILTER_NETLINK
 	depends on NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
+	depends on NF_NAT=n || NF_NAT
 	help
 	  This option enables support for a netlink-based userspace interface
 
-- 
1.4.4
