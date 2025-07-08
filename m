Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 493D93B7A8;
	Tue,  8 Jul 2025 22:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752012054; cv=none; b=WI6n4D1NQKbctBe1jbc2IJn818DmGixbHq4DfZS8MCasaAyQje2qtadXx+BFjS9c5xBHoxNzKlZR17myAcxvjv7X+JFKfL+ZxpJNVfJHsPyK4Au6kSVZIb7S4jKo6WDd+wEakqwhbktpvt3JpkUWeNnpPQNSQaVvFNX5DkpO1PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752012054; c=relaxed/simple;
	bh=7mFXvMq75GS63cOsJInVGaQYLNjUOZSwMKZHP+mbRYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qNJulJ/0cwL/EXdeCMtBh4LvLwvxw4j7wj7JEHSJY2POJfxEQc/VqaJi+nof1xUHU+zAvambchnazToRhqSGj1NFblKAQg+XJDaXyCeZqsBjHuSUPafSWw+NUxvsxjZyva94vcOQFmJpgDVPCAWaESL9Xd2gB4XXzF6mm4FKIA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 2D2CF6122E; Wed,  9 Jul 2025 00:00:49 +0200 (CEST)
Date: Wed, 9 Jul 2025 00:00:47 +0200
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
Subject: Re: [PATCH v14 nf-next 2/3] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <aG2VDyHfVsp5L2zR@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708151209.2006140-3-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> This adds the capability to conntrack 802.1ad, QinQ, PPPoE and PPPoE-in-Q
> packets that are passing a bridge, only when a conntrack zone is set.
> 
> Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 88 ++++++++++++++++++----
>  1 file changed, 72 insertions(+), 16 deletions(-)
> 
> +			data_len = ntohs(ph->hdr.length) - 2;

Shouldn't there be some validation on data_len here?

> +		if (!pskb_may_pull(skb, offset + sizeof(struct iphdr)))
> +			goto do_not_track;
 
>  		len = skb_ip_totlen(skb);
> -		if (pskb_trim_rcsum(skb, len))
> -			return NF_ACCEPT;
> +		if (data_len < len)
> +			len = data_len;

Hmm.  So if ph->hdr.length is smaller than what ip header claims,
len shrinks.

If its higher, then the mismatch is ignored and we only use
the ip header length (i.e., the smaller value).

> +		if (pskb_trim_rcsum(skb, offset + len))
> +			goto do_not_track;

Is the intent that garbage data_len is caught here and

>  		if (nf_ct_br_ip_check(skb))
> -			return NF_ACCEPT;

here?  If so, maybe a comment could help.

> +		goto do_not_track;
>  	}
>  
> -	if (ret != NF_ACCEPT)
> -		return ret;
> +	if (ret == NF_ACCEPT)
> +		ret = nf_conntrack_in(skb, &bridge_state);
>  
> -	return nf_conntrack_in(skb, &bridge_state);
> +do_not_track:
> +	if (offset) {

if (ret == NF_ACCEPT && offset) { ...

Else skb could have been free'd. There should be test cases for this
functionality included.  If we lack test cases for the existing
functionality, which might be the case, please consider submitting
a reduced test case first so it can be applied regardless of the
remaining functionality.
