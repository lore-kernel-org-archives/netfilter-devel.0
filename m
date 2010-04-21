From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Wed, 21 Apr 2010 15:39:41 +0200
Message-ID: <4BCF001D.4090304@trash.net>
References: <1271856792-20872-1-git-send-email-jengelh@medozas.de> <1271856792-20872-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41355 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0DUNjn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Apr 2010 09:39:43 -0400
In-Reply-To: <1271856792-20872-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> xt_condition can be used by userspace to influence decisions in rules
> by means of togglable variables without having to reload the entire
> ruleset.

> +
> +	var->refcount = 1;
> +	var->enabled  = false;
> +	var->status_proc->data = var;
> +	wmb();

Jan, while I'm pretty patient, I don't appreciate having to repeat
the same thing multiple times:

>> Please always comment the use of memory barriers.


> +static int __net_init condnet_mt_init(struct net *net)
> +{
> +	int ret;
> +
> +	proc_net_condition = proc_mkdir(dir_name, net->proc_net);
> +	if (proc_net_condition == NULL)
> +		return -EACCES;
> +
> +	ret = xt_register_match(&condition_mt_reg);

This is really starting to annoy me. Please read what I wrote,
take your time, test the patch and then resend it.

