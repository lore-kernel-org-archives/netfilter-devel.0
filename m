From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] Misc cleanups
Date: Mon, 11 Jun 2007 16:17:14 +0200
Message-ID: <466D596A.20807@trash.net>
References: <Pine.LNX.4.61.0706042108010.20829@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0706042109390.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706042109390.20829@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> Make a number of variables const and/or remove unneeded casts.


Applied with some minor changes, thanks Jan.


> @@ -249,7 +249,7 @@ clusterip_hashfn(struct sk_buff *skb, st
>  	case IPPROTO_SCTP:
>  	case IPPROTO_DCCP:
>  	case IPPROTO_ICMP:
> -		ports = (void *)iph+iph->ihl*4;
> +		ports = (const void *)iph+iph->ihl*4;


This one is not neccessary.

> @@ -88,7 +88,7 @@ masquerade_target(struct sk_buff **pskb,
>  		return NF_ACCEPT;
>  
>  	mr = targinfo;
> -	rt = (struct rtable *)(*pskb)->dst;
> +	rt = (const struct rtable *)(*pskb)->dst;


This one neither.

> @@ -147,7 +147,8 @@ static int masq_inet_event(struct notifi
>  			   unsigned long event,
>  			   void *ptr)
>  {
> -	struct net_device *dev = ((struct in_ifaddr *)ptr)->ifa_dev->dev;
> +	const struct net_device *dev =
> +		((const struct in_ifaddr *)ptr)->ifa_dev->dev;


Same here.

> +++ linux-2.6.22-rc3-git6/net/ipv4/netfilter/ipt_TOS.c
> @@ -50,7 +50,8 @@ checkentry(const char *tablename,
>  	   void *targinfo,
>  	   unsigned int hook_mask)
>  {
> -	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
> +	const u_int8_t tos =
> +		((const struct ipt_tos_target_info *)targinfo)->tos;


And here.

> @@ -443,8 +449,8 @@ hashlimit_match(const struct sk_buff *sk
>  		unsigned int protoff,
>  		bool *hotdrop)
>  {
> -	struct xt_hashlimit_info *r =
> -		((struct xt_hashlimit_info *)matchinfo)->u.master;
> +	const struct xt_hashlimit_info *r =
> +		((const struct xt_hashlimit_info *)matchinfo)->u.master;


This one is fine I guess since matchinfo is also const. Same for
all other matches.
