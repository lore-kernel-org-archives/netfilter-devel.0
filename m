From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] fix conntrack reassembly expire code
Date: Tue, 11 Dec 2012 02:50:20 +0100
Message-ID: <20121211015019.GA18425@1984>
References: <1354873337-3776-1-git-send-email-haibbo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, coreteam@netfilter.org
To: haibbo@gmail.com
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1354873337-3776-1-git-send-email-haibbo@gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Haibbo,

On Fri, Dec 07, 2012 at 05:42:17PM +0800, haibbo@gmail.com wrote:
> From: Haibo Xi <haibbo@gmail.com>
> 
> Commit b836c99fd6c9 (ipv6: unify conntrack reassembly expire
> code with standard one) use the standard IPv6 reassembly
> code(ip6_expire_frag_queue) to handle conntrack reassembly expire.
> 
> In ip6_expire_frag_queue, it invoke dev_get_by_index_rcu to get
> which device received this expired packet.so we must save ifindex
> when NF_conntrack get this packet.
> 
> With this patch applied, I can see ICMP Time Exceeded sent
> from the receiver when the sender sent out 1/2 fragmented
> IPv6 packet.
> 
> Signed-off-by: Haibo Xi <haibbo@gmail.com>
> ---
>  net/ipv6/netfilter/nf_conntrack_reasm.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 22c8ea9..e7197be 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -196,6 +196,7 @@ static int nf_ct_frag6_queue(struct frag_queue *fq, struct sk_buff *skb,
>  	struct sk_buff *prev, *next;
>  	unsigned int payload_len;
>  	int offset, end;
> +	struct net_device *dev = NULL;

This assignation above is superfluous.

>  	if (fq->q.last_in & INET_FRAG_COMPLETE) {
>  		pr_debug("Already completed\n");
> @@ -311,7 +312,11 @@ found:
>  	else
>  		fq->q.fragments = skb;
>  
> -	skb->dev = NULL;
> +	dev = skb->dev;
> +	if (dev) {
> +		fq->iif = dev->ifindex;
> +		skb->dev = NULL;
> +	}
>  	fq->q.stamp = skb->tstamp;
>  	fq->q.meat += skb->len;
>  	if (payload_len > fq->q.max_size)
> -- 
> 1.7.0.4
> 
