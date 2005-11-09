From: Pablo Neira <pablo@eurodev.net>
Subject: Re: again: conntrack & 2.6.14-git11
Date: Wed, 09 Nov 2005 14:38:37 +0100
Message-ID: <4371FBDD.4020302@eurodev.net>
References: <4371D660.4060003@fliegl.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030604070004010300060800"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <4371D660.4060003@fliegl.de>
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
--------------030604070004010300060800
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Deti Fliegl wrote:
> as far as I've seen all fixes for nf_netlink/conntrack are contained in
> 2.6.14-git11. I tried calling conntrack within an endless loop while my
> stresstest was running. After app. 30 minutes the kernel crashed. Did I
> miss an important patch from this list? How can I help?

I don't see the patch that is supposed to fix the problem in that git
snapshot. Please, make sure that the patch attached is applied to your
kernel tree.

-- 
Pablo

--------------030604070004010300060800
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

--------------030604070004010300060800--
