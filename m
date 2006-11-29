From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 33/33]: remove the reference to ipchains from Kconfig
Date: Wed, 29 Nov 2006 03:09:35 +0100 (MET)
Message-ID: <20061129020934.21082.76288.sendpatchset@localhost.localdomain>
References: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061129020843.21082.69507.sendpatchset@localhost.localdomain>
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

[NETFILTER]: remove the reference to ipchains from Kconfig

It is time to move on :-)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0fefe1556475985067ea1280789bc8f7d6584938
tree f8bec5743ec9a6820f9fa5153940b74eebd54f42
parent 8c6e0e883d2aa1ae8d07fb774cf8760f7f127ab8
author Pablo Neira Ayuso <pablo@netfilter.org> Wed, 29 Nov 2006 02:32:54 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 29 Nov 2006 02:32:54 +0100

 net/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/Kconfig b/net/Kconfig
index 867f950..7dfc949 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -75,7 +75,7 @@ config NETWORK_SECMARK
 	  If you are unsure how to answer this question, answer N.
 
 menuconfig NETFILTER
-	bool "Network packet filtering (replaces ipchains)"
+	bool "Network packet filtering framework (Netfilter)"
 	---help---
 	  Netfilter is a framework for filtering and mangling network packets
 	  that pass through your Linux box.
