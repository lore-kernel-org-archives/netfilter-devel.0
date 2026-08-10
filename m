Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3FA280331;
	Mon, 10 Aug 2026 22:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400480; cv=none; b=G7Cz+xyNvX/+vOjXLg+/SBGyDGeYxrqnGM2vPodbjQMGGHHlf2QLbTFgH3ZabAUXc293DsxjK+eXWzPVvhk/RMPYIetGx1g+W0+8KesRlVeT9Pus8Gw2R7jOL3mge0AH2U3dOaQwbFDUsw1Nk9ANPKjlOIhhR9wHqsXI9s75HJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400480; c=relaxed/simple;
	bh=dFAAqM5wOHImI909IUyJjpMTVgZxZbQWYRivyOzecFo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIcl2/TMy33jCxLbY+qn9ZcR4ZLbSWD/Cgt9ct9EkBK0wgJrWjcD9Co9BwgPMzswNkxOMzjIIYi6yOCR5eEYoY3eRGjJbymsfsW4DXyrsiZIw/GLWINg/jcx65NGhTPJFXrMq0EA4a7uJXqyHdGpGjT/xTn0VHRLwUawEx32spU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A4B066051B; Tue, 11 Aug 2026 00:21:09 +0200 (CEST)
Date: Tue, 11 Aug 2026 00:21:09 +0200
From: Florian Westphal <fw@strlen.de>
To: Kyle Zeng <kylebot@openai.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_ct: validate timeout object protocol
Message-ID: <anpO1Uz__Dg5QbNe@strlen.de>
References: <20260810221744.35007-1-kylebot@openai.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810221744.35007-1-kylebot@openai.com>

Kyle Zeng <kylebot@openai.com> wrote:
> nft_ct_timeout_obj_eval() only compares the timeout object protocol with
> packet metadata. A packet header can be changed after conntrack attaches
> an entry, so this metadata does not necessarily describe the entry.

I think all of these patches are wrong.  *How* can a packet header
change?  And if so, why is it enough to compare with the ct?

And why is that enough to somehow make it safe?

Are you going to add checks everywhere?
