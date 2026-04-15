Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9403126F3B
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 09:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776245350; cv=none; b=dOfOrETDpUqZFOiwsZIB2muJSwMfSp5KyVzEbx3T4UOuanXYXT4ruLD3eY8zXEZyNMhCPITGldoebJn4l+RPTa82YwoHvzh2gWCjb09Gnxz0Qrg3N0skJq7wY2TrCdMZJ8bYwPq96iFC3hNY/rD15sYBn6JCNPg0W+pmD4nJ2Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776245350; c=relaxed/simple;
	bh=Dgi+U5jw2fB6poSTbVJmibOyuxoaS3yUYt6j3CFO3YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RCSMl2tDyFzNvUf7Y3CgO2KxpLgPQEYrlwUkHXUl1U8Noox7LIyNuxah673bCNVcMiMr4EFalNxnzy18JwfAi0iB2inzQyWW8h8AIK+TUotZNSlHfGZYVv6QiawLEkrLd+7wXpqkKKKARxntdSqblplai96cS1mIgbEGuOr9fYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=I2nGn6n/; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="I2nGn6n/"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 3E45660181;
	Wed, 15 Apr 2026 11:29:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776245346;
	bh=jZ36SaKO8d8PkNAOQEEQWaL917VrTFJeCvh3UcNW0RM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2nGn6n/6CHRT0eksXlTUzoBOfJK6sx/E3pL8eulPjuvdABnxcRF/FRxLox7sccCy
	 6oF4OQ6Zwmqm7dwcGE22vj/E7itzd+03UGcRTg/zTV8JqUCy82rQkmo2bKBHzui6/1
	 lMILf48gf97cyupPMzh94dTxwMfl7HrUUckJyUihz+C2noyi03Esct5IjJVVwt3WIk
	 lN7bnMOFQnSbORid0+aCF4b3j43zr+7Y5cgU63y6DflR23LkJv49d8DRi62cGzrrL9
	 kME0vLT24mX6dsy95/Un5FFYKYQ8SD2jN847wEt/adUhLnSLx3Ple6FKdbagSP04Oy
	 +BBvkWIfox7+w==
Date: Wed, 15 Apr 2026 11:29:03 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Xiang Mei <xmei5@asu.edu>
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, coreteam@netfilter.org,
	Weiming Shi <bestswngs@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nfnetlink_osf: fix divide-by-zero in
 OSF_WSS_MODULO
Message-ID: <ad9aX5IDPWt3F6OF@chamomile>
References: <20260414221401.2809350-1-xmei5@asu.edu>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260414221401.2809350-1-xmei5@asu.edu>

On Tue, Apr 14, 2026 at 03:14:01PM -0700, Xiang Mei wrote:
> nf_osf_match_one() computes ctx->window % f->wss.val in the
> OSF_WSS_MODULO branch with no guard for f->wss.val == 0. A
> CAP_NET_ADMIN user can add such a fingerprint via nfnetlink; a
> subsequent matching TCP SYN divides by zero and panics the kernel.
> 
> Reject the bogus fingerprint in nfnl_osf_add_callback() above the
> per-option for-loop. f->wss is per-fingerprint, not per-option, so
> the check must run regardless of f->opt_num (including 0). Also
> reject wss.wc >= OSF_WSS_MAX; nf_osf_match_one() already treats that
> as "should not happen".
> 
> Crash:
>  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
>  RIP: 0010:nf_osf_match_one (net/netfilter/nfnetlink_osf.c:98)
>  Call Trace:
>  <IRQ>
>   nf_osf_match (net/netfilter/nfnetlink_osf.c:220)
>   xt_osf_match_packet (net/netfilter/xt_osf.c:32)
>   ipt_do_table (net/ipv4/netfilter/ip_tables.c:348)
>   nf_hook_slow (net/netfilter/core.c:622)
>   ip_local_deliver (net/ipv4/ip_input.c:265)
>   ip_rcv (include/linux/skbuff.h:1162)
>   __netif_receive_skb_one_core (net/core/dev.c:6181)
>   process_backlog (net/core/dev.c:6642)
>   __napi_poll (net/core/dev.c:7710)
>   net_rx_action (net/core/dev.c:7945)
>   handle_softirqs (kernel/softirq.c:622)
> 
> Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
> Reported-by: Weiming Shi <bestswngs@gmail.com>
> Suggested-by: Florian Westphal <fw@strlen.de>
> Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
> Signed-off-by: Xiang Mei <xmei5@asu.edu>
> ---
> v2: Fix the bug in configure path and correct the fix tag
> 
>  net/netfilter/nfnetlink_osf.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
> index 45d9ad231..70172ca07 100644
> --- a/net/netfilter/nfnetlink_osf.c
> +++ b/net/netfilter/nfnetlink_osf.c
> @@ -320,6 +320,10 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
>  	if (f->opt_num > ARRAY_SIZE(f->opt))
>  		return -EINVAL;
>  
> +	if (f->wss.wc >= OSF_WSS_MAX ||
> +	    (f->wss.wc == OSF_WSS_MODULO && f->wss.val == 0))
> +		return -EINVAL;

Maybe, more explicit, it is more lengthy but cristal clear:

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index e8069f4e139b..357453e8c147 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -329,6 +329,19 @@ static int nfnl_osf_add_callback(struct sk_buff *skb,
                if (f->opt[i].kind == OSFOPT_MSS && f->opt[i].length < 4)
                        return -EINVAL;
 
+               switch (f->wss.wc) {
+               case OSF_WSS_PLAIN:
+               case OSF_WSS_MSS:
+               case OSF_WSS_MTU:
+                       break;
+               case OSF_WSS_MODULO:
+                       if (f->wss.val == 0)
+                               return -EINVAL;
+                       break;
+               default:
+                       return -EINVAL;
+               }
+
                tot_opt_len += f->opt[i].length;
                if (tot_opt_len > MAX_IPOPTLEN)
                        return -EINVAL;

> +
>  	for (i = 0; i < f->opt_num; i++) {
>  		if (!f->opt[i].length || f->opt[i].length > MAX_IPOPTLEN)
>  			return -EINVAL;
> -- 
> 2.43.0
> 
