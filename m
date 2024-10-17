Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7BD31DFE23;
	Thu, 17 Oct 2024 18:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729188605; cv=none; b=XmkLg7/JJ5gBXbzn0U1qnGs2QeU51PXAE5dK46lKhyTByZgdV6N8xnjwcvUuETs86o/+fA+FIIoiUabgtYsGjEeDgV7JhjvuGgPkD1U/RNUE2IJeM8vLeZCxOZ9ElDMdZqv9x8y5joJJjhTQj6qVCdh6830vw9cazUhZFyih5q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729188605; c=relaxed/simple;
	bh=p6dDb527zKgJkfX6fy3fRt1iEqOKlslWlGhN2D6QVRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=empQ0WIVGWLuIQs+wp/NfSfoHxfmpyXV/vHz636wdyMCjmVR4jhViJJ7AfbFdYJlcO1aVjgTg3oqW0NtOCPx7J/3q21VjD11vqPtmA6g9209V6WnJzBPuU9AsB15QCnFGR9GnJTWA5to5EX4aVYlpceOVnkV4FPkFyWjqVggQwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=44420 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1t1UwZ-00FcEm-9a; Thu, 17 Oct 2024 20:09:53 +0200
Date: Thu, 17 Oct 2024 20:09:49 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Felix Fietkau <nbd@nbd.name>
Cc: Eric Woudstra <ericwouds@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Frank Wunderlich <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: Re: [PATCH RFC v1 net-next 00/12] bridge-fastpath and related
 improvements
Message-ID: <ZxFS7XBgFXsqUlkO@calendula>
References: <20241013185509.4430-1-ericwouds@gmail.com>
 <9f9f3cf0-7a78-40f1-b8d5-f06a2d428210@blackwall.org>
 <a07cadd3-a8ff-4d1c-9dca-27a5dba907c3@gmail.com>
 <0b0a92f2-2e80-429c-8fcd-d4dc162e6e1f@nbd.name>
 <137aa23a-db21-43c2-8fb0-608cfe221356@gmail.com>
 <a7ab80d5-ff49-4277-ba73-db46547a8a8e@nbd.name>
 <d7d48102-4c52-4161-a21c-4d5b42539fbb@gmail.com>
 <b5739f78-9cd5-4fd0-ae63-d80a5a37aaf0@nbd.name>
 <ZxEFdX1uoBYSFhBF@calendula>
 <eb9006ae-4ded-4249-ad0e-cf5b3d97a4cb@nbd.name>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <eb9006ae-4ded-4249-ad0e-cf5b3d97a4cb@nbd.name>
X-Spam-Score: -1.9 (-)

On Thu, Oct 17, 2024 at 07:06:51PM +0200, Felix Fietkau wrote:
> On 17.10.24 14:39, Pablo Neira Ayuso wrote:
> > On Thu, Oct 17, 2024 at 11:17:09AM +0200, Felix Fietkau wrote:
> > [...]
> > > By the way, based on some reports that I received, I do believe that the
> > > existing forwarding fastpath also doesn't handle roaming properly.
> > > I just didn't have the time to properly look into that yet.
> > 
> > I think it should work for the existing forwarding fastpath.
> > 
> > - If computer roams from different port, packets follow classic path,
> >    then new flow entry is created. The flow old entry expires after 30
> >    seconds.
> > - If route is stale, flow entry is also removed.
> > 
> > Maybe I am missing another possible scenario?
> 
> I'm mainly talking about the scenario where a computer moves to a different
> switch port on L2 only, so all routes remain the same.
> 
> I haven't fully analyzed the issue, but I did find a few potential issues
> with what you're describing.
> 
> 1. Since one direction remains the same when a computer roams, a new flow
> entry would probably fail to be added because of an existing entry in the
> flow hash table.

I don't think so, hash includes iifidx.

> 2. Even with that out of the way, the MTK hardware offload currently does
> not support matching the incoming switch/ethernet port.
> So even if we manage to add an updated entry, the old entry could still be
> kept alive by the hardware.

OK, that means probably driver needs to address the lack of iifidx in
the matching by dealling with more than one single flow entry to point
to one single hardware entry (refcounting?).

> The issues I found probably wouldn't cause connection hangs in pure L3
> software flow offload, since it will use the bridge device for xmit instead
> of its members. But since hardware offload needs to redirect traffic to
> individual bridge ports, it could cause connection hangs with stale flow
> entries.

I would not expect a hang, packets will just flow over classic path
for a little while for the computer that is roaming until the new flow
entry is added.

> There might be other issues as well, but this is what I could come up with
> on short notice. I think in order to properly address this, we should
> probably monitor for FDB / neigh entry changes somehow and clear affected
> flows.
>
> Routes do not become stale in my scenario, so something else is needed to
> trigger flow entry removal.

Yes. In case letting expire stale flow entries with old iifidx is not enough
some other mechanism could be required.
