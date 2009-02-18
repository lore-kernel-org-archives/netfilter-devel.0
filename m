From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] netfilter: sysctl support of logger choice.
Date: Wed, 18 Feb 2009 16:56:02 +0100
Message-ID: <499C2F92.3080105@trash.net>
References: <49980BA7.2040108@inl.fr> <1234701437-2754-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56638 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZBRP4F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:56:05 -0500
In-Reply-To: <1234701437-2754-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> +static int nf_log_proc_dostring(ctl_table *table, int write, struct file *filp,
> +			 void *buffer, size_t *lenp, loff_t *ppos)
> +{
> +	const struct nf_logger *logger;
> +	int r = 0;
> +
> +	if (write) {
> +		if (!strnicmp(buffer, "NONE", *lenp - 1)) {
> +			return nf_log_unbind_pf(table->ctl_name);
> +		}
> +		mutex_lock(&nf_log_mutex);
> +		logger = __find_logger(table->ctl_name, buffer);
> +	...

> +static int netfilter_log_sysctl_init(void)
> +{
> +	int i;
> +
> +	for (i = NFPROTO_UNSPEC; i < NFPROTO_NUMPROTO; i++) {
> +		char *pr_name = kmalloc(3, GFP_KERNEL);
> +		/* FIXME free at deinit but there is currently no deinit */
> +		snprintf(pr_name, 3, "%d", i);
> +		nf_log_sysctl_table[i].ctl_name	= i;

This ctl_name use seems rather abusive. The names are used
as numeric identifiers, we can't just stuff index values in
there :)
