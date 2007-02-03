From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: nf_conntrack_h323: fix compile error with
	CONFIG_IPV6=m, CONFIG_NF_CONNTRACK_H323=y
Date: Sat,  3 Feb 2007 02:46:25 +0100 (MET)
Message-ID: <20070203014623.892.82650.sendpatchset@localhost.localdomain>
References: <20070203014620.892.62689.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070203014620.892.62689.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_h323: fix compile error with CONFIG_IPV6=m, CONFIG_NF_CONNTRACK_H323=y

Fix this by letting NF_CONNTRACK_H323 depend on (IPV6 || IPV6=n).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
commit c204236dae38644133e5713d59d81e3e0abac384
tree eda435df6adf784f5778c988e4cffe5ce328673e
parent de4fee1de939b8a5422020822195dea4b25e142b
author Adrian Bunk <bunk@stusta.de> Sat, 03 Feb 2007 02:28:44 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 03 Feb 2007 02:28:44 +0100

 net/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 2a2bcb3..80107d4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -165,7 +165,7 @@ config NF_CONNTRACK_FTP
 
 config NF_CONNTRACK_H323
 	tristate "H.323 protocol support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NF_CONNTRACK
+	depends on EXPERIMENTAL && NF_CONNTRACK && (IPV6 || IPV6=n)
 	help
 	  H.323 is a VoIP signalling protocol from ITU-T. As one of the most
 	  important VoIP protocols, it is widely used by voice hardware and
