From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 06/12]: H.323 helper: make get_h245_addr() static
Date: Thu,  6 Apr 2006 12:05:01 +0200 (MEST)
Message-ID: <20060406100501.17409.55970.sendpatchset@localhost.localdomain>
References: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060406100452.17409.37120.sendpatchset@localhost.localdomain>
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

[NETFILTER]: H.323 helper: make get_h245_addr() static

Signed-off-by: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit a429b7ed024240e1334b78447e208f71959add62
tree d63e6e4658079356856f7b4bfd6a38529e39ac8e
parent 3c1284349cc00613a738dbd582e6096236c4a44e
author Jing Min Zhao <zhaojingmin@users.sourceforge.net> Thu, 06 Apr 2006 11:42:04 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 06 Apr 2006 11:42:04 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323.c b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
index 83140d2..11c652f 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323.c
@@ -220,8 +220,8 @@ static int get_tpkt_data(struct sk_buff 
 }
 
 /****************************************************************************/
-int get_h245_addr(unsigned char *data, H245_TransportAddress * addr,
-		  u_int32_t * ip, u_int16_t * port)
+static int get_h245_addr(unsigned char *data, H245_TransportAddress * addr,
+			 u_int32_t * ip, u_int16_t * port)
 {
 	unsigned char *p;
 
