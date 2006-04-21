From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/07]: ULOG target is not obsolete
Date: Fri, 21 Apr 2006 03:06:51 +0200 (MEST)
Message-ID: <20060421010651.8466.69434.sendpatchset@localhost.localdomain>
References: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ULOG target is not obsolete

The backend part is obsoleted, but the target itself is still needed.

Signed-off-by: Thomas Voegtle <tv@lio96.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 40c6dcb49ac3f091e30fa105c347cc25776e8b72
tree 2e826e3e3c47a7c5ba0fc5d070a05b090bc30a02
parent bc79a39fcc0cb09ed73ba0052cb87c2893f4f65f
author Thomas Voegtle <tv@lio96.de> Fri, 21 Apr 2006 01:19:15 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 01:19:15 +0200

 net/ipv4/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index c60fd5c..3d560de 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -345,7 +345,7 @@ config IP_NF_TARGET_LOG
 	  To compile it as a module, choose M here.  If unsure, say N.
 
 config IP_NF_TARGET_ULOG
-	tristate "ULOG target support (OBSOLETE)"
+	tristate "ULOG target support"
 	depends on IP_NF_IPTABLES
 	---help---
 
