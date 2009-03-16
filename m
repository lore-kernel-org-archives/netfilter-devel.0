From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: use a linked list of loggers.
Date: Mon, 16 Mar 2009 14:54:44 +0100
Message-ID: <49BE5A24.3060402@trash.net>
References: <499DD499.50704@inl.fr> <1235080458-6623-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45443 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799AbZCPNys (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:54:48 -0400
In-Reply-To: <1235080458-6623-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies nf_log to use a linked list of loggers for each
> protocol. This list of loggers is read and write protected with a
> mutex.
> This patch separates registration and binding. To be used as
> logging module, a module has to register calling nf_log_register()
> and to bind to a protocol it has to call nf_log_bind_pf().
> This patch also converts the logging modules to the new API. For nfnetlink_log,
> it simply switchs call to register functions to call to bind function and
> adds a call to nf_log_register() during init. For other modules, it just
> remove a const flag from the logger structure and replace it with a
> __read_mostly.

Applied, thanks. I've made a few changes, please see below.

> -void nf_log_unregister(const struct nf_logger *logger)
> +void nf_log_unregister(struct nf_logger *logger)
>  {
>  	int i;
>  
>  	mutex_lock(&nf_log_mutex);
>  	for (i = 0; i < ARRAY_SIZE(nf_loggers); i++) {
> -		if (nf_loggers[i] == logger)
> +		const struct nf_logger *c_logger = rcu_dereference(nf_loggers[i]);

I've moved the definitionn to the beginning of the function to
bring the line down to 80 characters.

> +		if (c_logger == logger)
>  			rcu_assign_pointer(nf_loggers[i], NULL);
> +		list_del(&(logger->list[i]));
>  	}
>  	mutex_unlock(&nf_log_mutex);
>  
> @@ -73,6 +76,28 @@ void nf_log_unregister(const struct nf_logger *logger)
>  }
>  EXPORT_SYMBOL(nf_log_unregister);
>  
> +int nf_log_bind_pf(u_int8_t pf, const struct nf_logger *logger)
> +{
> +	mutex_lock(&nf_log_mutex);
> +	if (__find_logger(pf, logger->name) == NULL) {
> +		mutex_unlock(&nf_log_mutex);
> +		return -1;

This is returned directly to userspace and thus needs to use
errno-codes. I've changed it to -ENOENT.

> +	}
> +	rcu_assign_pointer(nf_loggers[pf], logger);
> +	mutex_unlock(&nf_log_mutex);
> +	return 0;
> +}
> +EXPORT_SYMBOL(nf_log_bind_pf);
> +
> +int nf_log_unbind_pf(u_int8_t pf)
> +{
> +	mutex_lock(&nf_log_mutex);
> +	rcu_assign_pointer(nf_loggers[pf], NULL);
> +	mutex_unlock(&nf_log_mutex);
> +	return 0;
> +}
> +EXPORT_SYMBOL(nf_log_unbind_pf);

This should return void since there's nothing a caller can do
about it and the only existing one doesn't care.

> diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
> index c712e9f..42e7de9 100644
> --- a/net/netfilter/nfnetlink_log.c
> +++ b/net/netfilter/nfnetlink_log.c

> @@ -952,6 +952,11 @@ static int __init nfnetlink_log_init(void)
>  		goto cleanup_netlink_notifier;
>  	}
>  
> +	if ((status = nf_log_register(NFPROTO_UNSPEC, &nfulnl_logger)) < 0) {
> +		printk(KERN_ERR "log: failed to register logger\n");
> +		goto cleanup_netlink_notifier;

This needs to undo the nfnetlink subsys registration. I've fixed
it before applying.
