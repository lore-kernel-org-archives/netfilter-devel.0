From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/06]: nf_nat: fix NF_NAT dependency
Date: Tue, 12 Dec 2006 09:06:21 +0100 (MET)
Message-ID: <20061212080944.4788.90325.sendpatchset@localhost.localdomain>
References: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061212080941.4788.16630.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat: fix NF_NAT dependency

NF_NAT depends on NF_CONNTRACK_IPV4, not NF_CONNTRACK.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit bc5ca5410c8fa8930ea4cf55ae034e163cb02b76
tree d7ab6180d2a687ff2edd5478d9bc1f276262321f
parent 61ca98ed893d16bccb077bb88496d1e24b8604b2
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 12 Dec 2006 08:50:38 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 12 Dec 2006 08:50:38 +0100

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
