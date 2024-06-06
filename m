Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DECDC1974FA;
	Thu,  6 Jun 2024 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717684702; cv=none; b=qJ1vBKBnXBJHr95pW2+/NoAwavEJ3cmnxfDWkEKjxOlEWp8X4uaVreHo41ndOcha8+E1zOhfw7e7wXHe5+Vw+k05eioi8fyGzFN+Pczcbse/R/GgUtI3vxchjqoAj0VW/qfUkCabMOteCYDyQOatpVRuyo9cxPgd1KfEMVaOguM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717684702; c=relaxed/simple;
	bh=nFggiXocbbzYUUkBex/PsGSlj2zFIOCp5hrXE5rE1UM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SQgi5znRIgfW5dJQMn9ieIu6Z+WSlpqbcfGljgTynCv54EVAuKG/PTv9PeR/G7WzUIitOi0c2f92YdZfXTNs05/9X7uSSbiu4zNUgypdFVUG6MVzQgwwKYg6sBJ9DKkfZQmYycR0cRQxA8kUObCBEdDwYVWB2L0j+7CZ7AhE/o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sFEFs-0003oZ-2c; Thu, 06 Jun 2024 16:38:16 +0200
Date: Thu, 6 Jun 2024 16:38:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, willemb@google.com
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240606143816.GC9890@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <20240606092620.GC4688@breakpoint.cc>
 <20240606130457.GA9890@breakpoint.cc>
 <6661c313cf1fe_37b6f32942e@willemb.c.googlers.com.notmuch>
 <20240606141516.GB9890@breakpoint.cc>
 <6661c788553a4_37c46c294fc@willemb.c.googlers.com.notmuch>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6661c788553a4_37c46c294fc@willemb.c.googlers.com.notmuch>
User-Agent: Mutt/1.10.1 (2018-07-13)

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > I named the copypasta as nf_skb_get_hash. If placed in sk_buff.h:
> > net_get_hash_net()?
> > skb_get_hash()?
> 
> Still passing an skb too, so skb_get_hash_net()?

Sounds good to me.

> > And if either of that exists, maybe then use
> > skb_get_hash_symmetric_net(net, skb)
> 
> If symmetric is equally good for nft, that would be preferable, as it
> avoids the extra function. But I suppose it aliases the two flow
> directions, which may be exactly what you don't want?

It would actually be fine, but the more important part is that
skb->hash is set.

For the trace id, I want a stable identifier that won't change
(e.g. when nat rewrites addresses).

This currently works because skb_get_hash computes it at most once.

skb_get_hash_symmetric_net() will be used from nft_hash.c as
__skb_get_hash_symmetric "replacement".

Pablo, you can drop this patch, I will try the 'pass net to dissector'
route.
