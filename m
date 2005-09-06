From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 3/8]: Fix CONNMARK Kconfig dependency
Date: Tue, 06 Sep 2005 19:55:35 +0200
Message-ID: <431DD817.3060100@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="03.diff"
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

[NETFILTER]: Fix CONNMARK Kconfig dependency

Connection mark tracking support is one of the feature in connection
tracking, so IP_NF_CONNTRACK_MARK depends on IP_NF_CONNTRACK.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a5abc2029ac642c6d4d13aedfcb75de752aa7f11
tree 0d603c7e8a29c7698ad1e3a9fc1822f438958353
parent b057eac5e17bda8e06a6f3241a837d415a18be4d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sun, 04 Sep 2005 18:03:18 +0200
committer Patrick McHardy <kaber@trash.net> Sun, 04 Sep 2005 18:03:18 +0200

 net/ipv4/netfilter/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -34,6 +34,7 @@ config IP_NF_CT_ACCT
 
 config IP_NF_CONNTRACK_MARK
 	bool  'Connection mark tracking support'
+	depends on IP_NF_CONNTRACK
 	help
 	  This option enables support for connection marks, used by the
 	  `CONNMARK' target and `connmark' match. Similar to the mark value
