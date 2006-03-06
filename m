From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.6.16]: Fix wrong option spelling in Makefile for
	CONFIG_BRIDGE_EBT_ULOG
Date: Mon, 06 Mar 2006 22:12:31 +0100
Message-ID: <440CA5BF.4010701@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080707090500000001000404"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------080707090500000001000404
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

this patch fixes an incorrectly named option in the bridge-netfilter
Makefile. Please apply to 2.6.16.


--------------080707090500000001000404
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix wrong option spelling in Makefile for CONFIG_BRIDGE_EBT_ULOG

Signed-off-by: Gregor Maier <gregor@net.in.tum.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 35af439134b790b63c1708c3f2c2f54b88e3018f
tree d4b211ea63c234edc3a23fdeee70ae7d30ce29e1
parent c499ec24c31edf270e777a868ffd0daddcfe7ebd
author Gregor Maier <gregor@net.in.tum.de> Sat, 04 Mar 2006 09:58:39 +0100
committer Patrick McHardy <kaber@trash.net> Sat, 04 Mar 2006 09:58:39 +0100

 net/bridge/netfilter/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/bridge/netfilter/Makefile b/net/bridge/netfilter/Makefile
index 8bf6d9f..905087e 100644
--- a/net/bridge/netfilter/Makefile
+++ b/net/bridge/netfilter/Makefile
@@ -29,4 +29,4 @@ obj-$(CONFIG_BRIDGE_EBT_SNAT) += ebt_sna
 
 # watchers
 obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_log.o
-obj-$(CONFIG_BRIDGE_EBT_LOG) += ebt_ulog.o
+obj-$(CONFIG_BRIDGE_EBT_ULOG) += ebt_ulog.o

--------------080707090500000001000404--
