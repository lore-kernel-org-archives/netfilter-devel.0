From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/05]: Kconfig: fix xt_physdev dependencies
Date: Mon,  2 Oct 2006 17:46:05 +0200 (MEST)
Message-ID: <20061002154717.13121.35191.sendpatchset@localhost.localdomain>
References: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Kconfig: fix xt_physdev dependencies

xt_physdev depends on bridge netfilter, which is a boolean, but can still
be built modular because of special handling in the bridge makefile. Add
a dependency on BRIDGE to prevent XT_MATCH_PHYSDEV=y, BRIDGE=m.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2f253e95a172eaec7de29e3f0951d3a20d3f904c
tree fa38b574cf9b05743058ef38a3fa38bf28a1a399
parent 6656e3c4c8e0c80f2d2bfece574876d269f64861
author Patrick McHardy <kaber@trash.net> Mon, 02 Oct 2006 17:39:35 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 02 Oct 2006 17:39:35 +0200

 net/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0a28d2c..ce94732 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -365,7 +365,7 @@ config NETFILTER_XT_MATCH_MULTIPORT
 
 config NETFILTER_XT_MATCH_PHYSDEV
 	tristate '"physdev" match support'
-	depends on NETFILTER_XTABLES && BRIDGE_NETFILTER
+	depends on NETFILTER_XTABLES && BRIDGE && BRIDGE_NETFILTER
 	help
 	  Physdev packet matching matches against the physical bridge ports
 	  the IP packet arrived on or will leave by.
