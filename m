Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A606D274B46
	for <netfilter-devel@vger.kernel.org>; Mon, 19 Jan 2026 20:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768855515; cv=none; b=uVt38X2PCu0+HxEueONs1wbfeM4A4dyGo5++bmx9XeyYG7YQSjH4c3d3g1/rhi4N+bRxUWMXCViBod/wMTQXhriAwLA5sA8nSte7Cffr7BrYxNKMSo56ekR7FNCdek1GHhHmrlXgWmztFLzcqDSvewTqYow196lEceeIfyBkqKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768855515; c=relaxed/simple;
	bh=B9l3DDGP8IT+wCc2YBe8r7VF5ZwZC273ENwTQumjOX8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NQi+mn38KWiNhbHR9oILkFZizrVXidm2i9oRpQMkg+z1aBxku/LoQlELZLeea9hnp3egb7T6Sc75Ur2yf9c5Co5NBm+UlY5fjuf6HFYlEWk45ay+nGxUCZXcIM2Rw0tW+2ztu4CPPUeWpuwFSWyC8B8LGrBxmC4VJs45rMX267c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 238FA602AB; Mon, 19 Jan 2026 21:45:11 +0100 (CET)
Date: Mon, 19 Jan 2026 21:45:10 +0100
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, phil@nwl.cc,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Subject: Re: [PATCH nf-next v2] netfilter: nf_conncount: fix tracking of
 connections from localhost
Message-ID: <aW6X1kBQ8clOAL76@strlen.de>
References: <20260119203546.11207-1-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119203546.11207-1-fmancera@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
> sk_buff directly"), we skip the adding and trigger a GC when the ct is
> confirmed. For connections originated from local to local it doesn't
> work because the connection is confirmed on POSTROUTING, therefore
> tracking on the INPUT hook is always skipped.
> 
> In order to fix this, we check whether skb input ifindex is set to
> loopback ifindex. If it is then we fallback on a GC plus track operation
> skipping the optimization. This fallback is necessary to avoid
> duplicated tracking of a packet train e.g 10 UDP datagrams sent on a
> burst when initiating the connection.
> 
> Tested with xt_connlimit/nft_connlimit and OVS limit and with a HTTP
> server and iperf3 on UDP mode.

LGTM, thanks Fernando.  But shouldn't this go via nf tree?
