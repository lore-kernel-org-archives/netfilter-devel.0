From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv5 3/4] netfilter: bridge: rename br_parse_ip_options
Date: Fri, 29 May 2015 02:19:24 +0200
Message-ID: <20150529001924.GD705@salvia>
References: <1432801510-11902-1-git-send-email-bernhard.thaler@wvnet.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, netfilter-devel@vger.kernel.org,
	fw@strlen.de
To: Bernhard Thaler <bernhard.thaler@wvnet.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42574 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755208AbbE2AOW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 May 2015 20:14:22 -0400
Content-Disposition: inline
In-Reply-To: <1432801510-11902-1-git-send-email-bernhard.thaler@wvnet.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 28, 2015 at 10:25:10AM +0200, Bernhard Thaler wrote:
> br_parse_ip_options() does not parse any IP options, it validates IP
> packets as a whole and the function name is misleading.
> 
> Rename br_parse_ip_options() to br_validate_ipv4().
> 
> Signed-off-by: Bernhard Thaler <bernhard.thaler@wvnet.at>
> ---
> Patch revision history:
> 
> v5
> * rebase to current davem/net-next
> 
> v4
> * re-post due to errors in v3 formatting introduced by my MUA
> 
> v3
> * re-assignment of iph variable needed because pskb_may_pull() can
> invalidate the network header
> * same patch as v1 again
> 
> v2
> * first patch did not contain statement removing double iph variable
>   assignment
> 
>  net/bridge/br_netfilter.c |   11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index a43e216..f34edb6 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -217,7 +217,7 @@ static inline void nf_bridge_pull_encap_header_rcsum(struct sk_buff *skb)
>   * expected format
>   */
>  
> -static int br_parse_ip_options(struct sk_buff *skb)
> +static int br_validate_ipv4(struct sk_buff *skb)
>  {
>  	const struct iphdr *iph;
>  	struct net_device *dev = skb->dev;
> @@ -319,7 +319,7 @@ bad:
>  	return -1;
>  }
>  
> -/* Equivalent to br_parse_ip_options for IPv6 */
> +/* Equivalent to br_validate_ipv4 for IPv6 */
>  static int br_validate_ipv6(struct sk_buff *skb)

Could you send me this patch in first place so you don't need to
modify the IPv6 part that you just added?

Thanks.
