Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B0F13C9CD
	for <netfilter-devel@vger.kernel.org>; Fri, 26 Jul 2024 12:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721997122; cv=none; b=r+v/ZUhCTatWyRiMTF4Ibq7wjhCTPcptww193mdFCTE3L/8xipD+YhW8pMkSYgHzGFL3peMpLCOOTkDNFPdV2ePQRLMxZ4mvNj0z2pKwov6I8zdY9HQIGG0HFop6d00iumT775XXTYpRkFinPXJJPRXDeEafidTEiKRCYMUiQZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721997122; c=relaxed/simple;
	bh=IdDW8H/d36jH16kZN+XbN3LFkX0W/Kjj7N9K6iIC5bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HSW4GtlBbmJ635YjjmGWJO6XWRR4CS94P18KOC7nonclZwQzcWF7qKFhkm7Ui9kk19G0KGOjMsA2Sqtsd7at3qHA0DwwC2KCE1b0ZOXEkYeSanlAxGNnAAtxWPm/FWq6YumT/EV7Ctfqg4a9cVmv0sudzwBhY6mZS7TQ6muORbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sXK6y-00011k-4q; Fri, 26 Jul 2024 14:31:52 +0200
Date: Fri, 26 Jul 2024 14:31:52 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft 1/4] doc: add documentation about list hooks feature
Message-ID: <20240726123152.GA3778@breakpoint.cc>
References: <20240726015837.14572-1-fw@strlen.de>
 <20240726015837.14572-2-fw@strlen.de>
 <ZqNlvkJ2YSc-KIKb@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqNlvkJ2YSc-KIKb@calendula>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > +*list hooks* is enough to display everything that is active
> > +on the system, however, it does currently omit hooks that are
> > +tied to a specific network device (netdev family). To obtain
> > +those, the network device needs to be queried by name.
> 
> IIRC, the idea is to display the ingress path pipeline according to
> the device (if specified)
> 
>         list hooks netdev eth0
> 
> as for egress, as it is not possible to know where the packet is
> going, it is probably good to allow the user to specify the output
> device, so it gets the entire pipeline for ingress and egress
> paths, ie.
> 
> list hooks netdev eth0 eth1

Not really, why would eth0 and eth1 be related here?

What would make more sense to me is to allow

list hooks netdev

and then have nft fetch list of all network devices and then query them
all.

If a packet coming in on devX will be forwarded to devY depends on the
type of packet and the configuration, e.g. arp/ip vs. bridge/routing
or even encapsulation...

> Note that this is not implemented. This has limitations, discovering
> eth{0,1} belongs to bridge device would need more work (not asking to
> do this now, but it could be a nice usability feature to discover the
> pipeline?).

Bridge?  I don't think we have bridge family support for netdev hooks?
AFAIU its only netdev and inet.

This thing should only list the nf hooks registered for the device,
and not start to guess.  So for "list hooks br0", return ingress and
egress hooks for the virtual device, not the bridge ports.
