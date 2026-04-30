Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8398843DA56;
	Thu, 30 Apr 2026 16:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777565898; cv=none; b=KRSWKqhXeEfjxPmChYBXm5MS5owB0vfI7mQ9YE6GS2p5+JC7NkcDqwr4jPjxIW9VhFZetxP7l7SZobo5GbQMlt5NqqoF3iAgI/8mLavyG6hSXuXLLQuxn/13RaamT+HZ+VKFhlMxD56F63Lz9je+megEykjpneCWoiSLP0QkXeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777565898; c=relaxed/simple;
	bh=Wx0VA8Y3Bws5BbWlyAGMKMRH9mSa0JZQSrcbIWyjv3k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=taDWmR8Ib8aSn8rpwvZJllsuSetZGMAvhVn4OOdMCbA1AOMgApHgV/LB8GD9ioD13zZTu+Hw8gt8p8PV/NzICK/nmb1+D0ITDi/so0symJAz1LZ9olgdhKJwwIJLUQLQ3fT/xLxU2dyGGMmS2xb51URZ3xqDfxPb8an1JpULDoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RDQAIpDe; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RDQAIpDe"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 4E941600B9;
	Thu, 30 Apr 2026 18:18:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777565894;
	bh=eHaoXU695hp8Jy8Ock4Y2rXjmS8M48O/AWQ5LFcousM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RDQAIpDej/v4p81StC6XtsVfS9kLxM/949q5hvngU8Hsenfe8sQt1vamECLmRJQCz
	 VuU2enWmtdxbrIootvAJ92UN12EkSkMKgUSF4g4YUhoGyijpBH9rRCRZyNPSY8yKIe
	 w17OG4MrQcGDdGOaf7U+RXXhnZRFGBswjnjIKisfuKVocj/ez6GpGNAkV8znoSAjCE
	 auTZajhR5BNX/OtWU5ImJDBg2ZwgO1UuytJRuuUIPrUTIxFJJOCl3o4nT7RBKKzEp+
	 G+qKSBqfaaKuAWY4ZKOjMwvOMk3CvE84YD3EX/gzMy3Q55DWQGappj6Ym9pfE3f1Ua
	 NKCyDWaxlbxww==
Date: Thu, 30 Apr 2026 18:18:11 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: HACKE-RC <rc@rexion.ai>
Cc: Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] netfilter: conntrack: validate parsed port
 values in IRC and Amanda helpers
Message-ID: <afOAw3V2PAKy1gPJ@chamomile>
References: <20260430161230.3438973-1-rc@rexion.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260430161230.3438973-1-rc@rexion.ai>

On Thu, Apr 30, 2026 at 09:42:28PM +0530, HACKE-RC wrote:
> Both nf_conntrack_irc and nf_conntrack_amanda parse port numbers from
> application-layer protocol data using simple_strtoul(), which returns
> unsigned long. The results are stored in u16 variables without range
> checks, silently truncating values above 65535.
> 
> This series adds explicit upper-bound validation in both helpers.
> 
> Note: checkpatch warns about simple_strtoul being obsolete. Both
> call sites use the endptr output parameter to advance the parse
> position, which kstrtoul does not provide. Converting to kstrtoul
> would require restructuring the parsers, which is out of scope for
> this fix.
> 
> HACKE-RC (2):

HAHA, this nickname is funny, it is making my day here. Thanks!

>   netfilter: nf_conntrack_irc: reject DCC port values above 65535
>   netfilter: nf_conntrack_amanda: reject port values above 65535
> 
>  net/netfilter/nf_conntrack_amanda.c | 10 ++++++----
>  net/netfilter/nf_conntrack_irc.c    |  7 ++++++-
>  2 files changed, 12 insertions(+), 5 deletions(-)
> 
> -- 
> 2.54.0
> 
