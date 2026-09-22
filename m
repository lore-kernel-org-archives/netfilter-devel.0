Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6C84F7CB2
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 10:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072729; cv=none; b=ow2ytI5xGyj7dYfXo0skvdkQY+WbQD8VVenlwCIX+ZVDUZWd4JPDHxBbhN87l5+4PLnxcRPk0spZ4jnsV3+PC6lnBSvel5ssgzwNloY/aevAxJ5zMYx/TpBFi8VUJpc77al8aWUDpVBm7Uv1GNeIRz5jkKZIXRK/FHsZij55Pwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072729; c=relaxed/simple;
	bh=LSpXZF8jX8dzPxLeAlwiFEqNbuMy7NR+RhcfsI5339U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oq7x6ELQbCAVazR6LoPFQD3B2XbgQz/tQv1+uQ+RURc54zt3R2fCTCn2xZqoheopla+sozlngQtAeI3Y7EBseeZW4E9aWLZc7ZvQ3xrXqX3gSTOK4+S1ULYyP0g+KF68qRi42+OhfrCbjCUIRfgQbmIGCg3jbwl3qvF4Npp9oA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 6064E60344; Tue, 22 Sep 2026 12:25:18 +0200 (CEST)
Date: Tue, 22 Sep 2026 12:25:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc, eric@regit.org,
	Yu Junzhe <junzheyu1@gmail.com>
Subject: Re: [PATCH nf v2] netfilter: nft_reject: prevent unbounded recursion
 in output hooks
Message-ID: <arJXh7zI9qyCxSiB@strlen.de>
References: <20260922092503.3238-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922092503.3238-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> nftables payload-mangling rules can rewrite packet contents (such as TCP
> flags) before they are evaluated by reject targets. This defeats the
> content-based loop guards, allowing unbounded hook recursion that leads
> to kernel stack exhaustion and panics.
> 
> Fix this by extracting the per-CPU xmit recursion limit previously used
> by the netdev duplication/forwarding paths into a shared header, and
> apply it to the inet and inet6 reject transmit functions. It disables BH
> while transmitting the skb to address a possible migration to different
> CPU leading to imbalanced decrementation of the recursion counters.
> 
> Note that the dev_queue_xmit() path used when CONFIG_BRIDGE_NETFILTER is
> enabled does not require this recursion guard. In that scenario, the
> generated reset packet is transmitted directly at Layer 2. Because the
> packet egresses from a different hook, it cannot synchronously loop. In
> addition nf_send_unreach() and nf_send_unreach6() are safe as the ICMP
> transmit functions are protected against recursion by the
> icmp_xmit_lock() and icmpv6_xmit_lock() guards.

I see, thanks for explaining.
