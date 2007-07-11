From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070707 kernel
Date: Wed, 11 Jul 2007 19:37:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707111933530.11053@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>
	<468E3E06.3080305@trash.net>
	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
	<200707100630.l6A6UB8Q000847@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707100630.l6A6UB8Q000847@toshiba.co.jp>
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

On Jul 10 2007 15:30, Yasuyuki KOZAKAI wrote:
>> +		if (nf_ct_get_tuple(skb, 0, 0, match->family, match->proto,
>> +		    &tuple, NULL, NULL) != 0)
>> +			goto hotdrop;
>
>The second argument is the offset to network protocol header,
>skb_network_offset(skb) (it is 0 in most cases, but it is more logical).
>
>IIRC nf_conntrack_proto_icmp[v6].c do same things. If I have any time
>at late night today, I'll write a generic function for them.

I have applied your three patches to receive the nf_ct_get_tuplepr() 
function, and connlimit now reads:


---
 net/netfilter/xt_connlimit.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

Index: net-2.6/net/netfilter/xt_connlimit.c
===================================================================
--- net-2.6.orig/net/netfilter/xt_connlimit.c
+++ net-2.6/net/netfilter/xt_connlimit.c
@@ -185,9 +185,9 @@ static bool connlimit_match(const struct
 			    unsigned int protoff, bool *hotdrop)
 {
 	const struct xt_connlimit_info *info = matchinfo;
-	const struct nf_conntrack_tuple *tuple_ptr;
 	union nf_conntrack_address addr, mask;
 	struct nf_conntrack_tuple tuple;
+	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	int connections;
@@ -196,19 +196,13 @@ static bool connlimit_match(const struct
 	if (ct != NULL) {
 		tuple_ptr = &ct->tuplehash[0].tuple;
 	} else {
-		struct nf_conntrack_l3proto *l3proto;
-		struct nf_conntrack_l4proto *l4proto;
-
-		l3proto = __nf_ct_l3proto_find(match->family);
-		if (l3proto == NULL)
-			goto hotdrop;
-		l4proto = __nf_ct_l4proto_find(match->family, match->proto);
-		if (l4proto == NULL)
+		int ret;
+		printk(KERN_WARNING "ct==NULL\n");
+		if ((ret = nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+		    match->family, &tuple)) != 0) {
+			printk(KERN_WARNING "drop with %d\n", ret);
 			goto hotdrop;
-		if (nf_ct_get_tuple(skb, 0, 0, match->family, match->proto,
-		    &tuple, NULL, NULL) != 0)
-			goto hotdrop;
-		tuple_ptr = &tuple;
+		}
 	}
 
 	if (match->family == AF_INET6) {


But, nf_ct_get_tuplepr() returns with 1, and I am not sure why.



	Jan
-- 
