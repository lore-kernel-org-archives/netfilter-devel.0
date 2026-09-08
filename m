Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87AA3AFD17;
	Tue,  8 Sep 2026 20:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788899566; cv=none; b=aGcJUJeGkZZm1jI0OmZF/Fp+zjZrov1VsqASZkFgXc4HIUre5QSMR/Ng1+2qqzjPSOXhtMOwawP1hA+BWCPQ9wuKzI1HNg4b8fPTy2X/z8kTpuwkix1CcvkSTNSWyaTVzR8xWg1As6yMwH78njF41Qx+RHht4thqqE/8OTPvvMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788899566; c=relaxed/simple;
	bh=xLvaBK3xHpnvy2JCMFCaNQNgcU78b6QBE7GzP94VEmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyJ+aL8qFKl9iaxVNt7mrpGDXVHsxv4LB2RuOQz8+zVXdV6BOm/Z68oRtql1BXr4rvr7X5LMCr+zxLo3fvBSyQu3SodEVQDsX2/V3KYLcnswp/MlZe/ijCANt2iNwZjt+y8U4Q5kMwLM+TFUNHbfbxiSOuMH/kv6tXQcZaLv2wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gkv5vuS8; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gkv5vuS8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1788899562;
	bh=/fjal4Dx2esK25ZKPADi218K6qmyeSznYUSY/sYGPRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gkv5vuS8kMu7hvQMz3Lr8MJDHOiwb26uYaqrbKg030arj2+pt9M2wRkNkwJU7YRsh
	 Sh+oCeSeQZJKXnan51kELMVWcMCRzIhIVQz2TEZ5+vWKY4pE4aK/mo7nFX8RvO2TrS
	 KkcdyLR0xnisNVj21udwvbcxngqMHD3jq1LuULVWmM2pbYbu8bStV38Jz9bwetlcIV
	 GkXN0lP5NkwM0Q5P0YiKQnBZ2nMIjo4OfS2+mdzVoZ335UFsNLlv8ISNTwfivWdzak
	 WBDXy1a0sOeazz1Nc/Ien+QvTU5BtNQl0YDSFZipPYMqEudMhJdeRp+RuLUrzRe0eE
	 m++Cru54JCZqw==
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 1B0B5606E7;
	Tue,  8 Sep 2026 22:32:42 +0200 (CEST)
Date: Tue, 8 Sep 2026 22:32:39 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netdev-bot+sashiko@kernel.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Subject: Re: [PATCH net 7/9] netfilter: arp_tables: remove the 32bit compat
 interface
Message-ID: <aqBw5ymelxVziuZl@chamomile>
References: <20260907171732.1407739-8-pablo@netfilter.org>
 <178889064289.219967.7333044974025476861@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178889064289.219967.7333044974025476861@kernel.org>

On Tue, Sep 08, 2026 at 06:04:02PM +0000, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue(s) to consider:
> 
> Critical: 0 · High: 0 · Medium: 0 · Low: 1

This rising a lot of issues, because arptables 32bit gets broken.

We can follow up to break it more "nicely", but it is not a big issue.
