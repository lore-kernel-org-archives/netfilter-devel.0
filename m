From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/2]: Fix incorrect dependency for IP6_NF_TARGET_NFQUEUE
Date: Mon, 19 Dec 2005 11:21:53 +0100
Message-ID: <43A689C1.6010700@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: Fix incorrect dependency for IP6_NF_TARGET_NFQUEUE

IP6_NF_TARGET_NFQUEUE depends on IP6_NF_IPTABLES, not IP_NF_IPTABLES.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9d52bf90aed9ce0d0366b6853cd1beb7f1217d75
tree 0c2eb630cb7ed1ef8af66f54e2645cb2ae42bb2a
parent 87704c86b3406255a2b68b1d1a68ff72baa6177e
author Patrick McHardy <kaber@trash.net> Mon, 19 Dec 2005 11:19:00 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 19 Dec 2005 11:19:00 +0100

 net/ipv6/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv6/netfilter/Kconfig b/net/ipv6/netfilter/Kconfig
index 060d612..04912f9 100644
--- a/net/ipv6/netfilter/Kconfig
+++ b/net/ipv6/netfilter/Kconfig
@@ -211,7 +211,7 @@ config IP6_NF_TARGET_REJECT
 
 config IP6_NF_TARGET_NFQUEUE
 	tristate "NFQUEUE Target Support"
-	depends on IP_NF_IPTABLES
+	depends on IP6_NF_IPTABLES
 	help
 	  This Target replaced the old obsolete QUEUE target.
 
