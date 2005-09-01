From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH NF_CONNTRACK 1/10] exclusive option for {ip,nf}_conntrack
Date: Thu, 01 Sep 2005 18:13:53 +0900 (JST)
Message-ID: <200509010913.j819DsgS004695@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Thu_Sep__1_18_13_53_2005_886)--"
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

----Next_Part(Thu_Sep__1_18_13_53_2005_886)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


As a result of discussion on netfilter mailing list, we decided to let user
select to use whether ip_conntrack or nf_conntrack. This makes it easy for
us to do work on compatibility issues between ip_conntrack and
nf_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

----Next_Part(Thu_Sep__1_18_13_53_2005_886)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-exclusive.patch"

[NETFILTER] exclusive option for {ip,nf}_conntrack

As a result of discussion on netfilter mailing list, we decided to let user
select to use whether ip_conntrack or nf_conntrack. This makes it easy for
us to do work on compatibility issues between ip_conntrack and
nf_conntrack.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 17ddaa82dcf7dd18c35fc16b5ad12690cc2c5e36
tree ca6efcb19eb4f022a239d8ab207135b7bf8ff5a8
parent fd181f7707c662f9a8b0dd8a284040b8d3a286d7
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:18:23 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Thu, 01 Sep 2005 03:18:23 +0900

 net/netfilter/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -27,7 +27,7 @@ config NETFILTER_NETLINK_LOG
 
 config NF_CONNTRACK
 	tristate "Layer 3 Independent Connection tracking (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && NET
+	depends on EXPERIMENTAL && NET && IP_NF_CONNTRACK=n
 	default n
 	---help---
 	  Connection tracking keeps a record of what packets have passed

----Next_Part(Thu_Sep__1_18_13_53_2005_886)----
