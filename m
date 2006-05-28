From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: mark H.323 helper experimental
Date: Mon, 29 May 2006 01:06:33 +0200 (MEST)
Message-ID: <20060528230633.6318.48770.sendpatchset@localhost.localdomain>
References: <20060528230630.6318.23196.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060528230630.6318.23196.sendpatchset@localhost.localdomain>
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

[NETFILTER]: mark H.323 helper experimental

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b82323a2dfb5b58b9ca3e3687b35bae0ac90b503
tree 742877c3cd6c1d70e944079cc5638e58c8e84443
parent 31ce0405d43d58f359431362ef676735d8ccc7eb
author Patrick McHardy <kaber@trash.net> Sun, 28 May 2006 17:18:34 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 28 May 2006 17:18:34 +0200

 net/ipv4/netfilter/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 3d560de..d407253 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -170,8 +170,8 @@ config IP_NF_PPTP
 	  Documentation/modules.txt.  If unsure, say `N'.
 
 config IP_NF_H323
-	tristate  'H.323 protocol support'
-	depends on IP_NF_CONNTRACK
+	tristate  'H.323 protocol support (EXPERIMENTAL)'
+	depends on IP_NF_CONNTRACK && EXPERIMENTAL
 	help
 	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most
 	  important VoIP protocols, it is widely used by voice hardware and
