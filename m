From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 14/14]: Fix check whether dst_entry needs to be released
	after NAT
Date: Fri,  3 Feb 2006 14:44:20 +0100 (MET)
Message-ID: <20060203134420.2141.58708.sendpatchset@localhost.localdomain>
References: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060203134358.2141.63426.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix check whether dst_entry needs to be released after NAT

After DNAT the original dst_entry needs to be released if present
so the packet doesn't skip input routing with its new address. The
current check for DNAT in ip_nat_in is reversed and checks for SNAT.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 4cdd7631f09d50e293bae3c28b4b6d1d757598a2
tree 2c026934d638b4229b51c901b140bf595e31a16c
parent ea913eda85a9b7bf0247db91213a88b1ca2d12d8
author Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 13:35:47 +0100
committer Patrick McHardy <kaber@trash.net> Fri, 03 Feb 2006 13:35:47 +0100

 net/ipv4/netfilter/ip_nat_standalone.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ip_nat_standalone.c b/net/ipv4/netfilter/ip_nat_standalone.c
index ad438fb..92c5499 100644
--- a/net/ipv4/netfilter/ip_nat_standalone.c
+++ b/net/ipv4/netfilter/ip_nat_standalone.c
@@ -209,8 +209,8 @@ ip_nat_in(unsigned int hooknum,
 	    && (ct = ip_conntrack_get(*pskb, &ctinfo)) != NULL) {
 		enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
 
-		if (ct->tuplehash[dir].tuple.src.ip !=
-		    ct->tuplehash[!dir].tuple.dst.ip) {
+		if (ct->tuplehash[dir].tuple.dst.ip !=
+		    ct->tuplehash[!dir].tuple.src.ip) {
 			dst_release((*pskb)->dst);
 			(*pskb)->dst = NULL;
 		}
