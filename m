From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH] nfnetlink_queue Fix typo on debug message
Date: Fri, 11 Aug 2006 00:23:00 +0200
Message-ID: <44DBB1C4.5080901@trash.net>
References: <1155218132.10883.3.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1155218132.10883.3.camel@localhost.localdomain>
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

Eric Leblond wrote:
> This patch fixes a trivial typo in nfnetlink_queue.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> ---
>  net/netfilter/nfnetlink_queue.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 86a4ac3..d9a2ad8 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -584,7 +584,7 @@ nfqnl_enqueue_packet(struct sk_buff *skb
>                  queue->queue_dropped++;
>  		status = -ENOSPC;
>  		if (net_ratelimit())
> -		          printk(KERN_WARNING "ip_queue: full at %d entries, "
> +		          printk(KERN_WARNING "nf_queue: full at %d entries, "
>  				 "dropping packets(s). Dropped: %d\n", 
>  				 queue->queue_total, queue->queue_dropped);
>  		goto err_out_free_nskb;


You missed one spot. It should actually say nfnetlink_queue I guess, but
I'm too lazy to fix up all those printks :)
