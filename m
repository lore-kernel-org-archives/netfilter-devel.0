From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH] x_tables: fix dependencies of conntrack related modules
Date: Sat, 04 Feb 2006 00:09:03 +0900 (JST)
Message-ID: <200602031509.k13F93Wi004799@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline; filename="fix-kconfig.patch"
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

[NETFILTER] x_tables: fix dependencies of conntrack related modules

NF_CONNTRACK_MARK is bool and depends on NF_CONNTRACK which is tristate.
If a variable depends on NF_CONNTRACK_MARK and doesn't take care about
NF_CONNTRACK, it can be y even if NF_CONNTRACK isn't y.
NF_CT_ACCT have same issue, too.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 826b113da5df52f95cba9945dce4e91614d56552
tree cd571cee641669adabd949022340a97a10001b3c
parent b4103333d7904310d34de18d85e51e3d74f00a3b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 02 Feb 2006 22:02:59 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 02 Feb 2006 22:02:59 +0900

 net/netfilter/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 99c0a0f..562875d 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -128,7 +128,7 @@ config NETFILTER_XT_TARGET_CONNMARK
 	tristate  '"CONNMARK" target support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
-	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK_IPV4)
+	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK)
 	help
 	  This option adds a `CONNMARK' target, which allows one to manipulate
 	  the connection mark value.  Similar to the MARK target, but
@@ -189,7 +189,7 @@ config NETFILTER_XT_MATCH_COMMENT
 config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NETFILTER_XTABLES
-	depends on (IP_NF_CONNTRACK && IP_NF_CT_ACCT) || NF_CT_ACCT
+	depends on (IP_NF_CONNTRACK && IP_NF_CT_ACCT) || (NF_CT_ACCT && NF_CONNTRACK)
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
@@ -200,7 +200,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
 config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
 	depends on NETFILTER_XTABLES
-	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || NF_CONNTRACK_MARK
+	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK)
 	help
 	  This option adds a `connmark' match, which allows you to match the
 	  connection mark value previously set for the session by `CONNMARK'. 
