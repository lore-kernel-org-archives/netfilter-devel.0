From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 1/5] [CTNETLINK] Fix expectation mask dumping
Date: Tue, 28 Feb 2006 02:32:23 +0900 (JST)
Message-ID: <200602271732.k1RHWOaT006410@toshiba.co.jp>
References: <44025F8A.6070302@netfilter.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Feb_28_02_32_23_2006_915)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <44025F8A.6070302@netfilter.org>
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

----Next_Part(Tue_Feb_28_02_32_23_2006_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 27 Feb 2006 03:10:18 +0100

> This patch introduces the function ctnetlink_exp_dump_mask, that
> correctly dumps the expectation mask. Such function uses the l3num value
> from the expectation tuple that is a valid layer 3 protocol number.
> 
> The value of the l3num mask isn't dumped since it is meaningless from
> the userspace side.

At first, this patch seems to be for net-2.6.17. This fix isn't really
necessary to 2.6.16 ?

>  static inline int
> +ctnetlink_exp_dump_mask(struct sk_buff *skb, 
> +			const struct nf_conntrack_tuple *tuple,
> +			const struct nf_conntrack_tuple *mask)
> +{
> +	int ret;
> +	struct nf_conntrack_l3proto *l3proto;
> +	struct nf_conntrack_protocol *proto;
> +
> +	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
> +	ret = ctnetlink_dump_tuples_ip(skb, mask, l3proto);
> +	nf_ct_l3proto_put(l3proto);
> +
> +	if (unlikely(ret < 0))
> +		return ret;
> +
> +	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
> +	ret = ctnetlink_dump_tuples_proto(skb, mask, proto);
> +	nf_ct_proto_put(proto);
> +
> +	return ret;
> +}

I've noticed missing nesting with CTA_EXP_MASK in this function. Please
apply the attached patch on top of your patch. I tested it with ftp helper,
ftp server, and telnet with IPv6. And I saw that kernel filled expectation
mask in CTA_EXP_MASK area.

-- Yasuyuki Kozakai

----Next_Part(Tue_Feb_28_02_32_23_2006_915)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nfctnl-exp-mask.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index e7a75fb..abf5695 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1169,19 +1169,27 @@ ctnetlink_exp_dump_mask(struct sk_buff *
 	int ret;
 	struct nf_conntrack_l3proto *l3proto;
 	struct nf_conntrack_protocol *proto;
+	struct nfattr *nest_parms = NFA_NEST(skb, CTA_EXPECT_MASK);
 
 	l3proto = nf_ct_l3proto_find_get(tuple->src.l3num);
 	ret = ctnetlink_dump_tuples_ip(skb, mask, l3proto);
 	nf_ct_l3proto_put(l3proto);
 
 	if (unlikely(ret < 0))
-		return ret;
+		goto nfattr_failure;
 
 	proto = nf_ct_proto_find_get(tuple->src.l3num, tuple->dst.protonum);
 	ret = ctnetlink_dump_tuples_proto(skb, mask, proto);
 	nf_ct_proto_put(proto);
+	if (unlikely(ret < 0))
+		goto nfattr_failure;
 
-	return ret;
+	NFA_NEST_END(skb, nest_parms);
+
+	return 0;
+
+nfattr_failure:
+	return -1;
 }
 
 static inline int

----Next_Part(Tue_Feb_28_02_32_23_2006_915)----
