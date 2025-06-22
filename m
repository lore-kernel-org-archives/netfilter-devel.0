Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6EB156236;
	Sun, 22 Jun 2025 20:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750623413; cv=none; b=huHmQ6l/XrDOEstkcZ4CPLRERDxywoJxjyVGA4+D2XlCdxqDDD5lEzZZeWp2O4rV3TKqBm9lo5P7QogwX/Q6QTc72jgVpTQrck6A3TPSaelFoUMFkaqZB6JEtCcwQSsiBPuHz0BVCB5powtT0GI/Z3C3dP7U5aC5mdfFIJKRYzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750623413; c=relaxed/simple;
	bh=/BPuVakEF4+6+DAKkDQ86WmsjNsOQm+/UhaeUFwdsv4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pyAdOshy7HXbjFNZgGi5yKrHjacYcIgTBkBhvGf+NiC06CEE8lTlPw3/KjlI0eeWhNmzi4HzQhUfzbmAUT1xngmmpa1XUbFKRANtTx8aEei8rNKDeGJaCD5H0p96VFQqQVokiflPiLV32BOicJWpR+ywykGmfHKU5Z0/lERPbTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id AD3356123A; Sun, 22 Jun 2025 22:16:49 +0200 (CEST)
Date: Sun, 22 Jun 2025 22:16:49 +0200
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
Subject: Re: [PATCH v12 nf-next 1/2] netfilter: bridge: Add conntrack double
 vlan and pppoe
Message-ID: <aFhksV47fCiriwJ4@strlen.de>
References: <20250617065835.23428-1-ericwouds@gmail.com>
 <20250617065835.23428-2-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250617065835.23428-2-ericwouds@gmail.com>

Eric Woudstra <ericwouds@gmail.com> wrote:
> -	if (ret != NF_ACCEPT)
> -		return ret;
> +	if (ret == NF_ACCEPT)
> +		ret = nf_conntrack_in(skb, &bridge_state);
>  
> -	return nf_conntrack_in(skb, &bridge_state);
> +do_not_track:
> +	if (offset) {
> +		__skb_push(skb, offset);

nf_conntrack_in() can free the skb, or steal it.

But aside from this, I'm not sure this is a good idea to begin with,
it feels like we start to reimplement br_netfilter.c .

Perhaps it would be better to not push/pull but instead rename

unsigned int
nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)

 to

unsigned int 
nf_conntrack_inner(struct sk_buff *skb, const struct nf_hook_state *state,
		   unsigned int nhoff)

and add

unsigned int 
nf_conntrack_in(struct sk_buff *skb, const struct nf_hook_state *state)
{
	return nf_conntrack_inner(skb, state, skb_network_offset(skb));
}

Or, alternatively, add
struct nf_ct_pktoffs {
	u16 nhoff;
	u16 thoff;
};

then populate that from nf_ct_bridge_pre(), then pass that to
nf_conntrack_inner() (all names are suggestions, if you find something
better thats fine).

Its going to be more complicated than this, but my point is that e.g.
nf_ct_get_tuple() already gets the l4 offset, so why not pass l3
offset too?
