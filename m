From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/3]: nf_nat: fix NF_NAT dependency
Date: Fri, 08 Dec 2006 19:52:42 +0900 (JST)
Message-ID: <200612081052.kB8Aqh0f003741@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
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


NF_NAT depends on NF_CONNTRACK_IPV4, not NF_CONNTRACK.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
---
 net/ipv4/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 363df99..f6026d4 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -401,7 +401,7 @@ config IP_NF_NAT
 # NAT + specific targets: nf_conntrack
 config NF_NAT
 	tristate "Full NAT"
-	depends on IP_NF_IPTABLES && NF_CONNTRACK
+	depends on IP_NF_IPTABLES && NF_CONNTRACK_IPV4
 	help
 	  The Full NAT option allows masquerading, port forwarding and other
 	  forms of full Network Address Port Translation.  It is controlled by
-- 
1.4.4
