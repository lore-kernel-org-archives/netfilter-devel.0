Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940CD35337B;
	Wed, 20 Aug 2025 00:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755649036; cv=none; b=l+nNh1dRR+KhPXsiGjlsGuEj7WysyFhIQ4nHBxAuMieIYbefnp/7HWfdpqB8o+XYdiG7Jldbq+hakqShM1rfGt3G3oqyZP7lz4+0MV0aYkfNdh9ME16WAgCCRy/sr1DIu/+xQWGLAuwhtr6SJNR18gFmqK3fc/2qhwyrEwWAobY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755649036; c=relaxed/simple;
	bh=EKtl4HHMjUn0kAzyuD5H7t8s6ps1qQ+IphQ25Wg7NV4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s62gknUjv2NNApweV2GdP8464/M6+2LGwHocnJK3Nhty0SVqy+E01TKziao6i6U+Xw3hHrtb5G72OIQJoSZBLKFkwlGN59B1W6gbi/gqakEuEZB5jczEWM/T/j9ULbrZIzv0l5gPvsk9pU2kevTawL1JdauXCaYlNcxSZJzWKZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1CC9F601EB; Wed, 20 Aug 2025 02:17:11 +0200 (CEST)
Date: Wed, 20 Aug 2025 02:17:10 +0200
From: Florian Westphal <fw@strlen.de>
To: Qingjie Xing <xqjcool@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: drop expectations before freeing
 templates
Message-ID: <aKUUBsFYBYOu2xu-@strlen.de>
References: <aKTCFTQy1dVo-Ucy@strlen.de>
 <20250819232417.2337655-1-xqjcool@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250819232417.2337655-1-xqjcool@gmail.com>

Qingjie Xing <xqjcool@gmail.com> wrote:
> With an iptables-configured TFTP helper in place, a UDP packet 
> (10.65.41.36:1069 → 10.65.36.2:69, TFTP RRQ) triggered creation of an expectation.
> Later, iptables changes removed the rule’s per-rule template nf_conn. 
> When the expectation’s timer expired, nf_ct_unlink_expect_report() 
> ran and dereferenced the freed master, causing a crash.

Sorry, I do not see the problem.
A template should never be listed as exp->master.

Can you make a reproducer/selftest for this bug?

I worry we paper over a different bug.
