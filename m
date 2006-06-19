From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] Specify nf_queue max length from userspace
Date: Mon, 19 Jun 2006 18:26:24 +0200
Message-ID: <4496D030.1010400@trash.net>
References: <1150217788.7164.4.camel@porky> <1150218404.5386.2.camel@porky>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1150218404.5386.2.camel@porky>
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
> Attach patch is against current git kernel tree.
> 
> 
> 
> ------------------------------------------------------------------------
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>
> 
> 
> ---
> 
>  include/linux/netfilter/nfnetlink_queue.h |    2 ++
>  net/netfilter/nfnetlink_queue.c           |    7 ++++++-
>  2 files changed, 8 insertions(+), 1 deletions(-)
> 
> 1fb988dc51e2465500df50ff4e085f80acb7b6a3
> diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
> index 9e77437..ce32c54 100644
> --- a/include/linux/netfilter/nfnetlink_queue.h
> +++ b/include/linux/netfilter/nfnetlink_queue.h
> @@ -67,6 +67,7 @@ struct nfqnl_msg_config_cmd {
>  } __attribute__ ((packed));
>  
>  enum nfqnl_config_mode {
> +	NFQNL_COPY_UNSPEC,
>  	NFQNL_COPY_NONE,
>  	NFQNL_COPY_META,
>  	NFQNL_COPY_PACKET,

Looks like an ABI breaker.

> @@ -75,6 +76,7 @@ enum nfqnl_config_mode {
>  struct nfqnl_msg_config_params {
>  	u_int32_t	copy_range;
>  	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
> +	u_int32_t   queue_maxlen;
>  } __attribute__ ((packed));

This too. Why not just use a new attribute?
