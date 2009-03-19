From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: sysctl support of logger choice.
Date: Thu, 19 Mar 2009 10:45:35 +0100
Message-ID: <49C2143F.8070606@trash.net>
References: <1237331756.2708.41.camel@ice-age> <1237332458-25202-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63936 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754951AbZCSJpj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 05:45:39 -0400
In-Reply-To: <1237332458-25202-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patchs adds support of modification of the used logger via sysctl.
> It can be used to change the logger to module that can not use the bind
> operation (ipt_LOG and ipt_ULOG). For this purpose, it creates a
> directory /proc/sys/net/netfilter/nf_log which contains a file
> per-protocol. The content of the file is the name current logger (NONE if
> not set) and a logger can be setup by simply echoing its name to the file.
> By echoing "NONE" to a /proc/sys/net/netfilter/nf_log/PROTO file, the
> logger corresponding to this PROTO is set to NULL.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>

This seems fine apart from a few minor issues. No need to resend, just
let me know whether you agree to my changes. Thanks.

> -int __init netfilter_log_init(void)
> +static int nf_log_proc_dostring(ctl_table *table, int write, struct file *filp,
> +			 void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	const struct nf_logger *logger;
> +	int r = 0;
> +	int tindex = (unsigned long) table->extra1;
> +
> +	if (write) {
> +		if (!strnicmp(buffer, "NONE", *lenp - 1)) {

What is the motivation here for not doing a full comparison?
Suggested change: use strcmp

> +			nf_log_unbind_pf(tindex);
> +			return 0;
> +		}
> +		mutex_lock(&nf_log_mutex);
> +		logger = __find_logger(tindex, buffer);
> +		if (logger == NULL) {
> +			mutex_unlock(&nf_log_mutex);
> +			return -EINVAL;

ENOENT seems more approriate.

> +static int netfilter_log_sysctl_init(void)

__init?

> +int __init netfilter_log_init(void)
> +{
> +	int i, r;
>  #ifdef CONFIG_PROC_FS
>  	if (!proc_create("nf_log", S_IRUGO,
>  			 proc_net_netfilter, &nflog_file_ops))
>  		return -1;
>  #endif
>  
> +	r = netfilter_log_sysctl_init();
> +	if (r < 0)
> +		return r;

I previously didn't realize an error will cause a panic. I'll add a
comment explaning why unrolling is unnecessary.
