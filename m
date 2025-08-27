Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3200313D503
	for <netfilter-devel@vger.kernel.org>; Wed, 27 Aug 2025 20:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756326997; cv=none; b=G67Wro/+eQplF37OSempdL2mDlde7hvkzZ1rIGXk5UBe2lN/6qLgz1jYvIVJEMqnKr4No50nfcNidG4rgQ6jLKf2PSkSV+bCdSQxqTmpEGAZ7myx5U1+oCQzXIeyxB19Cf75EFYgvHGnckaPqzIy2Xt0hz9FfFWiiAd1CT5HjRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756326997; c=relaxed/simple;
	bh=ca0yrPkBluoif21csSEOPO07nuT+iylWIln2P6ZIkQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4JEQEb7j3D+/c6BrTMdomCX7iTTXhpKCuUCSwZhmp9yys3KYMCDgtoKC+9XxbykGvG6sPF2wxfOj1qgQNdXAmh8u0XFjSItlElVnimmjYO2gZl8/fpnh8p9o/eECWdCT1VQDfydmfiiZ32G2V8JnnR/uAE2S4XsqTFfR1dY8UA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u9XwwX3K; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u9XwwX3K; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u9XwwX3K";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u9XwwX3K"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id DF50D60265; Wed, 27 Aug 2025 22:36:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756326991;
	bh=naDSNOtFIOH38YqrshSrG3htWo4cGrCqjz/2XMqdikI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u9XwwX3KfZG6XEDuN0+LL8atuXnJ3HljeT497aHt5MMhbULVc2JEikXsEXt+jhhCR
	 no/JDqy0MeK2RMH0eazSEcpvdK19NNsG6GENxuAhIZs/7u08ETYitOXzfGJviv26p4
	 8/ddHnvfTSm7zoqOEUtRg35TReVnUNGM+bgZTxsiy13p2xb/lTe02yoPHS9orfnHgB
	 qQZBdHO9Gm3uvAMVutIZkybfJ0h8YkGG7WmUO+QkXuTpRXHEyhny9ZDzKFCm5DT6Nd
	 AGHYUsmjf22nAOBWzjY1ErSvhIenxkmHxVwhZMrzo6Gw7lyJxQ+LXrOiyICrOp3kRg
	 gSq5S0IUBgL+w==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 2471460255;
	Wed, 27 Aug 2025 22:36:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1756326991;
	bh=naDSNOtFIOH38YqrshSrG3htWo4cGrCqjz/2XMqdikI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u9XwwX3KfZG6XEDuN0+LL8atuXnJ3HljeT497aHt5MMhbULVc2JEikXsEXt+jhhCR
	 no/JDqy0MeK2RMH0eazSEcpvdK19NNsG6GENxuAhIZs/7u08ETYitOXzfGJviv26p4
	 8/ddHnvfTSm7zoqOEUtRg35TReVnUNGM+bgZTxsiy13p2xb/lTe02yoPHS9orfnHgB
	 qQZBdHO9Gm3uvAMVutIZkybfJ0h8YkGG7WmUO+QkXuTpRXHEyhny9ZDzKFCm5DT6Nd
	 AGHYUsmjf22nAOBWzjY1ErSvhIenxkmHxVwhZMrzo6Gw7lyJxQ+LXrOiyICrOp3kRg
	 gSq5S0IUBgL+w==
Date: Wed, 27 Aug 2025 22:36:28 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: jengelh@inai.de, phil@nwl.cc
Subject: Re: [PATCH nft] build: disable --with-unitdir by default
Message-ID: <aK9sTON-SEjCEkLb@calendula>
References: <20250827140214.645245-1-pablo@netfilter.org>
 <aK8aN4h2XsLnTdT6@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aK8aN4h2XsLnTdT6@calendula>

On Wed, Aug 27, 2025 at 04:46:17PM +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> Cc'ing Phil, Jan.
> 
> Excuse me my terse proposal description.
> 
> Extension: This is an alternative patch to disable --with-unitdir by
> default, to address distcheck issue.
> 
> I wonder also if this is a more conservative approach, this should
> integrate more seamlessly into existing pipelines while allowing
> distributors to opt-in to use this.
> 
> But maybe I'm worrying too much and it is just fine to change defaults
> for downstream packagers.

I'm going to proceed with this approach to release nftables 1.1.5,
if there is a need to refine, please just follow up.

Thanks.
