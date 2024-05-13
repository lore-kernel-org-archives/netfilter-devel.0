Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0601DA24
	for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2024 21:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715634874; cv=none; b=iDR0drx6nFJS7ITNxeGOLpTIde1H6rkQiJxAt20Tc4526DJ5eUgF9IIEpAdZFJK4WEo6f6i90Aoazkeow2BzOsEtOkLHQZaeccujU2xNRprob8o8aiaLzxDhH+Uxdmy+orcK3691iHo/71JaUcBBieBJsaGrNQrOqNCSjesjw08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715634874; c=relaxed/simple;
	bh=7tTn8mbK8zUAh7HlLlyce/PSV9f7j6XkXZVOu01YrTI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bh2qG4OWJ7g89S6rTTA7rkZptNoC5IWSJSICRAHF+1Q1EBT5sLuTQmNQwyNldbzw1C5AhJDG3rbkq76Vcc9pzp3i1jStzHJvGZEYwmg0iWUs+BdKc/LWNDXctOI1TCJcOeNoCZsFyHKwQN5FUuM3fP5BP80swnISeRr5xXZrOK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1s6d09-0004fF-7q; Mon, 13 May 2024 23:14:29 +0200
Date: Mon, 13 May 2024 23:14:29 +0200
From: Florian Westphal <fw@strlen.de>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de
Subject: Re: [PATCH v2 1/2] netfilter: nft_queue: compute SCTP checksum
Message-ID: <20240513211429.GA17004@breakpoint.cc>
References: <20240513000953.1458015-1-aojea@google.com>
 <20240513000953.1458015-2-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240513000953.1458015-2-aojea@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Antonio Ojea <aojea@google.com> wrote:
> when packet is enqueued with nfqueue and GSO is enabled, checksum
> calculation has to take into account the protocol, as SCTP uses a
> 32 bits CRC checksum.
> 
> Signed-off-by: Antonio Ojea <aojea@google.com>
> ---
> V1 -> V2: add a helper function to process the checksum
> 
>  net/netfilter/nfnetlink_queue.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index 00f4bd21c59b..accf4942d9ff 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -538,6 +538,14 @@ static int nfqnl_put_bridge(struct nf_queue_entry *entry, struct sk_buff *skb)
>  	return -1;
>  }
>  
> +static int nf_queue_checksum_help(struct sk_buff *entskb)
> +{
> +  if (skb_csum_is_sctp(entskb))
> +    return skb_crc32c_csum_help(entskb);

This should be tabs, please run your patch through checkpatch.pl.
