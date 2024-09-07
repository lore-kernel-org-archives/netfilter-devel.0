Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CAC15D5C1;
	Sat,  7 Sep 2024 13:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725716924; cv=none; b=ZATqO722pvCikazB/6vuFZHmJy5hWPkVDohOwyfHlZ5JQKysUuB1Q64eMlbwv3YBWMe0X5BkFBMfN1GQK7On/71Hnt3jWBNAKtjHuGmOaUgHGRXKOjBY/1xM9mS6UIifWkwtgkDcghmPMKpWIPNZxMyEPnlg0nVfqBrRP/Jg4dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725716924; c=relaxed/simple;
	bh=ey36fMdqyJSr9o7fg2f9nSLEmsq1vX3YG6kQS2WaUxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ryzz6B5gVL/XwH2ZPYmYb9vSLxOYcJLH+nVog8swZ2ZfGplzAx+fxTjG34wCNqxkTQAZLmMlnj+4KprTWmC5JR2CRaIl5Al48NOpM83j76IcQb3XIrCgCnGlDp4jyxOWfGDL+D4IoPI/Dse6WmkyLIhRwFRTqX3uz71tTKfbdVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qt9F/x2y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qt9F/x2y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6B0C4CEC6;
	Sat,  7 Sep 2024 13:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725716923;
	bh=ey36fMdqyJSr9o7fg2f9nSLEmsq1vX3YG6kQS2WaUxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Qt9F/x2yxCuHhMdqd2Yav13ruQezrjVb5lPNAuX8j07N8A5gPbjA0nLlW3eGfWdan
	 umTmnZ1xo94apLseKzyfGyAYS4AP5MC3bEBduXKn2JPxv5q7nWBjZC85PFNl6kQZPT
	 Xa8OCCB4aBJrgMvyBsuhm/Kg7B5ZHm2D5EiaW00bMwVfT8vpY2cgt/rczsbrneP3FU
	 dtG356bj9zGn3jGdeoBgupgR5czALPm9d24edUQdEZ2atn5uIl+WeAf0rsZtE7mVmN
	 IrDNe0L5bg2dbS5R6jnEmbgvIFrDnw4EGwRSpPm5dty6TvLKzEJZYrYxd6WZsuJ13p
	 7DoSpd5LvKOSw==
Date: Sat, 7 Sep 2024 14:48:37 +0100
From: Simon Horman <horms@kernel.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>
Subject: Re: [PATCH net v1 1/1] netfilter: nf_reject: Fix build error when
 CONFIG_BRIDGE_NETFILTER=n
Message-ID: <20240907134837.GP2097826@kernel.org>
References: <20240906145513.567781-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240906145513.567781-1-andriy.shevchenko@linux.intel.com>

On Fri, Sep 06, 2024 at 05:55:13PM +0300, Andy Shevchenko wrote:
> In some cases (CONFIG_BRIDGE_NETFILTER=n) the pointer to IP header
> is set but not used, it prevents kernel builds with clang, `make W=1`
> and CONFIG_WERROR=y:
> 
> ipv6: split nf_send_reset6() in smaller functions
> netfilter: nf_reject_ipv4: split nf_send_reset() in smaller functions
> 
> net/ipv4/netfilter/nf_reject_ipv4.c:243:16: error: variable 'niph' set but not used [-Werror,-Wunused-but-set-variable]
>   243 |         struct iphdr *niph;
>       |                       ^
> net/ipv6/netfilter/nf_reject_ipv6.c:286:18: error: variable 'ip6h' set but not used [-Werror,-Wunused-but-set-variable]
>   286 |         struct ipv6hdr *ip6h;
>       |                         ^
> 
> Fix these by marking respective variables with __maybe_unused as it
> seems more complicated to address that in a better way due to ifdeffery.
> 
> Fixes: 8bfcdf6671b1 ("netfilter: nf_reject_ipv6: split nf_send_reset6() in smaller functions")
> Fixes: 052b9498eea5 ("netfilter: nf_reject_ipv4: split nf_send_reset() in smaller functions")

Hi Andy,

As mentioned in relation to another similar patch,
I'm not sure that resolution of W=1 warnings are fixes.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  net/ipv4/netfilter/nf_reject_ipv4.c | 2 +-
>  net/ipv6/netfilter/nf_reject_ipv6.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

> 
> diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
> index 04504b2b51df..0af42494ac66 100644
> --- a/net/ipv4/netfilter/nf_reject_ipv4.c
> +++ b/net/ipv4/netfilter/nf_reject_ipv4.c
> @@ -240,7 +240,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
>  		   int hook)
>  {
>  	struct sk_buff *nskb;
> -	struct iphdr *niph;
> +	struct iphdr *niph __maybe_unused;
>  	const struct tcphdr *oth;
>  	struct tcphdr _oth;
>  

Possibly it is broken for some reason - like reading nskb too late -
but I wonder if rather than annotating niph it's scope can be reduced
to the code that is only compiled if CONFIG_BRIDGE_NETFILTER is enabled.

This also addreses what appears to be an assingment of niph without
the value being used - the first assingment.

E.g., for the ipv4 case (compile tested only!):

diff --git a/net/ipv4/netfilter/nf_reject_ipv4.c b/net/ipv4/netfilter/nf_reject_ipv4.c
index 04504b2b51df..87fd945a0d27 100644
--- a/net/ipv4/netfilter/nf_reject_ipv4.c
+++ b/net/ipv4/netfilter/nf_reject_ipv4.c
@@ -239,9 +239,8 @@ static int nf_reject_fill_skb_dst(struct sk_buff *skb_in)
 void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 		   int hook)
 {
-	struct sk_buff *nskb;
-	struct iphdr *niph;
 	const struct tcphdr *oth;
+	struct sk_buff *nskb;
 	struct tcphdr _oth;
 
 	oth = nf_reject_ip_tcphdr_get(oldskb, &_oth, hook);
@@ -266,14 +265,12 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	nskb->mark = IP4_REPLY_MARK(net, oldskb->mark);
 
 	skb_reserve(nskb, LL_MAX_HEADER);
-	niph = nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
-				   ip4_dst_hoplimit(skb_dst(nskb)));
+	nf_reject_iphdr_put(nskb, oldskb, IPPROTO_TCP,
+			    ip4_dst_hoplimit(skb_dst(nskb)));
 	nf_reject_ip_tcphdr_put(nskb, oldskb, oth);
 	if (ip_route_me_harder(net, sk, nskb, RTN_UNSPEC))
 		goto free_nskb;
 
-	niph = ip_hdr(nskb);
-
 	/* "Never happens" */
 	if (nskb->len > dst_mtu(skb_dst(nskb)))
 		goto free_nskb;
@@ -290,6 +287,7 @@ void nf_send_reset(struct net *net, struct sock *sk, struct sk_buff *oldskb,
 	 */
 	if (nf_bridge_info_exists(oldskb)) {
 		struct ethhdr *oeth = eth_hdr(oldskb);
+		struct iphdr *niph = ip_hdr(nskb);
 		struct net_device *br_indev;
 
 		br_indev = nf_bridge_get_physindev(oldskb, net);
