From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/3] packet counter of conntrack is 32bits
Date: Sat, 05 Nov 2005 01:12:11 +0900 (JST)
Message-ID: <200511041612.jA4GCCaR003378@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Nov__5_01_12_11_2005_488)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org
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

----Next_Part(Sat_Nov__5_01_12_11_2005_488)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


The packet counter variable of conntrack was changed to 32bits from
64bits. This follows that change.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sat_Nov__5_01_12_11_2005_488)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-ctnl-32bits.patch"

[NETFILTER] packet counter of conntrack is 32bits

The packet counter variable of conntrack was changed to 32bits from
64bits. This follows that change.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 61a002f080c6473da94f28314502ff0f15fe3625
tree 1b7f2dc43c9e8f976a1a8e320682e6bd561d783b
parent 928f936ad8e099bd2a84d6e875e1a8c59f55bf7d
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 04 Nov 2005 14:35:26 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 04 Nov 2005 14:35:26 +0900

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -175,7 +175,7 @@ ctnetlink_dump_counters(struct sk_buff *
 {
 	enum ctattr_type type = dir ? CTA_COUNTERS_REPLY: CTA_COUNTERS_ORIG;
 	struct nfattr *nest_count = NFA_NEST(skb, type);
-	u_int64_t tmp;
+	u_int32_t tmp;
 
 	tmp = htonl(ct->counters[dir].packets);
 	NFA_PUT(skb, CTA_COUNTERS32_PACKETS, sizeof(u_int32_t), &tmp);

----Next_Part(Sat_Nov__5_01_12_11_2005_488)----
