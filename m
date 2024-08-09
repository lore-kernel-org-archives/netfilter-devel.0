Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F8418F2D5;
	Fri,  9 Aug 2024 09:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723194163; cv=none; b=tNOVLt9s3yglvlNdO7I9sat6cdHbsnZbC9gIVJM43Fs7R36VMapewPQT/28UzHRf1k1FylQaa6mpF91WQgYD6gHCwSkx56ImPaqgGWqOKq8i+riOq138ZDpkfpHF7qggSVdjY2LAQqBTX7Byw1uoOLU/mezqdYtb2hspcTAZzUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723194163; c=relaxed/simple;
	bh=hBHeguOdflqTH8+5uSyjB0gCEXGFMLt5LH+7j/AhCbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BkJxANtyK72EUsTobUmqWK4oNXJdOL6AkmqVrEx4QzI58eyV6S9Yv36Xyent5fJiVslDA2z4UGpJ8drE5gUsKDMu1IUahXh1h8tYqM6rxtTKFQ+p2VD+4GuUg2Fmodx2zkuUj62/EWBbMrlEkMr2D1D6F1f2V0Vk3BmqL3oesrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LrqF5cvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LrqF5cvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF380C32782;
	Fri,  9 Aug 2024 09:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723194163;
	bh=hBHeguOdflqTH8+5uSyjB0gCEXGFMLt5LH+7j/AhCbA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LrqF5cvokdWWOZDZxnNANAuTot2H/dRMGiiOGgavyijb000d6D+7WH9Fn0UEBC8Aj
	 I2jiK7izqNRYKdMXK0OGnSS/YLH5ok2ijF3welE5d2bQdvEcIyputNv2vVJOCJz5eC
	 ungsGEZAGJAhJ7xwG0iK4rR2C8qH8rTl+jw9hlDPouaJE/rVtLngDaCDWMNEXKhNQh
	 81EYp9oRUYFd8dk1IQPPpxKYs147VWSP+yKlKppBhDfxb1QCXA3umGIb7jrSgyAd6Z
	 4kAGCX7pnYJNpyG+DET1fojzY6Ke4ITRHzcQIrEDeZ8GdHMfvR/7kyAKQO4+UDJnLm
	 9WBWE+U+kSzhw==
Date: Fri, 9 Aug 2024 10:02:38 +0100
From: Simon Horman <horms@kernel.org>
To: Donald Hunter <donald.hunter@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	donald.hunter@redhat.com
Subject: Re: [PATCH nf v1] netfilter: nfnetlink: Initialise extack before use
 in ACKs
Message-ID: <20240809090238.GF3075665@kernel.org>
References: <20240806154324.40764-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240806154324.40764-1-donald.hunter@gmail.com>

On Tue, Aug 06, 2024 at 04:43:24PM +0100, Donald Hunter wrote:
> Add missing extack initialisation when ACKing BATCH_BEGIN and BATCH_END.
> 
> Fixes: bf2ac490d28c ("netfilter: nfnetlink: Handle ACK flags for batch messages")
> Signed-off-by: Donald Hunter <donald.hunter@gmail.com>

Hi Donald,

I see two other places that extack is used in nfnetlink_rcv_batch().
Is it safe to leave them as-is?

> ---
>  net/netfilter/nfnetlink.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 4abf660c7baf..932b3ddb34f1 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -427,8 +427,10 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  
>  	nfnl_unlock(subsys_id);
>  
> -	if (nlh->nlmsg_flags & NLM_F_ACK)
> +	if (nlh->nlmsg_flags & NLM_F_ACK) {
> +		memset(&extack, 0, sizeof(extack));
>  		nfnl_err_add(&err_list, nlh, 0, &extack);
> +	}
>  
>  	while (skb->len >= nlmsg_total_size(0)) {
>  		int msglen, type;
> @@ -577,6 +579,7 @@ static void nfnetlink_rcv_batch(struct sk_buff *skb, struct nlmsghdr *nlh,
>  			ss->abort(net, oskb, NFNL_ABORT_NONE);
>  			netlink_ack(oskb, nlmsg_hdr(oskb), err, NULL);
>  		} else if (nlh->nlmsg_flags & NLM_F_ACK) {
> +			memset(&extack, 0, sizeof(extack));
>  			nfnl_err_add(&err_list, nlh, 0, &extack);
>  		}
>  	} else {
> -- 
> 2.45.2
> 
> 
