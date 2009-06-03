From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 9/9] netfilter: conntrack: replace notify chain by function
 pointer
Date: Wed, 03 Jun 2009 08:24:17 +0200
Message-ID: <4A261711.1020208@trash.net>
References: <20090602181336.18573.85368.stgit@Decadence> <20090602182115.18573.84532.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58088 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbZFCGYT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:24:19 -0400
In-Reply-To: <20090602182115.18573.84532.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> -int nf_ct_expect_unregister_notifier(struct notifier_block *nb)
> +int nf_ct_expect_unregister_notifier(struct nf_exp_event_notifier *new)
>  {
> -	return atomic_notifier_chain_unregister(&nf_ct_expect_chain, nb);
> +	int ret = 0;
> +	struct nf_exp_event_notifier *notify;
> +
> +	mutex_lock(&nf_ct_ecache_mutex);
> +	notify = rcu_dereference(nf_expect_event_cb);
> +	if (notify != new) {
> +		ret = -EINVAL;
> +		goto out_unlock;
> +	}

I think these unregistration functions should return void. The only
reason why they don't currently is because the notifier_chain_unregister
function for some unknown reasons don't return void, but there's
a) nothing the caller could possibly do to handle this and b) a bug
anyways. So I'd suggest to just unconditionally assign NULL.

Sorry for not bringing this up earlier.

BTW, you might also consider marking the callback pointers read_mostly.

> +	rcu_assign_pointer(nf_expect_event_cb, NULL);
> +	mutex_unlock(&nf_ct_ecache_mutex);
> +	return ret;
> +
> +out_unlock:
> +	mutex_unlock(&nf_ct_ecache_mutex);
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(nf_ct_expect_unregister_notifier);
