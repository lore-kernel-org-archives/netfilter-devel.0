Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD8513B7A9;
	Thu,  6 Jun 2024 08:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717663154; cv=none; b=OtyIConxw/rbWTE+tM70sRhQY543JvL202d+94ogqdDxHvP7uVor+J2Sr4m3a8dJ6dJ0qE44E+9b8HqPCFwCeMLFqgVC0OL6g1ZcCI+A7NlZFFiq2aMz/NmqoWkux42X46zS+6ntY5CEupJnf2hQMz8HsYvicZ6xJ4adj+ilXRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717663154; c=relaxed/simple;
	bh=HKLQNbCiKO8GdgIRFLmoBkFsM576UeU3qL3YIZA/dsA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSyl2liQJy/ENTQMxf2C+VtC8BUO7gD4x1W5vnxRYi1IqYvfgzEhhnK78RDnVq+q7s8N6+IMujWRoy1uVgZV+fWkff+IrIOZ62eam4AP6snwIbtR3Vs2hm3mUrVREJx3thhG1V8ZskTK3QL4KpM99u7iCGo3W1DQ6WZza9B+/g0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sF8eH-0001Jf-4n; Thu, 06 Jun 2024 10:39:05 +0200
Date: Thu, 6 Jun 2024 10:39:05 +0200
From: Florian Westphal <fw@strlen.de>
To: Willem de Bruijn <willemb@google.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Christoph Paasch <cpaasch@apple.com>,
	Netfilter <netfilter-devel@vger.kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
	daniel@iogearbox.net, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH nf] netfilter: nf_reject: init skb->dev for reset packet
Message-ID: <20240606083905.GA4688@breakpoint.cc>
References: <20240604120311.27300-1-fw@strlen.de>
 <FF8A506F-6F0F-440E-9F52-B27D05731B77@apple.com>
 <20240605181450.GA7176@breakpoint.cc>
 <ZmCwlbF8BvLGNgRM@calendula>
 <20240605190833.GB7176@breakpoint.cc>
 <ZmDAQ6r49kSgwaMm@calendula>
 <CA+FuTSfAhHDedA68LOiiUpbBtQKV9E-W5o4TJibpCWokYii69A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+FuTSfAhHDedA68LOiiUpbBtQKV9E-W5o4TJibpCWokYii69A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Willem de Bruijn <willemb@google.com> wrote:
> On Wed, Jun 5, 2024 at 3:45 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Jun 05, 2024 at 09:08:33PM +0200, Florian Westphal wrote:
> > > So there are several options here:
> > > 1. remove the WARN_ON_ONCE and be done with it
> > > 2. remove the WARN_ON_ONCE and pretend net was init_net
> > > 3. also look at skb_dst(skb)->dev if skb->dev is unset, then back to 1)
> > >    or 2)
> > > 4. stop using skb_get_hash() from netfilter (but there are likely other
> > >    callers that might hit this).
> > > 5. fix up callers, one by one
> > > 6. assign skb->dev inside netfilter if its unset
> 
> Is 6 a realistic option?

The output hook has to outdev available (its skb_dst(skb)->dev, passed
in from __ip_local_out()).

So we could set skb->dev = outdev, before calling skb_get_hash and
__skb_get_hash_symmetric.
