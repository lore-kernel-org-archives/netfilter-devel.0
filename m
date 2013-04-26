From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: idletimers - fix the case of already
 expired timer
Date: Fri, 26 Apr 2013 03:24:38 +0200
Message-ID: <20130426012438.GA4486@localhost>
References: <1366537994-19511-1-git-send-email-dmitry.pervushin@linaro.org>
 <1366537994-19511-2-git-send-email-dmitry.pervushin@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@linaro.org, dmitry pervushin <dpervushin@gmail.com>,
	Ashish Sharma <ashishsharma@google.com>,
	JP Abgrall <jpa@google.com>,
	John Stultz <john.stultz@linaro.org>
To: dmitry pervushin <dmitry.pervushin@linaro.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758898Ab3DZBYn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:24:43 -0400
Content-Disposition: inline
In-Reply-To: <1366537994-19511-2-git-send-email-dmitry.pervushin@linaro.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Same thing with this patch:

https://patchwork.kernel.org/patch/2333841/

Regards.

On Sun, Apr 21, 2013 at 11:53:13AM +0200, dmitry pervushin wrote:
> From: dmitry pervushin <dpervushin@gmail.com>
> 
> Fix the case in which timer has expired and we refresh it without
> sending the notification
> 
> Signed-off-by: Ashish Sharma <ashishsharma@google.com>
> Signed-off-by: JP Abgrall <jpa@google.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: dmitry pervushin <dmitry.pervushin@linaro.org>
> ---
>  net/netfilter/xt_IDLETIMER.c |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_IDLETIMER.c
> index f407ebc1..3540c04 100644
> --- a/net/netfilter/xt_IDLETIMER.c
> +++ b/net/netfilter/xt_IDLETIMER.c
> @@ -168,14 +168,22 @@ static unsigned int idletimer_tg_target(struct sk_buff *skb,
>  					 const struct xt_action_param *par)
>  {
>  	const struct idletimer_tg_info *info = par->targinfo;
> +	unsigned long now = jiffies;
>  
>  	pr_debug("resetting timer %s, timeout period %u\n",
>  		 info->label, info->timeout);
>  
>  	BUG_ON(!info->timer);
>  
> +	if (time_before(info->timer->timer.expires, now)) {
> +		schedule_work(&info->timer->work);
> +		pr_debug("Starting timer %s (Expired, Jiffies): %lu, %lu\n",
> +			 info->label, info->timer->timer.expires, now);
> +	}
> +
> +	/* TODO: Avoid modifying timers on each packet */
>  	mod_timer(&info->timer->timer,
> -		  msecs_to_jiffies(info->timeout * 1000) + jiffies);
> +		  msecs_to_jiffies(info->timeout * 1000) + now);
>  
>  	return XT_CONTINUE;
>  }
> @@ -184,6 +192,7 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
>  {
>  	struct idletimer_tg_info *info = par->targinfo;
>  	int ret;
> +	unsigned long now = jiffies;
>  
>  	pr_debug("checkentry targinfo%s\n", info->label);
>  
> @@ -204,8 +213,13 @@ static int idletimer_tg_checkentry(const struct xt_tgchk_param *par)
>  	info->timer = __idletimer_tg_find_by_label(info->label);
>  	if (info->timer) {
>  		info->timer->refcnt++;
> +		if (time_before(info->timer->timer.expires, now)) {
> +			schedule_work(&info->timer->work);
> +			pr_debug("Starting Checkentry timer (Expired, Jiffies): %lu, %lu\n",
> +				info->timer->timer.expires, now);
> +		}
>  		mod_timer(&info->timer->timer,
> -			  msecs_to_jiffies(info->timeout * 1000) + jiffies);
> +			  msecs_to_jiffies(info->timeout * 1000) + now);
>  
>  		pr_debug("increased refcnt of timer %s to %u\n",
>  			 info->label, info->timer->refcnt);
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
