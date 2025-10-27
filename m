Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5967218EB1
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Oct 2025 18:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590268; cv=none; b=D54ZJ1Whl5GlmCX/qpn+6gFGnROv/Mog6UjS7NduZa4SFSp+Opve4a5sAwK3dcmBFx/ME6OoxRInsOBWV9uc+uMpdJR5og4Kx5hlCGBIaGaWycWIXMkC3II3raqZg8bs8PIHSN7JSmb5oTiNNi57NbnIe/yEbq34zOSSnYJ4Yxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590268; c=relaxed/simple;
	bh=aXulBhIv0p7eIF1H+XAZ6VjWqwe7Oi2WWVOfPSSVPmw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mmuVLPo0JwlTvqPhiG7QdGsTLrHjfWSNlBx7MICW823noC9Vof46KvFa9CNBsC2T8bIDZPpv9l2m7Ji4CfJfT5KL4eappjwyI0jFGlsTFVFLeq6YqKHrCSA6kQu4D/S0Tb/PNE+HzCh4oYMZ49xUEr9azVGSCek+dU1wxlm3OiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 1A759605E6; Mon, 27 Oct 2025 19:37:43 +0100 (CET)
Date: Mon, 27 Oct 2025 19:37:42 +0100
From: Florian Westphal <fw@strlen.de>
To: "Antoine C." <acalando@free.fr>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: Re: bug report: MAC src + protocol optiomization failing with 802.1Q
 frames
Message-ID: <aP-76gB9axgCebpL@strlen.de>
References: <aOwhNIqlsbmeyTPA@strlen.de>
 <1676410308.11476569.1761589612512.JavaMail.root@zimbra62-e11.priv.proxad.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1676410308.11476569.1761589612512.JavaMail.root@zimbra62-e11.priv.proxad.net>

Antoine C. <acalando@free.fr> wrote:
> 
> This bug does not seem to get a lot of attention but may be it
> deserves at least to be filed ?

Its a design bug and so far not a single solution was
presented.

And no one answered any of the questions that I asked.

So, whats YOUR opinion?

> > Should "ip saddr 1.2.3.4" match:
> > 
> > Only in classic ethernet case?
> > In VLAN?
> > In QinQ?
> > 
> > What about IP packet in a PPPOE frame?
> > What about other L2 protocols?

As long as nobody defines how any of this is supposed to work
in the first place nothing will happen here.

What you encounter is the 'historic random behaviour' where outcome
depends on the hidden dependencies that nft (userspace) inserts and
if vlan offload was disabled.
