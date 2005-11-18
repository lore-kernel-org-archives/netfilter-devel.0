From: Pablo Neira <pablo@eurodev.net>
Subject: Re: kernel BUG at kernel/sched.c:2833!
Date: Fri, 18 Nov 2005 04:19:01 +0100
Message-ID: <437D4825.1060801@eurodev.net>
References: <Pine.LNX.4.64.0511141033001.8729@bizon.gios.gov.pl>
	<437882BE.6080705@eurodev.net>
	<Pine.LNX.4.64.0511162216140.16387@bizon.gios.gov.pl>
	<437BD093.3010905@eurodev.net>
	<20051117151135.GJ14201@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020302010100080402090208"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051117151135.GJ14201@sunbeam.de.gnumonks.org>
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
--------------020302010100080402090208
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Harald Welte wrote:
> On Thu, Nov 17, 2005 at 01:36:35AM +0100, Pablo Neira wrote:
> 
>>[NETFILTER] Fix ip_conntrack_proto_find_get badness
> 
> thanks, applied.

Sorry Harald, that patch is incomplete :(. Please, revert it. Attached
the final version.

BTW, you have two trees at people.netfilter.org, which one should I use?

-- 
Pablo

--------------020302010100080402090208
Content-Type: text/plain;
 name="proto_find.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="proto_find.patch"

Remove proto == NULL checking since ip_conntrack_[nat_]proto_find_get always
returns a valid pointer. Fix missing ip_conntrack_proto_put in some paths.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- netfilter-2.6.14.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-18 04:10:01.000000000 +0100
+++ netfilter-2.6.14.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2005-11-18 04:12:09.000000000 +0100
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
 
@@ -527,10 +531,10 @@ ctnetlink_parse_tuple_proto(struct nfatt
 
 	proto = ip_conntrack_proto_find_get(tuple->dst.protonum);
 
-	if (likely(proto && proto->nfattr_to_tuple)) {
+	if (likely(proto && proto->nfattr_to_tuple))
 		ret = proto->nfattr_to_tuple(tb, tuple);
-		ip_conntrack_proto_put(proto);
-	}
+	
+	ip_conntrack_proto_put(proto);
 	
 	return ret;
 }
@@ -596,8 +600,6 @@ static int ctnetlink_parse_nat_proto(str
 		return -EINVAL;
 
 	npt = ip_nat_proto_find_get(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.protonum);
-	if (!npt)
-		return 0;
 
 	if (!npt->nfattr_to_range) {
 		ip_nat_proto_put(npt);
@@ -957,8 +959,6 @@ ctnetlink_change_protoinfo(struct ip_con
 	nfattr_parse_nested(tb, CTA_PROTOINFO_MAX, attr);
 
 	proto = ip_conntrack_proto_find_get(npt);
-	if (!proto)
-		return -EINVAL;
 
 	if (proto->from_nfattr)
 		err = proto->from_nfattr(tb, ct);

--------------020302010100080402090208--
