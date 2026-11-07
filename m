Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794053442;
	b=5kPPttJL6KUG0J4RLP2AeEH4vnE+oiVaXIfcQA+J4cyfA5RbKB2AhUcaviiVGpCweexj
	 pInfO6E4L1xWGc32iV8lhg0qra+Ij6+NdwhRPMVq0XQFdhlLXssfXW6CKs/nmmbol4wI/
	 hjRHpFaUT4srL43L9aN78eDfHQ0xg04tDZ3tFap7z8F6Ejw85bQ7NMWtHE95olF3VNX86
	 JM7uH/gKB/pvHPIaRfzYkfmVrTX4mmlxqB0jOWVT7ImRag9/KAYlBzn7Ee4k8nUtBMSEi
	 d2Pxpy84fEEqjvRnbaJRQKs1cipf26G0l/ozYmyeijnvBvZyB5XD8H2pduL3QeLPaYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794053442;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=KEXVO5kUBVeSoqXVafost9ROdZlSxVie7Qj95Ex11JM=;
	b=YrdkfY5tEZwaO8BG/zY9Jeecl5ST8NH54rh/A4ktg51T+6b4ehaRq9QDz6rpC20Z9R0O
	 yWQJmqtpBoI5Px9/zoRi1pfVuUZYTVzFgv9vn4htuYdvry5AzDmw5h4ROBhhHiRaO7URS
	 HQRRNLOqUEJfb31k7n4Z77yu738FiibLwZ0Nxpt+kxcWqbf7j1eXGSpw6sQjMpqWzEXkK
	 DahzsAEaMlRvLfL5Y3jm6p12V3eJx6uBRO59Q3g9fCx4T7TaCja0Cq41Q+ekF4PZD7w6r
	 /LLMvj+f9N4KwZvX0KlJQ4zGmz68FqNKWCHocCV3YXovZ9MwYcNlkibNGrTaf0doqWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85089606A326;
	Sat,  7 Nov 2026 12:10:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85089606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id C7463609FC; Sat, 07 Nov 2026 13:10:38 +0100 (CET)
Date: Sat, 7 Nov 2026 13:10:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Kyle Zeng <kylebot@openai.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Subject: Re: [PATCH] netfilter: br_netfilter: reject unsafe neighbour devices
 for DNAT
Message-ID: <au8VOwNYrLAB7G7t@strlen.de>
References: <20261030042155.73844-1-kylebot@openai.com>
 <au7SdYQrIqAQOU24@strlen.de>
 <au79avuyDAz__s4t@com-75606>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <au79avuyDAz__s4t@com-75606>

Kyle Zeng <kylebot@openai.com> wrote:
> On Sat, Nov 07, 2026 at 08:25:41AM +0100, Florian Westphal wrote:
> > > +			struct net_device *dev = neigh->dev;
> > > +
> > > +			/* The neighbour queue must keep skb->dev alive. A VLAN
> > > +			 * device also holds a reference to its real device.
> > > +			 */
> > > +			if (is_vlan_dev(dev))
> > > +				dev = vlan_dev_real_dev(dev);
> > > +			if (dev != skb->dev) {
> > > +				neigh_release(neigh);
> > > +				goto free_skb;
> > > +			}
> > > +
[..]
> 
> The VLAN check is intended to preserve existing VLAN DNAT behavior.
> 
> bridge-nf-filter-vlan-tagged=1, bridge-nf-pass-vlan-input-dev=1, and br0.100, the earlier test can pass with
> dst->dev == dev == br0.100. The continuation then changes skb->dev to br0, so the strict comparison would
> drop that valid packet.

Then please consider sending a v2 that explains this.

/* The neighbour queue must keep skb->dev alive. dst->dev is either
 * the bridge or a vlan on top of bridge
 * (bridge-nf-pass-vlan-input-dev=1).
 */

might just be enough.  Thanks.

