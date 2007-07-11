From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070707 kernel
Date: Wed, 11 Jul 2007 20:18:53 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707112017450.11053@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0707041708010.1536@fbirervta.pbzchgretzou.qr>
	<468E3E06.3080305@trash.net>
	<Pine.LNX.4.64.0707071950170.1536@fbirervta.pbzchgretzou.qr>
	<200707100630.l6A6UB8Q000847@toshiba.co.jp>
	<Pine.LNX.4.64.0707111933530.11053@fbirervta.pbzchgretzou.qr>
	<46951BA9.4010809@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46951BA9.4010809@trash.net>
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


On Jul 11 2007 20:04, Patrick McHardy wrote:
>> [...]
>> 
>> But, nf_ct_get_tuplepr() returns with 1, and I am not sure why.
>
>Thats expected I guess, 1 is usually "success" for the tuple parsing
>functions.
>
Such functions should at best return bool :(
Anyway, please take this patch (to be folded onto xt_connlimit) -
runtime-'tested' this time.

Thanks,
	Jan
===
---
 net/netfilter/xt_connlimit.c |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

Index: net-2.6/net/netfilter/xt_connlimit.c
===================================================================
--- net-2.6.orig/net/netfilter/xt_connlimit.c
+++ net-2.6/net/netfilter/xt_connlimit.c
@@ -185,31 +185,19 @@ static bool connlimit_match(const struct
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
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct != NULL) {
+	if (ct != NULL)
 		tuple_ptr = &ct->tuplehash[0].tuple;
-	} else {
-		struct nf_conntrack_l3proto *l3proto;
-		struct nf_conntrack_l4proto *l4proto;
-
-		l3proto = __nf_ct_l3proto_find(match->family);
-		if (l3proto == NULL)
-			goto hotdrop;
-		l4proto = __nf_ct_l4proto_find(match->family, match->proto);
-		if (l4proto == NULL)
-			goto hotdrop;
-		if (nf_ct_get_tuple(skb, 0, 0, match->family, match->proto,
-		    &tuple, NULL, NULL) != 0)
-			goto hotdrop;
-		tuple_ptr = &tuple;
-	}
+	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+	    match->family, &tuple))
+		goto hotdrop;
 
 	if (match->family == AF_INET6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
