From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 04/06]: xt_CONNSECMARK: fix Kconfig dependencies
Date: Thu, 12 Oct 2006 11:54:24 +0200 (MEST)
Message-ID: <20061012095552.11462.86418.sendpatchset@localhost.localdomain>
References: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
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

---
commit 0ab5046ab83e4f0e88c40922701b2bc365f6aa09
tree 4add4ff88904c63e7ff20872f2faff015bbcbc28
parent 889d786a9211434b29e402a501d01a590b072d31
author Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 10:39:47 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 10:39:47 +0200

 net/netfilter/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ce94732..f619c65 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -209,7 +209,9 @@ config NETFILTER_XT_TARGET_SECMARK
 
 config NETFILTER_XT_TARGET_CONNSECMARK
 	tristate '"CONNSECMARK" target support'
-	depends on NETFILTER_XTABLES && (NF_CONNTRACK_SECMARK || IP_NF_CONNTRACK_SECMARK)
+	depends on NETFILTER_XTABLES && \
+		   ((NF_CONNTRACK && NF_CONNTRACK_SECMARK) || \
+		    (IP_NF_CONNTRACK && IP_NF_CONNTRACK_SECMARK))
 	help
 	  The CONNSECMARK target copies security markings from packets
 	  to connections, and restores security markings from connections
