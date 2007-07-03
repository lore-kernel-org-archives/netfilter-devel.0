From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070628 kernel
Date: Tue, 3 Jul 2007 13:31:30 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707031319000.1536@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706282121220.22579@fbirervta.pbzchgretzou.qr>
	<46840B9F.7080803@trash.net>
	<Pine.LNX.4.64.0706282130150.22579@fbirervta.pbzchgretzou.qr>
	<468410A9.70309@trash.net>
	<Pine.LNX.4.64.0706282150401.22579@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706282155000.22579@fbirervta.pbzchgretzou.qr>
	<4684ECB5.9070402@trash.net>
	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
	<4688EF45.7020200@trash.net>
	<Pine.LNX.4.64.0707021447200.15758@fbirervta.pbzchgretzou.qr>
	<46891C50.1020904@trash.net>
	<Pine.LNX.4.64.0707022103400.28721@fbirervta.pbzchgretzou.qr>
	<468A2F91.3040002@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468A2F91.3040002@trash.net>
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


On Jul 3 2007 13:14, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> Each struct xt_connlimit_data is allowed to have a different hash 
>> function, as long as each function is injective.
>> 
>> A struct xt_connlimit_{info,data} is never fed both AF_INET and
>> AF_INET6 connections.
>> Hence it may use different hash functions for AF_INET and AF_INET6 
>> connections.
>> 
>> Does that help?
>
>
>Not really, you described the situation that led me to this question.
>I can see that you're not using the same hash for both and I question
>that.

See the patch below. It may help to understanding. (The code itself is
redundant, because the BUG_ONs will (should) never trigger.)

>>>Connections are identifier by their tuples, you can derive them 
>>>yourself and do a lookup based on that.
>> 
>> connlimit uses nf_ct_get(skb,...)->tuplehash[0].tuple to get at the 
>> tuple. nf_ct_get() can fail.
>> How else should I derive it?
>
>Use the conntrack tuple if one is available, otherwise use
>nf_ct_get_tuple().

So you are saying I should use...

  nf_ct_get_tuple(skb, 0, 0, match->family, match->proto, &tuple,
                  what_l3, what_l4);

at the top of count_them() and get rid of the nf_ct_get() in connlimit_match?


Thanks,
	Jan

---
 net/netfilter/xt_connlimit.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-2.6.22/net/netfilter/xt_connlimit.c
===================================================================
--- linux-2.6.22.orig/net/netfilter/xt_connlimit.c
+++ linux-2.6.22/net/netfilter/xt_connlimit.c
@@ -36,6 +36,7 @@ struct xt_connlimit_conn {
 
 struct xt_connlimit_data {
 	struct list_head iphash[256];
+	u_int16_t family;
 	spinlock_t lock;
 };
 
@@ -115,10 +116,13 @@ static int count_them(struct xt_connlimi
 
 	tuple = xct->tuplehash[0].tuple;
 
-	if (family == AF_INET6)
+	if (family == AF_INET6) {
+		BUG_ON(data->family != AF_INET6);
 		hash = &data->iphash[connlimit_iphash6(addr, mask)];
-	else
+	} else {
+		BUG_ON(data->family != AF_INET);
 		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
+	}
 
 	read_lock_bh(&nf_conntrack_lock);
 
@@ -245,6 +249,8 @@ static bool connlimit_check(const char *
 	for (i = 0; i < ARRAY_SIZE(info->data->iphash); ++i)
 		INIT_LIST_HEAD(&info->data->iphash[i]);
 
+	/* Tag private structure with the type it is going to be used */
+	info->data->family = match->family;
 	return true;
 }
 
