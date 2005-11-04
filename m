From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 3/3] missing '_bh' in ctnetlink
Date: Sat, 05 Nov 2005 01:12:48 +0900 (JST)
Message-ID: <200511041612.jA4GCn9M001142@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Sat_Nov__5_01_12_48_2005_713)--"
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

----Next_Part(Sat_Nov__5_01_12_48_2005_713)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>


----Next_Part(Sat_Nov__5_01_12_48_2005_713)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="03-ctnl-bh.patch"

[NETFILTER] missing '_bh' in ctnetlink

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit eedbb4e381646931338a0463ab7f606aba025633
tree 7b528caa3d68cf4dbf97bdd467acd5c394cfda70
parent 3a4486b6419a1f25324bb4280d51f5c77b1117f7
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 04 Nov 2005 14:35:29 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 04 Nov 2005 14:35:29 +0900

 net/ipv4/netfilter/ip_conntrack_netlink.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -1395,7 +1395,7 @@ ctnetlink_del_expect(struct sock *ctnl, 
 				ip_conntrack_expect_put(exp);
 			}
 		}
-		write_unlock(&ip_conntrack_lock);
+		write_unlock_bh(&ip_conntrack_lock);
 	} else {
 		/* This basically means we have to flush everything*/
 		write_lock_bh(&ip_conntrack_lock);

----Next_Part(Sat_Nov__5_01_12_48_2005_713)----
