Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E412FD7C3;
	Sat,  1 Aug 2026 12:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785589094; cv=none; b=u2CyKSXFhSAutm2kK7AMZts5/vRo85urwCDfq0iFW89A5eRp8l2rGjS+NndKT0JSvN+VwnOE8yOARUN3dqN0dqvU1ZqvyOEJoWo0Nelpe3TQs9DnrQfOulgnmEL88JXCYRve5ec+iqlgwRyKnfIZi1a0VLPa42w2PRnV46IW3II=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785589094; c=relaxed/simple;
	bh=dqXueTeNmikbPWO0m1tN7QGosL4sy6GHFFPE8fmqsF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l4NfeCxXgLVBsXgEdP1VCEsXzDei9TYpXniWffgwFjBor0TRZ6h1kA86kFSjx6jpi2Qjg6eEhNiC6wB7i8m9tyBoVH+FxvL/id3O/z/4m85IM5BN62Qc+28J3TtjLmxUOpJ2fGcT1xRh6CTp1rQwmPTDt/jvNLqOiM6GzILp5Bg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 72CBB60952; Sat, 01 Aug 2026 14:58:08 +0200 (CEST)
Date: Sat, 1 Aug 2026 14:58:08 +0200
From: Florian Westphal <fw@strlen.de>
To: Zhiling Zou <zhilinz@nebusec.ai>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org, phil@nwl.cc, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	horms@kernel.org, kaber@trash.net, zhaojignmin@hotmail.com,
	vega@nebusec.ai
Subject: Re: [PATCH nf v3 1/1] netfilter: validate L4 headers after userspace
 packet writes
Message-ID: <am3tYPxeqwqOo9kP@strlen.de>
References: <587830a57a593c4b621f7e8e94b2ddc73e6becb0.1785468829.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <587830a57a593c4b621f7e8e94b2ddc73e6becb0.1785468829.git.zhilinz@nebusec.ai>

Zhiling Zou <zhilinz@nebusec.ai> wrote:
> Extend NFQUEUE payload validation to check the final L4 protocol and
> known base headers after IPv4 options or IPv6 extension headers. Reject
> packets whose L4 protocol no longer matches an attached non-template
> conntrack entry, and validate TCP data offset before reinjection. Unknown
> L4 protocols are left to their normal protocol handlers.

Nfqueue part will need to check for the ip frag case as noted by AI review, but other than that this LGTM.

This also means we should return false (i.e. drop)  in case we have an
ip fragment with a conntrack attached to it.
