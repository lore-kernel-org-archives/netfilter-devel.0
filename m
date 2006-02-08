From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Fix expectation mask dumping, take #2
Date: Wed, 08 Feb 2006 20:26:31 +0900 (JST)
Message-ID: <200602081126.k18BQW0v007329@toshiba.co.jp>
References: <200602011335.k11DZHwj018072@toshiba.co.jp>
	<43E15615.2070508@netfilter.org> <43E6904E.9020306@netfilter.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Wed_Feb__8_20_26_31_2006_026)--"
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <43E6904E.9020306@netfilter.org>
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

----Next_Part(Wed_Feb__8_20_26_31_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit


Hi, Pablo,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 06 Feb 2006 00:54:54 +0100

> Description:
> 
> This patch introduces the function ctnetlink_exp_dump_mask, that
> correctly dumps the expectation mask. Such function uses the l3num value
> from the expectation tuple that is a valid layer 3 protocol number.
> 
> Besides, this modification introduces the attribute CTA_IP_L3NUM.
> Although the layer 3 protocol information is sent in the nfnetlink
> header, if the message contains information about an expectation, it
> will contain information about the master conntrack (just one of the
> tuples), the expectation tuple and the expectation mask. In this case,
> the value of l3num in the expectation mask is not the same that is set
> in the nfnetlink message. That is why we need another field that contain
> the value of l3num.
> 
> Now libnetfilter_conntrack can use the CTA_IP_L3NUM attribute, but if
> this attribute is not present in the message, it can use the information
> available in the nfnetlink header message.

Thanks for changing size of CTA_IP_L3NUM field. But it seems to have endian
problem. This patch can save your time ?

Other parts are fine to me.

Regards,

-- Yasuyuki Kozakai

----Next_Part(Wed_Feb__8_20_26_31_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="nfctnetlink-8bits-l3num.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index ee814e1..150174f 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -81,8 +81,9 @@ ctnetlink_dump_tuples_ip(struct sk_buff 
 {
 	int ret = 0;
 	struct nfattr *nest_parms = NFA_NEST(skb, CTA_TUPLE_IP);
+	u_int8_t l3num = (u_int8_t)tuple->src.l3num;
 
-	NFA_PUT(skb, CTA_IP_L3NUM, sizeof(u_int8_t), &tuple->src.l3num);
+	NFA_PUT(skb, CTA_IP_L3NUM, sizeof(u_int8_t), &l3num);
 
 	if (likely(l3proto->tuple_to_nfattr))
 		ret = l3proto->tuple_to_nfattr(skb, tuple);

----Next_Part(Wed_Feb__8_20_26_31_2006_026)----
