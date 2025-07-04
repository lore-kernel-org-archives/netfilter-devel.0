Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFB622FF2E;
	Fri,  4 Jul 2025 19:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751657959; cv=none; b=cYIH0D+I7DHhCpTgExR4RLiFESg83+Lt6ktc9vAIoP/I2k+u7JmGKiDbLL+BSk/o5bXbIsbaTLT1hwqe5keLScpVPm2yxN5au3f1oEKk3TubN7J0QnP56cV1AStB7H8+ZC9EZD2EGYJ4OhrhTgofxH1XeoytZTZlNxdpqfoaZao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751657959; c=relaxed/simple;
	bh=lPHtRsVC8ACE7H3Qk0sZVKAmOHVHICOKr2a/g9a9GZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/+lD+4zbOv3dnjhZC2jfeCiI+XDlMbzhKqra9UXHuvis93kxxOdR0R3hgWm3NHujny1af1s1vpTJvZ5NN6DIVZMxMKA4mU8o5BCIiOK4rFWm7sVIJVYulN+CHrSor9hdgAMcIB93Ckyt+LQlI34aTrfQa3cr8QjRdV5/TMewmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DA62561260; Fri,  4 Jul 2025 21:39:13 +0200 (CEST)
Date: Fri, 4 Jul 2025 21:39:13 +0200
From: Florian Westphal <fw@strlen.de>
To: Eric Woudstra <ericwouds@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org
Subject: Re: [PATCH v13 nf-next 1/3] netfilter: utils: nf_checksum(_partial)
 correct data!=networkheader
Message-ID: <aGgt4dUF2AsDXzdX@strlen.de>
References: <20250704191135.1815969-1-ericwouds@gmail.com>
 <20250704191135.1815969-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250704191135.1815969-2-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> In the conntrack hook it may not always be the case that:
> skb_network_header(skb) == skb->data.
> 
> This is problematic when L4 function nf_conntrack_handle_packet()
> is accessing L3 data. This function uses thoff and ip_hdr()
> to finds it's data. But it also calculates the checksum.
> nf_checksum() and nf_checksum_partial() both use lower skb-checksum
> functions that are based on using skb->data.
> 
> When skb_network_header(skb) != skb->data, adjust accordingly,
> so that the checksum is calculated correctly.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/netfilter/utils.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
> index 008419db815a..daee035c25b8 100644
> --- a/net/netfilter/utils.c
> +++ b/net/netfilter/utils.c
> @@ -124,16 +124,21 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
>  		    unsigned int dataoff, u8 protocol,
>  		    unsigned short family)
>  {
> +	unsigned int nhpull = skb_network_header(skb) - skb->data;
>  	__sum16 csum = 0;
>  
> +	if (!pskb_may_pull(skb, nhpull))
> +		return -ENOMEM;

Hmm.  Not sure about this.  We should really audit all conntrack users
to make sure the network header is in the linear area, i.e.
ip_hdr() and friends return the right value, even though skb->data !=
skb_network_header().

Such may_pull, in case of skb->head reallocation, invalidate a pointer
to e.g. ethernet header in the caller.

No idea if we have callers that do this, I did not check, but such
"hidden" pulls tend to cause hard to spot bugs.

Maybe use
       if (WARN_ON_ONCE(skb_pointer_if_linear())
		return 0;

instead?  That allows to track down any offenders.  Given conntrack
takes presence of the l3 header in the linear area for granted, I don't
see how this can ever trigger.  You could also use
DEBUG_NET_WARN_ON_ONCE if you prefer, given this condition should never
be true anyway.
