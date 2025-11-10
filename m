Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901932F0C69
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Nov 2025 20:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762807464; cv=none; b=S0WB5oT2+R+5/nJrhc9b17aElX2YkHPClzZ/Ya2uoBzEKnFraSCkSS7kRAhnLj3IJkREedrxt27PNxB8xEUMcnzeFc1sQaAnB8A3yrQT91MHLkD0Tb4tWtQuT/tKbDo51FA7KYIns4SBX+EU2CPZ2ztu9wp95PWZu2IPJEqHvwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762807464; c=relaxed/simple;
	bh=YCKA7ljmPnMfiLB0AZyXHH0P/QDwDDVqwlwWka7f81U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQZk1KpC4QWy75jPQZ1NO17ZBWTtQtI0PxQBbmB41X+KulR+ZR5Zso7NxXurFjjzCg49U6/2Xp1RJDUy6qvr6cBlJBUMck/D16EXoVtfcvZowk9Sd4BUh1cpMIgnueWDdt8tFcCSOzy3zkIHz/p1Rl5WfdJoMQZOhN+OEb8lIXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 378AD604EE; Mon, 10 Nov 2025 21:44:19 +0100 (CET)
Date: Mon, 10 Nov 2025 21:44:19 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, aconole@redhat.com,
	echaudro@redhat.com, i.maximets@ovn.org
Subject: Re: [PATCH 2/4 nf-next v2] netfilter: nf_conncount: only track
 connection if it is not confirmed
Message-ID: <aRJOo4bN1DEhYvE7@strlen.de>
References: <20251110154249.3586-1-fmancera@suse.de>
 <20251110154249.3586-3-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110154249.3586-3-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
> index 0189f8b6b0bd..8c21890e4536 100644
> --- a/net/netfilter/xt_connlimit.c
> +++ b/net/netfilter/xt_connlimit.c
> @@ -29,24 +29,16 @@
>  static bool
>  connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
>  {
> -	struct net *net = xt_net(par);
>  	const struct xt_connlimit_info *info = par->matchinfo;
> -	struct nf_conntrack_tuple tuple;
> -	const struct nf_conntrack_tuple *tuple_ptr = &tuple;
> -	const struct nf_conntrack_zone *zone = &nf_ct_zone_dflt;
> -	enum ip_conntrack_info ctinfo;
> -	const struct nf_conn *ct;
> +	struct net *net = xt_net(par);
>  	unsigned int connections;
> +	bool refcounted = false;
> +	struct nf_conn *ct;
>  	u32 key[5];
>  
> -	ct = nf_ct_get(skb, &ctinfo);
> -	if (ct != NULL) {
> -		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
> -		zone = nf_ct_zone(ct);
> -	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
> -				      xt_family(par), net, &tuple)) {
> +	ct = nf_ct_get_or_find(net, skb, xt_family(par), &refcounted);
> +	if (!ct)
>  		goto hotdrop;
> -	}

This can't work this way for -t raw use case, which we need
to preserve.

Anyone who uses -t raw ... -m connlimit ...

will now have their packets dropped, so no connection
can make forward progress (not even when using iptables --syn).

We need to get rid of the
        if ((u32)jiffies == list->last_gc)
                goto add_new_node;

check in nf_conncount_add(), or, (to not add perf regress for ovs ...)
apply it when a (confirmed) conntrack entry is present.

Given that limitation, I don't think this nf_ct_get_or_find() helper
makes any sense, since you still need to pass the tupleptr down
to count_tree().

I think passing in the sk_buff is better, so all of this
conntrack/tuple/zone etc. stuff is hidden away in nf_conncount.c.

I think you could start by *adding*

unsigned int nf_conncount_count_skb(struct net *net,
				    const struct sk_buff *skb,
				    struct nf_conncount_data *data,
				    const u32 *key);

As frontend function for nf_conncount_count().
This new function could (re)use some of the code you made
for nf_ct_get_or_find(), the zone usage there looks correct
to me.

Then, in patch 2, convert -m connlimit.
You could send that as an initial patch set already.

Then, in patch 3 (or later followup patch set), convert remaining user
(ovs) and hide old api.

Then, in patch 4, start pushing down the sk_buff more in nf_conncount.c
until its available for nf_conncount_add().

Then, add nf_conncount_add_skb and repeat this process.

Does that make sense?
