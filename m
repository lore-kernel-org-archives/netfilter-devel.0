From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/06]: Fix INET=n linking error
Date: Tue, 12 Dec 2006 09:06:19 +0100 (MET)
Message-ID: <20061212080943.4788.38832.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix INET=n linking error

Building with INET=n results in

WARNING: "ip_route_output_key" [net/netfilter/nf_conntrack_h323.ko] undefined!

The entire code in net/netfilter is only used for IPv4/IPv6 currently, so
let it depend on INET.

Noticed by Toralf Förster <toralf.foerster@gmx.de>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 61ca98ed893d16bccb077bb88496d1e24b8604b2
tree 3adad9d96f832d98af105010eb3aaed0c9a83338
parent e63abb7bc148c5410f48496f8c339956947a1afb
author Patrick McHardy <kaber@trash.net> Tue, 12 Dec 2006 08:50:36 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 12 Dec 2006 08:50:36 +0100

 net/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3a66878..1b853c3 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1,5 +1,5 @@
 menu "Core Netfilter Configuration"
-	depends on NET && NETFILTER
+	depends on NET && INET && NETFILTER
 
 config NETFILTER_NETLINK
        tristate "Netfilter netlink interface"
