From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/20]: nf_conntrack: fix NF_CONNTRACK_PROC_COMPAT
	dependency
Date: Sat,  2 Dec 2006 15:49:39 +0100 (MET)
Message-ID: <20061202145244.1381.88186.sendpatchset@localhost.localdomain>
References: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack: fix NF_CONNTRACK_PROC_COMPAT dependency

NF_CONNTRACK_PROC_COMPAT depends on NF_CONNTRACK_IPV4, not NF_CONNTRACK.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 66d2cd318d32a8b3a876714f104477ba9aa6b87a
tree c9157c066030213ea7929456f7047fb2c35def9a
parent 0166e0457531e1e5260463477c30dd16b81ab606
author Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:53 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 02 Dec 2006 15:33:53 +0100

 net/ipv4/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index bc298a3..06fec80 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -21,7 +21,7 @@ config NF_CONNTRACK_IPV4
 
 config NF_CONNTRACK_PROC_COMPAT
 	bool "proc/sysctl compatibility with old connection tracking"
-	depends on NF_CONNTRACK
+	depends on NF_CONNTRACK_IPV4
 	default y
 	help
 	  This option enables /proc and sysctl compatibility with the old
