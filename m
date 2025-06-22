Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3D61E9B0B;
	Sun, 22 Jun 2025 20:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750624854; cv=none; b=t7lUhNCUzwENanUi6boC3oi+ekqIoVbFmJWyetxwMVUeRR9E/tk5wQ3UxFavrsXbankjyrx5btQHKC52iBQfpvh3XGJVSZyAyBrDiUK4Qy5lY2J6cpBP0RABtRClmRZ1Z87/SWOKCmBlLlyG1Kqd3elODWaB0SplGyxvSqDQStA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750624854; c=relaxed/simple;
	bh=YRRFceNsr2ap7axmfwbwETkli2TjRnKlosoEfXUPPYQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YavPv0UqBCAtXxxznHAbNRPwzMbskWXks7Ga5DMxZQkapdIlLu6u8rkpQDL3RsuMI4B2b2gBSmMfSpbi+Afpwykzqwls6Dcuvhzkim2H3LaUpcl1SB72PE2rC1ye/Fy5T2/WlJFUuq+r6p2nw1eRV0qe2RFOB/3sij9DjFg5y1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 8EEC06146D; Sun, 22 Jun 2025 22:40:50 +0200 (CEST)
Date: Sun, 22 Jun 2025 22:40:50 +0200
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
Subject: Re: [PATCH v12 nf-next 2/2] netfilter: nft_chain_filter: Add bridge
 double vlan and pppoe
Message-ID: <aFhqUosjt2ptnlOZ@strlen.de>
References: <20250617065835.23428-1-ericwouds@gmail.com>
 <20250617065835.23428-3-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617065835.23428-3-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> -	return nft_do_chain(&pkt, priv);
> +	ret = nft_do_chain(&pkt, priv);
> +
> +	if (offset) {
> +		__skb_push(skb, offset);
> +		skb_reset_network_header(skb);
> +		skb->protocol = outer_proto;
> +	}

I don't think its a good idea to do this.

nft_do_chain() can mangle packet in arbitrary ways,
including making a duplicate, sending icmp/tcp resets in response
to packet. forwarding the packet to another interface, dropping
the packet, etc.

Wouldn't it be enough to set the skb network header if its not
set yet, without pull (and a need to push later)?
