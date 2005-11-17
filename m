From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Thu, 17 Nov 2005 01:36:35 +0100
Message-ID: <437BD093.3010905@eurodev.net>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040101070601070808080106"
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
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
--------------040101070601070808080106
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Krzysztof Oledzki wrote:
> On Mon, 14 Nov 2005, Pablo Neira wrote:
> 
>> Krzysztof Oledzki wrote:
>>
>>> EIP is at sub_preempt_count+0x35/0x40
>>>
>>> AFAIK there were some small fixes that went into 2.6.15-rc1 which were
>>> supposed to fix such problems with conntrack -L. Shuldn't we send them
>>> to -stable to make 2.6.14.x also usable?
>>
>> I think so, at the least Yasuyuki's:
>> [NETFILTER] refcount leak of proto when ctnetlink dumping tuple
>>
>> That fixes the problem that you're reporting.
> 
> What about this one?

I realised that Yasuyuki's patch is incomplete. Could you give a try to
the patch attached. Thanks.

-- 
Pablo

--------------040101070601070808080106
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER] Fix ip_conntrack_proto_find_get badness

The function ip_conntrack_proto_find_get always returns a valid pointer. The 
generic protocol helper is returned when no specific protocol helper is found.
This patch fixes as well a missing putting at dump_protoinfo, when no to_attr
is found.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

diff --git a/net/ipv4/netfilter/ip_conntrack_netlink.c b/net/ipv4/netfilter/ip_conntrack_netlink.c
index f5e5e31..b797ef9 100644
--- a/net/ipv4/netfilter/ip_conntrack_netlink.c
+++ b/net/ipv4/netfilter/ip_conntrack_netlink.c
@@ -59,11 +59,13 @@ ctnetlink_dump_tuples_proto(struct sk_bu
 
 	NFA_PUT(skb, CTA_PROTO_NUM, sizeof(u_int8_t), &tuple->dst.protonum);
 
+	/* If no protocol helper is found, this function will return the
+	 * generic protocol helper, so proto won't *ever* be NULL */
 	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
-	if (likely(proto && proto->tuple_to_nfattr)) {
+	if (likely(proto->tuple_to_nfattr))
 		ret = proto->tuple_to_nfattr(skb, tuple);
-		ip_conntrack_proto_put(proto);
-	}
+
+	ip_conntrack_proto_put(proto);
 
 	return ret;
 
@@ -128,9 +130,11 @@ ctnetlink_dump_protoinfo(struct sk_buff 
 
 	struct nfattr *nest_proto;
 	int ret;
-	
-	if (!proto || !proto->to_nfattr)
+
+	if (!proto->to_nfattr) {
+		ip_conntrack_proto_put(proto);
 		return 0;
+	}
 	
 	nest_proto = NFA_NEST(skb, CTA_PROTOINFO);
 

--------------040101070601070808080106--
