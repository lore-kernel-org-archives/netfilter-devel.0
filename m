From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/06]: statistic match: add missing Kconfig help text
Date: Mon, 26 Jun 2006 17:43:15 +0200 (MEST)
Message-ID: <20060626154315.11682.84446.sendpatchset@localhost.localdomain>
References: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060626154307.11682.28562.sendpatchset@localhost.localdomain>
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

[NETFILTER]: statistic match: add missing Kconfig help text

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 761a7b483e46977e51f703ec5ff5d5861f328eb8
tree 18b8e54efc62a8c6d03ae8fba782b1b0c5d1f18f
parent 5e9d63f46ae2805245fcc9ec58f844d1347bd469
author Patrick McHardy <kaber@trash.net> Mon, 26 Jun 2006 17:17:25 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 26 Jun 2006 17:17:25 +0200

 net/netfilter/Kconfig |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index b1622b7..42a178a 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -411,7 +411,10 @@ config NETFILTER_XT_MATCH_STATISTIC
 	tristate '"statistic" match support'
 	depends on NETFILTER_XTABLES
 	help
-	  statistic module
+	  This option adds a `statistic' match, which allows you to match
+	  on packets periodically or randomly with a given percentage.
+
+	  To compile it as a module, choose M here.  If unsure, say N.
 
 config NETFILTER_XT_MATCH_STRING
 	tristate  '"string" match support'
