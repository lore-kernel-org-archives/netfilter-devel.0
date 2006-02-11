From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH][BRIDGE] Fix build error of br_netfilter with NETFILTER_DEBUG
Date: Sat, 11 Feb 2006 18:48:56 +0900 (JST)
Message-ID: <200602110948.k1B9mvb5003481@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Feb_11_18_48_56_2006_137)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: shemminger@osdl.org
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

----Next_Part(Sat_Feb_11_18_48_56_2006_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Stephen,

I failed to build kernel with CONFIG_NETFILTER_DEBUG and
CONFIG_BRIDGE_NETFILTER. The attached patch is correct fix ?

  LD      net/built-in.o
  GEN     .version
  CHK     include/linux/compile.h
dnsdomainname: Unknown host
  UPD     include/linux/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
net/built-in.o(.text+0xc84c0): In function `br_nf_post_routing':
: undefined reference to `has_bridge_parent'
make: *** [.tmp_vmlinux1] Error 1

Regards,

-- Yasuyuki Kozakai

----Next_Part(Sat_Feb_11_18_48_56_2006_137)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="br_netfilter-debug.patch"

[BRIDGE] Fix build error of br_netfilter with NETFILTER_DEBUG

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 74c1c8359741fca4c7b80bf538efd3ee96d22d4d
tree 3fdfde9adbf7dea2e79d05ab3db3d4fe0be58cbf
parent 25bf368b3d98668c5d5f38e2201d8bca16e52680
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 11 Feb 2006 18:33:10 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 11 Feb 2006 18:33:10 +0900

 net/bridge/br_netfilter.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index b501816..6bb0c7e 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -805,8 +805,8 @@ static unsigned int br_nf_post_routing(u
 print_error:
 	if (skb->dev != NULL) {
 		printk("[%s]", skb->dev->name);
-		if (has_bridge_parent(skb->dev))
-			printk("[%s]", bridge_parent(skb->dev)->name);
+		if (realoutdev)
+			printk("[%s]", realoutdev->name);
 	}
 	printk(" head:%p, raw:%p, data:%p\n", skb->head, skb->mac.raw,
 					      skb->data);

----Next_Part(Sat_Feb_11_18_48_56_2006_137)----
