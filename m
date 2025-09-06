Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7D5B131E2D;
	Sat,  6 Sep 2025 21:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757193005; cv=none; b=Sa2HaC4xfQaXg6DZllZJb73AtOoR00sTXcMeHO/8FveCG7dJMP5ev2zTZVblauOH5fbmKhE9XmptKyp1UvIS7s39DZR8oDXXuhrAJqVaOwodVYmTyCeYLF15Ld2oLqHFk9MSCYeg+4/1JwMyKecwR3UCj3Gl7rvXg9RcEUgz7Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757193005; c=relaxed/simple;
	bh=aE05Jvob0sDSVbL1cmt0RfJAftXOH5dW1daURhmnGbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iwqq47REZf4sO7skk1w8Uc/rhWSULCblMBIHh3g2Bj/oH277ooLKlpUPt2mcZUyC6CxxrlceEs7zFmrWABdyzFkqxX4U3F4j5ekArJLzsWeZnXm+c9x318DWDXxb+hl6ARjn91eFVVzHa8rBYzjSxpa5q26J+xO/t4UoRIi2G1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9F943604EE; Sat,  6 Sep 2025 23:09:54 +0200 (CEST)
Date: Sat, 6 Sep 2025 23:09:54 +0200
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
Subject: Re: [PATCH v14 nf-next 1/3] netfilter: utils: nf_checksum(_partial)
 correct data!=networkheader
Message-ID: <aLyjIuGj7BAEAO8B@strlen.de>
References: <20250708151209.2006140-1-ericwouds@gmail.com>
 <20250708151209.2006140-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250708151209.2006140-2-ericwouds@gmail.com>

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
>  net/netfilter/utils.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/net/netfilter/utils.c b/net/netfilter/utils.c
> index 008419db815a..9ba822983bc0 100644
> --- a/net/netfilter/utils.c
> +++ b/net/netfilter/utils.c
> @@ -124,16 +124,20 @@ __sum16 nf_checksum(struct sk_buff *skb, unsigned int hook,
>  		    unsigned int dataoff, u8 protocol,
>  		    unsigned short family)
>  {
> +	unsigned int nhpull = skb_network_header(skb) - skb->data;

skb_network_offset() ?

And can you add a comment that tells why there is a need
for pull/push pair despite the dataoff - nhpull argument?

> +	DEBUG_NET_WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0));

maybe if (DEBUG_NET_WARN ...
	return 0 ?

> @@ -143,18 +147,22 @@ __sum16 nf_checksum_partial(struct sk_buff *skb, unsigned int hook,
>  			    unsigned int dataoff, unsigned int len,
>  			    u8 protocol, unsigned short family)
>  {
> +	unsigned int nhpull = skb_network_header(skb) - skb->data;
>  	__sum16 csum = 0;
> +	DEBUG_NET_WARN_ON_ONCE(!skb_pointer_if_linear(skb, nhpull, 0));
> +	__skb_pull(skb, nhpull);

Same here, but no need to copy the comment from nf_checksum, its enough
to say something like "see nf_checksum()".
