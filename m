From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/1] missing dependency definition for ip_conntrack mark
Date: Thu, 01 Sep 2005 12:53:50 +0900 (JST)
Message-ID: <200509010353.j813roX3020876@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_12_53_50_2005_222)--"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

----Next_Part(Thu_Sep__1_12_53_50_2005_222)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi,

Connection mark tracking support is one of the feature in connection tracking,
so IP_NF_CONNTRACK_MARK depends on IP_NF_CONNTRACK.

This patch can be applied to Linus tree.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Thu_Sep__1_12_53_50_2005_222)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-markdep.patch"

[NETFILTER] missing dependency definition for ip_conntrack mark

Connection mark tracking support is one of the feature in connection tracking,
so IP_NF_CONNTRACK_MARK depends on IP_NF_CONNTRACK.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit fb12078da0631bcadfb36766bdac675adb127e8e
tree 92fedcabdafa6a59986c916d77a63dab0c727486
parent 59dd7a2fd41a1f0713162164c0a4a9017b73508d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:14:17 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:14:17 +0900

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

----Next_Part(Thu_Sep__1_12_53_50_2005_222)----
