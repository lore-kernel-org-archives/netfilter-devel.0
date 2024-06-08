Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB377D520;
	Sat,  8 Jun 2024 22:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717887211; cv=none; b=EPqSZEU22My1C10kB5UEXq/73P8Uth4eZ08Kg/yZsNK1uoxacuevrWUzXITdZ4IdWapwkyctlGgyfWSMtHllIK1aoHD9Qwfh+BKJIQyy0dd6oqbuATiB4TakDxGE/Lb7KAR+t+1wsXD4AQ7yP5/X6wJttKKj4GAT8qqNKC4MEV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717887211; c=relaxed/simple;
	bh=uykDTuaQUD8mAUClJATe9bpt+V+PH7kV6mEuFVD6kX4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1o1er7sLd1nGiaCHEOGtB7bay767j1RjqZ1tX5FEmIfdJu/6Sy3OBzXMf4UdgQN/yQXtkZ0/2F9GhtqU03yWj4suEg2IgS7Qhv8wMIzOAI6YyrkoVA9NnIR3gBT0QDoxmSVFJBWAJlI+GNvLUx7KAaIy5hpND/8lWf0Ucxo5DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sG4NO-0003hV-ID; Sun, 09 Jun 2024 00:17:30 +0200
Date: Sun, 9 Jun 2024 00:17:30 +0200
From: Florian Westphal <fw@strlen.de>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, willemb@google.com,
	Christoph Paasch <cpaasch@apple.com>
Subject: Re: [PATCH net-next 1/2] net: add and use skb_get_hash_net
Message-ID: <20240608221730.GA13159@breakpoint.cc>
References: <20240607083205.3000-1-fw@strlen.de>
 <20240607083205.3000-2-fw@strlen.de>
 <CANn89i+50SE0Lnbpj1b1u62CyOfVxH25bneXnc3e=RJB0+jJ9g@mail.gmail.com>
 <6663159ab88ef_2f27b294c5@willemb.c.googlers.com.notmuch>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6663159ab88ef_2f27b294c5@willemb.c.googlers.com.notmuch>
User-Agent: Mutt/1.10.1 (2018-07-13)

Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> > > syzkaller did something like this:
> > > table inet filter {
> > >   chain input {
> > >     type filter hook input priority filter; policy accept;
> > >     meta nftrace set 1                  # calls skb_get_hash
> > >     tcp dport 42 reject with tcp reset  # emits skb with NULL skb dev/sk
> > >    }
> > >    chain output {
> > >     type filter hook output priority filter; policy accept;
> > >     # empty chain is enough
> > >    }
> > > }
> > >
> > > ... then sends a tcp packet to port 42.
> > >
> > > Initial attempt to simply set skb->dev from nf_reject_ipv4 doesn't cover
> > > all cases: skbs generated via ipv4 igmp_send_report trigger similar splat.
> 
> Does this mean we have more non-nf callsites to convert?

There might be non-nf call sites that need skb_get_hash_net(),
but I don't know of any.

The above comment was meant to say that I tried to patch this
outside of flow dissector by setting skb->dev properly in nf_reject,
but that still triggers a slightly different WARN trace, this time
due to igmp_send_report also sending skb without dev+sk pointers.
