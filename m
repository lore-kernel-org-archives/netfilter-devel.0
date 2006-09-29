From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 3/3] Replace reverse_route() with a call to
	ip_route_me_harder()
Date: Fri, 29 Sep 2006 15:38:51 +0200
Message-ID: <451D21EB.9090500@trash.net>
References: <20060921092241.441882000@tabatha.lab.ultramonkey.org>
	<20060921093021.628489000@tabatha.lab.ultramonkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: vyekkirala@TrustedCS.com, Ken Brownfield <krb@irridia.com>,
	Roberto Nibali <ratz@drugphish.ch>, netfilter-devel@lists.netfilter.org,
	Farid Sarwari <fsarwari@exchangesolutions.com>,
	Julian Anastasov <ja@ssi.bg>, David Black <dave@jamsoft.com>,
	Joseph Mack NA3T <jmack@wm7d.net>, David Miller <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Horms <horms@verge.net.au>
In-Reply-To: <20060921093021.628489000@tabatha.lab.ultramonkey.org>
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

Horms wrote:
> Index: net-2.6.19/net/ipv4/netfilter/ipt_REJECT.c
> ===================================================================
> --- net-2.6.19.orig/net/ipv4/netfilter/ipt_REJECT.c	2006-09-19 12:50:43.000000000 +0900
> +++ net-2.6.19/net/ipv4/netfilter/ipt_REJECT.c	2006-09-21 17:55:37.000000000 +0900
> @@ -38,13 +38,9 @@
>  #define DEBUGP(format, args...)
>  #endif
>  
> -static inline struct rtable *route_reverse(struct sk_buff *skb, 
> -					   struct tcphdr *tcph, int hook)
> +static inline int send_reset_route(struct sk_buff **pskb, int hook)
>  {
> ...
> -	security_skb_classify_flow(skb, &fl);


With this patch we loose the security_skb_classify_flow call.
I think it is also needed in ip_route_me_harder, if so your
patch seems fine (but I get large rejects with the current
tree, so I'm going to redo it).

Venkat, is it correct to place a security_skb_classify_flow
call in ip_route_me_harder (which also handles currently
unlabeled protocols)?
