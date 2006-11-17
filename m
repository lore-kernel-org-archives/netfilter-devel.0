From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 08/08]: xt_CONNSECMARK: fix Kconfig dependencies
Date: Fri, 17 Nov 2006 06:35:50 +0100 (MET)
Message-ID: <20061117053550.10231.53961.sendpatchset@localhost.localdomain>
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

[NETFILTER]: xt_CONNSECMARK: fix Kconfig dependencies

CONNSECMARK needs conntrack, add missing dependency to fix linking error
with CONNSECMARK=y and CONNTRACK=m.

Reported by Toralf Förster <toralf.foerster@gmx.de>.

Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
commit 7f013c33ba2b02614c856d715b65d858bc1ec47f
tree 7ba757cfe1e953e47726bdcf956c16d07d94aa6e
parent ca6adddd237afa4910bab5e9e8ba0685f37c2bfe
author Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:25:54 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 17 Nov 2006 06:25:54 +0100

 net/netfilter/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 96af461..e1c27b7 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -197,7 +197,9 @@ config NETFILTER_XT_TARGET_SECMARK
 
 config NETFILTER_XT_TARGET_CONNSECMARK
 	tristate '"CONNSECMARK" target support'
-	depends on NETFILTER_XTABLES && (NF_CONNTRACK_SECMARK || IP_NF_CONNTRACK_SECMARK)
+	depends on NETFILTER_XTABLES && \
+		   ((NF_CONNTRACK && NF_CONNTRACK_SECMARK) || \
+		    (IP_NF_CONNTRACK && IP_NF_CONNTRACK_SECMARK))
 	help
 	  The CONNSECMARK target copies security markings from packets
 	  to connections, and restores security markings from connections
