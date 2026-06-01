Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62832342509
	for <netfilter-devel@vger.kernel.org>; Mon,  1 Jun 2026 10:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780309917; cv=none; b=SQSTlIt9t4QCJ/CObCE2qhBJtVI1kXQoJIb21aC6ckZvo7EvA6MqR7hfHnlZsm/PFj2/f3uttZhtqXYosVutujAa/KzO0tL/CRLwWSTrJAEyeOICLIWOAClEPu1hOv399Kb/HA24a4ETB5cgVAXetbBp86qO3X6TkVMwP0D0HMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780309917; c=relaxed/simple;
	bh=128YcygP3By5a+jKgRXlThx/mW2wDpPabboQDxS5wRk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJL4qyUucUVN4qcZklENjLJeyv2TLKdpsuyYZ9igIUFylVTHO6ei7yLb4Iu9aJZWD5/z4RAGAN5pVBHa1LuofpI7Oj2DQAqwBZK+JZ8KsIXznTHfqoH2+lvI9KVwqqVOXg0K1f8LXFOHfqAviR+7CMQtGh0cagP9bizsmfGL+BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A1060604DC; Mon, 01 Jun 2026 12:31:53 +0200 (CEST)
Date: Mon, 1 Jun 2026 12:31:53 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, Hacking <eilaimemedsnaimel@gmail.com>
Subject: Re: [PATCH nf] netfilter: bridge: ebt_redirect: don't assume bridge
 port exists
Message-ID: <ah1fmV-PtReWT0y-@strlen.de>
References: <20260601095000.595383-1-fw@strlen.de>
 <ah1fBBvCPBOTQ93a@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah1fBBvCPBOTQ93a@chamomile>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Florian,
> 
> On Mon, Jun 01, 2026 at 11:50:00AM +0200, Florian Westphal wrote:
> > ebt_redirect_tg() dereferences br_port_get_rcu() return without a
> > NULL check, causing a kernel panic when the bridge port has been
> > removed between the original hook invocation and an NFQUEUE
> > reinject.
> 
> Maybe more candidates for the same pattern?

Did not find any, but I only searched in net/bridge/netfilter.

Will send a v2.

> net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);
> net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);
> net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);
> net/bridge/netfilter/nft_reject_bridge.c:       br_forward(br_port_get_rcu(dev), nskb, false, true);

br_forward(NULL, .. is safe.

> net/netfilter/nfnetlink_log.c:                                   htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
> net/netfilter/nfnetlink_log.c:                                   htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))
> net/netfilter/nfnetlink_queue.c:                                         htonl(br_port_get_rcu(indev)->br->dev->ifindex)))
> net/netfilter/nfnetlink_queue.c:                                         htonl(br_port_get_rcu(outdev)->br->dev->ifindex)))

Those aren't.
