Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB4309F1D;
	Tue,  5 May 2026 09:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777972765; cv=none; b=JARL8b4o00Z3eUjyjDmIzN71hAv60jo7O/keG0+XExq2qS3Mn8fpH8lLW+gtwKGk5fMSiJv3bVzVjd4b7nnRWI6DrSyjtF6pZwdjwup5F6KDGVUW+QZOpbCGbC5++PsRRJOh90Wl5SXUPhsHLaGFkdyiBUtur+0mM/yfOai8iww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777972765; c=relaxed/simple;
	bh=Sa1cZpOj2vBVDkew0f+0GqoneqbSh2eHUpErybrPNVQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k74Vg9A+110Z61hjWpT07Raw2csYb6e0QgLdY9l40CKuPpRldNwNq0mvbY/MTSBLDGjOTkZYnKrXePz2+cWhbxhMQLuhliboomgY7qydcQQu8F9L6qT89qyZcvnpr8UbL6ctsU34XtMKEuiB0MIs/B8DcTcTYR8EyuzwNsYdx+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=nO44IJFL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="nO44IJFL"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 32E6F600B5;
	Tue,  5 May 2026 11:19:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777972761;
	bh=/jvsMDAng95ZDXouFnr0lTKBoKIcHWdA0+U30YrDN0A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nO44IJFLaNffpH/icrQrgPj74VxOP1bbmvcMCae7UClnGEkGSWi9gZ4GxQMJo0NUA
	 mKAQXnYMuTBspoN3b0PQgJxjAKIa/lsyosa4RQa9a6jxvN8OpM65ZIT7Z7DX7PDSeZ
	 3bLlykSBup06TzgXRTiMavS589KX/CCwQoy1rhrJE74UdA20iUVrlz/8skaWeny0u+
	 LyG/VgDqC6oI+6faWZ4h8rcgku5p6Pjj8qI5854JwemLKDvx7bJt9TDS9tFBKF3L0m
	 mTANgiJJ/i3VkDhbSkPkgnUv3hpcvMwSUdCA4DB9LEOrh3N++yZwDs4Z8Ksdi/uLEg
	 LtRFTH9oVvspg==
Date: Tue, 5 May 2026 11:19:18 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Pratham Gupta <pratham36gupta@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, horms@kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net] netfilter: ctnetlink: use nf_ct_exp_net() in
 expectation dump
Message-ID: <afm2FhEytJzShYhk@chamomile>
References: <20260505051157.3895177-1-pratham36gupta@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260505051157.3895177-1-pratham36gupta@gmail.com>

Hi,

This is nf-next material.

On Mon, May 04, 2026 at 10:11:57PM -0700, Pratham Gupta wrote:
> Commit 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
> introduced exp->net so RCU-only expectation paths no longer need to
> dereference exp->master for netns lookups.
> 
> Commit 3db5647984de ("netfilter: nf_conntrack_expect: skip expectations in other netns via proc")
> updated the proc path accordingly, but ctnetlink_exp_dump_table() still
> compares against nf_ct_net(exp->master).

There was no check in the /proc path.

> Use nf_ct_exp_net(exp) here as well so the netlink dump path matches
> the rest of the March 2026 expectation netns/RCU cleanup.

yes, this is a leftover, but it is safe to access 

> Fixes: 02a3231b6d82 ("netfilter: nf_conntrack_expect: store netns and zone in expectation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pratham Gupta <pratham36gupta@gmail.com>
> ---
> Tested expectation create/dump/delete on the host and in fresh Ubuntu 24.04
> Docker userspace. Concurrent namespace churn/dump testing did not reproduce
> a cross-netns leak.

What cross-netns leak are you refering? This is simply using the
conntrack netns instead of exp->netns which was added in 02a3231b6d82.

This is nf-next material.

>  net/netfilter/nf_conntrack_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index eda5fe4a75c8..8ae3f6acc2d2 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -3158,7 +3158,7 @@ ctnetlink_exp_dump_table(struct sk_buff *skb, struct netlink_callback *cb)
>  			if (l3proto && exp->tuple.src.l3num != l3proto)
>  				continue;
>  
> -			if (!net_eq(nf_ct_net(exp->master), net))
> +			if (!net_eq(nf_ct_exp_net(exp), net))
>  				continue;
>  
>  			if (cb->args[1]) {
> -- 
> 2.43.0
> 
