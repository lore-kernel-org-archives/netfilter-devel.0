Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793472616;
	b=4k2glpix+wNWXSmw+7x+VPvpOnaZ0tkTIV3cKpSnNlrYnh/E+AT9fdEZWN+2p2nMY4KQ
	 qyFgMYV/wLZsItgAjgP+4XyttK4f/OLj1kRvZQig0Iwoc9GQJuGAwOq7I7AI0Sr0Ukwv0
	 kM4/6lqgCzrNpWfsCQOoUD9PwvlI36Z6XOovA5ek5wqjAseZz/tE016mxKdgWx+Cmyd0+
	 bAZdad7Eh+YR6THitGlxRs/V6B7VuFRqESIrCxGbWLcjz6pcK8032JciUEQN9A4fQxT+E
	 1IPxmYNCPHwrYFAar7VP5PCFpDO6HSAm+GXlivLEqV9UPceGEVurdbu6O0InfOcHkJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793472616;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=mxsr/9eM9IT7x56XlFJqaM4VoKdjWeJUE5kFLUzsU1c=;
	b=R73xDyP2CsIvqhuKtEGvZHhoh04Ukwp45pxpkyLw4TGZabwiuH19BdxdzTFnkqIyMdh8
	 d+CTDMqw06Awyx2WPPviBRm2I+p6X7i6iijbRmfatRqljQTd/intgZ7wWSI/dkC/SGxi2
	 b6YpcKCDs/O2BUasz6n0r/6BBjfFHulclPMWVkFIzP0FDUsur0jUss7ofKvADksXZ1QsH
	 SnScU4BLZMCFY3akQ2u1G9f8fY7Hhpfijz+Fnoemu3ouLRs48Nkli5bAjcWdAz6onuQWN
	 lcnfdU6JZ862tCR7EWIki2OHhVnWu75ScNn89KQgUltNFpgPufCC8Kz3SS9GUqgK0Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B287606A31C;
	Sat, 31 Oct 2026 18:50:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5B287606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id DE3DA60796; Sat, 31 Oct 2026 19:50:12 +0100 (CET)
Date: Sat, 31 Oct 2026 19:50:12 +0100
From: Florian Westphal <fw@strlen.de>
To: Kyle Zeng <kylebot@openai.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Subject: Re: [PATCH] netfilter: br_netfilter: reject unsafe neighbour devices
 for DNAT
Message-ID: <auY4ZAZWQfQtX3oe@strlen.de>
References: <20261030042155.73844-1-kylebot@openai.com>
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
In-Reply-To: <20261030042155.73844-1-kylebot@openai.com>

Kyle Zeng <kylebot@openai.com> wrote:
> The IPv4 and IPv6 bridge prerouting callbacks classify DNAT traffic using
> the logical input device saved in skb->dev. The physical input port can
> have a different bridge master when prerouting resumes, for example after
> an NFQUEUE verdict. Netfilter reassembly can also combine the first
> fragment's bridge information with a different fragment's input device.
> 
> br_nf_pre_routing_finish_bridge() replaces skb->dev with the port's
> current bridge master, but looks up the neighbour using the existing
> route. This can put an skb with skb->dev pointing to bridge B on an
> unresolved neighbour of bridge A. Deleting B and resolving the neighbour
> on A then causes a use-after-free in __dev_queue_xmit().
> 
> Before calling the neighbour output method, check that the neighbour
> keeps skb->dev alive. A neighbour holds its device, and a VLAN device
> also holds its real device, so allow a VLAN whose real device is the
> bridge. Release the neighbour and drop the skb on a mismatch.
> 
> Doing this in the shared continuation covers both protocol families,
> including a queue in the remaining bridge prerouting hooks. Leave the
> cached-header path unchanged since it does not enqueue the skb.
> 
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---
> I have a reproducer for this issue and can share via DM

Please do.  I'd like to understand if that needs to be addressed
from nfqueue side instead, or if we can avoid neigh layer to
begin with.
