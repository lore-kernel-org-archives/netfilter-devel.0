From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/05]: x_tables: fix dependencies of conntrack related
	modules
Date: Thu, 16 Feb 2006 00:00:28 +0100 (MET)
Message-ID: <20060215230028.25078.50030.sendpatchset@localhost.localdomain>
References: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060215230026.25078.33875.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: fix dependencies of conntrack related modules

NF_CONNTRACK_MARK is bool and depends on NF_CONNTRACK which is tristate.
If a variable depends on NF_CONNTRACK_MARK and doesn't take care about
NF_CONNTRACK, it can be y even if NF_CONNTRACK isn't y.
NF_CT_ACCT have same issue, too.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1a99739a0044eae74cc17a6ae168bb30b49932d8
tree e307cf1590b62e3f5ee9eb5607fe6e262069c3d6
parent ee68cea2c26b7a8222f9020f54d22c6067011e8b
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Wed, 15 Feb 2006 10:52:02 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 15 Feb 2006 10:52:02 +0100

 net/netfilter/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0e55012..a8e5544 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -126,7 +126,7 @@ config NETFILTER_XT_TARGET_CONNMARK
 	tristate  '"CONNMARK" target support'
 	depends on NETFILTER_XTABLES
 	depends on IP_NF_MANGLE || IP6_NF_MANGLE
-	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK_IPV4)
+	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK)
 	help
 	  This option adds a `CONNMARK' target, which allows one to manipulate
 	  the connection mark value.  Similar to the MARK target, but
@@ -187,7 +187,7 @@ config NETFILTER_XT_MATCH_COMMENT
 config NETFILTER_XT_MATCH_CONNBYTES
 	tristate  '"connbytes" per-connection counter match support'
 	depends on NETFILTER_XTABLES
-	depends on (IP_NF_CONNTRACK && IP_NF_CT_ACCT) || NF_CT_ACCT
+	depends on (IP_NF_CONNTRACK && IP_NF_CT_ACCT) || (NF_CT_ACCT && NF_CONNTRACK)
 	help
 	  This option adds a `connbytes' match, which allows you to match the
 	  number of bytes and/or packets for each direction within a connection.
@@ -198,7 +198,7 @@ config NETFILTER_XT_MATCH_CONNBYTES
 config NETFILTER_XT_MATCH_CONNMARK
 	tristate  '"connmark" connection mark match support'
 	depends on NETFILTER_XTABLES
-	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || NF_CONNTRACK_MARK
+	depends on (IP_NF_CONNTRACK && IP_NF_CONNTRACK_MARK) || (NF_CONNTRACK_MARK && NF_CONNTRACK)
 	help
 	  This option adds a `connmark' match, which allows you to match the
 	  connection mark value previously set for the session by `CONNMARK'. 
