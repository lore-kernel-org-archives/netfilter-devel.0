Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FEF11A23BB
	for <netfilter-devel@vger.kernel.org>; Wed, 21 May 2025 14:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747837508; cv=none; b=q+C20MB13pbvZA6wcrCMKMJOyvoROiht/nEbYHP945Fg+Mq85fJhUol6Pvs9z2ynx3SNosP4AL8jFQWbkDVcXEEVyhvEpxabVWsY47lFKiiq0khueJqB/l2dlCy4xawxmPOmm0NVQ3zU3pIpHEOXVcIL0c21CyjYmOli07r87zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747837508; c=relaxed/simple;
	bh=V42T8679sNtmwXs476+536EWzNmoMmsKIp2yKme6qlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eAWu9n+sKdQ2I8AkAndCKK/IJsLwm/Ftpe4KbY2PooD7ja8PwpA+dwMuLoxjtz26p514ZI/8dvMAolgNstDOzVjqEiNjd2bPjb0h3sFFlqrc4imtekkRmX4cGMpi2BbpQ4iN4UM/+e+g6LKXUn51pyoNVLcSF4ddGgwa9aKxL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=MhD/N5cC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=juypBtWU; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="MhD/N5cC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="juypBtWU"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 746D1606E1; Wed, 21 May 2025 16:25:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747837505;
	bh=PpBcwD7Rxa+lIgM6iao6772ApqSOowl3mf/JaiM6zLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MhD/N5cChV8Tc6sCdRkykNbguZalCJNb2V4/jO//kt+/9dKzHX3GpORKBzYJEAgU6
	 tLVlAnv4pUcQN8/Ezk3i2BZPz31XuWGtJG9RwBm7eKZYfbcpFRMXq/BJMBeGYlW7lV
	 wE5/BRksgiLY8PAdhuMXBBCfcP50p6n1LuUtSZVPYU/M+20tpGbbpui9pCxJd5v9wH
	 Y8wUWynbjvxrnxxT6zvorc9YxtyXNcwvRp0jiE8OGLzLZWTvXN0009GjxaP2PEQBcM
	 LcuMqxAoFx9k4LHVFbGNdjE85hrUctUfmwoAcHDw28pJ5xZ0mb1OrdV+rbaHvWeR5E
	 uH/iO5a/mQtdQ==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 60E34606E1;
	Wed, 21 May 2025 16:25:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747837502;
	bh=PpBcwD7Rxa+lIgM6iao6772ApqSOowl3mf/JaiM6zLc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=juypBtWUwXcniznanbFZF2HtFdshcnTj+j9y4OraPYt0T+Ufct3uHsOLDWvgQvYUr
	 AL45vmwgeIFsVkSVl4/ajn79CJ23ziZ1L/rWPqZ0ejo3EA4jHRtKAqWbJY+ePPkvg8
	 AdjQbTuTr2W4AC4/t67bWiiTuCdpcFE8OJznKtXziP/IwIV5Q4yG0KKFmG9TIDSXLg
	 T7eAjoxiU7iSR3QvR/RcE7qlB1cXEBJzkLw5RK99oblJZyjKkWD0gS5SU60gmnhI82
	 uFV9oZNbrE4KRW+4pQS5unO4hSE/xBL1QoMSpR/O+H9Sm4w2KVC09c9pwE5YBL2UFL
	 TzGpXL998LZRw==
Date: Wed, 21 May 2025 16:24:59 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-rt-devel@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>
Subject: Re: [PATCH nf-next v1 1/3] netfilter: nf_dup{4, 6}: Move duplication
 check to task_struct
Message-ID: <aC3iO9FJo1FvdloW@calendula>
References: <20250512102846.234111-1-bigeasy@linutronix.de>
 <20250512102846.234111-2-bigeasy@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250512102846.234111-2-bigeasy@linutronix.de>

Hi Sebastian,

On Mon, May 12, 2025 at 12:28:44PM +0200, Sebastian Andrzej Siewior wrote:
[...]
> diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
> index 0c39c77fe8a8a..b903c62c00c9e 100644
> --- a/net/ipv6/netfilter/nf_dup_ipv6.c
> +++ b/net/ipv6/netfilter/nf_dup_ipv6.c
> @@ -48,7 +48,7 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
>  		 const struct in6_addr *gw, int oif)
>  {
>  	local_bh_disable();
> -	if (this_cpu_read(nf_skb_duplicated))
> +	if (current->in_nf_duplicate)

Netfilter runs from the forwarding path too, where no current process
is available.

>  		goto out;
>  	skb = pskb_copy(skb, GFP_ATOMIC);
>  	if (skb == NULL)
> @@ -64,9 +64,9 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
>  		--iph->hop_limit;
>  	}
>  	if (nf_dup_ipv6_route(net, skb, gw, oif)) {
> -		__this_cpu_write(nf_skb_duplicated, true);
> +		current->in_nf_duplicate = true;
>  		ip6_local_out(net, skb->sk, skb);
> -		__this_cpu_write(nf_skb_duplicated, false);
> +		current->in_nf_duplicate = false;
>  	} else {
>  		kfree_skb(skb);
>  	}
