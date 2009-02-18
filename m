From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] netfilter: use a linked list of loggers.
Date: Wed, 18 Feb 2009 17:08:22 +0100
Message-ID: <499C3276.5090402@trash.net>
References: <49980BA7.2040108@inl.fr> <1234701437-2754-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56955 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbZBRQIZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:08:25 -0500
In-Reply-To: <1234701437-2754-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> +/* return EEXIST if the same logger is registred, 0 on success. */
> +int nf_log_register(u_int8_t pf, struct nf_logger *logger)
>  {
>  	int ret;
> +	const struct nf_logger *llog;
>  
>  	if (pf >= ARRAY_SIZE(nf_loggers))
>  		return -EINVAL;
>  
> -	/* Any setup of logging members must be done before
> -	 * substituting pointer. */
> -	ret = mutex_lock_interruptible(&nf_log_mutex);
> -	if (ret < 0)
> -		return ret;
> +	mutex_lock(&nf_log_mutex);
>  
> -	if (!nf_loggers[pf])
> -		rcu_assign_pointer(nf_loggers[pf], logger);
> -	else if (nf_loggers[pf] == logger)
> -		ret = -EEXIST;
> -	else
> -		ret = -EBUSY;
> +	ret = -EEXIST;
> +	if (pf == NFPROTO_UNSPEC) {
> +		int i;
> +		for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
> +			if (__find_logger(i, logger->name) == NULL) {
> +				ret = 0;
> +				list_add_tail(&(logger->list[i]),
> +						&(nf_loggers_l[i]));
> +			}
> +	} else {
> +		if (__find_logger(pf, logger->name) == NULL) {
> +			ret = 0;
> +			/* register at end of list to honor first register win */
> +			list_add_tail(&(logger->list[pf]),
> +					  &nf_loggers_l[pf]);
> +			llog = rcu_dereference(nf_loggers[pf]);
> +			if (llog == NULL)
> +				rcu_assign_pointer(nf_loggers[pf], logger);
> +		}
> +	}

As the loggers are only registered statically by kernel modules,
I think this check is overkill. Just add them and let it crash
if someone does two registrations of the same logger, it won't
take long to notice. Similar for unregistration, its not worth
the trouble to check whether its actually registered, especially
since the list deletion doesn't even need to know. Just NULL
out the affected nf_loggers pointers and it should be fine.

Sorry for not saying this earlier.
