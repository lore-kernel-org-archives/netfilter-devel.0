From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Mon, 14 Nov 2005 13:27:42 +0100
Message-ID: <437882BE.6080705@eurodev.net>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050709090304080402090907"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
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
--------------050709090304080402090907
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Krzysztof Oledzki wrote:
> EIP is at sub_preempt_count+0x35/0x40
> 
> AFAIK there were some small fixes that went into 2.6.15-rc1 which were
> supposed to fix such problems with conntrack -L. Shuldn't we send them
> to -stable to make 2.6.14.x also usable?

I think so, at the least Yasuyuki's:
[NETFILTER] refcount leak of proto when ctnetlink dumping tuple

That fixes the problem that you're reporting.

-- 
Pablo

--------------050709090304080402090907
Content-Type: text/plain;
 name="02-ctnl-refcnt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02-ctnl-refcnt.patch"

[NETFILTER] refcount leak of proto when ctnetlink dumping tuple

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 3a4486b6419a1f25324bb4280d51f5c77b1117f7
tree 88b1831d06e21417baca01d1632131d96e3be611
parent 61a002f080c6473da94f28314502ff0f15fe3625
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 04 Nov 2005 14:35:27 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Fri, 04 Nov 2005 14:35:27 +0900

 net/ipv4/netfilter/ip_conntrack_netlink.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -58,14 +58,17 @@ ctnetlink_dump_tuples_proto(struct sk_bu
 			    const struct ip_conntrack_tuple *tuple)
 {
 	struct ip_conntrack_protocol *proto;
+	int ret = 0;
 
 	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
 	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
-	if (proto && proto->tuple_to_nfattr)
-		return proto->tuple_to_nfattr(skb, tuple);
+	if (likely(proto && proto->tuple_to_nfattr)) {
+		ret = proto->tuple_to_nfattr(skb, tuple);
+		ip_conntrack_proto_put(proto);
+	}
 
-	return 0;
+	return ret;
 
 nfattr_failure:
 	return -1;

--------------050709090304080402090907--
