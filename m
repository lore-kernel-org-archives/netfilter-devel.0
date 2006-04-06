From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 09/12]: Fix IP_NF_CONNTRACK_NETLINK dependency
Date: Thu,  6 Apr 2006 12:05:05 +0200 (MEST)
Message-ID: <20060406100505.17409.24939.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix IP_NF_CONNTRACK_NETLINK dependency

When NAT is built as a module, ip_conntrack_netlink can not be linked
statically.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c9cb4249431b37ed45e69f20a5faa2735933feeb
tree 7321ed9625f9163b6b8a3dd921510197c89681fe
parent 4c164120eecc4d67e0eb6392bbb9f81351c18387
author Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:35 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:43:35 +0200

 net/ipv4/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 77855cc..c60fd5c 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -69,6 +69,7 @@ config IP_NF_CONNTRACK_NETLINK
 	tristate 'Connection tracking netlink interface (EXPERIMENTAL)'
 	depends on EXPERIMENTAL && IP_NF_CONNTRACK && NETFILTER_NETLINK
 	depends on IP_NF_CONNTRACK!=y || NETFILTER_NETLINK!=m
+	depends on IP_NF_NAT=n || IP_NF_NAT
 	help
 	  This option enables support for a netlink-based userspace interface
 
