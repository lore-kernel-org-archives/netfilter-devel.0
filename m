Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867D71E494;
	Thu,  6 Jun 2024 14:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717685529; cv=none; b=ObGjvxhlg8XLUbAvfpCnwgneZlvOlJFyke2bY37PhYLzi3ZjBIJHDgqblfJsOfp7eXnT1+A+IjcCUIIC/UH04UsE/a6i6X9DzDP1W2V52pYbqw2+5zo/uwg2PYt7CDMHaZ78pob1/7qsAMkoF4vyMwjDGTfhzUuWQ5UOhhyOt7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717685529; c=relaxed/simple;
	bh=FxKFXo4utQQvS6wD2Vl91IR4w1i+Kdv8Xgec22AMuL8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nj/Tnak/tNuSLfnha+sQ6eGSdkEvdJeA/rxBVqpfC/yWRWwL+SbrXHwbQ4fB7JQ4fPaLtLDXLNyTccfP5zmdX6bIXmBeHCTBKQs6B/6ache/hadxkcZHSg3rpVaSCbVUoI10lMy1wBhdBakEcb2GRkXFc5YH9GDwtS5HlDjhPJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sFETB-0003vf-LW; Thu, 06 Jun 2024 16:52:01 +0200
Date: Thu, 6 Jun 2024 16:52:01 +0200
From: Florian Westphal <fw@strlen.de>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, willemb@google.com
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240606145201.GD9890@breakpoint.cc>
References: <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <20240606092620.GC4688@breakpoint.cc>
 <20240606130457.GA9890@breakpoint.cc>
 <6661c313cf1fe_37b6f32942e@willemb.c.googlers.com.notmuch>
 <20240606141516.GB9890@breakpoint.cc>
 <6661c788553a4_37c46c294fc@willemb.c.googlers.com.notmuch>
 <20240606143816.GC9890@breakpoint.cc>
 <6661cb237158e_37d9572949b@willemb.c.googlers.com.notmuch>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6661cb237158e_37d9572949b@willemb.c.googlers.com.notmuch>
User-Agent: Mutt/1.10.1 (2018-07-13)

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > This currently works because skb_get_hash computes it at most once.
> 
> Probably not relevant to these skbs, that don't have an skb->sk.
> 
> But in case skbs coming from the TCP stack are also in scope: can
> sk_rethink_txhash cause problems?

No, thats fine for the nf_trace infra.
