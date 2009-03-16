From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: sysctl support of logger choice.
Date: Mon, 16 Mar 2009 14:58:50 +0100
Message-ID: <49BE5B1A.6040407@trash.net>
References: <499DD499.50704@inl.fr> <1235080458-6623-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45583 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbZCPN6x (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 09:58:53 -0400
In-Reply-To: <1235080458-6623-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> +static int netfilter_log_sysctl_init(void)
> +{
> +	int i;
> +
> +	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
> +		char *pr_name = kmalloc(3, GFP_KERNEL);

This needs to check for allocation errors.

> +		/* FIXME free at deinit but there is currently no deinit */

And this needs to be fixed as well. If you want to simplify this, I'd
suggest to just use static storage.

> +		snprintf(pr_name, 3, "%d", i);
> +		nf_log_sysctl_table[i].ctl_name	= CTL_UNNUMBERED;
> +		nf_log_sysctl_table[i].procname	= pr_name;
> +		nf_log_sysctl_table[i].data = NULL;
> +		nf_log_sysctl_table[i].maxlen = NFLOGGER_NAME_LEN * sizeof(char);
> +		nf_log_sysctl_table[i].mode = 0644;
> +		nf_log_sysctl_table[i].proc_handler = nf_log_proc_dostring;
> +		nf_log_sysctl_table[i].extra1 = (void *)(unsigned long) i;
> +	}
> +
> +	nf_log_dir_header = register_sysctl_paths(nf_log_sysctl_path,
> +				       nf_log_sysctl_table);
> +
> +	return 0;
> +}
> +#else
> +static int netfilter_log_sysctl_init(void)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_SYSCTL */
>  
>  int __init netfilter_log_init(void)
>  {
> @@ -219,6 +292,9 @@ int __init netfilter_log_init(void)
>  		return -1;
>  #endif
>  
> +	if (netfilter_log_sysctl_init() < 0)
> +		return -1;

And this needs to use proper errno codes.

Well, nfnetlink_log_sysctl_init() should return proper errno codes
and this function should propagate them.

> +
>  	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++)
>  		INIT_LIST_HEAD(&(nf_loggers_l[i]));
>  

