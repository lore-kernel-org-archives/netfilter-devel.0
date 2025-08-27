Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833402773E0;
	Wed, 27 Aug 2025 09:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756285545; cv=none; b=PyGkPHz5QJl4Mfa8FTabcxDBbFbXu3uQ2S9XGGlxg0QNWXOFsncmX5tftzYZ97BttBF3Z092VKdk3dc5OX7Y8W8rLTEiLwDNj2+CN7YgFsdU2jVxlbPMw2w7otQN9GNs9tYaX7ix3VWtM2qSpHMQJISC+TOn8JJXciqvVG9ufH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756285545; c=relaxed/simple;
	bh=/h3xpP3SQsj84vxwNu4spLGJtFUGbyuVogajnVLgFvk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iRNP73Nyo2zoRIPmFb6A+5ZyEKb7NpMGfq86sOAWc3MxMmMBWVS/ZPPjHGgh65Skt3J+Toi6WgExzBlB5ITQAN6uPFew2qGOyicAN94WhTeR+voUeEwQapHMfzg7g21FolWf9zWS6GPsjEWsI0cEgyyXnLIQNmG4O/TEaipsesM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C0CD2601EB; Wed, 27 Aug 2025 11:05:38 +0200 (CEST)
Date: Wed, 27 Aug 2025 11:05:38 +0200
From: Florian Westphal <fw@strlen.de>
To: Fabian =?iso-8859-1?Q?Bl=E4se?= <fabian@blaese.de>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v2] icmp: fix icmp_ndo_send address translation for reply
 direction
Message-ID: <aK7KYr5D7bD3OcHb@strlen.de>
References: <20250825201717.3217045-1-fabian@blaese.de>
 <20250825203826.3231093-1-fabian@blaese.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250825203826.3231093-1-fabian@blaese.de>

Fabian Bläse <fabian@blaese.de> wrote:
> The icmp_ndo_send function was originally introduced to ensure proper
> rate limiting when icmp_send is called by a network device driver,
> where the packet's source address may have already been transformed
> by NAT or MASQUERADE.
> 
> However, the implementation only considered the IP_CT_DIR_ORIGINAL case
> and incorrectly applies the same logic to packets in reply direction.
> 
> Therefore, an SNAT rule in the original direction causes icmp_ndo_send to
> translate the source IP of reply-direction packets, even though no
> translation is required. The source address is translated to the sender
> address of the original direction, because the original tuple's source
> address is used.
> 
> On the other hand, icmp_ndo_send incorrectly misses translating the
> source address of packets in reply-direction, leading to incorrect rate
> limiting. The generated ICMP error is translated by netfilter at a later
> stage, therefore the ICMP error is sent correctly.
> 
> Fix this by translating the address based on the connection direction:
> - CT_DIR_ORIGINAL: Use the original tuple's source address
>   (unchanged from current behavior)
> - CT_DIR_REPLY: Use the reply tuple's source address
>   (fixing the incorrect translation)

>  	ct = nf_ct_get(skb_in, &ctinfo);
> -	if (!ct || !(ct->status & IPS_SRC_NAT)) {
> +	if (!ct) {
> +		__icmp_send(skb_in, type, code, info, &opts);
> +		return;
> +	}

I don't understand this part.  You talk about snat, yet you remove
the check for its absence here.  Why?

If the connection isn't subject to snat, why to we need to mangle the
source address in the first place?

If you are worried about "dnat to", then please update the commit
message, which only mentions masquerade/snat.

> +	if ( !(ct->status & IPS_SRC_NAT && CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL)
> +		&& !(ct->status & IPS_DST_NAT && CTINFO2DIR(ctinfo) == IP_CT_DIR_REPLY)) {
>  		__icmp_send(skb_in, type, code, info, &opts);
>  		return;
>  	}

Don't understand this either.  Why these checks?
AFAICS you can keep the original check in place, and then:

replace this
>  	orig_ip = ip_hdr(skb_in)->saddr;
> -	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;

... with ...

enum ip_conntrack_dir dir = CTINFO2DIR(ctinfo);
ip_hdr(skb_in)->saddr = ct->tuplehash[dir].tuple.src.u3.ip;

... at least, thats what I gather from your commit message.

For original direction, there is no change compared to existing code (dir == 0).
For reply direction, saddr is replaced with the source of the reply tuple.

Without dnat, the reply tuple saddr == original tuple daddr.

With dnat, its the dnat targets' address (i.e., the real destination
the client is talking to).

Did I get anything wrong?
