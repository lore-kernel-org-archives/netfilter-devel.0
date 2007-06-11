From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/3] Misc cleanups
Date: Mon, 11 Jun 2007 16:31:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706111624320.19578@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706042109390.20829@yvahk01.tjqt.qr>
	<466D596A.20807@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <466D596A.20807@trash.net>
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


On Jun 11 2007 16:17, Patrick McHardy wrote:
>
>> @@ -249,7 +249,7 @@ clusterip_hashfn(struct sk_buff *skb, st
>>  	case IPPROTO_SCTP:
>>  	case IPPROTO_DCCP:
>>  	case IPPROTO_ICMP:
>> -		ports = (void *)iph+iph->ihl*4;
>> +		ports = (const void *)iph+iph->ihl*4;
>
>
>This one is not neccessary.

*Are* you sure? iph is a const struct iphdr *, so adding (iph->ihl*4)
will add sizeof(const struct iphdr *) * (iph->ihl*4) bytes. Which is
four times more (eight on 64-bit) than actually wanted. C basics.

>> @@ -88,7 +88,7 @@ masquerade_target(struct sk_buff **pskb,
>>  		return NF_ACCEPT;
>>  
>>  	mr = targinfo;
>> -	rt = (struct rtable *)(*pskb)->dst;
>> +	rt = (const struct rtable *)(*pskb)->dst;
>
>
>This one neither.

Uhm? ->dst is of type "struct dst_entry", while rt is of type struct rtable.

>> @@ -147,7 +147,8 @@ static int masq_inet_event(struct notifi
>>  			   unsigned long event,
>>  			   void *ptr)
>>  {
>> -	struct net_device *dev = ((struct in_ifaddr *)ptr)->ifa_dev->dev;
>> +	const struct net_device *dev =
>> +		((const struct in_ifaddr *)ptr)->ifa_dev->dev;
>
>
>Same here.

Excuse me... ptr is a void *, so it needs to be cast (or assigned
a temporary) before ->ifa_dev can be dereferenced.

...

I think something is wrong. What is, actually? The "const"? Well 
yeah I added that for great consistency.

>> @@ -443,8 +449,8 @@ hashlimit_match(const struct sk_buff *sk
>>  		unsigned int protoff,
>>  		bool *hotdrop)
>>  {
>> -	struct xt_hashlimit_info *r =
>> -		((struct xt_hashlimit_info *)matchinfo)->u.master;
>> +	const struct xt_hashlimit_info *r =
>> +		((const struct xt_hashlimit_info *)matchinfo)->u.master;
>
>
>This one is fine I guess since matchinfo is also const. Same for
>all other matches.
>

And here it's ok? I don't get it. De-de-referencing a const item does 
not always need to give a const item, hence, all is fine.
Mind you, I compile tested it, and it was warning-free, as before.
Care to explain?


	Jan
-- 
