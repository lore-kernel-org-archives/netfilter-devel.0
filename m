From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH RFC 3/3] NFQUEUE: add --queue-cpu-fanout parameter
Date: Tue, 19 Mar 2013 15:34:12 +0100
Message-ID: <1363703652.30419.11.camel@tiger2>
References: <20130319141442.150005875@eitzenberger.org>
	 <20130319141606.304161536@eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: holger@eitzenberger.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:57219 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643Ab3CSOeV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:34:21 -0400
In-Reply-To: <20130319141606.304161536@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Cool job! This CPU-based setup has proven to be really efficient on
af_packet capture. I hope this will bring a performance boost to NFQ.

If possible, it could be interesting to be able to setup the balance
parameter by using an option in the same way fail-open option:  
       uint32_t flags = NFQA_CFG_F_FAIL_OPEN;
       uint32_t mask = NFQA_CFG_F_FAIL_OPEN;
       int r = nfq_set_queue_flags(qh, mask, flags);
This way, it is possible to tune the system without changing the
ruleset.

What do you think ?

BR,

On Tue, 2013-03-19 at 15:14 +0100, holger@eitzenberger.org wrote:
> plain text document attachment (iptables)
> Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>
> 
> ---
>  extensions/libxt_NFQUEUE.c           |   59 +++++++++++++++++++++++++++++++++-
>  include/linux/netfilter/xt_NFQUEUE.h |    8 +++++
>  2 files changed, 66 insertions(+), 1 deletion(-)
> 
> diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
> index 8c2f699..8106425 100644
> --- a/extensions/libxt_NFQUEUE.c
> +++ b/extensions/libxt_NFQUEUE.c
> @@ -13,8 +13,10 @@ enum {
>  	O_QUEUE_NUM = 0,
>  	O_QUEUE_BALANCE,
>  	O_QUEUE_BYPASS,
> +	O_QUEUE_CPU_FANOUT,
>  	F_QUEUE_NUM     = 1 << O_QUEUE_NUM,
>  	F_QUEUE_BALANCE = 1 << O_QUEUE_BALANCE,
> +	F_QUEUE_CPU_FANOUT = 1 << O_QUEUE_CPU_FANOUT,
>  };
>  
>  static void NFQUEUE_help(void)
> @@ -37,7 +39,15 @@ static void NFQUEUE_help_v2(void)
>  {
>  	NFQUEUE_help_v1();
>  	printf(
> -"  --queue-bypass		Bypass Queueing if no queue instance exists.\n");
> +"  --queue-bypass		Bypass Queueing if no queue instance exists.\n"
> +"  --queue-cpu-fanout	Use current CPU (no hashing)\n");
> +}
> +
> +static void NFQUEUE_help_v3(void)
> +{
> +	NFQUEUE_help_v2();
> +	printf(
> +"  --queue-cpu-fanout	Use current CPU (no hashing)\n");
>  }
>  
>  #define s struct xt_NFQ_info
> @@ -48,6 +58,8 @@ static const struct xt_option_entry NFQUEUE_opts[] = {
>  	{.name = "queue-balance", .id = O_QUEUE_BALANCE,
>  	 .type = XTTYPE_UINT16RC, .excl = F_QUEUE_NUM},
>  	{.name = "queue-bypass", .id = O_QUEUE_BYPASS, .type = XTTYPE_NONE},
> +	{.name = "queue-cpu-fanout", .id = O_QUEUE_CPU_FANOUT,
> +	 .type = XTTYPE_NONE, .also = O_QUEUE_BALANCE},
>  	XTOPT_TABLEEND,
>  };
>  #undef s
> @@ -92,6 +104,18 @@ static void NFQUEUE_parse_v2(struct xt_option_call *cb)
>  	}
>  }
>  
> +static void NFQUEUE_parse_v3(struct xt_option_call *cb)
> +{
> +	struct xt_NFQ_info_v3 *info = cb->data;
> +
> +	NFQUEUE_parse_v2(cb);
> +	switch (cb->entry->id) {
> +	case O_QUEUE_CPU_FANOUT:
> +		info->flags |= NFQ_FLAG_CPU_FANOUT;
> +		break;
> +	}
> +}
> +
>  static void NFQUEUE_print(const void *ip,
>                            const struct xt_entry_target *target, int numeric)
>  {
> @@ -124,6 +148,16 @@ static void NFQUEUE_print_v2(const void *ip,
>  		printf(" bypass");
>  }
>  
> +static void NFQUEUE_print_v3(const void *ip,
> +                             const struct xt_entry_target *target, int numeric)
> +{
> +	const struct xt_NFQ_info_v3 *info = (void *)target->data;
> +
> +	NFQUEUE_print_v2(ip, target, numeric);
> +	if (info->flags & NFQ_FLAG_CPU_FANOUT)
> +		printf(" cpu-fanout");
> +}
> +
>  static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
>  {
>  	const struct xt_NFQ_info *tinfo =
> @@ -155,6 +189,16 @@ static void NFQUEUE_save_v2(const void *ip, const struct xt_entry_target *target
>  		printf(" --queue-bypass");
>  }
>  
> +static void NFQUEUE_save_v3(const void *ip,
> +			    const struct xt_entry_target *target)
> +{
> +	const struct xt_NFQ_info_v3 *info = (void *)target->data;
> +
> +	NFQUEUE_save_v2(ip, target);
> +	if (info->flags & NFQ_FLAG_CPU_FANOUT)
> +		printf(" --queue-cpu-fanout");
> +}
> +
>  static void NFQUEUE_init_v1(struct xt_entry_target *t)
>  {
>  	struct xt_NFQ_info_v1 *tinfo = (void *)t->data;
> @@ -199,6 +243,19 @@ static struct xtables_target nfqueue_targets[] = {
>  	.save		= NFQUEUE_save_v2,
>  	.x6_parse	= NFQUEUE_parse_v2,
>  	.x6_options	= NFQUEUE_opts,
> +},{
> +	.family		= NFPROTO_UNSPEC,
> +	.revision	= 3,
> +	.name		= "NFQUEUE",
> +	.version	= XTABLES_VERSION,
> +	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info_v3)),
> +	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info_v3)),
> +	.help		= NFQUEUE_help_v3,
> +	.init		= NFQUEUE_init_v1,
> +	.print		= NFQUEUE_print_v3,
> +	.save		= NFQUEUE_save_v3,
> +	.x6_parse	= NFQUEUE_parse_v3,
> +	.x6_options	= NFQUEUE_opts,
>  }
>  };
>  
> diff --git a/include/linux/netfilter/xt_NFQUEUE.h b/include/linux/netfilter/xt_NFQUEUE.h
> index 9eafdbb..1f24680 100644
> --- a/include/linux/netfilter/xt_NFQUEUE.h
> +++ b/include/linux/netfilter/xt_NFQUEUE.h
> @@ -26,4 +26,12 @@ struct xt_NFQ_info_v2 {
>  	__u16 bypass;
>  };
>  
> +struct xt_NFQ_info_v3 {
> +	__u16 queuenum;
> +	__u16 queues_total;
> +	__u16 bypass;
> +	__u16 flags;
> +#define NFQ_FLAG_CPU_FANOUT		0x01 /* use current CPU (no hashing) */
> +};
> +
>  #endif /* _XT_NFQ_TARGET_H */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

