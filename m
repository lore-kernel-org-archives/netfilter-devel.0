Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A69436BC8
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 21:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790111053; cv=none; b=eJpbrZIYm9N3fjqPRx/ogDPxQaryZcbMsLkd0Z5AFM0N8WnwA6lHFqbvCVXCMfxRYds/Uw4AA0bwSAUK9nkLCxotmZJmc5M6R7g+qRwL6/OxexH5dYWYskxH09Se+tY97lHjCfHxOGwG91WwMDmr7nK1nXMw7gEKSLG6uS4PvBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790111053; c=relaxed/simple;
	bh=VeD7ldMNDulebSD8WS6suEX2w1ekZyegq54bQA2ljOU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KrtfyEZ820FKhhxov2IqEg0A+TOZsZ52bjNpVOk4tarsV8AgMQgDs1nu4ABXMw9yjq3JbH0bz0Hs6tgBN33N0Bg4+KDenxejeU4BvcgqLR6G/yFVVdcLDpMsJ31gZjgHCN1njZy9IcV99Bdt3JA0YU5ELkk7ZAPays/EgUatbVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 09B2F60301; Tue, 22 Sep 2026 23:03:50 +0200 (CEST)
Date: Tue, 22 Sep 2026 23:03:49 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <weir@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, kaber@trash.net,
	vega@nebusec.ai, caoruide123@gmail.com
Subject: Re: [PATCH nf 1/1] netfilter: ecache: bound destroy event redelivery
Message-ID: <arLtL4Azj6d7Juxe@strlen.de>
References: <cover.1787158072.git.vega.cover-letter@nebusec.ai>
 <48840876b129e0094fbd8048e96fb6e3fae51055.1787158072.git.vega.cover-letter@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48840876b129e0094fbd8048e96fb6e3fae51055.1787158072.git.vega.cover-letter@nebusec.ai>

Ren Wei <weir@nebusec.ai> wrote:
> From: Ruide Cao <caoruide123@gmail.com>
> 
> A conntrack whose destroy event cannot be delivered is kept on the
> per-netns ecache list while the workqueue retries the notification.
> The worker stops at the first failure and retries every 10 ms without
> a lifetime limit. A listener that enables NETLINK_BROADCAST_ERROR and
> never drains its receive queue can therefore retain conntracks and
> keep the worker busy indefinitely.

Yes, that's by design.  This feature intentionally blocks new
conntracks.

> +	if (!cnet->ecache.retry_deadline)
> +		cnet->ecache.retry_deadline = jiffies + ECACHE_RETRY_TIMEOUT;
> +
> +	if (time_after_eq(jiffies, cnet->ecache.retry_deadline)) {
> +		hlist_nulls_for_each_entry_safe(h, n, &cnet->ecache.dying_list,
> +						hnnode) {
> +			struct nf_conn *ct = nf_ct_tuplehash_to_ctrack(h);
> +
> +			hlist_nulls_del_rcu(&ct->tuplehash[IP_CT_DIR_ORIGINAL].hnnode);
> +			hlist_nulls_add_head(&ct->tuplehash[IP_CT_DIR_REPLY].hnnode,
> +					     &evicted_list);
> +		}
> +		ret = STATE_DONE;
> +		goto out_unlock;
> +	}

I doubt this is correct.  Userspace that can deal with missing destroy
events SHOULD NOT enable reliable event delivery mode.
