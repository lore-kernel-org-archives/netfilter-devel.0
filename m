Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9068E1AC438;
	Thu,  6 Jun 2024 14:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683326; cv=none; b=K9vLdkQWTY9I/DlEpD2swfaU19EPefePsPDfetjCJ0Ww7HKxsoZ4eLSMxYu8OEO9nkZzwV5uXowmd0j5v0XXT4D5yTorBdei0TsKhhx4zI8m6HksT233VDM9YFLXQKlRmlvnMLYfxGB+lM0Dcr664tVMa4rlx+8vOqza069UO+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683326; c=relaxed/simple;
	bh=Z6jDE3UN9aLj4w/SPShsNMVpxRDxA67wixN4CLYy3W4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imLWgsLp9iNMs8mSWjSwJv9ifeC5oSYhO6HdWBwy0h0/O0kC68XGZMaGrV71agbDGnNR/UjE8afmGJ9g8qnCjzXPboVfEp84Tad2vu5rfVnYjRJFgEOYhnkCIfYoU4prLk6e7RGiQjR0JDpEny255szKyKNE8Zl2tKoeDyTtKhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sFDtc-0003ht-Bl; Thu, 06 Jun 2024 16:15:16 +0200
Date: Thu, 6 Jun 2024 16:15:16 +0200
From: Florian Westphal <fw@strlen.de>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, willemb@google.com
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240606141516.GB9890@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <20240606092620.GC4688@breakpoint.cc>
 <20240606130457.GA9890@breakpoint.cc>
 <6661c313cf1fe_37b6f32942e@willemb.c.googlers.com.notmuch>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6661c313cf1fe_37b6f32942e@willemb.c.googlers.com.notmuch>
User-Agent: Mutt/1.10.1 (2018-07-13)

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > ... doesn't solve the nft_hash.c issue (which calls _symmetric version, and
> > > that uses flow_key definiton that isn't exported outside flow_dissector.o.
> > 
> > and here is the diff that would pass net for _symmetric, not too
> > horrible I think.
> > 
> > With that and the copypaste of skb_get_hash into nf_trace infra
> > netfilter can still pass skbs to the flow dissector with NULL skb->sk,dev
> > but the WARN would no longer trigger as struct net is non-null.
> 
> Thanks for coding this up Florian. This overall looks good to me.

Thanks for reviewing.

> One suggested change is to introduce a three underscore variant (yes
> really) ___skb_get_hash_symmetric that takes the optional net, and
> leave the existing callers of the two underscore version as is.

Okay, that reduces the code churn.

> The copypaste probably belongs with the other flow dissector wrappers
> in sk_buff.h.

skb_get_hash(skb);
__skb_get_hash_symmetric(skb);
____skb_get_hash_symmetric(net, skb);

I named the copypasta as nf_skb_get_hash. If placed in sk_buff.h:
net_get_hash_net()?
skb_get_hash()?

And if either of that exists, maybe then use
skb_get_hash_symmetric_net(net, skb)

or similar?

(There is no skb_get_hash_symmetric, no idea why it
 uses __prefix).
