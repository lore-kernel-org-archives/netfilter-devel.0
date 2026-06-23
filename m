Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F517269D18
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jun 2026 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782254249; cv=none; b=KoZAXJNZkoXK3i8hOIh3pPu19s76yotgJkocaIJEkdZin1QrvouEhG+wdCRNef48TSEGC2rZuOi5X9vHQhVW0XvbO2mvb5/hTjy7sMIhhslQkRg0oL0G3PcmA2KAk214a1/0C6uwymu3qhLXQRFO7oNjvnqiizIsZNmVKy6p9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782254249; c=relaxed/simple;
	bh=S1TgUh+KCM7nF4gsI1azZm6MU6p/PGP+FMk7UibH4C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DUbAOVQjrb7DMlbbJVwSs71e+Ql0AOEWiD3lnX+weRzBFFGuWlwFl89mHHAmICl9w07Krf7LfbFZS7qCi7wVGxDAk+XGoAnHRL2Kq0UhFSIFYvJq251LsfwE2jNTSfh0R4/PbD3tYr/PbH/lmBI/+75ntlc+eQFuUFfQB6jOP8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 526F16051B; Wed, 24 Jun 2026 00:37:24 +0200 (CEST)
Date: Wed, 24 Jun 2026 00:37:23 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	Phil Sutter <phil@nwl.cc>, Eric Garver <egarver@redhat.com>
Subject: Re: [PATCH 3/7 nft v3] src: add tunnel statement and expression
 support
Message-ID: <ajsKozU_JZ3PQLhF@strlen.de>
References: <20250821091302.9032-1-fmancera@suse.de>
 <20250821091302.9032-3-fmancera@suse.de>
 <CAJsUoE2uoZJH2VA6E+J+SK=G1W06JE2+0v-NmgGyGWBNRKFgng@mail.gmail.com>
 <0f9b3772-0b38-40ae-ad3f-e2e790695054@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0f9b3772-0b38-40ae-ad3f-e2e790695054@suse.de>

Hi Fernando

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 12/29/25 2:51 PM, Yi Chen wrote:
> > Hello Pablo and Fernando,
> > I have started working on a test script (attached) to exercise this
> > feature, using a geneve tunnel with an egress hook.
> > Please let me know if egress is the correct hook to use in this context.
> > 
> > However, the behavior is not what I expected: the tunnel template does
> > not appear to be attached, and even ARP packets are not being
> > encapsulated.
> > I would appreciate any guidance on what I might be missing, or
> > suggestions on how this test could be improved.
> > Thank you for your time and help.
> > 
> 
> As my patch is taking longer than expected because I am polishing all the
> details related to the tunnel object let me explain it here briefly to
> unblock you.
> 
> The tunnel expression/object is used to attach tunnel metadata into a packet
> so in essence support Lightweight Tunneling (LWT) using Nftables. The LWT
> support is useful on virtualization environments where the users need to
> created a lot of tunnels to interconnect containers that are inside
> different VMs. Instead of creating one interface per container, the idea is
> that the user can create a single one and then attach the metadata as
> needed. Imagine the topology described below.

I'm trying to get Yi's test script to work but I am failing as well.
AFAICS the entire feature doesn't work *by design*.

> +------------------------+                   +------------------------+
> |--------+          VM A |                   | VM B          +--------|
> |Box     | +------+ +---+|(192.168.124.49)   +----+ +------+ |Box     |
> |10.0.0.1|-|vxlan0|-|eth0|-------------------|eth0|-|vxlan0|-|10.0.0.2|
> |--------+ +------+ +---+|  (192.168.124.134)+----+ +------+ +--------|
> |                        |                   |                        |
> |                        |                   |                        |
> +------------------------+                   +------------------------+

How do I read this diagram?
Are these 4 computers or 2?
What is "Box" ? Is that a container inside of VM A / B ?
And if so, how does it connect to VM A?  veth?  The diagram reads like
its a container connected to VM A via a vxlan tunnel...

Which makes no sense to me.

> We want to reach 10.0.0.2 from 10.0.0.1, the nftables ruleset on VM A will
> look like this:
> 
> ```
> table netdev filter_tunnel {
> 	tunnel vxlan_tmpl {
> 		id 100
> 		ip saddr 192.168.124.49
> 		ip daddr 192.168.124.134
> 		dport 8472
> 		ttl 255
> 		vxlan {
> 			gbp 100
> 		}
> 	}
> 
> 	chain redirect_to_tunnel {
> 		type filter hook ingress device "veth_host" priority filter; policy
> accept;
> 		ip daddr 10.0.0.2 tunnel name "vxlan_tmpl" fwd to "vxlan0"
> 	}
> 
> 	chain redirect_from_tunnel {
> 		type filter hook ingress device "vxlan0" priority filter; policy accept;
> 		ip daddr 10.0.0.1 fwd to "veth_host"

How can this work?  I tried to get this to run but *ingress* sees no
packets.  Which is not surprising to me, as packets are *egressing* from
VM A, not coming in.

The only way that I can get it to work is via normal tunnel device +
routes, no nftables rules needed.

Can you make a test script for packetpath?
Or add documentation that explains how to use this feature?

Thanks.
