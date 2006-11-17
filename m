From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/08]: Kconfig: fix xt_physdev dependencies
Date: Fri, 17 Nov 2006 06:35:49 +0100 (MET)
Message-ID: <20061117053549.10231.57261.sendpatchset@localhost.localdomain>
References: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20061117053540.10231.92379.sendpatchset@localhost.localdomain>
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
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit ca6adddd237afa4910bab5e9e8ba0685f37c2bfe
tree 45c88fae3ec75a90ffac423906e662bdb36e8251
parent cf08e74a590c945d3c0b95886ea3fad8ff73793d
author Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:25:31 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:25:31 +0100

 net/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index a9894dd..96af461 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -342,7 +342,7 @@ config NETFILTER_XT_MATCH_MULTIPORT
 
 config NETFILTER_XT_MATCH_PHYSDEV
 	tristate '"physdev" match support'
-	depends on NETFILTER_XTABLES && BRIDGE_NETFILTER
+	depends on NETFILTER_XTABLES && BRIDGE && BRIDGE_NETFILTER
 	help
 	  Physdev packet matching matches against the physical bridge ports
 	  the IP packet arrived on or will leave by.
