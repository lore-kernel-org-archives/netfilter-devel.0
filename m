From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] Specify nf_queue max length from userspace
Date: Fri, 16 Jun 2006 14:36:53 +0200
Message-ID: <4492A5E5.1020308@netfilter.org>
References: <1150217788.7164.4.camel@porky> <1150218404.5386.2.camel@porky>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hi Eric,

Eric Leblond wrote:
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

If you have to add new attributes, do it always at the end, in other 
words, just before NFQNL_COPY_MAX. Otherwise you're breaking backward 
compatibility. See that old binaries use COPY_NONE set to 0, but after 
applying your patch COPY_NONE is set to 1. Result: old binaries will no 
work with nfnetlink_queue anymore.

> @@ -75,6 +76,7 @@ enum nfqnl_config_mode {
>  struct nfqnl_msg_config_params {
>  	u_int32_t	copy_range;
>  	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
> +	u_int32_t   queue_maxlen;
>  } __attribute__ ((packed));

Same thing here. If you have to modify this structure, you need to 
create a new one called struct nfqnl_msg_config_params2. Since I don't 
like this option, I think that the best solution is to add a new 
attribute called NFQNL_CFG_QUEUE_MAXLEN.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
