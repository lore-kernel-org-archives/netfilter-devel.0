From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/05]: remove masq/NAT from ip6tables Kconfig help
Date: Mon, 30 Oct 2006 19:18:57 +0100 (MET)
Message-ID: <20061030181855.32038.28779.sendpatchset@localhost.localdomain>
References: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061030181853.32038.97693.sendpatchset@localhost.localdomain>
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

[NETFILTER]: remove masq/NAT from ip6tables Kconfig help

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 68c5f8eb167a363d431d3ed02c052a60b3902ab7
tree ba8809081f5c40a80855d4737e78a2fd3d482086
parent c55145450fa6a2632a4f0c8941dd04678e06fb3c
author Peter Bieringer <pb@bieringer.de> Wed, 25 Oct 2006 18:53:40 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 25 Oct 2006 18:53:40 +0200

 net/ipv6/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 4bc4e5b..d7c45a9 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -40,7 +40,7 @@ config IP6_NF_QUEUE
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP6_NF_IPTABLES
-	tristate "IP6 tables support (required for filtering/masq/NAT)"
+	tristate "IP6 tables support (required for filtering)"
 	depends on NETFILTER_XTABLES
 	help
 	  ip6tables is a general, extensible packet identification framework.
