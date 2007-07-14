From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 16/43] Add support for IPv6 NOTRACK
Date: Sun, 15 Jul 2007 02:24:48 +0900 (JST)
Message-ID: <200707141724.l6EHOnaI026885@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


---
 extensions/libxt_NOTRACK.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index 2276eb6..220a9b8 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -56,7 +56,23 @@ struct xtables_target notrack =
 	.extra_opts	= opts,
 };
 
+static
+struct xtables_target notrack6 =
+{
+	.family		= AF_INET6,
+	.name		= "NOTRACK",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(0),
+	.userspacesize	= XT_ALIGN(0),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.extra_opts	= opts,
+};
+
 void _init(void)
 {
 	xtables_register_target(&notrack);
+	xtables_register_target(&notrack6);
 }
-- 
1.5.2.2
