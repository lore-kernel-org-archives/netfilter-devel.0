From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/07]: nf_nat_h323: call set_h225_addr instead of
	set_h225_addr_hook
Date: Fri, 25 May 2007 00:02:15 +0200 (MEST)
Message-ID: <20070524215843.14308.46250.sendpatchset@localhost.localdomain>
References: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070524215833.14308.60841.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_nat_h323: call set_h225_addr instead of set_h225_addr_hook

They're the same.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit ed22d6f07f4ac4b69b915df2d1798e171b501a47
tree 1accab86c105558c5ac6a9c094ac6bc9aef3288d
parent 9a545fc8e2ac3c8c7bbb7315469d96bb4e7d8748
author Jing Min Zhao <zhaojingmin@vivecode.com> Thu, 24 May 2007 23:50:52 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 24 May 2007 23:50:52 +0200

 net/ipv4/netfilter/nf_nat_h323.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/nf_nat_h323.c b/net/ipv4/netfilter/nf_nat_h323.c
index fcebc96..c5d2a2d 100644
--- a/net/ipv4/netfilter/nf_nat_h323.c
+++ b/net/ipv4/netfilter/nf_nat_h323.c
@@ -455,9 +455,9 @@ static int nat_q931(struct sk_buff **pskb, struct nf_conn *ct,
 		if (idx > 0 &&
 		    get_h225_addr(ct, *data, &taddr[0], &addr, &port) &&
 		    (ntohl(addr.ip) & 0xff000000) == 0x7f000000) {
-			set_h225_addr_hook(pskb, data, 0, &taddr[0],
-					   &ct->tuplehash[!dir].tuple.dst.u3,
-					   info->sig_port[!dir]);
+			set_h225_addr(pskb, data, 0, &taddr[0],
+				      &ct->tuplehash[!dir].tuple.dst.u3,
+				      info->sig_port[!dir]);
 		}
 	} else {
 		nf_conntrack_unexpect_related(exp);
