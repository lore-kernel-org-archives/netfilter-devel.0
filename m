From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/06]: Demote xt_sctp to EXPERIMENTAL
Date: Tue, 25 Jul 2006 05:27:01 +0200 (MEST)
Message-ID: <20060725032701.25063.97147.sendpatchset@localhost.localdomain>
References: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Demote xt_sctp to EXPERIMENTAL

After the recent problems with all the SCTP stuff it seems reasonable
to mark this as experimental.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 330dabc0d6886c4c23e94cfc66bf9281c2796629
tree d2ebe43ffc642107c62318f54d882f841acc6902
parent 6484ca45f549ab966c21d2e1da36f3d0d14a20a2
author Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 05:05:06 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 25 Jul 2006 05:05:06 +0200

 net/netfilter/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 42a178a..a9894dd 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -386,8 +386,8 @@ config NETFILTER_XT_MATCH_REALM
 	  <file:Documentation/modules.txt>.  If unsure, say `N'.
 
 config NETFILTER_XT_MATCH_SCTP
-	tristate  '"sctp" protocol match support'
-	depends on NETFILTER_XTABLES
+	tristate  '"sctp" protocol match support (EXPERIMENTAL)'
+	depends on NETFILTER_XTABLES && EXPERIMENTAL
 	help
 	  With this option enabled, you will be able to use the 
 	  `sctp' match in order to match on SCTP source/destination ports
