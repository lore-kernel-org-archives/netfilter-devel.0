From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/7] netfilter: sysctl support of logger choice.
Date: Wed, 11 Feb 2009 15:21:50 +0100
Message-ID: <4992DEFE.6070609@trash.net>
References: <49909B3E.0@inl.fr> <1234213876-8176-6-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51482 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbZBKOVx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Feb 2009 09:21:53 -0500
In-Reply-To: <1234213876-8176-6-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
> index e76d3b2..78d8642 100644
> --- a/include/linux/sysctl.h
> +++ b/include/linux/sysctl.h
> @@ -335,6 +335,7 @@ enum
>  	NET_NF_CONNTRACK_FRAG6_LOW_THRESH=30,
>  	NET_NF_CONNTRACK_FRAG6_HIGH_THRESH=31,
>  	NET_NF_CONNTRACK_CHECKSUM=32,
> +	NET_NF_LOG=33,

New sysctls should use CTL_UNNUMBERED.

>  };
>  
>  /* /proc/sys/net/ipv4 */
> diff --git a/net/netfilter/nf_log.c b/net/netfilter/nf_log.c
> index fc1deca..4775700 100644
> --- a/net/netfilter/nf_log.c
> +++ b/net/netfilter/nf_log.c
> @@ -14,23 +14,34 @@
>     LOG target modules */
>  
>  #define NF_LOG_PREFIXLEN		128
> -#define NFLOGGER_NAME_LEN		12
> +#define NFLOGGER_NAME_LEN		24

Please restructure this so the first patch adds the final value,
if necessary at all.

>  
>  static const struct nf_logger *nf_loggers[NFPROTO_NUMPROTO] __read_mostly;
>  static struct list_head nf_loggers_l[NFPROTO_NUMPROTO] __read_mostly;
>  static DEFINE_SPINLOCK(nf_log_lock);
>  
> -static struct nf_logger *__find_logger(int pf, const char *str_logger)
> +static struct nf_logger *__find_logger_n(int pf, const char *str_logger, size_t len)
>  {
>  	struct nf_logger *t;
>  
> -	list_for_each_entry(t, &nf_loggers_l[pf], list[pf])
> -		if (!strnicmp(str_logger, t->name, NFLOGGER_NAME_LEN))
> +	if (len > NFLOGGER_NAME_LEN)
> +		return NULL;
> +
> +	list_for_each_entry(t, &nf_loggers_l[pf], list[pf]) {
> +		if ((len != NFLOGGER_NAME_LEN) && (strlen(t->name) != len))

This seems like overoptimization, just the strcmp is fine. Then you can
also remove the wrapper around this function.

> +			continue;
> +		if (!strnicmp(str_logger, t->name, len))
>  			return t;
> +	}
>  
>  	return NULL;
>  }
>  
> +static struct ctl_table nf_log_sysctl_table[NFPROTO_NUMPROTO+1];
> +static struct ctl_table_header *nf_log_dir_header;
> +
> +static int nf_log_proc_dostring(ctl_table *table, int write, struct file *filp,
> +			 void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	const struct nf_logger *logger;
> +	int r;
> +	char ln_name[NFLOGGER_NAME_LEN];
> +
> +	rcu_read_lock();
> +	if (write) {
> +		if (!strnicmp(buffer, "NONE", *lenp - 1)) {
> +			rcu_read_unlock();
> +			return nf_log_unbind_pf(table->ctl_name);
> +		}
> +		logger = __find_logger_n(table->ctl_name, buffer, *lenp -1);
> +		if (logger == NULL) {
> +			rcu_read_unlock();
> +			return -EINVAL;
> +		}
> +		r = nf_log_bind_pf(table->ctl_name, logger);

I doubt that RCU read lock is really what you want here since you're
actively changing things.
