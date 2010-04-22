From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xtables: inclusion of xt_condition
Date: Thu, 22 Apr 2010 13:24:50 +0200
Message-ID: <4BD03202.3070100@trash.net>
References: <1271856792-20872-1-git-send-email-jengelh@medozas.de> <1271856792-20872-2-git-send-email-jengelh@medozas.de> <4BCF001D.4090304@trash.net> <alpine.LSU.2.01.1004220100530.6257@obet.zrqbmnf.qr> <4BD02FAA.7000207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab0DVLYv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Apr 2010 07:24:51 -0400
In-Reply-To: <4BD02FAA.7000207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> This looks better, thanks. A few remaining questions about things
> I missed previously:
> 
> Jan Engelhardt wrote:
>> +static int condition_mt_check(const struct xt_mtchk_param *par)
>> +{
>> +	...
>> +	/* Create the condition variable's proc file entry. */
>> +	var->status_proc = create_proc_entry(info->name, condition_list_perms,
>> +			   proc_net_condition);
> 
> proc_net_condition is a global variable, so this won't work for
> namespaces. What the code does is reinitialize it when instantiating
> a new namespace, so it will always point to the last instantiated
> namespace.
> 
> The same problem exists for the condition_list, each namespace
> should only be able to access its own conditions.

This also applies to the permission variables. Basically, we shouldn't
be having any globals except perhaps the mutex. You probably need a
module_param_call function to set them for the correct namespace (you
can access that through current->nsproxy->net_ns).

>> +static struct xt_match condition_mt_reg __read_mostly = {
>> +	.name       = "condition",
>> +	.revision   = 1,
> 
> Why are we starting with revision 1?
> 
>> +	.family     = NFPROTO_UNSPEC,
>> +	.matchsize  = sizeof(struct xt_condition_mtinfo),
>> +	.match      = condition_mt,
>> +	.checkentry = condition_mt_check,
>> +	.destroy    = condition_mt_destroy,
>> +	.me         = THIS_MODULE,
>> +};
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

